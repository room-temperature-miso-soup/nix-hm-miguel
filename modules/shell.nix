{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true; # Corrected option for Zsh autosuggestions
    syntaxHighlighting.enable = true; # Enable Zsh syntax highlighting
  oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "npm"
        "history"
        "node"
        "rust"
        "deno"
        "sudo"
        "docker"
      ];
    };
    initExtra = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];

  programs.bash.enable = false;
  # Add these lines to set zsh as default shell
  home.shellAliases = {
    # Your aliases here if needed
  };
  
  # This tells home-manager to manage your shell
  home.stateVersion = "24.11"; # Change this to your nixos version
  
  # Set default shell
  home.username = "nixos"; # Replace with your username
  home.homeDirectory = "/home/nixos"; # Replace with your home directory
  targets.genericLinux.enable = true;
  # The important line that sets zsh as default shell:
}
