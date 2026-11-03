return {
    -- 主题
    {
        "arzg/vim-colors-xcode",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([=[colorscheme xcodedark]=])
        end,
    },

    -- 状态栏
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = { theme = "auto" },
            })
        end,
    },

    -- 文件树
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false, -- 需在启动时加载，才能接管 `nvim .`
        keys = { { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "文件树" } },
        config = function()
            require("nvim-tree").setup({
                hijack_netrw = false,
                hijack_directories = { enable = false },
                view = { width = 30 },
            })

            -- `nvim .` 时：左边文件树 + 右边空白
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv()[1]) == 1 then
                        local dirbuf = vim.api.nvim_get_current_buf()
                        vim.cmd("enew")                                          -- 右侧空白 buffer
                        pcall(vim.api.nvim_buf_delete, dirbuf, { force = true }) -- 清理目录 buffer
                        local dir = vim.fn.fnamemodify(vim.fn.argv()[1], ":p")
                        require("nvim-tree.api").tree.open({ path = dir }) -- 左侧打开文件树
                    end
                end,
            })
        end,
    },
}
