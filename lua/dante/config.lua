local M = {}

local defaults = {

	presets = {
		default = {
			-- if not specified, will use global config
			-- model = "gpt-3.5-turbo",
			-- prompt = "You are an helpful assistant.",
			-- temperature = 1,
			-- stream = false,
			-- base_url = "https://api.openai.com/v1",
			-- diffopt = { ... },
		},
		-- another_preset = {
		--  -- you can define as many presets as you want
		--  -- defining config here will override global config for this preset
		-- },
	},

	-- Globals config will be used as default for all presets
	model = "gpt-3.5-turbo",
	prompt = "You are an helpful assistant.",
	temperature = 1,
	stream = false,
	env_var = "OPENAI_API_KEY",
	base_url = "https://api.openai.com/v1",
	diffopt = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
}

M.options = {}

function M.setup(options)
	M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
	for _, preset in pairs(M.options.presets) do
		for opt, value in pairs(M.options) do
			if opt ~= "presets" then
				preset[opt] = preset[opt] or value
			end
		end
	end
end

return M
