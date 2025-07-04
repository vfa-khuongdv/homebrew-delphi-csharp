class DelphiCsharp < Formula
  desc "A CLI tool to convert Delphi code to C#"
  homepage "https://github.com/vfa-khuongdv/homebrew-delphi-csharp"
  url "https://github.com/vfa-khuongdv/homebrew-delphi-csharp/releases/download/v1.0.0/delphi-csharp-1.0.0.tar.gz"
  sha256 "5ca8f9845d1a8ea87538cfa992cdc0a47ff158e81711127631f0b3627cf9ae68"
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
