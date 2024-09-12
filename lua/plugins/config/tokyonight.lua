local M = {}
-- your configuration comes here
-- or leave it empty to use the default settings
M.init = function()
  require('tokyonight').setup {
    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    style = 'moon',
    on_highlights = function(highlights, colors) end,
    on_colors = function(colors) end,
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
end
M.init()
return M
