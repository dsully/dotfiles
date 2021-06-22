-- Language Servers

require'lspconfig'.bashls.setup{}
require'lspconfig'.dockerls.setup{}
require'lspconfig'.graphql.setup{}
require'lspconfig'.pyright.setup{}
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.terraformls.setup{}
require'lspconfig'.tsserver.setup{}
require'lspconfig'.yamlls.setup{}

-- Lua's LSP requires a bit more config. See: https://github.com/folke/lua-dev.nvim
local sumneko_root_path = vim.fn.getenv('HOME') .. "/src/lua-language-server"
local sumneko_binary = ""

if vim.fn.has("mac") == 1 then
    sumneko_binary = sumneko_root_path .. "/bin/macOS/lua-language-server"
elseif vim.fn.has("unix") == 1 then
    sumneko_binary = sumneko_root_path .. "/bin/Linux/lua-language-server"
else
    print("Unsupported system for sumneko")
end

local luadev = require("lua-dev").setup({
    lspconfig = {
        cmd = {sumneko_binary}
    }
})

require'lspconfig'.sumneko_lua.setup(luadev)
