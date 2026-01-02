var capacitorDocumentScanner = (function (exports, core) {
    'use strict';

    exports.ResponseType = void 0;
    (function (ResponseType) {
        /**
         * Use this response type if you want document scan returned as base64 images.
         */
        ResponseType["Base64"] = "base64";
        /**
         * Use this response type if you want document scan returned as image file paths.
         */
        ResponseType["ImageFilePath"] = "imageFilePath";
    })(exports.ResponseType || (exports.ResponseType = {}));
    exports.ScannerMode = void 0;
    (function (ScannerMode) {
        /**
         * Full featured scanner with document detection, cropping, and filters.
         * This mode provides the best user experience with all features enabled.
         */
        ScannerMode["FULL"] = "FULL";
        /**
         * Basic scanner with document detection and cropping only.
         * This mode is faster and uses less resources.
         */
        ScannerMode["BASE"] = "BASE";
        /**
         * Basic scanner with document detection, cropping, and filters.
         * This mode provides filters without the full feature set.
         */
        ScannerMode["BASE_WITH_FILTER"] = "BASE_WITH_FILTER";
    })(exports.ScannerMode || (exports.ScannerMode = {}));
    exports.ScanDocumentResponseStatus = void 0;
    (function (ScanDocumentResponseStatus) {
        /**
         * The status comes back as success if the document scan completes
         * successfully.
         */
        ScanDocumentResponseStatus["Success"] = "success";
        /**
         * The status comes back as cancel if the user closes out of the camera
         * before completing the document scan.
         */
        ScanDocumentResponseStatus["Cancel"] = "cancel";
    })(exports.ScanDocumentResponseStatus || (exports.ScanDocumentResponseStatus = {}));

    const DocumentScanner = core.registerPlugin('DocumentScanner', {
        web: () => Promise.resolve().then(function () { return web; }).then(m => new m.DocumentScannerWeb()),
    });

    class DocumentScannerWeb extends core.WebPlugin {
        async scanDocument(options) {
            console.log('=== DocumentScannerWeb.scanDocument called ===');
            console.log('Options received:', options);
            console.log('Options type:', typeof options);
            if (options) {
                console.log('Options keys:', Object.keys(options));
                console.log('maxNumDocuments:', options.maxNumDocuments);
                console.log('scannerMode:', options.scannerMode);
                console.log('responseType:', options.responseType);
                console.log('letUserAdjustCrop:', options.letUserAdjustCrop);
                console.log('croppedImageQuality:', options.croppedImageQuality);
            }
            console.log('Throwing unimplemented error for web platform');
            throw this.unimplemented('Not implemented on web.');
        }
    }

    var web = /*#__PURE__*/Object.freeze({
        __proto__: null,
        DocumentScannerWeb: DocumentScannerWeb
    });

    exports.DocumentScanner = DocumentScanner;

    return exports;

})({}, capacitorExports);
//# sourceMappingURL=plugin.js.map
