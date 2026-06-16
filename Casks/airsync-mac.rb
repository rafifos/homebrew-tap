cask "airsync-mac" do
  version "3.2.0"

  url "https://github.com/sameerasw/airsync-mac/archive/refs/tags/v#{version}.tar.gz"
  
  name "AirSync macOS"
  desc "Bring the forbidden macOS continuity to Android"
  homepage "https://sameerasw.com/airsync"
  license "MPL-2.0-only"
  
  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on xcode: ["15.0", :build]
  depends_on brew: ["scrcpy", "adb"]

  app "AirSync.app"

  postflight do
    system "cd #{staged_path} && xcodebuild -scheme 'AirSync Self Compiled' -configuration Release -derivedDataPath DerivedData"
  end

  zap trash: []
end
