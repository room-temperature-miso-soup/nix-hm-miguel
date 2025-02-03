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

        # Set escape-time to 300ms (or lower)
        set-option -sg escape-time 10

        # Enable focus events
        set -g focus-events on

         # Change prefix from Ctrl+b to Ctrl+a
        unbind C-b
        set-option -g prefix C-a
        bind-key C-a send-prefix

        # Split windows with shortcuts
        bind-key [ split-window -h  # Ctrl+a + [ for horizontal split
        bind-key ] split-window -v  # Ctrl+a + ] for vertical split

        # Resize panes with Ctrl + Arrow keys (by 3 cells)
        bind-key -n C-Left resize-pane -L 3
        bind-key -n C-Right resize-pane -R 3
        bind-key -n C-Up resize-pane -U 3
        bind-key -n C-Down resize-pane -D 3

        # Navigate panes with Ctrl + h/j/k/l
        bind-key -n C-h select-pane -L
        bind-key -n C-l select-pane -R
        bind-key -n C-k select-pane -U
        bind-key -n C-j select-pane -D

        # Reload tmux config with Ctrl+a + r
        bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"

        
      '';
    };

    home.packages = with pkgs; [
      zsh-powerlevel10k
      tmux
    ];
    
    programs.bash.enable = false;
  };
}
