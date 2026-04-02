-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Colorscheme (load first)
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "auto",
                background = { light = "latte", dark = "frappe" },
                transparent_background = false,
                dim_inactive = { enabled = false },
            })
            vim.cmd.colorscheme("catppuccin")

            vim.api.nvim_create_user_command("Dark", function() ApplyDark() end, {})
            vim.api.nvim_create_user_command("Light", function() ApplyLight() end, {})

            if vim.env.TERM_PALETTE == "light" then
                ApplyLight()
            else
                ApplyDark()
            end
        end,
    },

    -- CSV utilities
    { "chrisbra/csv.vim", ft = "csv" },

    -- .editorconfig support
    { "editorconfig/editorconfig-vim" },

    -- AI programmer
    {
        "github/copilot.vim",
        init = function()
            vim.g.copilot_no_tab_map = true
        end,
    },

    -- Align text (:Tabularize)
    { "godlygeek/tabular" },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "catppuccin", "ryanoasis/vim-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    section_separators = { left = "\u{e0b0}", right = "\u{e0b2}" },
                    component_separators = { left = "\u{e0b1}", right = "\u{e0b3}" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { { "branch", icon = "\u{e0a0}" } },
                    lualine_c = { FileDir, { "filename", path = 0, symbols = { modified = " +", readonly = " \u{e0a2}" } } },
                    lualine_x = {
                        { "fileformat", cond = function() return vim.fn.winwidth(0) > 120 end },
                        { "encoding", cond = function() return vim.fn.winwidth(0) > 120 end },
                        { "filetype", cond = function() return vim.fn.winwidth(0) > 120 end },
                    },
                    lualine_y = { function() return os.date("%H:%M") end },
                    lualine_z = { { "progress" }, { "location" } },
                },
                inactive_sections = {
                    lualine_a = { "mode" },
                    lualine_b = {},
                    lualine_c = { FileDir, { "filename", path = 0 } },
                    lualine_x = {},
                    lualine_y = { "progress", "location" },
                    lualine_z = {},
                },
                tabline = {
                    lualine_a = {
                        {
                            "tabs",
                            mode = 2, -- tab number + name
                            max_length = vim.o.columns,
                        },
                    },
                },
            })
        end,
    },

    -- Fuzzy finder
    { "junegunn/fzf", dir = "~/.fzf", build = "./install --all" },
    {
        "junegunn/fzf.vim",
        init = function()
            vim.g.fzf_layout = { down = "~40%" }
            vim.g.fzf_command_prefix = "Fzf"
        end,
    },

    -- Custom text objects
    { "kana/vim-textobj-user" },

    -- File finder
    {
        "kien/ctrlp.vim",
        init = function()
            vim.g.ctrlp_match_window_bottom = 0
            vim.g.ctrlp_match_window_reversed = 0
            vim.g.ctrlp_show_hidden = 1
            vim.g.ctrlp_map = "<C-q>"
            vim.g.ctrlp_switch_buffer = "Et"
            vim.g.ctrlp_custom_ignore = "node_modules\\|DS_Store\\|coverage"
            vim.g.ctrlp_root_markers = { ".ctrlp" }
            vim.g.ctrlp_dont_split = "NERD"
            vim.g.ctrlp_prompt_mappings = {
                ['PrtSelectMove("j")'] = { "<c-n>", "<down>" },
                ['PrtSelectMove("k")'] = { "<c-p>", "<up>" },
                ['PrtHistory(-1)'] = { "<c-j>" },
                ['PrtHistory(1)'] = { "<c-k>" },
            }
        end,
    },

    -- Show marks in the sign column
    { "kshenoy/vim-signature" },

    -- Color-code matching brackets
    {
        "luochen1990/rainbow",
        init = function()
            vim.g.rainbow_active = 1
            vim.g.rainbow_conf = {
                separately = { nerdtree = 0 },
            }
        end,
    },

    -- VCS signs
    {
        "mhinz/vim-signify",
        init = function()
            vim.g.signify_vcs_list = { "git" }
        end,
    },

    -- Color column by indent level
    {
        "nathanaelkane/vim-indent-guides",
        init = function()
            vim.g.indent_guides_start_level = 2
            vim.g.indent_guides_guide_size = 1
            vim.g.indent_guides_enable_on_vim_startup = 1
            vim.g.indent_guides_exclude_filetypes = { "help", "nerdtree" }
            vim.g.indent_guides_auto_colors = 0
        end,
        config = function()
            -- Apply colors after the plugin loads (needs g:indent_guides_*_color from theme)
            if vim.g.indent_guides_odd_color then
                vim.cmd("hi IndentGuidesOdd guibg=" .. vim.g.indent_guides_odd_color)
                vim.cmd("hi IndentGuidesEven guibg=" .. vim.g.indent_guides_even_color)
            end
        end,
    },

    -- Completion, LSP
    { "neoclide/coc.nvim", branch = "release" },

    -- File tree
    {
        "scrooloose/nerdtree",
        init = function()
            vim.g.NERDTreeIgnore = { "\\.pyc$" }
            vim.g.NERDTreeWinSize = 45
            vim.g.NERDTreeShowHidden = 1
        end,
    },

    -- Syntax highlighting for everything
    { "sheerun/vim-polyglot" },

    -- `ga` for unicode name, digraphs, emoji codes, and html entities
    { "tpope/vim-characterize" },

    -- `gcc` for comments
    { "tpope/vim-commentary" },

    -- Shell commands as vim commands (:Rename)
    { "tpope/vim-eunuch" },

    -- :Git, :Gvdiffsplit, :GBrowse, etc
    { "tpope/vim-fugitive" },

    -- Makes `.` work better
    { "tpope/vim-repeat" },

    -- Makes :GBrowse work
    { "tpope/vim-rhubarb" },

    -- Add/remove brackets, quotes, and tags
    { "tpope/vim-surround" },

    -- Get syntax group for highlighting
    { "vim-scripts/SyntaxAttr.vim" },

    -- Icons for filetypes (must come last)
    {
        "ryanoasis/vim-devicons",
        init = function()
            vim.g.WebDevIconsNerdTreeBeforeGlyphPadding = ""
        end,
    },
})
