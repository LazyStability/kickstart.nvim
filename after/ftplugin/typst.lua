-- set filetype to typst
-- local buf = vim.api.nvim_get_current_buf()
-- vim.api.nvim_buf_set_option(buf, 'filetype', 'typst')

local function ScreenshotFig()
  local attachment = vim.fn.expand '<cfile>'
  if attachment == '' then
    vim.notify('No file path under cursor, fallback to default', vim.log.levels.ERROR)
    attachment = 'attachments'
  end

  local cfile_dir = vim.fn.fnamemodify(attachment, ':h')

  -- Runs completely in the background, never freezes Neovim
  vim.system({
    'bash',
    '-c',
    string.format(
      [[
				set -euo pipefail
				mkdir -p %s
				TEMP=$(mktemp --suffix=.png)
				wl-paste --type image/png > "$TEMP"
				inkscape "$TEMP" -o %s
				rm "$TEMP"
  ]],
      vim.fn.shellescape(cfile_dir),
      vim.fn.shellescape(attachment)
    ),
  }, {}, function(out)
    vim.schedule(function()
      if out.code == 0 then
        vim.notify(string.format('Saved screenshot to %s', attachment))
      else
        vim.notify(string.format('Screenshot failed: %s', out.stderr), vim.log.levels.ERROR)
      end
    end)
  end)
end

local function open_or_create_inkscape(svg_path)
  -- If no path is provided, use the path under the cursor
  svg_path = svg_path or vim.fn.expand '<cfile>'

  if svg_path == '' then
    vim.notify('No SVG path under cursor', vim.log.levels.ERROR)
    return
  end

  -- Create parent directory if it doesn't exist
  local dir = vim.fn.fnamemodify(svg_path, ':h')
  vim.fn.mkdir(dir, 'p')

  -- Your exact template, fixed and unmodified
  local svg_template = [[<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!-- Created with Inkscape (http://www.inkscape.org/) -->

<svg
   width="160mm"
   height="80mm"
   viewBox="0 0 160 80"
   version="1.1"
   id="svg5"
   inkscape:version="1.2.2 (b0a8486541, 2022-12-01)"
   sodipodi:docname="drawing.svg"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg">
  <sodipodi:namedview
     id="namedview7"
     pagecolor="#ffffff"
     bordercolor="#000000"
     borderopacity="0.25"
     inkscape:showpageshadow="2"
     inkscape:pageopacity="0.0"
     inkscape:pagecheckerboard="0"
     inkscape:deskcolor="#dddddd"
     inkscape:document-units="mm" />
  <defs
     id="defs2" />
  <g
     inkscape:label="Layer 1"
     inkscape:groupmode="layer"
     id="layer1" />
</svg>]]

  -- Create file only if it does not already exist
  if not vim.uv.fs_stat(svg_path) then
    local f, err = io.open(svg_path, 'w')
    if not f then
      vim.notify('Failed to write SVG: ' .. err, vim.log.levels.ERROR)
      return
    end
    f:write(svg_template)
    f:close()
    vim.notify('Created new SVG: ' .. svg_path)
  else
    vim.notify('Opening existing SVG: ' .. svg_path)
  end

  -- Open Inkscape completely detached from Neovim
  vim.system({ 'inkscape', svg_path }, {
    detach = true,
    stdio = { 'ignore', 'ignore', 'ignore' },
  })
end

vim.keymap.set('n', '<leader>pi', ScreenshotFig, { desc = 'imports latest screenshot from clipboard' })
vim.keymap.set('n', '<leader>i', open_or_create_inkscape, { desc = 'Open a (new) inkscape image' })
