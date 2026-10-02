if vim.g.neovide then
  vim.o.guifont = "JetBrains Mono:h8" -- 设置字体名称和大小
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_smooth_blink = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_opacity = 0.95                 -- 透明度
  vim.g.neovide_fullscreen = false             -- 是否全屏启动
  vim.g.neovide_confirm_quit = true            -- 退出时是否确认
end

-- 设置行号
vim.opt.number = true
--vim.opt.relativenumber = true -- 相对行号
-- 使用系统剪贴板
vim.opt.clipboard:append { 'unnamedplus' }
-- 设置 Tab 和缩进
vim.opt.tabstop = 4         -- 一个 tab 对应 4 个空格
vim.opt.shiftwidth = 4      -- 自动缩进时使用的空格数
vim.opt.expandtab = true    -- 将 tab 转换为空格
vim.opt.smartindent = true  -- 智能缩进
-- 禁用折叠列
vim.opt.signcolumn = "yes"
-- 使用稳定渲染
vim.opt.lazyredraw = true
-- 搜索设置
vim.opt.ignorecase = true   -- 搜索时忽略大小写
vim.opt.smartcase = true    -- 如果搜索模式包含大写字母，则开启大小写敏感
vim.opt.hlsearch = true     -- 高亮所有匹配项
vim.opt.incsearch = true    -- 实时显示匹配项

-- 界面设置
vim.opt.termguicolors = true -- 启用真彩色
vim.opt.cursorline = true    -- 高亮当前行
vim.opt.splitright = true    -- 垂直分屏时新窗口在右侧
vim.opt.splitbelow = true    -- 水平分屏时新窗口在下方
vim.opt.undofile = true      -- 启用撤销文件 (持久化撤销历史)
vim.opt.updatetime = 300     -- 插件更新和 LSP 延迟

-- 全选 + 复制到系统剪贴板
vim.keymap.set('n', '<C-a>', function()
    vim.cmd('normal! ggVG')       -- 执行全选
--    vim.cmd('normal! "+y')        -- 复制到系统剪贴板
--    print("✓ All content copied") -- 显示提示
end, { noremap = true, silent = true })

-- 禁用 normal 模式下括号键的光标移动
for _, key in ipairs({ "{", "}", "(", ")", "[", "]" }) do
    vim.keymap.set("n", key, "<Nop>", { noremap = true, silent = true })
end

-- 其他常用设置
vim.opt.encoding = "utf-8"   -- 设置编码为 UTF-8
vim.opt.fileencoding = "utf-8" -- 文件编码
vim.opt.wrap = false         -- 不自动换行
vim.opt.mouse = "a"          -- 在所有模式下启用鼠标

-- 只读保护：Rust 依赖库 / 工具链 + nvim 插件目录
local protected_dirs = {
  vim.fn.stdpath("data") .. "/lazy",
  vim.fn.stdpath("data") .. "/mason",
}

local cargo_src = vim.fn.glob(vim.fn.expand("~/.cargo/registry/src/*/"), false, true)
local rustup_lib = vim.fn.glob(vim.fn.expand("~/.rustup/toolchains/*/lib/"), false, true)
vim.list_extend(protected_dirs, cargo_src)
vim.list_extend(protected_dirs, rustup_lib)

vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function()
    local path = vim.fn.expand("%:p")
    for _, dir in ipairs(protected_dirs) do
      if vim.startswith(path, dir) then
        vim.bo.modifiable = false -- 禁止修改
        vim.bo.readonly = true    -- 禁止 :w
        break
      end
    end
  end,
})

