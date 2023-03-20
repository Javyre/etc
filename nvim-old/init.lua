Timer = {
    start = function()
        return {
            start_time = vim.loop.hrtime(),
            stop = function(self)
                local time = (vim.loop.hrtime() - self.start_time) / 1000000
                vim.schedule(function()
                    print(string.format('Elapsed time: %f msecs', time))
                end)
            end
        }
    end
}

local InitTimer = Timer.start()

-- Bootstrap Paq
local function clone_paq()
    local path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
    if vim.fn.empty(vim.fn.glob(path)) > 0 then
        vim.fn.system {
            'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git',
            path
        }
    end
end
clone_paq()
vim.cmd('packadd paq-nvim')

require 'init'

InitTimer:stop()
