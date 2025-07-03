class DelphiCsharp < Formula
  desc "A CLI tool to convert Delphi code to C#"
  homepage "https://github.com/vfa-khuongdv/homebrew-delphi-csharp"
  url "https://github.com/vfa-khuongdv/homebrew-delphi-csharp/releases/download/v1.0.0/delphi-csharp-1.0.0.tar.gz"
  sha256 "412c31b89cd5e0b3ea15db67a29c34b73fa80b2cc155be34d280d7078bcf0744"
  license "MIT"

  depends_on "node"

  def install
    # Everything is pre-built and included in the tarball
    # Just install the application directly
    libexec.install Dir["*"]
    (bin/"delphi-csharp").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/dist/cli.js" "$@"
    EOS
    chmod 0755, bin/"delphi-csharp"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/delphi-csharp --help")
  end
end
