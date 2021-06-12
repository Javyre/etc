-- Bootstrap Paq

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/paqs/opt/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/savq/paq-nvim '..install_path)
end
execute 'packadd paq-nvim'

local paq = require'paq-nvim'.paq
paq {'savq/paq-nvim', opt=true}

-- Bootstrap Moonscript

paq {'svermeulen/nvim-moonmaker'}
require 'init'
