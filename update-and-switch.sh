#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(dirname "$(realpath "$0")")"
HOST=nixos

echo "Using $REPO_DIR to update flakes and switch"
nix flake update "$REPO_DIR"
sudo nixos-rebuild switch --flake "$REPO_DIR#$HOST"
