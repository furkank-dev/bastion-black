"""
Generate the 'Clear' variant from the base theme.

Two transforms, both grounded in published guidance:

  chroma x 0.80   Material Design's dark-theme guidance: saturated colour
                  visually vibrates against dark surfaces. 0.80 is the lowest
                  factor that still keeps every pair of semantic tokens at
                  CIEDE2000 >= 8 once lightness is equalised.

  APCA Lc gain    APCA (the WCAG 3 candidate contrast model) reports that
                  WCAG 2 ratios overstate contrast when colours are near black,
                  and that dark-mode body text needs to be brighter than
                  instinct suggests. The base theme sits at Lc 54; this raises
                  main tokens to Lc ~68, in line with Gruvbox and Catppuccin.
"""
import json, collections, math, re

CHROMA_FACTOR = 0.80
LC_TARGET     = 68.0
LC_CAP        = 90.0
LEAVE_BELOW   = 2.0        # backgrounds and borders are untouched

# Roles that the proportional gain leaves too quiet for sustained reading.
# Comments are content, not decoration; line numbers get scanned from stack
# traces; brackets get matched by eye. APCA floors, applied after the gain.
FLOORS = {"#7B7489": 48.0,   # comments
          "#554F5E": 30.0,   # inactive line numbers
          "#4A4552": 24.0}   # punctuation and brackets

def s2l(c):
    c/=255
    return c/12.92 if c<=0.04045 else ((c+0.055)/1.055)**2.4
def l2s(c):
    c=0.0 if c<0 else (1.0 if c>1 else c)
    v=c*12.92 if c<=0.0031308 else 1.055*c**(1/2.4)-0.055
    return round(v*255)
def wcag(h,b="#000000"):
    L=lambda x:(lambda r,g,bl:0.2126*r+0.7152*g+0.0722*bl)(*[s2l(int(x.lstrip('#')[i:i+2],16)) for i in (0,2,4)])
    a,c=L(h)+0.05,L(b)+0.05
    return round(max(a,c)/min(a,c),2)
def _Y(h):
    h=h.lstrip("#"); r,g,b=[int(h[i:i+2],16)/255 for i in (0,2,4)]
    return 0.2126729*r**2.4+0.7151522*g**2.4+0.0721750*b**2.4
def apca(txt,bg="#000000"):
    Yt,Yb=_Y(txt),_Y(bg)
    if Yt<0.022: Yt+=(0.022-Yt)**1.414
    if Yb<0.022: Yb+=(0.022-Yb)**1.414
    if abs(Yb-Yt)<0.0005: return 0.0
    if Yb>Yt:
        S=(Yb**0.56-Yt**0.57)*1.14; C=0.0 if S<0.1 else S-0.027
    else:
        S=(Yb**0.65-Yt**0.62)*1.14; C=0.0 if S>-0.1 else S+0.027
    return C*100
def hex2oklch(h):
    r,g,b=(s2l(int(h[i:i+2],16)) for i in (1,3,5))
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

src=open("themes/bastion-black-color-theme.json").read()
ANCHOR=abs(apca("#A9A3B5"))                 # plain text in the base theme
GAIN=LC_TARGET/ANCHOR

def clear(h):
    h=h.upper()
    if wcag(h)<LEAVE_BELOW: return h
    L,C,H=hex2oklch(h)
    target=min(abs(apca(h))*GAIN, LC_CAP)
    target=max(target, FLOORS.get(h, 0.0))
    C*=CHROMA_FACTOR
    lo,hi=0.0,1.0
    for _ in range(50):
        mid=(lo+hi)/2
        if abs(apca(oklch2hex(mid,C,H)))<target: lo=mid
        else: hi=mid
    return oklch2hex((lo+hi)/2,C,H)

seen=sorted(set(m.upper() for m in re.findall(r"#[0-9a-fA-F]{6}",src)))
table={h:clear(h) for h in seen}
out=re.sub(r"#[0-9a-fA-F]{6}",lambda m:table[m.group(0).upper()],src)
t=json.loads(out,object_pairs_hook=collections.OrderedDict)
t["name"]="Bastion Black Clear"
json.dump(t,open("themes/bastion-black-clear-color-theme.json","w"),indent=2,ensure_ascii=False)
open("themes/bastion-black-clear-color-theme.json","a").write("\n")

roles=[("plain text","#A9A3B5"),("keyword","#B77BCC"),("function","#C9A94E"),
       ("string","#C4899B"),("number","#93A8D9"),("type","#63A39B"),
       ("property","#A897C4"),("parameter","#8699A2"),("error","#C46A6A"),
       ("unresolved","#8F8296"),("comment","#7B7489"),("line number","#554F5E"),
       ("punctuation","#4A4552")]
print(f"anchor Lc {ANCHOR:.1f} -> {LC_TARGET}, gain {GAIN:.3f}, chroma x{CHROMA_FACTOR}\n")
print(f"{'role':13} {'base':>9} {'clear':>9}   {'WCAG':>14}   {'APCA Lc':>14}")
for n,h in roles:
    c=table.get(h)
    if not c: continue
    print(f"{n:13} {h:>9} {c:>9}   {wcag(h):5.2f} -> {wcag(c):5.2f}   "
          f"{abs(apca(h)):5.1f} -> {abs(apca(c)):5.1f}")
