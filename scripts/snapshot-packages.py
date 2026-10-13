#!/usr/bin/env python3
"""Save package inventory, trust settings, and existing JDK destinations before installs."""
import argparse
import datetime
import json
import os
from pathlib import Path
import shutil
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--jdks', action='store_true')
args = parser.parse_args()
home = Path.home()
stamp = datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%d-%H%M%S-%f')
root = home / '.dotfiles-backups' / ('packages-' + stamp)
root.mkdir(parents=True, mode=0o700)
os.chmod(root, 0o700)
for label, command in [('formulae', ['brew', 'list', '--formula', '--versions']), ('casks', ['brew', 'list', '--cask', '--versions']), ('homebrew', ['brew', '--version'])]:
    (root / (label + '.txt')).write_text(subprocess.check_output(command, text=True))
trust = home / '.homebrew/trust.json'
if trust.exists():
    shutil.copy2(trust, root / 'trust.json')
entries = []
if args.jdks:
    for version in ['17', '21']:
        path = Path('/Library/Java/JavaVirtualMachines') / f'temurin-{version}.jdk'
        entry = {'path': str(path), 'existed': path.exists(), 'backup': None}
        if path.exists():
            saved = root / path.name
            shutil.copytree(path, saved, symlinks=True)
            entry['backup'] = str(saved)
        entries.append(entry)
(root / 'jdk-manifest.json').write_text(json.dumps(entries, indent=2) + '\n')
print('Pre-install package/JDK snapshot: ' + str(root))
