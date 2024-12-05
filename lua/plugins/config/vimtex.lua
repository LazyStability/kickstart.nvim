local vimTex = {}

vimTex.init = function()
  -- Use init for configuration, don't use the more common "config".
  vim.g.vimtex_view_method = 'zathura'
  vim.g.vimtex_view_general_viewer = 'okular'
  -- vim.cmd("set conceallevel=1")
end

vimTex.init()

return vimTex
