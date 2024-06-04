local vimTex = {}

vimTex.init = function()
  -- Use init for configuration, don't use the more common "config".
  vim.g.vimtex_view_general_viewer = 'zathura'
  -- vim.cmd("set conceallevel=1")
  vim.keymap.set('n', '<leader>tc', '<cmd>VimtexCompile<CR>', { desc = '[c]ompile the document' })
  vim.keymap.set('n', '<leader>tv', '<cmd>VimtexView<CR>', { desc = '[v]iew this line' })
  vim.keymap.set('n', '<leader>ti', '<cmd>VimtexTocOpen<CR>', { desc = '[I]ndex' })
  vim.keymap.set('n', '<leader>tr', '<cmd>VimtexClean<CR>', { desc = '[R]emove the aux' })
  vim.keymap.set('n', '<leader>tm', '<cmd>VimtexContextMenu<CR>', { desc = 'Context [m]enu' })
end

vimTex.init()

return vimTex
