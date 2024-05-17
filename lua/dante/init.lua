local ai = require("ai")

local dante = {}

---Setup global options for Dante
---@param options Options: global optoins for Dante.
function dante.setup(options)
	require("dante.config").setup(options)
end

---Replace the placeholder in the content string
---@param content string: The content string to be formatted
---@return string: The formatted content string
function dante.format(content)
	if content:find("{{'<,'>}}") then
		local start_idx, end_idx = content:find("{{'<,'>}}")
		local start_pos = vim.fn.getpos("'<")
		local end_pos = vim.fn.getpos("'>")
		local range_lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
		local range_text = table.concat(range_lines, "\n")
		content = content:sub(1, start_idx - 1) .. range_text .. content:sub(end_idx + 1)
		return dante.format(content)

	-- TODO: add other placeholders
	-- elseif content:find("{{'<,'>}}")[1] then
	--    return dante.format(content)
	else
		return content
	end
end

---Represents a chat completion request to be sent to the model.
---Reference: https://platform.openai.com/docs/api-reference/chat/create
---@alias RequestObject table

---Run Dante with the given preset
---@param preset_key string: One of the preset from options
---@param start_line integer: The start line of the selected text
---@param end_line integer: The end line of the selected text
function dante.main(preset_key, start_line, end_line)
	-- LLM Client
	local options = require("dante.config").options
	local preset = vim.deepcopy(options.presets[preset_key])
	local client = ai.Client:new(preset.client.base_url, preset.client.api_key)

	-- Format the messages content (e.g. substitute selected text)
	for _, message in ipairs(preset.request.messages) do
		message.content = dante.format(message.content)
	end

	-- Request UI
	local req_win = vim.api.nvim_get_current_win()
	local req_buf = vim.api.nvim_get_current_buf()
	local filetype = vim.bo.filetype
	local wrap = vim.wo.wrap
	local linebreak = vim.wo.linebreak
	local breakindent = vim.wo.breakindent
	vim.cmd("set diffopt=internal,filler,closeoff,followwrap,iblank")

	-- Response
	vim.cmd("vsplit")
	local res_win = vim.api.nvim_get_current_win()
	local res_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(res_win, res_buf)
	vim.api.nvim_set_option_value("filetype", filetype, { buf = res_buf })
	vim.api.nvim_set_option_value("wrap", wrap, { win = res_win })
	vim.api.nvim_set_option_value("linebreak", linebreak, { win = res_win })
	vim.api.nvim_set_option_value("breakindent", breakindent, { win = res_win })

	-- Partition request buffer
	local before_lines = vim.api.nvim_buf_get_lines(req_buf, 0, start_line - 1, true)
	local after_lines = vim.api.nvim_buf_get_lines(req_buf, end_line, -1, true)

	-- Add line before the response
	vim.api.nvim_buf_set_lines(res_buf, 0, 0, true, before_lines)
	vim.api.nvim_win_set_cursor(res_win, { start_line, 0 })

	local function on_chat_completion(obj)
		local finish_reason = obj.choices[1].finish_reason
		local content = obj.choices[1].message.content
		if finish_reason == "stop" then
			local lines = vim.split(content, "\n")
			vim.api.nvim_buf_set_lines(res_buf, -1, -1, true, lines)
			vim.api.nvim_buf_set_lines(res_buf, -1, -1, true, after_lines)
			if options.verbose and obj.usage then
				vim.notify("usage = " .. vim.inspect(obj.usage), vim.log.levels.INFO)
			end
			vim.notify("Done.", vim.log.levels.INFO)
		else
			vim.notify("An error occured during text genereation.", vim.log.levels.ERROR)
		end
	end

	local function on_exit()
		vim.api.nvim_set_current_win(res_win)
		vim.cmd("diffthis")
		vim.api.nvim_set_current_win(req_win)
		vim.cmd("diffthis")
	end

	client:chat_completion_create(preset.request, on_chat_completion, nil, nil, nil, on_exit)
end

return dante
