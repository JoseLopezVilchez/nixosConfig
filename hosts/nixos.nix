{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../modules/system/boot.nix
    ../modules/system/locale.nix
    ../modules/system/desktop-gnome.nix
    ../modules/system/sound.nix
    ../modules/system/users.nix
    ../modules/system/packages.nix
    ../modules/system/virt.nix
    ../modules/system/tpm.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users = {
      redfinger = import ./home.nix;
    };
  };

  networking.hostName = "nixos";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
}
