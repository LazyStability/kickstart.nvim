--[[
  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.
  Next, run AND READ `:help`.

   NOTE: Don't touch this file
   Just Lazy installions copy and pasted
--]]

-- Load basic options
require 'options'

-- Load basic keymaps
require 'keymaps'

-- Load autocommands
require 'autocommands'

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({ import = 'plugins/core' }, {
  change_detection = {
    notify = false,
  },
})
-- vim: ts=2 sts=2 sw=2 et
-- -- The line beneath this is called `modeline`. See `:help modeline`
-- -- vim: ts=2 sts=2 sw=2 et
