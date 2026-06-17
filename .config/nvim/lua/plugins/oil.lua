vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		vim.opt_local.colorcolumn = ""
	end,
})


vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

return {
	{
		"stevearc/oil.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				-- use_default_keymaps = false,
				confirmation = {
					border = "rounded",
				},
				float = {
					border = "rounded",
				},
				keymaps = {
					["<C-l>"] = false,
					["<C-r>"] = "actions.refresh",
				},
				view_options = {
					show_hidden = true,
				},
			})
		end,
	},
}
