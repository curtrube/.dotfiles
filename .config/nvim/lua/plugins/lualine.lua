return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
			options = {
				-- Set the lualine theme to 'catppuccin'
				theme = catppuccin,
				globalstatus = true,
				icons_enabled = true,
			},
		})
	end,
}
