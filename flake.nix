{
  description = "Tikv package for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    crane.url = "github:ipetkov/crane";
    flake-utils.url = "github:numtide/flake-utils";
    #fenix = {
    #  url = "github:nix-community/fenix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      #url = "github:oxalica/rust-overlay/snapshot/2025-01-11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      crane,
      flake-utils,
      #fenix,
      rust-overlay,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };
      in
      {
        packages.default =
          let
            craneLib = (crane.mkLib pkgs).overrideToolchain (
              p: p.rust-bin.fromRustupToolchainFile (./rust-toolchain.toml)
            );
          in
          craneLib.buildPackage {

            buildFlags = [
              "CC=gcc-12"
              "CXX=g++-12"
              "RUST_BACKTRACE=FULL"
              "CARGO_PROFILE_RELEASE_BUILD_OVERRIDE_DEBUG=true"
              "DROCKSDB_DIR=../rocksdb-0.3.0"
            ];
            CC = "gcc-12";
            CXX = "g++-12";
            RUST_BACKTRACE = "FULL";
            CARGO_PROFILE_RELEASE_BUILD_OVERRIDE_DEBUG = true;
            DROCKSDB_DIR = "../rocksdb-0.3.0";

            #cargoBuildFlags = [
            #FIXME remove
            #"RUST_BACKTRACE=FULL"
            #"CARGO_PROFILE_RELEASE_BUILD_OVERRIDE_DEBUG=true"
            #end

            #"DROCKSDB_DIR=../rocksdb-0.3.0"
            #];

	    cargoToml = ./Cargo.toml;
            cargoLock = ./Cargo.lock;
            nativeBuildInputs = with pkgs; [
              pkg-config
              rustPlatform.bindgenHook
              git
              bzip2
              lz4
              zstd
              snappy
              protobuf
              cmake
              gcc12
              gflags
              openssl
            ];
            buildInputs = with pkgs; [ openssl ];
            src = pkgs.fetchFromGitHub {
              owner = "tikv";
              repo = "tikv";
              #FIXME
              rev = "699ecd9258482d5b38a0c2f196d9b8ecf3fbb616";
              fetchSubmodules = true;
              deepClone = true;
              sha256 = "sha256-MTDQzwi9CYnqI2iNbvQnMAC1juStUKsLbgYya59V+ak=";
            };
          };
      }
    );
}
