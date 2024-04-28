return {
  'lervag/vimtex',
  init = function()
    -- Use init for configuration, don't use the more common "config".
    vim.g.vimtex_view_general_viewer = 'zathura'
    -- vim.cmd("set conceallevel=1")
    vim.keymap.set('n', '<leader>tc', '<cmd>VimtexCompile<CR>', { desc = '[c]ompile the document' })
    vim.keymap.set('n', '<leader>tv', '<cmd>VimtexView<CR>', { desc = '[v]iew this line' })
  end,
}
