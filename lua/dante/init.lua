local ai = require("ai")

local dante = {}

---Setup global options for Dante
---@param options Options: global optoins for Dante.
function dante.setup(options)
  require("dante.config").setup(options)
end

---Replace all placeholders in the content string
---@param content string: The content string to be formatted
---@param start_line integer: The start line of the selected text
---@param end_line integer: The end line of the selected text
---@param buf integer: The buffer number of the selected text
---@return string: The formatted content string
function dante.format(content, start_line, end_line, buf)
  local result = ""
  local last_end = 1

  -- Function to get the replacement for a placeholder
  local function get_replacement(placeholder)
    if placeholder == "{{SELECTED_LINES}}" then
      local range_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
      return table.concat(range_lines, "\n")
    elseif placeholder == "{{NOW}}" then
      return os.date("Today is %a, %d %b %Y %H:%M:%S %z")
    -- Add other placeholders here...
    else
      -- If not recognized, keep the original placeholder
      vim.notify("Unrecognized placeholder: " .. placeholder, vim.log.levels.WARN)
      return placeholder
    end
  end

  -- Find and replace all placeholders
  for placeholder_start, placeholder_end in content:gmatch("(){{.-}}()") do
    local placeholder = content:sub(placeholder_start, placeholder_end - 1)
    result = result .. content:sub(last_end, placeholder_start - 1)
    result = result .. get_replacement(placeholder)
    last_end = placeholder_end
  end

  -- Append any remaining content after the last placeholder
  result = result .. content:sub(last_end)

  return result
end

---Get the last line, column and line count in the chat buffer
---Thanks to Oli Morris for this function
---https://github.com/olimorris/codecompanion.nvim/blob/
---  f8db284e1197a8cc4235afa30dcc3e8d4f3f45a5
---  /lua/codecompanion/strategies/chat.lua#L987
---@param buf integer: The buffer number
---@return integer: number of the last line
---@return integer: number of columns in the last line
local function last(buf)
  local line_count = vim.api.nvim_buf_line_count(buf)
  local last_line = line_count - 1
  if last_line < 0 then
    return 0, 0
  end
  local last_line_content = vim.api.nvim_buf_get_lines(buf, -2, -1, false)
  if not last_line_content or #last_line_content == 0 then
    return last_line, 0
  end
  local last_column = #last_line_content[1]
  return last_line, last_column
end

---Represents a chat completion request to be sent to the model.
---Reference: https://platform.openai.com/docs/api-reference/chat/create
----@alias RequestObject table (already defined in ai.nvim)

---Run Dante with the given preset
---@param preset_key string: One of the preset from options
---@param start_line integer: The start line of the selected text
---@param end_line integer: The end line of the selected text
---@return integer: Job id of the running job (curl request)
function dante.main(preset_key, start_line, end_line)
  -- LLM Client
  local options = require("dante.config").options
  local preset = vim.deepcopy(options.presets[preset_key])
  local client = ai.Client:new(preset.client.base_url, preset.client.api_key)

  -- Format the messages content (e.g. substitute selected text)
  for _, message in ipairs(preset.request.messages) do
    message.content = dante.format(message.content, start_line, end_line)
  end

  -- Request UI
  local req_win = vim.api.nvim_get_current_win()
  local req_buf = vim.api.nvim_get_current_buf()
  local filetype = vim.bo.filetype
  local wrap = vim.wo.wrap
  local linebreak = vim.wo.linebreak
  local breakindent = vim.wo.breakindent
  vim.cmd("set diffopt=internal,filler,closeoff,followwrap,iblank")

  -- Generate a unique buffer name
  local current_time = os.time()
  local hex_time = string.format("%x", current_time)
  local res_buf_name = "[Dante] " .. hex_time

  -- Response
  vim.cmd("vsplit")
  local res_win = vim.api.nvim_get_current_win()
  local res_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(res_win, res_buf)
  vim.api.nvim_buf_set_name(res_buf, res_buf_name)
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
      local lines = vim.split(content, "\n", { plain = true, trimempty = false })
      vim.api.nvim_buf_set_lines(res_buf, -2, -1, true, lines)
      if options.verbose and obj.usage then
        vim.notify("usage = " .. vim.inspect(obj.usage), vim.log.levels.INFO)
      end
      vim.notify("Done.", vim.log.levels.INFO)
    else
      vim.notify("An error occured during text genereation.", vim.log.levels.ERROR)
    end
  end

  local function on_chat_completion_chunk(obj)
    local finish_reason = obj.choices[1].finish_reason
    local content = obj.choices[1].delta.content
    if finish_reason == vim.NIL then
      local lines = vim.split(content, "\n", { plain = true, trimempty = false })
      local last_line, last_column = last(res_buf)
      vim.api.nvim_buf_set_text(res_buf, last_line, last_column, last_line, last_column, lines)
      if options.verbose and obj.usage then
        vim.notify("usage = " .. vim.inspect(obj.usage), vim.log.levels.INFO)
      end
    elseif finish_reason == "stop" then
      vim.notify("Done.", vim.log.levels.INFO)
    else
      vim.notify("An error occured during text genereation.", vim.log.levels.ERROR)
    end
  end

  local function on_exit()
    vim.api.nvim_buf_set_lines(res_buf, -1, -1, true, after_lines)
    vim.api.nvim_set_current_win(res_win)
    vim.cmd("diffthis")
    vim.api.nvim_set_current_win(req_win)
    vim.cmd("diffthis")
  end

  return client:chat_completion_create(preset.request, on_chat_completion, on_chat_completion_chunk, nil, nil, on_exit)
end

return dante
