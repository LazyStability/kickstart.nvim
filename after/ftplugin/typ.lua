-- set filetype to typst
local buf = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_option(buf, 'filetype', 'typst')
