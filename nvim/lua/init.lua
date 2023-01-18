pcall(function() require('impatient') end)
local paq = require 'paq'

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local paqs_path = vim.fn.stdpath('data') .. '/site/pack/paqs'

paq {
    'savq/paq-nvim', --
    'lewis6991/impatient.nvim', --
    --
    -- Should-be-default
    --
    'antoinemadec/FixCursorHold.nvim', --
    {
        'luafun/luafun',
        run = function()
            vim.cmd('!cd ' .. paqs_path ..
                        '/start/luafun && mkdir -p lua && mv fun.lua lua')
        end
    }, --
    'nvim-lua/plenary.nvim', --
    'ethanholz/nvim-lastplace', --
    'tpope/vim-repeat', --
    'numToStr/Comment.nvim', --
    'tpope/vim-unimpaired', --
    'tpope/vim-abolish', --
    'junegunn/vim-easy-align', --
    'troydm/zoomwintab.vim', --
    'kana/vim-textobj-user', --
    'sgur/vim-textobj-parameter', --
    'editorconfig/editorconfig-vim', --
    --
    -- Missing syntax
    --
    -- 'sheerun/vim-polyglot', --
    'HarnoRanaivo/vim-mipssyntax', --
    'vim-pandoc/vim-pandoc-syntax', --
    --
    -- Tree-Sitter
    --
    {
        'nvim-treesitter/nvim-treesitter',
        run = function() return vim.cmd('TSInstall all | TSUpdate') end
    }, --
    -- 
    -- Lsp (see lsp.lua)
    --
    'neovim/nvim-lspconfig', --
    'williamboman/nvim-lsp-installer', --
    'hrsh7th/cmp-nvim-lsp', --
    'hrsh7th/cmp-buffer', --
    'hrsh7th/cmp-path', --
    'hrsh7th/cmp-cmdline', --
    'hrsh7th/nvim-cmp', --
    'L3MON4D3/LuaSnip', --
    'saadparwaiz1/cmp_luasnip', --
    'rafamadriz/friendly-snippets', --
    'RishabhRD/popfix', --
    'folke/trouble.nvim', --
    'folke/lua-dev.nvim', --
    --
    -- Misc
    --
    -- 'RRethy/nvim-base16', --
    'rktjmp/lush.nvim', --
    'nvim-lualine/lualine.nvim', --
    'norcalli/nvim-colorizer.lua', --
    'nvim-neorg/neorg', --
    --
    -- Util
    --
    'tpope/vim-fugitive', --
    'rbong/vim-flog', --
    'lambdalisue/fern.vim', --
    'lambdalisue/fern-git-status.vim', --
    'kevinhwang91/nvim-bqf', --
    'mhinz/vim-grepper', --
    'christoomey/vim-tmux-navigator', --
    'vijaymarupudi/nvim-fzf', --
    'sindrets/winshift.nvim' --
}

vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.o.mouse = 'a'
vim.o.timeout = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.gdefault = true
vim.o.splitbelow = true
vim.o.diffopt = (vim.o.diffopt or '') .. ',indent-heuristic,algorithm:histogram'
vim.o.clipboard = 'unnamedplus'
vim.o.fillchars = 'fold: ,diff: '
vim.o.inccommand = 'split'
vim.o.termguicolors = true
vim.o.foldlevelstart = 99
vim.o.path = '.,**'
vim.o.wildmode = 'longest:full,full'
vim.o.tabstop = 4

vim.wo.colorcolumn = '+1'
vim.wo.conceallevel = 2
vim.wo.concealcursor = 'vn'

local set_indent = function(indent)
    indent = indent or 4

    vim.bo.expandtab = true
    vim.bo.shiftwidth = indent
    vim.bo.tabstop = indent
    vim.bo.softtabstop = indent
end

augroup('jv_buffer_setup', {})
autocmd({'FileType'}, {
    group = 'jv_buffer_setup',
    pattern = {'c', 'cpp', 'java', 'javascript', 'jsx', 'html', 'lua'},
    callback = function()
        set_indent(4)
        vim.bo.textwidth = 80
        vim.bo.infercase = true -- infer case in search
        vim.bo.modeline = true
        vim.cmd 'EditorConfigReload'
    end
})
autocmd({'FileType'}, {
    group = 'jv_buffer_setup',
    pattern = {'fennel', 'lisp', 'moon', 'markdown', 'markdown.pandoc'},
    callback = function()
        set_indent(2)
        vim.bo.textwidth = 80
        vim.bo.infercase = true -- infer case in search
        vim.bo.modeline = true
        vim.cmd 'EditorConfigReload'
    end
})

local map = vim.keymap.set;

for i = 1, 9 do map('n', '<M-' .. i .. '>', '<cmd>' .. i .. 'tabn<cr>') end

map('n', '<Leader>fs', '<cmd>w<cr>')
map('n', '<Leader><Tab>', '<cmd>b#<cr>')
map('n', '<Leader>wm', '<cmd>ZoomWinTabToggle<cr>')
map('n', '<Leader>ww', '<cmd>WinShift<cr>')
map('n', '<Leader>wx', '<cmd>WinShift swap<cr>')
map('x', 'ga', '<Plug>(EasyAlign)')
map('n', 'ga', '<Plug>(EasyAlign)')
vim.g.vim_textobj_parameter_mapping = 'a'

-- Disable troublesome 4-space prefixed codeblocks
vim.g['pandoc#syntax#protect#codeblocks'] = 0
augroup('pandoc_syntax', {})
autocmd({'FileType'}, {
    group = 'pandoc_syntax',
    pattern = {'*.md'},
    callback = function()
        vim.bo.filetype = 'markdown.pandoc'
        vim.wo.concealcursor = 'v'
    end
})

require'nvim-lastplace'.setup {}

package.loaded['init.lsp'] = nil
require 'init.lsp'

require('nvim-treesitter.configs').setup({
    -- see paq hook: TSInstall all
    -- not setting ensure_installed = 'all' here as that causes init slowdown
    ensure_installed = {},
    ignore_install = {},
    highlight = {enable = true, disable = {}},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm'
        }
    },
    indent = {enable = false}
})
-- do
--   local _with_0 = vim.wo
--   _with_0.foldmethod = 'expr'
--   _with_0.foldexpr = 'nvim_treesitter#foldexpr()'
-- end

require('Comment').setup()
map('n', '<M-;>', function() --
    require('Comment.api').call('toggle_current_linewise_op')
end)
map('x', '<M-;>', function()
    require("Comment.api").toggle_linewise_op(vim.fn.visualmode())
end)

require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.norg.concealer"] = {},
        ["core.norg.completion"] = {config = {engine = 'nvim-cmp'}},
        ["core.integrations.nvim-cmp"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    heroai = "~/Documents/Work/HeroAI/",
                    home = "~/Documents/Notes/"
                }
            }
        }
    }
}

map('n', '<Leader>rr', function()
    package.loaded.init = nil
    require 'init'
end)

vim.cmd('colo toni')
local jv_tabline
do
    local colors = {
        black = '#232526',
        grey = '#7E8E91',
        dark_grey = '#465558',
        white = '#f8f8f2',
        cyan = '#66d9ef',
        green = '#a6e22e',
        orange = '#ef5939',
        red = '#f92672',
        yellow = '#e6db74',
        purple = '#AE81FF'
    }

    local hi = vim.api.nvim_set_hl
    hi(0, 'TabLineFill', {})
    hi(0, 'TabLineSel', { --
        fg = '#000000',
        bg = colors.grey,
        bold = true,
        italic = true
    })
    hi(0, 'TabLine', { --
        fg = '#000000',
        bg = colors.dark_grey,
        bold = true
    })

    jv_tabline = function()
        local ret = ''
        local selected_tab = vim.fn.tabpagenr()
        local num_tabs = vim.fn.tabpagenr('$')
        for i = 1, num_tabs do
            local cwd = vim.split(vim.fn.getcwd(-1, i), '/')
            if i == selected_tab then
                ret = ret .. '%#TabLineSel#'
            else
                ret = ret .. '%#TabLine#'
            end
            ret = ret .. "%" .. tostring(i) .. "T " .. tostring(i) .. " " ..
                      tostring(cwd[#cwd]) .. "/ "
        end
        ret = ret .. '%#TabLineFill#'
        if num_tabs > 1 then ret = ret .. '%=%999X ✖︎ ' end
        return ret
    end
    vim.o.tabline = '%!luaeval(\'require"init".jv_tabline()\')'
    require('lualine').setup({
        options = {
            icons_enabled = false,
            theme = {
                normal = {
                    a = {fg = colors.grey, gui = 'bold,inverse,italic'},
                    b = {fg = colors.grey, bg = colors.black},
                    c = {fg = colors.dark_grey, gui = 'bold'},
                    z = {fg = colors.grey, gui = 'bold,inverse'}
                },
                insert = {z = {fg = colors.green, gui = 'bold,inverse'}},
                visual = {z = {fg = colors.purple, gui = 'bold,inverse'}},
                replace = {z = {fg = colors.red, gui = 'bold,inverse'}},
                inactive = {a = {fg = colors.dark_grey, gui = 'bold,inverse'}}
            },
            section_separators = '',
            component_separators = '|',
            symbols = {modified = ' ▲', readonly = ' ▼'}
        },
        sections = {
            lualine_a = {'filename'},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {{'diff', colored = false, symbols = {modified = '~'}}},
            lualine_y = {'branch'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {'filename'},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        extensions = {'fugitive', 'quickfix'}
    })
end

require'colorizer'.setup({'css'}, {css = true})

vim.g['fern#renderer#default#leaf_symbol'] = '│ '
vim.g['fern#renderer#default#collapsed_symbol'] = '│+'
vim.g['fern#renderer#default#expanded_symbol'] = '│-'

map('n', '<Leader>gs', '<cmd>tab Git<cr>')
map('n', '<Leader>gl', [[<cmd>Flog -all -format=[%h]\ (%ar)\ %s%d\ {%an}<cr>]])
map('n', '<Leader>tt', '<cmd>Fern . -drawer -toggle -reveal=%<cr>')
map('n', 'gs', '<plug>(GrepperOperator)')
map('x', 'gs', '<plug>(GrepperOperator)')
map('n', '<Leader>ps', '<cmd>Grepper -tool rg<cr>')
map('n', '<Leader>ss', '<cmd>Grepper -tool rg -buffer<cr>')
vim.g.tmux_navigator_no_mappings = 1
map('n', '<A-h>', '<cmd>TmuxNavigateLeft<cr>')
map('n', '<A-j>', '<cmd>TmuxNavigateDown<cr>')
map('n', '<A-k>', '<cmd>TmuxNavigateUp<cr>')
map('n', '<A-l>', '<cmd>TmuxNavigateRight<cr>')
map('t', '<A-h>', [[<C-\><C-n><cmd>TmuxNavigateLeft<cr>]])
map('t', '<A-j>', [[<C-\><C-n><cmd>TmuxNavigateDown<cr>]])
map('t', '<A-k>', [[<C-\><C-n><cmd>TmuxNavigateUp<cr>]])
map('t', '<A-l>', [[<C-\><C-n><cmd>TmuxNavigateRight<cr>]])

do
    local Fzf = require('init.fzf')
    map('n', '<Leader>ff', Fzf.find_file)
    map('n', '<Leader>pf', function() return Fzf.find_file(true) end)
    map('n', '<Leader>bb', Fzf.switch_buff)
end

require('noom').setup()

do
    package.loaded.iedit = nil
    local iedit = require 'iedit'

    iedit.setup {}
    map('n', '<Leader>e', function()
        vim.keymap.set('n', '<LocalLeader>T',
                       function() print('Hello world!') end, {buffer = true})
        iedit.iedit {source = 'last-search'}
    end)
    map('n', '<Leader>E', function() iedit.stop() end)
end

return {set_indent = set_indent, jv_tabline = jv_tabline}
