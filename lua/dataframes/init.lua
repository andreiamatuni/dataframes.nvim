local nio = require("nio")

local M = {}

function get_current_expr()
	if nio.fn.mode() == "v" then
		local start = nio.fn.getpos("v")
		local finish = nio.fn.getpos(".")
		local lines = M.get_selection(start, finish)
		return table.concat(lines, "\n")
	end
	return nio.fn.expand("<cexpr>")
end

local function close_floating()
	local inactive_floating_wins = vim.fn.filter(vim.api.nvim_list_wins(), function(k, v)
		local file_type = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(v), "filetype")

		return vim.api.nvim_win_get_config(v).relative ~= ""
			and v ~= vim.api.nvim_get_current_win()
			and file_type ~= "hydra_hint"
	end)
	for _, w in ipairs(inactive_floating_wins) do
		pcall(vim.api.nvim_win_close, w, false)
	end
end

-- Show the currently highlighted DataFrame variable
function M.show_df()
	local wordUnderCursor = get_current_expr()
	local time = os.time()

	require("dapui").eval(string.format("%s.to_csv('/tmp/%s.csv', index=True)", wordUnderCursor, time))
	close_floating()
	LazyVim.terminal.open({ "tw", string.format("/tmp/%s.csv", time) })
end

-- Show the currently highlighted filepath of a csv. This function assumes that
-- the filepath is relative to the current file being edited (i.e. which contains the
-- path string)
function M.show_file()
	local original_wd = vim.fn.getcwd()

	-- change working directory to the current file being edited (i.e. which contains the path string)
	vim.cmd(string.format("cd %s", vim.fn.expand("%:h")))

	-- get path from the highlighted string
	local filepath = vim.fn.expand("<cfile>")
	-- call tabiew with that path
	LazyVim.terminal.open({ "tw", filepath })
	-- change back to the original working directory
	vim.cmd(string.format("cd %s", original_wd))
end

return M
