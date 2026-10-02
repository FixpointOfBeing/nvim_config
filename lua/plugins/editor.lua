vim.cmd('filetype on')
vim.cmd('filetype plugin on')
vim.cmd('filetype indent on')
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

return {{
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            surrounds = {
                ["("] = {
                    add = {"(", ")"},
                    find = function()
                        return require("nvim-surround.config").get_selection({
                            motion = "a("
                        })
                    end,
                    delete = "^(.)().-(.)()$"
                },
                ["["] = {
                    add = {"[", "]"},
                    find = function()
                        return require("nvim-surround.config").get_selection({
                            motion = "a["
                        })
                    end,
                    delete = "^(.)().-(.)()$"
                }
            }
        })
    end
}, {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
        modes = {
            char = {
                enabled = false,
                jump_labels = true
            }
        },
        label = {
            rainbow = {
                enabled = true
            }
        },
        highlight = {
            backdrop = true
        }
    },
    keys = { -- 核心：全局跳转
    {
        "<leader>s",
        mode = {"n", "x", "o"},
        function()
            require("flash").jump()
        end,
        desc = "Flash jump"
    }, {
        "<leader>j",
        mode = {"n", "x", "o"},
        function()
            require("flash").jump({
                search = {
                    mode = "search",
                    max_length = 1
                }
            })
        end,
        desc = "Flash f"
    }, {
        "<leader>k",
        mode = {"n", "x", "o"},
        function()
            require("flash").jump({
                search = {
                    mode = "search",
                    max_length = 1
                },
                backward = true
            })
        end,
        desc = "Flash F"
    }}
}, {
    "terrortylor/nvim-comment",
    config = function()
        require('nvim_comment').setup()
        -- 快捷键: gc
        -- Normal 模式: gc<行数>j -> 注释行
        -- Visual 模式: gc -> 注释选择区域
    end
}, {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        require("bufferline").setup {
            options = {
                numbers = "ordinal",
                close_command = "bdelete! %d",
                right_mouse_command = "bdelete! %d",
                show_buffer_close_icons = true,
                show_close_icon = false,
                tab_size = 18
            }
        }
        -- 快捷键
        vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>")
        vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>")

        -- 关闭其他 buffer(先保存):有改动的先写盘,未命名/写盘失败的保留
        -- bufferline 自带的 CloseOthers 走 close_command(bdelete!) 会丢改动
        local function close_others_and_save()
            local cur = vim.api.nvim_get_current_buf()
            local kept = {}
            for _, b in ipairs(vim.api.nvim_list_bufs()) do
                if b ~= cur and vim.api.nvim_buf_is_valid(b) then
                    local bo = vim.bo[b]
                    -- 只处理普通文件 buffer(listed 且 buftype 为空)
                    if bo.buflisted and bo.buftype == "" then
                        local ok = not bo.modified
                        if bo.modified and vim.api.nvim_buf_get_name(b) ~= "" then
                            ok = pcall(vim.api.nvim_buf_call, b, function()
                                vim.cmd("silent write")
                            end)
                        end
                        if ok then
                            pcall(vim.api.nvim_buf_delete, b, { force = false })
                        else
                            table.insert(kept, b)
                        end
                    end
                end
            end
            if #kept > 0 then
                vim.notify("保留未能保存的 buffer: " .. table.concat(kept, ", "),
                    vim.log.levels.WARN)
            end
        end
        vim.keymap.set("n", "<leader>bx", close_others_and_save,
            { desc = "关闭其他 buffer 并保存" })
    end
}, {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = 20, -- 终端大小
            open_mapping = [[<c-\>]], -- 快捷键：Ctrl + \
            direction = 'float', -- 默认浮动窗口，也可选 'vertical' 或 'horizontal'
            hide_numbers = true, -- 隐藏行号
            shade_filetypes = {},
            auto_scroll = true -- 自动滚动到底部
        })
        vim.api.nvim_create_autocmd("TermEnter", {
            pattern = "term://*toggleterm#*",
            callback = function()
                vim.cmd("startinsert")
            end
        })
    end
}, {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {"lua", "python", "javascript", "rust"},
            highlight = {
                enable = true
            }
        })
    end
}, {
    "nvim-treesitter/nvim-treesitter-textobjects",
    config = function()
        require("nvim-treesitter-textobjects").setup({
            select = {
                lookahead = true
            }
        })

        local select = require("nvim-treesitter-textobjects.select")
        vim.keymap.set({ "x", "o" }, "af", function()
            select.select_textobject("@function.outer", "textobjects")
        end)
        vim.keymap.set({ "x", "o" }, "if", function()
            select.select_textobject("@function.inner", "textobjects")
        end)
        vim.keymap.set({ "x", "o" }, "ac", function()
            select.select_textobject("@class.outer", "textobjects")
        end)
        vim.keymap.set({ "x", "o" }, "ic", function()
            select.select_textobject("@class.inner", "textobjects")
        end)
    end
}}
