if not _G.plugin_loaded("nvim-tree.lua") then
	print("nvim-tree.lua is not loaded")
	do return end
end

print("nvim-tree.lua is loaded")


-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- OR setup with some options
require("nvim-tree").setup({
  -- sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

vim.keymap.set("n", "<leader>nn", ":NvimTreeFocus<CR>")
vim.keymap.set("n", "<leader>nt", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>nf", ":NvimTreeFind<CR>")

