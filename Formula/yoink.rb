class Yoink < Formula
  desc "Small, opinionated container deploy CLI for a handful of services on a handful of hosts."
  homepage "https://github.com/oddur/yoink"
  version "0.20.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oddur/yoink/releases/download/v0.20.6/yoink-aarch64-apple-darwin.tar.xz"
      sha256 "ba6b58b05b42141ea1cdb1c0cdf1994f8d1d279ec8412752741c863349720924"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oddur/yoink/releases/download/v0.20.6/yoink-x86_64-apple-darwin.tar.xz"
      sha256 "8e0212dd0609499ee0315d1a5607b839f9f3352529792fd3b09ad88b85a77294"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/oddur/yoink/releases/download/v0.20.6/yoink-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e74c9520441d9fe2315ba0d20396518570e143d57434b364c72e45987c494173"
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
