# Changelog

## 1.0.0

- First public release.
- Muted variant settled at 62% chroma, 7.4:1 ceiling — the 40% pass explored in
  development lost too much hue separation to keep.
- Added `tools/retint.py` so the chroma factor and contrast ceiling can be
  re-dialled and the variant regenerated in one command.

## 0.3.0

- Added **Bastion Black Muted**: the same theme with chroma reduced to 62% in OKLCh,
  perceptual lightness held steady. Removes the halation that saturated colour
  produces against a true-black background without losing contrast.
- Capped the brightest accents: UI amber drops from 13.2:1 to 9.0:1, plain text
  from 8.6:1 to 7.3:1 in the muted variant.
- Both variants ship in the same extension; switch with `Ctrl+K Ctrl+T`.

## 0.2.0

- Dropped the green string color; strings are now rose `#C4899B`.
- Dropped orange; numbers, constants and enum members are now periwinkle `#93A8D9`.
- Additions and passing tests moved to a cooler `#5FA396` so no pistachio green remains anywhere.
- Identifiers with no semantic token now render dim italic mauve `#8F8296`, so unresolved names read differently from resolved ones.

## 0.1.0

- First release.
- True-black workbench with violet (`#C57AD4`) and amber (`#F5C842`) accents.
- Full syntax coverage: TS/JS, JSX/HTML/Vue, Python, Rust, Go, JSON, YAML, Markdown, diffs.
- Semantic highlighting enabled, terminal ANSI palette matched to the theme.
