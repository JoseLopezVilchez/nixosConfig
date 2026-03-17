{ ... }:

{
  boot = {
    kernelModules = [ "uhid" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  services.udev.extraRules = ''
    KERNEL=="uhid", SUBSYSTEM=="misc", GROUP="users", MODE="0660"
    KERNEL=="tpmrm0", SUBSYSTEM=="misc", GROUP="tpm", MODE="0660"
  '';
}
