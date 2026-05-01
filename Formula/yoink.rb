class Yoink < Formula
  desc "Small, opinionated container deploy CLI for a handful of services on a handful of hosts."
  homepage "https://github.com/oddur/yoink"
  version "0.19.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oddur/yoink/releases/download/v0.19.0/yoink-aarch64-apple-darwin.tar.xz"
      sha256 "7c9b9f65df8e021cbac49d37bbe8c6dfcc6d54f36c2397543ce7e2105e2f48d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oddur/yoink/releases/download/v0.19.0/yoink-x86_64-apple-darwin.tar.xz"
      sha256 "bb5da0dda7b964b2ef0e1c452cb17ff34f1e34175b49c31618fba69edb96fc87"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/oddur/yoink/releases/download/v0.19.0/yoink-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "b525cc67743574096e00b2ec788fbbc449c912139e935dbfe9ef83407235f877"
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
