# iOS Document Scanner Implementation

## Overview

This iOS implementation uses Apple's **VisionKit** framework to provide native document scanning capabilities. The implementation leverages `VNDocumentCameraViewController`, which provides a polished, full-featured document scanning experience.

## Features

✅ **Native VisionKit Integration**: Uses Apple's built-in document scanner with automatic edge detection
✅ **Multi-page Scanning**: Supports scanning multiple pages in a single session
✅ **Automatic Image Enhancement**: VisionKit automatically applies perspective correction and image enhancement
✅ **Two Response Formats**: 
  - **Base64**: Returns images as base64-encoded strings
  - **File Path**: Saves images to temporary directory and returns file paths
✅ **User-friendly UI**: Native iOS document scanner interface with automatic corner detection
✅ **iOS 13.0+**: Compatible with iOS 13.0 and later

## Technical Details

### Architecture

```
DocumentScannerPlugin.swift (Capacitor Bridge)
    ↓
DocScanner.swift (VisionKit Wrapper)
    ↓
VNDocumentCameraViewController (Apple's Native Scanner)
```

### Key Components

1. **DocumentScannerPlugin.swift**: 
   - Capacitor plugin interface
   - Receives JavaScript calls from the web layer
   - Passes configuration to DocScanner

2. **DocScanner.swift**:
   - Implements `VNDocumentCameraViewControllerDelegate`
   - Manages document scanning lifecycle
   - Processes scanned images (base64 or file path)
   - Handles success, error, and cancel scenarios

### VisionKit Features Used

- **VNDocumentCameraViewController**: The main document scanning interface
  - Automatic document edge detection
  - Real-time perspective correction
  - Manual corner adjustment
  - Auto and manual capture modes
  - Flash control
  - Multi-page scanning

### Image Processing

#### Base64 Mode
```swift
image.jpegData(compressionQuality: 1.0)
  → Base64 encoding
  → Return string
```

#### File Path Mode
```swift
image.jpegData(compressionQuality: 1.0)
  → Save to temporary directory
  → Return file path
```

## Requirements

- **iOS Version**: 13.0 or later
- **Device**: VisionKit requires a physical device (not available in simulator)
- **Camera Permission**: Automatically handled by VisionKit

## API Support

### Supported Options

| Option | Support | Notes |
|--------|---------|-------|
| `responseType` | ✅ Full | Both `base64` and `imageFilePath` supported |
| `maxNumDocuments` | ⚠️ Partial | VisionKit allows unlimited pages (Android-only option) |
| `scannerMode` | ⚠️ N/A | VisionKit has a single mode (Android-only option) |
| `letUserAdjustCrop` | ✅ Built-in | VisionKit always allows manual corner adjustment |
| `croppedImageQuality` | ⚠️ N/A | iOS uses maximum quality (Android-only option) |

### Response Format

**Success:**
```json
{
  "status": "success",
  "scannedImages": ["base64string..." or "/path/to/file.jpg"]
}
```

**Cancel:**
```json
{
  "status": "cancel"
}
```

**Error:**
```json
{
  "error": "Error message"
}
```

## Usage Example

```typescript
import { DocumentScanner, ResponseType } from '@sixmon/capacitor-document-scanner';

const result = await DocumentScanner.scanDocument({
  responseType: ResponseType.Base64
});

if (result.status === 'success') {
  console.log('Scanned images:', result.scannedImages);
}
```

## Testing

### Device Testing
VisionKit requires a physical iOS device. The document scanner will not work in the iOS Simulator.

### Test Checklist
- ✅ Launch scanner
- ✅ Scan single page
- ✅ Scan multiple pages
- ✅ Cancel operation
- ✅ Test base64 response
- ✅ Test file path response
- ✅ Verify image quality
- ✅ Test error handling

## Troubleshooting

### Common Issues

**1. "Document scanning is not supported on this device"**
- Solution: VisionKit requires iOS 13.0+ and a physical device (not simulator)

**2. Scanner doesn't appear**
- Check that the view controller is available
- Verify iOS version is 13.0+
- Ensure app is running on a physical device

**3. Images not saving**
- Check app has write permissions to temporary directory
- Verify disk space is available

## Performance Considerations

- **Memory**: VisionKit handles memory management efficiently
- **Image Quality**: JPEG compression set to 1.0 (maximum quality)
- **Storage**: Images saved to temporary directory (automatically cleaned by iOS)
- **Processing**: Image processing happens on background threads when possible

## Future Enhancements

Potential improvements:
- [ ] Custom image quality/compression settings
- [ ] PDF generation from scanned pages
- [ ] Custom save location
- [ ] Image filtering options
- [ ] OCR text extraction (using VisionKit's text recognition)

## Implementation Notes

### Thread Safety
- UI operations dispatched to main thread
- Image processing can happen on background threads
- Delegates called on main thread by VisionKit

### Memory Management
- Uses weak references to prevent retain cycles
- Properly cleans up view controller references
- Images processed and released promptly

### Error Handling
- Comprehensive error messages
- Graceful degradation
- User-friendly error reporting

## Resources

- [VisionKit Documentation](https://developer.apple.com/documentation/visionkit)
- [VNDocumentCameraViewController](https://developer.apple.com/documentation/visionkit/vndocumentcameraviewcontroller)
- [Capacitor iOS Plugin Guide](https://capacitorjs.com/docs/plugins/ios)

## License

See main project LICENSE file.

