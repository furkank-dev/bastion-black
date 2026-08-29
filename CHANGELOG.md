# Changelog

## 2.1.0

The extension now ships one theme. Black, Muted, Clear, Gilded, Cipher and Amber
were exploration steps, not products — keeping six near-identical variants in a
picker is clutter, and every one of them was superseded.

- Fixed nine colours in the VS Code theme that the generator had left unmapped
  from the palette it was derived from. The worst was pure white, used eleven
  times in scrollbar and selection overlays, in a theme whose entire premise is
  that nothing on screen is white. Also a violet-grey used for every disabled and
  inactive label, and two stale hover violets from the old accent family.
- Old generator scripts and per-variant kitty and Neovim files removed.

## 2.0.0

Added **Signalman**, built to four priorities in order.

1. Nothing that costs a security engineer. ANSI is left honest — green reads as
   green — because `git diff`, `pytest`, `trivy` and `semgrep` lean on it.
   Comments sit at 5.15:1. Worst semantic pair is CIEDE2000 18.5.
2. Fits the desktop: violet `#C57AD4` carries chrome and never enters the code.
3. Reads as a terminal: black background, amber-dominant, no white.
4. Monochrome as far as the above allow: code hue spans 80–92 only.
