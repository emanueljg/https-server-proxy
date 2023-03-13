{
  description = "A https-server-proxy for Node.js (supporting http2 and Express applications)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, ... }: let
    name = "https-server-proxy"; 
  in
    flake-utils.lib.eachDefaultSystem(system: let

      pkgs = import nixpkgs { inherit system; };

      pkg = with pkgs; buildNpmPackage {
        inherit name;

        buildInputs = [
          pkgs.nodejs
        ];

        #dontNpmBuild = true;

        src = ./.;
        npmDepsHash = "sha256-QQSzCBQ2RG2kJggqU/f+VQHzlJqwZpdqkz4tckdobpQ=";
      };

    in {
      packages.default = pkg;
      packages.${name} = pkg;
    });
}

