{ pkgs, ... }:
{
  security = {
    tpm2 = {
      enable = true;
      abrmd.enable = true;
      pkcs11.enable = true;
      fapi = {
        ekCertLess = true;
      };
    };
  };
  environment = {
    systemPackages = with pkgs; [
      tpm2-tss
      tpm2-tools
      tpm2-openssl
      tpm2-pkcs11-abrmd
      tpm2-pkcs11-fapi
      libfido2
      tpm-fido
      pinentry-qt
      openssl
      openssh
      ghostunnel
      pkcs11-provider
      p11-kit
      opensc
      gnupg
      gnupg-pkcs11-scd
    ];
    etc = {
      "ssl/openssl.cnf".text = ''
        openssl_conf = default_conf

        [default_conf]
        providers = provider_sect

        [provider_sect]
        default = default_sect
        tpm2 = tpm2_sect
        pkcs11 = pkcs11_sect

        [default_sect]
        activate = 1

        [tpm2_sect]
        module = ${pkgs.tpm2-openssl}/lib/ossl-modules/tpm2.so
        activate = 1

        [pkcs11_sect]
        module = ${pkgs.pkcs11-provider}/lib/ossl-modules/pkcs11.so
        activate = 1
      '';
      "pkcs11/modules/tpm2.module".text = ''
        module: ${pkgs.tpm2-pkcs11}/lib/libtpm2_pkcs11.so
      '';
    };
    sessionVariables = {
      OPENSSL_CONF = "/etc/ssl/openssl.cnf";
      TPM2TOOLS_TCTI = "device:/dev/tpmrm0";
    };
    shellAliases = {
      tpm2pkcs11-tool = "pkcs11-tool --module ${pkgs.tpm2-pkcs11-abrmd}/lib/libtpm2_pkcs11.so";
    };
  };
  services = {
    pcscd.enable = true;
    udev.packages = with pkgs; [
      libfido2
    ];
    dbus = {
      enable = true;
      packages = with pkgs; [
        pinentry-qt
        p11-kit
      ];
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
