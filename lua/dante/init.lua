local dante = {}

function dante.setup(options)
	require("dante.config").setup(options)
end

function dante.main(lines)
	-- Request
	local req_win = vim.api.nvim_get_current_win()
	local req_buf = vim.api.nvim_get_current_buf()
	local line_count = vim.api.nvim_buf_line_count(req_buf)
	local filetype = vim.bo.filetype
	local wrap = vim.wo.wrap
	local linebreak = vim.wo.linebreak

	-- Set options for diff mode
	local config = require("dante.config")
	vim.cmd("set diffopt=" .. table.concat(config.options.diffopt, ","))

	-- Response
	vim.cmd("vsplit")
	local res_win = vim.api.nvim_get_current_win()
	local res_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(res_win, res_buf)
	vim.api.nvim_buf_set_option(res_buf, "filetype", filetype)
	vim.api.nvim_win_set_option(res_win, "wrap", wrap)
	vim.api.nvim_win_set_option(res_win, "linebreak", linebreak)

	-- Focus back to request window
	vim.api.nvim_set_current_win(req_win)

	-- Query
	require("dante.assistant").query(lines, res_buf, res_win, req_win)
end

return dante
