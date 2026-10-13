#!/usr/bin/env python3
"""Restore one installer manifest; refuse to discard later edits unless --force."""
import argparse
import json
from pathlib import Path
import shutil
from deploy import Installer, signature

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('manifest', type=Path)
parser.add_argument('--force', action='store_true')
args = parser.parse_args()
document = json.loads(args.manifest.read_text())
for entry in reversed(document['entries']):
    target = Path(entry['path'])
    if not args.force and signature(target) != entry['installed']:
        raise SystemExit(f'Changed since installation; refusing to discard: {target}')
for entry in reversed(document['entries']):
    target = Path(entry['path'])
    Installer.remove(target)
    if entry['existed']:
        saved = Path(entry['backup'])
        target.parent.mkdir(parents=True, exist_ok=True)
        if saved.is_symlink():
            target.symlink_to(saved.readlink())
        elif saved.is_dir():
            shutil.copytree(saved, target, symlinks=True)
        else:
            shutil.copy2(saved, target)
    print(f'Restored {target}')
