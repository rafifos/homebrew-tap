# frozen_string_literal: true
class AndroidSdkPlatformTools < Formula
  desc "Tools that interface with the Android platform, like adb and fastboot"
  homepage "https://developer.android.com/studio/releases/platform-tools"
  url "https://dl.google.com/android/repository/platform-tools_r31.0.2-linux.zip"
  version "31.0.2"
  sha256 "cdde800a61766679abc5771596225b4e0081d01b20ffea51bde26c488bcbc677"
  license :cannot_represent

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_exec_script "#{libexec}/adb"
    bin.write_exec_script "#{libexec}/dmtracedump"
    bin.write_exec_script "#{libexec}/e2fsdroid"
    bin.write_exec_script "#{libexec}/etc1tool"
    bin.write_exec_script "#{libexec}/fastboot"
    bin.write_exec_script "#{libexec}/hprov-conv"
    bin.write_exec_script "#{libexec}/make_f2fs"
    bin.write_exec_script "#{libexec}/make_f2fs_casefold"
    bin.write_exec_script "#{libexec}/mke2fs"
    bin.write_exec_script "#{libexec}/sload_f2fs"
  end

  test do
    system "#{bin}/adb", "--version"
    system "#{bin}/fastboot", "--version"
  end
end
