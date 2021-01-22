## flipdir.vim

Very simplified version of [vim-dirvish](https://github.com/justinmk/vim-dirvish).

Flip or split current window to new buffer with a list of directories and files.
Each line in the new buffer is the 'tail'  of  a	path,  which  is  used	to
flip/split files and browse directories. Buffer's name is the directory full
path and can be used in command-line expansions (see `:h :c_%`).

## Mappings

### global mappings

`-` flip current window to parent directory.

### buffer-local (flipdir buffers)

`h` flips current window to parent directory.

`l` flips current window to path under the cursor

`v` vertically splits new window with the path under the cursor

`s` splits new window with the path under the cursor

`p` previews the path under the cursor in new window

`a` adds path under the cursor to `arglist`.

## Commands

`Flipdir {dir}` flips current window to `{dir}` (default to parent directory).

`Splitdir {dir}` splits new window with `{dir}` (default to parent directory).
