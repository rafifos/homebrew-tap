class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1) and gpg-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://github.com/rafifos/keychain/archive/2.9.0.tar.gz"
  sha256 "81ca327d54e844cbf70910711da61852139cd357bb960318bafcfb2c58a7de10"
  license "GPL-2.0-only"

  livecheck do
    url "https://github.com/rafifos/keychain.git"
    strategy :github_latest
  end

  bottle :unneeded

  def install
    bin.install "keychain"
    man1.install "keychain.1"
  end

  test do
    system "#{bin}/keychain"
    hostname = shell_output("hostname").chomp
    assert_match "SSH_AGENT_PID", File.read(testpath/".keychain/#{hostname}-sh")
    system "#{bin}/keychain", "--stop", "mine"
  end
end
