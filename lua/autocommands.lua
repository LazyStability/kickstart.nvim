-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[Basic Skeletons]]
-- See `:help skeletons`

-- When creating files with the mentioned extensions it will fill them with the template files
local skeletons = vim.api.nvim_create_augroup('skeletons', { clear = true })
vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*.tex',
  group = skeletons,
  command = 'r ~/Dokumente/Skeleton_files/LaTex/Root.tex',
})
vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*.h',
  group = skeletons,
  command = 'r ~/Dokumente/Skeleton_files/cpp/basic_header.h',
})
vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*.cpp',
  group = skeletons,
  command = 'r ~/Dokumente/Skeleton_files/cpp/basic_source_file.cpp',
})
