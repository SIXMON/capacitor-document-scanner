import Foundation
import UIKit
import VisionKit
import Capacitor

@available(iOS 13.0, *)
class DocScanner: NSObject, VNDocumentCameraViewControllerDelegate {
    enum OutputType {
        case base64
        case imageFilePath

        static func from(_ value: String?) -> OutputType {
            guard let lowercased = value?.lowercased() else { return .imageFilePath }
            if lowercased == "base64" { return .base64 }
            return .imageFilePath
        }
    }

    private weak var plugin: CAPPlugin?
    private var call: CAPPluginCall?
    private var outputType: OutputType = .imageFilePath

    init(plugin: CAPPlugin) {
        self.plugin = plugin
        super.init()
    }

    func start(call: CAPPluginCall, responseType: String?) {
        self.call = call
        self.outputType = OutputType.from(responseType)

        guard VNDocumentCameraViewController.isSupported else {
            call.reject("Document scanning is not supported on this device")
            return
        }

        guard let presentingVC = plugin?.bridge?.viewController else {
            call.reject("No view controller available to present scanner")
            return
        }

        let scannerVC = VNDocumentCameraViewController()
        scannerVC.delegate = self

        DispatchQueue.main.async { [weak presentingVC] in
            presentingVC?.present(scannerVC, animated: true, completion: nil)
        }
    }

    // MARK: - VNDocumentCameraViewControllerDelegate

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true) { [weak self] in
            self?.call?.resolve([
                "status": "cancel"
            ])
            self?.cleanup()
        }
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true) { [weak self] in
            self?.call?.reject("Document scanning failed: \(error.localizedDescription)")
            self?.cleanup()
        }
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let numPages = scan.pageCount
        var results: [String] = []

        for index in 0..<numPages {
            let image = scan.imageOfPage(at: index)

            guard let jpegData = image.jpegData(compressionQuality: 1.0) else { continue }

            switch outputType {
            case .base64:
                let base64String = jpegData.base64EncodedString()
                results.append(base64String)
            case .imageFilePath:
                if let filePath = saveImageToTemporaryDirectory(data: jpegData) {
                    results.append(filePath)
                }
            }
        }

        controller.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            guard !results.isEmpty else {
                self.call?.reject("Failed to process scanned images")
                self.cleanup()
                return
            }

            self.call?.resolve([
                "status": "success",
                "scannedImages": results
            ])
            self.cleanup()
        }
    }

    // MARK: - Helpers

    private func saveImageToTemporaryDirectory(data: Data) -> String? {
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let fileName = "scanned_\(Int(Date().timeIntervalSince1970))_\(UUID().uuidString).jpg"
        let fileURL = tempDir.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            return nil
        }
    }

    private func cleanup() {
        self.call = nil
    }
}


