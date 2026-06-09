{ pkgs, ... }:
{
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs = {
    dconf = {
      enable = true;
    };
  };
  services.flatpak.enable = true;
  environment.systemPackages = with pkgs; [
    home-manager
    virt-manager
    podman
    git
    gsettings-desktop-schemas
  ];
}
