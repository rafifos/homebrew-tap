class AirsyncMac < Formula
  desc "Bring the forbidden macOS continuity to Android"
  homepage "https://sameerasw.com/airsync"
  url "https://github.com/sameerasw/airsync-mac/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "3932935ea301b45db656ecf958cfbbb9223308c31ae7d8c14ba2e75e6b256e8b"
  version "3.2.0"
  license "MPL-2.0"

  depends_on macos: :sonoma
  depends_on xcode: ["14.5", :build]
  depends_on "android-platform-tools" => :optional
  depends_on "media-control" => :optional
  depends_on "scrcpy" => :optional

  livecheck do
    url :url
    strategy :github_latest
  end

  def install
    # Disable nested sandbox for SPM package resolution (see Homebrew/discussions#59)
    system "xcodebuild", "-scheme", "AirSync Self Compiled",
           "-configuration", "Release",
           "-derivedDataPath", "DerivedData",
           "OTHER_SWIFT_FLAGS=$(inherited) -disable-sandbox",
           "-IDEPackageSupportDisableManifestSandbox=1",
           "-IDEPackageSupportDisablePluginExecutionSandbox=1"
    app_path = buildpath/"DerivedData/Build/Products/Release/AirSync.app"
    prefix.install app_path
  end

  def caveats
    <<~EOS
    The build is compiled without sandbox support to avoid nested sandbox issues with SPM packages.
    See: https://github.com/orgs/Homebrew/discussions/59
    EOS
  end

  test do
    assert_predicate prefix/"AirSync.app", :exist?
  end
end
