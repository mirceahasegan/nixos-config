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
    userName = "Mircea Hasegan";
    userEmail = "mircea.hasegan@gmail.com";
    aliases = {
      hist = "log --oneline --decorate";
      pf = "push --force-with-lease";
      aliases = "config --get-regexp ^alias\.";
    };
    extraConfig = {
      core.editor = "vim";
    };
  };

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

  home.packages = with pkgs; [
    git
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