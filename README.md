# Homebrew tap for WIE

Homebrew tap for [**WIE**](https://github.com/wie-project/wie) — an
experimental emulator that runs 64-bit Windows PE user-mode binaries on macOS
Apple Silicon (no Windows, no Wine, no VM). Guest x86-64 code runs through a
Cranelift block JIT; Windows API calls are handled on the host in Rust.

## Install

```bash
brew tap wie-project/wie
brew install wie
```

The formula downloads the prebuilt `wie-<version>-darwin-arm64.tar.gz`
artifact attached to the matching GitHub release. The binary is unsigned —
macOS Gatekeeper will warn on first run (Right-click > Open, or
`xattr -dr com.apple.quarantine "$(which wie)"`). Code-signing and
notarization are out of scope.

## Update the formula on a new release

Each release in [wie-project/wie releases](https://github.com/wie-project/wie/releases)
produces `wie-<version>-darwin-arm64.tar.gz` via the release-on-tag workflow
(`.github/workflows/release.yml` in the wie repo). To serve the new version:

1. Edit `Formula/wie.rb`:
   - bump `version` to the tag without the leading `v` (e.g. tag `v1.1.0`
     → `version "1.1.0"`; the download URL interpolates it automatically);
   - replace `sha256` with the real digest of the new artifact:
     ```bash
     curl -L https://github.com/wie-project/wie/releases/download/v<ver>/wie-<ver>-darwin-arm64.tar.gz | shasum -a 256
     ```
2. Verify locally from the tap root:
   ```bash
   brew style Formula/wie.rb
   brew install --build-from-source .
   ```
3. Commit and push to `main`. Tap consumers pick up the new version on their
   next `brew update && brew upgrade wie`.
