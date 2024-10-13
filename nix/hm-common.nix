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
  };

  home.shellAliases = {
    ls = "eza";
  };

  programs.alacritty = {
    enable = true;
    settings = {
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
          background = "0x000000";
          foreground = "0xEBEBEB";
        };

        # Normal colors
        normal = {
          black = "0x0d0d0d";
          red = "0xFF301B";
          green = "0xA0E521";
          yellow = "0xFFC620";
          blue = "0x1BA6FA";
          magenta = "0x8763B8";
          cyan = "0x21DEEF";
          white = "0xEBEBEB";
        };

        # Bright colors
        bright = {
          black = "0x6D7070";
          red = "0xFF4352";
          green = "0xB8E466";
          yellow = "0xFFD750";
          blue = "0x1BA6FA";
          magenta = "0xA578EA";
          cyan = "0x73FBF1";
          white = "0xFEFEF8";
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
