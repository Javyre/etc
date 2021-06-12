import Hook, augroup from require 'init.util'
require 'vimp'

Lsp = {
  is_initialized: false
  is_setup: {}

  InitHook: Hook! -- When initializing defered lsp servers
  AttachHook: Hook! -- When attaching a buffer to lsp

  defer_setup: (serv, fts, opts using nil) =>
    augroup 'jv_lsp_defer_'..serv, {{
      'FileType', fts,
      ->
        if @is_setup[serv] == nil
          unless @is_initialized
            @InitHook\emit!
            @is_initialized = true
          with require'lspconfig'[serv]
            .setup opts
            .manager.try_add!
          @is_setup[serv] = true
    }}
}

on_lsp_attach = (client, bufnr using nil) ->
  vimp.add_buffer_maps ->
    with vimp
      .nnoremap 'gD',    vim.lsp.buf.declaration
      .nnoremap 'gd',    vim.lsp.buf.definition
      .nnoremap 'gr',    vim.lsp.buf.references
      .nnoremap 'K',     vim.lsp.buf.hover
      .nnoremap 'gi',    vim.lsp.buf.implementation
      .nnoremap '<C-k>', vim.lsp.buf.signature_help
      .nnoremap '[d',    vim.lsp.diagnostic.goto_prev
      .nnoremap ']d',    vim.lsp.diagnostic.goto_next
      .nnoremap '<LocalLeader>wa', vim.lsp.buf.add_workspace_folder
      .nnoremap '<LocalLeader>wr', vim.lsp.buf.remove_workspace_folder
      .nnoremap '<LocalLeader>wl', ->
        print vim.inspect vim.lsp.buf.list_workspace_folders
      .nnoremap '<LocalLeader>D',  vim.lsp.buf.type_definition
      .nnoremap '<LocalLeader>lr', vim.lsp.buf.rename
      .nnoremap '<LocalLeader>la', vim.lsp.buf.code_action
      .nnoremap '<LocalLeader>le', vim.lsp.diagnostic.show_line_diagnostics
      .nnoremap '<LocalLeader>lq', vim.lsp.diagnostic.set_loclist

      if client.resolved_capabilities.document_formatting
        .nnoremap '<LocalLeader>lf', vim.lsp.buf.formatting
      if client.resolved_capabilities.document_range_formatting
        .vnoremap '<LocalLeader>lf', vim.lsp.buf.range_formatting

  if client.resolved_capabilities.document_highlight
    vim.cmd [[
      hi def link LspReferenceText CursorLine
      hi def link LspReferenceWrite CursorLine
      hi def link LspReferenceRead CursorLine

      augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END" false
    ]]

  Lsp.AttachHook\emit client, bufnr

-- We have to initialize lsp-install to access the installed server configs
-- in lspconfig.
Lsp.InitHook\hook -> require'lspinstall'.setup!

Lsp\defer_setup('jdtls',
  { 'java' },
  {
    on_attach: on_lsp_attach
    cmd: {'jdtls'}
    root_dir: (fname) ->
      require'lspconfig'.util.root_pattern(
        'gradle.build', '.project', '.git'
      )(fname) or vim.fn.getcwd!
  })

Lsp\defer_setup('cpp', 
  { 'c', 'cpp', 'objc', 'objcpp' },
  { on_attach: on_lsp_attach })

Lsp\defer_setup('typescript',
  { 'javascript', 'javascriptreact', 'jsx'
    'typescript', 'typescriptreact', 'tsx' },
  { on_attach: on_lsp_attach })

require'compe'.setup {
  source: {
    path: true
    buffer: true
    calc: true
    nvim_lsp: true
    nvim_lua: true
    vsnip: true
  }
}

do
  local opts
  opts = { 'silent', 'expr' }
  vimp.inoremap opts, '<C-Space>', [[compe#complete()]]
  vimp.inoremap opts, '<CR>',      [[compe#confirm('<CR>')]]
  vimp.inoremap opts, '<C-e>',     [[compe#close('<C-e>')]]
  vimp.inoremap opts, '<C-f>',     [[compe#scroll({ 'delta': +4 })]]
  vimp.inoremap opts, '<C-d>',     [[compe#scroll({ 'delta': -4 })]]

Lsp
