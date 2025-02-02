{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    extraConfig = "set -g mouse on";
  };

  home.packages = with pkgs; [
    yazi
    htop
    btop
    eza
    fd
    tldr
  ];
  # Set Neovim as the default editor
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}

