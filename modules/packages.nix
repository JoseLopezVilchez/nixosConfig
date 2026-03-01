{ pkgs, ... }:
{
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    virt-manager
    podman
    tpm2-tools
    libfido2
    tpm-fido
    pinentry-qt
    git
  ];
}
