import Foundation
import Capacitor

/**
 * This class contains functions that get called when
 * you use the DocumentScanner JavaScript functions
 */
@available(iOS 13.0, *)
@objc(DocumentScannerPlugin)
public class DocumentScannerPlugin: CAPPlugin {
    
    /**
     * No implementation at the moment
     *
     * @param  call contains JS inputs and lets you return results
     */
    @objc func scanDocument(_ call: CAPPluginCall) {
        // launch the document scanner
        call.resolve([
            "status": "cancel"
        ])
    }
}