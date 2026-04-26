class Yoink < Formula
  desc "Small, opinionated container deploy CLI for a handful of services on a handful of hosts."
  homepage "https://github.com/oddur/yoink"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oddur/yoink/releases/download/v0.2.1/yoink-aarch64-apple-darwin.tar.xz"
      sha256 "c08862add161ae10c460e32686407cddd9b45172989cbca3463ca8ed3032d638"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oddur/yoink/releases/download/v0.2.1/yoink-x86_64-apple-darwin.tar.xz"
      sha256 "1b3bbcece72b81b57f460c29c434e69e272cc78a95624b850275269d220f144f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/oddur/yoink/releases/download/v0.2.1/yoink-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "4a29257e71c696feccdab08642d1289797c54fc7938746b5e9169781283d2fbe"
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
