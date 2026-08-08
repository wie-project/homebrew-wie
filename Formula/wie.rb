# WIE — run 64-bit Windows apps on Apple Silicon.
#
# The artifact is an unsigned macOS arm64 binary built by the release-on-tag
# workflow in wie-project/wie (.github/workflows/release.yml) and attached to
# a GitHub release. Gatekeeper will warn on first run (unidentified
# developer); Right-click > Open, or `xattr -dr com.apple.quarantine <path>`
# dismisses it. Code-signing/notarization are out of scope for now.
#
# On a new upstream release:
#   1. Bump `version` below to the tag without the leading `v`.
#   2. Replace the placeholder sha256 with the real digest:
#      curl -L https://github.com/wie-project/wie/releases/download/v<ver>/wie-<ver>-darwin-arm64.tar.gz | shasum -a 256
#   3. Verify locally: brew style Formula/wie.rb && brew install --build-from-source .
class Wie < Formula
  desc "Experimental PE64 userspace emulator for macOS Apple Silicon"
  homepage "https://github.com/wie-project/wie"
  # Version hardcoded in the URL (homebrew-core convention): `#{version}`
  # interpolation inside `url` is evaluated before the `version` stanza runs,
  # which produced an empty version in the download path (`v//wie--.tar.gz`).
  # Bump this URL + the sha256 below on each release.
  url "https://github.com/wie-project/wie/releases/download/v0.1.0/wie-0.1.0-darwin-arm64.tar.gz"
  version "0.1.0"
  sha256 "298c444b4e050dc0e2ada74b8b8e143f2da9bd21687b712197dad494e5515687"

  def install
    bin.install "wie"
  end

  test do
    # The CLI has no --version flag; match the --help banner instead.
    assert_match "PE64 userspace emulator", shell_output("#{bin}/wie --help")
  end
end
