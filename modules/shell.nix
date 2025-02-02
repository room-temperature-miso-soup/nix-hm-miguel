{ config, pkgs, ... }:
{
  imports = [ ];
  
  options = { };
  
  config = {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
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
          "tmux"
        ];
      };
      initExtra = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        
        # Auto-start tmux
        if [ -z "$TMUX" ]; then
          exec tmux new-session -A -s main
        fi
      '';
    };

    programs.tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      terminal = "screen-256color";
      baseIndex = 1;
      customPaneNavigationAndResize = true;
      historyLimit = 10000;
      extraConfig = ''
        # Enable mouse support
        set -g mouse on
        
        # Set prefix to Ctrl-a
        set -g prefix C-a
        unbind C-b
        bind C-a send-prefix
        
        # Improve colors
        set -g default-terminal "screen-256color"
        
        # Set window split keys
        bind-key v split-window -h
        bind-key h split-window -v
      '';
    };

    home.packages = with pkgs; [
      zsh-powerlevel10k
      tmux
    ];
    
    programs.bash.enable = false;
  };
}
