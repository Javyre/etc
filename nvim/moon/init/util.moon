Callbacks = {
  next_id: 1
  callbacks: {}

  reg_callback: (cb using nil) =>
    id = @next_id
    @callbacks[id] = cb
    @next_id += 1
    id

  reg_callback_cmd: (cmd) =>
    if type(cmd) == 'function'
      cmd = string.format(
        'lua require"init.util".Callbacks.callbacks[%s]()',
        @reg_callback(cmd)
      )
    cmd
}

Hook = (using nil) -> {
  fns: {}
  hook: (fn) =>
    table.insert @fns, fn
  emit: (...) =>
    fn(...) for fn in *@fns
}

autocmd = (args using nil) ->
  {event, pat, cmd} = args
  if type(pat) == 'table'
    pat = table.concat pat, ','

  vim.cmd string.format 'autocmd %s %s %s', event, pat,
    Callbacks\reg_callback_cmd(cmd)

augroup = (name, aucmds) ->
  vim.cmd 'augroup '..name
  vim.cmd 'autocmd!'
  autocmd c for c in *aucmds
  vim.cmd 'augroup END'

{
  :Callbacks
  :Hook
  :autocmd
  :augroup
}
