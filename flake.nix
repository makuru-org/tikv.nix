{
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "git+file:///home/framework-16/Documents/nixpkgs";
  };

  outputs =
    {
      fenix,
      flake-utils,
      nixpkgs,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (system: {
     packages.tikv =
        let
          toolchain = fenix.packages.${system}.fromToolchainFile {
            file = ./rust-toolchain.toml;
            sha256 = "sha256-4HfRQx49hyuJ8IjBWSty3OXCLOmeaZF5qZAXW6QiQNI=";
          };
          pkgs = nixpkgs.legacyPackages.${system};
        in

        (pkgs.makeRustPlatform {
          cargo = toolchain;
          rustc = toolchain;
        }).buildRustPackage
          rec {
            pname = "tikv";
            version = "8.4.0";

            src = pkgs.fetchFromGitHub {
              owner = pname;
              repo = pname;
              rev = "v${version}";
              sha256 = "sha256-CKt1Jh3UByB9hXc9WkXhevfKx+DNo1VUSV9Vvt2bJd4=";
            };

            # ROCKSDB_DIR = "${pkgs.rocksdb_6_23}";

            nativeBuildInputs = [
              pkgs.pkg-config
              pkgs.cmake
              pkgs.rustPlatform.bindgenHook
              pkgs.protobuf
              #pkgs.snappy
              #pkgs.zlib
              #pkgs.lzlib
              pkgs.git
            ];

            buildInputs = [
              pkgs.pkg-config
              pkgs.gnumake
              pkgs.openssl
              pkgs.snappy
              pkgs.go
              pkgs.gawk
              pkgs.libllvm
              pkgs.llvmPackages.clangUseLLVM
              pkgs.gcc9
              pkgs.binutils
              pkgs.lz4
              pkgs.zstd
              pkgs.zlib
              pkgs.bzip2
            ];

            cargoLock = {
              lockFile = ./Cargo.lock;
              outputHashes = {
                "azure_core-0.12.0" = "sha256-1Y+4puMrtrKoKWxrNRl8MzBhX298NzT6V4/SVisNYbE=";
                "cmake-0.1.48" = "sha256-yFHJUzaiwvAyah6wahfeY7qNvtiN0nmsVSWr/Sc/tWk=";
                "encoding_rs-0.8.29" = "sha256-YbV9szN2nIxrEx0MKMFzJet8pKtNHv0ryghmvGfvUbE=";
                "fs2-0.4.3" = "sha256-ZaCu23Vzkpz+2AwL5n4lrHN+Pn4xFYC2awtaKil/Uxo=";
                "kvproto-0.0.2" = "sha256-IQNJGkatLCiozTaf/+1fs/3lVQk6JViEuGjMh+wC6O8=";
                "librocksdb_sys-0.1.0" = "sha256-UcLCXLC3pM2s8vc7bi9IrtdLdjkv3xSPI7EjQvxrMYQ=";
                "procinfo-0.4.2" = "sha256-r0MgE8cNAf5LDgRQAtVDXBgck5eK67jAiN6lOZVsJyo=";
                "protobuf-2.8.0" = "sha256-Kzs5Gt06cNJROPXaQX8AIzFhoBYTs7ubEOGkccwhPJw=";
                "raft-0.7.0" = "sha256-77wPQoEG8Q0L8kPiWzB7NQLqx9T8o1U9vEMc0Prn9ho=";
                "raft-engine-0.4.2" = "sha256-AnIJJ87PA41QKpaxLkqfNxazjTo/Md2hO9aYG0JNrsQ=";
                "raft-engine-ctl-0.4.2" = "sha256-AnIJJ87PA41QKpaxLkqfNxazjTo/Md2hO9aYG0JNrsQ=";
                "rusoto_core-0.46.0" = "sha256-lnMcSpytw743FYfR12b6NUTrLwR8NCP8qrwELcjsS4g=";
                # "skiplist-rs-0.1.0" = "sha256-3dVMAofINOObEYLtD0SuVfwCi0dmeslEq9ZcoGKd4wU=";
                "slog-global-0.1.0" = "sha256-1EoGVI0wHoSKG4yO9SjwLXYYIawYoTaLz15rWlmK7Kg=";
                "snappy-sys-0.1.0" = "sha256-7EKiW6RZuBOeX0Yp3Arf+ll14IwH+1QiR5vDNJomc0A=";
                "sysinfo-0.26.9" = "sha256-wsxUdNCX1nJwaS4kedhET2UBr9wY8Q4EB06I0w3JEIY=";
                "tame-oauth-0.9.6" = "sha256-dE5AWImaeWXP2SeGLryhGy82IONSPXAUuOXnLqL80x8=";
                "tipb-0.0.1" = "sha256-WpJSHacVlLVYfCS+3ODdTTAc4nxbezLcawFvRdPseVI=";
                "tokio-executor-0.1.9" = "sha256-Ku9MnT7uhyWhXOc5vpcoGmxyTNN7EL5GT6c95S3r/4U=";
                "tracing-active-tree-0.1.0" = "sha256-EXKbt7nf0nlU89T80R5c4Iezji5GOWylMtCHmUeB86o=";
                "yatp-0.0.1" = "sha256-AQ7CzDT43tvbLdFIoEuTsK3KSubZFAQr0XrD81uwQbw=";
              };
            };
          };
    });
}
