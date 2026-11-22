return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				html = { "prettier" },
				css = { "prettier" },
				javascript = { "oxfmt", "biome", "prettierd", stop_after_first = true },
				javascriptreact = { "oxfmt", "biome", "prettierd", stop_after_first = true },
				typescript = { "oxfmt", "biome", "prettierd", stop_after_first = true },
				typescriptreact = { "oxfmt", "biome", "prettierd", stop_after_first = true },
				lua = { "stylua" },
				markdown = { "prettier" },
				json = { "prettier" },
				python = { "ruff_organize_imports", "ruff_format" },
			},
			formatters = {
				oxfmt = {
					condition = function(_, ctx)
						return vim.fs.find({ ".oxfmtrc.json", ".oxfmtrc.jsonc" }, {
							path = ctx.filename,
							upward = true,
							stop = vim.uv.os_homedir(),
						})[1] ~= nil
					end,
				},
				biome = {
					condition = function(_, ctx)
						return vim.fs.find({ "biome.json", "biome.jsonc" }, {
							path = ctx.filename,
							upward = true,
							stop = vim.uv.os_homedir(),
						})[1] ~= nil
					end,
				},
				prettierd = {
					condition = function(_, ctx)
						return vim.fs.find({
							".prettierrc",
							".prettierrc.json",
							".prettierrc.js",
							".prettierrc.cjs",
							".prettierrc.mjs",
							".prettier.config.js",
							".prettier.config.cjs",
							".prettier.cofnig.mjs",
						}, {
							path = ctx.filename,
							upward = true,
							stop = vim.uv.os_homedir(),
						})[1] ~= nil
					end,
				},
			},
		},
	},
}
