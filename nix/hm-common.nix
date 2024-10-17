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
    # utils
    wget
    htop
    jq
    fd
    eza
    ripgrep
    coreutils
    abduco

    # compilers
    clang
    cargo
    # TODO: fix this somehow overriding the PATH of flakes in devshell..
    # zig

    inputs'.neovim-nightly-overlay.packages.default

    obsidian

    (nerdfonts.override { fonts = [ "Monaspace" ]; })
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "${pkgs.fish}/bin/fish";
  };

  home.shellAliases = {
    ls = "eza";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      shell = "${pkgs.fish}/bin/fish";
      font = {
        normal.family = "MonaspiceKr Nerd Font";
        size = 14.0;
      };
      window = lib.mkMerge [
        (lib.mkIf pkgs.stdenv.isDarwin {
          option_as_alt = "Both";
          decorations = "Buttonless";
        })
        {
          blur = true;
          opacity = 0.9;
        }
      ];
      colors = {
        # Default colors
        primary = {
          background = "#000000";
          foreground = "#EBEBEB";
        };

        # Normal colors
        normal = {
          black = "#0d0d0d";
          red = "#FF301B";
          green = "#A0E521";
          yellow = "#FFC620";
          blue = "#1BA6FA";
          magenta = "#8763B8";
          cyan = "#21DEEF";
          white = "#EBEBEB";
        };

        # Bright colors
        bright = {
          black = "#6D7070";
          red = "#FF4352";
          green = "#B8E466";
          yellow = "#FFD750";
          blue = "#1BA6FA";
          magenta = "#A578EA";
          cyan = "#73FBF1";
          white = "#FEFEF8";
        };
      };
    };
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
}
