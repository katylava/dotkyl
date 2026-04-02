local dir = vim.fn.stdpath("config") .. "/init"
vim.cmd("source " .. dir .. "/options.vim")
vim.cmd("luafile " .. dir .. "/functions.lua")
vim.cmd("luafile " .. dir .. "/plugins.lua")
vim.cmd("luafile " .. dir .. "/autocommands.lua")
vim.cmd("source " .. dir .. "/mappings.vim")
