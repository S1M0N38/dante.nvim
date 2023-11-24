local config = require("dante.config")
local assistant = {}

local function encode(lines)
	local messages = {
		{
			role = "system",
			content = config.options.prompt,
		},
		{
			role = "user",
			content = table.concat(lines, "\n"),
		},
	}
	local json = vim.fn.json_encode({
		model = config.options.model,
		temperature = config.options.temperature,
		stream = true,
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

local function decode(res)
	if #(res or "") < 20 then
		return ""
	end
	res = vim.fn.json_decode(string.sub(res, 7))
	assert(res ~= nil, "res is nil")
	return res.choices[1].delta.content or ""
end

function assistant.query(lines, res_buf, res_win, req_win)
	local stream = ""

	local function on_stdout(_, ress, _)
		for _, res in pairs(ress) do
			local text = decode(res)
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
		vim.api.nvim_set_current_win(res_win)
		vim.cmd("diffthis")
	end

	local job = vim.fn.jobstart(command(encode(lines)), {
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
