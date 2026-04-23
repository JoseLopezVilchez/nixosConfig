{ pkgs, ... }:
{
  security = {
    tpm2 = {
      enable = true;
      abrmd.enable = true;
      pkcs11.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    tpm2-tss
    tpm2-tools
    libfido2
    tpm-fido
    pinentry-qt
    tpm2-abrmd
    tpm2-openssl
    openssl
    openssh
  ];
  systemd.user.services.tpm-fido = {
    description = "TPM2 FIDO2 Token Emulator";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.tpm-fido}/bin/tpm-fido";
      Restart = "on-failure";
    };
  };
}
