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
local paqs_path = vim.fn.stdpath('data') .. '/site/pack/paqs'
do
    local install_path = paqs_path .. '/start/paq-nvim'

    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.cmd('!git clone https://github.com/savq/paq-nvim ' .. install_path)
    end
end

require 'init'

InitTimer:stop()
