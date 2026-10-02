return {
    {
        "mrcjkb/rustaceanvim",
        lazy = false,
        init = function()
            vim.g.rustaceanvim = {
                server = {
                    settings = {
                        ["rust-analyzer"] = {
                            cachePriming = { enable = true },
                            checkOnSave = true,
                            diagnostics = {
                                enable = true,
                            },
                            check = {
                                allTargets = false,
                            },
                            cargo = {
                                targetDir = true,
                            },
                            inlayHints = {
                                bindingModeHints = { enable = true },
                                typeHints = { enable = true, hideClosureParameterTypes = false },
                                parameterHints = { enable = true },
                                chainingHints = { enable = true },
                                closureReturnTypeHints = { enable = true },
                            },
                        },
                    },
                },
            }
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        ft = "rust",
        config = function()
            local ls = require("luasnip")
            local s = ls.snippet
            local i = ls.insert_node
            local fmt = require("luasnip.extras.fmt").fmt
            ls.add_snippets("rust", {
                s({ trig = "match", priority = 1001 }, fmt([[
match {} {{
    {}
}}
]], {
                    i(1, "expr"),
                    i(2),
                })),
            })
        end,
    },
}
