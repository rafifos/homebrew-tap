cask "hayase" do
  version "6.4.15"
  sha256 "e7c8ae72ee9a4c4e63b9be1c81dbc3d3ffe62509f127b1985aedaa914cc8ae0d"

  url "https://github.com/hayase-app/ui/releases/download/v#{version}/mac-hayase-#{version}-mac.dmg"
  name "Hayase"
  desc "Stream anime torrents instantly, real-time with no waiting for downloads"
  homepage "https://hayase.watch/"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Hayase.app"

  zap trash: [
    "~/Library/Application Support/hayase",
    "~/Library/Logs/hayase",
  ]
end
