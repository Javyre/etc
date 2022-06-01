vim.o.background = 'dark'
vim.g.colors_name = 'toni'

--[[
    #FFFFFF
    #E0E0E0
    #C5C8C6
    #969896
    #373B41
    #282A2E
    #1D1F21
    #131416

    #CC6666
    #DE935F
    #FFCC66 #FFE792
    #B5BD68
    #8ABEB7
    #81A2BE
    #B294BB #C4A3CF
]]

local hsl_to_rgb = function(h, s, l)
    if s == 0 then return l, l, l end
    h, s, l = h / 360 * 6, s / 100, l / 100
    local c = (1 - math.abs(2 * l - 1)) * s
    local x = (1 - math.abs(h % 2 - 1)) * c
    local m, r, g, b = (l - .5 * c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return math.ceil((r + m) * 0xFF), math.ceil((g + m) * 0xFF),
           math.ceil((b + m) * 0xFF)
end
local hsl = function(h, s, l)
    local r, g, b = hsl_to_rgb(h, s, l)
    return string.format('#%02X%02X%02X', r, g, b)
end

local process_line = function(line)
    local expr = string.match(line, '#......[^#]*<<==%s*(.+)%s*$')
    if not expr then return line end

    local repl = loadstring('local hsl = require"toni".hsl; return ' .. expr)
    if not repl then return line end

    local succ, repl = pcall(repl)
    if not succ then return line end

    repl = tostring(repl)
    if #repl ~= 7 then return line end

    return string.gsub(line, '#......([^#]*<<==.*)$', repl .. '%1')
end

local start_preview = function()
    print('begin preview')
    local detach = false
    vim.keymap.set('n', '<LocalLeader>k', function()
        detach = true
        print('done preview')
    end, {buffer = true})
    vim.schedule(function()
        vim.api.nvim_buf_attach(0, false, {
            on_lines = function(_, buf, _, first, last, new_last)
                if detach then return true end

                local lines = vim.api.nvim_buf_get_lines(buf, first, new_last,
                                                         true)

                local changed = false
                for i, line in ipairs(lines) do
                    lines[i] = process_line(line)
                    if line ~= lines[i] then changed = true end
                end
                if changed then
                    vim.schedule(function()
                        vim.api.nvim_buf_set_lines(buf, first, new_last, false,
                                                   lines)
                    end)
                end
            end
        })
    end)
end
vim.keymap.set('n', '<LocalLeader>k', start_preview)

-- print(hsl(40, 100, 73))

-- LuaFormatter off
local colors = {
    white       = '#FFFFFF',
    -- grey_1      = '#E0E0E0',
    grey_1      = '#C5C8C6',
    grey_2      = '#969896',
    -- grey_2      = '#C5C8C6',
    -- grey_3      = '#969896',
    grey_3      = '#656A72', -- <<== hsl(216, 6, 42)
    grey_4      = '#3B3F45', -- <<== hsl(216, 8, 25)
    grey_5      = '#282A2E',
    grey_6      = '#1D1F21',
    grey_7      = '#17191A', -- <<== hsl(210, 7, 9.5)
    red         = '#CC6666', -- #CC6666 <<== hsl(0,   50,  60)
    bright_red  = '#E96363', -- #E96363 <<== hsl(0,   75,  65)
    orange      = '#DE935F', -- #DF945F <<== hsl(25,  66,  62)
    yellow      = '#FFD276', -- #FFD276 <<== hsl(40,  100, 73)
    light_yellow = '#E3C68D', -- ...... <<== hsl(40,  60,  72)
    lighter_yellow = '#FFE6B3', -- ...... <<== hsl(40, 100, 85)
    green       = '#B5BD68', -- #B4BD67 <<== hsl(66,  39,  57)
    cyan        = '#87EEE1', -- 91E4D9 <<== hsl(172, 75,  73)
    blue        = '#98AFDD', -- #98AFDD <<== hsl(220, 50,  73)
    bright_blue = '#6699FF', -- ....... <<== hsl(220, 100,  70)
    purple      = '#C89FD6', -- #C89FD6 <<== hsl(285, 40,  73)
    brown       = '#A3685A', -- #A56A5B <<== hsl(12,  29,  50)
}
-- LuaFormatter on

colors.normal_fg = colors.white
colors.normal_bg = colors.grey_6

-- LuaFormatter off
local groups = {
    Normal       = {fg = colors.normal_fg, bg = colors.normal_bg},
    Visual       = { bg=colors.grey_4 },
    VisualNOS    = { link = 'Visual' },
    Comment      = {fg = colors.grey_2},
    NonText      = {fg = colors.grey_4},
    CursorColumn = {bg = colors.grey_5},
    CursorLine   = {bg = colors.grey_5},
    ColorColumn  = {bg = colors.grey_7},
    Directory    = {fg = colors.green},

    -- LANG
    Constant         = { fg = colors.purple },
    String           = { fg = colors.light_yellow },
    Character        = { link = 'String' },
    Identifier       = { link = 'Normal' },
    Statement        = { fg = colors.yellow,   bold = true },
    Operator         = { link = 'Normal' },
    Keyword          = { link = 'Statement' },
    Exception        = { link = 'Statement' },
    PreProc          = { fg = colors.purple,   bold = false },
    Type             = { fg = colors.cyan },
    StorageClass     = { fg = colors.orange,   italic = true },
    Special          = { copy = 'Type',        italic = true },
    SpecialChar      = { fg = colors.red },
    Tag              = { fg = colors.red,      italic = true },
    Delimiter        = { link = 'Comment' },
    SpecialComment   = { copy = 'Comment',     bold = true },
    Underlined       = { fg=colors.bright_blue,       underline = true },
    Error            = { fg=colors.normal_bg,  bg = '#C82829', bold = true },
    Todo             = { fg=colors.normal_fg,  bold = true },

    TSNamespace      = { copy = 'Type',        bold = true },
    TSPunctDelimiter = { link = 'Delimiter' },
    TSPunctBracket   = { link = 'Delimiter' },
    TSPunctSpecial   = { link = 'Delimiter' },
    
    -- VCS
    DiffAdd     = { bg = colors.blue },
    DiffChange  = { bg = colors.purple },
    DiffDelete  = { bg = colors.red },
    DiffText    = { fg = colors.normal_bg, bg = colors.blue, italic = true },
    diffLine    = { fg = colors.yellow },
    diffAdded   = { fg = colors.cyan },
    diffRemoved = { fg = colors.bright_red },
    fugitiveHunk = { fg = colors.grey_1 },
    fugitiveHash = {fg = colors.orange },
    FugitiveblameHash  = {link = 'fugitiveHash'},

    -- UI
    Ignore       = { fg=colors.grey_4 },
    LineNr       = { link='NonText' },
    CursorLineNr = { copy='CursorLine', fg=colors.yellow },
    MatchParen   = { fg=colors.bright_red, bg=colors.grey_7, bold=true },
    Search       = { fg='black', bg=colors.lighter_yellow },
    IncSearch    = { fg='black', bg=colors.bright_blue },
    Substitute   = { link='Search' },
    Pmenu        = { fg=colors.normal_fg, bg=colors.grey_5 },
    PmenuSel     = { fg=colors.normal_fg, bg=colors.grey_4 },
    PmenuSbar    = { bg=colors.normal_bg },
    PmenuThumb   = { bg=colors.grey_4 },
    CmpItemAbbrMatch = { fg=colors.purple, bold=true },
    CmpItemAbbrMatchFuzzy = { link='CmpItemAbbrMatch'},
    CmpItemKind  = { link='Type' },
    StatusLine   = { link='ColorColumn' },
    StatusLineNC = { copy='ColorColumn', fg=colors.grey_3 },
    TabLine      = { link='Pmenu' },
    TabLineSel   = { link='PmenuSel' },
    TabLineFill  = { link='StatusLine' },
    WildMenu     = { link='PmenuSel' },
    VertSplit    = { link='NonText' },
    Folded       = { link='NonText' },
    FoldColumn   = { link='NonText' },
    -- SignColumn   = { },
    QuickFixLine = { link='CursorLine' },
    SpecialKey   = { link='NonText' },
    Title        = { fg=colors.blue, bold=true },
    WarningMsg   = { copy='CursorColumn', bold=true },
    Question     = { fg=colors.blue, italic=true },
    MoreMsg      = { Question },
    ErrorMsg     = { fg=colors.red, bold=true },
    ModeMsg      = { copy='Comment', bold=true },
    DiagnosticError = { fg=colors.bright_red },
    DiagnosticWarn = { fg=colors.orange },
    DiagnosticInfo = { fg=colors.blue },
    DiagnosticHint = { fg=colors.grey_1 },

    NeorgCodeBlock = { bg=colors.grey_7 },
    NeorgMarker = { fg=colors.brown, bold=true },
    NeorgMarkerTitle = { fg=colors.grey_2 },
    NeorgHeading1Title = { fg=colors.orange, bold=true },
    NeorgHeading1Prefix = { link='NeorgHeading1Title'},
    NeorgHeading2Title = { fg=colors.yellow, bold=true },
    NeorgHeading2Prefix = { link='NeorgHeading2Title'},
    NeorgHeading3Title = { fg=colors.purple, bold=true },
    NeorgHeading3Prefix = { link='NeorgHeading3Title'},
    NeorgOrderedList1 = { fg=colors.orange },
    NeorgOrderedList2 = { fg=colors.orange },
    NeorgOrderedList3 = { fg=colors.orange },
    NeorgOrderedList4 = { fg=colors.orange },
    NeorgOrderedList5 = { fg=colors.orange },
    NeorgOrderedList6 = { fg=colors.orange },
    NeorgMarkupVerbatim = { link='String' },
    NeorgTagBegin = { fg=colors.purple },
    NeorgTagName = { link='NeorgTagBegin' },
    NeorgTagNameWord = { link='NeorgTagBegin' },
    NeorgTagEnd = { link='NeorgTagBegin' },
    NeorgTagParameter = { fg=colors.green },

    Blue = { fg=colors.blue },
    Yellow = { fg=colors.light_yellow },
    Red = { fg=colors.red },
    Green = { fg=colors.green },
    Brown = { fg=colors.brown },

    --[[
    Normal       { fg=hsl('#F8F8F2') },
    Comment      { fg=hsl(189, 8, 53) },
    NonText      { fg=hsl(191, 11, 31) },
    CursorColumn { bg=hsl(188, 16, 17) },
    ColorColumn  { bg=hsl(200, 4, 14) },
    CursorLine   { bg=CursorColumn.bg },
    Directory    { fg=green },
    DiffAdd      { bg=uiblue.darken(70).desaturate(20) },
    DiffChange   { bg=purple.darken(75).desaturate(40) },
    DiffDelete   { bg=red.darken(75).desaturate(20) },
    DiffText     { fg=Normal.fg, bg=NonText.fg, gui='italic' },
    diffAdded    { fg=blue.lighten(30).saturate(80) },
    diffRemoved  { fg=red.darken(20).desaturate(20) },
    EndOfBuffer  { NonText },
    Search       { fg='black', bg=hsl('#FFE792') },
    IncSearch    { fg='black', bg=uiblue.lighten(30) },
    Substitute   { Search },
    LineNr       { fg=NonText.fg },
    CursorLineNr { fg=Comment.fg },
    MatchParen   { fg=red.saturate(20), bg=ColorColumn.bg, gui='bold' },

    -- UI
    Pmenu        { fg=Normal.fg, bg=NonText.fg.darken(55) },
    PmenuSel     { fg=Normal.fg, bg=uiblue},
    PmenuSbar    { bg=NonText.fg },
    PmenuThumb   { bg=Normal.fg },
    StatusLine   { ColorColumn },
    StatusLineNC { bg=ColorColumn.bg },
    TabLine      { Pmenu },
    TabLineSel   { PmenuSel },
    TabLineFill  { StatusLine },
    WildMenu     { PmenuSel },
    VertSplit    { fg=NonText.fg },
    Folded       { NonText },
    FoldColumn   { NonText },
    SignColumn   { },

    QuickFixLine { CursorLine },
    SpecialKey   { fg=NonText.fg },

    Title        { fg=blue, gui='bold' },
    Visual       { bg=NonText.fg.darken(25).desaturate(80) },
    VisualNOS    { Visual },
    WarningMsg   { bg=CursorColumn.bg, gui='bold' },
    Question     { fg=blue, gui='italic' },
    MoreMsg      { Question },
    ErrorMsg     { fg=red, gui='bold' },
    ModeMsg      { Comment, gui='bold' },

    Constant       { fg=purple },
    String         { fg='#E6DB74' },
    Character      { String },

    Identifier     { Normal }, 
    Statement      { fg=red, gui='bold' },
    Operator       { Normal },
    Keyword        { Statement },
    Exception      { fg=green, gui='bold' },
    PreProc        { fg=green },

    Type           { fg=blue }, 
    StorageClass   { fg=orange, gui='italic' }, 

    Special        { Type, gui='italic' }, 
    SpecialChar    { fg=red },
    Tag            { fg=red, gui='italic' },
    Delimiter      { Comment }, 
    SpecialComment { fg=Comment.fg, gui='bold' },
    Underlined { fg=uiblue.desaturate(20).lighten(25), gui = "underline" },
    Error          { fg=String.fg, bg=red.darken(90) },
    Todo           { fg=Normal.fg, gui='bold' },

    TSNamespace          { Type, gui='bold' },
    TSPunctDelimiter     { },
    TSPunctBracket       { },
    TSPunctSpecial       { },

    TelescopeSelection = {link = 'CursorLine'},
    fugitiveHash       = {fg = orange},
    FugitiveblameHash  = {link = 'fugitiveHash'}
    ]]
}

for group, config in pairs(groups) do
    if config.copy then
        config = vim.tbl_extend('keep', config, groups[config.copy])
        config.copy = nil
    end
    vim.api.nvim_set_hl(0, group, config)
end
-- LuaFormatter on

return {hsl = hsl, start_preview = start_preview}
