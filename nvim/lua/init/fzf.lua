local fun = require 'fun'

vim.fn.sign_define('JvStatusLineBG', {linehl = 'StatusLine'})

local Floating = {
    rel_to_vim = function()
        local info = vim.fn.getwininfo(vim.fn.win_getid())[1]
        local buf = vim.api.nvim_create_buf(false, true)
        return vim.api.nvim_open_win(buf, true, {
            relative = 'win',
            win = info.winid,
            anchor = 'SW',
            width = info.width,
            height = 15,
            row = info.height + 1,
            col = 0,
            style = 'minimal'
        })
    end,
    rel_to_win = function()
        local info = vim.fn.getwininfo(vim.fn.win_getid())[1]
        local buf = vim.api.nvim_create_buf(false, true)
        local height = math.min(info.height + 1, 15)
        vim.api.nvim_open_win(buf, true, {
            relative = 'win',
            win = info.winid,
            anchor = 'SW',
            width = info.width,
            height = height,
            row = info.height + 1,
            col = 0,
            style = 'minimal'
        })
        vim.cmd('set winhl=Normal:Normal')
        return vim.fn.sign_place(0, '', 'JvStatusLineBG', '', {lnum = height})
    end
}

local get_syn_attr = function(hl, attr)
    return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hl)), attr)
end

local fzf_opts = function(opts)
    if opts == nil then opts = {} end
    return string.format([[                        \
    --border=top                                 \
    --prompt='%s'                                \
    --color=16,query:regular,prompt:10,border:%s \
  ]], opts.prompt or '> ', get_syn_attr('VertSplit', 'fg#'))
end

return {
    find_file = function(gitignore)
        local I_flag = (gitignore and '-I') or ''
        local provided_win_fzf = require('fzf').provided_win_fzf

        return (coroutine.wrap(function()
            Floating.rel_to_win()
            local cmd = "fd -H " .. I_flag .. " -t f"
            local result = provided_win_fzf(cmd, fzf_opts({prompt = ' EDIT '}))
            return vim.cmd('e ' .. result[1])
        end))()
    end,

    switch_buff = function()
        local provided_win_fzf = require('fzf').provided_win_fzf
        return (coroutine.wrap(function()
            Floating.rel_to_win()

            local buffers = vim.fn.getbufinfo({buflisted = 1})
            buffers = fun.map(function(b) return b.name; end, buffers)
            buffers = buffers:filter(function(n) return #n ~= 0 end):totable()

            local result = provided_win_fzf(buffers,
                                            fzf_opts({prompt = ' BUFFER '}))
            return vim.cmd('b ' .. result[1])
        end))()
    end
}
