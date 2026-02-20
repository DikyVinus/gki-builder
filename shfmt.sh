#!/usr/bin/env bash

set -euo pipefail

__DIR="$(dirname "$(realpath "$0")")"

if ! command -v shfmt &> /dev/null; then
  echo "shfmt not found. Attempting to install..."
  if command -v apt-get &> /dev/null; then
    sudo apt-get update -qq || true
    sudo apt-get install -qq shfmt -y
  else
    echo "Error: shfmt is not installed and apt-get is not available."
    exit 1
  fi
fi

echo "Formatting shell scripts in ${__DIR}..."
find "${__DIR}" -name "*.sh" -exec shfmt -w -i 2 -ci -sr -bn {} +
echo "Done."
