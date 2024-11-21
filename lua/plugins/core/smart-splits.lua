return {
  'mrjones2014/smart-splits.nvim',
  build = './kitty/install-kittens.bash',
  event = 'VeryLazy',
  config = function()
    require 'plugins.config.smart-splits'
  end,
}
