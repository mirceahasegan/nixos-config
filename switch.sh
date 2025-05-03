#!/usr/bin/env bash
set -eo pipefail

REPO_DIR="$(dirname "$(realpath "$0")")"
HOST=$1
DO_UPDATE=$2

# Check if hostname was provided
if [ -z "$HOST" ]; then
  echo "Error: Hostname is required."
  echo "Usage: $0 <hostname> [update]"
  exit 1
fi

echo "Using $REPO_DIR config root folder. Switching to $REPO_DIR#$HOST"
if [ -n "${DO_UPDATE+x}" ]; then
  echo "Running flake update.."
  nix flake update "$REPO_DIR"
fi
sudo nixos-rebuild switch --flake "$REPO_DIR#$HOST"
