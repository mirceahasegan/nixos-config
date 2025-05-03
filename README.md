# Simple NixOS config

- For now I'm always using the "nixos" hostname.
- Scripts assume configuration files are in the same dir as the scripts

## Scripts

- `update-and-switch.sh` updates nix flakes and runs `nixos-rebuild`
- `switch.sh` runs `nixos-rebuild`
