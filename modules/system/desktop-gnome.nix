{ pkgs, ... }:
{
  services = {
    printing.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome.gnome-software.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "es";
        variant = "nodeadkeys";
      };
    };
  };

  environment.gnome = {
    excludePackages = with pkgs; [
      gnome-tour
      yelp
      epiphany
      geary
      xterm
    ];
  };
}
