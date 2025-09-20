#!/bin/bash

echo "🔧 Fixing Bias AI App Icons..."
echo "================================"
echo ""

# Check if Python3 is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 is not installed. Please install Python3 first."
    exit 1
fi

# Install Pillow if not already installed
echo "📦 Installing Pillow library..."
pip3 install Pillow --quiet 2>/dev/null || pip3 install Pillow --user --quiet

# Run the icon generator
echo "🎨 Generating app icons with candlestick design..."
python3 generate_icons.py

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Icons fixed successfully!"
    echo ""
    echo "Now you can run:"
    echo "  flutter clean"
    echo "  flutter pub get"
    echo "  cd ios && pod install && cd .."
    echo "  flutter build ios"
    echo ""
    echo "The app icon will now show a green candlestick on black background."
else
    echo ""
    echo "❌ Failed to generate icons. Please check the error messages above."
    echo ""
    echo "Alternative: You can manually create a 1024x1024 PNG icon and use:"
    echo "  flutter pub add flutter_launcher_icons"
    echo "  flutter pub run flutter_launcher_icons"
fi
