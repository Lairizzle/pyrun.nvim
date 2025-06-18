# pyrun.nvim

A small Neovim plugin to compile and run Python files from a floating terminal.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "lairizzle/pyrun.nvim",
  config = function()
    vim.keymap.set("n", "<leader>pr", function()
      require("pyrun").run()
    end, { desc = "Run Python in floating terminal" })
  end,
}
