{ config, pkgs, ... }:
let
  toolbelt = import <toolbelt> {};
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "19.09";
  home.sessionVariables = {
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    GIT_SSH = "/usr/bin/ssh"; # https://github.com/NixOS/nixpkgs/issues/58132
    EDITOR = "emacs";
  };

  home.packages = with pkgs; [
    htop
    arandr
    glibcLocales
    ripgrep
    xsel
    toolbelt
  ];

  home.file = {
    ".emacs" = {
      source = ~/code/dotfiles/emacs.el;
    };
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      cargo
      yasnippet
      dap-mode
      helm
      yaml-mode
      nix-mode
      elm-mode
      magit
      nord-theme
      neotree
      fzf
      lsp-mode
      lsp-ui
      which-key
      flycheck
#      company-lsp
      company
      rust-mode
      flymake-diagnostic-at-point
      projectile
      protobuf-mode
      blacken
      terraform-mode
      xclip
      rainbow-delimiters

      # clojure
      clojure-mode
      lsp-mode
      cider
      lsp-treemacs
    ];
  };

  programs.fzf = rec {
    enable = true;
    defaultCommand = "${pkgs.ripgrep}/bin/rg --files";
    fileWidgetCommand = defaultCommand;
  };

  programs.firefox = {
    enable = true;
  };

  programs.gpg = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    enableAutosuggestions = true;
    initExtra = ''
      # don't add coppi to python env
      export REZ_USED=1

      # allow tab completion in the middle of a word
      setopt COMPLETE_IN_WORD

      # mark completion
      zstyle ':completion:*' menu select
      zstyle ':completion:*' list-colors '''
      zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
      typeset -g -A key
      bindkey "''${terminfo[khome]}" beginning-of-line
      bindkey "''${terminfo[kend]}" end-of-line
      bindkey "''${terminfo[kdch1]}" delete-char

      # arrow to search
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey '^[[A' up-line-or-beginning-search
      bindkey '^[[B' down-line-or-beginning-search
      bindkey '^[OA' up-line-or-beginning-search
      bindkey '^[OB' down-line-or-beginning-search
    '';
    plugins = [
      {
        name = "pure";
        src = pkgs.fetchFromGitHub {
          owner = "sindresorhus";
          repo = "pure";
          rev = "v1.11.0";
          sha256 = "0nzvb5iqyn3fv9z5xba850mxphxmnsiq3wxm1rclzffislm8ml1j";
        };
      }
      {
        name = "base16-shell";
        src = pkgs.fetchFromGitHub {
          owner = "chriskempson";
          repo = "base16-shell";
          rev = "master";
          sha256 = "1yj36k64zz65lxh28bb5rb5skwlinixxz6qwkwaf845ajvm45j1q";
        };
      }
    ];
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableScDaemon = true;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''
      set-option -ga update-environment ' LOCALE_ARCHIVE'
      set -g default-terminal "xterm-256color"
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      set-option -g default-shell ${pkgs.zsh}/bin/zsh
      # mouse (this really is the future)
      set -g mouse on

      # end and home keys
      bind -n End send-key C-e
      bind -n Home send-key C-a

      # shift + arrow keys to switch windows
      bind -n C-Left  previous-window
      bind -n C-Right next-window

      # move windows
      bind -n C-S-Left swap-window -t -1
      bind -n C-S-Right swap-window -t +1

      # Use Alt-arrow keys without prefix key to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # move panes
      bind -n C-M-Up swap-pane -U
      bind -n C-M-Down swap-pane -D

      # Status Bar
      set -g status-style fg=cyan,bg=default
      set -g status-interval 4
      set -g status-left '''
      set -g status-right '''

      set -g status-left '#{?client_prefix,💡,}'
      set -g status-right '#[fg=#green]%a %h-%d %H:%M#[default]'
      set -g status-justify centre

      # Set window split options
      set-option -g pane-active-border-style fg="green",bg=default
      set-option -g pane-border-style fg=black,bg=default

      # Highlighting the active window in status bar
      setw -g window-status-current-style fg=default,bg=default
      setw -g window-status-style fg=white,bg=default
      setw -g window-status-activity-style fg=default,bg=default,blink
      setw -g window-status-bell-style fg=default,bg=default,blink
      setw -g window-status-format '#[fg=blue] ● #[fg=blue]#W'
      setw -g window-status-current-format '#[fg=green,bold] ● #[fg=green]#W'

      bind -T copy-mode M-w send-keys -X copy-pipe-and-cancel "${pkgs.xsel}/bin/xsel -i --clipboard"
      bind r source-file ~/.tmux.conf
      bind -n MouseDown3Pane paste-buffer
      bind -T copy-mode MouseDragEnd1Pane send-keys -X stop-selection
      bind -T copy-mode MouseDown3Pane send-keys -X copy-pipe-and-cancel "${pkgs.xsel}/bin/xsel -i --clipboard"
       
      # remap prefix from 'C-b' to 'C-TAB'
      unbind C-b
      set-option -g prefix C-u
      bind-key C-u send-prefix

      # new panes always open in the same directory
      bind '"' split-window -c "#{pane_current_path}" 
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };

  programs.git = {
    enable = true;
    userEmail = "sakarias.johansson@goodbyekansas.com";
    userName = "Sakarias Johansson";
    signing = {
      key = "38EBE52A64C48459";
    };
    extraConfig = {
      pull.rebase = true;
    };
  };
}
