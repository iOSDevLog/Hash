# Hash
---

[简体中文](README_CN.md)

A concise and efficient macOS hash calculation tool that supports multiple hash algorithms and batch file processing.

## Features

- 🔐 **Multiple Hash Algorithm Support**: MD5, SHA-1, CRC32
- 📁 **Batch File Processing**: Calculate hash values for multiple files simultaneously
- 🎯 **Drag & Drop Operation**: Simply drag files to the application window to start calculation
- 📋 **One-Click Copy**: Click to copy hash values to clipboard
- 📊 **File Information Display**: Shows file size, version info, modification date, etc.
- 🌍 **Multilingual Support**: Supports 22 languages including Chinese, English, Japanese, Korean, German, French, Spanish, Russian, Arabic, etc.
- 🎨 **Modern Interface**: Native macOS app built with SwiftUI
- ⚡ **High Performance Computing**: Asynchronous processing with support for large files

## Screenshots

![Hash Application Interface](Screenshots/hash.png)

*Main interface of the Hash application, showcasing file selection, hash calculation, and result display features*

## System Requirements

- macOS 11.0 or later
- Xcode 13.0 or later (for development)

## Installation

### Build from Source

1. Clone the repository:
```bash
git clone https://github.com/iOSDevLog/Hash
cd Hash
```

2. Open the project with Xcode:
```bash
open Hash.xcodeproj
```

3. Build and run the project in Xcode (⌘+R)

## Usage

### Basic Operations

1. **Launch the Application**: Double-click the app icon or launch from Launchpad

2. **Add Files**:
   - Click the "Select Files" button to choose files
   - Or drag files directly to the application window

3. **Select Hash Algorithm**:
   - Check the desired hash algorithms in the right panel
   - Supports MD5, SHA-1, CRC32

4. **Start Calculation**:
   - Click the "Start Calculation" button
   - Or calculation starts automatically after adding files

5. **Copy Results**:
   - Click any hash value to copy to clipboard
   - Supports copying individual hash values or all results

### Advanced Features

- **Batch Processing**: Add multiple files for simultaneous batch calculation
- **Progress Display**: Real-time calculation progress display
- **File Management**: Support for clearing individual files or all files
- **Result Export**: Copy all calculation results

## Technical Architecture

### Core Technologies

- **SwiftUI**: Modern user interface framework
- **CryptoKit**: Apple's official cryptographic framework for SHA-1 calculation
- **Foundation**: For MD5 and file operations
- **UniformTypeIdentifiers**: File type identification

### Project Structure

```
Hash/
├── Hash/
│   ├── ContentView.swift          # Main interface view
│   ├── HashApp.swift              # Application entry point
│   ├── Assets.xcassets/           # Application resources
│   │   └── AppIcon.appiconset/    # Application icon
│   ├── Hash.entitlements          # Application permissions
│   └── *.lproj/                   # Multilingual localization files
├── HashTests/                     # Unit tests
└── HashUITests/                   # UI tests
```

### Hash Algorithm Implementation

- **MD5**: Implemented using CommonCrypto framework
- **SHA-1**: Implemented using CryptoKit framework
- **CRC32**: Custom implementation using standard CRC32 polynomial

## Development

### Environment Setup

1. Install Xcode 13.0 or later
2. Ensure macOS version is 11.0 or later
3. Clone the project and open in Xcode

### Build Project

```bash
# Build using Xcode command line tools
xcodebuild -project Hash.xcodeproj -scheme Hash -configuration Debug build

# Or use shortcut ⌘+B in Xcode
```

### Run Tests

```bash
# Run unit tests
xcodebuild test -project Hash.xcodeproj -scheme Hash -destination 'platform=macOS'

# Or use shortcut ⌘+U in Xcode
```

## Localization

The application supports the following 22 languages:

### Asian Languages
- 🇨🇳 中文（简体）(Chinese Simplified)
- 🇹🇼 中文（繁体）(Chinese Traditional)
- 🇯🇵 日本語 (Japanese)
- 🇰🇷 한국어 (Korean)
- 🇹🇭 ไทย (Thai)
- 🇻🇳 Tiếng Việt (Vietnamese)
- 🇮🇳 हिन्दी (Hindi)
- 🇮🇩 Bahasa Indonesia (Indonesian)
- 🇲🇾 Bahasa Melayu (Malay)

### European Languages
- 🇺🇸 English
- 🇩🇪 Deutsch (German)
- 🇫🇷 Français (French)
- 🇪🇸 Español (Spanish)
- 🇮🇹 Italiano (Italian)
- 🇵🇹 Português (Portuguese)
- 🇳🇱 Nederlands (Dutch)
- 🇸🇪 Svenska (Swedish)
- 🇳🇴 Norsk (Norwegian)
- 🇩🇰 Dansk (Danish)
- 🇫🇮 Suomi (Finnish)
- 🇵🇱 Polski (Polish)
- 🇨🇿 Čeština (Czech)
- 🇭🇺 Magyar (Hungarian)
- 🇬🇷 Ελληνικά (Greek)
- 🇹🇷 Türkçe (Turkish)
- 🇺🇦 Українська (Ukrainian)
- 🇷🇴 Română (Romanian)
- 🇧🇬 Български (Bulgarian)
- 🇸🇰 Slovenčina (Slovak)
- 🇸🇮 Slovenščina (Slovenian)
- 🇭🇷 Hrvatski (Croatian)
- 🇷🇸 Српски (Serbian)
- 🇷🇺 Русский (Russian)

### Middle Eastern Languages
- 🇸🇦 العربية (Arabic)
- 🇮🇱 עברית (Hebrew)

### Adding New Languages

1. Select the project in Xcode
2. Add a new language in the "Localizations" section
3. Translate the strings in the `Localizable.strings` file

## Contributing

Issues and Pull Requests are welcome!

### Contribution Guidelines

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

### v1.0.0
- ✨ Initial release
- 🔐 Support for MD5, SHA-1, CRC32 hash algorithms
- 📁 Support for batch file processing
- 🎯 Support for drag & drop operations
- 🌍 Support for multilingual interface
- 🎨 Modern SwiftUI interface

## Contact

For questions or suggestions, please contact us through:

- Submit Issues: [GitHub Issues](https://github.com/iOSDevLog/Hash/issues)
- Project Homepage: [GitHub Repository](https://github.com/iOSDevLog/Hash)

---

**Hash** - Making file hash calculation simple and efficient 🚀