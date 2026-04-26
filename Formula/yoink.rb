class Yoink < Formula
  desc "Small, opinionated container deploy CLI for a handful of services on a handful of hosts."
  homepage "https://github.com/oddur/yoink"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oddur/yoink/releases/download/v0.2.0/yoink-aarch64-apple-darwin.tar.xz"
      sha256 "76faaaa173ddfc3149272804f394ba409cb22ac8c74a9bc6f22f5cb806e7b0d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oddur/yoink/releases/download/v0.2.0/yoink-x86_64-apple-darwin.tar.xz"
      sha256 "f5695da9f55dd233b83e4a9e878dad5207f8b34c645e38e30c5f163fe8d5a08a"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/oddur/yoink/releases/download/v0.2.0/yoink-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "051bb755ab2c769d1f03cbcf4e34894973e3fdba82d9c244c97ab97c4c0a4d57"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "yoink"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "yoink"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "yoink"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
