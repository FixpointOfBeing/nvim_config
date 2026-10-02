return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.keymap.set('n', '<leader>rn', function()
                local diag_conf = vim.diagnostic.config()
                local had_virtual_lines = diag_conf.virtual_lines
                if had_virtual_lines then
                    vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
                end
                local ok, _ = pcall(vim.lsp.buf.rename)
                vim.defer_fn(function()
                    if had_virtual_lines then
                        vim.diagnostic.config({ virtual_lines = diag_conf.virtual_lines, virtual_text = false })
                    end
                    if ok then
                        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                            if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modified then
                                vim.api.nvim_buf_call(buf, function()
                                    vim.cmd('silent! write')
                                end)
                            end
                        end
                    end
                end, 300)
            end, { desc = 'LSP: [R]e[n]ame' })
            vim.keymap.set('n', '<leader>f',
                function()
                    vim.lsp.buf.format({ async = true })
                end, { desc = 'LSP: [F]ormat code with LSP' })
            vim.keymap.set('n', '<leader>i', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, { desc = 'LSP: Toggle [I]nlay Hints' })
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
                { desc = 'LSP: [G]o to [D]efinition' })
            vim.keymap.set('n', '<leader>t', vim.lsp.buf.type_definition,
                { desc = 'LSP: [T]ype Definition' })
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action,
                { desc = 'LSP: [C]ode [A]ction' })
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client and client.server_capabilities.inlayHintProvider then
                        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
                    end
                end,
            })
            vim.lsp.enable("clangd")
            vim.lsp.enable("pyright")
            vim.lsp.enable("lua_ls")
            vim.lsp.enable("ocamllsp")
            vim.lsp.config.tinymist = vim.lsp.config.tinymist or {}
            vim.lsp.config.tinymist.settings = {
                formatterMode = "typstyle",
                exportPdf = "onType",
                semanticTokens = "disable"
            }
            vim.lsp.enable("tinymist")
        end
    },      -- 诊断符号（sign column 图标）
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },
    -- 添加 lsp_lines 插件
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("lsp_lines").setup()

            -- 过滤只显示 ERROR 和 WARN
            local orig_handler = vim.diagnostic.handlers.virtual_lines
            vim.diagnostic.handlers.virtual_lines = {
                show = function(_, bufnr, diagnostics, opts)
                    local filtered = {}
                    for _, d in ipairs(diagnostics) do
                        if d.severity and d.severity <= vim.diagnostic.severity.WARN then
                            filtered[#filtered + 1] = d
                        end
                    end
                    if #filtered > 0 then
                        orig_handler.show(_, bufnr, filtered, opts)
                    else
                        orig_handler.hide(_, bufnr)
                    end
                end,
                hide = orig_handler.hide,
            }

            local signs = {
                { name = "DiagnosticSignError", text = "" },
                { name = "DiagnosticSignWarn",  text = "" },
            }
            for _, sign in ipairs(signs) do
                vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
            end

            vim.diagnostic.config({
                severity = { min = vim.diagnostic.severity.WARN },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN]  = "",
                    },
                },
                virtual_text = false,
                virtual_lines = {
                    only_current_line = false,
                    highlight_whole_line = false,
                },
                float = {
                    border = "rounded",
                    source = "if_many",
                    header = "",
                    prefix = "",
                },
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })

            vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#ff4444", bg = "#3a0000" })
            vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn",  { fg = "#ffaa00", bg = "#3a2a00" })
            vim.api.nvim_set_hl(0, "DiagnosticLineError",        { fg = "#ff4444" })
            vim.api.nvim_set_hl(0, "DiagnosticLineWarn",         { fg = "#ffaa00" })
            vim.api.nvim_set_hl(0, "DiagnosticSignError",        { fg = "#ff2222" })
            vim.api.nvim_set_hl(0, "DiagnosticSignWarn",         { fg = "#ff8800" })
            vim.keymap.set("n", "<leader>ll", require("lsp_lines").toggle,
                { desc = "Toggle LSP lines" })
        end
    },
    {
        "j-hui/fidget.nvim",
        event = "LspNotify",
        opts = {},
    },
     {
    "folke/trouble.nvim",
    opts = {},     -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
        {
            "<leader>xx",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)"
        }
    }
},     -- 添加补全引擎（必需）
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip"
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true })
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" },
                    { name = "path" }
                })
            })
        end
    }, -- 添加代码片段支持
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    }, {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
        registries = { "github:mason-org/mason-registry" },
        -- 自动安装的工具列表
        ensure_installed = {
            -- LSP
            "lua_ls", "pyright", "tsserver", "rust_analyzer",     -- Formatters
            "stylua", "black",                                    -- Linters
            "eslint_d", "flake8"
        }
    },
    config = function(_, opts)
        require("mason").setup(opts)

        vim.schedule(function()
            require("mason-registry").update()
        end)
    end
}

}
