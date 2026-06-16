class AirSyncMacOS < Formula
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
    system "xcodebuild", "-scheme", "AirSync Self Compiled", "-configuration", "Release", "-derivedDataPath", "DerivedData"
    app_path = buildpath/"DerivedData/Build/Products/Release/AirSync.app"
    prefix.install app_path
  end

  test do
    assert_predicate prefix/"AirSync.app", :exist?
  end
end
