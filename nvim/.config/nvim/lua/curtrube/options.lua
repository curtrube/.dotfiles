-- See `:help vim.o`

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.netrw_banner = 0

-- Enable relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Disable showing the mode below the statusline
vim.opt.showmode = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Disable text wrap
vim.opt.wrap = false
vim.opt.smartindent = true
vim.opt.inccommand = "split"

-- Better splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- Enable ignorecase + smartcase for better searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.laststatus = 3

-- Enable persistent undo history
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true

-- Enable 24-bit color
vim.opt.termguicolors = true

-- Enable the sign column to prevent the screen from jumping
vim.opt.signcolumn = "yes"

-- Enable incremental searching
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Enable access to System Clipboard
vim.opt.clipboard = "unnamed,unnamedplus"

-- Enable cursor line highlight
vim.opt.cursorline = true

-- Enable break indent
vim.o.breakindent = true

-- Always keep 8 lines above/below cursor unless at start/end of file
vim.opt.scrolloff = 8

-- Folding
vim.o.foldenable = true
vim.o.foldmethod = "manual"
vim.o.foldlevel = 99
vim.o.foldcolumn = "0"

-- Hightlight yanking
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')
