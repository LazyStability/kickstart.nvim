local M = {}
M.init = function()
  require('obsidian').setup {
    legacy_commands = false,
    workspaces = {
      {
        name = 'personal',
        path = '~/Dokumente/Personal',
        overrides = {
          daily_notes = {
            folder = 'Tagebuch/Täglich/thisYear',
            date_format = '%Y-%m-%d',
            template = 'Templates/Tagebuch/Täglicher_Eintrag_Template.md',
          },
        },
      },
      {
        name = 'DnD',
        path = '~/Dokumente/DNDVault',
      },
      {
        name = 'Zettelkasten',
        path = '~/Dokumente/Zettelkasten',
        overrides = {
          notes_subdir = 'Notizen',
          templates = {
            folder = 'Templates',
            date_format = '%Y-%m-%d',
            time_format = '%H:%M',
            -- A map for custom variables, the key should be the variable and the value a function
            customizations = {
              Notiz = {
                notes_subdir = 'Notizen',
              },
              MOC = {
                notes_subdir = 'MOCs',
                note_id_func = function(title)
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
                  return suffix
                end,
              },
              Reference = {
                notes_subdir = 'Literature',
              },
            },
            substitutions = {
              Topic = function()
                local picker = require('obsidian').picker
                return picker:find_notes()
              end,
            },
          },
        },
      },
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
    },
    callbacks = {
      enter_note = function(note)
        vim.ui.open = (function(overridden)
          return function(uri, opt)
            if vim.endswith(uri, '.png') then
              -- vim.cmd('edit ' .. uri) -- early return to just open in neovim
              opt = { cmd = { 'imv' } } -- override open app
              return
            elseif vim.endswith(uri, '.pdf') then
              opt = { cmd = { 'sioyek' } } -- override open app
            end
            return overridden(uri, opt)
          end
        end)(vim.ui.open)
        vim.keymap.set('n', '<leader>oc', '<cmd>Obsidian toggle_checkbox<cr>', {
          buffer = note.bufnr,
          desc = 'Toggle checkbox',
          --     opts = { buffer = true },
          --
        })
      end,
    },
    checkbox = {
      enable = true,
      order = { ' ', '>', 'x' },
    },
    -- mappings = {
    --   -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
    --   ['gf'] = {
    --     action = function()
    --       return require('obsidian').util.gf_passthrough()
    --     end,
    --     opts = { noremap = false, expr = true, buffer = true },
    --   },
    -- how default frontmatter is generated
    frontmatter = {
      func = function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
          note:add_alias('󱞁' .. note.title)
        end

        local out = { id = note.id, title = note.title, aliases = note.aliases, tags = note.tags, date = os.date '%Y-%m-%d' }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,
    },
    templates = {
      folder = 'Templates',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {
        -- Topic = function(client)
        --   local picker = client:picker()
        --   picker.findFiles
        -- end,
      },
    },
    -- attachments = {
    --   img_folder = 'Attachments',
    --   img_text_func = function(client, path)
    --     path = client:vault_relative_path(path) or path
    --     return string.format('![%s](%s)', path.name, path)
    --   end,
    --   confirm_img_paste = true,
    -- },
  }
end
M.init()
return M
