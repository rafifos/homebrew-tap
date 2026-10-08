cask "fluxer-canary" do
  version "2026.1008.190209"
  sha256 "71f9b53361f9dece3fe43a0f3c8bdb1b7e26118ebd10ca838fa75caa71d7fe6a"

  url "https://github.com/fluxerapp/fluxer/releases/download/fluxer-desktop-canary%40#{version}/Fluxer-Canary-#{version}-mac-universal.dmg"
  name "Fluxer Canary"
  desc "Chat app that puts you first"
  homepage "https://fluxer.com/"

  livecheck do
    url :url
    regex(/fluxer-desktop-canary@(\d{4}\.\d{4}\.\d{5,6})/i)
    strategy :github_releases do |json, regex|
      json.filter_map do |release|
        next if release["draft"]

        release["tag_name"]&.[](regex, 1)
      end
    end
  end

  auto_updates true
  depends_on macos: :ventura

  app "Fluxer Canary.app"

  uninstall quit:       "app.fluxer.canary",
            signal:     [["TERM", "app.fluxer.canary"]],
            on_upgrade: :signal

  zap trash: [
    "~/Library/Application Support/CrashReporter/Fluxer Canary_*.plist",
    "~/Library/Application Support/fluxercanary",
    "~/Library/Caches/app.fluxer.canary",
    "~/Library/Caches/app.fluxer.canary.ShipIt",
    "~/Library/HTTPStorages/app.fluxer.canary",
    "~/Library/Logs/Fluxer Canary",
    "~/Library/Logs/fluxer_desktop_canary",
    "~/Library/Preferences/app.fluxer.canary.plist",
  ]
end
