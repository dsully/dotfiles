local lsp_installer = require'nvim-lsp-installer'

function common_on_attach(client, bufnr)
    -- setup buffer keymaps etc.
end

local installed_servers = lsp_installer.get_installed_servers()

for _, server in pairs(installed_servers) do
    opts = {
        on_attach = common_on_attach,
    }

    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
    --     opts.root_dir = function() ... end
    -- end

    server:setup(opts)
end
