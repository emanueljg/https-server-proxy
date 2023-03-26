{
  description = "A https-server-proxy for Node.js (supporting http2 and Express applications)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, ... }: let
    name = "https-server-proxy"; 
  in
    flake-utils.lib.eachDefaultSystem(system: let

      pkgs = import nixpkgs { inherit system; };

      pkg = (pkgs.buildNpmPackage {
        inherit name;
        src = ./.;
        npmDepsHash = "sha256-QQSzCBQ2RG2kJggqU/f+VQHzlJqwZpdqkz4tckdob=";
        dontNpmBuild = true;
      });

    in {
      packages.default = pkg;
      packages.${name} = pkg;
    });
}

