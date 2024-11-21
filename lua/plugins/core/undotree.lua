-- Gives a history of all actions to navigate for undos.
return {
  'mbbill/undotree',

  config = function()
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Show the [U]ndotree' })
  end,
  event = 'VeryLazy',
}
