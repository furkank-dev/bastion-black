-- lua/lualine/themes/signalman.lua
--
-- Mod rengi = chrome ailesi. Sag taraftaki bilgi bloklari kod ekseninden
-- ayri tutulur: durum cubugu kod degil, arayuz. Bu yuzden b/c bolumleri
-- notr, sadece a (mod) renkli.
local c = {
  bg      = '#000000',
  panel   = '#0A0806',
  fg      = '#C4B9A7',
  muted   = '#877E68',
  dim     = '#737068',
  accent  = '#C57AD4',
  amber   = '#B69507',
  gold    = '#C7BE83',
  bright  = '#F7D856',
  err     = '#F0887B',
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
