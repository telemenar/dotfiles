#!/bin/bash
# AirDrop this file; run from Terminal with: bash bootstrap-laptop.sh [--work]
set -euo pipefail
with_work=0
case "${1:-}" in
  --work) with_work=1 ;;
  '') ;;
  *) echo 'Usage: bash bootstrap-laptop.sh [--work]' >&2; exit 2 ;;
esac
[[ $(uname -s) == Darwin ]] || { echo 'This bootstrap is for macOS.' >&2; exit 1; }
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo 'Finish Command Line Tools installation, then run this script again.'
  exit 1
fi
if [[ -x /opt/homebrew/bin/brew ]]; then
  brew_bin=/opt/homebrew/bin/brew
elif [[ -x /usr/local/bin/brew ]]; then
  brew_bin=/usr/local/bin/brew
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -x /opt/homebrew/bin/brew ]]; then brew_bin=/opt/homebrew/bin/brew; else brew_bin=/usr/local/bin/brew; fi
fi
eval "$("$brew_bin" shellenv)"
export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_CLEANUP=1
# Existing checkouts are never switched, reset, or overwritten by this bootstrap.
personal=${DOTFILES_DIR:-$HOME/.dotfiles}
personal_ref=${DOTFILES_REF:-master}
if [[ ! -e "$personal" ]]; then
  git clone --branch "$personal_ref" https://github.com/telemenar/dotfiles.git "$personal"
fi
[[ -f "$personal/scripts/deploy.py" ]] || {
  echo 'The selected dotfiles revision does not contain the new setup yet.' >&2
  echo 'Publish the validated commits or select their branch with DOTFILES_REF.' >&2
  exit 1
}
bash "$personal/install.sh" --packages --gui --plugins
if [[ "$with_work" == 1 ]]; then
  gh auth status --hostname github.com >/dev/null 2>&1 || gh auth login --hostname github.com --git-protocol https --web
  work=${WORK_SETUP_DIR:-$HOME/repos/christopher.pride}
  if [[ ! -e "$work" ]]; then
    mkdir -p "$(dirname "$work")"
    git -c credential.helper= -c 'credential.https://github.com.helper=!gh auth git-credential' clone --branch "${WORK_SETUP_REF:-main}" https://github.com/dremio-employees/christopher.pride.git "$work"
  fi
  [[ -f "$work/dev-setup/install.sh" ]] || { echo 'Publish the validated work setup or select WORK_SETUP_REF.' >&2; exit 1; }
  DOTFILES_REPO="$personal" bash "$work/dev-setup/install.sh" --packages --gui
fi
code_bin='/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'
if [[ -x "$code_bin" ]]; then
  "$code_bin" --install-extension "$HOME/.local/share/dotfiles/pop-bright.vsix"
  while IFS= read -r extension; do
    [[ -z "$extension" || "$extension" == \#* ]] || "$code_bin" --install-extension "$extension"
  done < "$personal/vscode/extensions.personal.txt"
  if [[ "$with_work" == 1 ]]; then
    while IFS= read -r extension; do
      [[ -z "$extension" || "$extension" == \#* ]] || "$code_bin" --install-extension "$extension"
    done < "$work/dev-setup/vscode/extensions.work.txt"
  fi
fi
echo 'Open iTerm2 and select Personal — Pop Bright. Operator Mono is installed separately.'
echo 'Optional Personal/Dremio profile imports are in ~/.local/share/dotfiles/.'
echo 'Work credentials and company AI integrations still need enrollment.'
