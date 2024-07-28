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

function M.show_df()
	local wordUnderCursor = get_current_expr()
	local time = os.time()
	print(string.format("tw /tmp/%s.csv", time))

	require("dapui").eval(string.format("%s.to_csv('/tmp/%s.csv', index=True)", wordUnderCursor, time))
	close_floating()
	LazyVim.terminal.open({ "tw", string.format("/tmp/%s.csv", time) })
end

return M
