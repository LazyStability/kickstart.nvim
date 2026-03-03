-- Fidget, notification UI
require("fidget").setup({
	notification = {
		override_vim_notify = true,
		view = {
			stack_upwards = false,
		},
		window = {
			winblend = 0,
			align = "top",
		},
	},
})

require("tokyonight").setup({
	-- Load the colorscheme here.
	-- Like many other themes, this one has different styles, and you could load
	-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
	style = "moon",
	on_highlights = function(highlights, colors) end,
	on_colors = function(colors) end,
	transparent = true, -- Enable this to disable setting the background color
	terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
	styles = {
		-- Style to be applied to different syntax groups
		-- Value is any valid attr-list value for `:help nvim_set_hl`
		comments = { italic = false },
		keywords = { italic = false },
		-- Background styles. Can be "dark", "transparent" or "normal"
		sidebars = "transparent", -- style for sidebars, see below
		floats = "transparent", -- style for floating windows
	},
})

-- theme & transparency
vim.cmd.colorscheme("tokyonight")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

-- vim.list_extend(require("my-config.lazy.specs"), {}

vim.list_extend(require("my-config.lazy.specs"), {
	-- Status line
	{
		"lualine.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("lualine").setup()
		end,
	},
	-- Show special comments
	{
		"todo-comments.nvim",
		event = "VimEnter",
		after = function()
			require("todo-comments").setup({
				signs = false,
			})
		end,
	},
	{
		"which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		after = function() -- This is the function that runs, AFTER loading
			require("which-key").setup()
		end,
	},
	{
		"indent-blankline.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("ibl").setup({ indent = { highlight = highlight } })
		end,
	},
	{
		"render-markdown.nvim",
		ft = "markdown",
		after =function()
			require("render-markdown").setup({
			checkbox = {
				-- Turn on / off checkbox state rendering
				enabled = true,
				-- Determines how icons fill the available space:
				--  inline:  underlying text is concealed resulting in a left aligned icon
				--  overlay: result is left padded with spaces to hide any additional text
				position = "inline",
				unchecked = {
					-- Replaces '[ ]' of 'task_list_marker_unchecked'
					icon = "󰄱",
					-- Highlight for the unchecked icon
					highlight = "RenderMarkdownUnchecked",
					-- Highlight for item associated with unchecked checkbox
					scope_highlight = nil,
				},
				checked = {
					-- Replaces '[x]' of 'task_list_marker_checked'
					icon = " ",
					-- Highlight for the checked icon
					highlight = "RenderMarkdownChecked",
					-- Highlight for item associated with checked checkbox
					scope_highlight = nil,
				},
				custom = {
					todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
					RightArrow = {
						raw = "[>]",
						rendered = " ",
						highlight = "RenderMarkdownTodo",
						scope_highlight = nil,
					},
					canceled = {
						raw = "[-]",
						rendered = "",
						highlight = "RenderMarkdownTodo",
						scope_highlight = nil,
					},
					important = {
						raw = "[!]",
						rendered = " ",
						highlight = "RenderMarkdownTodo",
						scope_highlight = nil,
					},
				},
			},
		})
		end
	},
})
