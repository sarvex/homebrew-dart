class DartAT2 < Formula
  desc "The Dart 2 SDK"
  homepage "https://www.dartlang.org/"
  version "2.0.0-dev.65.0"

  keg_only :versioned_formula

  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.0.0-dev.65.0/sdk/dartsdk-macos-x64-release.zip"
    sha256 "506b6177ec2872154f81900ae14056147c1031892f22e9acf17368e00749dc11"
  else
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.0.0-dev.65.0/sdk/dartsdk-macos-ia32-release.zip"
    sha256 "f9ad337ced5cdae2b7f97172b259d97a14b76eb816b9d0e49017938be6976aa7"
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/dart"
    bin.write_exec_script Dir["#{libexec}/bin/{pub,dart?*}"]
  end

  def shim_script(target)
    <<~EOS
      #!/usr/bin/env bash
      exec "#{prefix}/#{target}" "$@"
    EOS
  end

  def caveats; <<~EOS
    Note that this is a prerelease version of Dart.

    Please note the path to the Dart SDK:
      #{opt_libexec}
    EOS
  end

  test do
    (testpath/"sample.dart").write <<~EOS
      void main() {
        print(r"test message");
      }
    EOS

    assert_equal "test message
", shell_output("#{bin}/dart sample.dart")
  end
end
