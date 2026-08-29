-- lua/lualine/themes/signalman.lua
local c = {
  bg      = '#000000',
  panel   = '#0A0806',
  fg      = '#C2B6A3',
  muted   = '#8B7A56',
  dim     = '#7A6B4B',
  accent  = '#C57AD4',
  amber   = '#C3973E',
  gold    = '#DEC472',
  bright  = '#F5CF57',
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
  terminal = { a = { fg = c.bg, bg = c.accent, gui = 'bold' } },
  inactive = {
    a = { fg = c.dim, bg = 'NONE' },
    b = { fg = c.dim, bg = 'NONE' },
    c = { fg = c.dim, bg = 'NONE' },
  },
}
