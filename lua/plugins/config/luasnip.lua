local M = {}
M.init = function()
  local ls = require 'luasnip'

  require('luasnip.loaders.from_lua').load { paths = vim.fn.stdpath 'config' .. '/lua/snippets' }
  ls.config.setup { enable_autosnippets = true }
end
M.init()
return M
