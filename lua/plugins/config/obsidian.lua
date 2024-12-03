local M = {}
M.init = function()
  require('obsidian').setup {
    workspaces = {
      {
        name = 'personal',
        path = '~/Dokumente/Personal',
        overrides = {
          daily_notes = {
            folder = 'Tagebuch/Täglich/thisYear',
            date_format = '%Y-%m-%d',
            template = 'Templates/Tagebuch/Täglicher_Eintrag_Template',
          },
        },
      },
      {
        name = 'DnD',
        path = '~/Dokumente/DNDVault',
      },
      { name = 'Zettelkasten', path = '~/Dokumente/Zettelkasten', overrides = {
        notes_subdir = 'Notizen',
      } },
    },

    -- see below for full list of options 👇
    new_notes_location = 'Verschiedenes/',
    note_id_func = function(title)
      -- Fuck Ids
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ''
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return os.date '%Y-%m-%d' .. '-' .. suffix
    end,
    preferred_link_style = 'Markdown',
    ui = {
      enable = false, -- set to false to disable all additional syntax features
      --   update_debounce = 200, -- update delay after a text change (in milliseconds)
      --   -- Define how various check-boxes are displayed
      --   checkboxes = {
      --     -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
      --     -- [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
      --     -- ['x'] = { char = '', hl_group = 'ObsidianDone' },
      --     -- ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
      --     -- ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
      --     -- Replace the above with this if you don't have a patched font:
      --     [' '] = { char = '☐', hl_group = 'ObsidianTodo' },
      --     ['x'] = { char = '✔', hl_group = 'ObsidianDone' },
      --     ['X'] = { char = '✔', hl_group = 'ObsidianDone' },
      --
      --     -- You can also add more custom ones...
      --   },
      --   -- Use bullet marks for non-checkbox lists.
      --   bullets = { char = '•', hl_group = 'ObsidianBullet' },
      --   -- external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
      --   -- Replace the above with this if you don't have a patched font:
      --   external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
      --   reference_text = { hl_group = 'ObsidianRefText' },
      --   highlight_text = { hl_group = 'ObsidianHighlightText' },
      --   tags = { hl_group = 'ObsidianTag' },
      --   block_ids = { hl_group = 'ObsidianBlockID' },
      --   hl_groups = {
      --     -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
      --     ObsidianTodo = { bold = true, fg = '#f78c6c' },
      --     ObsidianDone = { bold = true, fg = '#89ddff' },
      --     ObsidianRightArrow = { bold = true, fg = '#f78c6c' },
      --     ObsidianTilde = { bold = true, fg = '#ff5370' },
      --     ObsidianBullet = { bold = true, fg = '#89ddff' },
      --     ObsidianRefText = { underline = true, fg = '#c792ea' },
      --     ObsidianExtLinkIcon = { fg = '#c792ea' },
      --     ObsidianTag = { italic = true, fg = '#89ddff' },
      --     ObsidianBlockID = { italic = true, fg = '#89ddff' },
      --     ObsidianHighlightText = { bg = '#75662e' },
      --   },
    },
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ['gf'] = {
        action = function()
          return require('obsidian').util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ['<leader>ch'] = {
        action = function()
          return require('obsidian').util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      ['<cr>'] = {
        action = function()
          return require('obsidian').util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },
    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      -- vim.fn.jobstart { 'open', url } -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
      -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      vim.ui.open(url) -- need Neovim 0.10.0+
    end,
    --
    -- how default frontmatter is generated
    note_frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then
        note:add_alias(note.title)
        note:add_alias('󱞁' .. note.title)
      end

      local out = { aliases = note.aliases, tags = note.tags, Datum = os.date '%Y-%m-%d' }

      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,
    attachments = {
      img_folder = 'Attachments',
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        return string.format('![%s](%s)', path.name, path)
      end,
      confirm_img_paste = true,
    },
  }
end
M.init()
return M
