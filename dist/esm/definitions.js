export var ResponseType;
(function (ResponseType) {
    /**
     * Use this response type if you want document scan returned as base64 images.
     */
    ResponseType["Base64"] = "base64";
    /**
     * Use this response type if you want document scan returned as image file paths.
     */
    ResponseType["ImageFilePath"] = "imageFilePath";
})(ResponseType || (ResponseType = {}));
export var ScannerMode;
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
})(ScannerMode || (ScannerMode = {}));
export var ScanDocumentResponseStatus;
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
})(ScanDocumentResponseStatus || (ScanDocumentResponseStatus = {}));
//# sourceMappingURL=definitions.js.map