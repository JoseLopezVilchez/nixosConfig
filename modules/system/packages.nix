{ pkgs, ... }:
{
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs.firefox = {
    enable = true;
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
  ];
}
