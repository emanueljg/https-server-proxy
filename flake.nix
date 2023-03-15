{
  description = "A https-server-proxy for Node.js (supporting http2 and Express applications)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, ... }: let
    name = "https-server-proxy"; 
  in
    flake-utils.lib.eachDefaultSystem(system: let
      pkgs = import nixpkgs { inherit system; };

      inherit (pkgs)
        buildNpmPackage
        writeShellScriptBin
      ;


      libPkg = (buildNpmPackage {
        inherit name;

        buildInputs = [
          pkgs.nodejs
        ];

        dontNpmBuild = true;

        src = ./.;
        npmDepsHash = "sha256-QQSzCBQ2RG2kJggqU/f+VQHzlJqwZpdqkz4tckdobpQ=";
      }).overrideAttrs (_: _: { 
        postInstall = ''
          cat > $out/lib/node_modules/https-server-proxy/myproxy.js <<'endtextblock'
          const proxy = require('https-reverse-proxy')

          proxy('nodehill.com', {
            'emanuel.nodehill.com': 34000,
            'emanuel1.nodehill.com': 34001,
            'emanuel2.nodehill.com': 34002
          });
          endtextblock
        '';
      });
    in {
      packages.default = libPkg;
      packages.${name} = libPkg;
    });
}

