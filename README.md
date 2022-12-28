# Telescope Scratch Run integration
[Telescope](https://github.com/nvim-telescope/telescope.nvim) picker for running simple code via stdin to language compiler and output to message window.

## How does it look?
Color scheme is [Darcula](https://github.com/4542elgh/darcula.nvim) made with TJ's colorbuddy plugin<br/>
<img src="https://user-images.githubusercontent.com/17227723/209482354-e055c4ad-12ca-4f16-8c2f-b89d2a409d40.png" alt="drawing" width="400"/>
<br/>
Using Python as an example<br/>
<img src="https://user-images.githubusercontent.com/17227723/209483105-80ac03df-bf33-4bda-ac7e-cae2e25c23da.png" alt="drawing" width="500"/>

## Why?
This plugin was created so I do not have to create a file or go to playground to test simple code. A lot of times, I just want to see if syntax is correct or validate my logic is correct.
And this plugin does exactly that.
It is a simple plugin, it simply run `:w !YOUR_LANG_COMPLIER` command.
<br/><br/>
You dont need to save anything into a file. Just open a new/scratch buffer with `:new` and type out the code you need to test.
Then running this telescope plugin and it will take current buffer as standard input (stdin) and run it via your language's compiler.
<br/><br/>
Note: you need to have your language toolchain/compiler installed before running this.

## Installation
If you are using [packer.nvim](https://github.com/wbthomason/packer.nvim), use this to setup `scratch_run`
```lua
use "4542elgh/telescope-scratch-run.nvim"
```
If you are using [lazy.nvim](https://github.com/folke/lazy.nvim), use this to setup `scratch_run`
```lua
"4542elgh/telescope-scratch-run.nvim"
```

In Telescope setup, require smb_unc module
```lua
require('telescope').load_extension('scratch_run')
```

## Configuration
For user defined command, you can use the following config structure under Telescope's `setup.extensions`
```lua
require("telescope").setup({
    defaults = {
        ...
    },
    extensions = {
        ...
        scratch_run = {
            custom_compilers = {
                lua = {
                    name = "lua",
                    cmd = ":w !jit" -- Make sure your command start with ':w !' then follow by your compiler command
                }
            }
        }
    },
})
```

## Usage

The extension provides the following picker:
```viml
" output available compilers
:Telescope scratch_run 
```
Lua equivalent:
```lua
require('telescope').extensions.scratch_run.all()
```
