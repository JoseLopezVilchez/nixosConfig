{
  description = "NixOS System";

  inputs = {
    nixpgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    { nixpkgs, ... }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos.nix
          ./hardware-configuration.nix
        ];
      };
    };
}
