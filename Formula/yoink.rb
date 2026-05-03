class Yoink < Formula
  desc "Small, opinionated container deploy CLI for a handful of services on a handful of hosts."
  homepage "https://github.com/oddur/yoink"
  version "0.20.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oddur/yoink/releases/download/v0.20.1/yoink-aarch64-apple-darwin.tar.xz"
      sha256 "2c286aa303fa6273773accef61a4ddb0ffa73a8df079987b9802c18c64574f7e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oddur/yoink/releases/download/v0.20.1/yoink-x86_64-apple-darwin.tar.xz"
      sha256 "ad138c82342a9e6b66fc7b4951271def79b9ef78b6faeca21abaecc0ff9d149a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/oddur/yoink/releases/download/v0.20.1/yoink-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "84e2bbc4aea0af5775500a71fb413a223ab84f28b848c1438466befb4e6179bf"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "yoink" if OS.mac? && Hardware::CPU.arm?
    bin.install "yoink" if OS.mac? && Hardware::CPU.intel?
    bin.install "yoink" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
