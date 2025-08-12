{
  pkgs,
  config,
  lib,
  inputs',
  ...
}:
let
  ln = config.lib.jv.ln;
in
{
  lib.jv.ln =
    path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/etc/${toString path}";

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nixVersions.nix_2_26
    cachix

    # utils
    git
    jujutsu
    wget
    htop
    jq
    fd
    eza
    ripgrep
    coreutils
    abduco
    numbat
    xh
    imagemagick # convert command useful for image previews in nvim

    # compilers
    clang
    cargo
    lua-language-server
    stylua

    tinymist # typst-lsp
    websocat # typst-preview nvim plugin dep

    # TODO: fix this somehow overriding the PATH of flakes in devshell..
    # zig

    inputs'.neovim-nightly-overlay.packages.default

    thunderbird
    obsidian
    # native-comp broken on macos 15.4:
    # https://github.com/NixOS/nixpkgs/issues/395169
    # inputs'.emacs-overlay.packages.emacs-unstable

    # (nerdfonts.override { fonts = [ "Monaspace" ]; })
    nerd-fonts.monaspace
    nerd-fonts.jetbrains-mono
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "${pkgs.fish}/bin/fish";
  };

  home.shellAliases = {
    ls = "eza";
  };

  # programs.alacritty = {
  #   enable = true;
  #   settings = {
  #     terminal.shell = "${pkgs.fish}/bin/fish";
  #     font = {
  #       normal.family = "MonaspiceKr Nerd Font";
  #       size = 14.0;
  #     };
  #     window = lib.mkMerge [
  #       (lib.mkIf pkgs.stdenv.isDarwin {
  #         option_as_alt = "Both";
  #         decorations = "Buttonless";
  #       })
  #       {
  #         blur = true;
  #         opacity = 0.9;
  #       }
  #     ];
  #     colors = {
  #       # Default colors
  #       primary = {
  #         background = "#000000";
  #         foreground = "#EBEBEB";
  #       };
  #
  #       # Normal colors
  #       normal = {
  #         black = "#0d0d0d";
  #         red = "#FF301B";
  #         green = "#A0E521";
  #         yellow = "#FFC620";
  #         blue = "#1BA6FA";
  #         magenta = "#8763B8";
  #         cyan = "#21DEEF";
  #         white = "#EBEBEB";
  #       };
  #
  #       # Bright colors
  #       bright = {
  #         black = "#6D7070";
  #         red = "#FF4352";
  #         green = "#B8E466";
  #         yellow = "#FFD750";
  #         blue = "#1BA6FA";
  #         magenta = "#A578EA";
  #         cyan = "#73FBF1";
  #         white = "#FEFEF8";
  #       };
  #     };
  #   };
  # };

  programs.tmux = {
    enable = true;
    prefix = "C-b";
    baseIndex = 1;
    reverseSplit = true;
    escapeTime = 0;
    focusEvents = true;
    historyLimit = 15000;
    keyMode = "vi";
    mouse = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    extraConfig = ''
      set -g status-keys emacs

      set -sa terminal-overrides ',xterm-256color:RGB,alacritty*:RGB,foot*:RGB,xterm-ghostty:RGB'

      set -g status 'on'
      set -g status-style bg=default,fg=colour255
      set -g status-justify 'left'
      set -g status-right '#{?#{m:*Z*,#F}, zoom,}#(timew > /dev/null && echo " timew:$(timew get dom.active.tag.1)")'
      set -g status-left '#S#[fg=colour255,nobold] | '
      set -g status-left-style fg=colour255,bold

      set -g message-style bg=default,fg=colour255

      set -gw window-status-format '#W'
      set -gw window-status-current-format '#W'
      set -gw window-status-style fg=colour255,bg=default
      set -gw window-status-current-style fg=colour98,bg=default,bold
      set -gw window-status-activity-style fg=colour200,bg=default

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # == tmux.nvim == #
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?\.?(view|n?vim?x?)(-wrapped)?(diff)?$'"

      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'
      # bind-key -n 'C-n' if-shell "$is_vim" 'send-keys C-n' 'select-window -n'
      # bind-key -n 'C-p' if-shell "$is_vim" 'send-keys C-p' 'select-window -p'

      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection -x

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      # bind-key -T copy-mode-vi 'C-n' select-window -n
      # bind-key -T copy-mode-vi 'C-p' select-window -p

      bind -n 'C-M-h' if-shell "$is_vim" 'send-keys C-M-h' 'resize-pane -L 1'
      bind -n 'C-M-j' if-shell "$is_vim" 'send-keys C-M-j' 'resize-pane -D 1'
      bind -n 'C-M-k' if-shell "$is_vim" 'send-keys C-M-k' 'resize-pane -U 1'
      bind -n 'C-M-l' if-shell "$is_vim" 'send-keys C-M-l' 'resize-pane -R 1'

      bind-key -T copy-mode-vi C-M-h resize-pane -L 1
      bind-key -T copy-mode-vi C-M-j resize-pane -D 1
      bind-key -T copy-mode-vi C-M-k resize-pane -U 1
      bind-key -T copy-mode-vi C-M-l resize-pane -R 1

      bind -n 'C-H' if-shell "$is_vim" 'send-keys C-M-h' 'swap-pane -s "{left-of}"'
      bind -n 'C-J' if-shell "$is_vim" 'send-keys C-M-j' 'swap-pane -s "{down-of}"'
      bind -n 'C-K' if-shell "$is_vim" 'send-keys C-M-k' 'swap-pane -s "{up-of}"'
      bind -n 'C-L' if-shell "$is_vim" 'send-keys C-M-l' 'swap-pane -s "{right-of}"'

      bind-key -T copy-mode-vi C-H swap-pane -s "{left-of}"
      bind-key -T copy-mode-vi C-J swap-pane -s "{down-of}"
      bind-key -T copy-mode-vi C-K swap-pane -s "{up-of}"
      bind-key -T copy-mode-vi C-L swap-pane -s "{right-of}"

      # == #

      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t '{end}'
      bind-key -T copy-mode-vi M-1 select-window -t 1
      bind-key -T copy-mode-vi M-2 select-window -t 2
      bind-key -T copy-mode-vi M-3 select-window -t 3
      bind-key -T copy-mode-vi M-4 select-window -t 4
      bind-key -T copy-mode-vi M-5 select-window -t 5
      bind-key -T copy-mode-vi M-6 select-window -t 6
      bind-key -T copy-mode-vi M-7 select-window -t 7
      bind-key -T copy-mode-vi M-8 select-window -t 8
      bind-key -T copy-mode-vi M-9 select-window -t '{end}'

      bind - split-window -v
      bind \\ split-window -h
      bind b set-option -g status
    '';
  };

  programs.zoxide.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$username"
        "$directory"
        "$cmd_duration"
        "$character"
      ];
      right_format = lib.concatStrings [
        "$git_branch"
        "$direnv"
      ];
      username = {
        format = "[$user]($style) ";
      };
      directory = {
        style = "";
        truncate_to_repo = false;
        before_repo_root_style = "dimmed";
        repo_root_style = "bold";
        truncation_symbol = "…/";
        # substitutions = {
        #   "~/etc" = "+";
        #   "~/src" = "@";
        # };
      };
      character = {
        success_symbol = "[->](bold blue)";
        error_symbol = "[->](bold red)";
        vimcmd_symbol = "[<-](bold green)";
        vimcmd_replace_one_symbol = "[<-](bold yellow)";
        vimcmd_replace_symbol = "[<-](bold yellow)";
        vimcmd_visual_symbol = "[<-](bold purple)";
      };
      direnv = {
        format = "[$symbol$loaded+$allowed]($style)";
        disabled = false;
        style = "dimmed";
        allowed_msg = "A";
        not_allowed_msg = "NA";
        denied_msg = "DENIED";
        loaded_msg = "L";
        unloaded_msg = "NL";
      };
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        symbol = " ";
        style = "dimmed";
      };
    };
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    history.ignoreDups = true;
    initExtra = "export ZLE_RPROMPT_INDENT=0";
  };

  programs.fish = {
    enable = true;
    shellInit =
      let
        # run the bootstrap file created by the determinate nix installer
        nix-daemon = "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish";
      in
      ''
        if test -e '${nix-daemon}'
          . '${nix-daemon}'
        end
      '';
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };

  # TODO: install ghostty here. check out the ghostty support in home-manager

  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--preview-window border-rounded"
      "--layout reverse"
      "--exact" # turn off fuzzy matching
      "--color 16"
    ];
  };

  programs.git = {
    enable = true;
    userName = "Javier A. Pollak";
    userEmail = "javi.po.123@gmail.com";
    ignores = [
      ".DS_STORE"
      ".direnv/"
      ".envrc"
    ];
    extraConfig = {
      fetch.parallel = 0;
      push.autoSetupRemote = true;
      push.default = "current";
      branch.autoSetupMerge = "inherit";
      init.defaultBranch = "master";
      submodule.recurse = true;
      branch.sort = "-committerdate";
    };
  };

  # Need to impure-symlink since lazy.lock needs to be writeable, but
  # store is read-only.
  xdg.configFile."nvim".source = ln "nvim";
  xdg.configFile."emacs".source = ln "emacs";
  xdg.configFile."ghostty".source = ln "ghostty";
}
