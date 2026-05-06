{ pkgs, ... }:
{
  security = {
    tpm2 = {
      enable = true;
      abrmd.enable = true;
      pkcs11.enable = true;
    };
  };
  environment = {
    systemPackages = with pkgs; [
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
    etc = {
      "ssl/openssl.cnf".text = ''
        openssl_conf = default_conf

        [default_conf]
        providers = provider_sect

        [provider_sect]
        default = default_sect
        tpm2 = tpm2_sect

        [default_sect]
        activate = 1

        [tpm2_sect]
        module = ${pkgs.tpm2-openssl}/lib/ossl-modules/tpm2.so
        activate = 1
      '';
    };
    sessionVariables = {
      OPENSSL_MODULES = "${pkgs.tpm2-openssl}/lib/ossl-modules";
      OPENSSL_CONF = "/etc/ssl/openssl.cnf";
      TPM2TOOLS_TCTI = "device:/dev/tpmrm0";
    };
  };
  services = {
    pcscd.enable = true;
    udev.packages = with pkgs; [
      libfido2
    ];
    dbus = {
      enable = true;
      packages = [ pkgs.pinentry-qt ];
    };
  };
  systemd.user.services.tpm-fido = {
    description = "TPM2 FIDO2 Token Emulator";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.tpm-fido}/bin/tpm-fido";
      Environment = [ "PATH=${pkgs.pinentry-qt}/bin" ];
      Restart = "on-failure";
    };
  };
}
