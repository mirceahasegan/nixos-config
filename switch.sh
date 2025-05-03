#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(dirname "$(realpath "$0")")"
HOST=nixos

echo "Using $REPO_DIR config root folder"
sudo nixos-rebuild switch --flake "$REPO_DIR#$HOST"
