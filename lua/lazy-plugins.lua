-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Git integration into nvim
  -- See `:help gitsigns` to understand what the configuration keys do
  require 'kickstart.plugins.gitsigns',

  -- Offers keybindings for the command you started
  -- For example <Leader> (telescope)
  require 'kickstart.plugins.which-key',

  -- Fuzzy search, improved c version
  require 'kickstart.plugins.telescope-fzf',

  -- Runs the lsps needed for the autocomplete of the cmp module
  require 'kickstart.plugins.lspconfig',

  -- Autoformat
  require 'kickstart.plugins.conform',

  -- Autocomplete
  require 'kickstart.plugins.cmp',

  -- Theme
  require 'kickstart.plugins.tokyonight',

  -- Highlight todo, notes, etc in comments
  require 'kickstart.plugins.todo-comments',

  -- Collection of various small independent plugins/modules
  require 'kickstart.plugins.mini',

  -- Highlight, edit, and navigate code
  require 'kickstart.plugins.treesitter',

  -- Game to learn vim motions
  require 'custom.plugins.vimbegood',

  -- Shows the history of changes to the file, enabling us to select our undo
  require 'custom.plugins.undotree',

  -- Gitintegration newer lua version
  require 'custom.plugins.neogit',

  -- Vimtex like gilles castel
  require 'custom.plugins.vimtex',

  -- Try out obsidian.nvim
  require 'custom.plugins.obsidian',

  -- Old tried and true method
  -- require 'custom.plugins.fugitive',

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
