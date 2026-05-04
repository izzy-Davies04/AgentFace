# Flutter Setup Guide - Complete Multi-Platform Development (2026)

Flutter is Google's UI toolkit that allows you to build high-performance applications for **Android, iOS, macOS, Windows, Linux, Web**, and embedded devices from a **single codebase**.

This guide helps you set up Flutter in your workspace to develop and deploy **AgentFace** (or any cross-platform app) on all major platforms.

---

## 1. System Requirements
- **OS**: Windows 10/11, macOS (latest), Linux (Ubuntu 22.04+ recommended)
- **RAM**: Minimum 8 GB (16 GB recommended)
- **Disk Space**: 10 GB+ free
- Stable internet connection

---

## 2. Install Flutter SDK

1. Download the latest stable Flutter SDK from: https://docs.flutter.dev/install
2. Extract it to a permanent folder:
   - Windows: `C:\src\flutter`
   - macOS/Linux: `~/development/flutter`
3. Add Flutter to your system PATH:
   - **Windows**: Add `C:\src\flutter\bin` to Environment Variables → Path
   - **macOS/Linux**: Add to `~/.zshrc` or `~/.bashrc`:
     ```bash
     export PATH="$PATH:~/development/flutter/bin"
     ```
4. Run the doctor command:
   ```bash
   flutter doctor
   ```

---

## 3. Platform Setup

### Android Setup
- Install **Android Studio** (latest version)
- Install Android SDK, Platform-Tools, and Emulator
- Run:
  ```bash
  flutter doctor --android-licenses
  ```
- Enable Android support (usually enabled by default)

### iOS & macOS Setup (macOS Only)
- Install **Xcode** from Mac App Store
- Install Command Line Tools:
  ```bash
  xcode-select --install
  ```
- Install CocoaPods:
  ```bash
  sudo gem install cocoapods
  ```
- Enable platforms:
  ```bash
  flutter config --enable-ios-desktop
  flutter config --enable-macos-desktop
  ```

### Windows Desktop Setup
- Install **Visual Studio 2022 Community** (with **Desktop development with C++** workload)
- Enable Windows support:
  ```bash
  flutter config --enable-windows-desktop
  ```

### Linux Desktop Setup
- Install required dependencies (Ubuntu/Debian):
  ```bash
  sudo apt-get update
  sudo apt-get install clang cmake git ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++6
  ```
- Enable Linux support:
  ```bash
  flutter config --enable-linux-desktop
  ```

### Web Setup
- Enabled by default. Run with Chrome or Edge for testing.

---

## 4. Create & Add AgentFace Project to Workspace

```bash
# Create new Flutter project
flutter create agentface

# Go into project folder
cd agentface

# Enable all platforms
    flutter config --enable-android
    flutter config --enable-ios
    flutter config --enable-macos-desktop
    flutter config --enable-windows-desktop
    flutter config --enable-linux-desktop
    flutter config --enable-web
```

---

## 5. Build Commands for AgentFace

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS (macOS only)
flutter build ios --release

# macOS Desktop
flutter build macos --release

# Windows Desktop
flutter build windows --release

# Linux Desktop
flutter build linux --release

# Web
flutter build web --release
```

---

## 6. Run Commands

```bash
flutter run                     # Run on connected device/emulator
flutter run -d chrome           # Run on Web
flutter run -d windows          # Run on Windows
flutter run -d macos            # Run on macOS
flutter run -d linux            # Run on Linux
flutter devices                 # List all available devices
```

---

## 7. Useful Commands

```bash
flutter doctor                  # Check setup status
flutter upgrade                 # Update Flutter
flutter clean                   # Clean build cache
flutter pub get                 # Get dependencies
flutter pub upgrade             # Upgrade packages
flutter analyze                 # Static code analysis
```

---

## 8. Recommended Development Tools
- **VS Code** (lightweight) + Flutter + Dart extensions
- **Android Studio** (best for Android + full Flutter support)

---

## 9. Deployment Notes for AgentFace
- **Android**: Upload `.aab` to Google Play Console
- **iOS**: Use Xcode + App Store Connect (macOS required)
- **macOS/Windows/Linux**: Distribute as native executables or use auto-updaters
- **Web**: Host build/web folder on any static hosting (Vercel, Netlify, Firebase, etc.)

**You are now ready to develop AgentFace** as a full cross-platform open-source application that runs on Android, iOS, macOS, Windows, Linux, and Web from one codebase.
