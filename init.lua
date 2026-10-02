require("config.options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if vim.g.neovide then
    -- 字体
    vim.o.guifont = "JetBrains Mono:h14"

    -- 刷新率
    vim.g.neovide_refresh_rate = 144
    vim.g.neovide_refresh_rate_idle = 5

    -- 光标动画
    vim.g.neovide_cursor_animation_length = 0.08
    vim.g.neovide_cursor_trail_size = 0

    -- 滚动动画
    vim.g.neovide_scroll_animation_length = 0.15

    -- 光标特效（可选）
    vim.g.neovide_cursor_vfx_mode = ""

    -- 退出确认
    vim.g.neovide_confirm_quit = true

    -- 不隐藏鼠标
    vim.g.neovide_hide_mouse_when_typing = false

    -- 浮动透明度
    -- vim.g.neovide_floating_blur_amount_x = 2.0
    -- vim.g.neovide_floating_blur_amount_y = 2.0

    -- 缩放比例
    vim.g.neovide_scale_factor = 1.0
end
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { import = "plugins.ui" },
    { import = "plugins.editor" },
    { import = "plugins.lsp" },
    { import = "plugins.rust" },
    { import = "plugins.coq" },
    { import = "plugins.lean" },
    { import = "plugins.typst" },
    -- { import = "plugins.ice_lsp" },
    -- { import = "plugins.vimwiki" },
    -- { import = "plugins.telescope" },
})
