{ config, pkgs, ... }:

{
  imports = [
    ../modules/homeManager/ai-services.nix
  ];

  home.username = "redfinger";
  home.homeDirectory = "/home/redfinger";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
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

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = {

  };

  # Home Manager can also manage your environment variables
  home.sessionVariables = {

  };

  home.programs = {
    git = {
      enable = true;
      userName = "José López Vílchez";
      userEmail = "joselopezvilchez.dev@gmail.com";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
