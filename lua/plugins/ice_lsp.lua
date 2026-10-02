return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      if not vim.lsp.config.my_tiny_lsp then
        vim.lsp.config.my_tiny_lsp = {
          cmd = { "node", vim.fn.expand("~/Workspace/test/js/ice_lsp/ice_server.js") },
          filetypes = { "*" },
          root_dir = function(fname)
            return vim.fs.root(fname, ".git") or vim.fn.getcwd()
          end,
          single_file_support = true,
          settings = {},
        }
      end

      vim.lsp.enable("my_tiny_lsp")
    end,
  },
}
