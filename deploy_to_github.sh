#!/bin/bash

echo "🚀 Bias AI - GitHub Pages Deployment Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Flutter found${NC}"
echo ""

# Build for web
echo "📦 Building web version..."
flutter build web --release --web-renderer html --base-href /bias-ai-demo/

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Build successful${NC}"
echo ""

# Create icons if they don't exist
echo "🎨 Creating web icons..."
mkdir -p build/web/icons

# Copy a simple icon (using the green candlestick concept)
if [ -f "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png" ]; then
    cp ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png build/web/favicon.png
    echo -e "${GREEN}✓ Icons copied${NC}"
else
    echo -e "${YELLOW}⚠ Icons not found, using defaults${NC}"
fi

echo ""
echo "📁 Web build ready in: build/web/"
echo ""
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}NEXT STEPS TO DEPLOY:${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo ""
echo "1. Create a new GitHub repository named 'bias-ai-demo'"
echo ""
echo "2. Initialize git and push the web build:"
echo -e "${YELLOW}"
echo "   cd build/web"
echo "   git init"
echo "   git add ."
echo "   git commit -m 'Initial deployment'"
echo "   git branch -M main"
echo "   git remote add origin https://github.com/YOUR_USERNAME/bias-ai-demo.git"
echo "   git push -u origin main"
echo -e "${NC}"
echo "3. Enable GitHub Pages:"
echo "   - Go to repository Settings → Pages"
echo "   - Source: Deploy from a branch"
echo "   - Branch: main"
echo "   - Folder: / (root)"
echo "   - Click Save"
echo ""
echo "4. Your app will be live at:"
echo -e "${GREEN}   https://YOUR_USERNAME.github.io/bias-ai-demo${NC}"
echo ""
echo "5. Share with friend - they can:"
echo "   - Open in Safari on iPhone"
echo "   - Tap Share button"
echo "   - Select 'Add to Home Screen'"
echo "   - Name it 'Bias AI'"
echo ""
echo -e "${GREEN}✨ The app will work offline after first visit!${NC}"
