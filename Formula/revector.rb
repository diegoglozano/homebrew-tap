class Revector < Formula
  desc "Declarative, versioned schema & config migrations for Qdrant — Alembic for vector collections."
  homepage "https://github.com/diegoglozano/revector"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/diegoglozano/revector/releases/download/v0.3.0/revector-aarch64-apple-darwin.tar.xz"
      sha256 "54255d32b7e09e9267c539d66af191af3ab88a2d8002e22e7870904d098f4fc7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/diegoglozano/revector/releases/download/v0.3.0/revector-x86_64-apple-darwin.tar.xz"
      sha256 "50c4e4f6d2faa959f04ab38d020f65e249fc5487415ee022a379986b3455d006"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/diegoglozano/revector/releases/download/v0.3.0/revector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "14ca605a6892b50771d265b207dc0161d2d34eb34b81cb91e11c230663e26f8c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/diegoglozano/revector/releases/download/v0.3.0/revector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e9d72cfdcc75a555c31d98f7fa0d7e469259f0707f5572b6d2f39dd7822c6050"
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
