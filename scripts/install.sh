#!/bin/zsh
# Builds this fork and installs it to /Applications, replacing the running copy.
# Signing uses the local Apple Development certificate rather than the upstream team.
set -e

REPO_DIR=${0:a:h:h}
APP_NAME="Reminders MenuBar.app"
BUILD_DIR="${TMPDIR:-/tmp}/reminders-menubar-build"
TEAM_ID=${DEVELOPMENT_TEAM:-B3NUWGTPR9}

cd "$REPO_DIR"

echo "Building Release..."
xcodebuild -project reminders-menubar.xcodeproj \
  -scheme "Reminders MenuBar" \
  -configuration Release \
  -derivedDataPath "$BUILD_DIR" \
  CODE_SIGN_STYLE=Manual \
  DEVELOPMENT_TEAM="$TEAM_ID" \
  CODE_SIGN_IDENTITY="Apple Development" \
  PROVISIONING_PROFILE_SPECIFIER="" \
  build > "$BUILD_DIR.log" 2>&1 || { echo "Build failed, see $BUILD_DIR.log"; exit 1; }

echo "Replacing /Applications/$APP_NAME..."
osascript -e "tell application \"/Applications/$APP_NAME\" to quit" 2>/dev/null || true
sleep 2
rm -rf "/Applications/$APP_NAME"
cp -R "$BUILD_DIR/Build/Products/Release/$APP_NAME" "/Applications/$APP_NAME"

open "/Applications/$APP_NAME"
echo "Installed and launched."
