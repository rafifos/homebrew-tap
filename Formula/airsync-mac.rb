class MetalToolchainRequirement < Requirement
  fatal true

  satisfy(build_env: false) do
    Utils.popen_read("xcodebuild", "-showComponent", "metalToolchain").include?("Status: installed")
  end

  def message
    "This formula requires the Metal toolchain. Please run `xcodebuild -downloadComponent MetalToolchain` first."
  end

  def display_s
    "Metal toolchain"
  end
end

class AndroidPlatformToolsRequirement < Requirement
  cask "android-platform-tools"

  satisfy(build_env: false) { which("adb") }

  def message
    "This formula requires android-platform-tools. Please run `brew install --cask android-platform-tools` first."
  end

  def display_s
    "android-platform-tools"
  end
end

class AirsyncMac < Formula
  desc "Bring the forbidden macOS continuity to Android"
  homepage "https://sameerasw.com/airsync"
  url "https://github.com/sameerasw/airsync-mac/archive/refs/tags/v4.1.0.tar.gz"
  version "4.1.0"
  sha256 "923ad789ae20fba54e5562a2ebfc58dc92e0423a11445938a3b4a77f71b99126"
  license "MPL-2.0"

  head "https://github.com/sameerasw/airsync-mac.git", branch: "main"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on xcode: ["27.0", :build]
  depends_on macos: :golden_gate
  depends_on MetalToolchainRequirement
  depends_on AndroidPlatformToolsRequirement => :optional
  depends_on "media-control" => :optional
  depends_on "scrcpy" => :optional

  def install
    # Use SelfCompiled.xcconfig instead of Shared.xcconfig
    inreplace "AirSync.xcodeproj/project.pbxproj",
              "Configs/Shared.xcconfig",
              "Configs/SelfCompiled.xcconfig"

    # xcodebuild needs to write to the project during SPM resolution;
    # Homebrew extracts tarballs as read-only, so make it writable.
    chmod_R "u+w", buildpath/"AirSync.xcodeproj"

    # Disable nested sandbox for SPM package resolution (Homebrew/discussions#59)
    xcodebuild "-scheme", "AirSync Self Compiled",
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
    assert_path_exists prefix/"AirSync.app"
  end
end
