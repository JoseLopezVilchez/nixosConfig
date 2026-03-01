{ ... }:

{
  imports = [
    ../modules/boot.nix
    ../modules/locale.nix
    ../modules/desktop-gnome.nix
    ../modules/sound.nix
    ../modules/users.nix
    ../modules/packages.nix
    ../modules/virt.nix
    ../modules/tpm.nix
  ];

  networking.hostName = "nixos";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";
}
