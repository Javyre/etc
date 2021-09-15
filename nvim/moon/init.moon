Timer =
  start: -> {
    start_time: vim.loop.hrtime!
    stop: (using nil) =>
      time = (vim.loop.hrtime! - @start_time) / 1000000
      print string.format 'Elapsed time: %f msecs', time
  }

InitTimer = Timer.start!

import paq from require 'paq-nvim'
import augroup from require 'init.util'

-- Should-be-default
paq { 'svermeulen/vimpeccable' }
paq { 'farmergrep/vim-lastplace' }
paq { 'tpope/vim-repeat' }
paq { 'tpope/vim-commentary' }
paq { 'tpope/vim-unimpaired' }
paq { 'tpope/vim-abolish' }
paq { 'junegunn/vim-easy-align' }
paq { 'troydm/zoomwintab.vim' }
paq { 'kana/vim-textobj-user' }
paq { 'sgur/vim-textobj-parameter' }
paq { 'editorconfig/editorconfig-vim' }

-- Missing syntax
paq { 'sheerun/vim-polyglot' }
paq { 'HarnoRanaivo/vim-mipssyntax' }
paq { 'vim-pandoc/vim-pandoc-syntax' }

-- Tree-Sitter
paq { 'nvim-treesitter/nvim-treesitter', run: -> vim.cmd 'TSUpdate' }

-- Lsp (see lsp.moon)
paq { 'neovim/nvim-lspconfig' }
paq { 'kabouzeid/nvim-lspinstall' }
paq { 'hrsh7th/vim-vsnip' }
paq { 'hrsh7th/nvim-compe' }
paq { 'RishabhRD/popfix' }
paq { 'folke/trouble.nvim' }

-- Misc
paq { 'rktjmp/lush.nvim' }
paq { 'kyazdani42/nvim-web-devicons' }
paq { 'hoob3rt/lualine.nvim' }

-- Util
paq { 'tpope/vim-fugitive' }
paq { 'rbong/vim-flog' }
paq { 'lambdalisue/fern.vim' }
paq { 'kevinhwang91/nvim-bqf' }
paq { 'mhinz/vim-grepper' }
paq { 'christoomey/vim-tmux-navigator' }
paq { 'vijaymarupudi/nvim-fzf' }

require 'vimp'

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

with vim.o
  .mouse      = 'a'
  .timeout    = false
  .ignorecase = true
  .smartcase  = true
  .incsearch  = true  -- search while typing
  .hlsearch   = true  -- highlight search
  .gdefault   = true  -- global substitution by default (no need for /g flag)
  .splitbelow = true  -- open below instead of above
  .diffopt    = do    -- smarter diff
		(.diffopt or "") .. ",indent-heuristic,algorithm:histogram"
  .clipboard      = 'unnamedplus'
  .fillchars      = 'fold: ,diff: '
  .inccommand     = 'split'
  .termguicolors  = true
  .foldlevelstart = 99
  .path           = '.,**'
  .wildmode       = 'longest:full,full'

with vim.wo
  .colorcolumn   = '+1' -- highlight column at textwidth+1
  .conceallevel  = 2
  .concealcursor = 'vn'

set_indent = (indent = 4) ->
  with vim.bo
    .expandtab   = true
    .shiftwidth  = indent
    .tabstop     = indent
    .softtabstop = indent

augroup 'jv_buffer_setup', {
  { 'FileType',
    { 'fennel', 'lisp', 'moon', 'markdown', 'markdown.pandoc' },
    ->
      set_indent 2
      with vim.bo
        .textwidth = 80
        .infercase = true -- infer case in search
        .modeline  = true
      vim.cmd 'EditorConfigReload' }
  { 'FileType',
    { 'c', 'cpp', 'java', 'javascript', 'jsx', 'html', 'lua' },
    ->
      set_indent 4
      with vim.bo
        .textwidth = 80
        .infercase = true
        .modeline  = true
      vim.cmd 'EditorConfigReload' }
}

vimp.nmap("<M-#{i}>", "<cmd>#{i}tabn<cr>") for i=1,9

vimp.nmap '<Leader>fs', '<cmd>w<cr>'
vimp.nmap '<Leader><Tab>', '<cmd>b#<cr>'
vimp.nmap '<M-;>', '<cmd>Commentary<cr>'
vimp.vmap '<M-;>', 'gcgv'
vimp.nmap '<Leader>wm', '<cmd>ZoomWinTabToggle<cr>'
vimp.xmap 'ga', '<Plug>(EasyAlign)'
vimp.nmap 'ga', '<Plug>(EasyAlign)'
vim.g.vim_textobj_parameter_mapping = 'a'

-- Disable troublesome 4-space prefixed codeblocks
vim.g['pandoc#syntax#protect#codeblocks'] = 0
augroup 'pandoc_syntax', {
  { 'BufNewFile,BufFilePre,BufRead',
    { '*.md' },
    ->
      vim.bo.filetype = 'markdown.pandoc'
      vim.wo.concealcursor = 'v'
  }
}

require'init.lsp'

require'nvim-treesitter.configs'.setup {
  ensure_installed: 'all'
  ignore_install: {}
  highlight: { enable: true, disable: {} }
  incremental_selection: {
    enable: true
    keymaps: {
      init_selection: 'gnn'
      node_incremental: 'grn'
      scope_incremental: 'grc'
      node_decremental: 'grm'
    }
  }
  indent: { enable: false }
}

with vim.wo
  .foldmethod = 'expr'
  .foldexpr = 'nvim_treesitter#foldexpr()'

augroup 'jv_moon_init_compile_on_save', {{
  'BufWritePost', '~/*/*vim/*.moon', 'silent MoonCompile'
}}

vimp.nnoremap '<Leader>rr', ->
  vimp.unmap_all!
  package.loaded.init = nil
  require 'init'

-- vim.cmd 'packadd molo.nvim'
vim.cmd 'colo molo'

require'nvim-web-devicons'.setup { default: true }

local jv_tabline
do
  colors = {
    black:     '#232526'
    grey:      '#7E8E91'
    dark_grey: '#465558'
    white:     '#f8f8f2'
    cyan:      '#66d9ef'
    green:     '#a6e22e'
    orange:    '#ef5939'
    red:       '#f92672'
    yellow:    '#e6db74'
    purple:    '#AE81FF'
  }

  vim.cmd "hi TabLineFill guibg=none    gui=none"
  vim.cmd "hi TabLineSel  guifg=#000000 guibg=#{colors.grey} gui=bold,italic"
  vim.cmd "hi TabLine     guifg=#000000 guibg=#{colors.dark_grey} gui=bold"

  jv_tabline = (using nil)->
    ret = ''
    selected_tab = vim.fn.tabpagenr()
    num_tabs = vim.fn.tabpagenr('$')

    for i = 1,num_tabs
      cwd = vim.split(vim.fn.getcwd(-1, i), '/')
      if i == selected_tab
        ret ..= '%#TabLineSel#'
      else
        ret ..= '%#TabLine#'
      ret ..= "%#{i}T #{i} #{cwd[#cwd]}/ "
    ret ..= '%#TabLineFill#'

    ret ..= '%=%999X ✖︎ ' if num_tabs > 1
    ret
  vim.o.tabline = '%!luaeval(\'require"init".jv_tabline()\')'

  require'lualine'.setup {
    options: {
      icons_enabled: false
      theme: {
        normal: {
          a: {fg: colors.grey,      gui: 'bold,inverse,italic'}
          b: {fg: colors.grey,      bg: colors.black}
          c: {fg: colors.dark_grey, gui: 'bold'}
          z: {fg: colors.grey,      gui: 'bold,inverse'}
        }
        insert:   {z: {fg: colors.green,     gui: 'bold,inverse'}}
        visual:   {z: {fg: colors.purple,    gui: 'bold,inverse'}}
        replace:  {z: {fg: colors.red,       gui: 'bold,inverse'}}
        inactive: {a: {fg: colors.dark_grey, gui: 'bold,inverse'}}
      }
      section_separators: ''
      component_separators: '|'
      symbols: {
        modified: ' ▲'
        readonly: ' ▼'
      }
    }
    sections: {
      lualine_a: {'filename'}
      lualine_b: {}
      lualine_c: {}
      lualine_x: {{'diff', colored: false, symbols: {modified: '~'}}}
      lualine_y: {'branch'}
      lualine_z: {'location'}
    }
    inactive_sections: {
      lualine_a: {'filename'}
      lualine_b: {}
      lualine_c: {}
      lualine_x: {}
      lualine_y: {}
      lualine_z: {}
    }
    tabline: {}
    extensions: {
      'fugitive'
      'quickfix'
    }
  }

vimp.nnoremap '<Leader>gs', '<cmd>tab Git<cr>'
vimp.nnoremap '<Leader>gl', [[<cmd>Flog -all -format=[%h]\ (%ar)\ %s%d\ {%an}<cr>]]

vimp.nnoremap '<Leader>tt', '<cmd>Fern . -drawer -toggle -reveal=%<cr>'

vimp.nmap 'gs', '<plug>(GrepperOperator)'
vimp.xmap 'gs', '<plug>(GrepperOperator)'
vimp.nnoremap '<Leader>ps', '<cmd>Grepper -tool rg<cr>'
vimp.nnoremap '<Leader>ss', '<cmd>Grepper -tool rg -buffer<cr>'

vim.g.tmux_navigator_no_mappings = 1
vimp.nnoremap '<A-h>', '<cmd>TmuxNavigateLeft<cr>'
vimp.nnoremap '<A-j>', '<cmd>TmuxNavigateDown<cr>'
vimp.nnoremap '<A-k>', '<cmd>TmuxNavigateUp<cr>'
vimp.nnoremap '<A-l>', '<cmd>TmuxNavigateRight<cr>'

vimp.tnoremap '<A-h>', [[<C-\><C-n><cmd>TmuxNavigateLeft<cr>]]
vimp.tnoremap '<A-j>', [[<C-\><C-n><cmd>TmuxNavigateDown<cr>]]
vimp.tnoremap '<A-k>', [[<C-\><C-n><cmd>TmuxNavigateUp<cr>]]
vimp.tnoremap '<A-l>', [[<C-\><C-n><cmd>TmuxNavigateRight<cr>]]

with Fzf = require 'init.fzf'
  vimp.nnoremap '<Leader>ff', Fzf.find_file
  vimp.nnoremap '<Leader>pf', -> Fzf.find_file(true)
  vimp.nnoremap '<Leader>bb', Fzf.switch_buff

InitTimer\stop!

{ :set_indent, :jv_tabline }
