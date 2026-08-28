# Changelog

## 1.5.2

- Gilded: search highlight moved to violet. The inherited amber highlight sat at
  CIEDE2000 22 from the surrounding code, which is nothing when every token in
  the file is already gold — Ctrl+F results did not stand out. Violet is 79 away
  from the palette's average and is already the variant's chrome colour.
  Applies to find matches, the minimap, the overview ruler and peek views.

## 1.5.1

Gilded rebuilt. The 1.5.0 release did not match what it was designed to be.

- **Brackets are no longer violet.** VS Code colours bracket pairs from a
  six-colour palette, and the first entry had been left as the chrome violet, so
  every parenthesis in the editor was purple. The palette is rebuilt in
  gold / bone / steel; violet now really is confined to cursor, active tab
  border, badges, buttons and the active line number.
- **Brightness matched to Clear.** Every role is now placed at the exact APCA
  lightness of the corresponding role in Clear, so switching between the two
  changes hue and not intensity. Keyword and number had been well above Clear's
  ceiling.
- **Bold and italic removed.** Separation is carried by lightness alone, as in
  the other variants. Worst-case semantic pair is CIEDE2000 10.7, above Clear's
  8.0, with mean chroma 0.063.
- **Terminal green and cyan separated in every variant.** `terminal.ansiGreen`
  and `terminal.ansiCyan` were 6.6 degrees apart in hue and the bright pair was
  byte-identical, which broke `ls`, `git diff` and `grep` output in the
  integrated terminal. Fixed in the base palette, so Black, Muted, Clear and
  Gilded all inherit the fix.

## 1.5.0

Added **Bastion Gilded**, a fourth variant with a different identity from the
other three: black, bone and gold, with violet confined to the chrome.

Its colours were sampled from the desktop it was designed against — gold from
the character's eyes, bone from her skin, steel from her armour, violet from the
mist behind her. The code area never uses violet; it appears only on the cursor,
active tab border, badges, buttons and the active line number.

Gold and bone sit about 40 degrees apart in hue, so hue alone cannot separate
seven token roles. Gilded carries the difference on two other preattentive
channels instead: a wide lightness spread, and font style — functions are bold,
types and classes italic. Worst-case semantic pair is CIEDE2000 8.0, matching
Clear, with mean chroma 0.065.

- `tools/gilded.py` generates the theme from the base palette.
- `terminal/bastion-gilded.conf` is the matching kitty palette.

## 1.4.0

- Added `terminal/` — the Clear palette as a 16-colour ANSI scheme, with configs
  for kitty, foot, alacritty, ghostty, wezterm and Xresources.
- Fixed a collision that only mattered outside the editor: `terminal.ansiGreen`
  and `terminal.ansiCyan` sat 6.6° apart in hue (CIEDE2000 2.2), and the bright
  variants were the same hex. Harmless for syntax, since the syntax palette has
  no green — but it would have made `ls`, `git diff` and `grep` output
  unreadable. Green moved to hue 152°, cyan to 205°, now 14.2 apart.

## 1.3.1

Documentation only — no colour changes, no need to reinstall if you already
have 1.3.0.

- Recommended settings no longer assume a specific font. Ligatures and Medium
  weight are called out as font-dependent, with a check for whether your family
  supports them and what to do instead when it does not.

## 1.3.0

**Bastion Black Clear is now the recommended default.** The other two variants
remain for the cases noted in the README.

- Clear: added APCA floors for the three roles the proportional gain left too
  quiet to read for hours — comments to Lc 48, inactive line numbers to Lc 30,
  punctuation and brackets to Lc 24.
- README now states which variant to pick and why, and includes the editor
  settings that matter more than the palette does.

## 1.2.0

Added **Bastion Black Clear**, a third variant built from published guidance
rather than preference.

Two findings prompted it. First, measured against nine widely used dark themes,
this theme was already the least saturated of the set and among the dimmest —
further muting was pushing past every mainstream reference point. Second, APCA,
the contrast model drafted for WCAG 3, reports that WCAG 2 ratios overstate
contrast for near-black colours and that dark-mode body text generally needs to
be brighter than it looks like it should be. The base theme sat at Lc 54 and the
muted variant at Lc 47, against an APCA body-text minimum of Lc 75.

Clear keeps the desaturation that Material's dark-theme guidance calls for
(chroma x0.80, the lowest factor that holds every semantic token pair at
CIEDE2000 >= 8) and raises main tokens to Lc 68, which puts it in the same
contrast band as Gruvbox and Catppuccin Mocha.

- `tools/clear.py` generates the variant and documents both constants.

## 1.1.0

Readability pass driven by measurement rather than taste.

- Comments raised from 3.71:1 to **4.70:1**. They were below the readability floor,
  which is exactly the kind of thing that costs you on a long session — comments are
  content, not decoration.
- Inactive line numbers raised from 1.88:1 to **2.67:1**, so scanning to a line
  number from a stack trace no longer needs a squint.
- Parameters moved from a near-neutral violet-grey to slate `#8699A2`. They had
  collapsed into the plain foreground: CIEDE2000 distance was 4.1 in the base theme
  and 2.5 in the muted one, meaning parameters and ordinary variables were effectively
  the same colour. Now 14.6 and 8.8.
- Worst-case token pair in the muted variant improved from dE00 2.5 to 5.7; average
  pairwise separation from 17.5 to 18.3.

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
