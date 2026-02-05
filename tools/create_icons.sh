#!/bin/bash

# Create PicPic app icons with three-circle design
# This script generates icons in multiple sizes

echo "Creating PicPic app icons..."

# Create web icons directory if it doesn't exist
mkdir -p web/icons

# Create SVG icon (already created)
echo "✓ SVG icon created"

# Use ImageMagick to convert SVG to PNG in different sizes
# If ImageMagick is not available, you'll need to install it: brew install imagemagick

# Generate different icon sizes
declare -a sizes=(1024 512 192 180 152 144 120 114 76 72 60 57 48 36 32)

for size in "${sizes[@]}"; do
    echo "Generating Icon-${size}.png..."
    
    # Convert SVG to PNG with proper size
    if command -v convert >/dev/null 2>&1; then
        # Use ImageMagick convert
        convert web/icons/Icon-192.svg -resize ${size}x${size} -background transparent web/icons/Icon-${size}.png
    else
        echo "⚠️  ImageMagick not found. Please install with: brew install imagemagick"
        echo "⚠️  Or use an online SVG to PNG converter"
        exit 1
    fi
done

# Create iOS icons directory structure
mkdir -p ios/Runner/Assets.xcassets/AppIcon.appiconset

# Copy specific sizes for iOS
cp web/icons/Icon-1024.png ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png
cp web/icons/Icon-512.png ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-512x512@1x.png
cp web/icons/Icon-192.png ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png
cp web/icons/Icon-180.png ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png
cp web/icons/Icon-152.png ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png
cp web/icons/Icon-144.png ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-72x72@2x.png
cp web/icons/Icon-120.png ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png
cp web/icons/Icon-114.png ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-57x57@2x.png
cp web/icons/Icon-76.png ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png
cp web/icons/Icon-72.png ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-36x36@2x.png
cp web/icons/Icon-60.png ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png
cp web/icons/Icon-57.png ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png
cp web/icons/Icon-48.png ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-24x24@2x.png
cp web/icons/Icon-36.png ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-18x18@2x.png
cp web/icons/Icon-32.png ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-16x16@2x.png

# Create Android icons directory structure
mkdir -p android/app/src/main/res/mipmap-hdpi
mkdir -p android/app/src/main/res/mipmap-mdpi
mkdir -p android/app/src/main/res/mipmap-xhdpi
mkdir -p android/app/src/main/res/mipmap-xxhdpi
mkdir -p android/app/src/main/res/mipmap-xxxhdpi

# Copy specific sizes for Android
cp web/icons/Icon-72.png android/app/src/main/res/mipmap-hdpi/ic_launcher.png
cp web/icons/Icon-48.png android/app/src/main/res/mipmap-mdpi/ic_launcher.png
cp web/icons/Icon-96.png android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
cp web/icons/Icon-144.png android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
cp web/icons/Icon-192.png android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png

echo "✓ App icons generated successfully!"
echo ""
echo "Generated files:"
echo "  Web: web/icons/Icon-*.png"
echo "  iOS: ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png"
echo "  Android: android/app/src/main/res/mipmap-*/ic_launcher.png"
echo ""
echo "🎨 New PicPic icon features:"
echo "  - Three circles with different sizes"
echo "  - Gradient background matching app theme"
echo "  - Professional, modern design"
