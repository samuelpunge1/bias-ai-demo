#!/bin/bash

echo "🚀 Bias AI Demo - Setup Script"
echo "=============================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed"
flutter --version
echo ""

# Clean any existing build artifacts
echo "🧹 Cleaning project..."
flutter clean

# Get dependencies
echo "📦 Installing dependencies..."
flutter pub get

# Check iOS setup
echo ""
echo "📱 Checking iOS setup..."
flutter doctor -v

# Create iOS project files if needed
echo ""
echo "🔧 Setting up iOS project..."
cd ios

# Check if CocoaPods is installed
if ! command -v pod &> /dev/null; then
    echo "⚠️  CocoaPods is not installed. Installing CocoaPods..."
    sudo gem install cocoapods
fi

# Install iOS dependencies
echo "📦 Installing iOS dependencies..."
pod install || pod update

cd ..

echo ""
echo "✨ Setup complete!"
echo ""
echo "To run the app:"
echo "  flutter run                    # Run on default device"
echo "  flutter run -d iPhone          # Run on iOS simulator"
echo "  flutter run --release          # Run in release mode (smoother animations)"
echo ""
echo "To build for release:"
echo "  flutter build ios --release"
echo ""
echo "If you encounter any issues:"
echo "  1. Make sure Xcode is installed and updated"
echo "  2. Open ios/Runner.xcworkspace in Xcode and configure signing"
echo "  3. Run 'flutter doctor' to check for any issues"
echo ""
echo "Happy coding! 🎯"
