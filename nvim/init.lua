vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- [[ Setting options ]]
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false

-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.breakindent = true
vim.opt.undofile = true
-- Case-insensitive searching UNLESS \C or one or more capital letters in the
-- search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 5

-- [[ Basic Keymaps ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set(
  'n',
  '<leader>q',
  vim.diagnostic.setloclist,
  { desc = 'diagnostics loclist' }
)
vim.keymap.set(
  't',
  '<Esc><Esc>',
  '<C-\\><C-n>',
  { desc = 'Exit terminal mode' }
)
vim.keymap.set(
  'n',
  '<C-h>',
  '<C-w><C-h>',
  { desc = 'Move focus to the left window' }
)
vim.keymap.set(
  'n',
  '<C-l>',
  '<C-w><C-l>',
  { desc = 'Move focus to the right window' }
)
vim.keymap.set(
  'n',
  '<C-j>',
  '<C-w><C-j>',
  { desc = 'Move focus to the lower window' }
)
vim.keymap.set(
  'n',
  '<C-k>',
  '<C-w><C-k>',
  { desc = 'Move focus to the upper window' }
)

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('jv-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more
--    info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  { -- Adds git related signs to the gutter, as well as utilities for managing
    -- changes 'lewis6991/gitsigns.nvim',
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'next git change' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'prev git change' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'stage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'reset hunk' })
        map(
          'n',
          '<leader>hS',
          gitsigns.stage_buffer,
          { desc = 'stage buffer' }
        )
        map(
          'n',
          '<leader>hu',
          gitsigns.undo_stage_hunk,
          { desc = 'undo stage hunk' }
        )
        map(
          'n',
          '<leader>hR',
          gitsigns.reset_buffer,
          { desc = 'reset buffer' }
        )
        map(
          'n',
          '<leader>hp',
          gitsigns.preview_hunk,
          { desc = 'preview hunk' }
        )
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'blame line' })
        map(
          'n',
          '<leader>hd',
          gitsigns.diffthis,
          { desc = 'diff against index' }
        )
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'diff against last commit' })
        -- Toggles
        map(
          'n',
          '<leader>tb',
          gitsigns.toggle_current_line_blame,
          { desc = 'toggle git show blame line' }
        )
        map(
          'n',
          '<leader>tD',
          gitsigns.toggle_deleted,
          { desc = 'toggle git show deleted' }
        )
      end,
    },
  },

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      layout = {
        width = { min = 5 },
        spacing = 2,
      },
      win = {
        padding = { 1, 0 },
        border = 'none',
      },
      icons = {
        breadcrumb = '>',
        separator = ':',
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = 'code', mode = { 'n', 'x' } },
        { '<leader>d', group = 'document' },
        { '<leader>r', group = 'rename' },
        { '<leader>s', group = 'search' },
        { '<leader>w', group = 'workspace' },
        { '<leader>t', group = 'toggle' },
        { '<leader>h', group = 'git hunk', mode = { 'n', 'v' } },
      },
    },
  },

  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- [[ Configure Telescope ]]
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'help' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'keymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'files' })
      vim.keymap.set(
        'n',
        '<leader>ss',
        builtin.builtin,
        { desc = 'select telescope' }
      )
      vim.keymap.set(
        'n',
        '<leader>sw',
        builtin.grep_string,
        { desc = 'current word' }
      )
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'grep' })
      vim.keymap.set(
        'n',
        '<leader>sd',
        builtin.diagnostics,
        { desc = 'diagnostics' }
      )
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'resume' })
      vim.keymap.set(
        'n',
        '<leader>s.',
        builtin.oldfiles,
        { desc = 'recent files' }
      )
      vim.keymap.set(
        'n',
        '<leader><leader>',
        builtin.buffers,
        { desc = 'buffers' }
      )

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the
        -- theme, layout, etc.
        builtin.current_buffer_fuzzy_find(
          require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          }
        )
      end, { desc = 'current buffer fuzzy' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about
      --  particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = 'grep open files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'neovim files' })
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- NOTE: Must be loaded before dependants
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('jv-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(
              mode,
              keys,
              func,
              { buffer = event.buf, desc = 'LSP: ' .. desc }
            )
          end

          map(
            'gd',
            require('telescope.builtin').lsp_definitions,
            'goto definition'
          )
          map(
            'gr',
            require('telescope.builtin').lsp_references,
            'goto references'
          )
          map(
            'gI',
            require('telescope.builtin').lsp_implementations,
            'goto implementation'
          )
          map(
            '<leader>D',
            require('telescope.builtin').lsp_type_definitions,
            'type definition'
          )
          map(
            '<leader>ds',
            require('telescope.builtin').lsp_document_symbols,
            'document symbols'
          )
          map(
            '<leader>ws',
            require('telescope.builtin').lsp_dynamic_workspace_symbols,
            'workspace symbols'
          )
          map('<leader>rn', vim.lsp.buf.rename, 'rename')
          map(
            '<leader>ca',
            vim.lsp.buf.code_action,
            'code action',
            { 'n', 'x' }
          )
          map('gD', vim.lsp.buf.declaration, 'goto declaration')

          -- Cursor hold symbol highlight
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
            client
            and client.supports_method(
              vim.lsp.protocol.Methods.textDocument_documentHighlight
            )
          then
            local highlight_augroup = vim.api.nvim_create_augroup(
              'jv-lsp-highlight',
              { clear = false }
            )
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup(
                'jv-lsp-detach',
                { clear = true }
              ),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds {
                  group = 'jv-lsp-highlight',
                  buffer = event2.buf,
                }
              end,
            })
          end

          -- Inlay hints toggle
          if
            client
            and client.supports_method(
              vim.lsp.protocol.Methods.textDocument_inlayHint
            )
          then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(
                not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }
              )
            end, 'toggle inlay hints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what
      -- features they support. By default, Neovim doesn't support everything
      -- that is in the LSP specification. When you add nvim-cmp, luasnip, etc.
      -- Neovim now has *more* capabilities. So, we create new capabilities
      -- with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
        'force',
        capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      local servers = {
        rust_analyzer = {},
        zls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      -- run :Mason for status
      require('mason').setup()

      local ensure_installed = {
        'lua_ls',
        'stylua', -- Used to format Lua code
      }
      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }

      local setup_handler = function(server_name)
        local server = servers[server_name] or {}
        server.capabilities = vim.tbl_deep_extend(
          'force',
          {},
          capabilities,
          server.capabilities or {}
        )
        require('lspconfig')[server_name].setup(server)
      end
      require('mason-lspconfig').setup {
        handlers = { setup_handler },
      }
      setup_handler 'rust_analyzer'
      setup_handler 'zls'
      setup_handler 'lua_ls'
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = 'format buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin
          --    snippets: https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          -- Manually trigger a completion from nvim-cmp.
          ['<C-Space>'] = cmp.mapping.complete {},
          -- <c-l> will move you to the right of each of the expansion
          -- locations. <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as
            -- lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  {
    'tpope/vim-fugitive',
    keys = { { '<leader>gs', '<cmd>tab Git<cr>', desc = 'git status' } },
  },

  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      open_mapping = [[<c-\>]],
    },
  },

  -- Nightfox Theme
  {
    'EdenEast/nightfox.nvim',
    -- dir = '~/src/nightfox.nvim',
    priority = 1000,
    config = function(_, opts)
      require('nightfox').setup(opts)
      -- vim.cmd.colorscheme 'nightfox'
      vim.cmd.colorscheme 'carbonfox'
    end,
    -- Horribly bad attempt at an argonaught port
    opts = function()
      return {}
      -- Color = require 'nightfox.lib.color'
      -- Shade = require 'nightfox.lib.shade'
      --
      -- local bg = Color '#121212'
      -- local fg = Color '#EBEBEB'
      --
      -- local function set_okhsl(hex, h, s, l)
      --   local orig = Color.from_hex(hex):to_okhsl()
      --   return Color.from_okhsl( --
      --     h or orig.hue,
      --     s or orig.saturation,
      --     l or orig.lightness
      --   )
      -- end
      --
      -- local function set_okhsv(hex, h, s, v)
      --   local orig = Color.from_hex(hex):to_okhsv()
      --   return Color.from_okhsv( --
      --     h or orig.hue,
      --     s or orig.saturation,
      --     v or orig.value
      --   )
      -- end
      --
      -- -- stylua: ignore start
      -- local red     = set_okhsv('#FF301B', nil, nil, 90)
      -- local green   = set_okhsv('#A0E521', nil, nil, 90)
      -- local yellow  = set_okhsv('#FFC620', nil, nil, 90)
      -- local blue    = set_okhsv('#1BA6FA', nil, nil, 90)
      -- local magenta = set_okhsv('#8763B8', nil, nil, 90)
      -- local cyan    = set_okhsv('#21DEEF', nil, nil, 90)
      -- local orange  = set_okhsv('#FF301B', 38,  nil, 90)
      -- local pink    = Color.from_okhsv(    341, 70,  90)
      -- -- stylua: ignore stop
      --
      -- return {
      --   palettes = {
      --     nightfox = {
      --       -- stylua: ignore start
      --       black   = Shade.new('#0d0d0d', 0.30, -0.25),
      --       red     = Shade.new(red      , 0.30, -0.25),
      --       green   = Shade.new(green    , 0.30, -0.25),
      --       yellow  = Shade.new(yellow   , 0.30, -0.25),
      --       blue    = Shade.new(blue     , 0.30, -0.25),
      --       magenta = Shade.new(magenta  , 0.30, -0.25),
      --       cyan    = Shade.new(cyan     , 0.30, -0.25),
      --       white   = Shade.new('#EBEBEB', 0.30, -0.25),
      --       orange  = Shade.new(orange   , 0.30, -0.25),
      --       pink    = Shade.new(pink     , 0.30, -0.25),
      --
      --       comment = bg:blend(fg, 0.5):to_css(),
      --
      --       bg0 = bg:brighten(-6):to_css(), -- Dark bg (status line and float)
      --       bg1 = bg:to_css(), -- Default bg
      --       bg2 = bg:brighten(6):to_css(), -- Lighter bg (colorcolm folds)
      --       bg3 = bg:brighten(12):to_css(), -- Lighter bg (cursor line)
      --       bg4 = bg:brighten(24):to_css(), -- Conceal, border fg
      --
      --       fg0 = fg:brighten(6):to_css(), -- Lighter fg
      --       fg1 = fg:to_css(), -- Default fg
      --       fg2 = fg:brighten(-24):to_css(), -- Darker fg (status line)
      --       fg3 = fg:brighten(-48):to_css(), -- Darker fg (line numbers, fold colums)
      --
      --       sel0 = bg:blend(fg, 0.15):to_css(), -- Popup bg, visual selection bg
      --       sel1 = bg:blend(fg, 0.3):to_css(), -- Popup sel bg, search bg
      --       -- stylua: ignore stop
      --     },
      --   },
      -- }
    end,
  },

  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'go',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'rust',
        'terraform',
        'hcl',
        'zig',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
