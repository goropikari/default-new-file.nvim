# default-new-file.nvim

default-new-file.nvim is a Neovim plugin that automatically inserts a predefined template into newly created files based on their file type. It also provides commands for managing and editing templates.

## Features

- Automatically apply templates to new files based on their file type.
- Skip template application if the file already exists.
- Manage templates with a built-in command for editing them.
- Customizable patterns for file matching and template locations.

## Installation

### Using [Lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
  'goropikari/default-new-file.nvim',
  opts = {
    -- default config
    pattern = { '*' }, -- Match all file types by default
    template_path = vim.fn.stdpath('data') .. '/default-new-file.nvim', -- Default template storage
  },
}
```

## Usage

### Setup
To initialize the plugin, call the `setup` function:

```lua
require('default-new-file').setup({
  pattern = { '*.md', '*.lua' }, -- Specify patterns for files
  template_path = vim.fn.stdpath('data') .. '/custom-template-path',
})
```

### Creating a New File
When you create a new file (e.g., `:e new_file.lua`), the plugin will:
1. Check the file type of the new file.
2. Look for a corresponding template in the specified `template_path`.
3. If a matching template exists, its content will be inserted into the new file.

### Managing Templates
Use the `:DefaultNewFile` command to create or edit templates for specific file types.

#### Command Example:
```vim
:DefaultNewFile lua
```
- This opens the template file for `lua` file types.
- If the template file does not exist, a new one will be created at the configured `template_path`.

## License
This plugin is distributed under the MIT License.
