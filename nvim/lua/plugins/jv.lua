return {
  { "nvim-treesitter/playground" },
  {
    "olimorris/onedarkpro.nvim",
    opts = {
      colors = {
        onedark_vivid = {
          bg = "require('onedarkpro.helpers').darken('bg', 7, 'onedark_vivid')",
        },
      },
      highlights = {
        Identifier = { link = "Normal" },
        ["@variable"] = { link = "Normal" },
      },
    },
  },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark_vivid",
    },
  },
  { "rcarriga/nvim-notify", enabled = false },
  {
    "folke/noice.nvim",
    opts = {
      views = {
        cmdline_popup = {
          position = { row = 15, col = "50%" },
        },
        popupmenu = {
          position = { row = 18, col = "50%" },
        },
      },
    },
  },
  { import = "lazyvim.plugins.extras.coding.copilot" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = { width = 25 },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        section_separators = { left = "", right = "" },
      },
    },
  },
  {
    "echasnovski/mini.indentscope",
    opts = {
      draw = {
        delay = 35,
        animation = function()
          return 0
        end,
      },
    },
  },
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      local header = [[
                                           
▀██▀▀█▄          ▀██  ▀██          ▀██     
 ██   ██   ▄▄▄    ██   ██   ▄▄▄▄    ██  ▄▄ 
 ██▄▄▄█▀ ▄█  ▀█▄  ██   ██  ▀▀ ▄██   ██ ▄▀  
 ██      ██   ██  ██   ██  ▄█▀ ██   ██▀█▄  
▄██▄      ▀█▄▄█▀ ▄██▄ ▄██▄ ▀█▄▄▀█▀ ▄██▄ ██▄
                                           
    ]]
      ---@diagnostic disable-next-line: missing-parameter
      opts.section.header.val = vim.split(header, "\n")
    end,
  },
}
