{ pkgs, ... }:
{
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs = {
    dconf = {
      enable = true;
    };
    firefox = {
      enable = true;
    };
  };
  programs.chromium = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    home-manager
    virt-manager
    podman
    git
    brave
    android-tools
    gtk3
    gtk4
    gsettings-desktop-schemas
  ];
}
