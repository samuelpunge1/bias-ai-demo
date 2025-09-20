# Bias AI Demo App

A sophisticated Flutter demo application for showcasing the Bias AI platform - a machine learning-based market analysis tool that provides calculated bias with confidence levels.

## App Icon

The app features a custom **candlestick icon** with glassmorphic effects:
- Black background matching the app theme
- Green bullish candlestick with glass effects
- Dark blue and purple accent gradients
- Professional trading aesthetic

See `APP_ICON_README.md` for detailed icon generation instructions.

## Features

- **Modern Glassmorphism Design**: Transparent glass effects with dark blue and purple accents on a pure black background
- **3D Depth Animations**: Parallax and depth effects for text transitions
- **Smooth Page Transitions**: Custom animations between screens
- **Counting Animations**: Animated number counters for confidence levels
- **Interactive UI Elements**: Press effects and hover states for all interactive components

## App Flow

1. **Admin Panel** (Hidden from clients)
   - Set market bias (Bullish/Bearish)
   - Adjust confidence level (0-100%)
   - Start the demo

2. **Intro Screen**
   - Glassmorphic "Bias AI" logo
   - Floating animation with subtle glow
   - Tap anywhere to continue

3. **Instrument Selection**
   - Choose from ES, NQ, DAX, or FTSE
   - Interactive cards with press effects

4. **Loading Screen**
   - Sequential analysis steps with 3D text transitions
   - Animated loading indicator
   - Progress dots

5. **Results Screen**
   - Display predetermined bias with pulsing effect
   - Animated confidence counter
   - Color-coded confidence levels
   - Tap to return to admin panel

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- iOS development environment (Xcode)
- iOS device or simulator running iOS 16+

## Installation

1. **Clone or download this project**

2. **Install Flutter dependencies**:
   ```bash
   cd bias_ai_demo
   flutter pub get
   ```

3. **iOS Setup** (IMPORTANT):
   ```bash
   cd ios
   pod install  # Install iOS dependencies
   cd ..
   ```
   
   If you get an error about missing Flutter or pods, run:
   ```bash
   flutter clean
   flutter pub get
   cd ios
   pod install
   cd ..
   ```

4. **Run on iOS**:
   ```bash
   flutter run
   ```
   
   Or to run on a specific device:
   ```bash
   flutter devices  # List available devices
   flutter run -d [device-id]
   ```

## Building for iOS

To build a release version for iOS:

1. **Open iOS project in Xcode**:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Configure signing**:
   - Select the Runner project
   - Go to Signing & Capabilities
   - Select your team
   - Update bundle identifier if needed

3. **Build the app**:
   ```bash
   flutter build ios --release
   ```

4. **Install on device**:
   - Connect your iOS device
   - Run: `flutter install`

## Key Technologies

- **State Management**: Provider pattern for clean state handling
- **Animations**: Flutter's animation controllers with custom curves
- **UI Effects**: 
  - BackdropFilter for glassmorphism
  - Transform widgets for 3D effects
  - Custom painted widgets
- **Navigation**: Custom page route transitions

## Color Scheme

- **Background**: Pure black (#000000)
- **Primary Blue**: #1E3A8A
- **Primary Purple**: #6B21A8
- **Glass White**: Semi-transparent white overlays
- **Text**: White with varying opacity

## Performance Optimizations

- Efficient widget rebuilds using Consumer widgets
- Optimized animations running at 60fps
- Proper disposal of animation controllers
- Cached gradients and decorations

## Customization

### Changing Animation Speeds
Edit the Duration values in respective screen files:
- Intro floating speed: `intro_screen.dart`
- Loading text transitions: `loading_screen.dart`
- Confidence counter: `results_screen.dart`

### Modifying Colors
Update the color values in `lib/theme/app_theme.dart`

### Adding New Instruments
Edit the `instruments` and `fullNames` lists in `lib/screens/instrument_screen.dart`

## Demo Tips

1. **Before the demo**:
   - Test all animations on the target device
   - Set appropriate bias and confidence for your scenario
   - Ensure smooth 60fps performance

2. **During the demo**:
   - Start from the admin screen to set parameters
   - Let animations complete for best effect
   - Point out the 3D depth effects during loading
   - Highlight the confidence level animation

3. **Talking points**:
   - Real-time market analysis capabilities
   - AI-driven bias calculation
   - Professional trading interface
   - Scalability to multiple instruments

## Troubleshooting

- **Animations stuttering**: Ensure you're running in release mode (`flutter run --release`)
- **Black screen**: Check that the device supports the required Flutter version
- **Touch not responsive**: Verify gesture detectors are properly configured

## Support

For any issues or questions about the demo app, please refer to the Flutter documentation or check the code comments for implementation details.

---

**Note**: This is a demo application for marketing purposes only. The bias and confidence values are predetermined and do not reflect actual market analysis.
