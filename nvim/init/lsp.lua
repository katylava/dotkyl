-- LSP, completion, formatting, linting
-- ============================================================================
-- Plugin set:
--   mason.nvim                  - install LSP servers / formatters / linters
--   mason-lspconfig.nvim        - bridge mason ↔ lspconfig
--   mason-tool-installer.nvim   - keep formatters/linters auto-installed
--   nvim-lspconfig              - presets for ~200 LSP servers
--   nvim-cmp + sources          - completion popup
--   LuaSnip + cmp_luasnip       - snippet engine (cmp requires one)
--   conform.nvim                - run formatters (black, prettier)
--   nvim-lint                   - run linters (flake8, eslint_d)

-- ----------------------------------------------------------------------------
-- Mason: install tools
-- ----------------------------------------------------------------------------
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "pyright", "ts_ls" },
})
require("mason-tool-installer").setup({
    ensure_installed = { "black", "flake8", "prettier", "eslint_d" },
})

-- ----------------------------------------------------------------------------
-- LSP servers (nvim 0.11+ vim.lsp.config API)
-- ----------------------------------------------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("pyright", {
    settings = {
        pyright = {
            inlayHints = {
                functionReturnTypes = false,
                variableTypes = false,
                parameterTypes = false,
            },
        },
    },
})

vim.lsp.enable({ "pyright", "ts_ls" })

-- Buffer-local LSP mappings (only when an LSP attaches)
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local opts = { buffer = args.buf, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    end,
})

-- ----------------------------------------------------------------------------
-- Completion (nvim-cmp)
-- ----------------------------------------------------------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    -- Don't preselect first item (matches old `suggest.noselect: true`)
    preselect = cmp.PreselectMode.None,
    completion = {
        completeopt = "menu,menuone,noselect",
    },
    -- Defaults: <C-n>/<C-p> nav, <C-y> confirm, <C-e> abort,
    -- <C-b>/<C-f> scroll docs. No <CR> binding (so Enter inserts a
    -- newline and never accepts).
    mapping = cmp.mapping.preset.insert(),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    }),
})

-- ----------------------------------------------------------------------------
-- Formatters (conform.nvim)
-- ----------------------------------------------------------------------------
require("conform").setup({
    formatters_by_ft = {
        python = { "black" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        json5 = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
    },
})

-- ,n: format buffer (replaces coc's `,n` mapped to coc-format)
vim.keymap.set("n", ",n", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

-- ----------------------------------------------------------------------------
-- Linters (nvim-lint)
-- ----------------------------------------------------------------------------
require("lint").linters_by_ft = {
    python = { "flake8" },
    javascript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
}

-- Re-lint on write, read, and exit-from-insert
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    callback = function() require("lint").try_lint() end,
})
