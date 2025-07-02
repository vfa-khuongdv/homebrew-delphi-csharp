class DelphiCsharp < Formula
  desc "A CLI tool to convert Delphi code to C#"
  homepage "https://github.com/vfa-khuongdv/delphi-csharp"
  url "https://github.com/vfa-khuongdv/delphi-csharp/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "your-correct-sha256"
  license "MIT"

  depends_on "node"

  def install
    libexec.install Dir["*"]

    (bin/"delphi-csharp").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/dist/cli.js" "$@"
    EOS

    chmod 0755, bin/"delphi-csharp"
  end

  test do
    output = shell_output("#{bin}/delphi-csharp --help")
    assert_match "Usage", output
  end
end
