-- Python 开发环境
-- pyright（类型检查）与 ruff（lint + 格式化）的 LSP 配置在 lua/plugins/lsp.lua
-- 这里负责：虚拟环境选择、保存时格式化、运行脚本

local function project_python()
    -- 优先项目内 .venv，其次 venv-selector 激活的 VIRTUAL_ENV，最后系统 python3
    local root = vim.fs.root(0, { ".venv", "pyproject.toml", ".git" })
    if root then
        local exe = root .. "/.venv/bin/python"
        if vim.uv.fs_stat(exe) then
            return exe
        end
    end
    if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
        local exe = vim.env.VIRTUAL_ENV .. "/bin/python"
        if vim.uv.fs_stat(exe) then
            return exe
        end
    end
    return "python3"
end

local function run_current_file()
    if vim.bo.filetype ~= "python" then
        return
    end
    vim.cmd("write")
    local file = vim.api.nvim_buf_get_name(0)
    local cmd = string.format("%s %s", vim.fn.shellescape(project_python()),
        vim.fn.shellescape(file))
    require("toggleterm").exec(cmd, 15, "horizontal")
end

vim.keymap.set("n", "<leader>pr", run_current_file, { desc = "Python: 运行当前文件" })
vim.keymap.set("n", "<leader>po", function()
    vim.lsp.buf.code_action({
        apply = true,
        context = { only = { "source.organizeImports" }, diagnostics = {} },
    })
end, { desc = "Python: 整理 import（ruff）" })

-- 保存时用 ruff 格式化；关掉的话设置 vim.g.python_format_on_save = false
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("PythonFormatOnSave", { clear = true }),
    pattern = "*.py",
    callback = function(args)
        if vim.g.python_format_on_save == false then
            return
        end
        if #vim.lsp.get_clients({ bufnr = args.buf, name = "ruff" }) == 0 then
            return
        end
        vim.lsp.buf.format({
            bufnr = args.buf,
            async = false,
            timeout_ms = 3000,
            filter = function(client)
                return client.name == "ruff"
            end,
        })
    end,
    desc = "ruff 保存时格式化",
})

return {
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        ft = "python",
        cmd = { "VenvSelect", "VenvSelectCache" },
        keys = {
            { "<leader>pv", "<cmd>VenvSelect<cr>", ft = "python", desc = "Python: 选择虚拟环境" },
        },
        opts = {
            options = {
                -- 没有装 telescope/fzf-lua/snacks 时用内置选择器
                picker = "native",
                -- 选中后同步 VIRTUAL_ENV，并让 pyright 使用新解释器
                set_environment_variables = true,
                activate_venv_in_terminal = true,
                -- 按项目记住上次选择，重新打开项目自动激活
                enable_cached_venvs = true,
                cached_venv_automatic_activation = true,
                notify_user_on_venv_activation = true,
            },
        },
    },
}
