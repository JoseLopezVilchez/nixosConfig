{ pkgs, ... }:
{
  users.users.redfinger = {
    isNormalUser = true;
    description = "Redfinger";
    extraGroups = [
      "networkmanager"
      "wheel"
      "tss"
      "libvirtd"
    ];
    packages = with pkgs; [
      discord
      rustc
      cargo
      tor-browser
      gcc
      gnumake
      zed-editor
      rust-analyzer
      nixd
      nil
      prismlauncher
    ];
  };
}
