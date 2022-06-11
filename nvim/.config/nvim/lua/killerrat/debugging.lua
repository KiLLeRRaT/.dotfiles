--debugging

local ok, dap = pcall(require, "dap")
if not ok then return end

vim.keymap.set("n", "<F1>", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<F2>", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<F3>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<F4>", ":lua require'dap'.step_out()<CR>")
-- vim.keymap.set("n", "<leader>ub", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<F9>", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<A-F9>", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
-- vim.keymap.set("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
vim.keymap.set("n", "<leader>ur", ":lua require'dap'.repl.open()<CR>")
-- vim.keymap.set("n", "<leader>ut", ":lua require'dap-go'.debug_test()<CR>")

require("nvim-dap-virtual-text").setup()
-- require('dap-go').setup()
require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
