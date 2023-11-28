vim.api.nvim_create_user_command("Dante", function(args)
	require("dante").main(args.line1, args.line2)
end, { range = true })
