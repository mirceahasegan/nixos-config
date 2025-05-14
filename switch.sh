#!/usr/bin/env bash
set -eo pipefail

REPO_DIR="$(dirname "$(realpath "$0")")"
HOST="${1:-$(hostname)}"
DO_UPDATE=$2

# Check if hostname was provided
if [ -z "$HOST" ]; then
  echo "Error: Hostname is required."
  echo "Usage: $0 <hostname> [update]"
  exit 1
fi

# Check if the script is running on macOS
if [[ "$(uname)" == "Darwin" ]]; then
  echo "Detected macOS. Using home-manager switch. Ignoring the 'Hostname' argument."
  home-manager switch --flake "$REPO_DIR#macos"
  exit 0
fi

echo "Using $REPO_DIR config root folder. Switching to $REPO_DIR#$HOST"
if [ -n "${DO_UPDATE+x}" ]; then
  echo "Running flake update.."
  nix flake update "$REPO_DIR"
fi
sudo nixos-rebuild switch --flake "$REPO_DIR#$HOST"
