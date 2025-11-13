# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Capacitor plugin (`@sixmon/capacitor-document-scanner`) that provides document scanning functionality for iOS and Android using native platform features. The plugin bridges JavaScript/TypeScript code with native implementations using Google ML Kit on Android and native iOS APIs.

## Commands

### Build and Development
- `npm run build` - Compile TypeScript to ESM (dist/esm/), bundle with Rollup (dist/plugin.js), and generate API docs
- `npm run clean` - Remove the dist directory
- `npm run watch` - Watch TypeScript files for changes
- `npm run docgen` - Generate API documentation from JSDoc comments (updates README.md)

### Verification (CI/Testing)
- `npm run verify` - Build and validate all platforms (iOS, Android, web)
- `npm run verify:ios` - Install pods and build iOS plugin in Xcode
- `npm run verify:android` - Build and test Android plugin with Gradle
- `npm run verify:web` - Build web assets only

### Code Quality
- `npm run lint` - Run ESLint, Prettier check, and SwiftLint
- `npm run fmt` - Auto-fix with ESLint, format with Prettier, and fix SwiftLint issues
- `npm run eslint` - Run ESLint on TypeScript files
- `npm run prettier` - Check formatting for CSS, HTML, TS, JS, Java files
- `npm run swiftlint` - Run SwiftLint on iOS code

### Publishing
- `npm publish` - Build and publish to npm (prepublishOnly hook runs build automatically)

## Architecture

### Plugin Structure

This follows the standard Capacitor plugin architecture with three layers:

1. **TypeScript Layer** (`src/`)
   - `definitions.ts` - TypeScript interfaces, enums, and type definitions for the plugin API
   - `index.ts` - Plugin registration using Capacitor's `registerPlugin()` function
   - `web.ts` - Stub implementation for web platform (throws unimplemented error)

2. **Native Android Layer** (`android/`)
   - `DocumentScannerPlugin.java` - Main plugin class that uses Google ML Kit Document Scanner API
   - Implements document scanning with configurable options (scanner mode, page limit, quality, response type)
   - Handles activity results and processes scanned images (converts to base64 or file paths)
   - Uses `@CapacitorPlugin` annotation with request code 9999

3. **Native iOS Layer** (`ios/`)
   - `DocumentScannerPlugin.swift` - iOS plugin implementation (currently returns cancel status only)
   - Requires `NSCameraUsageDescription` in Info.plist
   - Declared in `SixmonCapacitorDocumentScanner.podspec`

### Key Concepts

**Capacitor Plugin Bridge**: The plugin uses Capacitor's bridge to communicate between JavaScript and native code. The `registerPlugin()` call in `index.ts` creates a proxy that routes method calls to the appropriate native implementation.

**Response Types**: The plugin supports two response formats:
- `imageFilePath` (default) - Returns Capacitor-compatible file URIs that can be displayed in WebViews
- `base64` - Returns base64-encoded image strings

**Scanner Modes** (Android only via ML Kit):
- `FULL` - Complete scanner with detection, cropping, and filters
- `BASE` - Basic scanner with detection and cropping only
- `BASE_WITH_FILTER` - Basic scanner with detection, cropping, and filters

**Android Implementation Details**:
- Uses Google ML Kit Document Scanner (`com.google.mlkit.vision.documentscanner`)
- Stores scanned images in app's external files directory (no permissions required)
- Handles activity results through `handleOnActivityResult()` with request code 9999
- Converts URIs to Capacitor-compatible format using `getBridge().getLocalUrl()`

**iOS Implementation Status**: The iOS implementation currently returns a cancel status immediately. Full iOS implementation using VNDocumentCameraViewController or similar would be needed for production use.

## Development Notes

### Building Native Code
- Android: Changes to Java code require running `npm run verify:android` or building in Android Studio
- iOS: Changes to Swift code require running `npm run verify:ios` or building in Xcode (requires macOS)
- Both platforms: The native implementations are compiled separately from the TypeScript bridge code

### Documentation Generation
The `npm run docgen` command uses `@capacitor/docgen` to generate API documentation from JSDoc comments in `definitions.ts`. It automatically updates the API section in README.md.

### iOS Requirements
- iOS 13.0+ (specified in .podspec)
- Swift 5.1+
- SwiftLint must be installed via Homebrew on macOS for linting
- Camera usage description must be added to consuming app's Info.plist

### Android Requirements
- Min SDK 22, Target SDK 33
- Gradle 8.0.0
- Java 17 source/target compatibility
- Google ML Kit Document Scanner 16.0.0-beta1

### File Publishing
The `files` array in package.json controls what gets published to npm. When adding new files/directories, update this array to ensure they're included in the published package.
