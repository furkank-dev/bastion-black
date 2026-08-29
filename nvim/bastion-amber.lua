-- bastion-amber.lua — Neovim colourscheme
--
-- The same palette as the Bastion Gilded editor theme and kitty config:
-- black, amber and white in the manner of a phosphor terminal. Yellow carries
-- the identity, white marks structural landmarks, and a single clay red is kept
-- for errors. Separation is carried by lightness, not hue.
--
-- Install: drop this at ~/.config/nvim/colors/bastion-amber.lua and add
--   vim.cmd.colorscheme 'bastion-amber'
-- to your init.lua, or `require('bastion-amber')` if you prefer.

local M = {}

-- Varsayilanlar. init.lua'dan degistirmek icin:
--   require('bastion-amber').setup({ transparent = false })
M.opts = {
  transparent = true,   -- yuzen pencereler, durum cubugu ve zemin saydam kalir
  cursorline  = false,  -- imlec satirinda dolgu yok, sadece satir numarasi vurgulanir
}

local c = {
  bg        = '#000000',
  bg_elev   = '#0A0806',
  bg_line   = '#0B0906',
  bg_sel    = '#14110C',
  border    = '#1E1A13',

  fg        = '#BCB5AD', -- plain text, bone
  fg_bright = '#F2E4CF',
  gold      = '#CB8E3E', -- keywords, the eye colour
  gold_pale = '#FDC572', -- functions
  gold_mid  = '#AE8557', -- strings
  cream     = '#E6BB8B', -- numbers, constants
  steel     = '#FFD894', -- types, classes
  steel_dim = '#B8A589', -- properties, object keys
  armour    = '#8B8277', -- parameters
  unknown   = '#7B7368', -- names the LSP cannot resolve
  comment   = '#A19283',
  operator  = '#82796E',
  punct     = '#695F56',
  linenr    = '#786D63',

  violet    = '#FCDA70', -- cursor, active line number, search
  clay      = '#D9897F', -- errors
  sage      = '#A9B294', -- git added
  info      = '#9CA9BE',
}

M.palette = c

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

function M.setup(o)
  M.opts = vim.tbl_deep_extend('force', M.opts, o or {})
  M.load()
end

function M.load()
  local t = M.opts.transparent
  local NONE = 'NONE'
  local function bg(colour) return t and NONE or colour end

  vim.cmd 'highlight clear'
  if vim.fn.exists 'syntax_on' then vim.cmd 'syntax reset' end
  vim.o.background = 'dark'
  vim.o.termguicolors = true
  vim.g.colors_name = 'bastion-amber'

  -- ── editor ──────────────────────────────────────────────────────────
  hl('Normal',        { fg = c.fg, bg = bg(c.bg) })
  hl('NormalFloat',   { fg = c.fg, bg = bg(c.bg_elev) })
  hl('FloatBorder',   { fg = t and '#4A4238' or c.border, bg = bg(c.bg_elev) })
  hl('FloatTitle',    { fg = c.violet, bg = bg(c.bg_elev) })
  hl('Cursor',        { fg = c.bg, bg = c.violet })
  hl('CursorLine',    { bg = M.opts.cursorline and c.bg_line or NONE })
  hl('CursorLineNr',  { fg = c.violet, bold = false })
  hl('LineNr',        { fg = c.linenr })
  hl('SignColumn',    { bg = bg(c.bg) })
  hl('ColorColumn',   { bg = c.bg_elev })
  hl('Visual',        { bg = '#2E2716' })
  hl('Search',        { fg = c.bg, bg = c.violet })
  hl('IncSearch',     { fg = c.bg, bg = '#FFE9A8' })
  hl('CurSearch',     { fg = c.bg, bg = '#FFE9A8' })
  hl('MatchParen',    { fg = c.gold_pale, bold = true })
  hl('Whitespace',    { fg = '#2C261C' })
  hl('NonText',       { fg = '#332C22' })
  hl('VertSplit',     { fg = c.border })
  hl('WinSeparator',  { fg = c.border })
  hl('Folded',        { fg = c.comment, bg = bg(c.bg_elev) })
  hl('EndOfBuffer',   { fg = t and '#1A1712' or c.bg, bg = bg(c.bg) })

  hl('StatusLine',    { fg = '#9F9A8F', bg = bg(c.bg_elev) })
  hl('StatusLineNC',  { fg = c.punct, bg = bg(c.bg) })
  hl('TabLine',       { fg = c.punct, bg = bg(c.bg) })
  hl('TabLineSel',    { fg = c.fg_bright, bg = c.bg_sel })
  hl('TabLineFill',   { bg = bg(c.bg) })
  hl('WinBar',        { fg = c.fg, bg = bg(c.bg) })
  hl('WinBarNC',      { fg = c.punct, bg = bg(c.bg) })

  hl('Pmenu',         { fg = c.fg, bg = bg(c.bg_elev) })
  hl('PmenuSel',      { fg = c.fg_bright, bg = c.bg_sel })
  hl('PmenuSbar',     { bg = bg(c.bg_elev) })
  hl('PmenuThumb',    { bg = c.border })
  hl('WildMenu',      { fg = c.fg_bright, bg = c.bg_sel })

  hl('Directory',     { fg = c.steel_dim })
  hl('Title',         { fg = c.violet, bold = true })
  hl('Question',      { fg = c.gold })
  hl('MoreMsg',       { fg = c.gold })
  hl('ErrorMsg',      { fg = c.clay })
  hl('WarningMsg',    { fg = c.gold_pale })
  hl('ModeMsg',       { fg = c.fg })

  -- ── classic syntax groups ───────────────────────────────────────────
  hl('Comment',       { fg = c.comment, italic = true })
  hl('Keyword',       { fg = c.gold })
  hl('Statement',     { fg = c.gold })
  hl('Conditional',   { fg = c.gold })
  hl('Repeat',        { fg = c.gold })
  hl('Exception',     { fg = c.gold })
  hl('Include',       { fg = c.gold })
  hl('PreProc',       { fg = c.gold })
  hl('Define',        { fg = c.gold })
  hl('StorageClass',  { fg = c.gold })
  hl('Structure',     { fg = c.gold })
  hl('Operator',      { fg = c.operator })
  hl('Delimiter',     { fg = c.punct })
  hl('Function',      { fg = c.gold_pale })
  hl('Identifier',    { fg = c.fg })
  hl('String',        { fg = c.gold_mid })
  hl('Character',     { fg = c.gold_mid })
  hl('Number',        { fg = c.cream })
  hl('Float',         { fg = c.cream })
  hl('Boolean',       { fg = c.cream })
  hl('Constant',      { fg = c.cream })
  hl('Type',          { fg = c.steel })
  hl('Typedef',       { fg = c.steel })
  hl('Special',       { fg = c.gold_pale })
  hl('SpecialChar',   { fg = '#F0D07C' })
  hl('Todo',          { fg = c.bg, bg = c.gold_pale, bold = true })
  hl('Error',         { fg = c.clay })
  hl('Underlined',    { fg = c.info, underline = true })

  -- ── treesitter ──────────────────────────────────────────────────────
  hl('@comment',              { link = 'Comment' })
  hl('@keyword',              { fg = c.gold })
  hl('@keyword.function',     { fg = c.gold })
  hl('@keyword.return',       { fg = c.gold })
  hl('@keyword.operator',     { fg = c.operator })
  hl('@keyword.import',       { fg = c.gold })
  hl('@conditional',          { fg = c.gold })
  hl('@repeat',               { fg = c.gold })
  hl('@exception',            { fg = c.gold })

  hl('@function',             { fg = c.gold_pale })
  hl('@function.call',        { fg = c.gold_pale })
  hl('@function.builtin',     { fg = c.gold_pale })
  hl('@function.method',      { fg = c.gold_pale })
  hl('@function.method.call', { fg = c.gold_pale })
  hl('@constructor',          { fg = c.steel })

  hl('@string',               { fg = c.gold_mid })
  hl('@string.escape',        { fg = '#F0D07C' })
  hl('@string.special',       { fg = '#F0D07C' })
  hl('@string.regexp',        { fg = '#C4A176' })
  hl('@character',            { fg = c.gold_mid })

  hl('@number',               { fg = c.cream })
  hl('@float',                { fg = c.cream })
  hl('@boolean',              { fg = c.cream })
  hl('@constant',             { fg = c.cream })
  hl('@constant.builtin',     { fg = c.cream })
  hl('@constant.macro',       { fg = c.cream })

  hl('@type',                 { fg = c.steel })
  hl('@type.builtin',         { fg = c.steel })
  hl('@type.definition',      { fg = c.steel })
  hl('@attribute',            { fg = c.gold })
  hl('@module',               { fg = c.steel_dim })
  hl('@namespace',            { fg = c.steel_dim })

  hl('@property',             { fg = c.steel_dim })
  hl('@field',                { fg = c.steel_dim })
  hl('@variable',             { fg = c.fg })
  hl('@variable.builtin',     { fg = c.cream })
  hl('@variable.parameter',   { fg = c.armour })
  hl('@variable.member',      { fg = c.steel_dim })

  hl('@operator',             { fg = c.operator })
  hl('@punctuation',          { fg = c.punct })
  hl('@punctuation.bracket',  { fg = c.punct })
  hl('@punctuation.delimiter',{ fg = c.punct })
  hl('@punctuation.special',  { fg = c.gold_pale })

  hl('@tag',                  { fg = c.gold })
  hl('@tag.attribute',        { fg = c.gold_pale })
  hl('@tag.delimiter',        { fg = c.punct })

  hl('@markup.heading',       { fg = c.violet, bold = true })
  hl('@markup.strong',        { fg = c.fg_bright, bold = true })
  hl('@markup.italic',        { fg = c.fg_bright, italic = true })
  hl('@markup.raw',           { fg = c.gold_mid })
  hl('@markup.link',          { fg = c.info, underline = true })
  hl('@markup.list',          { fg = c.gold_pale })
  hl('@markup.quote',         { fg = c.comment, italic = true })

  -- ── lsp semantic tokens ─────────────────────────────────────────────
  -- Anything the language server resolves gets a real colour here; anything
  -- it cannot resolve falls back to treesitter, which is why unresolved
  -- names read differently. Keep @lsp.type.variable pointing at plain fg.
  hl('@lsp.type.variable',      { fg = c.fg })
  hl('@lsp.type.parameter',     { fg = c.armour })
  hl('@lsp.type.property',      { fg = c.steel_dim })
  hl('@lsp.type.class',         { fg = c.steel })
  hl('@lsp.type.interface',     { fg = c.steel })
  hl('@lsp.type.enum',          { fg = c.steel })
  hl('@lsp.type.enumMember',    { fg = c.cream })
  hl('@lsp.type.function',      { fg = c.gold_pale })
  hl('@lsp.type.method',        { fg = c.gold_pale })
  hl('@lsp.type.namespace',     { fg = c.steel_dim })
  hl('@lsp.type.decorator',     { fg = c.gold })
  hl('@lsp.type.selfKeyword',   { fg = c.cream })
  hl('@lsp.mod.readonly',       { fg = c.cream })

  -- ── diagnostics ─────────────────────────────────────────────────────
  hl('DiagnosticError',        { fg = c.clay })
  hl('DiagnosticWarn',         { fg = c.gold_pale })
  hl('DiagnosticInfo',         { fg = c.info })
  hl('DiagnosticHint',         { fg = c.steel })
  hl('DiagnosticOk',           { fg = c.sage })
  hl('DiagnosticUnderlineError',{ sp = c.clay,      undercurl = true })
  hl('DiagnosticUnderlineWarn', { sp = c.gold_pale, undercurl = true })
  hl('DiagnosticUnderlineInfo', { sp = c.info,      undercurl = true })
  hl('DiagnosticUnderlineHint', { sp = c.steel,     undercurl = true })
  hl('DiagnosticUnnecessary',   { fg = c.punct })

  hl('LspReferenceText',  { bg = c.bg_sel })
  hl('LspReferenceRead',  { bg = c.bg_sel })
  hl('LspReferenceWrite', { bg = '#1E1A22' })
  hl('LspInlayHint',      { fg = '#5A554C', bg = bg(c.bg_elev) })

  -- ── diff and git ────────────────────────────────────────────────────
  hl('DiffAdd',       { bg = '#0F1A0E' })
  hl('DiffChange',    { bg = '#141210' })
  hl('DiffDelete',    { fg = c.clay, bg = '#1A0F0C' })
  hl('DiffText',      { bg = '#2A2318' })
  hl('Added',         { fg = c.sage })
  hl('Changed',       { fg = c.gold_pale })
  hl('Removed',       { fg = c.clay })

  hl('GitSignsAdd',    { fg = c.sage })
  hl('GitSignsChange', { fg = c.gold_pale })
  hl('GitSignsDelete', { fg = c.clay })

  -- ── telescope ───────────────────────────────────────────────────────
  hl('TelescopeNormal',       { fg = c.fg, bg = bg(c.bg_elev) })
  hl('TelescopeBorder',       { fg = t and '#4A4238' or c.border, bg = bg(c.bg_elev) })
  hl('TelescopeTitle',        { fg = c.violet })
  hl('TelescopePromptNormal', { fg = c.fg, bg = c.bg_sel })
  hl('TelescopePromptBorder', { fg = c.bg_sel, bg = c.bg_sel })
  hl('TelescopePromptTitle',  { fg = c.bg, bg = c.violet })
  hl('TelescopeSelection',    { fg = c.fg_bright, bg = c.bg_sel })
  hl('TelescopeMatching',     { fg = c.violet, bold = true })

  -- ── which-key, notify, misc plugins ─────────────────────────────────
  hl('WhichKey',          { fg = c.gold })
  hl('WhichKeyGroup',     { fg = c.steel_dim })
  hl('WhichKeyDesc',      { fg = c.fg })
  hl('WhichKeySeparator', { fg = c.punct })
  hl('WhichKeyFloat',     { bg = bg(c.bg_elev) })

  hl('NvimTreeNormal',      { fg = c.fg, bg = bg(c.bg) })
  hl('NvimTreeFolderName',  { fg = c.steel_dim })
  hl('NvimTreeOpenedFolderName', { fg = c.fg_bright })
  hl('NvimTreeRootFolder',  { fg = c.violet })
  hl('NvimTreeGitDirty',    { fg = c.gold_pale })
  hl('NvimTreeGitNew',      { fg = c.sage })

  -- indent guides — LazyVim uses snacks.indent; indent-blankline names are
  -- kept as a fallback. Raised well above the theme's other structural marks
  -- because indentation carries meaning in Python and YAML.
  hl('SnacksIndent',       { fg = '#3A342A' })
  hl('SnacksIndentScope',  { fg = '#6A6052' })
  hl('SnacksIndentChunk',  { fg = '#6A6052' })
  hl('SnacksIndentBlank',  { fg = '#2C261C' })
  hl('IblIndent',          { fg = '#3A342A' })
  hl('IblScope',           { fg = '#6A6052' })
  hl('IndentBlanklineChar',      { fg = '#3A342A' })
  hl('IndentBlanklineContextChar', { fg = '#6A6052' })

  -- ── terminal palette, matching the kitty config ─────────────────────
  vim.g.terminal_color_0  = '#4E4A44'
  vim.g.terminal_color_1  = '#D9897E'
  vim.g.terminal_color_2  = '#92AF82'
  vim.g.terminal_color_3  = '#ECB060'
  vim.g.terminal_color_4  = '#86A6C2'
  vim.g.terminal_color_5  = '#C88DA9'
  vim.g.terminal_color_6  = '#7AB3B6'
  vim.g.terminal_color_7  = '#C2BBB2'
  vim.g.terminal_color_8  = '#807A72'
  vim.g.terminal_color_9  = '#EBA297'
  vim.g.terminal_color_10 = '#A8C39A'
  vim.g.terminal_color_11 = '#FFCE87'
  vim.g.terminal_color_12 = '#9DBCD6'
  vim.g.terminal_color_13 = '#DBA5BE'
  vim.g.terminal_color_14 = '#94C8CB'
  vim.g.terminal_color_15 = '#DFD9D3'
end

M.load()
return M
