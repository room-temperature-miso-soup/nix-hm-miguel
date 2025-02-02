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
}

