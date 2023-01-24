local util = require 'init.util'
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local Lsp = {
    is_initialized = false,
    is_setup = {},

    InitHook = util.Hook(),

    defer_setup = function(self, serv, fts, opts)
        local group = augroup('jv_lsp_defer_' .. serv, {})
        autocmd('FileType', {
            group = group,
            pattern = fts,
            callback = function()
                if self[serv] == nil then
                    if not self.is_initialized then
                        self.InitHook:emit()
                        self.is_initialized = true
                    end

                    local lspi = require 'nvim-lsp-installer'
                    local ok, server = lspi.get_server(serv)
                    if ok and server:is_installed() then
                        local s = require'lspconfig'[serv]
                        s.setup(opts or {})
                        s.manager.try_add()
                        self.is_setup[serv] = true
                    end
                end
            end
        })
    end
}

Lsp.InitHook:hook(function()
    require'nvim-lsp-installer'.setup {}
    require'lspconfig'.util.default_config.on_attach =
        function(client, bufnr)
            local nmap = function(lhs, rhs)
                if rhs then
                    vim.keymap.set('n', lhs, rhs, {buffer = true})
                end
            end

            local lsp = vim.lsp
            local buf = vim.lsp.buf

            nmap('gD', buf.declaration)
            nmap('gd', buf.definition)
            nmap('gr', buf.references)
            nmap('K', buf.hover)
            nmap('gi', buf.implementation)
            nmap('<C-k>', buf.signature_help)
            nmap('[d', lsp.diagnostic.goto_prev)
            nmap(']d', lsp.diagnostic.goto_next)
            nmap('<LocalLeader>wa', buf.add_workspace_folder)
            nmap('<LocalLeader>wr', buf.remove_workspace_folder)
            nmap('<LocalLeader>wl',
                 function()
                vim.pretty_print(buf.list_workspace_folders)
            end)
            nmap('<LocalLeader>D', buf.type_definition)
            nmap('<LocalLeader>lr', buf.rename)
            nmap('<LocalLeader>la', buf.code_action)
            nmap('<LocalLeader>le', lsp.diagnostic.show_line_diagnostics)
            nmap('<LocalLeader>lq', lsp.diagnostic.set_loclist)

            if client.server_capabilities.document_formatting then
                nmap('<LocalLeader>lf', buf.formatting)
            end
            if client.server_capabilities.document_range_formatting then
                nmap('<LocalLeader>lf', buf.range_formatting)
            end

            if client.server_capabilities.document_highlight then
                local hi = vim.api.nvim_set_hl
                hi(0, 'LspReferenceText', {default = true, link = 'CursorLine'})
                hi(0, 'LspReferenceWrite', {default = true, link = 'CursorLine'})
                hi(0, 'LspReferenceRead', {default = true, link = 'CursorLine'})

                local group =
                    augroup('jv_lsp_document_highlight', {clear = false})
                vim.api.nvim_clear_autocmds({group = group, buffer = bufnr})

                autocmd('CursorHold', {
                    group = group,
                    buffer = bufnr,
                    callback = buf.document_highlight
                })
                autocmd('CursorMoved', {
                    group = group,
                    buffer = bufnr,
                    callback = buf.clear_references
                })
            end
        end

    vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {signs = false})
end)

Lsp:defer_setup('jdtls', {'java'}, {
    cmd = {'jdtls'},
    root_dir = function(fname)
        local root_pat = require'lspconfig'.util.root_pattern
        return root_pat('gradle.build', '.project', '.git')(fname) or
                   vim.fn.getcwd()
    end
})

-- Lsp:defer_setup('sumneko_lua', {'lua'}, require'lua-dev'.setup {})

Lsp:defer_setup('cpp', {'c', 'cpp', 'objc', 'objcpp'})
Lsp:defer_setup('gopls', {'go'})
Lsp:defer_setup('svelte', {'svelte'})
Lsp:defer_setup('cssls', {'css', 'scss', 'less'})
Lsp:defer_setup('tsserver', {
    'javascript', 'javascriptreact', 'jsx', 'typescript', 'typescriptreact',
    'tsx'
})
Lsp:defer_setup('zls', {'zig'}, {
    cmd = {'/Users/javyre/src/zls/zig-out/bin/zls'}
})
Lsp:defer_setup('rust_analyzer', {'rust'})

local cmp = require 'cmp'
cmp.setup({
    snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
                else
                    cmp.confirm()
                end
            else
                fallback()
            end
        end, {"i", "s"})
    }),
    sources = cmp.config.sources({{name = 'nvim_lsp'}, {name = 'luasnip'}},
                                 {{name = 'buffer'}}),
    experimental = {ghost_text = {hl_group = 'Comment'}}
})

--[[
cmp.setup.cmdline('?', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {{name = 'buffer'}}
})
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {{name = 'buffer'}}
})
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})
})
]]

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

Lsp.InitHook:hook(function()
    require'lspconfig'.util.default_config.capabilities = capabilities
end)

Lsp.InitHook:hook(function() require("trouble").setup {icons = false} end)
