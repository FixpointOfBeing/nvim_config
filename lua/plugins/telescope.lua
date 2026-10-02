return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup{
        defaults = {
          mappings = {
            i = { -- insert 模式
              ["<esc>"] = actions.close,
            },
            n = { -- normal 模式
              ["q"] = actions.close,
            },
          },
        },
      }

      -- 快捷键设置
      local map = vim.keymap.set
      map("n", "<leader>tb", ":Telescope buffers<CR>", { desc = "显示已打开文件" })
      map("n", "<leader>tf", ":Telescope find_files<CR>", { desc = "搜索文件" })
      map("n", "<leader>tg", ":Telescope live_grep<CR>", { desc = "全文搜索" })
    end
  }
}
