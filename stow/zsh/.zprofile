# Portable login initialization; company credentials live in an optional private file.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
[[ -r "$HOME/.config/work-setup/shell/work-profile.zsh" ]] && source "$HOME/.config/work-setup/shell/work-profile.zsh"
[[ -r "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"
true
