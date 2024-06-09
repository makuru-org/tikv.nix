{
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, fenix, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system: {
      packages.tikv =
        let 
          #toolchain = fenix.packages.${system}.fromManifest (nixpkgs.lib.importTOML ./Cargo.toml);
          toolchain = fenix.packages.${system}.fromToolchainFile { file = ./rust-toolchain.toml; sha256 ="sha256-4HfRQx49hyuJ8IjBWSty3OXCLOmeaZF5qZAXW6QiQNI=";};
          pkgs = nixpkgs.legacyPackages.${system};
        in

        (pkgs.makeRustPlatform {
          cargo = toolchain;
          rustc = toolchain;
        }).buildRustPackage rec {
          pname = "tikv";
          version = "8.1.0";

          src = pkgs.fetchFromGitHub {
            owner = "tikv";
            repo = pname;
            rev = "v${version}";
            sha256 = "sha256-oAyD2+LMHINZN8Kx87KxKLyOwf0EYnLMoJsoRZvmvBY=";
          };

          nativeBuildInputs = [
            pkgs.pkg-config
            pkgs.cmake
            pkgs.rustPlatform.bindgenHook
            pkgs.protobuf
            pkgs.snappy
            pkgs.zlib
            pkgs.lzlib
         ];

          buildInputs = [
            pkgs.pkg-config
            pkgs.gnumake
            pkgs.openssl
            pkgs.snappy
            pkgs.lz4
            pkgs.zlib
            pkgs.lzlib
            pkgs.go
            pkgs.gawk
            pkgs.libllvm
            pkgs.llvmPackages.clangUseLLVM
            pkgs.libgcc
            pkgs.binutils
          ];

          cargoLock = {
            lockFile = ./Cargo.lock;
            outputHashes = {
              "azure_core-0.12.0" = "sha256-1Y+4puMrtrKoKWxrNRl8MzBhX298NzT6V4/SVisNYbE=";
              "cmake-0.1.48" = "sha256-yFHJUzaiwvAyah6wahfeY7qNvtiN0nmsVSWr/Sc/tWk=";
              "encoding_rs-0.8.29" = "sha256-YbV9szN2nIxrEx0MKMFzJet8pKtNHv0ryghmvGfvUbE=";
              "fs2-0.4.3" = "sha256-ZaCu23Vzkpz+2AwL5n4lrHN+Pn4xFYC2awtaKil/Uxo=";
              "kvproto-0.0.2" = "sha256-g01XxpUMy4RwSiKjxpaYNLGr22Vc5aPYsz4wG7AqT0Q=";
              "librocksdb_sys-0.1.0" = "sha256-Tl+62DLy9U6PvatiCeVG7IV0fyOu+e8mGpZRrJRCxpA=";
              "procinfo-0.4.2" = "sha256-r0MgE8cNAf5LDgRQAtVDXBgck5eK67jAiN6lOZVsJyo=";
              "protobuf-2.8.0" = "sha256-bg8osI/zg9S7EckscdX4An+uy9yTOstiZypDu/85JMk=";
              "raft-0.7.0" = "sha256-77wPQoEG8Q0L8kPiWzB7NQLqx9T8o1U9vEMc0Prn9ho=";
              "raft-engine-0.4.2" = "sha256-AnIJJ87PA41QKpaxLkqfNxazjTo/Md2hO9aYG0JNrsQ=";
              "rusoto_core-0.46.0" = "sha256-JzDw+oZYSypurHvR31lD3Hjq2kfiGsgQ/14Z59IEMgg=";
              "skiplist-rs-0.1.0" = "sha256-3dVMAofINOObEYLtD0SuVfwCi0dmeslEq9ZcoGKd4wU=";
              "slog-global-0.1.0" = "sha256-1EoGVI0wHoSKG4yO9SjwLXYYIawYoTaLz15rWlmK7Kg=";
              "snappy-sys-0.1.0" = "sha256-7EKiW6RZuBOeX0Yp3Arf+ll14IwH+1QiR5vDNJomc0A=";
              "sysinfo-0.26.9" = "sha256-wsxUdNCX1nJwaS4kedhET2UBr9wY8Q4EB06I0w3JEIY=";
              "tame-oauth-0.9.6" = "sha256-dE5AWImaeWXP2SeGLryhGy82IONSPXAUuOXnLqL80x8=";
              "tipb-0.0.1" = "sha256-65ptYmqWaY8X3/3NUd8bwnzu+9KzXGDTErwJhLg6efo=";
              "tokio-executor-0.1.9" = "sha256-Ku9MnT7uhyWhXOc5vpcoGmxyTNN7EL5GT6c95S3r/4U=";
              "tracing-active-tree-0.1.0" = "sha256-EXKbt7nf0nlU89T80R5c4Iezji5GOWylMtCHmUeB86o=";
              "yatp-0.0.1" = "sha256-AQ7CzDT43tvbLdFIoEuTsK3KSubZFAQr0XrD81uwQbw=";
            };
          };
        };
    }
  );
}
