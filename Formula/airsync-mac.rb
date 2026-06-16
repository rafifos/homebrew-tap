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
    # Update project configuration to use SelfCompiled.xcconfig
    pbxproj = buildpath/"AirSync.xcodeproj/project.pbxproj"
    pbxproj_content = pbxproj.read
    pbxproj_content.gsub!("Configs/Shared.xcconfig", "Configs/SelfCompiled.xcconfig")
    pbxproj.write(pbxproj_content)

    # Disable nested sandbox for SPM package resolution and remove code signing requirements
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
      AirSync has been installed to #{prefix}/AirSync.app

      To launch AirSync:
        open #{prefix}/AirSync.app

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
