#!/usr/bin/env python3
"""Install selected configs with backups. App-generated settings never link to Git."""
import argparse
import datetime
import hashlib
import json
import os
from pathlib import Path
import shutil
import shlex
import subprocess
import tempfile
import zipfile

REPO = Path(__file__).resolve().parents[1]


def signature(path):
    if path.is_symlink():
        return {"link": os.readlink(path)}
    if path.is_file():
        return {"sha256": hashlib.sha256(path.read_bytes()).hexdigest()}
    if path.is_dir():
        digest = hashlib.sha256()
        for child in sorted(path.rglob('*')):
            digest.update(str(child.relative_to(path)).encode())
            if child.is_symlink():
                digest.update(os.readlink(child).encode())
            elif child.is_file():
                with child.open('rb') as stream:
                    for block in iter(lambda: stream.read(1024 * 1024), b''):
                        digest.update(block)
        return {"directory_sha256": digest.hexdigest()}
    return None


def jsonc(text):
    # Scan comments without changing URLs or escaped quotes inside strings.
    import re
    pattern = r'"(?:\\.|[^"\\])*"|//[^\n]*|/\*[\s\S]*?\*/'
    clean = re.sub(pattern, lambda m: m.group() if m.group().startswith('"') else '', text)
    pattern = r'"(?:\\.|[^"\\])*"|,\s*(?=[}\]])'
    clean = re.sub(pattern, lambda m: m.group() if m.group().startswith('"') else '', clean)
    return json.loads(clean)


def merge(base, overlay):
    result = dict(base)
    for key, value in overlay.items():
        if isinstance(value, dict) and isinstance(result.get(key), dict):
            result[key] = merge(result[key], value)
        else:
            result[key] = value
    return result


class Installer:
    def __init__(self, home, dry_run=False, label="personal"):
        self.home = Path(home).expanduser().resolve()
        self.dry_run = dry_run
        stamp = datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%d-%H%M%S-%f')
        self.backup_root = self.home / '.dotfiles-backups' / f'{label}-{stamp}'
        self.entries = []

    def destination(self, relative):
        relative = Path(relative)
        if relative.is_absolute() or '..' in relative.parts:
            raise ValueError(f'Unsafe relative path: {relative}')
        target = self.home / relative
        # Do not traverse links to another tree when installing a nested file.
        for parent in target.parents:
            if parent == self.home:
                break
            if parent.is_symlink():
                raise ValueError(f'Parent is a symlink; review it before installing: {parent}')
        return target

    def journal(self):
        self.backup_root.mkdir(parents=True, exist_ok=True, mode=0o700)
        os.chmod(self.backup_root, 0o700)
        document = {"home": str(self.home), "entries": self.entries}
        path = self.backup_root / 'manifest.json'
        path.write_text(json.dumps(document, indent=2) + '\n')
        os.chmod(path, 0o600)

    def backup(self, target):
        relative = target.relative_to(self.home)
        existed = target.exists() or target.is_symlink()
        entry = {"path": str(target), "existed": existed, "backup": None, "installed": None}
        if existed:
            saved = self.backup_root / 'files' / relative
            saved.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
            if target.is_symlink():
                saved.symlink_to(os.readlink(target))
            elif target.is_dir():
                shutil.copytree(target, saved, symlinks=True)
            else:
                shutil.copy2(target, saved)
            entry['backup'] = str(saved)
        self.entries.append(entry)
        self.journal()  # Persist the original before changing the destination.
        return entry

    @staticmethod
    def remove(target):
        if target.is_symlink() or target.is_file():
            target.unlink()
        elif target.is_dir():
            shutil.rmtree(target)

    def write(self, relative, content, mode=0o644):
        target = self.destination(relative)
        data = content.encode() if isinstance(content, str) else content
        if target.is_file() and not target.is_symlink() and target.read_bytes() == data and (target.stat().st_mode & 0o777) == mode:
            return
        print(('Would write ' if self.dry_run else 'Write ') + str(target))
        if self.dry_run:
            return
        entry = self.backup(target)
        target.parent.mkdir(parents=True, exist_ok=True)
        descriptor, temporary = tempfile.mkstemp(dir=target.parent)
        try:
            with os.fdopen(descriptor, 'wb') as output:
                output.write(data)
            os.chmod(temporary, mode)
            if target.is_dir() and not target.is_symlink():
                self.remove(target)
            os.replace(temporary, target)
        finally:
            if os.path.exists(temporary):
                os.unlink(temporary)
        entry['installed'] = signature(target)
        self.journal()

    def link(self, relative, source):
        target = self.destination(relative)
        source = Path(source).resolve()
        if target.is_symlink() and target.resolve() == source:
            return
        print(('Would link ' if self.dry_run else 'Link ') + str(target))
        if self.dry_run:
            return
        entry = self.backup(target)
        self.remove(target)
        target.parent.mkdir(parents=True, exist_ok=True)
        target.symlink_to(source)
        entry['installed'] = signature(target)
        self.journal()

    def stow(self, packages):
        pending = []
        for package in packages:
            root = REPO / 'stow' / package
            for source in sorted(root.rglob('*')):
                if not source.is_file():
                    continue
                target = self.destination(source.relative_to(root))
                if target.is_symlink() and target.resolve() == source.resolve():
                    continue
                print(('Would link ' if self.dry_run else 'Link ') + str(target))
                pending.append(target)
        if self.dry_run:
            return
        if not shutil.which('stow'):
            raise RuntimeError('GNU Stow is required. Install packages first.')
        self.home.mkdir(parents=True, exist_ok=True)
        records = []
        for target in pending:
            entry = self.backup(target)
            self.remove(target)
            records.append((target, entry))
        try:
            subprocess.run(['stow', '--dir', str(REPO / 'stow'), '--target', str(self.home), '--no-folding', *packages], check=True)
        finally:
            for target, entry in records:
                entry['installed'] = signature(target)
            if records:
                self.journal()

    def finish(self):
        if self.entries:
            print(f'Backup and rollback manifest: {self.backup_root / "manifest.json"}')
        elif not self.dry_run:
            print('No configuration changes needed.')


def theme_profile():
    theme = json.loads((REPO / 'vscode/pop-bright-theme/themes/pop-bright-color-theme.json').read_text())
    colors = theme['colors']
    profile = json.loads((REPO / 'iterm2/personal-profile.json').read_text())
    selected = profile['Profiles'][0]
    mapping = {'Background Color': 'editor.background', 'Foreground Color': 'editor.foreground', 'Cursor Color': 'terminalCursor.foreground', 'Selection Color': 'editor.selectionBackground'}
    names = ['Black', 'Red', 'Green', 'Yellow', 'Blue', 'Magenta', 'Cyan', 'White']
    for i, name in enumerate(names):
        mapping[f'Ansi {i} Color'] = 'terminal.ansi' + name
        mapping[f'Ansi {i + 8} Color'] = 'terminal.ansiBright' + name
    for field, key in mapping.items():
        value = colors.get(key, colors['editor.foreground'])[:7].lstrip('#')
        selected[field] = {f'{channel} Component': int(value[i:i+2], 16) / 255 for channel, i in [('Red', 0), ('Green', 2), ('Blue', 4)]}
        selected[field]['Color Space'] = 'sRGB'
    return json.dumps(profile, indent=2) + '\n'


def theme_vsix():
    import io
    root = REPO / 'vscode/pop-bright-theme'
    manifest = json.loads((root / 'package.json').read_text())
    xml = f'''<?xml version="1.0" encoding="utf-8"?>
<PackageManifest Version="2.0.0" xmlns="http://schemas.microsoft.com/developer/vsx-schema/2011"><Metadata><Identity Language="en-US" Id="{manifest['name']}" Version="{manifest['version']}" Publisher="{manifest['publisher']}"/><DisplayName>Pop Bright</DisplayName><Description xml:space="preserve">Personal Pop Bright theme</Description><Tags>theme</Tags><Categories>Themes</Categories><GalleryFlags>Public</GalleryFlags><Properties><Property Id="Microsoft.VisualStudio.Code.Engine" Value="{manifest['engines']['vscode']}"/></Properties></Metadata><Installation><InstallationTarget Id="Microsoft.VisualStudio.Code"/></Installation><Dependencies/><Assets><Asset Type="Microsoft.VisualStudio.Code.Manifest" Path="extension/package.json" Addressable="true"/></Assets></PackageManifest>'''
    content_types = '''<?xml version="1.0" encoding="utf-8"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="json" ContentType="application/json"/><Default Extension="md" ContentType="text/markdown"/><Default Extension="xml" ContentType="text/xml"/><Default Extension="vsixmanifest" ContentType="text/xml"/><Default Extension="" ContentType="text/plain"/></Types>'''
    buffer = io.BytesIO()
    with zipfile.ZipFile(buffer, 'w', zipfile.ZIP_DEFLATED) as archive:
        for name, value in [('extension.vsixmanifest', xml), ('[Content_Types].xml', content_types)]:
            info = zipfile.ZipInfo(name, (2026, 1, 1, 0, 0, 0))
            archive.writestr(info, value)
        for path in sorted(root.rglob('*')):
            if path.is_file():
                info = zipfile.ZipInfo('extension/' + str(path.relative_to(root)), (2026, 1, 1, 0, 0, 0))
                archive.writestr(info, path.read_bytes())
    return buffer.getvalue()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--target-home', default=str(Path.home()))
    parser.add_argument('--dry-run', action='store_true')
    parser.add_argument('--packages', action='store_true', help='Handled by install.sh')
    parser.add_argument('--gui', action='store_true', help='Capture/install macOS app configuration')
    parser.add_argument('--plugins', action='store_true', help='Restore Neovim plugins from the lockfile')
    args = parser.parse_args()
    installer = Installer(args.target_home, args.dry_run)
    installer.stow(['zsh', 'bash', 'git', 'tmux', 'nvim', 'bin'])
    if (installer.home / '.dotfiles-internal/install.sh').exists():
        installer.write('.dotfiles-internal/install.sh', '#!/bin/bash\n# Compatibility entry point for the old copied installer.\nexec ' + shlex.quote(str(REPO / 'install.sh')) + ' "$@"\n', 0o755)
    if args.gui:
        installer.write('Library/Application Support/iTerm2/DynamicProfiles/personal-pop-bright.json', theme_profile())
        installer.write('Library/Application Support/Code/User/settings.json', (REPO / 'vscode/settings.personal.jsonc').read_text())
        installer.write('.local/share/dotfiles/pop-bright.vsix', theme_vsix())
        installer.write('.local/share/dotfiles/Personal.code-profile', json.dumps({
            'name': 'Personal', 'settings': (REPO / 'vscode/settings.personal.jsonc').read_text(),
            'extensions': json.dumps([{'identifier': {'id': line}} for line in (REPO / 'vscode/extensions.personal.txt').read_text().splitlines() if line and not line.startswith('#')])
        }, indent=2) + '\n')
    installer.finish()
    if args.plugins and not args.dry_run:
        environment = dict(os.environ, HOME=str(installer.home), XDG_CONFIG_HOME=str(installer.home / '.config'), XDG_DATA_HOME=str(installer.home / '.local/share'), XDG_STATE_HOME=str(installer.home / '.local/state'), XDG_CACHE_HOME=str(installer.home / '.cache'))
        runtime = Installer(installer.home, label='plugins')
        records = []
        for relative in ['.local/share/nvim/lazy', '.local/share/nvim/mason']:
            target = runtime.destination(relative)
            records.append((target, runtime.backup(target)))
        try:
            environment['DOTFILES_OFFLINE'] = '1'
            config = json.dumps(str(REPO / 'stow/nvim/.config/nvim'))
            subprocess.run(['nvim', '--headless', '-u', 'NONE', '--cmd', 'lua vim.opt.rtp:prepend(' + config + ')', '-c', 'lua require("core.plugins")', '+Lazy! restore', '+qa'], env=environment, check=True)
            subprocess.run(['nvim', '--headless', '-c', 'luafile ' + str(REPO / 'scripts/install-language-tools.lua'), '+qa'], env=environment, check=True)
        finally:
            for target, entry in records:
                entry['installed'] = signature(target)
            runtime.journal()
            runtime.finish()


if __name__ == '__main__':
    main()
