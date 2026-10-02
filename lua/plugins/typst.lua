return {
  {
    'chomosuke/typst-preview.nvim',
    lazy = false,
    version = '1.*',
    config = function()
      require('typst-preview').setup {
        -- 完整配置选项
        debug = false,
        open_cmd = nil,
        port = 8080,
        invert_colors = 'always',
        follow_cursor = true,
        extra_args = nil,
        get_root = function(path_of_main_file)
          local root = os.getenv 'TYPST_ROOT'
          if root then
            return root
          end
          return vim.fn.fnamemodify(path_of_main_file, ':p:h')
        end,
        get_main_file = function(path_of_buffer)
          return path_of_buffer
        end,
      }
      -- 添加快捷键
      vim.keymap.set('n', '<leader>tp', '<cmd>TypstPreview<CR>', {
        desc = 'Toggle Typst Preview',
        noremap = true,
        silent = true
      })
    end
  }
}
