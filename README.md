# Signalman

A single-hue amber theme on true black, with violet chrome.

The code axis spans only hue 80–92. Separation comes from a lightness ladder
running Lc 19 at the punctuation to Lc 88 at the type names, not from colour —
which is why the palette can be monochrome without becoming unreadable. Worst
semantic pair is CIEDE2000 18.5.

## What the colours are doing

| Role | Hex | Contrast |
|---|---|---|
| Types, classes | `#F6DDB3` | 15.9:1 |
| Functions | `#F5CF57` | 14.0:1 |
| Strings | `#DEC472` | 12.2:1 |
| Plain text | `#C2B6A3` | 10.5:1 |
| Numbers, constants | `#DBA21A` | 9.2:1 |
| Keywords | `#C3973E` | 7.8:1 |
| Properties | `#A38F52` | 6.6:1 |
| Comments | `#8C7C5B` | 5.2:1 |
| Errors | `#F0887B` | 8.5:1 |
| Chrome (violet) | `#C57AD4` | 7.1:1 |

Plain text is held at chroma 0.030 — the lowest in the palette — because the
most frequent token on screen should be the calmest thing on it. Keywords and
numbers carry the saturation instead; they are sparse.

Violet appears on the cursor, selection, active line number, search highlight
and tab border. It never enters the code.

## The ANSI palette is left honest

`terminal.ansiGreen` is green and `terminal.ansiRed` is red, at CIEDE2000 101
apart. This breaks the single-hue rule on purpose: `git diff`, `pytest`, `trivy`
and `semgrep` all signal pass and fail through those two slots, and trading a
hardwired red/green reflex for a learned amber/rust one is a worse deal than a
slightly impure palette. Purity is worth something in the editor and nothing in
a scan report.

## Install

**VS Code / VSCodium** — install the `.vsix`, then pick Signalman from the theme
picker.

**kitty** — copy `terminal/signalman.conf` next to `kitty.conf` and add
`include signalman.conf` near the top, above any personal colour overrides.

**Neovim** — copy `nvim/signalman.lua` to `colors/` and
`nvim/signalman-lualine.lua` to `lua/lualine/themes/signalman.lua`.

## License

MIT
