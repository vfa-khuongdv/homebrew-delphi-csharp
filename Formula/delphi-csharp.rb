class DelphiCsharp < Formula
  desc "A CLI tool to convert Delphi code to C#"
  homepage "https://github.com/vfa-khuongdv/homebrew-delphi-to-csharp"
  url "https://github.com/vfa-khuongdv/homebrew-delphi-to-csharp/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ce2194b9a7719ff4d8535b1f4c648570e871e8213737b53985e8aded443d8f63"
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
