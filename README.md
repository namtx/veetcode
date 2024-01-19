### How to install?

#### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
require('lazy').setup {
  {
    'namtx/veetcode.nvim',
    opts = {
      path = -- point to the directory that you want to store your solution
    }
  }
}
```


### Mappings

- `<leader>ln` - Open a new buffer from Leetcode problem URL
