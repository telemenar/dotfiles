#!/bin/bash
set -euo pipefail
repo_dir=$(cd -- "$(dirname -- "$0")" && pwd)
packages=0
gui=0
dry_run=0
for arg in "$@"; do
  case "$arg" in
    --packages) packages=1 ;;
    --gui) gui=1 ;;
    --dry-run) dry_run=1 ;;
  esac
done
python3 "$repo_dir/scripts/deploy.py" --dry-run "$@" >/dev/null
if [[ "$packages" == 1 && "$dry_run" == 0 ]]; then
  command -v brew >/dev/null || { echo 'Install Homebrew first, or use bootstrap-laptop.sh.' >&2; exit 1; }
  python3 "$repo_dir/scripts/snapshot-packages.py"
  HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_CLEANUP=1 brew bundle --no-upgrade --file="$repo_dir/Brewfile"
  if [[ "$gui" == 1 ]]; then
    HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_CLEANUP=1 brew bundle --no-upgrade --file="$repo_dir/Brewfile.gui"
  fi
fi
command -v python3 >/dev/null || { echo 'Python 3 is required.' >&2; exit 1; }
exec python3 "$repo_dir/scripts/deploy.py" "$@"
