local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Filetype detection
autocmd("BufRead", { pattern = "*.gs", command = "set filetype=javascript" })
autocmd("BufRead", { pattern = "*.md", command = "set filetype=markdown" })
autocmd("BufRead", { pattern = "*.sql", command = "set filetype=sql" })
autocmd("BufRead", { pattern = "*.txt", command = "set filetype=markdown" })
autocmd("BufRead", { pattern = ".zsh*", command = "set filetype=sh" })
autocmd("BufRead", { pattern = ".npmrc", command = "set commentstring=#\\ %s" })

autocmd("BufRead", { pattern = "requirements.txt", command = "set filetype=text sw=2 ts=2" })
autocmd("BufRead", { pattern = "requirements/*.txt", command = "set filetype=text sw=2 ts=2" })

-- Filetype-specific settings
autocmd("FileType", {
    pattern = "cfg",
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.textwidth = 0
        vim.opt_local.commentstring = "# %s"
    end,
})
autocmd("FileType", {
    pattern = "css",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.textwidth = 0
    end,
})
autocmd("FileType", {
    pattern = { "javascript", "javascript.jsx" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.textwidth = 120
    end,
})
autocmd("FileType", {
    pattern = "json",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.foldmethod = "syntax"
        vim.bo.filetype = "json5"
    end,
})
autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.textwidth = 79
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.comments = "n:>"
    end,
})
autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.commentstring = "# %s"
        vim.opt_local.foldmethod = "indent"
    end,
})
autocmd("FileType", { pattern = "sql", command = "setlocal commentstring=--\\ %s" })
autocmd("FileType", { pattern = "toml", command = "setlocal tw=0" })
autocmd("FileType", {
    pattern = "yaml",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end,
})

-- Crontab: edit in place
autocmd("FileType", { pattern = "crontab", command = "setlocal nobackup nowritebackup" })

-- Tabs in python are bad
autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.cmd("highlight Tabs ctermbg=red guibg=red")
        vim.cmd("match Tabs /^\\t+/")
    end,
})

-- Automatically chmod +x shell scripts
autocmd("BufWritePost", { pattern = "*.sh", command = "silent !chmod +x %" })

-- Open file at last edited location
autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- Title string (requires FileDir from functions.lua)
autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        vim.opt.titlestring = vim.fn.expand("%:t") .. " ∈ " .. vim.fn["FileDir"]()
    end,
})

-- Remove html link/italic overrides from colorscheme
autocmd("ColorScheme", { pattern = "*", command = "hi link htmlLink NONE | hi link htmlItalic NONE" })

-- CoC: highlight symbol under cursor
autocmd("CursorHold", { pattern = "*", command = "silent call CocActionAsync('highlight')" })

-- CoC augroup
local coc_group = augroup("mygroup", { clear = true })
autocmd("FileType", {
    group = coc_group,
    pattern = { "typescript", "json" },
    command = "setl formatexpr=CocAction('formatSelected')",
})
autocmd("User", {
    group = coc_group,
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
})

-- Trailing whitespace highlighting
vim.cmd("highlight ExtraWhitespace ctermbg=red guibg=red")
vim.cmd([[match ExtraWhitespace /\s\+$/]])
autocmd("BufWinEnter", { pattern = "*", command = [[match ExtraWhitespace /\s\+$/]] })
autocmd("InsertEnter", { pattern = "*", command = [[match ExtraWhitespace /\s\+\%#\@<!$/]] })
autocmd("InsertLeave", { pattern = "*", command = [[match ExtraWhitespace /\s\+$/]] })
autocmd("BufWinLeave", { pattern = "*", command = "call clearmatches()" })
