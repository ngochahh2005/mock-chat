#!/bin/zsh

# set the hooksPath config to point to a versioned directory :
git config --local core.hooksPath ".githooks/"
chmod +x .githooks/pre-commit
echo "Hooks installed successfully!"

# using fvm
flutterVersion=$(grep 'flutter_version' ci-cd-config/project-config.yaml | cut -d '=' -f2)
echo "Project flutter version: $flutterVersion"
echo "Run this command to switch to the project's flutter version:"
echo "fvm use $flutterVersion"