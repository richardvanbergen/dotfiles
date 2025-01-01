vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

return {
  {
    "stevearc/oil.nvim", -- Specify the plugin
    keys = {
      {
        "-", -- The keybinding
        "<CMD>Oil<CR>", -- The command to execute
        desc = "Open parent directory", -- Description for which-key
        mode = "n", -- Optional: Specify the mode (default is 'n' for normal mode)
      },
    },
    config = function()
      require("oil").setup() -- Ensure the plugin is properly configured
    end,
  },
}
