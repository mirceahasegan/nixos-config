{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../shared/common.nix
  ];

  networking.hostName = "desktop-pc";

  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;
  };
}
