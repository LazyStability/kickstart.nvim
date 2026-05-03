local M = {}

local function getWeekDays()
  local current = os.time()
  local currentDay = os.date('%w', current) -- 0 = Sunday, 1 = Monday
  local mondayOffset = (currentDay == 0) and 6 or (currentDay - 1)

  local weekDays = {}
  local dayNames = { 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday' }

  for i = 1, 7 do
    local day = os.time() + (i - 1 - mondayOffset) * 24 * 60 * 60
    local dateStr = os.date('%Y-%m-%d', day)
    local dayName = dayNames[i]
    weekDays[i] = {
      name = dayName,
      date = dateStr,
      timestamp = day,
    }
  end
  return weekDays
end

-- Compact version using string patterns
local function getBulletPointsCompact(filePath)
  local file = io.open(filePath, 'r')
  if not file then
    return {}
  end

  local content = file:read '*all'
  file:close()

  local bullets = ''
  local inBullets = false

  local lines = content:split '\n'
  for _, line in ipairs(lines) do
    if vim.startswith(line, '### Bullet Points') then
      if not inBullets then
        bullets = bullets .. line .. '\n'
        inBullets = true
      end
    elseif vim.startswith(line, '#') then
      inBullets = false
      break
    elseif inBullets then
      bullets = bullets .. line .. '\n'
    end
  end

  return bullets
end

local function new_note_id(title, suffix)
  -- Fuck Ids
  -- In this case a note with the title 'My new note' will be given an ID that looks
  -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
  local suffix = suffix
  if suffix == '' then
    suffix = os.date '%Y-%m-%d' .. '-'
  end
  if title ~= nil then
    -- If title is given, transform it into valid file name.
    suffix = suffix .. title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
  else
    -- If title is nil, just add 4 random uppercase letters to the suffix.
    for _ = 1, 4 do
      suffix = suffix .. string.char(math.random(65, 90))
    end
  end
  return suffix
end

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
          templates = {
            substitutions = {
              -- Topic = function()
              --   local picker = require('obsidian').picker
              --   return picker:find_notes()
              -- end,
              weekSummary = function()
                local summary = ''
                local weekDays = getWeekDays()
                for _, day in pairs(weekDays) do
                  -- path = 'Tagebuch/Täglich/thisYear/%s'
                  summary = summary
                    .. string.format('[%s](Tagebuch/Täglich/thisYear/%s.md#Bullet Points)\n', day.name, day.date)
                    .. getBulletPointsCompact(string.format('~/Dokumente/Personal' .. 'Tagebuch/Täglich/thisYear/%s.md', day.date))
                end
                return summary
              end,
            },
          },
        },
      },
      {
        name = 'DnD',
        path = '~/Dokumente/DNDVault',
        overrides = {
          notes_subdir = '4-archieve',
        },
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
                  return new_note_id(title, 'M-')
                end,
              },
              Reference = {
                notes_subdir = 'Literature',
                note_id_func = function(title)
                  return new_note_id(title, 'L-')
                end,
              },
            },
          },
        },
      },
    },

    -- see below for full list of options 👇
    new_notes_location = 'Verschiedenes/',
    note_id_func = function(title)
      return new_note_id(title, '')
    end,
    link = { style = 'markdown', format = 'absolute' },
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
        vim.keymap.set('n', '<leader>ot', '<cmd>Obsidian tags<CR>', { desc = 'Search through all occurences of a tag' })
        vim.keymap.set('n', '<leader>ont', '<cmd>Obsidian new_from_template<CR>', { desc = 'Create a new note from a template' })
        vim.keymap.set('n', '<leader>onn', '<cmd>Obsidian new<CR>', { desc = 'Create a new note' })
        vim.keymap.set('n', '<leader>od', function()
          vim.ui.input({ prompt = 'Enter a day: ' }, function(input)
            if not input or input == '' then
              input = 0
            end
            vim.cmd('Obsidian today ' .. input)
          end)
        end, { desc = 'Open a daily note' })
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
