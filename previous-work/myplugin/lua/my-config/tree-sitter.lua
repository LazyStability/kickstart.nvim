---@diagnostic disable: missing-fields
require('nvim-treesitter.configs').setup {
  -- ignore_install = { "all" },
  highlight = {
    enable = true,
    disable = { 'bigfile' },
    -- additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['ia'] = { query = '@parameter.inner', desc = 'inner argument' },
        ['aa'] = { query = '@parameter.outer', desc = 'around argument' },
      },
    },
  },
}
require('treesitter-context').setup {
  enable = true,
  max_lines = 4,
}

-- conflicts with treesitter
vim.opt.smartindent = false
vim.opt.foldmethod = 'expr' -- Use expression for folding
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- Use treesitter for folding
vim.opt.foldlevel = 99 -- Start with all folds open

-- autoclose and autorename html fields in non-native filetypes
require('nvim-ts-autotag').setup {
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false, -- Auto close on trailing </
  },
  -- Also override individual filetype configs, these take priority.
  -- Empty by default, useful if one of the "opts" global settings
  -- doesn't work well in a specific filetype
  -- per_filetype = {
  --   ["html"] = {
  --     enable_close = false
  --   }
  -- }
}
