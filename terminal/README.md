# Bastion Black Clear — terminal palette

The same colours as the editor theme, adapted for a 16-colour ANSI terminal.

Two things differ from the editor palette, both deliberate:

**Green and cyan were pulled apart.** In the editor, green is unused — strings are
rose and "added" states are teal, so green and cyan sat on almost the same hue
(CIEDE2000 2.2, and the bright variants were byte-identical). A terminal cannot
work that way: `ls` colours executables green and symlinks cyan, `git diff` uses
green for additions, `grep` highlights matches in green. Green is now at hue 152°
and cyan at 205°, separated by CIEDE2000 14.2. It is a muted sea green, not the
pistachio that was removed from the syntax palette.

**Bright black was raised** from Lc 24 to Lc 34 (5.2:1). Editors use that slot for
punctuation; terminals use it for secondary text in prompts, `tmux` status lines
and `git log` graphs, where Lc 24 is too quiet to read.

## Palette

| | Colour | Hex | | Colour | Hex |
|---|---|---|---|---|---|
| 0 | black | `#1A1A21` | 8 | bright black | `#807D88` |
| 1 | red | `#CE8483` | 9 | bright red | `#E8A1A0` |
| 2 | green | `#91B79A` | 10 | bright green | `#B0D3B8` |
| 3 | yellow | `#DEC47F` | 11 | bright yellow | `#FFE281` |
| 4 | blue | `#89A4C5` | 12 | bright blue | `#A4BEDF` |
| 5 | magenta | `#C796D8` | 13 | bright magenta | `#D497E0` |
| 6 | cyan | `#85B7BD` | 14 | bright cyan | `#A0D3D9` |
| 7 | white | `#C2BDCB` | 15 | bright white | `#E6E2EC` |

Background `#000000`, foreground `#C2BDCB`, cursor `#D497E0`.

## Install

### kitty

```bash
cp bastion-black.conf ~/.config/kitty/
echo 'include bastion-black.conf' >> ~/.config/kitty/kitty.conf
```

Reload with `ctrl+shift+F5`, or `kill -SIGUSR1 $(pidof kitty)`.

### foot

```bash
cp bastion-black.ini ~/.config/foot/
echo 'include=~/.config/foot/bastion-black.ini' >> ~/.config/foot/foot.ini
```

The `include` line must sit above any `[colors]` section already in `foot.ini`,
or the old one wins. New windows pick it up; existing ones do not.

### alacritty

```bash
cp bastion-black.toml ~/.config/alacritty/
```

Then in `alacritty.toml`:

```toml
[general]
import = ["~/.config/alacritty/bastion-black.toml"]
```

On alacritty older than 0.14 the key is a top-level `import` rather than
`[general] import`.

### ghostty

```bash
cp bastion-black-ghostty ~/.config/ghostty/bastion-black
echo 'config-file = bastion-black' >> ~/.config/ghostty/config
```

### wezterm

```bash
mkdir -p ~/.config/wezterm/colors
cp bastion-black.lua ~/.config/wezterm/colors/
```

Then in `wezterm.lua`:

```lua
config.color_scheme_dirs = { os.getenv('HOME') .. '/.config/wezterm/colors' }
config.color_scheme = 'bastion-black'
```

### xterm / urxvt

```bash
cat bastion-black.Xresources >> ~/.Xresources
xrdb -merge ~/.Xresources
```

## Checking it

```bash
for i in $(seq 0 15); do printf "\033[48;5;${i}m  \033[0m"; done; echo
```

Sixteen swatches, each visibly different from its neighbour.

```bash
ls --color=always /usr/bin | head -40
git log --oneline --graph --decorate | head -20
```

Executables, symlinks and directories should be three obviously different
colours.
