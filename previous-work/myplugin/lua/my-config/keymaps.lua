-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Set keymap for netrw
vim.keymap.set("n", "<leader>F", vim.cmd.Ex, { desc = "[F]ile system mode" })
vim.keymap.set("n", "<leader>s", ":find ", { desc = "[s]earch file" })

-- Set move marked lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Copy & cut to system clipboard
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

-- Navigate quickfix list
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "[p]revious item in the quickfix list" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "[n]ext item in the quickfix list" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "next item in the location list" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "previous item in the location list" })

-- Replace current word in whole file
vim.keymap.set(
	"n",
	"<leader>r",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "[r]eplace current hovered word in whole file" }
)

-- Quality of life changes
-- Centering after down a page
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Copy Full File-Path
vim.keymap.set("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, { desc = "copy current file path" })

-- Lazy Plugins
vim.list_extend(require("my-config.lazy.specs"), {
	{
		"gitsigns.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end)

					map("n", "[c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end)

					-- Actions
					map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git [s]tage hunk" })
					map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git [r]eset hunk" })

					map("v", "<leader>hs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Git [s]tage hunk" })

					map("v", "<leader>hr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Git [r]eset hunk" })

					map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git [s]tage buffer" })
					map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git [r]eset buffer" })
					map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Git [p]review hunk" })
					map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Git preview hunk [i]nline" })

					map("n", "<leader>hb", function()
						gitsigns.blame_line({ full = true })
					end, { desc = "Git [b]lame line" })

					map("n", "<leader>hd", gitsigns.diffthis, { desc = "Git [d]iff this" })

					map("n", "<leader>hD", function()
						gitsigns.diffthis("~")
					end, { desc = "Git [d]iff this all" })

					map("n", "<leader>hQ", function()
						gitsigns.setqflist("all")
					end, { desc = "Git open [Q]uickfix list all" })
					map("n", "<leader>hq", gitsigns.setqflist, { desc = "Git open [q]uickfix list" })

					-- Toggles
					map(
						"n",
						"<leader>tb",
						gitsigns.toggle_current_line_blame,
						{ desc = "Git [t]oggle current line [b]lame" }
					)
					map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Git [t]oggle [w]ord diff" })

					-- Text object
					map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Git [s]elect hunk" })
				end,
			})
		end,
	},
	{
		"neogit",
		after = function()
			require("my-config.lazy").packadd("plenary.nvim")
			require("my-config.lazy").packadd("diffview.nvim")
			require("diffview").setup()
			require("neogit").setup({
				integrations = { diffview = true },
				vim.keymap.set("n", "<leader>hn", "<cmd>Neogit<cr>", { desc = "open [n]eogit" }),
			})
		end,
	},
	{
		"undotree",
		after = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Show the [U]ndotree" })
		end,
	},
	{
		"conform.nvim",
		cmd = "Format",
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		after = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					nix = { "nixfmt" },
					c = { "clang-format" },
					typst = { "typstyle" },
					rust = { "rustfmt" },
					haskell = { "fourmolu" },
				},
				format_on_save = {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})

			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = true, lsp_format = "fallback", range = range })
			end, { range = true })
		end,
	},
	-- Controls interaction between a multiplexer and vim
	{
		"smart-splits.nvim",
		event = "VimEnter",
		after = function()
			require("smart-splits").setup({
				-- resizing splits
				-- these keymaps will also accept a range,
				-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
				vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left),
				vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down),
				vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up),
				vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right),
				-- moving between splits
				vim.keymap.set("n", "<CS-h>", require("smart-splits").move_cursor_left),
				vim.keymap.set("n", "<CS-j>", require("smart-splits").move_cursor_down),
				vim.keymap.set("n", "<CS-k>", require("smart-splits").move_cursor_up),
				vim.keymap.set("n", "<CS-l>", require("smart-splits").move_cursor_right),
				vim.keymap.set("n", "<CS-\\>", require("smart-splits").move_cursor_previous),
				-- swapping buffers between windows
				vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left),
				vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down),
				vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up),
				vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right),
			})
		end,
	},
	{

		"kitty-scrollback.nvim",
		enabled = true,
		lazy = true,
		cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
		event = { "User KittyScrollbackLaunch" },
		config = function()
			require("kitty-scrollback").setup({})
		end,
	},
	{
		"vim-nix",
		ft = { "nix" },
	},
	{
		"vimplugin-nvim-surround",
		-- event = "VeryLazy",
		after = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
})
