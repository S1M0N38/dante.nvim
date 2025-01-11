---@diagnostic disable: lowercase-global
local _MODREV, _SPECREV = "scm", "-1"
rockspec_format = "3.0"
package = "dante.nvim"
version = _MODREV .. _SPECREV

description = {
	summary = "A Neovim grammar checker powered by LLM.",
	labels = { "neovim" },
	homepage = "https://github.com/S1M0N38/ai.nvim",
	license = "MIT",
}

dependencies = {
	"ai.nvim >= 1.4.2-1",
}

test_dependencies = {
	"nlua",
}

source = {
	url = "git://github.com/S1M0N38/" .. package,
}

build = {
	type = "builtin",
}
