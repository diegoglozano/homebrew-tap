class Revector < Formula
  desc "Declarative, versioned schema & config migrations for Qdrant — Alembic for vector collections."
  homepage "https://github.com/diegoglozano/revector"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/diegoglozano/revector/releases/download/v0.2.0/revector-aarch64-apple-darwin.tar.xz"
      sha256 "82e910e3053815d4ee0c3acdf5de77aabe1c264673ef88a6d3df7a38ac72ccef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/diegoglozano/revector/releases/download/v0.2.0/revector-x86_64-apple-darwin.tar.xz"
      sha256 "030cac6b06a6be4767ebe600b45980447b6930cf149bb99923a3df3331afc0b1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/diegoglozano/revector/releases/download/v0.2.0/revector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cf6f7f088d63a523112e8829c99d422b0286794df99ee1f4dc5c2ac12f652835"
    end
    if Hardware::CPU.intel?
      url "https://github.com/diegoglozano/revector/releases/download/v0.2.0/revector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7a528ccd694db3bff1db3df0a6fb3b0e975bd7fd447d59f16974002f92be47f4"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "revector" if OS.mac? && Hardware::CPU.arm?
    bin.install "revector" if OS.mac? && Hardware::CPU.intel?
    bin.install "revector" if OS.linux? && Hardware::CPU.arm?
    bin.install "revector" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
