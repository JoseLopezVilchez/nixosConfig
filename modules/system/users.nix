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
  };
}
