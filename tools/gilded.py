"""
Generate the Gilded variant.

Identity comes from the desktop it was designed against: gold from the
character's eyes, bone from her skin, steel from her armour, violet from the
mist. Violet appears only in chrome — cursor, active tab border, badges,
buttons, active line number. It never enters the code area, which is why the
bracket-pair palette is rebuilt in the gold/bone/steel family rather than
inherited.

Every role is placed at the same APCA lightness as the corresponding role in
Clear, so the two variants sit in the same brightness band and swapping between
them changes hue, not intensity. No bold or italic is used; separation is
carried by lightness alone.
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

# ---------- hues measured off the wallpaper --------------------------------
GOLD, BONE, STEEL, ARMOUR, CLAY = 89.6, 88.0, 255.0, 298.7, 40.0

# base-theme colour -> (hue, chroma, Clear's APCA Lc for that role)
SPEC = {
  "#A9A3B5": (BONE,   0.022, 68.1),   # plain text
  "#B77BCC": (GOLD,   0.115, 55.0),   # keyword          <- eye gold, Clear's Lc
  "#C9A94E": (78.0,   0.080, 72.3),   # function
  "#C4899B": (78.0,   0.100, 59.6),   # string
  "#93A8D9": (GOLD,   0.050, 69.7),   # number / constant
  "#63A39B": (STEEL,  0.055, 58.7),   # type / class
  "#A897C4": (STEEL,  0.020, 63.3),   # property
  "#8699A2": (ARMOUR, 0.022, 57.6),   # parameter
  "#9E7FA8": (BONE,   0.014, 50.0),   # operator
  "#8F8296": (ARMOUR, 0.022, 47.6),   # unresolved name
  "#C46A6A": (CLAY,   0.080, 46.7),   # error
  "#7B7489": (BONE,   0.020, 48.0),   # comment
  "#4A4552": (BONE,   0.012, 24.2),   # punctuation
  "#554F5E": (BONE,   0.012, 29.8),   # line number
  "#8E6874": (78.0,   0.070, 42.0),   # string quotes
  "#B0858F": (70.0,   0.070, 55.0),   # regex
  "#C9C3D4": (BONE,   0.016, 76.0),   # selected foreground
  "#8F8A9C": (BONE,   0.018, 58.0),   # sidebar foreground
  "#7C7689": (BONE,   0.018, 48.0),   # status bar / muted
  "#5FA396": (135.0,  0.045, 58.0),   # added / passing
  "#7CBAB2": (135.0,  0.045, 68.0),   # untracked
  "#6E8FB8": (STEEL,  0.045, 58.0),   # info / modified
  "#F5C842": (GOLD,   0.110, 80.0),   # find match, lightbulb
  "#3E3947": (BONE,   0.010, 20.0),   # separators, ignored
  "#2A2630": (BONE,   0.008, 12.0),   # dimmed line numbers
  # bracket pair colours — rebuilt in-family so no violet reaches the code
  "#C57AD4": None,                    # handled separately (chrome)
}
MAP = {k: at_lc(*v) for k, v in SPEC.items() if v}

src = open("themes/bastion-black-color-theme.json").read()
out = re.sub(r"#[0-9a-fA-F]{6}", lambda m: MAP.get(m.group(0).upper(), m.group(0)), src)
t = json.loads(out, object_pairs_hook=collections.OrderedDict)
t["name"] = "Bastion Gilded"
c = t["colors"]

# ---------- brackets: gold / bone / steel, never violet --------------------
BRACKETS = [at_lc(78.0,  0.080, 64), at_lc(BONE,  0.018, 70), at_lc(STEEL, 0.050, 58),
            at_lc(GOLD,  0.045, 74), at_lc(STEEL, 0.020, 52), at_lc(70.0,  0.070, 60)]
for i, col in enumerate(BRACKETS, 1):
    c[f"editorBracketHighlight.foreground{i}"] = col
c["editorBracketHighlight.unexpectedBracket.foreground"] = MAP["#C46A6A"]
c["editorBracketMatch.background"] = MAP["#C9A94E"] + "26"
c["editorBracketMatch.border"]     = MAP["#C9A94E"] + "4D"
c["editorOverviewRuler.bracketMatchForeground"] = MAP["#3E3947"]

# ---------- search must pop against a gold-dominant palette ----------------
# The inherited amber highlight sat at CIEDE2000 22 from the code around it —
# effectively invisible when every other token is also gold. Violet is 79 away
# and is already this variant's chrome colour, so search reads instantly.
VIOLET = "#C57AD4"
c["editor.findMatchBackground"]          = VIOLET + "59"
c["editor.findMatchHighlightBackground"] = VIOLET + "33"
c["editor.findMatchBorder"]              = VIOLET + "99"
c["editor.findRangeHighlightBackground"] = VIOLET + "14"
c["minimap.findMatchHighlight"]          = VIOLET + "AA"
c["editorOverviewRuler.findMatchForeground"] = VIOLET + "AA"
c["searchEditor.findMatchBackground"]    = VIOLET + "33"
c["peekViewEditor.matchHighlightBackground"] = VIOLET + "44"
c["peekViewResult.matchHighlightBackground"] = VIOLET + "44"

# ---------- no bold, no italic beyond the base theme's own use -------------
for rule in t["tokenColors"]:
    if rule.get("name") in ("Function and method names", "Types, classes, interfaces"):
        rule["settings"].pop("fontStyle", None)

json.dump(t, open("themes/bastion-gilded-color-theme.json", "w"), indent=2, ensure_ascii=False)
open("themes/bastion-gilded-color-theme.json", "a").write("\n")

lab = {"#A9A3B5":"duz metin","#B77BCC":"anahtar","#C9A94E":"fonksiyon","#C4899B":"string",
       "#93A8D9":"sayi","#63A39B":"tip","#A897C4":"ozellik","#8699A2":"parametre",
       "#9E7FA8":"operator","#8F8296":"cozulmemis","#C46A6A":"hata","#7B7489":"yorum",
       "#4A4552":"noktalama","#554F5E":"satir no"}
print(f"{'rol':12} {'gilded':>9}  {'kontrast':>9}  {'Lc':>5}   hedef Lc (Clear)")
for k, name in lab.items():
    g = MAP[k]
    print(f"  {name:12} {g}  {round((_Y(g)+0.05)/0.05,2):8.2f}:1  {apca(g):5.1f}   {SPEC[k][2]:5.1f}")
print("\nparantez renkleri:", " ".join(BRACKETS))
