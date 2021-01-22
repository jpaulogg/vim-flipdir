## flipdir.vim

Very simplified version of [vim-dirvish](https://github.com/justinmk/vim-dirvish).

Flip or split current window to new buffer with a list of directories and files.
Each line in the new buffer is the 'tail'  of  a	path,  which  is  used	to
flip/split files and browse directories. Buffer's name is the directory full
path and can be used in command-line expansions (see `:help :c_%`).

## Mappings

### global mappings

`-` flips current window to parent directory.

### buffer-local (flipdir buffers)

`h` flips current window to parent directory.

`l` flips current window to path under the cursor

`v` vertically splits new window with the path under the cursor

`s` splits new window with the path under the cursor

`p` previews the path under the cursor in new window

`x` adds path under the cursor to `arglist`.

`gh` hide dot files.

`gq` delete flipdir buffer.

## Commands

`Flipdir {dir}` flips current window to `{dir}` (default to parent directory).

`{mod} Splitdir {dir}` splits new window with `{dir}` (default to parent directory).
You can pass a `{mod}` like `vertical`, `botrigth`, etc.

## Installation

Install using your favorite package manager, or use (Neo)Vim's built-in package support:

```
# neovim:
mkdir -p ~/.config/nvim/pack/dist/start
cd ~/.config/nvim/pack/dist/start
git clone https://github.com/jpaulogg/vim-flipdir
```
