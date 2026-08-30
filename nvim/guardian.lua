-- guardian.lua — Neovim colourscheme (Signalman'in celik varyanti)
--
-- Kod ekseni tek aile: kehribar. Ayrim artik sadece parlaklikla degil,
-- parlaklik x doygunluk x dar bir ton araligiyla (OKLCh hue 46-118) yapiliyor.
-- Chrome mor (#C57AD4) — imlec, secim, aktif satir numarasi. Koda hic girmez.
-- Gutter notr gri: satir numarasi kod degil, arayuz.
-- Terminal ANSI durust birakildi: yesil yesil, kirmizi kirmizi. git diff,
-- pytest, trivy ve semgrep bu ayrima bagli, palet safligindan once gelir.
--
-- 2.2.0 olcumleri (CIEDE2000 ayrim, APCA Lc kontrast, siyah zemin):
--   yan yana gelen token ciftlerinde en dusuk ayrim   0.47 -> 8.28
--   yorum kontrasti                                   Lc 33.7 -> 45.9
--   operator kontrasti                                Lc 32.8 -> 52.6
--
-- Kurulum:
--   lua/signalman.lua                  (modul)
--   colors/guardian.lua               (tek satir: require('guardian').load())
--   lua/lualine/themes/guardian.lua   (lualine)

local M = {}

-- Varsayilanlar. init.lua'dan degistirmek icin:
--   require('guardian').setup({ transparent = false })
M.opts = {
  transparent = false,  -- yuzen pencereler, durum cubugu ve zemin saydam kalir
  cursorline  = true,   -- imlec satirinda cok hafif dolgu (L* +5.6, dikkat dagitmaz)
}

local c = {
  bg        = '#000000',
  bg_elev   = '#08090A',
  bg_line   = '#101214', -- imlec satiri: siyaha gore L* +5.6, gorunur ama sessiz
  bg_sel    = '#24202E',
  border    = '#1E2226',

  fg        = '#C6CACD', -- plain text, bone
  fg_bright = '#E8ECEF',

  -- kod ekseni
  gold      = '#A7B2BD', -- keywords, the eye colour
  gold_pale = '#F7C371', -- functions
  gold_mid  = '#B4BDC4', -- strings (soguk taraf, blok halinde okunur)
  cream     = '#C4A86D', -- numbers, constants (en sicak, en doygun)
  steel     = '#DFE6EC', -- types, classes
  steel_dim = '#8E9DAA', -- properties, object keys
  armour    = '#7E8B92', -- parameters
  unknown   = '#86898C', -- LSP'nin cozemedigi isimler: doygunluk sifirlanir

  -- yapisal eksen (eski surumde altisi da neredeyse ayni renkti, artik degil)
  comment   = '#8D998F', -- Lc 45.9 — geride ama gunduz de okunur
  operator  = '#A1A6AB', -- operator anlam tasir, noktalamadan parlak
  punct     = '#757D84',
  linenr    = '#6F7275', -- notr: gutter arayuzdur, kod degil

  -- regex govdesi ayri ele alinir
  regex      = '#A89C93', -- literal karakterler
  regex_meta = '#DCC58C', -- quantifier, anchor, karakter sinifi, kacis

  violet    = '#C57AD4', -- cursor, active line number, search
  clay      = '#F0887B', -- errors
  sage      = '#58BE6C', -- git added
  info      = '#78A1D5',
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
  local line_bg = M.opts.cursorline and not t and c.bg_line or NONE

  vim.cmd 'highlight clear'
  if vim.fn.exists('syntax_on') == 1 then vim.cmd 'syntax reset' end
  vim.o.background = 'dark'
  vim.o.termguicolors = true
  vim.g.colors_name = 'guardian'

  -- ── editor ──────────────────────────────────────────────────────────
  hl('Normal',        { fg = c.fg, bg = bg(c.bg) })
  hl('NormalNC',      { fg = c.fg, bg = bg(c.bg) })
  hl('NormalFloat',   { fg = c.fg, bg = bg(c.bg_elev) })
  hl('FloatBorder',   { fg = t and '#4A4238' or c.border, bg = bg(c.bg_elev) })
  hl('FloatTitle',    { fg = c.violet, bg = bg(c.bg_elev) })
  hl('Cursor',        { fg = c.bg, bg = c.gold_pale })
  hl('CursorLine',    { bg = line_bg })
  hl('CursorLineNr',  { fg = c.gold_pale, bold = true })
  hl('CursorLineSign',{ bg = line_bg })
  hl('CursorLineFold',{ bg = line_bg })
  hl('LineNr',        { fg = c.linenr })
  hl('LineNrAbove',   { fg = c.linenr })
  hl('LineNrBelow',   { fg = c.linenr })
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
  hl('Comment',       { fg = c.comment })
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
  hl('SpecialChar',   { fg = c.regex_meta })
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
  hl('@string.escape',        { fg = c.regex_meta })
  hl('@string.special',       { fg = c.regex_meta })
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

  -- ── regex ───────────────────────────────────────────────────────────
  -- Neovim once `@capture.dil` adini dener; regex parser'i enjekte edildiginde
  -- asagidaki gruplar sadece regex govdesinde gecerli olur. Literal karakterler
  -- geri cekilir, metakarakterler one cikar — regex okurken goz quantifier ve
  -- anchor arar, harfleri degil.
  hl('@string.regexp',                   { fg = c.regex })
  hl('@string.regex',                    { fg = c.regex })
  hl('@character.regex',                 { fg = c.regex })
  hl('@constant.regex',                  { fg = c.regex })
  hl('@operator.regex',                  { fg = c.regex_meta })  -- * + ? | {n,m}
  hl('@punctuation.bracket.regex',       { fg = c.gold_pale })   -- ( ) [ ]
  hl('@punctuation.delimiter.regex',     { fg = c.gold_pale })
  hl('@punctuation.special.regex',       { fg = c.regex_meta })  -- ^ $ .
  hl('@character.special.regex',         { fg = c.regex_meta })
  hl('@constant.character.escape',       { fg = c.regex_meta })  -- \b \d \w \s
  hl('@constant.character.escape.regex', { fg = c.regex_meta })
  hl('@keyword.regex',                   { fg = c.gold })
  hl('@variable.regex',                  { fg = c.steel_dim })   -- adlandirilmis grup
  hl('@property.regex',                  { fg = c.steel_dim })

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
  hl('@lsp.type.regexp',        { fg = c.regex })
  hl('@lsp.mod.readonly',       { fg = c.cream })

  -- ── diagnostics ─────────────────────────────────────────────────────
  -- Kehribar zeminde tehlike renkleri olculdu (CIEDE2000):
  --   hata vs fonksiyon 39.5 | hata vs sayi 23.9 | bilgi vs kod ekseni > 40
  -- Uyari kasten kehribar ailesinden: uyari kod degil, kodun bir hali.
  hl('DiagnosticError',         { fg = c.clay })
  hl('DiagnosticWarn',          { fg = c.gold_pale })
  hl('DiagnosticInfo',          { fg = c.info })
  hl('DiagnosticHint',          { fg = c.steel })
  hl('DiagnosticOk',            { fg = c.sage })
  hl('DiagnosticUnderlineError',{ sp = c.clay,      undercurl = true })
  hl('DiagnosticUnderlineWarn', { sp = c.gold_pale, undercurl = true })
  hl('DiagnosticUnderlineInfo', { sp = c.info,      undercurl = true })
  hl('DiagnosticUnderlineHint', { sp = c.steel,     undercurl = true })
  hl('DiagnosticUnnecessary',   { fg = c.unknown })

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
  hl('SnacksIndent',       { fg = '#232830' })
  hl('SnacksIndentScope',  { fg = '#4E5661' })
  hl('SnacksIndentChunk',  { fg = '#4E5661' })
  hl('SnacksIndentBlank',  { fg = '#2C261C' })
  hl('IblIndent',          { fg = '#232830' })
  hl('IblScope',           { fg = '#4E5661' })
  hl('IndentBlanklineChar',      { fg = '#3A342A' })
  hl('IndentBlanklineContextChar', { fg = '#6A6052' })

  -- ── diagnostic virtual lines ────────────────────────────────────────
  -- options.lua'da virtual_lines aciktir, bu gruplara gun boyu bakilir
  hl('DiagnosticVirtualLinesError', { fg = c.clay,      bg = '#170A08' })
  hl('DiagnosticVirtualLinesWarn',  { fg = c.gold_pale, bg = '#161006' })
  hl('DiagnosticVirtualLinesInfo',  { fg = c.info,      bg = '#0A0D13' })
  hl('DiagnosticVirtualLinesHint',  { fg = c.steel_dim, bg = c.bg_elev })
  hl('DiagnosticVirtualTextError',  { fg = c.clay })
  hl('DiagnosticVirtualTextWarn',   { fg = c.gold_pale })
  hl('DiagnosticVirtualTextInfo',   { fg = c.info })
  hl('DiagnosticVirtualTextHint',   { fg = c.steel_dim })
  hl('DiagnosticDeprecated',        { fg = c.unknown, strikethrough = true })

  -- ── snacks.picker (LazyVim artik Telescope yerine bunu kullaniyor) ──
  hl('SnacksPickerBorder',    { fg = c.border,    bg = c.bg_elev })
  hl('SnacksPickerTitle',     { fg = c.violet })
  hl('SnacksPickerInput',     { fg = c.fg,        bg = c.bg_sel })
  hl('SnacksPickerInputTitle',{ fg = c.bg,        bg = c.violet })
  hl('SnacksPickerList',      { fg = c.fg,        bg = c.bg_elev })
  hl('SnacksPickerListTitle', { fg = c.violet })
  hl('SnacksPickerMatch',     { fg = c.violet,    bold = true })
  hl('SnacksPickerSelected',  { fg = c.fg_bright, bg = c.bg_sel })
  hl('SnacksPickerDir',       { fg = c.operator })
  hl('SnacksPickerFile',      { fg = c.fg })
  hl('SnacksPickerPreview',   { bg = c.bg })

  -- ── blink.cmp ──────────────────────────────────────────────────────
  hl('BlinkCmpMenu',            { fg = c.fg,        bg = c.bg_elev })
  hl('BlinkCmpMenuBorder',      { fg = c.border,    bg = c.bg_elev })
  hl('BlinkCmpMenuSelection',   { fg = c.fg_bright, bg = c.bg_sel })
  hl('BlinkCmpLabel',           { fg = c.fg })
  hl('BlinkCmpLabelMatch',      { fg = c.violet,    bold = true })
  hl('BlinkCmpLabelDeprecated', { fg = c.unknown,   strikethrough = true })
  hl('BlinkCmpKind',            { fg = c.gold })
  hl('BlinkCmpKindFunction',    { fg = c.gold_pale })
  hl('BlinkCmpKindMethod',      { fg = c.gold_pale })
  hl('BlinkCmpKindVariable',    { fg = c.fg })
  hl('BlinkCmpKindClass',       { fg = c.steel })
  hl('BlinkCmpKindKeyword',     { fg = c.gold })
  hl('BlinkCmpKindText',        { fg = c.fg })
  hl('BlinkCmpKindSnippet',     { fg = c.violet })
  hl('BlinkCmpDoc',             { fg = c.fg,     bg = c.bg_elev })
  hl('BlinkCmpDocBorder',       { fg = c.border, bg = c.bg_elev })
  hl('BlinkCmpSignatureHelp',   { fg = c.fg,     bg = c.bg_elev })
  hl('BlinkCmpSignatureHelpActiveParameter', { fg = c.violet, bold = true })

  -- ── temel eksikler ──────────────────────────────────────────────────
  hl('CursorColumn',  { bg = c.bg_line })
  hl('Substitute',    { fg = c.bg, bg = c.gold_pale })
  hl('QuickFixLine',  { fg = c.fg_bright, bg = c.bg_sel })
  hl('Conceal',       { fg = c.punct })
  hl('MsgArea',       { fg = c.fg })
  hl('MsgSeparator',  { fg = c.border })
  hl('LspCodeLens',   { fg = c.operator })
  hl('LspSignatureActiveParameter', { fg = c.violet, bold = true })

  hl('SpellBad',   { sp = c.clay,      undercurl = true })
  hl('SpellCap',   { sp = c.gold_pale, undercurl = true })
  hl('SpellLocal', { sp = c.info,      undercurl = true })
  hl('SpellRare',  { sp = c.steel_dim, undercurl = true })

  -- ── treesitter tamamlayicilar ───────────────────────────────────────
  hl('@comment.todo',    { fg = c.bg, bg = c.gold_pale, bold = true })
  hl('@comment.note',    { fg = c.bg, bg = c.info,      bold = true })
  hl('@comment.warning', { fg = c.bg, bg = c.gold,      bold = true })
  hl('@comment.error',   { fg = c.bg, bg = c.clay,      bold = true })
  hl('@diff.plus',       { fg = c.sage })
  hl('@diff.minus',      { fg = c.clay })
  hl('@diff.delta',      { fg = c.gold_pale })
  hl('@string.documentation',       { fg = c.gold_mid })
  hl('@variable.parameter.builtin', { fg = c.cream })
  hl('@markup.heading.1', { fg = c.violet,    bold = true })
  hl('@markup.heading.2', { fg = c.steel,     bold = true })
  hl('@markup.heading.3', { fg = c.gold_pale, bold = true })
  hl('@markup.heading.4', { fg = c.gold })
  hl('@markup.heading.5', { fg = c.steel_dim })
  hl('@markup.heading.6', { fg = c.operator })

  -- ── flash.nvim ──────────────────────────────────────────────────────
  -- Atlama etiketleri chrome ailesinden: navigasyon arayuzdur, kod degil.
  -- Etiket en belirgin olan; eslesme bir ton geride, arka plan sonuk.
  hl('FlashBackdrop',   { fg = c.linenr })
  hl('FlashMatch',      { fg = c.bg, bg = c.steel_dim })
  hl('FlashCurrent',    { fg = c.bg, bg = c.gold_pale })
  hl('FlashLabel',      { fg = c.bg, bg = c.violet, bold = true })
  hl('FlashPrompt',     { fg = c.fg, bg = c.bg_elev })
  hl('FlashPromptIcon', { fg = c.violet })
  hl('FlashCursor',     { fg = c.bg, bg = c.violet })

  -- ── terminal palette, matching the kitty config ─────────────────────
  vim.g.terminal_color_0  = '#3E4348'
  vim.g.terminal_color_1  = '#FF7061'
  vim.g.terminal_color_2  = '#58BE6C'
  vim.g.terminal_color_3  = '#F7BD00'
  vim.g.terminal_color_4  = '#78A1D5'
  vim.g.terminal_color_5  = '#CF8FDD'
  vim.g.terminal_color_6  = '#70BCC5'
  vim.g.terminal_color_7  = '#C6CACD'
  vim.g.terminal_color_8  = '#86898C'
  vim.g.terminal_color_9  = '#F6A397'
  vim.g.terminal_color_10 = '#6BD47F'
  vim.g.terminal_color_11 = '#FFD87A'
  vim.g.terminal_color_12 = '#99B7DC'
  vim.g.terminal_color_13 = '#DBB0E5'
  vim.g.terminal_color_14 = '#85D2DB'
  vim.g.terminal_color_15 = '#E8ECEF'
end

-- :SignalmanCheck — token gruplarinin cozulmus renklerini ve siyah zemine gore
-- APCA kontrastini yazar. Tema degistirdiginde "acaba tanimli mi" diye
-- tahmin etmemek icin.
vim.api.nvim_create_user_command('GuardianCheck', function()
  local groups = {
    'Normal', 'Comment', 'Keyword', 'Function', 'String', 'Number', 'Type',
    '@property', '@variable.parameter', '@operator', '@punctuation.bracket',
    '@string.regexp', '@constant.character.escape', 'LineNr', 'CursorLineNr',
    'DiagnosticError', 'DiagnosticWarn', 'DiagnosticInfo', 'DiagnosticHint',
  }
  local function lc(hex)
    local r = tonumber(hex:sub(2, 3), 16) / 255
    local g = tonumber(hex:sub(4, 5), 16) / 255
    local b = tonumber(hex:sub(6, 7), 16) / 255
    local y = 0.2126729 * r ^ 2.4 + 0.7151522 * g ^ 2.4 + 0.0721750 * b ^ 2.4
    y = y > 0.022 and y or y + (0.022 - y) ^ 1.414
    local s = (0.022 ^ 0.56 - y ^ 0.57) * 1.14
    return math.abs(s < 0 and s + 0.027 or s - 0.027) * 100
  end
  local lines = { 'group                          renk       APCA Lc', '' }
  for _, g in ipairs(groups) do
    local h = vim.api.nvim_get_hl(0, { name = g, link = false })
    if h and h.fg then
      local hex = string.format('#%06X', h.fg)
      lines[#lines + 1] = string.format('%-30s %-10s %5.1f', g, hex, lc(hex))
    else
      lines[#lines + 1] = string.format('%-30s %s', g, 'TANIMSIZ')
    end
  end
  lines[#lines + 1] = ''
  lines[#lines + 1] = 'Lc 45+ okunabilir, 60+ govde metni, 30 alti sadece dekor.'
  vim.cmd 'new'
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'wipe'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end, { desc = 'Signalman: token renkleri ve kontrast raporu' })

M.load()
return M
