import json, collections, math, re

# ---------- sRGB <-> OKLab -------------------------------------------------
def s2l(c):
    c /= 255
    return c/12.92 if c <= 0.04045 else ((c+0.055)/1.055)**2.4
def l2s(c):
    c = 0.0 if c < 0 else (1.0 if c > 1 else c)
    v = c*12.92 if c <= 0.0031308 else 1.055*c**(1/2.4)-0.055
    return round(v*255)

def hex2oklch(h):
    r,g,b = (s2l(int(h[i:i+2],16)) for i in (1,3,5))
    l = (0.4122214708*r + 0.5363325363*g + 0.0514459929*b) ** (1/3)
    m = (0.2119034982*r + 0.6806995451*g + 0.1073969566*b) ** (1/3)
    s = (0.0883024619*r + 0.2817188376*g + 0.6299787005*b) ** (1/3)
    L = 0.2104542553*l + 0.7936177850*m - 0.0040720468*s
    a = 1.9779984951*l - 2.4285922050*m + 0.4505937099*s
    bb= 0.0259040371*l + 0.7827717662*m - 0.8086757660*s
    return L, math.hypot(a, bb), math.atan2(bb, a)

def oklch2hex(L, C, H):
    a, bb = C*math.cos(H), C*math.sin(H)
    l = (L + 0.3963377774*a + 0.2158037573*bb) ** 3
    m = (L - 0.1055613458*a - 0.0638541728*bb) ** 3
    s = (L - 0.0894841775*a - 1.2914855480*bb) ** 3
    r =  4.0767416621*l - 3.3077115913*m + 0.2309699292*s
    g = -1.2684380046*l + 2.6097574011*m - 0.3413193965*s
    b = -0.0041960863*l - 0.7034186147*m + 1.7076147010*s
    return "#%02X%02X%02X" % (l2s(r), l2s(g), l2s(b))

def contrast(h):
    r,g,b = (s2l(int(h[i:i+2],16)) for i in (1,3,5))
    return (0.2126*r + 0.7152*g + 0.0722*b + 0.05) / 0.05

# ---------- the mute pass --------------------------------------------------
CHROMA = 0.62          # keep 62% of the colourfulness
CEILING = 7.4          # contrast ceiling for ordinary syntax colours
FLOOR   = 1.9          # below this the colour is already a whisper: leave it

SPECIAL = {"#F5C842": 9.0, "#C9C3D4": 9.6, "#A9A3B5": 7.3}   # per-colour ceilings

def mute(h):
    h = h.upper()
    cur = contrast(h)
    if cur < FLOOR:
        return h
    L, C, H = hex2oklch(h)
    C *= CHROMA
    target = min(cur, SPECIAL.get(h, CEILING))
    lo, hi = 0.0, L
    for _ in range(40):                       # bisect L to hit the target
        mid = (lo + hi) / 2
        if contrast(oklch2hex(mid, C, H)) < target: lo = mid
        else: hi = mid
    return oklch2hex((lo + hi) / 2, C, H)

# ---------- build the muted variant ---------------------------------------
src = open("themes/bastion-black-color-theme.json").read()
seen = sorted(set(m.upper() for m in re.findall(r"#[0-9a-fA-F]{6}", src)))
table = {h: mute(h) for h in seen}

out = re.sub(r"#[0-9a-fA-F]{6}", lambda m: table[m.group(0).upper()], src)
t = json.loads(out, object_pairs_hook=collections.OrderedDict)
t["name"] = "Bastion Black Muted"
json.dump(t, open("themes/bastion-black-muted-color-theme.json", "w"), indent=2, ensure_ascii=False)
open("themes/bastion-black-muted-color-theme.json", "a").write("\n")

roles = [("plain text","#A9A3B5"),("keyword","#B77BCC"),("accent violet","#C57AD4"),
         ("function amber","#C9A94E"),("ui amber","#F5C842"),("string rose","#C4899B"),
         ("number periwinkle","#93A8D9"),("type teal","#63A39B"),("property lavender","#A897C4"),
         ("parameter slate","#8699A2"),("error red","#C46A6A"),("unresolved","#8F8296"),
         ("comment","#7B7489"),("line number","#554F5E")]
print(f"{'role':20} {'before':>9} {'after':>9}   contrast")
for name, h in roles:
    n = table.get(h)
    if n is None:                       # colour no longer present in the theme
        print(f"{name:20} {h:>9}   (not in theme any more)")
        continue
    print(f"{name:20} {h:>9} {n:>9}   {contrast(h):5.2f} -> {contrast(n):5.2f}")
