return {
  'mrjones2014/smart-splits.nvim',
  build = './kitty/install-kittens.bash',
  config = function()
    require 'plugins.config.smart-splits'
  end,
}
