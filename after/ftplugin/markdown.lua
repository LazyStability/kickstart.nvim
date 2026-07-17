local function codelens_supported(bufnr)
  for _, c in ipairs(vim.lsp.get_clients { name = 'markdown_oxide' }) do
    if c.server_capabilities and c.server_capabilities.codeLensProvider then
      return true
    end
  end
  return false
end
local group = vim.api.nvim_create_augroup('markdown_oxide', { clear = true })

vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave', 'CursorHold', 'BufEnter' }, {
  buffer = bufnr,
  group = group,
  callback = function()
    if codelens_supported(bufnr) and vim.lsp.codelens.enable ~= nil then
      -- vim.lsp.codelens.refresh()
      vim.lsp.codelens.enable(true, { bufnr = bufnr })
    end
  end,
})

-- setup Markdown Oxide daily note commands
-- local markdown_oxide = vim.lsp.get_clients { name = 'markdown_oxide' }
-- if markdown_oxide ~= nil then
--   vim.api.nvim_create_user_command('Daily', function(args)
--     local input = args.args
--
--     vim.lsp.buf.execute_command { command = 'jump', arguments = { input } }
--   end, { desc = 'Open daily note', nargs = '*' })
-- end

-- vim.api.nvim_create_autocmd('BufEnter', { print 'markdown file' })
