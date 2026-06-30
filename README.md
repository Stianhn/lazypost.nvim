# lazypost.nvim

Open [LazyPost](https://github.com/tafsen/lazypost) (TUI Postman client) in a floating terminal window within Neovim.

## Requirements

- Neovim >= 0.8.0
- [LazyPost](https://github.com/tafsen/lazypost) installed and available in PATH

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "tafsen/lazypost.nvim",
  cmd = { "LazyPost" },
  keys = {
    { "<leader>lp", "<cmd>LazyPost<cr>", desc = "LazyPost" },
  },
  opts = {},
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "tafsen/lazypost.nvim",
  config = function()
    require("lazypost").setup()
  end,
}
```

### Manual

Clone the repository and add to your runtimepath:

```lua
vim.opt.runtimepath:append("/path/to/lazypost.nvim")
require("lazypost").setup()
```

## Configuration

```lua
require("lazypost").setup({
  cmd = "lazypost",      -- Command to run
  width = 0.9,           -- 90% of editor width (0-1 for percentage, >1 for absolute)
  height = 0.9,          -- 90% of editor height (0-1 for percentage, >1 for absolute)
  border = "rounded",    -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
  title = " LazyPost ",  -- Window title
  cwd = nil,             -- Working directory (nil uses current directory)
})
```

## Usage

### Commands

- `:LazyPost` - Toggle the LazyPost floating window

### Lua API

```lua
require("lazypost").open()   -- Open LazyPost
require("lazypost").close()  -- Close LazyPost
require("lazypost").toggle() -- Toggle LazyPost
```

### Example Keymaps

```lua
vim.keymap.set("n", "<leader>lp", "<cmd>LazyPost<cr>", { desc = "LazyPost" })
```

## Health Check

Run `:checkhealth lazypost` to verify your setup.

## License

MIT
