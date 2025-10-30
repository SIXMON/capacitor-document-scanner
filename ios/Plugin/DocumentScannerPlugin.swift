import Foundation
import Capacitor
import VisionKit

/**
 * This class contains functions that get called when
 * you use the DocumentScanner JavaScript functions
 */
@available(iOS 13.0, *)
@objc(DocumentScannerPlugin)
public class DocumentScannerPlugin: CAPPlugin {
    private var scanner: DocScanner?
    
    /**
     * No implementation at the moment
     *
     * @param  call contains JS inputs and lets you return results
     */
    @objc func scanDocument(_ call: CAPPluginCall) {
        let responseType = call.getString("responseType")

        let scanner = DocScanner(plugin: self)
        self.scanner = scanner
        scanner.start(call: call, responseType: responseType)
    }
}