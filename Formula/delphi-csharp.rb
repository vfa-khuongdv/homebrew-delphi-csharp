class DelphiCsharp < Formula
  desc "A CLI tool to convert Delphi code to C#"
  homepage "https://github.com/vfa-khuongdv/homebrew-delphi-csharp"
  url "https://github.com/vfa-khuongdv/homebrew-delphi-csharp/releases/download/v1.0.0/delphi-csharp-1.0.0.tar.gz"
  sha256 "90083d2bf7774bf8127bca8283879a3a14f2dc8d56d51be569c61b2f588f8645"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install"
    system "npm", "run", "build"
    
    # Install the built application
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
