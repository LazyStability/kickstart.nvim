local M = {}
-- your configuration comes here
-- or leave it empty to use the default settings
M.init = function()
  require('tokyonight').setup {
    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    style = 'moon',
    transparent = true, -- Enable this to disable setting the background color
    terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
    styles = {
      -- Style to be applied to different syntax groups
      -- Value is any valid attr-list value for `:help nvim_set_hl`
      comments = { italic = false },
      keywords = { italic = false },
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = 'transparent', -- style for sidebars, see below
      floats = 'transparent', -- style for floating windows
    },
  }
  vim.cmd.colorscheme 'tokyonight'

  -- Make the window transpartent
  -- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' }),
  -- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' }),

  -- You can configure highlights by doing something like:
  -- vim.cmd.hi 'Comment gui=none',
end
M.init()
return M
