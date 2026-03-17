{ pkgs, ... }:
{
  services = {
    printing.enable = true;
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      xkb = {
        layout = "es";
        variant = "nodeadkeys";
      };
    };
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    yelp
    epiphany
    geary
    xterm
  ];
}
