## flipdir.vim

This plugin was inspired by the concept of split explorer [presented by Drew Neil](http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/).

> Think of it like this: each split window can either act as a view onto the contents of a file, or it
> can act as a view onto the contents of a directory. (...) I find that it helps to imagine a
> **card-flip** transition as the window shifts between file and directory viewing modes.
> - Drew Neil

I do all my file management from the shell or from a file manager. Most of the time I use `:find`
and command-line abbreviation to find my files in vim. So I don't use vim files browser for much
more than visualization and exploration of directories content.

I switched from netrw to [vim-dirvish](https://github.com/justinmk/vim-dirvish) when I started
using a very old laptop and felt the need for a faster plugin. I think dirvish is a great plugin,
but it have some features that i never used. Also I don't like `conceal` solution. So I decided to
write my own plugin, based on my use of dirvish.

## Flipdir buffer

Each line in the flipdir buffer is the 'tail' of a path, which is used to flip/split files and browse directories.
Buffer's name is the directory full path and can be used in command-line expansions (see `:help
:c_%`). You can filter lines with `:g` and sort with `:sort` commands. You can undo any change with
`u` and `:undo`. To undo all changes use `:1undo`. To reload the buffer use `:Flipdir %`.

## Mappings

### global mappings

`-` flips current window to parent directory.

### buffer-local (flipdir buffers)

`h` flips current window to parent directory.

`l` flips current window to path under the cursor

`v` topleft vertically splits new window with the path under the cursor

`s` topleft splits new window with the path under the cursor

`p` previews the path under the cursor in botrigth vertical window

`x` adds path under the cursor to `arglist`.

`gh` hides dot files.

`gq` deletes flipdir buffer.

## Commands

`:Flipdir {dir}` flips current window to `{dir}` (default to parent directory).

`:{mod} Splitdir {dir}` splits new window with `{dir}` (default to parent directory).
You can pass a `{mod}` like `vertical`, `botrigth`, etc.

## Tips

- you can abbreviate commands, like `:F{lipdir}` and `:S{plitdir}`
- In the command line `<C-r>l` expands to current line, so you can get current line path.
- So `%<C-r>l` will expands to current line full path.
- You can use environment variables, like `:Flip $VIMRUNTIME`.
- You can easily change split directions in the [mapping section](https://github.com/jpaulogg/vim-flipdir/blob/ee2b8801eefacb533b82f5d679682566142d6820/plugin/flipdir.vim#L24-L27)
  of the script.

## Installation

Install using your favorite package manager, or use (Neo)Vim's built-in package support:

```vim
" vim-plug
Plug 'jpaulogg/vim-flipdir
:PlugInstall
```

```bash
# built-in package support (in vim use '~/.vim/' instead of '~/.config/nvim')
mkdir -p ~/.config/nvim/pack/dist/start
cd ~/.config/nvim/pack/dist/start
git clone https://github.com/jpaulogg/vim-flipdir.git
```
