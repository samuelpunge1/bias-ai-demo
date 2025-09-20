# Bias AI Demo - Customization Guide

## Quick Animation Reference

### Timing Adjustments

All animation durations can be modified in their respective files:

#### Page Transitions (`lib/widgets/page_transitions.dart`)
- **FadeScaleTransition**: 600ms forward, 400ms reverse
- **SlideUpTransition**: 500ms forward, 400ms reverse
- **DepthTransition**: 700ms forward, 500ms reverse

#### Screen-Specific Animations

**Admin Screen** (`lib/screens/admin_screen.dart`)
- Button press scale: 100ms
- Bias selection animation: 200ms

**Intro Screen** (`lib/screens/intro_screen.dart`)
- Logo floating: 3 seconds (loops)
- Glow pulsing: 2 seconds (loops)
- Initial fade in: 2 seconds

**Instrument Screen** (`lib/screens/instrument_screen.dart`)
- Card stagger delay: 100ms between each
- Card fade/scale in: 400-700ms
- Press animation: 150ms

**Loading Screen** (`lib/screens/loading_screen.dart`)
- Text change interval: 1 second
- Text 3D animation: 800ms
- Progress dot animation: 300ms

**Results Screen** (`lib/screens/results_screen.dart`)
- Bias reveal: 800ms
- Confidence reveal: 800ms (400ms delay)
- Counter animation: 2000ms
- Color pulse: 2 seconds (loops)

## Color Customization

Edit `lib/theme/app_theme.dart`:

```dart
// Main colors
static const Color primaryBlue = Color(0xFF1E3A8A);    // Dark blue accent
static const Color primaryPurple = Color(0xFF6B21A8);  // Purple accent
static const Color glassWhite = Color(0x1AFFFFFF);     // Glass overlay
static const Color backgroundBlack = Color(0xFF000000); // Pure black background
```

### Confidence Level Colors
Edit in `lib/screens/results_screen.dart`:
- 80%+: Green
- 60-79%: Yellow
- 40-59%: Orange
- Below 40%: Red

## 3D Depth Effects

The 3D depth effect is achieved using Matrix4 transformations:

```dart
Transform(
  transform: Matrix4.identity()
    ..setEntry(3, 2, 0.005)  // Perspective depth (higher = more depth)
    ..scale(0.8),            // Scale factor
  alignment: Alignment.center,
  child: YourWidget(),
)
```

### Adjusting Depth
- `setEntry(3, 2, value)`: 
  - 0.001-0.005: Subtle depth
  - 0.005-0.01: Moderate depth
  - 0.01+: Dramatic depth

## Glassmorphism Settings

Edit `lib/widgets/glassmorphic_container.dart`:

```dart
// Default values
blur: 10.0,          // Background blur intensity (5-30 recommended)
opacity: 0.1,        // Container opacity (0.05-0.3 for glass effect)
borderRadius: 20.0,  // Corner radius
```

## Adding New Instruments

Edit `lib/screens/instrument_screen.dart`:

```dart
final List<String> instruments = ['ES', 'NQ', 'DAX', 'FTSE', 'NEW'];
final List<String> fullNames = [
  'E-mini S&P 500',
  'E-mini Nasdaq-100',
  'DAX Index',
  'FTSE 100',
  'New Instrument',
];
```

## Loading Messages

Edit `lib/screens/loading_screen.dart`:

```dart
final List<String> loadingTexts = [
  'Your custom message 1...',
  'Your custom message 2...',
  'Your custom message 3...',
  'Your custom message 4...',
];
```

## Performance Tips

1. **Always test in release mode** for smooth animations:
   ```bash
   flutter run --release
   ```

2. **Reduce animation complexity** if needed:
   - Decrease blur values
   - Simplify gradients
   - Reduce simultaneous animations

3. **Optimize for older devices**:
   - Lower `sigmaX` and `sigmaY` in BackdropFilter
   - Reduce shadow blur radius
   - Simplify transform animations

## Adding Haptic Feedback (Optional)

```dart
import 'package:flutter/services.dart';

// Light impact
HapticFeedback.lightImpact();

// Medium impact
HapticFeedback.mediumImpact();

// Selection click
HapticFeedback.selectionClick();
```

## Debug Options

Enable performance overlay:
```dart
MaterialApp(
  showPerformanceOverlay: true,  // Shows FPS
  debugShowCheckedModeBanner: false,
  // ...
)
```

## Common Modifications

### Make animations faster/slower globally
Create a constant multiplier in `lib/theme/app_theme.dart`:
```dart
static const double animationSpeed = 1.0; // 0.5 = twice as fast, 2.0 = twice as slow
```

Then use throughout:
```dart
Duration(milliseconds: (800 * AppTheme.animationSpeed).toInt())
```

### Disable all animations (for testing)
Set all animation durations to `Duration.zero` or use:
```dart
timeDilation = 5.0; // in main.dart - slows all animations by 5x for debugging
```

### Change app orientation
Edit `lib/main.dart`:
```dart
SystemChrome.setPreferredOrientations([
  DeviceOrientation.landscapeLeft,
  DeviceOrientation.landscapeRight,
]);
```
