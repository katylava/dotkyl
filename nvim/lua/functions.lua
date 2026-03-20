-- FileDir: abbreviate current file's directory for display
-- Uses vim.fn.substitute for the lookbehind regex that Lua patterns can't handle
function FileDir()
    local d = vim.fn.expand("%:p:h")
    d = d:gsub("/Users/kyl/", "")
    d = d:gsub("Library/Mobile Documents/com~apple~CloudDocs", "icloud")
    d = d:gsub("Code/", "")
    d = d:gsub("Work/", "")
    d = d:gsub("%.dotkyl/", "…")
    -- Remove vowels unless at beginning of word (vim regex required for lookbehind)
    d = vim.fn.substitute(d, [[\(\<\)\@<![aeiou]], "", "g")
    -- Remove double letters
    d = d:gsub("([a-zA-Z])%1", "%1")
    -- Restore vowels where abbreviation looks bad
    d = d:gsub("%.rg/", ".org/")
    return d
end

-- ConflictsHighlight: highlight git merge conflict markers
function ConflictsHighlight()
    vim.cmd([[
        syn region conflictStart start=/^<<<<<<< .*$/ end=/^\ze\(=======$\||||||||\)/
        syn region conflictMiddle start=/^||||||| .*$/ end=/^\ze=======$/
        syn region conflictEnd start=/^\(=======$\||||||| |\)/ end=/^>>>>>>> .*$/
        highlight conflictStart ctermbg=red ctermfg=black
        highlight conflictMiddle ctermbg=blue ctermfg=black
        highlight conflictEnd ctermbg=green cterm=bold ctermfg=black
    ]])
end

-- Window swap: mark one split, then call again in another to swap buffers
-- from https://stackoverflow.com/a/15508593/111362
local marked_win_num = -1

local function do_window_swap()
    local cur_num = vim.fn.winnr()
    local cur_buf = vim.fn.bufnr("%")
    vim.cmd(marked_win_num .. "wincmd w")
    local marked_buf = vim.fn.bufnr("%")
    vim.cmd("hide buf " .. cur_buf)
    vim.cmd(cur_num .. "wincmd w")
    vim.cmd("hide buf " .. marked_buf)
end

function WindowSwapping()
    if marked_win_num == -1 then
        marked_win_num = vim.fn.winnr()
    else
        do_window_swap()
        marked_win_num = -1
    end
end

-- Theme functions: Apply dark/light palette with indent guide colors
-- These interact with lightline (vimscript plugin) so they use vim.cmd
function ApplyDark()
    vim.opt.background = "dark"
    vim.cmd("hi lineNr guibg=#282828")
    vim.g.indent_guides_odd_color = "#233046"
    vim.g.indent_guides_even_color = "#2F3648"
    vim.cmd("hi IndentGuidesOdd guibg=" .. vim.g.indent_guides_odd_color)
    vim.cmd("hi IndentGuidesEven guibg=" .. vim.g.indent_guides_even_color)
    if vim.g.lightline then
        vim.cmd("runtime autoload/lightline/colorscheme/catppuccin.vim")
        vim.fn["lightline#init"]()
        vim.fn["lightline#colorscheme"]()
        vim.fn["lightline#update"]()
    end
end

function ApplyLight()
    vim.opt.background = "light"
    vim.cmd("hi lineNr guibg=#C8C8A8 guifg=#282828")
    vim.g.indent_guides_odd_color = "#C3D0C6"
    vim.g.indent_guides_even_color = "#CFD6C8"
    vim.cmd("hi IndentGuidesOdd guibg=" .. vim.g.indent_guides_odd_color)
    vim.cmd("hi IndentGuidesEven guibg=" .. vim.g.indent_guides_even_color)
    if vim.g.lightline then
        vim.cmd("runtime autoload/lightline/colorscheme/catppuccin.vim")
        vim.fn["lightline#init"]()
        vim.fn["lightline#colorscheme"]()
        vim.fn["lightline#update"]()
    end
end

-- Lightline component functions (must be global — lightline calls them by name)
function LightlineModified()
    if vim.bo.filetype == "help" then
        return ""
    elseif vim.bo.modified then
        return "+"
    else
        return ""
    end
end

function LightlineReadonly()
    if vim.bo.filetype == "help" then
        return ""
    elseif vim.bo.readonly then
        return "\u{e0a2}"
    else
        return ""
    end
end

function LightlineFugitive()
    if vim.fn.exists("*FugitiveHead") == 1 then
        local branch = vim.fn.FugitiveHead()
        if branch ~= "" then
            return " " .. branch
        end
    end
    return ""
end

function LightlineFilename()
    local ro = LightlineReadonly()
    local name = vim.fn.expand("%:t")
    if name == "" then
        name = "[No Name]"
    end
    local mod = LightlineModified()
    local result = ""
    if ro ~= "" then
        result = ro .. " "
    end
    result = result .. name
    if mod ~= "" then
        result = result .. " " .. mod
    end
    return result
end

function LightlineTime()
    return os.date("%H:%M")
end

function LightlineDevicon(n)
    local buflist = vim.fn.tabpagebuflist(n)
    local winnr = vim.fn.tabpagewinnr(n)
    local fname = vim.fn.expand("#" .. buflist[winnr] .. ":t")
    return vim.fn.WebDevIconsGetFileTypeSymbol(fname)
end

function LightlineFileformat()
    if vim.fn.winwidth(0) > 120 then
        return vim.bo.fileformat
    end
    return ""
end

function LightlineFiletype()
    if vim.fn.winwidth(0) > 120 then
        return vim.bo.filetype ~= "" and vim.bo.filetype or "no ft"
    end
    return ""
end

function LightlineFileencoding()
    if vim.fn.winwidth(0) > 120 then
        return vim.bo.fileencoding
    end
    return ""
end
