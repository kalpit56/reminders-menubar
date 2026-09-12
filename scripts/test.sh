#!/bin/zsh
# Runs the unit tests with the local signing settings.
set -e

REPO_DIR=${0:a:h:h}
TEAM_ID=${DEVELOPMENT_TEAM:-B3NUWGTPR9}

cd "$REPO_DIR"
xcodebuild -project reminders-menubar.xcodeproj \
  -scheme "Reminders MenuBar" \
  -configuration Debug \
  CODE_SIGN_STYLE=Manual \
  DEVELOPMENT_TEAM="$TEAM_ID" \
  CODE_SIGN_IDENTITY="Apple Development" \
  PROVISIONING_PROFILE_SPECIFIER="" \
  test
