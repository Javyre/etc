vim.fn.sign_define 'JvStatusLineBG', { linehl: 'StatusLine' }

Floating = {
  rel_to_vim: (using nil) ->
    info = vim.fn.getwininfo(vim.fn.win_getid!)[1]
    buf = vim.api.nvim_create_buf false, true
    vim.api.nvim_open_win buf, true, {
      relative: 'win',
      win: info.winid,
      anchor: 'SW',
      width: info.width,
      height: 15,
      row: info.height + 1,
      col: 0,
      style: 'minimal',
    }

  rel_to_win: (using nil) ->
    info = vim.fn.getwininfo(vim.fn.win_getid!)[1]
    buf = vim.api.nvim_create_buf false, true
    height = math.min(info.height + 1, 15)
    vim.api.nvim_open_win buf, true, {
      relative: 'win',
      win: info.winid,
      anchor: 'SW',
      width: info.width,      :height,
      row:   info.height + 1, col: 0,
      style: 'minimal',
    }

    vim.cmd 'set winhl=Normal:Normal'
    vim.fn.sign_place 0, '', 'JvStatusLineBG', '', { lnum: height }
}

get_syn_attr = (hl, attr using nil) ->
  with vim.fn
    return .synIDattr(.synIDtrans(.hlID(hl)), attr)

fzf_opts = (opts = {}) -> string.format([[
  --border=top                                 \
  --prompt='%s'                                \
  --color=16,query:regular,prompt:10,border:%s \
  ]], opts.prompt or '> ', get_syn_attr('VertSplit', 'fg#'))

{
  find_file: (gitignore = false using nil) ->
    import provided_win_fzf from require 'fzf'
    (coroutine.wrap (using nil) ->
      Floating.rel_to_win!

      cmd = "fd -H #{if gitignore then '' else '-I'} -t f"

      result = provided_win_fzf(cmd, fzf_opts {prompt: ' EDIT '})
      vim.cmd 'e '..result[1]
    )!

  switch_buff: (using nil) ->
    import provided_win_fzf from require 'fzf'
    (coroutine.wrap (using nil) ->
      Floating.rel_to_win!

      buffers = vim.fn.getbufinfo{buflisted: 1}
      buffers = [ b.name for b in *buffers when #b.name != 0 ]

      result = provided_win_fzf(buffers, fzf_opts{prompt: ' BUFFER '})
      vim.cmd 'b '..result[1]
    )!
}
