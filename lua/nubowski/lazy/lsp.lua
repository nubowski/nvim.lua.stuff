return {
    -- main LSP plugin
    "neovim/nvim-lspconfig",
    dependencies = {
        -- automatic server install
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        -- completion engine
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        -- optional snippets
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
    },

    config = function()
        -- Mason: install LSP servers
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "clangd" },  -- install C/C++ LSP server
            handlers = {
                function(server_name)
                    local opts = {
                        capabilities = require("cmp_nvim_lsp").default_capabilities()
                    }

                    -- Only override `cmd` for clangd
                    if server_name == "clangd" then
                        opts.cmd = {
                            "clangd",
                            "--compile-commands-dir=build",
                            "--query-driver=C:/msys64/mingw64/bin/*"
                        }
                    end

                    require("lspconfig")[server_name].setup(opts)
                end
            }

        })

        -- nvim-cmp setup
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                    { name = 'buffer' },
                    { name = 'path' },
                })
        })
    end
}

