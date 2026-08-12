class Revector < Formula
  desc "Declarative, versioned schema & config migrations for Qdrant — Alembic for vector collections."
  homepage "https://github.com/diegoglozano/revector"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/diegoglozano/revector/releases/download/v0.5.0/revector-aarch64-apple-darwin.tar.xz"
      sha256 "7e3bd0302be85b791729a4c9019b2cc9fe20f474e44b487cb4ff659f5c611a22"
    end
    if Hardware::CPU.intel?
      url "https://github.com/diegoglozano/revector/releases/download/v0.5.0/revector-x86_64-apple-darwin.tar.xz"
      sha256 "e44953b98c0bdcb6170ba45575bfbc681962fa4bffbfcf8116aebc3a0dd298b4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/diegoglozano/revector/releases/download/v0.5.0/revector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cb92bac9010e48ed5ee7422b61fc6624433abe4bb2a6c7e4e391488081d029a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/diegoglozano/revector/releases/download/v0.5.0/revector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "47efe13d186b07ca8f0de00dd9a11b42668295dc5f13cc9a1cfffc1c5abcae8f"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "revector"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "revector"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "revector"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "revector"
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
