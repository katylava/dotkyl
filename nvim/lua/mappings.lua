local map = vim.keymap.set

-- Escape
map("i", "jk", "<Esc>")
map("i", "kk", "<Esc>")
map("t", "jk", "<C-\\><C-n>")

-- Window navigation
map("n", "<C-j>", "<cmd>wincmd j<CR>")
map("n", "<C-k>", "<cmd>wincmd k<CR>")
map("n", "<C-h>", "<cmd>wincmd h<CR>")
map("n", "<C-l>", "<cmd>wincmd l<CR>")
map("t", "<C-j>", "<C-\\><C-n><C-w>h")
map("t", "<C-k>", "<C-\\><C-n><C-w>j")
map("t", "<C-h>", "<C-\\><C-n><C-w>k")
map("t", "<C-l>", "<C-\\><C-n><C-w>l")

-- Window resize (<opt> = - . ,)
map("n", "≠", "10<C-W>+")
map("n", "–", "10<C-W>-")
map("n", "≥", "10<C-W>>")
map("n", "≤", "10<C-W><")

-- Window move (<opt> b f k j)
map("n", "∫", "<C-W>H")
map("n", "ƒ", "<C-W>L")
map("n", "˚", "<C-W>K")
map("n", "∆", "<C-W>J")

-- Tabs (<opt> p o)
map("n", "π", "<cmd>tabnext<CR>")
map("n", "ø", "<cmd>tabprevious<CR>")

-- Select just-pasted lines
map("n", "gp", "`[v`]")

-- Insert space or newline and get back to normal mode
map("n", "gj", "o<Esc>", { silent = true })
map("n", "gk", "O<Esc>", { silent = true })
map("n", "gh", "i<Space><Esc>", { silent = true })
map("n", "gl", "a<Space><Esc>", { silent = true })
map("n", "gn", "i<CR><Esc>", { silent = true })

-- Center search result
map("n", "N", "Nzz")
map("n", "n", "nzz")

-- System clipboard
map("", ",y", '"+y')
map("", ",p", '"+p')

-- Don't show help when F1 is pressed
map("", "<F1>", "<ESC>")

-- Remove trailing space without overwriting current search
map("n", ",s", "<cmd>let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>", { silent = true })

-- Terminal mode
map("n", ",tv", "<cmd>vsp term://zsh -f<CR>i")
map("n", ",tx", "<cmd>sp term://zsh -f<CR>i")

-- Signify fold
map("n", "<Leader>s", "<cmd>SignifyFold<CR>")

-- Window swap
map("n", "<C-w>m", "<cmd>lua WindowSwapping()<CR>")

-- NERDTree
map("", ",d", "<cmd>NERDTreeToggle<CR>")
map("", ",e", "<cmd>NERDTreeFind<CR>")

-- CtrlP
map("", ",f", "<cmd>CtrlP<CR>")
map("", ",m", "<cmd>CtrlPMRU<CR>")
map("", ",g", "<cmd>CtrlPBuffer<CR>")
map("", ",r", "<cmd>CtrlPClearCache<CR>")

-- Copilot
map("i", "<C-n>", 'copilot#Accept("\\<CR>")', { expr = true, silent = true, script = true })

-- Command typos
vim.api.nvim_create_user_command("Q", "quit", {})
vim.api.nvim_create_user_command("W", "write", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("Wn", "wn", {})
vim.api.nvim_create_user_command("WN", "wN", {})

-- ---------------------
-- CoC mappings
-- ---------------------

-- Tab completion (must use vim.cmd for expr mappings with vimscript functions)
vim.cmd([[
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()
]])

-- Diagnostics navigation
map("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true, remap = true })
map("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true, remap = true })

-- GoTo code navigation
map("n", "gd", "<Plug>(coc-definition)", { silent = true, remap = true })
map("n", "gy", "<Plug>(coc-type-definition)", { silent = true, remap = true })
map("n", "gi", "<Plug>(coc-implementation)", { silent = true, remap = true })
map("n", "gr", "<Plug>(coc-references)", { silent = true, remap = true })

-- Show documentation
vim.cmd([[
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
]])
map("n", "K", "<cmd>call ShowDocumentation()<CR>", { silent = true })

-- Symbol renaming
map("n", "<leader>rn", "<Plug>(coc-rename)", { remap = true })

-- Formatting
map("x", "<leader>f", "<Plug>(coc-format-selected)", { remap = true })
map("n", "<leader>f", "<Plug>(coc-format-selected)", { remap = true })
map("n", ",n", "<Plug>(coc-format)", { remap = true })

-- Code actions
map("x", "<leader>a", "<Plug>(coc-codeaction-selected)", { remap = true })
map("n", "<leader>a", "<Plug>(coc-codeaction-selected)", { remap = true })
map("n", "<leader>ac", "<Plug>(coc-codeaction)", { remap = true })
map("n", "<leader>qf", "<Plug>(coc-fix-current)", { remap = true })
map("n", "<leader>cl", "<Plug>(coc-codelens-action)", { remap = true })

-- Text objects for functions and classes
map("x", "if", "<Plug>(coc-funcobj-i)", { remap = true })
map("o", "if", "<Plug>(coc-funcobj-i)", { remap = true })
map("x", "af", "<Plug>(coc-funcobj-a)", { remap = true })
map("o", "af", "<Plug>(coc-funcobj-a)", { remap = true })
map("x", "ic", "<Plug>(coc-classobj-i)", { remap = true })
map("o", "ic", "<Plug>(coc-classobj-i)", { remap = true })
map("x", "ac", "<Plug>(coc-classobj-a)", { remap = true })
map("o", "ac", "<Plug>(coc-classobj-a)", { remap = true })

-- Scroll float windows/popups (must use vim.cmd for expr mappings)
vim.cmd([[
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
]])

-- Selection ranges
map("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true, remap = true })
map("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true, remap = true })

-- CoC commands
vim.api.nvim_create_user_command("Format", "call CocActionAsync('format')", {})
vim.api.nvim_create_user_command("Fold", function(opts)
    vim.fn.CocAction("fold", opts.args ~= "" and opts.args or nil)
end, { nargs = "?" })
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

-- CoCList mappings
map("n", "<space>a", "<cmd>CocList diagnostics<CR>", { silent = true, nowait = true })
map("n", "<space>e", "<cmd>CocList extensions<CR>", { silent = true, nowait = true })
map("n", "<space>c", "<cmd>CocList commands<CR>", { silent = true, nowait = true })
map("n", "<space>o", "<cmd>CocList outline<CR>", { silent = true, nowait = true })
map("n", "<space>s", "<cmd>CocList -I symbols<CR>", { silent = true, nowait = true })
map("n", "<space>j", "<cmd>CocNext<CR>", { silent = true, nowait = true })
map("n", "<space>k", "<cmd>CocPrev<CR>", { silent = true, nowait = true })
map("n", "<space>p", "<cmd>CocListResume<CR>", { silent = true, nowait = true })
