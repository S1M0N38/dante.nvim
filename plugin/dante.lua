vim.api.nvim_create_user_command("Dante", function(args)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
	require("dante").main(lines, args.line1, args.line2)
end, {
	range = true,
})
