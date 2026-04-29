class Yoink < Formula
  desc "Small, opinionated container deploy CLI for a handful of services on a handful of hosts."
  homepage "https://github.com/oddur/yoink"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oddur/yoink/releases/download/v0.13.0/yoink-aarch64-apple-darwin.tar.xz"
      sha256 "7fd180f8e33a528a82a6e678faa6de6689d0350b0849056a9192caf28ec937cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oddur/yoink/releases/download/v0.13.0/yoink-x86_64-apple-darwin.tar.xz"
      sha256 "b266ddd0482e6246dd3ce020153fd521dcb616c450ce877d0408df6b87c18b57"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/oddur/yoink/releases/download/v0.13.0/yoink-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "6c0d060380e9784761c2f6f98e5020974f11e8a55b0a7410bc9cd87b06ceaa6b"
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
