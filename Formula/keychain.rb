class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1) and gpg-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://github.com/rafifos/keychain/archive/2.9.0.tar.gz"
  sha256 "55eb7f8ce547dbd60b915b572a07d7b441f8018c694b06dfd3ba128c"
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
