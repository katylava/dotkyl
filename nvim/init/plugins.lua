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

    -- Diff/merge tool (maintained fork of sindrets/diffview.nvim)
    {
        "dlyongemallo/diffview.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("diffview").setup({
                enhanced_diff_hl = true,
                diffopt = { algorithm = "histogram" },
            })
        end,
    },

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
        dependencies = { "catppuccin", "nvim-tree/nvim-web-devicons" },
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
            vim.g.fzf_layout = { up = "~40%" }
            vim.g.fzf_command_prefix = "Fzf"
            -- --reverse: prompt at top, best match adjacent to prompt
            -- ctrl-e/ctrl-y scroll the preview (mirrors vim's scroll keys)
            vim.env.FZF_DEFAULT_OPTS = table.concat({
                "--reverse",
                "--bind ctrl-e:preview-down,ctrl-y:preview-up",
            }, " ")
            -- bat is fzf.vim's previewer; "plain" drops line numbers and header
            vim.env.BAT_STYLE = "plain"
            -- ag -U disables .gitignore (so gitignored files are findable);
            -- explicit ignores match the old ctrlp custom_ignore.
            vim.env.FZF_DEFAULT_COMMAND = table.concat({
                "ag --hidden -U",
                "--ignore .git",
                "--ignore node_modules",
                "--ignore .DS_Store",
                "--ignore coverage",
                "--ignore '*.pyc'",
                "--ignore __pycache__",
                "-g ''",
            }, " ")
        end,
    },

    -- Custom text objects
    { "kana/vim-textobj-user" },

    -- Show marks in the sign column
    { "kshenoy/vim-signature" },

    -- Color-code matching brackets
    {
        "luochen1990/rainbow",
        init = function()
            vim.g.rainbow_active = 1
            vim.g.rainbow_conf = {
                separately = { NvimTree = 0 },
            }
        end,
    },

    -- VCS signs
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            local gs = require("gitsigns")
            gs.setup()

            -- :GitsignsFold — toggle fold-unchanged-lines view. First call
            -- saves current fold settings then folds non-hunk lines; second
            -- call restores. Replaces vim-signify's :SignifyFold.
            function _G._gitsigns_fold_expr()
                local hunks = gs.get_hunks() or {}
                local lnum = vim.v.lnum
                for _, hunk in ipairs(hunks) do
                    local added = hunk.added or {}
                    local start = added.start or 0
                    local count = math.max(added.count or 0, 1)
                    if lnum >= start and lnum < start + count then
                        return 0
                    end
                end
                return 1
            end

            vim.api.nvim_create_user_command("GitsignsFold", function()
                local ok, saved = pcall(vim.api.nvim_win_get_var, 0, "_gitsigns_fold_saved")
                if ok and saved then
                    vim.wo.foldmethod = saved.foldmethod
                    vim.wo.foldexpr = saved.foldexpr
                    vim.wo.foldenable = saved.foldenable
                    vim.wo.foldlevel = saved.foldlevel
                    vim.api.nvim_win_del_var(0, "_gitsigns_fold_saved")
                else
                    vim.api.nvim_win_set_var(0, "_gitsigns_fold_saved", {
                        foldmethod = vim.wo.foldmethod,
                        foldexpr = vim.wo.foldexpr,
                        foldenable = vim.wo.foldenable,
                        foldlevel = vim.wo.foldlevel,
                    })
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldexpr = "v:lua._gitsigns_fold_expr()"
                    vim.wo.foldenable = true
                    vim.wo.foldlevel = 0
                end
            end, {})
        end,
    },

    -- Color column by indent level
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            -- char=" " makes the indicator a space; the IblOdd/IblEven groups
            -- supply the column colors via guibg. Mirrors vim-indent-guides'
            -- look. Highlight colors are set in ApplyDark/ApplyLight.
            require("ibl").setup({
                indent = {
                    char = " ",
                    highlight = { "IblOdd", "IblEven" },
                },
                scope = { enabled = false },
            })
            -- Hide the level-1 guide (mirrors vim-indent-guides start_level=2)
            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
            hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
        end,
    },

    -- LSP, completion, formatting, linting (configured in init/lsp.lua)
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
    { "stevearc/conform.nvim" },
    { "mfussenegger/nvim-lint" },

    -- File tree
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local function on_attach(bufnr)
                local api = require("nvim-tree.api")
                api.config.mappings.default_on_attach(bufnr)

                local function opts(desc)
                    return {
                        desc = "nvim-tree: " .. desc,
                        buffer = bufnr,
                        noremap = true,
                        silent = true,
                        nowait = true,
                    }
                end

                -- Override defaults to match nerdtree muscle memory
                vim.keymap.set("n", "i", api.node.open.horizontal, opts("Open: horizontal split"))
                vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: vertical split"))
                vim.keymap.set("n", "t", api.node.open.tab, opts("Open: new tab"))
                vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
                vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("Change root"))
            end

            require("nvim-tree").setup({
                on_attach = on_attach,
                view = { width = 40 },
                filters = {
                    -- show dotfiles (NERDTreeShowHidden=1)
                    dotfiles = false,
                    -- hide .pyc (NERDTreeIgnore)
                    custom = { ".*%.pyc$" },
                },
                renderer = {
                    icons = {
                        -- Two-space padding (default is one) gives wider
                        -- glyphs (markdown, toml) breathing room without
                        -- breaking row alignment for narrow ones.
                        padding = "  ",
                        -- Render git status in the signcolumn so the
                        -- 2-space padding doesn't apply around git icons.
                        git_placement = "signcolumn",
                        glyphs = {
                            git = {
                                unstaged = "✽",
                                staged = "✚",
                                renamed = "⥱",
                                untracked = "፧",
                                deleted = "✗",
                            },
                        },
                    },
                },
            })
        end,
    },

    -- Syntax highlighting via treesitter parsers (nvim-treesitter v1)
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")
            ts.setup({})

            local parsers = {
                "bash", "comment", "css", "html",
                "javascript", "json", "json5", "lua",
                "markdown", "markdown_inline", "python",
                "query", "regex", "sql", "toml", "tsx",
                "typescript", "vim", "vimdoc", "yaml",
            }
            ts.install(parsers)

            -- Enable highlight on FileType
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "bash", "css", "html",
                    "javascript", "javascriptreact",
                    "json", "json5", "lua",
                    "markdown", "python",
                    "sh", "sql", "toml",
                    "typescript", "typescriptreact",
                    "vim", "yaml",
                },
                callback = function() pcall(vim.treesitter.start) end,
            })
        end,
    },

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
})
