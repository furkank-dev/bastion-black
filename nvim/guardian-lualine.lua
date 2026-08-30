-- lua/lualine/themes/guardian.lua
--
-- Mod rengi = chrome ailesi. Sag taraftaki bilgi bloklari kod ekseninden
-- ayri tutulur: durum cubugu kod degil, arayuz. Bu yuzden b/c bolumleri
-- notr, sadece a (mod) renkli.
local c = {
  bg      = '#000000',
  panel   = '#08090A',
  fg      = '#C6CACD',
  muted   = '#757D84',
  dim     = '#6F7275',
  accent  = '#C57AD4',
  amber   = '#A7B2BD',
  gold    = '#B4BDC4',
  bright  = '#F7C371',
  err     = '#FF7061',
}

return {
  normal = {
    a = { fg = c.bg, bg = c.accent, gui = 'bold' },
    b = { fg = c.fg, bg = c.panel },
    c = { fg = c.muted, bg = 'NONE' },
  },
  insert   = { a = { fg = c.bg, bg = c.bright, gui = 'bold' } },
  visual   = { a = { fg = c.bg, bg = c.gold,   gui = 'bold' } },
  replace  = { a = { fg = c.bg, bg = c.err,    gui = 'bold' } },
  command  = { a = { fg = c.bg, bg = c.amber,  gui = 'bold' } },
  terminal = { a = { fg = c.bg, bg = c.gold,   gui = 'bold' } },
  inactive = {
    a = { fg = c.dim, bg = 'NONE' },
    b = { fg = c.dim, bg = 'NONE' },
    c = { fg = c.dim, bg = 'NONE' },
  },
}
