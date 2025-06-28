#!/bin/bash
set -e

WORKSPACE="CookBook.xcworkspace"
SCHEME="CookBook"
SIMULATOR="iPhone 14"
CONFIGURATION="Debug"
DERIVED_DATA="build"
BUNDLE_ID="cn.edu.njxzc.CookBook"

# Build the app
xcodebuild -workspace "$WORKSPACE" -scheme "$SCHEME" -destination "platform=iOS Simulator,name=$SIMULATOR" -configuration "$CONFIGURATION" -derivedDataPath "$DERIVED_DATA" clean build

# Boot the simulator (if not already booted)
open -a Simulator
sleep 5
xcrun simctl boot "$SIMULATOR" || true

# Install the app
xcrun simctl install booted "$DERIVED_DATA/Build/Products/${CONFIGURATION}-iphonesimulator/${SCHEME}.app"

# Launch the app
xcrun simctl launch booted "$BUNDLE_ID" 