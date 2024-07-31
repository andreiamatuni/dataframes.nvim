# dataframes.nvim

Visualize Pandas DataFrame variables while debugging in Neovim. Currently depends on LazyVim terminal to render tables.

# usage

- Commands
  - `DFShowDataFrame` - display the Pandas DataFrame variable that's currently highlighted
  - `DFShowFile` - display a csv file whose file path is currently highlighted in the source code (either absolute path or relative to the file being currently edited)

## requirements

- [DAP](https://github.com/mfussenegger/nvim-dap)
- [DAP-python](https://github.com/mfussenegger/nvim-dap-python)
- [tabiew](https://github.com/shshemi/tabiew)
- [LazyVim](https://www.lazyvim.org/)
