local M = {}
-- your configuration comes here
-- or leave it empty to use the default settings
M.init = function()
  require('image').setup {
    backend = 'kitty',
    kitty_method = 'normal',
    processor = 'magick_cli', -- or "magick_cli"
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = true,
        filetypes = { 'markdown', 'vimwiki' }, -- markdown extensions (ie. quarto) can go here
      },
      neorg = {
        enabled = true,
        filetypes = { 'norg' },
      },
      typst = {
        enabled = true,
        only_render_image_at_cursor = true,
        filetypes = { 'typst' },
      },
      html = {
        enabled = false,
      },
      css = {
        enabled = false,
      },
    },
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
    window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
    editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
    tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
    hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' }, -- render image files as images when opened
    -- resolve_image_path = function(document_path, image_path, fallback)
    --   local working_dir = vim.fn.getcwd()
    --   -- Format image path for Obsidian notes
    --   if working_dir:find '~/Dokumente/Zettelkasten' then
    --     return working_dir .. '/' .. 'Attachments'
    --   elseif working_dir:find '~/Dokumente/Personal' then
    --     return working_dir .. '/' .. 'Attachments'
    --   end
    --   -- Fallback to the default behavior
    --   return fallback(document_path, image_path)
    -- end,
  }
end
M.init()
return M
