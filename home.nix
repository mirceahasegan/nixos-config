{ config, pkgs, ... }: {
  home.username = "mircea";
  home.homeDirectory = "/home/mircea";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "zsh-autosuggestions" "zsh-autosuggestions" ];
      theme = "robbyrussell";
    };
  };

  programs.git = {
    enable = true;
    userName = "Mircea Hasegan";
    userEmail = "mircea.hasegan@gmail.com";
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
  ];

  home.sessionVariables = {
    EDIT = "vim";
    PAGER = "less";
  };
}

