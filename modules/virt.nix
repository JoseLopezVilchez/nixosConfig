{ ... }:
{
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    podman.enable = true;
    containers.policy = {
      default = [
        {
          type = "insecureAcceptAnything";
        }
      ];
    };
  };
}
