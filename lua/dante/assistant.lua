local config = require("dante.config")
local assistant = {}

local commands = {
	create_thread = function()
		local cmd = [[
      curl https://api.openai.com/v1/threads \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -H "OpenAI-Beta: assistants=v1" \
        -d ''
    ]]
		return cmd
	end,
	create_message = function(thread_id, req_lines)
		local content = table.concat(req_lines, "\n")
		local data = vim.fn.json_encode({ role = "user", content = content })
		local url = "curl " .. "https://api.openai.com/v1/threads/" .. thread_id .. "/messages"
		local cmd = url
			.. [[ \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -H "OpenAI-Beta: assistants=v1" \
        -d ]]
			.. vim.fn.shellescape(data)
		return cmd
	end,
	create_run = function(thread_id, assistant_id)
		local data = vim.fn.json_encode({ assistant_id = assistant_id })
		local url = "curl " .. "https://api.openai.com/v1/threads/" .. thread_id .. "/runs"
		local cmd = url
			.. [[ \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -H "Content-Type: application/json" \
        -H "OpenAI-Beta: assistants=v1" \
        -d ]]
			.. vim.fn.shellescape(data)
		return cmd
	end,
	retrive_run = function(thread_id, run_id)
		local url = "curl " .. "https://api.openai.com/v1/threads/" .. thread_id .. "/runs/" .. run_id
		local cmd = url
			.. [[ \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -H "OpenAI-Beta: assistants=v1" ]]
		return cmd
	end,

	list_messages = function(thread_id)
		local query_params = "\\?limit=1"
		local url = "curl " .. "https://api.openai.com/v1/threads/" .. thread_id .. "/messages"
		local cmd = url
			.. query_params
			.. [[ \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -H "Content-Type: application/json" \
        -H "OpenAI-Beta: assistants=v1" ]]
		return cmd
	end,
}

function assistant.query(line1, line2, res_buf)
	local req_lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, true)

	vim.fn.jobstart(commands.create_thread(), {
		clear_env = true,
		env = { OPENAI_API_KEY = os.getenv("OPENAI_API_KEY") },
		stdout_buffered = true,
		on_stdout = function(_, thread, _)
			thread = vim.fn.json_decode(thread)
			assert(thread ~= nil)

			vim.fn.jobstart(commands.create_message(thread.id, req_lines), {
				clear_env = true,
				env = { OPENAI_API_KEY = os.getenv("OPENAI_API_KEY") },
				stdout_buffered = true,
				on_stdout = function(_, message, _)
					message = vim.fn.json_decode(message)
					assert(message ~= nil)

					vim.fn.jobstart(commands.create_run(thread.id, config.options.assistant_id), {
						clear_env = true,
						env = { OPENAI_API_KEY = os.getenv("OPENAI_API_KEY") },
						stdout_buffered = true,
						on_stdout = function(_, run, _)
							run = vim.fn.json_decode(run)
							assert(run ~= nil)

							-- Periodically check run status
							repeat
								vim.wait(2000)
								vim.fn.jobstart(commands.retrive_run(thread.id, run.id), {
									clear_env = true,
									env = { OPENAI_API_KEY = os.getenv("OPENAI_API_KEY") },
									stdout_buffered = true,
									on_stdout = function(_, new_run, _)
										run = vim.fn.json_decode(new_run)
										assert(run ~= nil)
									end,
								})
							until run.status == "completed"

							vim.fn.jobstart(commands.list_messages(thread.id), {
								clear_env = true,
								env = { OPENAI_API_KEY = os.getenv("OPENAI_API_KEY") },
								stdout_buffered = true,
								on_stdout = function(_, messages, _)
									messages = vim.fn.json_decode(messages)
									assert(messages ~= nil)
									local res = messages.data[1].content[1].text.value
									local res_lines = vim.split(res, "\n")
									for _ = 1, line1 - 1 do
										table.insert(res_lines, 1, "")
									end
									vim.api.nvim_buf_set_lines(res_buf, 0, -1, false, res_lines)
								end,
							})
						end,
					})
				end,
			})
		end,
	})
	return {}
end

return assistant
