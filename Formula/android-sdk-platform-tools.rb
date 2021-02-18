# frozen_string_literal: true
class AndroidSdkPlatformTools < Formula
  desc "Tools that interface with the Android platform, like adb and fastboot"
  homepage "https://developer.android.com/studio/releases/platform-tools"
  url "https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
  version "30.0.5"
  sha256 "d6d72d006c03bd55d49b6cef9f00295db02f0a31da10e121427e1f4cb43e7cb9"
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
