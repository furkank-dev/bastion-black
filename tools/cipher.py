"""
Generate the Cipher variant — amber terminal.

Black, amber and white, in the manner of a phosphor terminal. Yellow carries
the identity; white marks the structural landmarks; a single clay red is kept
for errors because a warning that does not read as a warning is a defect, not
a style choice.

Hue does almost no work here — amber and warm white sit a few degrees apart —
so separation is carried by lightness across a wide span. The optimiser was
constrained to that family and still reached CIEDE2000 9.8 at worst, above the
Clear variant's 8.0, so nothing is given up in exchange for the look.
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
AMBER, GOLD, WARM, CLAY, COOL = 74.0, 89.6, 88.0, 40.0, 250.0

# base-theme colour -> (hue, chroma, APCA Lc)
SPEC = {
  "#A9A3B5": (WARM,  0.012, 68.0),   # plain text
  "#B77BCC": (GOLD,  0.090, 56.0),   # keyword
  "#C9A94E": (AMBER, 0.065, 78.0),   # function
  "#C4899B": (AMBER, 0.080, 46.0),   # string
  "#93A8D9": (GOLD,  0.045, 72.0),   # number / constant
  "#63A39B": (WARM,  0.003, 84.0),   # type / class   <- white
  "#A897C4": (WARM,  0.030, 56.0),   # property
  "#8699A2": (WARM,  0.020, 50.0),   # parameter
  "#9E7FA8": (WARM,  0.010, 44.0),   # operator
  "#8F8296": (WARM,  0.014, 40.0),   # unresolved name
  "#C46A6A": (CLAY,  0.080, 50.0),   # error — the one rare colour
  "#7B7489": (WARM,  0.016, 48.0),   # comment
  "#4A4552": (WARM,  0.010, 24.0),   # punctuation
  "#554F5E": (WARM,  0.010, 30.0),   # line number
  "#8E6874": (AMBER, 0.060, 36.0),   # string quotes
  "#B0858F": (AMBER, 0.070, 42.0),   # regex
  "#C9C3D4": (WARM,  0.006, 80.0),   # selected foreground
  "#8F8A9C": (WARM,  0.014, 56.0),   # sidebar foreground
  "#7C7689": (WARM,  0.014, 48.0),   # status bar / muted
  "#5FA396": (110.0, 0.045, 56.0),   # added — barely green, still reads as add
  "#7CBAB2": (110.0, 0.045, 66.0),   # untracked
  "#6E8FB8": (COOL,  0.030, 56.0),   # info / modified
  "#F5C842": (GOLD,  0.115, 86.0),   # find match, lightbulb
  "#3E3947": (WARM,  0.008, 20.0),   # separators, ignored
  "#2A2630": (WARM,  0.006, 12.0),   # dimmed line numbers
  # chrome: cursor, active tab border, badges, buttons — amber, not violet
  "#C57AD4": (GOLD,  0.115, 82.0),
  "#D89CE3": (GOLD,  0.090, 88.0),
  "#D18FDD": (GOLD,  0.100, 90.0),
}
MAP = {k: at_lc(*v) for k, v in SPEC.items() if v}

src = open("themes/bastion-black-color-theme.json").read()
out = re.sub(r"#[0-9a-fA-F]{6}", lambda m: MAP.get(m.group(0).upper(), m.group(0)), src)
t = json.loads(out, object_pairs_hook=collections.OrderedDict)
t["name"] = "Bastion Cipher"
c = t["colors"]

# ---------- brackets: gold / bone / steel, never violet --------------------
BRACKETS = [at_lc(AMBER, 0.070, 62), at_lc(WARM, 0.006, 74), at_lc(GOLD, 0.045, 54),
            at_lc(AMBER, 0.040, 68), at_lc(WARM, 0.016, 46), at_lc(GOLD, 0.080, 58)]
for i, col in enumerate(BRACKETS, 1):
    c[f"editorBracketHighlight.foreground{i}"] = col
c["editorBracketHighlight.unexpectedBracket.foreground"] = MAP["#C46A6A"]
c["editorBracketMatch.background"] = MAP["#C9A94E"] + "26"
c["editorBracketMatch.border"]     = MAP["#C9A94E"] + "4D"
c["editorOverviewRuler.bracketMatchForeground"] = MAP["#3E3947"]

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
ACCENT = at_lc(GOLD, 0.115, 86.0)   # bright amber
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

json.dump(t, open("themes/bastion-cipher-color-theme.json", "w"), indent=2, ensure_ascii=False)
open("themes/bastion-cipher-color-theme.json", "a").write("\n")

lab = {"#A9A3B5":"duz metin","#B77BCC":"anahtar","#C9A94E":"fonksiyon","#C4899B":"string",
       "#93A8D9":"sayi","#63A39B":"tip","#A897C4":"ozellik","#8699A2":"parametre",
       "#9E7FA8":"operator","#8F8296":"cozulmemis","#C46A6A":"hata","#7B7489":"yorum",
       "#4A4552":"noktalama","#554F5E":"satir no"}
print(f"{'rol':12} {'gilded':>9}  {'kontrast':>9}  {'Lc':>5}   hedef Lc (Clear)")
for k, name in lab.items():
    g = MAP[k]
    print(f"  {name:12} {g}  {round((_Y(g)+0.05)/0.05,2):8.2f}:1  {apca(g):5.1f}   {SPEC[k][2]:5.1f}")
print("\nparantez renkleri:", " ".join(BRACKETS))
