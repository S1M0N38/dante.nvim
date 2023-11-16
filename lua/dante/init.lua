local dante = {}

function dante.setup(options)
	require("dante.config").setup(options)
end

function dante.main(line1, line2)
	-- Request
	local req_buf = vim.api.nvim_get_current_buf()
	local req_win = vim.api.nvim_get_current_win()
	vim.api.nvim_buf_set_option(req_buf, "filetype", "tex")
	vim.api.nvim_win_set_option(req_win, "wrap", true)
	vim.api.nvim_win_set_option(req_win, "linebreak", true)
	vim.cmd("diffthis")

	-- Response
	vim.cmd("vsplit")
	local res_win = vim.api.nvim_get_current_win()
	local res_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(res_win, res_buf)
	vim.api.nvim_buf_set_option(res_buf, "filetype", "tex")
	vim.api.nvim_win_set_option(res_win, "wrap", true)
	vim.api.nvim_win_set_option(res_win, "linebreak", true)
	vim.cmd("diffthis")

	-- Focus back to request window
	vim.api.nvim_set_current_win(req_win)

	-- Query
	require("dante.assistant").query(line1, line2, res_buf)

	-- Revert to default mappings for diff navigation
	-- vim.api.nvim_del_keymap("n", "[c")
	-- vim.api.nvim_del_keymap("x", "[c")
	-- vim.api.nvim_del_keymap("n", "]c")
	-- vim.api.nvim_del_keymap("x", "]c")

	-- Useuful mappings for diff navigation (these are the default in NeoVim)
	-- "[c":  Jump to the previous diff
	-- "]c":  Jump to the next diff
	-- "do":  Diff obtain, i.e. copy changes from the other window to the current window
	-- "dp":  Diff put, i.e. copy changes from the current window to the other window
end

return dante
