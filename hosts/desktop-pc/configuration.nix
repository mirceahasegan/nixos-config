{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../shared/common.nix
  ];

  networking.hostName = "desktop-pc";
}
