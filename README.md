# ATAK CIV SDK Collection

This repository contains multiple versions of the Android Team Awareness Kit (ATAK) CIV SDK, organized for efficient development and DBSDK CI integration.

## Repository Structure

This repository uses a **versioned folder approach** where each SDK release is contained in its own directory:

```
atak-civ/
├── .devcontainer/                    # Base devcontainer template
│   └── devcontainer.json
├── ATAK-CIV-5.3.0.12-SDK/            # SDK v5.3.0.12 (Foundation)
│   ├── .devcontainer/
│   │   └── devcontainer.json
│   └── [SDK files...]
├── ATAK-CIV-5.4.0.21-SDK/            # SDK v5.4.0.21
│   ├── .devcontainer/
│   │   └── devcontainer.json
│   └── [SDK files...]
├── ATAK-CIV-5.5.0.5-SDK/             # SDK v5.5.0.5 (Latest)
│   ├── .devcontainer/
│   │   └── devcontainer.json
│   └── [SDK files...]
└── README.md                         # This file
```

## Version Management

### Linear Git History
- **release-5.3.0**: Foundation branch (SDK 5.3.0.12)
- **release-5.4.0**: Built FROM 5.3.0 + SDK 5.4.0.21 additions
- **release-5.5.0**: Built FROM 5.4.0 + SDK 5.5.0.5 additions (default branch)
- **main**: Contains ALL releases simultaneously for DBSDK CI integration

### Pull Request Workflow
Create PRs to show version progression:
1. `release-5.3.0` → `release-5.4.0` (shows 5.4.0 changes)
2. `release-5.4.0` → `release-5.5.0` (shows 5.5.0 changes)

## Development Environment

### Prerequisites

**Required Tools:**
- **Adoptium Java JDK 11** (DO NOT USE ORACLE)
- **Git 2.34.1** or later
- **Git Large File Storage (LFS) 3.0.2** or later
- **Android Studio Dolphin** or later

**System Requirements:**
- **Android API 21** or later (for physical devices)
- **VM Configuration**: 512 MB heap, 2048 MB internal storage (for emulators)

### Quick Start with Devcontainers

Each SDK version includes a pre-configured devcontainer for immediate development:

```bash
# Clone the repository
git clone https://github.com/iotactical/atak-civ.git
cd atak-civ

# Option 1: Work with specific SDK version
cd ATAK-CIV-5.5.0.5-SDK
code . # Opens in VS Code with devcontainer

# Option 2: Work with all versions
code . # Opens entire repository
```

### Local Development Setup

1. **Configure local.properties** in your plugin project:
```properties
sdk.dir=<directory-path-to-android-sdk>
takrepo.url=https://artifacts.tak.gov/artifactory/maven  
takrepo.user=<username>
takrepo.password=<password>
takdev.plugin=.
```

2. **Install ATAK Javadocs**:
   - Download `atak-javadoc.jar` for your SDK version
   - Place in plugin root directory
   - Configure in Android Studio: External Libraries → Gradle → Library Properties

3. **Device Configuration**:

   **Physical Device:**
   - Enable USB debugging in Developer Options
   - Connect via USB

   **Emulator:**
   - Use Android Studio AVD Manager
   - Configure: Pixel 5, API 30+, x86_64 image
   - Set VM heap: 512 MB, Internal storage: 2048 MB

### Build and Deploy

1. **Select Build Variant**: `civDebug` (most common)
2. **Edit Configuration**: 
   - Launch Options: "Nothing"
   - Installation Options: "Always Install with Package Manager"
3. **Build**: Press play button in Android Studio
4. **Install ATAK**: APK generated in `/app/build/outputs/atak-apks/sdk/`
5. **Deploy Plugin**: Press play again to load plugin into ATAK

### Troubleshooting

| Problem | Solution |
|---------|----------|
| Out of space error | Increase emulator heap (512MB) and storage (2048MB) |
| ATAK crashes repeatedly | Disable OpenGL: `adb shell` → `cd sdcard/atak/` → `touch opengl.broken` |
| Display issues | Change emulator OpenGL renderer to ANGLE (D3D11) or SwiftShader |
| APK install fails | Use ADB: `adb install <atak-apk>` |

## SDK Version Differences

### ATAK CIV SDK 5.3.0.12 (Foundation)
- **Base Requirements**: Java 11, Android API 21+
- **Core Features**: Basic ATAK plugin architecture, essential APIs
- **Build System**: Gradle with basic ProGuard configuration
- **Testing**: Standard Android unit testing support

### ATAK CIV SDK 5.4.0.21
- **New in 5.4.0**: 
  - Enhanced action bar APIs
  - Improved user manual generation (Typst support)
  - Additional sample plugins (action-bar-demo)
  - Enhanced ProGuard configurations
- **Breaking Changes**: None (backward compatible with 5.3.0)
- **Migration**: Direct upgrade from 5.3.0

### ATAK CIV SDK 5.5.0.5 (Latest)
- **New in 5.5.0**:
  - Advanced DSM manager capabilities with enhanced UI
  - Extended documentation and user manual systems
  - Improved sample plugin coverage
  - Enhanced build tools and gradle configurations
- **Breaking Changes**: None (backward compatible with 5.4.0)
- **Migration**: Direct upgrade from 5.4.0

## DBSDK Integration

This repository is designed for seamless integration with the Defense Builders SDK (DBSDK) CI system:

### Container Generation
- **Base Image**: `ghcr.io/iotactical/dbsdk-base:latest`
- **Generated Containers**:
  - `iotactical/atak-civ-5.3.0.12`
  - `iotactical/atak-civ-5.4.0.21` 
  - `iotactical/atak-civ-5.5.0.5`

### Registry Configuration
DBSDK CI automatically scans for `.devcontainer/devcontainer.json` files and builds containers for each SDK version found.

### Environment Variables
Each devcontainer includes:
- `ATAK_SDK_VERSION`: Version identifier (e.g., "5.5.0.5")
- `ATAK_SDK_PATH`: Full path to SDK directory
- `ANDROID_HOME`: Android SDK location
- `ANDROID_SDK_ROOT`: Android SDK root

## Plugin Development

### Starting a New Plugin
1. Download the PluginTemplate from the SDK samples
2. Rename directory to your plugin name
3. Configure `local.properties`
4. Set up devcontainer or local environment
5. Begin development!

### Best Practices
- **Resource Management**: Always unregister resources in plugin lifecycle methods
- **Build Variants**: Use `civDebug` for development
- **Testing**: Implement Espresso tests using provided templates
- **Documentation**: Follow ATAK plugin documentation standards

### Plugin Lifecycle
- `onCreate()`: Initialize plugin resources
- `onStart()`, `onResume()`: Handle plugin activation
- `onPause()`, `onStop()`: Handle plugin deactivation  
- `onDestroy()`: Clean up all resources

## Support

- **Documentation**: See `ATAK_Plugin_Development_Guide.pdf` in each SDK directory
- **Samples**: Explore `/samples/` directory in each SDK version
- **Issues**: Report problems via GitHub Issues
- **ATAK Forums**: Official ATAK developer community

## License

See individual SDK license files in `/license/` directories for complete licensing information.

---

**Generated by DBSDK CI** - This README is automatically maintained as part of the Defense Builders SDK ecosystem.