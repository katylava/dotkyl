-- Leader key (must be set before any mappings)
vim.g.mapleader = "\\"

-- Python provider
vim.g.python3_host_prog = vim.fn.exepath("python3")

-- File handling
vim.opt.binary = true
vim.opt.fileencoding = "utf-8"
vim.opt.fileformat = "unix"
vim.opt.fixeol = true
vim.opt.modeline = true
vim.opt.hidden = true

-- UI
vim.opt.number = true
vim.opt.ruler = true
vim.opt.laststatus = 2
vim.opt.cmdheight = 2
vim.opt.cursorcolumn = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.title = true
vim.opt.showbreak = "↪ "
vim.opt.colorcolumn = { "80", "100" }

-- Scrolling / wrapping
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.scrolloff = 3

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Folding
vim.opt.foldmethod = "indent"

-- Completion
vim.opt.completeopt = { "menu", "longest", "preview" }
vim.opt.shortmess:append("c")
vim.opt.updatetime = 300

-- Whitespace display
vim.opt.listchars = {
    space = "⋅",
    tab = "→ ",
    eol = "↲",
    nbsp = "␣",
    trail = "•",
    extends = "⟩",
    precedes = "⟨",
}

-- Bell
vim.opt.errorbells = false
vim.opt.visualbell = true

-- Backup
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.directory = vim.fn.expand("~/.tmp/nvim")

-- Grep
vim.opt.grepprg = "ag"

-- Text width
vim.opt.textwidth = 79

-- Keywords
vim.opt.iskeyword:append("-")

-- Mouse
vim.opt.mouse = "a"

-- Wildmenu
vim.opt.wildignore = { ".svn", ".git", ".env", "*.bak", "*.pyc", "*.DS_Store", "*.db", "venv" }
vim.opt.wildmenu = true
vim.opt.wildmode = { "list:longest" }

