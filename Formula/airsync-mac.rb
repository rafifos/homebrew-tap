class AirsyncMac < Formula
  desc "Bring the forbidden macOS continuity to Android"
  homepage "https://sameerasw.com/airsync"
  url "https://github.com/sameerasw/airsync-mac/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "3932935ea301b45db656ecf958cfbbb9223308c31ae7d8c14ba2e75e6b256e8b"
  version "3.2.0"
  license "MPL-2.0"

  head "https://github.com/sameerasw/airsync-mac.git", branch: "main"

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
    # Use SelfCompiled.xcconfig instead of Shared.xcconfig
    inreplace "AirSync.xcodeproj/project.pbxproj",
              "Configs/Shared.xcconfig",
              "Configs/SelfCompiled.xcconfig"

    # xcodebuild needs to write to the project during SPM resolution;
    # Homebrew extracts tarballs as read-only, so make it writable.
    FileUtils.chmod_R "u+w", buildpath/"AirSync.xcodeproj"

    # Download Metal toolchain if not already installed (required for .metal shaders)
    system "xcodebuild", "-downloadComponent", "MetalToolchain"

    # Disable nested sandbox for SPM package resolution (Homebrew/discussions#59)
    system "xcodebuild", "-scheme", "AirSync Self Compiled",
           "-configuration", "Release",
           "-derivedDataPath", "DerivedData",
           "CODE_SIGN_IDENTITY=", "CODE_SIGNING_REQUIRED=NO", "AD_HOC_CODE_SIGNING_ALLOWED=YES",
           "OTHER_SWIFT_FLAGS=$(inherited) -disable-sandbox",
           "-IDEPackageSupportDisableManifestSandbox=1",
           "-IDEPackageSupportDisablePluginExecutionSandbox=1"
    app_path = buildpath/"DerivedData/Build/Products/Release/AirSync.app"
    prefix.install app_path
  end

  def caveats
    <<~EOS
      AirSync.app has been installed to:
        #{prefix}/AirSync.app

      To launch AirSync:
        open #{prefix}/AirSync.app

      To make it appear in /Applications and Launchpad:
        ln -s #{prefix}/AirSync.app /Applications/AirSync.app

      Build Configuration:
      • Built without code signing (development certificate not available in Homebrew environment)
      • Sandbox restrictions disabled to enable SPM package resolution
      • Self-compiled build configuration used (feature-gated with SELF_COMPILED flag)
      • Requires macOS Sonoma or later with Xcode 14.5+

      Optional dependencies:
      • android-platform-tools: For Android device integration
      • media-control: Enhanced media control features
      • scrcpy: Screen mirroring capabilities

      For more information, visit: https://sameerasw.com/airsync
    EOS
  end

  test do
    assert_predicate prefix/"AirSync.app", :exist?
  end
end
