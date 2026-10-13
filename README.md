# Portable dotfiles

Personal shell, Git, Neovim, terminal appearance, and VS Code configuration.
Company paths, build conventions, credentials, and large-project tuning belong
in the separate employee repository's `dev-setup/` directory.

## Install

```sh
./install.sh --dry-run --gui
./install.sh --packages --gui --plugins
```

The default invocation installs configuration only. `--packages` installs the
curated Brewfile without upgrading existing packages or cleaning other packages.
`--gui` installs iTerm2 and VS Code when combined with `--packages`, and writes
their portable configuration. `--plugins` restores Neovim's plugin lockfile.
Linux config-only installation requires Python 3 and GNU Stow; GUI deployment is
for macOS. `Brewfile.optional` contains tmux, Tinty, and Git LFS, independently
selectable. No login-shell change, GNU-utility override, npm-prefix change, or
AI-provider configuration is performed.

Stow uses individual file links (`--no-folding`), so application directories can
also contain private files. Neovim requires 0.11 or later for the modern LSP API.
Treesitter deliberately retains its locked `master` API. Lazy's checker is off;
updates should be explicit and reviewed alongside `lazy-lock.json`.

## Backups and rollback

Every changed configuration is copied before replacement into a private
`~/.dotfiles-backups/personal-*/` directory. Already-correct links and identical
generated files are left alone. `--dry-run` makes no configuration changes.

```sh
python3 scripts/restore.py ~/.dotfiles-backups/personal-TIMESTAMP/manifest.json
```

Rollback refuses to discard later edits. Inspect those changes before using
`--force`. Restore work manifests before personal manifests if both are applied.
Package inventories and existing Temurin JDK destinations are saved separately
before package installation. Package removal is a manual operation, not part of
configuration rollback. Backups may contain credentials and must never be
published.

## Apps and appearance

The installer generates `Personal — Pop Bright` as an iTerm2 Dynamic Profile.
Select it in iTerm2; setting it as the default is a manual preference. It includes
keyboard mappings, scrollback, and a stable Pop Bright palette. It does not
overwrite the existing default profile or the full preferences database.
Operator Mono is a separately licensed font; install your licensed copy, or
choose a Nerd Font fallback. The old AutoLaunch palette script may still exist
on migrated machines; it is not required by the new profile.

`vscode/pop-bright-theme/` is a standalone MIT-attributed theme extension.
The installer builds `~/.local/share/dotfiles/pop-bright.vsix` without npm build
dependencies. Its theme label is `Pop Bright (Personal)` to avoid ambiguity with
the old locally modified Tinted extension.

```sh
code --install-extension ~/.local/share/dotfiles/pop-bright.vsix
```

VS Code settings are rendered copies, not public-repo symlinks. Edit the public
baseline in `vscode/settings.personal.jsonc`; company overrides live in the
employee repo. Generated Personal/Dremio `.code-profile` files can be imported
using VS Code's Profiles interface. The work installer also renders the combined
settings into the current default profile to preserve the existing workflow.
Running the personal GUI installer later resets the default profile to the
personal baseline; rerun the work GUI installer to restore its overlay.

Pop Bright YAML sources are in `themes/pop-bright/`. Committed Neovim/VS Code
outputs preserve the existing theme without depending on dirty Tinty caches.
Regeneration should use reviewed Tinted template revisions; ordinary installation
does not pull or rebuild third-party theme repositories.

## Private extension points

Zsh loads optional private files under `~/.config/work-setup/shell/`, plus
`.zprofile.local` and `.zshrc.local`. Git includes the private work configuration.
Neovim loads an optional `~/.config/work-setup/nvim.lua` for Java preferences.
Jenv is no longer initialized; the work setup selects Temurin 21 via macOS
`java_home`. Pyenv remains supported, but installing Python 3.11.4 is not forced
on new laptops. Credential stores and agent integration configuration are not
part of the public repo. Shell histories and generated plugin/editor state are
not captured.

## Tests and bootstrap

```sh
python3 -m unittest discover -s tests -v
```

`bootstrap-laptop.sh` is the small AirDrop entry point. On a new Mac:

```sh
bash bootstrap-laptop.sh --work
```

It requires the validated changes to be published first. Until then it fails
clearly against old remote revisions. `DOTFILES_REF` and `WORK_SETUP_REF` can
select published feature branches. Existing checkouts are not reset or switched.
Work authentication is interactive; no secrets are embedded in this file.

## Provenance

Parts of the original Neovim configuration derive from Mike Szczys's MIT-licensed
dotfiles. See `LICENSES/szczys-dotfiles.txt`. The Pop Bright theme uses Tinted
Theming templates; the relevant MIT license is retained alongside its VS Code
extension. Earlier installer assets and Base16 submodules were retired from this
tree; the pre-migration snapshot preserves them.
