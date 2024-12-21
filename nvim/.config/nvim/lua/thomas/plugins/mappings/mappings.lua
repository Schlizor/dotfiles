local M = {}

M.dap = {
    plugin = true,
    n = {
        ["<leader>db"] = {
        "<cmd> DapToggleBreakpoint <CR>",
        "Add breakpoint at line",
        },
    }
}

return M
