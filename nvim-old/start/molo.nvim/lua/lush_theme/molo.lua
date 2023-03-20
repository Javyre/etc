local lush = require('lush')
local hsl = lush.hsl

local uiblue = hsl(213,100,48)

local orange = hsl('#FD971F')
local red = hsl('#F92672')
local green = hsl('#A6E22E')
local blue = hsl('#66D9EF')
local purple = hsl('#AE81FF')

local theme = lush(function()
  return {
    -- The following are all the Neovim default highlight groups from the docs
    -- as of 0.5.0-nightly-446, to aid your theme creation. Your themes should
    -- probably style all of these at a bare minimum.
    --
    -- Referenced/linked groups must come before being referenced/lined,
    -- so the order shown ((mostly) alphabetical) is likely
    -- not the order you will end up with.
    --
    -- You can uncomment these and leave them empty to disable any
    -- styling for that group (meaning they mostly get styled as Normal)
    -- or leave them commented to apply vims default colouring or linking.

    Normal       { fg=hsl('#F8F8F2') }, -- normal text
    Comment      { fg=hsl(189, 8, 53) }, -- any comment
    NonText      { fg=hsl(191, 11, 31) }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
    CursorColumn { bg=hsl(188, 16, 17) }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
    ColorColumn  { bg=hsl(200, 4, 14) }, -- used for the columns set with 'colorcolumn'
    CursorLine   { bg=CursorColumn.bg }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
    -- Conceal      { }, -- placeholder characters substituted for concealed text (see 'conceallevel')
    -- Cursor       { }, -- character under the cursor
    -- lCursor      { }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
    -- CursorIM     { }, -- like Cursor, but used when in IME mode |CursorIM|
    Directory    { fg=green }, -- directory names (and other special names in listings)
    DiffAdd      { bg=uiblue.darken(70).desaturate(20) }, -- { bg=hsl('#13354A') }, -- diff mode: Added line |diff.txt|
    DiffChange   { bg=purple.darken(75).desaturate(40) }, -- diff mode: Changed line |diff.txt|
    DiffDelete   { bg=red.darken(75).desaturate(20) }, -- diff mode: Deleted line |diff.txt|
    DiffText     { fg=Normal.fg, bg=NonText.fg, gui='italic' }, -- diff mode: Changed text within a changed line |diff.txt|
    diffAdded    { fg=blue.lighten(30).saturate(80) }, -- fugitive inline diff
    diffRemoved  { fg=red.darken(20).desaturate(20) }, -- fugitive inline diff
    EndOfBuffer  { NonText }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
    -- TermCursor   { }, -- cursor in a focused terminal
    -- TermCursorNC { }, -- cursor in an unfocused terminal
    Search       { fg='black', bg=hsl('#FFE792') }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
    IncSearch    { fg='black', bg=uiblue.lighten(30) }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    Substitute   { Search }, -- |:substitute| replacement text highlighting
    LineNr       { fg=NonText.fg }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    CursorLineNr { fg=Comment.fg }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    MatchParen   { fg=red.saturate(20), bg=ColorColumn.bg, gui='bold' }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
    -- MsgArea      { }, -- Area for messages and cmdline
    -- MsgSeparator { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
    -- NormalFloat  { }, -- Normal text in floating windows.
    -- NormalNC     { }, -- normal text in non-current windows
    -- Whitespace   { }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
    
    -- UI
    Pmenu        { fg=Normal.fg, bg=NonText.fg.darken(55) }, -- Popup 000000menu: normal item.-360
    PmenuSel     { fg=Normal.fg, bg=uiblue},-- bg=NonText.fg.saturate(40) }, -- Popup menu: selected item.
    PmenuSbar    { bg=NonText.fg }, -- Popup menu: scrollbar.
    PmenuThumb   { bg=Normal.fg }, -- Popup menu: Thumb of the scrollbar.
    StatusLine   { ColorColumn }, -- status line of current window
    StatusLineNC { bg=ColorColumn.bg }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    TabLine      { Pmenu }, -- tab pages line, not active tab page label
    TabLineSel   { PmenuSel }, -- tab pages line, active tab page label
    TabLineFill  { StatusLine }, -- tab pages line, where there are no labels
    WildMenu     { PmenuSel }, -- current match in 'wildmenu' completion
    VertSplit    { fg=NonText.fg }, -- the column separating vertically split windows
    Folded       { NonText }, -- line used for closed folds
    FoldColumn   { NonText }, -- 'foldcolumn'
    SignColumn   { }, -- column where |signs| are displayed

    QuickFixLine { CursorLine }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    SpecialKey   { fg=NonText.fg }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
    -- SpellBad     { }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise. 
    -- SpellCap     { }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    -- SpellLocal   { }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    -- SpellRare    { }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
    
    Title        { fg=blue, gui='bold' }, -- titles for output from ":set all", ":autocmd" etc.
    Visual       { bg=NonText.fg.darken(25).desaturate(80) }, -- { bg=hsl('#403D3D') }, -- Visual mode selection
    VisualNOS    { Visual }, -- Visual mode selection when vim is "Not Owning the Selection".
    WarningMsg   { bg=CursorColumn.bg, gui='bold' }, -- warning messages
    Question     { fg=blue, gui='italic' }, -- |hit-enter| prompt and yes/no questions
    MoreMsg      { Question }, -- |more-prompt|
    ErrorMsg     { fg=red, gui='bold' }, -- error messages on the command line
    ModeMsg      { Comment, gui='bold' }, -- 'showmode' message (e.g., "-- INSERT -- ")


    -- These groups are not listed as default vim groups,
    -- but they are defacto standard group names for syntax highlighting.
    -- commented out groups should chain up to their "preferred" group by
    -- default,
    -- Uncomment and edit if you want more specific syntax highlighting.

    Constant       { fg=purple }, -- (preferred) any constant
    String         { fg='#E6DB74' }, --   a string constant: "this is a string"
    Character      { String }, --  a character constant: 'c', '\n'
    -- Number         { }, --   a number constant: 234, 0xff
    -- Boolean        { }, --  a boolean constant: TRUE, false
    -- Float          { }, --    a floating point constant: 2.3e10

    Identifier     { Normal }, -- (preferred) any variable name
    -- Function       { fg=green }, -- function name (also: methods for classes)

    Statement      { fg=red, gui='bold' }, -- (preferred) any statement
    -- Conditional    { }, --  if, then, else, endif, switch, etc.
    -- Repeat         { }, --   for, do, while, etc.
    -- Label          { }, --    case, default, etc.
    Operator       { Normal }, -- "sizeof", "+", "*", etc.
    Keyword        { Statement }, --  any other keyword
    Exception      { fg=green, gui='bold' }, --  try, catch, throw

    -- PreProc        { Comment, gui='bold' },
    PreProc        { fg=green }, -- (preferred) generic Preprocessor
    -- Include        { }, --  preprocessor #include
    -- Define         { }, --   preprocessor #define
    -- Macro          { }, --    same as Define
    -- PreCondit      { }, --  preprocessor #if, #else, #endif, etc.

    Type           { fg=blue }, -- (preferred) int, long, char, etc.
    StorageClass   { fg=orange, gui='italic' }, -- static, register, volatile, etc.
    -- Structure      { }, --  struct, union, enum, etc.
    -- Typedef        { }, --  A typedef

    Special        { Type, gui='italic' }, -- (preferred) any special symbol
    SpecialChar    { fg=red }, --  special character in a constant
    Tag            { fg=red, gui='italic' }, --    you can use CTRL-] on this
    Delimiter      { Comment }, --  character that needs attention
    SpecialComment { fg=Comment.fg, gui='bold' }, -- special things inside a comment
    -- Debug          { }, --    debugging statements

    Underlined { fg=uiblue.desaturate(20).lighten(25), gui = "underline" }, -- (preferred) text that stands out, HTML links
    -- Bold       { gui = "bold" },
    -- Italic     { gui = "italic" },

    -- ("Ignore", below, may be invisible...)
    -- Ignore         { }, -- (preferred) left blank, hidden  |hl-Ignore|

    Error          { fg=String.fg, bg=red.darken(90) }, -- (preferred) any erroneous construct

    Todo           { fg=Normal.fg, gui='bold' }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX

    -- These groups are for the native LSP client. Some other LSP clients may
    -- use these groups, or use their own. Consult your LSP client's
    -- documentation.

    -- LspReferenceText                     { }, -- used for highlighting "text" references
    -- LspReferenceRead                     { }, -- used for highlighting "read" references
    -- LspReferenceWrite                    { }, -- used for highlighting "write" references

    -- LspDiagnosticsDefaultError           { }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    -- LspDiagnosticsDefaultWarning         { }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    -- LspDiagnosticsDefaultInformation     { }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    -- LspDiagnosticsDefaultHint            { }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)

    -- LspDiagnosticsVirtualTextError       { Error }, -- Used for "Error" diagnostic virtual text
    -- LspDiagnosticsVirtualTextWarning     { Error }, -- Used for "Warning" diagnostic virtual text
    -- LspDiagnosticsVirtualTextInformation { }, -- Used for "Information" diagnostic virtual text
    -- LspDiagnosticsVirtualTextHint        { }, -- Used for "Hint" diagnostic virtual text

    -- LspDiagnosticsUnderlineError         { }, -- Used to underline "Error" diagnostics
    -- LspDiagnosticsUnderlineWarning       { }, -- Used to underline "Warning" diagnostics
    -- LspDiagnosticsUnderlineInformation   { }, -- Used to underline "Information" diagnostics
    -- LspDiagnosticsUnderlineHint          { }, -- Used to underline "Hint" diagnostics

    -- LspDiagnosticsFloatingError          { }, -- Used to color "Error" diagnostic messages in diagnostics float
    -- LspDiagnosticsFloatingWarning        { }, -- Used to color "Warning" diagnostic messages in diagnostics float
    -- LspDiagnosticsFloatingInformation    { }, -- Used to color "Information" diagnostic messages in diagnostics float
    -- LspDiagnosticsFloatingHint           { }, -- Used to color "Hint" diagnostic messages in diagnostics float

    -- LspDiagnosticsSignError              { }, -- Used for "Error" signs in sign column
    -- LspDiagnosticsSignWarning            { }, -- Used for "Warning" signs in sign column
    -- LspDiagnosticsSignInformation        { }, -- Used for "Information" signs in sign column
    -- LspDiagnosticsSignHint               { }, -- Used for "Hint" signs in sign column

    -- These groups are for the neovim tree-sitter highlights.
    -- As of writing, tree-sitter support is a WIP, group names may change.
    -- By default, most of these groups link to an appropriate Vim group,
    -- TSError -> Error for example, so you do not have to define these unless
    -- you explicitly want to support Treesitter's improved syntax awareness.

    -- TSAnnotation         { };    -- For C++/Dart attributes, annotations that can be attached to the code to denote some kind of meta information.
    -- TSAttribute          { };    -- (unstable) TODO: docs
    -- TSBoolean            { };    -- For booleans.
    -- TSCharacter          { };    -- For characters.
    -- TSComment            { };    -- For comment blocks.
    -- TSConstructor        { };    -- For constructor calls and definitions: ` { }` in Lua, and Java constructors.
    -- TSConditional        { };    -- For keywords related to conditionnals.
    -- TSConstant           { };    -- For constants
    -- TSConstBuiltin       { };    -- For constant that are built in the language: `nil` in Lua.
    -- TSConstMacro         { };    -- For constants that are defined by macros: `NULL` in C.
    -- TSError              { };    -- For syntax/parser errors.
    -- TSException          { };    -- For exception related keywords.
    -- TSField              { };    -- For fields.
    -- TSFloat              { };    -- For floats.
    -- TSFunction           { };    -- For function (calls and definitions).
    -- TSFuncBuiltin        { };    -- For builtin functions: `table.insert` in Lua.
    -- TSFuncMacro          { };    -- For macro defined fuctions (calls and definitions): each `macro_rules` in Rust.
    -- TSInclude            { };    -- For includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
    -- TSKeyword            { };    -- For keywords that don't fall in previous categories.
    -- TSKeywordFunction    { };    -- For keywords used to define a fuction.
    -- TSLabel              { };    -- For labels: `label:` in C and `:label:` in Lua.
    -- TSMethod             { };    -- For method calls and definitions.
    TSNamespace          { Type, gui='bold' };    -- For identifiers referring to modules and namespaces.
    -- TSNone               { };    -- TODO: docs
    -- TSNumber             { };    -- For all numbers
    -- TSOperator           { };    -- For any operator: `+`, but also `->` and `*` in C.
    -- TSParameter          { };    -- For parameters of a function.
    -- TSParameterReference { };    -- For references to parameters of a function.
    -- TSProperty           { };    -- Same as `TSField`.
    TSPunctDelimiter     { };    -- For delimiters ie: `.`
    TSPunctBracket       { };    -- For brackets and parens.
    TSPunctSpecial       { };    -- For special punctutation that does not fall in the catagories before.
    -- TSRepeat             { };    -- For keywords related to loops.
    -- TSString             { };    -- For strings.
    -- TSStringRegex        { };    -- For regexes.
    -- TSStringEscape       { };    -- For escape characters within a string.
    -- TSSymbol             { };    -- For identifiers referring to symbols or atoms.
    -- TSType               { };    -- For types.
    -- TSTypeBuiltin        { Keyword };    -- For builtin types.
    -- TSVariable           { };    -- Any variable name that does not have another highlight.
    -- TSVariableBuiltin    { };    -- Variable names that are defined by the languages, like `this` or `self`.

    -- TSTag                { };    -- Tags like html tag names.
    -- TSTagDelimiter       { };    -- Tag delimiter like `<` `>` `/`
    -- TSText               { };    -- For strings considered text in a markup language.
    -- TSEmphasis           { };    -- For text to be represented with emphasis.
    -- TSUnderline          { };    -- For text to be represented with an underline.
    -- TSStrike             { };    -- For strikethrough text.
    -- TSTitle              { };    -- Text that is part of a title.
    -- TSLiteral            { };    -- Literal text.
    -- TSURI                { };    -- Any URI like a link or email.
    
    -- Telescope.nvim
    -- TelescopeNormal       { Pmenu },
    TelescopeSelection    { CursorLine },

    fugitiveHash          { fg=orange },
    FugitiveblameHash     { fugitiveHash },

  }
end)

-- return our parsed theme for extension or use else where.
return theme

-- vi:nowrap
