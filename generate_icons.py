#!/usr/bin/env python3
"""
Generate iOS app icons with candlestick design for Bias AI
Requires: pip install Pillow
"""

from PIL import Image, ImageDraw
import os

def create_candlestick_icon(size):
    """Create a simple green candlestick icon of given size"""
    # Create a new image with black background
    img = Image.new('RGBA', (size, size), color=(0, 0, 0, 255))
    draw = ImageDraw.Draw(img)
    
    # Calculate dimensions
    center_x = size // 2
    center_y = size // 2
    
    # Wick dimensions
    wick_width = max(2, size // 50)
    wick_top = int(size * 0.15)
    wick_bottom = int(size * 0.85)
    
    # Body dimensions
    body_width = int(size * 0.3)
    body_height = int(size * 0.25)
    body_left = center_x - body_width // 2
    body_right = center_x + body_width // 2
    body_top = center_y - body_height // 2
    body_bottom = center_y + body_height // 2
    
    # Simple green color
    green_color = (34, 197, 94, 255)  # A nice green color (#22C55E)
    
    # Draw upper wick (simple green)
    draw.rectangle(
        [center_x - wick_width//2, wick_top, center_x + wick_width//2, body_top],
        fill=green_color
    )
    
    # Draw lower wick (simple green)
    draw.rectangle(
        [center_x - wick_width//2, body_bottom, center_x + wick_width//2, wick_bottom],
        fill=green_color
    )
    
    # Draw candle body (simple green with slight rounded corners)
    # Main body
    draw.rectangle(
        [body_left, body_top, body_right, body_bottom],
        fill=green_color
    )
    
    # Add a simple highlight for dimension (optional, subtle)
    highlight_width = body_width // 3
    draw.rectangle(
        [body_left + 2, body_top + 2, body_left + highlight_width, body_bottom - 2],
        fill=(68, 217, 124, 255)  # Slightly lighter green for highlight
    )
    
    return img

def save_icon(img, size, scale, filename):
    """Save icon with proper size"""
    actual_size = size * scale
    if img.size != (actual_size, actual_size):
        img = img.resize((actual_size, actual_size), Image.Resampling.LANCZOS)
    img.save(filename, 'PNG')
    print(f"Created: {filename} ({actual_size}x{actual_size})")

def main():
    # Create output directory
    output_dir = "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    os.makedirs(output_dir, exist_ok=True)
    
    # Icon configurations (size, scale, filename)
    icons = [
        (20, 1, "Icon-App-20x20@1x.png"),
        (20, 2, "Icon-App-20x20@2x.png"),
        (20, 3, "Icon-App-20x20@3x.png"),
        (29, 1, "Icon-App-29x29@1x.png"),
        (29, 2, "Icon-App-29x29@2x.png"),
        (29, 3, "Icon-App-29x29@3x.png"),
        (40, 1, "Icon-App-40x40@1x.png"),
        (40, 2, "Icon-App-40x40@2x.png"),
        (40, 3, "Icon-App-40x40@3x.png"),
        (60, 2, "Icon-App-60x60@2x.png"),
        (60, 3, "Icon-App-60x60@3x.png"),
        (76, 1, "Icon-App-76x76@1x.png"),
        (76, 2, "Icon-App-76x76@2x.png"),
        (83.5, 2, "Icon-App-83.5x83.5@2x.png"),
        (1024, 1, "Icon-App-1024x1024@1x.png"),
    ]
    
    print("Generating Bias AI app icons with candlestick design...")
    print("-" * 50)
    
    for base_size, scale, filename in icons:
        actual_size = int(base_size * scale)
        img = create_candlestick_icon(actual_size)
        filepath = os.path.join(output_dir, filename)
        save_icon(img, base_size, scale, filepath)
    
    print("-" * 50)
    print("✅ All icons generated successfully!")
    print("\nThe icons feature:")
    print("- Black background")
    print("- Simple green candlestick")
    print("- Clean, minimalist design")

if __name__ == "__main__":
    main()
