local dante = {}

function dante.setup(options)
	require("dante.config").setup(options)
end

function dante.main(start_line, end_line)
	-- Request
	local req_win = vim.api.nvim_get_current_win()
	local req_buf = vim.api.nvim_get_current_buf()
	local filetype = vim.bo.filetype

	-- Set options for diff mode
	local config = require("dante.config")
	vim.cmd("set diffopt=" .. table.concat(config.options.diffopt, ","))

	-- Response
	vim.cmd("vsplit")
	local res_win = vim.api.nvim_get_current_win()
	local res_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(res_win, res_buf)
	vim.api.nvim_buf_set_option(res_buf, "filetype", filetype)

	for _, wo in pairs(config.options.wo) do
		vim.api.nvim_win_set_option(res_win, wo, vim.api.nvim_win_get_option(req_win, wo))
	end

	-- Partition request buffer
	local before_lines = vim.api.nvim_buf_get_lines(req_buf, 0, start_line, true)
	local lines = vim.api.nvim_buf_get_lines(req_buf, start_line, end_line, true)
	local after_lines = vim.api.nvim_buf_get_lines(req_buf, end_line, -1, true)

	-- Add line before the response
	vim.api.nvim_buf_set_lines(res_buf, 0, 0, true, before_lines)
	vim.api.nvim_win_set_cursor(res_win, { start_line, 0 })

	local function callback()
		-- Add line after the response
		vim.api.nvim_buf_set_lines(res_buf, -1, -1, true, after_lines)

		-- Calculate diff
		vim.api.nvim_set_current_win(res_win)
		vim.cmd("diffthis")
		vim.api.nvim_set_current_win(req_win)
		vim.cmd("diffthis")
	end

	-- Query
	require("dante.assistant").query(lines, res_buf, callback)
end

return dante
