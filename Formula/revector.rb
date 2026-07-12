class Revector < Formula
  desc "Declarative, versioned schema & config migrations for Qdrant — Alembic for vector collections."
  homepage "https://github.com/diegoglozano/revector"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/diegoglozano/revector/releases/download/v0.4.0/revector-aarch64-apple-darwin.tar.xz"
      sha256 "f228f8fce567345829f146e99b9eaec3f7a570b1806f4a79ce85ecec99f0de77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/diegoglozano/revector/releases/download/v0.4.0/revector-x86_64-apple-darwin.tar.xz"
      sha256 "1dd60fdd6edc668fd19b50dba44c42723d36dcb8983fde7be3b1bc9ac60120cd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/diegoglozano/revector/releases/download/v0.4.0/revector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "705a5447ac2cce2737b1b228816c485de147d5510979385cffac26c3df26d70b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/diegoglozano/revector/releases/download/v0.4.0/revector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2fc4df7ab3d67cde712f43710f2c566683a945220e40f242674b67629123c2d5"
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
