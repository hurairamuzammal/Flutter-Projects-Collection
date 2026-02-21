# Torch - Enhanced Flashlight App

A minimal, feature-rich Flutter torch/flashlight app with Google's dark Material design theme.

## Features

### 🔦 **Multiple Modes**
- **Torch**: Standard flashlight control
- **Strobe**: Adjustable speed strobe light
- **Screen Light**: Full-screen colored light (alternative to flashlight)

### 🎨 **Screen Light Colors**
- White, Red, Green, Blue, Amber
- Perfect for photography, reading, or ambient lighting

### 🔊 **Sound Effects**
- System click sounds for torch on/off
- Settings panel to enable/disable sounds
- Respects user preferences

### ⚙️ **Settings Panel**
- Sound effects toggle
- Strobe speed slider
- Screen brightness slider (controls device screen brightness in Screen mode)
- Minimal, accessible design

### 🎨 **Design**
- Google Material Dark theme with pure black background (#000000)
- Surface colors matching Material Design 3 specifications
- Smooth pulse animations when torch is active
- Responsive layout for all screen sizes

## Usage

### Basic Operation
1. **Select Mode**: Tap mode buttons (Torch, Strobe, Screen)
2. **Toggle ON/OFF**: Tap the large center button
3. **Settings**: Tap the settings icon (top right) for sound and speed controls

### Screen Light Mode
- Switch to "Screen" mode for colored screen lighting
- Choose colors using the color picker (appears in Screen mode)
- Adjust brightness using the settings slider

### Flash Patterns
- **Strobe**: Continuous flashing at adjustable speed
- All patterns stop when tapped again or mode is changed

## Permissions

### Android
- `CAMERA`: Required for flashlight access
- Camera hardware feature detection

### iOS
- Camera usage description for flashlight control

## Platform Support
- ✅ **Android**: Full functionality with flashlight hardware
- ✅ **iOS**: Full functionality with flashlight hardware  
- ⚠️ **Desktop/Web**: Screen light mode only (no hardware flashlight)

## Technical Details
- Uses `torch_light` package for flashlight control
- Uses `screen_brightness` package to control device/app screen brightness
- System sound effects via Flutter's `SystemSound` API
- Graceful fallback when flashlight is unavailable
- Animation controller for pulse effects
- Timer-based flash patterns with proper cleanup

## Building & Running

```bash
# Get dependencies
flutter pub get

# Run on device/emulator
flutter run

# Run tests
flutter test

# Build APK (Android)
flutter build apk

# Build iOS
flutter build ios
```

## Requirements
- Flutter SDK ^3.9.2
- Android: API level 21+ (Android 5.0+)
- iOS: iOS 11.0+
- Device with camera/flashlight for torch functionality
