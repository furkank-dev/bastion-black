# Signalman — terminal

Two files. `signalman.conf` is the kitty palette. `signalman-shell.sh` is
everything the palette cannot reach on its own: the prompt, `LS_COLORS`, man
pages, grep.

## Why the shell file exists

A terminal colour scheme only sets 16 ANSI slots plus foreground, background
and cursor. That covers programs that emit colour. It does not cover the
default bash prompt (which emits none), `ls` without `LS_COLORS`, or `man`,
which is monochrome unless `less` is told otherwise. So an editor can be fully
themed while the terminal beside it stays plain white — the two surfaces stop
looking like one system.

`signalman-shell.sh` closes that gap using the same hex values as the editor:

- **Prompt** keeps the `[user@host dir]$` shape. Brackets take the violet
  chrome, the user the keyword colour, the path the string colour. Added: git
  branch with a `*` when the tree is dirty (unstaged, staged, or untracked),
  and a non-zero exit code in the error colour. All three checks are cheap
  commands; they do not slow the prompt down in a large repo.
- **`LS_COLORS` / `EZA_COLORS`** map file types onto editor token roles.
  Directories take the property colour, executables the function colour,
  archives the number colour, config formats (`yaml`, `tf`, `toml`,
  `Dockerfile`) the keyword colour. Keys and certificates take the error
  colour, because noticing a stray `.pem` in a directory listing is worth a
  slot. Backups and swap files drop to the gutter grey.
- **Man pages and grep** take bold, underline and match highlights from the
  same palette.

## The ANSI palette is left honest

`color2` is green and `color1` is red, at CIEDE2000 101 apart. This breaks the
single-hue rule on purpose: `git diff`, `pytest`, `trivy` and `semgrep` all
signal pass and fail through those two slots. Trading a hardwired red/green
reflex for a learned amber/rust one is a worse deal than a slightly impure
palette.

## Install

kitty — next to `kitty.conf`, above any personal colour overrides:

```
include signalman.conf
```

bash — in `~/.bashrc`:

```sh
[ -f ~/.config/signalman/signalman-shell.sh ] && . ~/.config/signalman/signalman-shell.sh
```

If you already set `PS1` further down in `.bashrc`, move that line after this
one or it will win.
