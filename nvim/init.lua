vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- [[ Setting options ]]
vim.opt.number = false
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
vim.opt.scrolloff = 3

vim.opt.colorcolumn = '80'
vim.opt.textwidth = 79

-- [[ Basic Keymaps ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>fs', '<cmd>w<CR>', { desc = 'write' })
vim.keymap.set(
  'n',
  '<leader>lq',
  vim.diagnostic.setloclist,
  { desc = 'diagnostics loclist' }
)
vim.keymap.set(
  't',
  '<Esc><Esc>',
  '<C-\\><C-n>',
  { desc = 'exit terminal mode' }
)

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('jv-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `mini.deps` plugin manager ]]
local path_package = vim.fn.stdpath 'data' .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd 'echo "Installing `mini.nvim`" | redraw'
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd 'packadd mini.nvim | helptags ALL'
  vim.cmd 'echo "Installed `mini.nvim`" | redraw'
end

local MiniDeps = require 'mini.deps'
MiniDeps.setup { path = { package = path_package } }

-- [[ Configure and install plugins ]]

local now, later, add = MiniDeps.now, MiniDeps.later, MiniDeps.add

now(function()
  -- tmux
  add 'aserowy/tmux.nvim'
  local tmux = require 'tmux'
  tmux.setup {
    navigation = {
      enable_default_keybindings = false,
    },
    resize = {
      enable_default_keybindings = false,
    },
    swap = {
      enable_default_keybindings = false,
    },
  }

  local map = function(...)
    vim.keymap.set('n', ...)
  end
  map('<C-h>', tmux.move_left, { desc = 'focus the left window' })
  map('<C-l>', tmux.move_right, { desc = 'focus the right window' })
  map('<C-j>', tmux.move_bottom, { desc = 'focus the lower window' })
  map('<C-k>', tmux.move_top, { desc = 'focus the upper window' })
  map('<C-M-h>', tmux.resize_left, { desc = 'resize the window left' })
  map('<C-M-l>', tmux.resize_right, { desc = 'resize the window right' })
  map('<C-M-j>', tmux.resize_bottom, { desc = 'resize the window down' })
  map('<C-M-k>', tmux.resize_top, { desc = 'resize the window up' })
  map('<C-S-h>', tmux.swap_left, { desc = 'swap the window left' })
  map('<C-S-l>', tmux.swap_right, { desc = 'swap the window right' })
  map('<C-S-j>', tmux.swap_bottom, { desc = 'swap the window down' })
  map('<C-S-k>', tmux.swap_top, { desc = 'swap the window up' })
end)

now(function()
  local misc = require 'mini.misc'
  misc.setup()
  misc.setup_termbg_sync()
  misc.setup_restore_cursor()

  local statusline = require 'mini.statusline'
  local section_devinfo = function(args)
    if statusline.is_truncated(args.trunc_width) then
      return ''
    end
    local dgn = statusline.section_diagnostics { icon = '' }
    local lsp = statusline.section_lsp { icon = '' }
    local ret = ''
    if dgn ~= '' then
      ret = ret .. dgn:gsub(' ', '')
    end
    if lsp ~= '' then
      ret = ret .. 'L'
    end
    return ret
  end

  statusline.setup {
    use_icons = vim.g.have_nerd_font,
    content = {
      active = function()
        local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
        local devinfo = section_devinfo { trunc_width = 40 }
        local filename = statusline.section_filename { trunc_width = 140 }
        local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
        local location = statusline.section_location { trunc_width = 75 }
        local search = statusline.section_searchcount { trunc_width = 75 }

        return statusline.combine_groups {
          { hl = mode_hl, strings = { mode } },
          { hl = 'MiniStatuslineDevinfo', strings = { devinfo } },
          '%<', -- Mark general truncate point
          { hl = 'MiniStatuslineFilename', strings = { filename } },
          '%=', -- End left alignment
          { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
          { hl = mode_hl, strings = { search, location } },
        }
      end,
    },
  }

  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function()
    return '%2l:%-2v'
  end

  local hipatterns = require 'mini.hipatterns'
  hipatterns.setup {
    highlighters = {
      sponge = {
        pattern = '%f[%w]()SPONGE()%f[%W]',
        group = '@comment.error',
      },
      fixme = {
        pattern = '%f[%w]()FIXME()%f[%W]',
        group = '@comment.error',
      },
      warn = {
        pattern = '%f[%w]()WARN()%f[%W]',
        group = '@comment.warning',
      },
      hack = {
        pattern = '%f[%w]()HACK()%f[%W]',
        group = '@comment.warning',
      },
      todo = {
        pattern = '%f[%w]()TODO()%f[%W]',
        group = '@comment.todo',
      },
      combak = {
        pattern = '%f[%w]()COMBAK()%f[%W]',
        group = '@comment.todo',
      },
      note = {
        pattern = '%f[%w]()NOTE()%f[%W]',
        group = '@comment.note',
      },

      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  }
end)

later(function()
  require('mini.bufremove').setup()
  require('mini.surround').setup()
  require('mini.jump2d').setup {
    labels = 'jfkdlsncvm;ahgpqowieur',
    view = {
      n_steps_ahead = 3,
    },
    mappings = {
      start_jumping = '<CR>',
    },
  }
  require('mini.bracketed').setup {
    -- empty suffix = disabled
    buffer = { suffix = 'b', options = {} },
    comment = { suffix = '', options = {} },
    conflict = { suffix = 'x', options = {} },
    diagnostic = { suffix = 'd', options = {} },
    file = { suffix = 'f', options = {} },
    indent = { suffix = 'i', options = {} },
    jump = { suffix = 'j', options = {} },
    location = { suffix = 'l', options = {} },
    oldfile = { suffix = 'o', options = {} },
    quickfix = { suffix = 'q', options = {} },
    treesitter = { suffix = 't', options = {} },
    undo = { suffix = '', options = {} },
    window = { suffix = 'w', options = {} },
    yank = { suffix = 'y', options = {} },
  }
end)

now(function()
  -- Detect tabstop and shiftwidth automatically
  add 'tpope/vim-sleuth'
end)

now(function()
  add 'MunifTanjim/nui.nvim'
  add 'julienvincent/hunk.nvim'
  require('hunk').setup()
end)

later(function()
  add 'tpope/vim-fugitive'
  vim.keymap.set(
    'n',
    '<leader>gs',
    '<cmd>tab Git<cr>',
    { desc = 'git status' }
  )
end)

later(function()
  -- Adds git related signs to the gutter, as well as utilities for managing
  -- changes
  add 'lewis6991/gitsigns.nvim'

  require('gitsigns').setup {
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
      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'stage buffer' })
      map(
        'n',
        '<leader>hu',
        gitsigns.undo_stage_hunk,
        { desc = 'undo stage hunk' }
      )
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'reset buffer' })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'preview hunk' })
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
  }
end)

later(function()
  add 'folke/which-key.nvim'
  require('which-key').setup {
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
        Up = 'Up',
        Down = 'Down',
        Left = 'Left',
        Right = 'Right',
        C = 'C-',
        M = 'M-',
        D = 'D-',
        S = 'S-',
        CR = 'CR',
        Esc = 'ESC',
        ScrollWheelDown = 'ScrollWheelDown',
        ScrollWheelUp = 'ScrollWheelUp',
        NL = 'NL',
        BS = 'BS',
        Space = 'SPC',
        Tab = 'TAB ',
        F1 = 'F1',
        F2 = 'F2',
        F3 = 'F3',
        F4 = 'F4',
        F5 = 'F5',
        F6 = 'F6',
        F7 = 'F7',
        F8 = 'F8',
        F9 = 'F9',
        F10 = 'F10',
        F11 = 'F11',
        F12 = 'F12',
      },
    },

    -- Document existing key chains
    spec = {
      { '<leader>l', group = 'lang', mode = { 'n', 'x' } },
      { '<leader>s', group = 'search' },
      { '<leader>f', group = 'file' },
      { '<leader>t', group = 'toggle' },
      { '<leader>h', group = 'git hunk', mode = { 'n', 'v' } },
      { '<leader>g', group = 'git' },
    },
  }
end)

later(function()
  add 'folke/snacks.nvim'

  local snacks = require 'snacks'
  snacks.setup {
    picker = {
      layout = 'bottom',
    },
    explorer = {},
  }
  local picker = snacks.picker
  local map = function(lhs, rhs, desc, mode)
    vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc })
  end

  -- files
  map('<leader>ff', picker.smart, 'files')
  map('<leader>fe', picker.explorer, 'explorer')
  map('<leader>fp', picker.git_files, 'git files')
  map('<leader>fn', function()
    picker.files { cwd = vim.fn.stdpath 'config' }
  end, 'neovim files')

  map('<leader>gf', picker.git_log_file, 'git log file')

  -- text
  map('<leader>sp', picker.grep, 'grep')
  map('<leader>sP', picker.grep_word, 'grep cursor')
  map('<leader>ss', picker.lines, 'search buffer')

  map('<leader>sc', picker.commands, 'fzf-lua commands')
  map('<leader>sr', picker.resume, 'fzf-lua resume')
  map('<leader>sd', picker.diagnostics, 'diagnostics')
  map('<leader>sD', picker.diagnostics_buffer, 'diagnostics buffer')
  map('<leader>sC', picker.colorschemes, 'colorschemes')
end)
-- -- TODO: lazy load trigger on key
-- -- see https://github.com/lewis6991/pckr.nvim for example
-- later(function()
--   add 'ibhagwan/fzf-lua'
--
--   local fzf_lua = require 'fzf-lua'
--   fzf_lua.setup {
--     'default-title',
--     glob_flag = '--iglob',
--     grep = {
--       actions = {
--         ['ctrl-q'] = {
--           fn = fzf_lua.actions.file_edit_or_qf,
--           prefix = 'select-all+',
--         },
--       },
--     },
--   }
--
--   fzf_lua.register_ui_select(function(_, items)
--     local min_h, max_h = 0.15, 0.70
--     local h = (#items + 4) / vim.o.lines
--     if h < min_h then
--       h = min_h
--     elseif h > max_h then
--       h = max_h
--     end
--     return { winopts = { height = h, width = 0.60, row = 0.40 } }
--   end)
--
--   local map = function(lhs, rhs, desc, mode)
--     vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc })
--   end
--
--   local nvim_files = function()
--     fzf_lua.files { cwd = vim.fn.stdpath 'config' }
--   end
--
--   -- files
--   map('<leader>ff', fzf_lua.files, 'files')
--   map('<leader>fp', fzf_lua.git_files, 'git files')
--   map('<leader>fn', nvim_files, 'neovim files')
--
--   -- text
--   map('<leader>sp', fzf_lua.live_grep_glob, 'project live grep')
--   map('<leader>ss', fzf_lua.grep_curbuf, 'search buffer')
--
--   map('<leader>sc', fzf_lua.builtin, 'fzf-lua commands')
--   map('<leader>sr', fzf_lua.resume, 'fzf-lua resume')
-- end)

-- LSP Plugins

-- TODO: lazy load on lua filetype opened
later(function()
  -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
  -- used for completion, annotations and signatures of Neovim apis
  add 'folke/lazydev.nvim'
  add 'Bilal2453/luvit-meta'
  require('lazydev').setup {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
    },
  }
end)

later(function()
  add 'supermaven-inc/supermaven-nvim'
  require('supermaven-nvim').setup {}

  add 'j-hui/fidget.nvim'
  require('fidget').setup {}
  vim.lsp.config('*', {
    root_markers = { 'Cargo.lock', '.git', '.jj' },
  })
  vim.lsp.config.lua_ls = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
      },
    },
  }
  vim.lsp.config.rust_analyzer = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
  }
  vim.lsp.config.zls = {
    cmd = { 'zls' },
    filetypes = { 'zig', 'zir', 'zon' },
    root_markers = { 'build.zig', '.git', '.jj' },
  }
  vim.lsp.config.tinymist = {
    cmd = { 'tinymist' },
    filetypes = { 'typst' },
    settings = {
      formatterMode = 'typstyle',
    },
  }

  vim.lsp.enable {
    'lua_ls',
    'rust_analyzer',
    'zls',
    'tinymist',
  }

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

      -- local fzf_lua = require 'fzf-lua'
      -- local defs = function()
      --   fzf_lua.lsp_definitions { jump1 = true }
      -- end
      -- local refs = function()
      --   fzf_lua.lsp_references { includeDeclaration = false }
      -- end
      -- map('gd', defs, 'goto def')
      -- map('gD', fzf_lua.lsp_typedefs, 'goto typedef')
      -- map('gr', refs, 'goto ref')
      -- map('gI', fzf_lua.lsp_implementations, 'goto impl')
      -- map('<leader>lD', vim.lsp.buf.declaration, 'goto decl')
      -- map('<leader>lsd', fzf_lua.lsp_document_symbols, 'doc symbols')
      -- map('<leader>lsw', fzf_lua.lsp_live_workspace_symbols, 'ws symbols')
      local picker = require('snacks').picker
      map('gd', picker.lsp_definitions, 'goto def')
      map('gD', picker.lsp_type_definitions, 'goto typedef')
      map('gr', picker.lsp_references, 'goto ref')
      map('gI', picker.lsp_implementations, 'goto impl')
      map('<leader>lr', vim.lsp.buf.rename, 'rename')
      map('<leader>la', vim.lsp.buf.code_action, 'action', { 'n', 'x' })

      local client = vim.lsp.get_client_by_id(event.data.client_id)

      -- Cursor hold symbol highlight
      if
        client
        and client:supports_method(
          vim.lsp.protocol.Methods.textDocument_documentHighlight
        )
      then
        local highlight_augroup =
          vim.api.nvim_create_augroup('jv-lsp-highlight', { clear = false })
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
        and client:supports_method(
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
end)

later(function()
  add 'chomosuke/typst-preview.nvim'
  require('typst-preview').setup {
    dependencies_bin = {
      ['tinymist'] = 'tinymist',
      ['websocat'] = 'websocat',
    },
  }
end)

-- later(function()
--   add 'neovim/nvim-lspconfig'
--   add 'williamboman/mason.nvim'
--   add 'williamboman/mason-lspconfig.nvim'
--   add 'WhoIsSethDaniel/mason-tool-installer.nvim'
--   -- Useful status updates for LSP.
--   add 'j-hui/fidget.nvim'
--   -- Allows extra capabilities provided by nvim-cmp
--   add 'hrsh7th/cmp-nvim-lsp'
--
--   -- NOTE: Must be loaded before dependants
--   -- run :Mason for status
--   require('mason').setup {}
--   require('fidget').setup {}
--
--   vim.api.nvim_create_autocmd('LspAttach', {
--     group = vim.api.nvim_create_augroup('jv-lsp-attach', { clear = true }),
--     callback = function(event)
--       local map = function(keys, func, desc, mode)
--         mode = mode or 'n'
--         vim.keymap.set(
--           mode,
--           keys,
--           func,
--           { buffer = event.buf, desc = 'LSP: ' .. desc }
--         )
--       end
--
--       local fzf_lua = require 'fzf-lua'
--       local defs = function()
--         fzf_lua.lsp_definitions {
--           jump_to_single_result = true,
--         }
--       end
--       local refs = function()
--         fzf_lua.lsp_references {
--           includeDeclaration = false,
--         }
--       end
--       map('gd', defs, 'goto def')
--       map('gD', fzf_lua.lsp_typedefs, 'goto typedef')
--       map('gr', refs, 'goto ref')
--       map('gI', fzf_lua.lsp_implementations, 'goto impl')
--       map('<leader>lD', vim.lsp.buf.declaration, 'goto decl')
--       map('<leader>lsd', fzf_lua.lsp_document_symbols, 'doc symbols')
--       map('<leader>lsw', fzf_lua.lsp_live_workspace_symbols, 'ws symbols')
--       map('<leader>lr', vim.lsp.buf.rename, 'rename')
--       map('<leader>la', vim.lsp.buf.code_action, 'action', { 'n', 'x' })
--
--       local client = vim.lsp.get_client_by_id(event.data.client_id)
--
--       -- Cursor hold symbol highlight
--       if
--         client
--         and client.supports_method(
--           vim.lsp.protocol.Methods.textDocument_documentHighlight
--         )
--       then
--         local highlight_augroup =
--           vim.api.nvim_create_augroup('jv-lsp-highlight', { clear = false })
--         vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--           buffer = event.buf,
--           group = highlight_augroup,
--           callback = vim.lsp.buf.document_highlight,
--         })
--
--         vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--           buffer = event.buf,
--           group = highlight_augroup,
--           callback = vim.lsp.buf.clear_references,
--         })
--
--         vim.api.nvim_create_autocmd('LspDetach', {
--           group = vim.api.nvim_create_augroup(
--             'jv-lsp-detach',
--             { clear = true }
--           ),
--           callback = function(event2)
--             vim.lsp.buf.clear_references()
--             vim.api.nvim_clear_autocmds {
--               group = 'jv-lsp-highlight',
--               buffer = event2.buf,
--             }
--           end,
--         })
--       end
--
--       -- Inlay hints toggle
--       if
--         client
--         and client.supports_method(
--           vim.lsp.protocol.Methods.textDocument_inlayHint
--         )
--       then
--         map('<leader>th', function()
--           vim.lsp.inlay_hint.enable(
--             not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }
--           )
--         end, 'toggle inlay hints')
--       end
--     end,
--   })
--
--   -- LSP servers and clients are able to communicate to each other what
--   -- features they support. By default, Neovim doesn't support everything
--   -- that is in the LSP specification. When you add nvim-cmp, luasnip, etc.
--   -- Neovim now has *more* capabilities. So, we create new capabilities
--   -- with nvim cmp, and then broadcast that to the servers.
--   local capabilities = vim.lsp.protocol.make_client_capabilities()
--   capabilities = vim.tbl_deep_extend(
--     'force',
--     capabilities,
--     require('cmp_nvim_lsp').default_capabilities()
--   )
--
--   local servers = {
--     rust_analyzer = {},
--     zls = {},
--     lua_ls = {
--       settings = {
--         Lua = {
--           completion = {
--             callSnippet = 'Replace',
--           },
--         },
--       },
--     },
--   }
--
--   local ensure_installed = {
--     'lua_ls',
--     'stylua', -- Used to format Lua code
--   }
--   require('mason-tool-installer').setup {
--     ensure_installed = ensure_installed,
--   }
--
--   local setup_handler = function(server_name)
--     local server = servers[server_name] or {}
--     server.capabilities =
--       vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
--     require('lspconfig')[server_name].setup(server)
--   end
--   require('mason-lspconfig').setup {
--     handlers = { setup_handler },
--   }
--   setup_handler 'rust_analyzer'
--   setup_handler 'zls'
--   setup_handler 'lua_ls'
-- end)

later(function()
  add 'mfussenegger/nvim-dap'

  local dap = require 'dap'
  dap.adapters.lldb = {
    type = 'executable',
    command = 'codelldb',
  }
  dap.configurations.zig = {
    {
      name = 'Launch',
      type = 'lldb',
      request = 'launch',
      program = '${command:pickFile}',
      -- program = function()
      --   return vim.fn.input(
      --     'Path to executable: ',
      --     vim.fn.getcwd() .. '/',
      --     'file'
      --   )
      -- end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
      sourceLanguages = {
        'cpp',
        'rust',
      },
    },
  }
end)

later(function()
  -- Autoformat
  add 'stevearc/conform.nvim'
  -- event = { 'BufWritePre' },
  -- cmd = { 'ConformInfo' },
  vim.keymap.set('n', '<leader>f', function()
    require('conform').format { async = true, lsp_format = 'fallback' }
  end, {
    desc = 'format buffer',
  })
  require('conform').setup {
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
  }
end)

later(function()
  -- Breadcrumbs in winbar
  add 'Bekaboo/dropbar.nvim'
  vim.keymap.set('n', '<leader>ll', function()
    require('dropbar.api').select_next_context()
  end, { desc = 'breadcrumbs' })
end)

later(function()
  -- Autocompletion
  local build_blink_hook = function(params)
    vim.notify('Building blink.cmp', vim.log.levels.INFO)
    local obj = vim
      .system({ 'nix', 'run', '.#build-plugin' }, { cwd = params.path })
      :wait()
    if obj.code == 0 then
      vim.notify('Building blink.cmp done', vim.log.levels.INFO)
    else
      vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
    end
  end

  add {
    source = 'saghen/blink.cmp',
    hooks = {
      post_checkout = build_blink_hook,
      post_install = build_blink_hook,
    },
  }
  add {
    source = 'L3MON4D3/LuaSnip',
    hooks = {
      post_checkout = function()
        vim.cmd '!make install_jsregexp'
      end,
    },
  }

  require('blink.cmp').setup {
    completion = {
      menu = {
        draw = {
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon', 'kind' },
          },
        },
      },
    },
  }
end)
-- later(function()
--   -- Autocompletion
--   add 'hrsh7th/nvim-cmp'
--   -- event = 'InsertEnter',
--   -- Snippet Engine & its associated nvim-cmp source
--   add {
--     source = 'L3MON4D3/LuaSnip',
--     hooks = {
--       post_checkout = function()
--         vim.cmd '!make install_jsregexp'
--       end,
--     },
--   }
--   add 'saadparwaiz1/cmp_luasnip'
--   add 'hrsh7th/cmp-nvim-lsp'
--   add 'hrsh7th/cmp-path'
--
--   add 'supermaven-inc/supermaven-nvim'
--   require('supermaven-nvim').setup {}
--
--   -- See `:help cmp`
--   local cmp = require 'cmp'
--   local luasnip = require 'luasnip'
--   luasnip.config.setup {}
--
--   cmp.setup {
--     snippet = {
--       expand = function(args)
--         luasnip.lsp_expand(args.body)
--       end,
--     },
--     completion = { completeopt = 'menu,menuone,noinsert' },
--
--     mapping = cmp.mapping.preset.insert {
--       ['<C-n>'] = cmp.mapping.select_next_item(),
--       ['<C-p>'] = cmp.mapping.select_prev_item(),
--       ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--       ['<C-f>'] = cmp.mapping.scroll_docs(4),
--       ['<C-y>'] = cmp.mapping.confirm { select = true },
--       -- Manually trigger a completion from nvim-cmp.
--       ['<C-Space>'] = cmp.mapping.complete {},
--       -- <c-l> will move you to the right of each of the expansion
--       -- locations. <c-h> is similar, except moving you backwards.
--       ['<C-l>'] = cmp.mapping(function()
--         if luasnip.expand_or_locally_jumpable() then
--           luasnip.expand_or_jump()
--         end
--       end, { 'i', 's' }),
--       ['<C-h>'] = cmp.mapping(function()
--         if luasnip.locally_jumpable(-1) then
--           luasnip.jump(-1)
--         end
--       end, { 'i', 's' }),
--     },
--     sources = {
--       { name = 'supermaven' },
--       {
--         name = 'lazydev',
--         -- set group index to 0 to skip loading LuaLS completions as
--         -- lazydev recommends it
--         group_index = 0,
--       },
--       { name = 'nvim_lsp' },
--       { name = 'luasnip' },
--       { name = 'path' },
--     },
--   }
-- end)

later(function()
  add 'akinsho/toggleterm.nvim'
  require('toggleterm').setup {
    open_mapping = [[<c-\>]],
  }
end)

now(function()
  -- add 'EdenEast/nightfox.nvim'
  -- require('nightfox').setup {}
  -- add 'kepano/flexoki-neovim'
  -- add 'cpplain/flexoki.nvim'
  add 'nuvic/flexoki-nvim'
  require('flexoki').setup {
    variant = 'auto',
    palette = {
      moon = {
        surface = '#1C1B1A',
      },
    },
  }
  -- dir = '~/src/nightfox.nvim',
  -- vim.cmd.colorscheme 'carbonfox'
  vim.cmd.colorscheme 'flexoki'
end)

now(function()
  add {
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = {
      post_checkout = function()
        vim.cmd ':TSUpdate'
      end,
    },
  }
  require('nvim-treesitter.configs').setup {
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
  }
end)

later(function()
  add 'nvim-treesitter/nvim-treesitter-textobjects'
  local ai = require 'mini.ai'
  local spec_treesitter = ai.gen_spec.treesitter
  ai.setup {
    n_lines = 500,
    custom_textobjects = {
      s = spec_treesitter {
        a = {
          '@loop.inner',
          '@conditional.inner',
          '@function.inner',
          '@class.inner',
        },
        i = {
          '@loop.outer',
          '@conditional.outer',
          '@function.outer',
          '@class.outer',
        },
      },
      a = spec_treesitter { a = '@parameter.outer', i = '@parameter.inner' },
      f = spec_treesitter { a = '@call.outer', i = '@call.inner' },
      F = spec_treesitter { a = '@function.outer', i = '@function.inner' },
      o = spec_treesitter {
        a = { '@conditional.outer', '@loop.outer' },
        i = { '@conditional.inner', '@loop.inner' },
      },
    },
  }
end)

-- vim: ts=2 sts=2 sw=2 et
