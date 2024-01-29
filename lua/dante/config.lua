local M = {}

local defaults = {
	presets = {
		default = {
			model = "gpt-3.5-turbo",
			prompt = "You are an helpful assistant.",
			temperature = 1,
		},
	},
	openai_api_key = "OPENAI_API_KEY",
	diffopt = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
}

M.options = {}

function M.setup(options)
	M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
end

return M
