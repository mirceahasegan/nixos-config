{ config, pkgs, ... }: {
  home.username = "mircea";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/mircea" else "/home/mircea";

  home.stateVersion = "24.11";

  fonts.fontconfig.enable = true;

  programs.home-manager = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };

    shellAliases = {
      # 🐚 Aliases for convenience
      ll = "ls -l";
      la = "ls -lah";
      l = "ls -CF";
      g = "git";
      v = "vim";
      c = "clear";
      h = "history";
      secureInputState  = "ioreg -l -d 1 -w 0 | grep SecureInput";
    };

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
      }
    ];
  };

  programs.git = {
    enable = true;

    # 🧑 Default identity
    userName = "Mircea Hasegan";
    # userEmail = "mircea.hasegan@iohk.io";

    # signing = {
    #   key = "A975E37E7053466EDED32653D6A4DD7DB6AAB2BD";
    #   signByDefault = true;
    # };

    aliases = {
      hist = "log --oneline --decorate";
      pf = "push --force-with-lease";
      aliases = "config --get-regexp ^alias\\.";
    };

    extraConfig = {
      core.editor = "vim";
      "filter \"lfs\"" = {
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
        clean = "git-lfs clean -- %f";
      };

      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";

      delta = {
        navigate = true;
        dark = true;
        line-numbers = true;
      };

      merge.conflictstyle = "zdiff3";

      # 🔁 Conditional config for work folder
      "includeIf \"gitdir:${config.home.homeDirectory}/me/\"" = {
        path = "${config.home.homeDirectory}/.gitconfig-me";
      };

      # 🔁 Conditional config for personal folder
      "includeIf \"gitdir:${config.home.homeDirectory}/iog/\"" = {
        path = "${config.home.homeDirectory}/.gitconfig-iog";
      };
    };
  };

  # 🧾 Git config for personal projects
  home.file.".gitconfig-me".text = ''
    [user]
      email = mircea.hasegan@gmail.com
      signingkey = A975E37E7053466EDED32653D6A4DD7DB6AAB2BD
    [commit]
      gpgsign = true
  '';

  # 🧾 Git config for IOG projects
  home.file.".gitconfig-iog".text = ''
    [user]
      email = mircea.hasegan@iohk.io
      signingkey = A975E37E7053466EDED32653D6A4DD7DB6AAB2BD
    [commit]
      gpgsign = true
  '';

  programs.vim = {
    enable=true;
    extraConfig = ''
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set autoindent
      set smartindent
    '';
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    terminal = "screen-256color";
    shell = "${pkgs.zsh}/bin/zsh";

    extraConfig = ''
      bind-key -T prefix m set mouse
      set-option -g history-limit 200000
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
      set-option -g set-clipboard off
    '';
  };

  programs.gpg = {
    enable = true;
    settings = {
      use-agent = true; # Tell GPG to use the gpg-agent for key operations
    };
  };

  services.gpg-agent = {
    enable = true; # Start the gpg-agent background service
    defaultCacheTtl = 1800; # Time (in seconds) a passphrase stays cached
    maxCacheTtl = 7200;     # Max time (in seconds) a passphrase can be cached
    pinentry.package = pkgs.pinentry-curses; # macOS-friendly pinentry; "curses" is reliable in terminal
  };

  home.packages = with pkgs; [
    jq
    yalc
    git
    delta
    git-lfs
    htop
    neovim
    curl
    wget
    unzip
    ripgrep
    fd
    tmux
    zsh
    victor-mono # nicest font ever
    nodejs_22
    pnpm
    docker
    colima # docker runtime
    lazydocker
    corepack
    yt-dlp
    utm
    rsync
  ] ++ (if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then [
      slack
      spice-vdagent
    ] else if pkgs.stdenv.hostPlatform.system == "aarch64-darwin" then [
      iterm2
    ] else []);

  home.sessionVariables = {
    EDIT = "vim";
    PAGER = "less";
  };

  nixpkgs.config.allowUnfree = true;
}