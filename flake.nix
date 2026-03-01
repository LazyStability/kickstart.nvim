{
  description = "A self-contained Neovim configuration wrapped in Nix";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          default = pkgs.callPackage ./neovim.nix { };
          neovim = pkgs.callPackage ./neovim.nix { };
        };

        apps = {
          neovim = {
            type = "app";
            program = "${pkgs.callPackage ./neovim.nix { }}/bin/nvim";
          };
        };
      }
    );
}
