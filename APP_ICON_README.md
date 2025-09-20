# Bias AI - App Icon Documentation

## Icon Design

The Bias AI app icon features a **glassmorphic candlestick** design that represents market trading:

### Design Elements:
- **Background**: Pure black (#000000) matching the app's theme
- **Candlestick**: Green bullish candle with glass effects
- **Accents**: Subtle dark blue (#1E3A8A) and purple (#6B21A8) gradients
- **Glass Effect**: Semi-transparent overlays with highlights

### Visual Representation:
```
     |     <- Upper wick
   ┌───┐
   │ ▓ │   <- Candle body (green gradient)
   │ ▓ │      with glass effect
   └───┘
     |     <- Lower wick
```

## Generating the Icon

### Method 1: Using Flutter Script (Recommended)

After setting up Flutter, run the icon generator:

```bash
flutter run lib/generate_app_icon.dart
```

This will create all required icon sizes with the candlestick design.

### Method 2: Using flutter_launcher_icons

1. Create a candlestick icon image (1024x1024px) and save as `assets/icon/app_icon.png`

2. Run:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### Method 3: Manual Creation

Use any image editor to create a candlestick icon with:
- Size: 1024x1024px
- Background: Black
- Candlestick: Centered, green with gradient
- Export to all required sizes

## Required Icon Sizes (iOS)

- 20x20 (1x, 2x, 3x)
- 29x29 (1x, 2x, 3x)
- 40x40 (1x, 2x, 3x)
- 60x60 (2x, 3x)
- 76x76 (1x, 2x)
- 83.5x83.5 (2x)
- 1024x1024 (1x) - App Store

## Icon Files Location

All icon files should be placed in:
```
ios/Runner/Assets.xcassets/AppIcon.appiconset/
```

## Design Guidelines

1. **Keep it Simple**: The candlestick should be clearly visible at all sizes
2. **Maintain Contrast**: Green candle on black background ensures visibility
3. **Glass Effects**: Should be subtle to avoid clutter at small sizes
4. **No Text**: The icon should not contain any text

## Color Palette

- Background: `#000000` (Pure Black)
- Candlestick Primary: `#00FF00` to `#008800` (Green gradient)
- Accent 1: `#1E3A8A` (Dark Blue)
- Accent 2: `#6B21A8` (Purple)
- Highlight: `#FFFFFF` at 20-30% opacity

## Testing

After generating icons, test them by:
1. Building the app: `flutter build ios`
2. Installing on device
3. Checking appearance on:
   - Home screen
   - App Switcher
   - Settings
   - App Store (TestFlight)

## Troubleshooting

If icons don't appear:
1. Clean build: `flutter clean`
2. Delete derived data in Xcode
3. Reinstall app on device
4. Check Info.plist has correct icon references

## Alternative Designs

For different market conditions, you could create variations:
- **Bullish**: Green candlestick (current design)
- **Bearish**: Red candlestick
- **Neutral**: White/gray candlestick
- **Premium**: Gold candlestick with enhanced glow

---

The candlestick icon represents the core functionality of Bias AI - analyzing market trends and providing trading insights with a modern, professional aesthetic.
