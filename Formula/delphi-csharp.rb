class DelphiCsharp < Formula
  desc "A CLI tool to convert Delphi code to C#"
  homepage "https://github.com/vfa-khuongdv/homebrew-delphi-csharp"
  url "https://github.com/vfa-khuongdv/homebrew-delphi-csharp/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "764db02aba4c2b084e2f2100e3766b96161b8fde41971dbc33e06e4bcee26552"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install"
    system "npm", "run", "build"
    
    # Install the built application
    libexec.install Dir["*"]
    
    # Create a wrapper script
    (bin/"delphi-csharp").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/dist/cli.js" "$@"
    EOS
    
    chmod 0755, bin/"delphi-csharp"
  end

  test do
    system "#{bin}/delphi-csharp", "--version"
  end
end
