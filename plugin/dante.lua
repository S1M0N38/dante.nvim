vim.api.nvim_create_user_command("Dante", function(args)
	local lines = vim.api.nvim_buf_get_lines(0, args.line1 - 1, args.line2, true)
	require("dante").main(lines)
end, {
	range = true,
})
