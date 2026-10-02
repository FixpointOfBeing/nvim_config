return {
  "vimwiki/vimwiki",
  --event = "BufEnter *.wiki",
  config = function()
    vim.g.vimwiki_list = {
      {
        path = '~/vimwiki/',
        syntax = 'markdown',
        ext = '.md',
      }
    }
    
    vim.g.vimwiki_global_ext = 0
    vim.g.vimwiki_markdown_link_ext = 1
    
    vim.keymap.set('n', '<leader>ww', '<cmd>VimwikiIndex<CR>', { desc = 'Open Vimwiki Index' })
    vim.keymap.set('n', '<leader>wt', '<cmd>VimwikiTabIndex<CR>', { desc = 'Open Vimwiki in New Tab' })
    vim.keymap.set('n', '<leader>ws', '<cmd>VimwikiUISelect<CR>', { desc = 'Select Vimwiki' })
  end,
}
