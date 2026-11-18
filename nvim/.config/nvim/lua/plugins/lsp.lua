return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },
			-- Allows extra capabilities provided by blink.cmp
			"saghen/blink.cmp",
		},
		config = function()
			-- List LSP server
			local servers = {
				bashls = {},
				cssls = {},
				emmet_language_server = {},
				eslint = {},
				gopls = {},
				html = {},
				jsonls = {},
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
							},
							telemetry = { enabled = false },
						},
					},
				},
				marksman = {},
				oxlint = {
					root_markers = { ".oxlintrc.json" },
				},
				sqls = {},
				terraformls = {},
				yamlls = {},
			}

			local formatters = {
				prettierd = {},
				stylua = {},
			}

			local manually_installed_servers = {}
			local mason_tools_to_install = vim.tbl_keys(vim.tbl_deep_extend("force", {}, servers, formatters))
			local ensure_installed = vim.tbl_filter(function(name)
				return not vim.tbl_contains(manually_installed_servers, name)
			end, mason_tools_to_install)

			require("mason-tool-installer").setup({
				auto_update = true,
				run_on_start = true,
				start_delay = 3000,
				debounce_hours = 12,
				ensure_installed = ensure_installed,
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			-- By default, Neovim doesn't support everything that is in the LSP specification.
			-- When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
			-- So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- Use Blink.cmp capabilities if available, fallback to cmp_nvim_lsp
			local has_blink, blink = pcall(require, "blink.cmp")
			if has_blink then
				capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())
			else
				local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
				if has_cmp then
					capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
				end
			end

			-- Setup LspAttach autocmd for keybindings (replaces on_attach)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local bufnr = event.buf
					local bufname = vim.api.nvim_buf_get_name(bufnr)

					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

					-- Find references for the word under your cursor.
					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			--			vim.diagnostic.config({
			--				severity_sort = true,
			--				float = { border = "rounded", source = "if_many" },
			--				underline = { severity = vim.diagnostic.severity.ERROR },
			--				signs = vim.g.have_nerd_font and {
			--					text = {
			--						[vim.diagnostic.severity.ERROR] = "󰅚 ",
			--						[vim.diagnostic.severity.WARN] = "󰀪 ",
			--						[vim.diagnostic.severity.INFO] = "󰋽 ",
			--						[vim.diagnostic.severity.HINT] = "󰌶 ",
			--					},
			--				} or {},
			--				virtual_text = {
			--					source = "if_many",
			--					spacing = 2,
			--					format = function(diagnostic)
			--						local diagnostic_message = {
			--							[vim.diagnostic.severity.ERROR] = diagnostic.message,
			--							[vim.diagnostic.severity.WARN] = diagnostic.message,
			--							[vim.diagnostic.severity.INFO] = diagnostic.message,
			--							[vim.diagnostic.severity.HINT] = diagnostic.message,
			--						}
			--						return diagnostic_message[diagnostic.severity]
			--					end,
			--				},
			--			})

			-- Setup each LSP server using the new vim.lsp.config API
			for name, config in pairs(servers) do
				-- Configure the server
				vim.lsp.config(name, {
					cmd = config.cmd,
					capabilities = capabilities,
					filetypes = config.filetypes,
					settings = config.settings,
					root_dir = config.root_dir,
					root_markers = config.root_markers,
				})

				-- Enable the server (with autostart setting if specified)
				if config.autostart == false then
					-- Don't auto-enable servers with autostart = false
					-- Users can manually enable with :lua vim.lsp.enable(name)
				else
					vim.lsp.enable(name)
				end
			end

			-- Setup Mason for managing external LSP servers
			require("mason").setup({ ui = { border = "rounded" } })
			require("mason-lspconfig").setup()
		end,
	},
}
