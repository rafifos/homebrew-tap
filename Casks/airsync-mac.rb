cask "airsync-mac" do
  version "3.2.0"
  sha256 "5e74c5fa9fb92c2288070f8220b275a2749981ea7873ac5ecc6d6107475f4629"

  url "https://github.com/sameerasw/airsync-mac/releases/download/v#{version}/AirSync.dmg"
  name "AirSync macOS"
  desc "Bring the forbidden macOS continuity to Android"
  homepage "https://sameerasw.com/airsync"
  
  livecheck do
    url :url
    strategy :github_latest
  end

  app "AirSync.app"

  zap trash: []
end
