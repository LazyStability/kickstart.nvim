-- Neogit
local M = {}
-- your configuration comes here
-- or leave it empty to use the default settings
M.init = function() end
require('neogit').setup {
  integrations = { diffview = true },
  vim.keymap.set('n', '<leader>hn', '<cmd>Neogit<cr>', { desc = 'open [n]eogit' }),
  vim.keymap.set('n', '<leader>hn', '<cmd>Neogit<cr>', { desc = 'open [n]eogit' }),
}
M.init()
return M
