local M = {}
-- your configuration comes here
-- or leave it empty to use the default settings
M.init = function()
  require('kitty-scrollback').setup {
    -- vim.keymap.set('n', require('kitty-scrollback.api').execute_command(), 'ENTER', { desc = 'Execute the contents of the paste window in Kitty' }),
  }
end
M.init()
return M
