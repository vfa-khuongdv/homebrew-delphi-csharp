class DelphiCsharpLocal < Formula
  desc "A CLI tool to convert Delphi code to C#"
  homepage "https://github.com/vfa-khuongdv/homebrew-delphi-csharp"
  url "file:///Users/khuongdv/Desktop/tools/delphi-csharp-1.0.0.tar.gz"
  sha256 "6bcd0e3d84ac1c0026e912c67ee1870dc518bcd823c95f8a9ef76abffaa435bb"
  license "MIT"

  depends_on "node"

  def install
    # Install dependencies first
    system "npm", "install", "--production=false"
    # Build the project
    system "npm", "run", "build"
    
    # Verify dist directory exists
    odie "Build failed: dist directory not found" unless File.directory?("dist")
    
    # Install the built application
    libexec.install Dir["*"]
    (bin/"delphi-csharp-local").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/dist/cli.js" "$@"
    EOS
    chmod 0755, bin/"delphi-csharp-local"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/delphi-csharp-local --help")
  end
end
