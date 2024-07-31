if exists("g:loaded_dataframes")
    finish
endif
let g:loaded_dataframes = 1

" Defines a package path for Lua. This facilitates importing the
" Lua modules from the plugin's dependency directory.
let s:lua_rocks_deps_loc =  expand("<sfile>:h:r") . "/../lua/dataframes/deps"
exe "lua package.path = package.path .. ';" . s:lua_rocks_deps_loc . "/lua-?/init.lua'"

" Exposes the plugin's functions for use as commands in Neovim.
command! -nargs=0 DFShowDataFrame lua require("dataframes").show_df()
command! -nargs=0 DFShowFile lua require("dataframes").show_file()
