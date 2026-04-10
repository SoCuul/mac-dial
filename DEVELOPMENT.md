# Development Notes

## Creating a Release
 1. Update the "Version" field to the new version number, and bump the "Build" field
    - Note that Sparkle uses kCFBundleVersionKey for its update version comparison, which shows up in the "Build" field in Xcode
 2. Run the app in Xcode, after it opens you can close it.
 3. Developer ID must be set up for code signing and notarization
 4. Archive the app and follow Apple's instructions for uploading a release to be notarized
 5. Upon receiving the success notification from Apple, export the notarized build from the project
 6. Create distribution DMG with the notarized build
 7. Notarize the distribution DMG (w/ shell command), and verify it has been notarized and stapled
 8. Run the `update_appcast.sh` shell script, providing the path to the notarized DMG as the first argument
 9. Create a GitHub release with a tag matching the "vX.X.X" naming format, and attach the notarized distribution DMG
 10. Commit and push the newly updated appcast.xml file to the origin repository
 11. Update Homebrew cask using `brew bump-cask-pr`