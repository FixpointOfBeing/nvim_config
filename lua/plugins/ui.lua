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
    keys = { { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "文件树" } },
    config = function()
      require("nvim-tree").setup()
    end,
  },
}
