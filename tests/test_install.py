import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('deploy', ROOT / 'scripts/deploy.py')
deploy = importlib.util.module_from_spec(spec)
spec.loader.exec_module(deploy)


class InstallationTests(unittest.TestCase):
    def test_source_files_are_not_ignored(self):
        files = []
        for directory, directories, names in os.walk(ROOT):
            directories[:] = [name for name in directories if name not in ['.git', '__pycache__', 'node_modules', '.test-results']]
            files += [str((Path(directory) / name).relative_to(ROOT)) for name in names if name != '.DS_Store']
        result = subprocess.run(['git', '-C', str(ROOT), 'check-ignore', *files], capture_output=True, text=True)
        self.assertEqual(result.stdout.strip(), '', 'Required source files must be publishable')

    def test_jsonc_urls_and_nested_merge(self):
        parsed = deploy.jsonc('{"url":"https://example.test",/*comment*/"a":{"x":1,},}')
        self.assertEqual(parsed['url'], 'https://example.test')
        self.assertEqual(deploy.merge(parsed, {'a': {'y': 2}})['a'], {'x': 1, 'y': 2})

    def test_dry_run_changes_nothing(self):
        with tempfile.TemporaryDirectory(prefix='dotfiles test ') as temporary:
            home = Path(temporary)
            (home / '.zshrc').write_text('existing\n')
            subprocess.run([sys.executable, str(ROOT / 'scripts/deploy.py'), '--target-home', temporary, '--gui', '--dry-run'], check=True, stdout=subprocess.DEVNULL)
            self.assertEqual((home / '.zshrc').read_text(), 'existing\n')
            self.assertEqual(sorted(p.name for p in home.iterdir()), ['.zshrc'])

    def test_conflicts_idempotence_and_restore(self):
        with tempfile.TemporaryDirectory(prefix='dotfiles test ') as temporary:
            home = Path(temporary)
            (home / '.zshrc').write_text('original shell\n')
            (home / '.config/unrelated').mkdir(parents=True)
            (home / '.config/unrelated/settings').write_text('keep me')
            command = [sys.executable, str(ROOT / 'scripts/deploy.py'), '--target-home', temporary, '--gui']
            subprocess.run(command, check=True, stdout=subprocess.DEVNULL)
            self.assertTrue((home / '.zshrc').is_symlink())
            self.assertFalse((home / '.config').is_symlink())
            self.assertEqual((home / '.config/unrelated/settings').read_text(), 'keep me')
            self.assertFalse((home / 'Library/Application Support/Code/User/settings.json').is_symlink())
            manifests = list((home / '.dotfiles-backups').glob('*/manifest.json'))
            self.assertEqual(len(manifests), 1)
            subprocess.run(command, check=True, stdout=subprocess.DEVNULL)
            self.assertEqual(list((home / '.dotfiles-backups').glob('*/manifest.json')), manifests)
            (home / 'Library/Application Support/Code/User/settings.json').write_text('later edit')
            restore = [sys.executable, str(ROOT / 'scripts/restore.py'), str(manifests[0])]
            self.assertNotEqual(subprocess.run(restore, capture_output=True).returncode, 0)
            subprocess.run(restore + ['--force'], check=True, stdout=subprocess.DEVNULL)
            self.assertFalse((home / '.zshrc').is_symlink())
            self.assertEqual((home / '.zshrc').read_text(), 'original shell\n')
            self.assertFalse((home / '.p10k.zsh').exists())

    def test_parent_symlink_is_rejected(self):
        with tempfile.TemporaryDirectory() as temporary:
            home = Path(temporary) / 'home'
            outside = Path(temporary) / 'outside'
            home.mkdir()
            outside.mkdir()
            (home / '.config').symlink_to(outside)
            with self.assertRaises(ValueError):
                deploy.Installer(home).write('.config/settings', 'must not escape')
            self.assertEqual(list(outside.iterdir()), [])

    def test_git_checkout_copy_does_not_reset_existing_branch(self):
        with tempfile.TemporaryDirectory() as temporary:
            repo = Path(temporary) / 'repo'
            other = Path(temporary) / 'other'
            subprocess.run(['git', 'init', '-q', '-b', 'main', str(repo)], check=True)
            def git(*arguments):
                return subprocess.run(['git', '-C', str(repo), *arguments], check=True, capture_output=True, text=True).stdout.strip()
            git('-c', 'user.name=Test', '-c', 'user.email=test@example.test', 'commit', '-q', '--allow-empty', '-m', 'initial')
            git('worktree', 'add', '-q', '-b', 'topic', str(other))
            script = ROOT / 'stow/bin/.local/bin/git-co'
            subprocess.run([str(script), 'topic'], cwd=repo, check=True, capture_output=True)
            self.assertEqual(git('branch', '--show-current'), 'topic-wt')
            git('-c', 'user.name=Test', '-c', 'user.email=test@example.test', 'commit', '-q', '--allow-empty', '-m', 'keep')
            saved = git('rev-parse', 'topic-wt')
            git('checkout', '-q', 'main')
            self.assertNotEqual(subprocess.run([str(script), 'topic'], cwd=repo, capture_output=True).returncode, 0)
            self.assertEqual(git('rev-parse', 'topic-wt'), saved)


if __name__ == '__main__':
    unittest.main()
