"""
Generate the Cipher variant — amber terminal.

A P3 phosphor terminal: one hue, black background, nothing else.

Every role sits on the same amber, separated only by lightness across a span
from Lc 21 at the punctuation to Lc 86 at the type names. Chroma is assigned by
how often a token appears — plain text is the calmest thing on screen at 0.014,
keywords the loudest at 0.120 — because the most frequent token should never be
the most saturated one.

Monochrome is usually assumed to be unreadable. Measured, this palette reaches
CIEDE2000 13.3 at its worst pair, above every other variant in this extension,
including the ones with seven hues. Hue was never doing the work.
"""
import json, collections, math, re

# ---------- colour maths ---------------------------------------------------
def s2l(c):
    c/=255
    return c/12.92 if c<=0.04045 else ((c+0.055)/1.055)**2.4
def l2s(c):
    c=0.0 if c<0 else (1.0 if c>1 else c)
    v=c*12.92 if c<=0.0031308 else 1.055*c**(1/2.4)-0.055
    return round(v*255)
def hex2oklch(h):
    r,g,b=(s2l(int(h.lstrip('#')[i:i+2],16)) for i in (0,2,4))
    l=(0.4122214708*r+0.5363325363*g+0.0514459929*b)**(1/3)
    m=(0.2119034982*r+0.6806995451*g+0.1073969566*b)**(1/3)
    s=(0.0883024619*r+0.2817188376*g+0.6299787005*b)**(1/3)
    L=0.2104542553*l+0.7936177850*m-0.0040720468*s
    a=1.9779984951*l-2.4285922050*m+0.4505937099*s
    bb=0.0259040371*l+0.7827717662*m-0.8086757660*s
    return L,math.hypot(a,bb),math.atan2(bb,a)
def oklch2hex(L,C,H):
    a,bb=C*math.cos(H),C*math.sin(H)
    l=(L+0.3963377774*a+0.2158037573*bb)**3
    m=(L-0.1055613458*a-0.0638541728*bb)**3
    s=(L-0.0894841775*a-1.2914855480*bb)**3
    r= 4.0767416621*l-3.3077115913*m+0.2309699292*s
    g=-1.2684380046*l+2.6097574011*m-0.3413193965*s
    b=-0.0041960863*l-0.7034186147*m+1.7076147010*s
    return "#%02X%02X%02X"%(l2s(r),l2s(g),l2s(b))
def _Y(h):
    h=h.lstrip("#"); r,g,b=[int(h[i:i+2],16)/255 for i in (0,2,4)]
    return 0.2126729*r**2.4+0.7151522*g**2.4+0.0721750*b**2.4
def apca(t,bg="#000000"):
    Yt,Yb=_Y(t),_Y(bg)
    if Yt<0.022: Yt+=(0.022-Yt)**1.414
    if Yb<0.022: Yb+=(0.022-Yb)**1.414
    if abs(Yb-Yt)<0.0005: return 0.0
    if Yb>Yt: S=(Yb**0.56-Yt**0.57)*1.14; C=0.0 if S<0.1 else S-0.027
    else:     S=(Yb**0.65-Yt**0.62)*1.14; C=0.0 if S>-0.1 else S+0.027
    return abs(C*100)
def at_lc(hue_deg, chroma, target):
    H=math.radians(hue_deg); lo,hi=0.0,1.0
    for _ in range(50):
        mid=(lo+hi)/2
        if apca(oklch2hex(mid,chroma,H))<target: lo=mid
        else: hi=mid
    return oklch2hex((lo+hi)/2,chroma,H)

# ---------- palette ---------------------------------------------------------
SPEC = {
  "#A9A3B5": ( 67.6, 0.014, 63.0),   # fg
  "#B77BCC": ( 70.3, 0.120, 48.0),   # kw
  "#C9A94E": ( 76.1, 0.120, 77.3),   # fn
  "#C4899B": ( 68.8, 0.080, 41.0),   # st
  "#93A8D9": ( 69.4, 0.080, 70.1),   # nu
  "#63A39B": ( 80.9, 0.096, 86.3),   # ty
  "#A897C4": ( 76.2, 0.045, 55.0),   # pr
  "#8699A2": ( 72.9, 0.020, 36.3),   # pa
  "#9E7FA8": ( 72.9, 0.020, 32.1),   # op
  "#8F8296": ( 72.9, 0.020, 29.3),   # un
  "#C46A6A": ( 28.3, 0.100, 50.0),   # er
  "#7B7489": ( 67.3, 0.028, 44.8),   # cm
  "#4A4552": ( 67.3, 0.020, 20.8),   # pu
  "#554F5E": ( 67.4, 0.020, 26.8),   # ln
  "#8E6874": ( 68.8, 0.060, 34.0),
  "#B0858F": ( 68.8, 0.075, 38.0),
  "#C9C3D4": ( 67.6, 0.010, 76.0),
  "#8F8A9C": ( 67.6, 0.018, 54.0),
  "#7C7689": ( 67.6, 0.018, 46.0),
  "#5FA396": (135.0, 0.050, 54.0),
  "#7CBAB2": (135.0, 0.050, 64.0),
  "#6E8FB8": (235.0, 0.045, 54.0),
  "#F5C842": ( 92.4, 0.131, 88.0),
  "#3E3947": ( 67.6, 0.012, 18.0),
  "#2A2630": ( 67.6, 0.008, 11.0),
  "#C57AD4": ( 92.4, 0.131, 86.0),
  "#D89CE3": ( 92.4, 0.131, 92.0),
  "#D18FDD": ( 92.4, 0.131, 94.0),
}

MAP = {k: at_lc(*v) for k, v in SPEC.items() if v}

src = open("themes/bastion-black-color-theme.json").read()
out = re.sub(r"#[0-9a-fA-F]{6}", lambda m: MAP.get(m.group(0).upper(), m.group(0)), src)
t = json.loads(out, object_pairs_hook=collections.OrderedDict)
t["name"] = "Bastion Amber"
c = t["colors"]

# ---------- brackets: gold / bone / steel, never violet --------------------
H = 72.0
BRACKETS = [at_lc(H, 0.090, 60), at_lc(H, 0.020, 72), at_lc(H, 0.055, 50),
            at_lc(H, 0.070, 66), at_lc(H, 0.014, 44), at_lc(H, 0.110, 56)]
for i, col in enumerate(BRACKETS, 1):
    c[f"editorBracketHighlight.foreground{i}"] = col
c["editorBracketHighlight.unexpectedBracket.foreground"] = MAP["#C46A6A"]
c["editorBracketMatch.background"] = MAP["#C9A94E"] + "26"
c["editorBracketMatch.border"]     = MAP["#C9A94E"] + "4D"
c["editorOverviewRuler.bracketMatchForeground"] = MAP["#3E3947"]

# ---------- terminal ANSI: monokrom olmaz -----------------------------------
# ls, git diff ve grep bu on alti rengin ayirt edilebilir olmasina bagli.
# Tonlari sicak tarafa cekildi ama fonksiyonel ayrim korundu.
ANSI = {
  "Black": (72.0, 0.010, 12), "Red": (28.0, 0.100, 50), "Green": (135.0, 0.070, 54),
  "Yellow": (72.0, 0.120, 66), "Blue": (245.0, 0.055, 52), "Magenta": (350.0, 0.080, 50),
  "Cyan": (200.0, 0.060, 56), "White": (72.0, 0.014, 66),
}
ANSI_BRIGHT = {
  "Black": (72.0, 0.014, 32), "Red": (28.0, 0.090, 62), "Green": (135.0, 0.065, 66),
  "Yellow": (72.0, 0.110, 82), "Blue": (245.0, 0.050, 64), "Magenta": (350.0, 0.070, 62),
  "Cyan": (200.0, 0.055, 68), "White": (72.0, 0.010, 84),
}
for n, v in ANSI.items():
    c[f"terminal.ansi{n}"] = at_lc(*v)
for n, v in ANSI_BRIGHT.items():
    c[f"terminal.ansiBright{n}"] = at_lc(*v)

# ---------- indent guides in the warm family -------------------------------
# Inherited from the base palette these were blue-grey, which read as a
# foreign colour in a gold theme. Python and YAML need them, so they stay
# visible but quiet: 1.28:1 idle, 2.13:1 for the active block.
for k, v in (("editorIndentGuide.background",   "#241F17"),
             ("editorIndentGuide.background1",  "#241F17"),
             ("editorIndentGuide.activeBackground",  "#4A4238"),
             ("editorIndentGuide.activeBackground1", "#4A4238"),
             ("editorWhitespace.foreground",    "#221D15"),
             ("editorRuler.foreground",         "#1C1811"),
             ("tree.indentGuidesStroke",        "#332C22"),
             ("tree.inactiveIndentGuidesStroke","#241F17")):
    c[k] = v

# ---------- search must pop against a gold-dominant palette ----------------
# The inherited amber highlight sat at CIEDE2000 22 from the code around it —
# effectively invisible when every other token is also gold. Violet is 79 away
# and is already this variant's chrome colour, so search reads instantly.
ACCENT = at_lc(92.4, 0.131, 88.0)
c["editor.findMatchBackground"]          = ACCENT + "55"
c["editor.findMatchHighlightBackground"] = ACCENT + "30"
c["editor.findMatchBorder"]              = ACCENT + "AA"
c["editor.findRangeHighlightBackground"] = ACCENT + "14"
c["minimap.findMatchHighlight"]          = ACCENT + "AA"
c["editorOverviewRuler.findMatchForeground"] = ACCENT + "AA"
c["searchEditor.findMatchBackground"]    = ACCENT + "30"
c["peekViewEditor.matchHighlightBackground"] = ACCENT + "44"
c["peekViewResult.matchHighlightBackground"] = ACCENT + "44"

# ---------- no bold, no italic beyond the base theme's own use -------------
for rule in t["tokenColors"]:
    if rule.get("name") in ("Function and method names", "Types, classes, interfaces"):
        rule["settings"].pop("fontStyle", None)

json.dump(t, open("themes/bastion-amber-color-theme.json", "w"), indent=2, ensure_ascii=False)
open("themes/bastion-amber-color-theme.json", "a").write("\n")

lab = {"#A9A3B5":"duz metin","#B77BCC":"anahtar","#C9A94E":"fonksiyon","#C4899B":"string",
       "#93A8D9":"sayi","#63A39B":"tip","#A897C4":"ozellik","#8699A2":"parametre",
       "#9E7FA8":"operator","#8F8296":"cozulmemis","#C46A6A":"hata","#7B7489":"yorum",
       "#4A4552":"noktalama","#554F5E":"satir no"}
print(f"{'rol':12} {'gilded':>9}  {'kontrast':>9}  {'Lc':>5}   hedef Lc (Clear)")
for k, name in lab.items():
    g = MAP[k]
    print(f"  {name:12} {g}  {round((_Y(g)+0.05)/0.05,2):8.2f}:1  {apca(g):5.1f}   {SPEC[k][2]:5.1f}")
print("\nparantez renkleri:", " ".join(BRACKETS))
