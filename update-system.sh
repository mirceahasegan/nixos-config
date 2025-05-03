#!/usr/bin/env bash
set -e

cd ~/nixos-config
nix flake update
sudo nixos-rebuild switch --flake .#nixos
