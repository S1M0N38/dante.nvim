vim.api.nvim_create_user_command("Dante", function(args)
  if args.args == "" then
    args.args = "default"
  end
  require("dante").main(args.args, args.line1, args.line2)
end, { range = true, nargs = "?" })
