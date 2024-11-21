return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  event = 'VeryLazy',
  config = function()
    require 'plugins.config.ufo'
  end,
}
