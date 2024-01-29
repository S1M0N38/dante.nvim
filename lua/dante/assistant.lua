local config = require("dante.config")
local assistant = {}

local function encode(preset, lines)
	preset = config.options.presets[preset]
	local messages = {
		{
			role = "system",
			content = preset.prompt,
		},
		{
			role = "user",
			content = table.concat(lines, "\n"),
		},
	}
	local json = vim.fn.json_encode({
		model = preset.model,
		temperature = preset.temperature,
		stream = preset.stream,
		messages = messages,
	})
	return json
end

local function command(req)
	local args = {
		"--silent",
		"--no-buffer",
		'--header "Authorization: Bearer $OPENAI_API_KEY"',
		'--header "content-type: application/json"',
		"--url https://api.openai.com/v1/chat/completions",
		"--data " .. vim.fn.shellescape(req),
	}
	return "curl " .. table.concat(args, " ")
end

local function decode(preset, res)
	preset = config.options.presets[preset]
	if #(res or "") < 20 then
		return ""
	end
	if preset.stream then
		res = vim.fn.json_decode(string.sub(res, 7))
		assert(res ~= nil, "res is nil")
		return res.choices[1].delta.content or ""
	else
		res = vim.fn.json_decode(res)
		return res.choices[1].message.content
	end
end

function assistant.query(preset, query, res_buf, callback)
	local stream = ""

	local function on_stdout(_, ress, _)
		for _, res in pairs(ress) do
			local text = decode(preset, res)
			if text ~= "" then
				local lines = vim.split(text, "\n", { plain = true, trimempty = false })
				local row = vim.api.nvim_buf_get_lines(res_buf, 0, -1, false)
				local col = row[#row] or ""
				vim.api.nvim_buf_set_text(res_buf, #row - 1, #col, #row - 1, #col, lines)
				stream = stream .. text
			end
		end
	end

	local function on_exit()
		vim.notify("Done.")
		callback()
	end

	local job = vim.fn.jobstart(command(encode(preset, query)), {
		clear_env = true,
		env = { OPENAI_API_KEY = os.getenv(config.options.openai_api_key) },
		on_stdout = on_stdout,
		on_exit = on_exit,
	})

	vim.notify("Quering llm...")

	vim.api.nvim_buf_set_keymap(res_buf, "n", "x", "", {
		callback = function()
			vim.notify("Stop.")
			vim.fn.jobstop(job)
		end,
	})
end

return assistant
