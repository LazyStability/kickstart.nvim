vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require('ufo').setup {
  provider_selector = function(bufnr, filetype, buftype)
    return { 'lsp', 'indent' }
  end,
}
