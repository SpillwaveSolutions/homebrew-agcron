class Agcron < Formula
  desc "Run AI agent workflows on a schedule — reliably, portably, and transparently"
  homepage "https://github.com/SpillwaveSolutions/agent-cron"
  version "1.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SpillwaveSolutions/agent-cron/releases/download/v1.8.0/agent-cron-aarch64-apple-darwin.tar.xz"
      sha256 "e269f6583f3c40b9aac9b85d63dad8163e7bc1ab4890c20c5428a9962532322d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SpillwaveSolutions/agent-cron/releases/download/v1.8.0/agent-cron-x86_64-apple-darwin.tar.xz"
      sha256 "38271c4b05f2198b7b4f029528fe9c0e7945938a90393ea5c4b60cdca61dfb9d"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/SpillwaveSolutions/agent-cron/releases/download/v1.8.0/agent-cron-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9a9f04f7862cefb3f23bf50e534c7cc267726bd5253f2b6c6884cc6c4eb0d116"
    end
  end

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
      bin.install "agcron"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "agcron"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "agcron"
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
