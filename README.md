# Bastion Black

A pitch-black theme for people who keep the editor open all day.

The background is true black (`#000000`). Nothing in the syntax palette is pure white or fully saturated — every code color lands between 5.6:1 and 9.3:1 contrast, so no single token pulls your eye harder than the rest. Accents are violet and amber, matching a Hyprland/Waybar-style desktop.

## Palette

| Role | Hex | |
|---|---|---|
| Background | `#000000` | editor, sidebar, panels, terminal |
| Elevated | `#0A0A0D` `#0C0C10` `#141419` | widgets, inputs, hover, selection |
| Borders | `#121218` `#1A1A21` | panel splits, widget outlines |
| Text | `#A9A3B5` | plain identifiers and body text |
| Muted | `#7C7689` `#6A6478` | status bar, comments |
| Faint | `#4A4552` `#3E3947` | punctuation, line numbers, inlay hints |
| Violet | `#C57AD4` `#B77BCC` | cursor, active borders, badges / keywords |
| Amber | `#F5C842` `#C9A94E` | find match, lightbulb / functions |
| Rose | `#C4899B` | strings |
| Periwinkle | `#93A8D9` | numbers, constants, enum members |
| Teal | `#63A39B` | types, classes, interfaces |
| Sea | `#5FA396` | additions, passing tests |
| Red | `#C46A6A` | errors, deletions |
| Mauve | `#8F8296` *italic* | unresolved identifiers |

Syntax roles are separated by hue, not by brightness — that is what keeps it readable without anything glowing at you.

## Unresolved names stand out

Anything the language server resolves gets a real syntax color. Anything it cannot resolve — a typo, a name you never declared, an import you forgot — falls through to dim italic mauve. You see the mistake while you type it, before the squiggle catches up.

This relies on semantic highlighting, so it is sharpest in TypeScript, JavaScript, Rust, Go, and C/C++. Languages whose grammar leaves bare identifiers unscoped (Python among them) show a weaker version of the effect.

Turn it off by pointing the fallback back at the normal foreground:

```jsonc
"editor.tokenColorCustomizations": {
  "[Bastion Black]": {
    "textMateRules": [
      { "scope": ["variable", "identifier"],
        "settings": { "foreground": "#A9A3B5", "fontStyle": "" } }
    ]
  }
}
```

## Two chroma levels

| Variant | Plain text | Syntax band | Use when |
|---|---|---|---|
| **Bastion Black** | 8.6:1 | 5.6 – 9.3:1 | bright rooms, glossy panels, short sessions |
| **Bastion Black Muted** | 7.3:1 | 5.6 – 7.4:1 | dim rooms, OLED, all-day sessions |

The muted variant is not the normal one dimmed. Every colour was converted to OKLCh,
had its chroma cut to 62%, and kept its perceptual lightness — so the colour stops
fringing against pure black while staying just as readable. Only the few colours above
the contrast ceiling were pulled down.

## Re-dialling the muted variant

`tools/retint.py` regenerates the muted theme from the base one. Two numbers control it:

```python
CHROMA  = 0.62   # fraction of the base colourfulness to keep
CEILING = 7.4    # contrast ceiling for ordinary syntax colours
```

Change them and run `python3 tools/retint.py` from the extension root. Below roughly
`CHROMA = 0.35` the hues stop being reliably distinguishable from each other, and below
`CEILING = 4.5` body text drops under the readability floor and starts costing more
strain than the softer colour saves.

## Recommended settings

```jsonc
{
  "workbench.colorTheme": "Bastion Black",
  "editor.fontFamily": "'JetBrains Mono Nerd Font', monospace",
  "editor.fontLigatures": true,
  "editor.fontSize": 14,
  "editor.lineHeight": 1.6,
  "editor.cursorBlinking": "solid",
  "editor.cursorWidth": 2,
  "editor.renderLineHighlight": "all",
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": "active",
  "terminal.integrated.fontFamily": "'JetBrains Mono Nerd Font'",
  "workbench.list.smoothScrolling": true
}
```

## Tweaking without forking

Override anything from your own `settings.json`:

```jsonc
{
  "workbench.colorCustomizations": {
    "[Bastion Black]": {
      "editor.background": "#050507",
      "editorCursor.foreground": "#F5C842"
    }
  },
  "editor.tokenColorCustomizations": {
    "[Bastion Black]": {
      "comments": { "fontStyle": "" }
    }
  }
}
```

Comments are italic by default — the snippet above turns that off.

## License

MIT
