# Capacitor Document Scanner

This is a Capacitor plugin that lets you scan documents using Android and iOS. You can use it to create
apps that let users scan notes, homework, business cards, receipts, or anything with a rectangular shape.

This work is a replacement for https://github.com/WebsiteBeaver/capacitor-document-scanner/tree/master using nowadays native scanner implementations.

## Install

```bash
npm install @sixmon/capacitor-document-scanner
npx cap sync
```

## Examples

* [Basic Example](#basic-example)
* [Limit Number of Scans](#limit-number-of-scans)
* [Remove Cropper](#remove-cropper)

### Basic Example

```typescript
import { Capacitor } from '@capacitor/core'
import { DocumentScanner } from '@sixmon/capacitor-document-scanner'

const scanDocument = async () => {
  // start the document scanner
  const { scannedImages } = await DocumentScanner.scanDocument()

  // get back an array with scanned image file paths
  if (scannedImages.length > 0) {
    // set the img src, so we can view the first scanned image
    const scannedImage = document.getElementById('scannedImage') as HTMLImageElement
    scannedImage.src = Capacitor.convertFileSrc(scannedImages[0])
  }
}
```

### Limit Number of Scans (Android ONLY)

You can limit the number of scans. For example if your app lets a user scan a business 
card you might want them to only capture the front and back. In this case you can set
maxNumDocuments to 2.

```typescript
import { Capacitor } from '@capacitor/core'
import { DocumentScanner } from '@sixmon/capacitor-document-scanner'

const scanDocument = async () => {
  // limit the number of scans to 2
  const { scannedImages } = await DocumentScanner.scanDocument({
    maxNumDocuments: 2
  })

  // get back an array with scanned image file paths
  if (scannedImages.length > 0) {
    // set the img src, so we can view the first scanned image
    const scannedImage = document.getElementById('scannedImage') as HTMLImageElement
    scannedImage.src = Capacitor.convertFileSrc(scannedImages[0])
  }
}
```

### Remove Cropper (Android ONLY)

You can automatically accept the detected document corners, and prevent the user from 
making adjustments. Set letUserAdjustCrop to false to skip the crop screen. This limits
the max number of scans to 1.

```typescript
import { Capacitor } from '@capacitor/core'
import { DocumentScanner } from '@sixmon/capacitor-document-scanner'

const scanDocument = async () => {
  // skip the crop screen
  const { scannedImages } = await DocumentScanner.scanDocument({
    letUserAdjustCrop: false
  })

  // get back an array with scanned image file paths
  if (scannedImages.length > 0) {
    // set the img src, so we can view the first scanned image
    const scannedImage = document.getElementById('scannedImage') as HTMLImageElement
    scannedImage.src = Capacitor.convertFileSrc(scannedImages[0])
  }
}
```

## iOS Requirements

iOS requires the following usage description be added and filled out for your app in `Info.plist`:

- `NSCameraUsageDescription` (`Privacy - Camera Usage Description`)

Read about [Configuring `Info.plist`](https://capacitorjs.com/docs/ios/configuration#configuring-infoplist) in the [iOS Guide](https://capacitorjs.com/docs/ios) for more information on setting iOS permissions in Xcode

## Documentation

<docgen-index>

* [`scanDocument(...)`](#scandocument)
* [Interfaces](#interfaces)
* [Enums](#enums)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### scanDocument(...)

```typescript
scanDocument(options?: ScanDocumentOptions | undefined) => Promise<ScanDocumentResponse>
```

Opens the camera, and starts the document scan

| Param         | Type                                                                |
| ------------- | ------------------------------------------------------------------- |
| **`options`** | <code><a href="#scandocumentoptions">ScanDocumentOptions</a></code> |

**Returns:** <code>Promise&lt;<a href="#scandocumentresponse">ScanDocumentResponse</a>&gt;</code>

--------------------


### Interfaces


#### ScanDocumentResponse

| Prop                | Type                                                                              | Description                                                                                                                       |
| ------------------- | --------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| **`scannedImages`** | <code>string[]</code>                                                             | This is an array with either file paths or base64 images for the document scan.                                                   |
| **`status`**        | <code><a href="#scandocumentresponsestatus">ScanDocumentResponseStatus</a></code> | The status lets you know if the document scan completes successfully, or if the user cancels before completing the document scan. |


#### ScanDocumentOptions

| Prop                      | Type                                                  | Description                                                                                                                                                                                                                                                                                                                               | Default                                   |
| ------------------------- | ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| **`croppedImageQuality`** | <code>number</code>                                   | Android only: The quality of the cropped image from 0 - 100. 100 is the best quality.                                                                                                                                                                                                                                                     | <code>: 100</code>                        |
| **`letUserAdjustCrop`**   | <code>boolean</code>                                  | Android only: If true then once the user takes a photo, they get to preview the automatically detected document corners. They can then move the corners in case there needs to be an adjustment. If false then the user can't adjust the corners, and the user can only take 1 photo (maxNumDocuments can't be more than 1 in this case). | <code>: true</code>                       |
| **`maxNumDocuments`**     | <code>number</code>                                   | Android only: The maximum number of photos an user can take (not counting photo retakes)                                                                                                                                                                                                                                                  | <code>: 24</code>                         |
| **`responseType`**        | <code><a href="#responsetype">ResponseType</a></code> | The response comes back in this format on success. It can be the document scan image file paths or base64 images.                                                                                                                                                                                                                         | <code>: ResponseType.ImageFilePath</code> |
| **`scannerMode`**         | <code><a href="#scannermode">ScannerMode</a></code>   | Android only (ML Kit): The scanner mode to use. - FULL: Full featured scanner with document detection, cropping, and filters - BASE: Basic scanner with document detection and cropping - BASE_WITH_FILTER: Basic scanner with document detection, cropping, and filters                                                                  | <code>: ScannerMode.FULL</code>           |


### Enums


#### ScanDocumentResponseStatus

| Members       | Value                  | Description                                                                                               |
| ------------- | ---------------------- | --------------------------------------------------------------------------------------------------------- |
| **`Success`** | <code>'success'</code> | The status comes back as success if the document scan completes successfully.                             |
| **`Cancel`**  | <code>'cancel'</code>  | The status comes back as cancel if the user closes out of the camera before completing the document scan. |


#### ResponseType

| Members             | Value                        | Description                                                                    |
| ------------------- | ---------------------------- | ------------------------------------------------------------------------------ |
| **`Base64`**        | <code>'base64'</code>        | Use this response type if you want document scan returned as base64 images.    |
| **`ImageFilePath`** | <code>'imageFilePath'</code> | Use this response type if you want document scan returned as image file paths. |


#### ScannerMode

| Members                | Value                           | Description                                                                                                                                  |
| ---------------------- | ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| **`FULL`**             | <code>'FULL'</code>             | Full featured scanner with document detection, cropping, and filters. This mode provides the best user experience with all features enabled. |
| **`BASE`**             | <code>'BASE'</code>             | Basic scanner with document detection and cropping only. This mode is faster and uses less resources.                                        |
| **`BASE_WITH_FILTER`** | <code>'BASE_WITH_FILTER'</code> | Basic scanner with document detection, cropping, and filters. This mode provides filters without the full feature set.                       |

</docgen-api>

## License

Copyright 2025 Sixmon

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.