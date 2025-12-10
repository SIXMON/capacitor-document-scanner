import Foundation
import Capacitor
import VisionKit

/**
 * This class contains functions that get called when
 * you use the DocumentScanner JavaScript functions
 */
@available(iOS 13.0, *)
@objc(DocumentScannerPlugin)
public class DocumentScannerPlugin: CAPPlugin, VNDocumentCameraViewControllerDelegate {

    // Response type constants
    private let RESPONSE_TYPE_IMAGE_FILE_PATH = "imageFilePath"
    private let RESPONSE_TYPE_BASE64 = "base64"

    // Store parameters for use in delegate callbacks
    private var savedCall: CAPPluginCall?
    private var currentResponseType: String = "imageFilePath"
    private var currentQuality: Int = 100

    /**
     * Opens the document scanner camera
     *
     * @param  call contains JS inputs and lets you return results
     */
    @objc func scanDocument(_ call: CAPPluginCall) {
        // Get configuration options from the call
        let responseType = call.getString("responseType") ?? RESPONSE_TYPE_IMAGE_FILE_PATH
        let quality = call.getInt("croppedImageQuality") ?? 100

        // Store parameters for use in delegate callbacks
        self.currentResponseType = responseType
        self.currentQuality = quality
        self.savedCall = call

        // Check if VisionKit is available
        guard #available(iOS 13.0, *) else {
            call.reject("Document scanning requires iOS 13.0 or later")
            return
        }

        // Create and present the document camera
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            let documentCameraViewController = VNDocumentCameraViewController()
            documentCameraViewController.delegate = self

            self.bridge?.viewController?.present(documentCameraViewController, animated: true, completion: nil)
        }
    }

    // MARK: - VNDocumentCameraViewControllerDelegate

    /**
     * Called when the user successfully scans one or more documents
     */
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true, completion: nil)

        guard let call = savedCall else {
            return
        }

        var scannedImages: [String] = []

        // Process each scanned page
        for pageIndex in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: pageIndex)

            if currentResponseType == RESPONSE_TYPE_BASE64 {
                // Convert to base64
                if let base64String = convertImageToBase64(image, quality: currentQuality) {
                    scannedImages.append(base64String)
                }
            } else {
                // Save to file and return file path
                if let filePath = saveImageToDocumentsDirectory(image) {
                    scannedImages.append(filePath)
                }
            }
        }

        // Build response
        if scannedImages.isEmpty {
            call.reject("Failed to process scanned images")
        } else {
            call.resolve([
                "scannedImages": scannedImages,
                "status": "success"
            ])
        }

        savedCall = nil
    }

    /**
     * Called when the user cancels the document scan
     */
    public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true, completion: nil)

        guard let call = savedCall else {
            return
        }

        call.resolve([
            "status": "cancel"
        ])

        savedCall = nil
    }

    /**
     * Called when an error occurs during scanning
     */
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true, completion: nil)

        guard let call = savedCall else {
            return
        }

        call.reject("Document scanning failed: \(error.localizedDescription)")
        savedCall = nil
    }

    // MARK: - Helper Methods

    /**
     * Save a UIImage to the app's documents directory
     *
     * @param image The image to save
     * @return The file:// URL string, or nil if saving failed
     */
    private func saveImageToDocumentsDirectory(_ image: UIImage) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        let fileName = "scanned_\(Int(Date().timeIntervalSince1970 * 1000)).jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        // Convert image to JPEG data with quality
        let quality = CGFloat(currentQuality) / 100.0
        guard let imageData = image.jpegData(compressionQuality: quality) else {
            return nil
        }

        do {
            try imageData.write(to: fileURL)
            return fileURL.absoluteString
        } catch {
            print("Error saving image: \(error.localizedDescription)")
            return nil
        }
    }

    /**
     * Convert a UIImage to base64 string
     *
     * @param image The image to convert
     * @param quality JPEG quality from 0-100
     * @return The base64 encoded string, or nil if conversion failed
     */
    private func convertImageToBase64(_ image: UIImage, quality: Int) -> String? {
        let compressionQuality = CGFloat(quality) / 100.0
        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }

        return imageData.base64EncodedString()
    }
}