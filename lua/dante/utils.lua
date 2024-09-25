local M = {}

---Get the last line, column and line count in the chat buffer
---Thanks to Oli Morris for this function
---https://github.com/olimorris/codecompanion.nvim/blob/
---  f8db284e1197a8cc4235afa30dcc3e8d4f3f45a5
---  /lua/codecompanion/strategies/chat.lua#L987
---@param buf integer: The buffer number
---@return integer: number of the last line
---@return integer: number of columns in the last line
M.last = function(buf)
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

---Generate a unique buffer name.
---It uses the current time in hexadecimal format prefixed with "[Dante] ".
---@return string: The generated buffer name
M.generate_buf_name = function()
  -- Generate a unique buffer name
  local current_time = os.time()
  local hex_time = string.format("%x", current_time)
  local res_buf_name = "[Dante] " .. hex_time
  return res_buf_name
end

---Replace all placeholders in the content string
---This is the core function that enable the user specify how to add context in LLM requests.
---Supported place holders are:
---  - `{{SELECTED_LINES}}`: The selected lines in the editor from VISUAL mode
---  - `{{NOW}}`: The current date and time
---@param content string: The content string to be formatted
---@param start_line integer: The start line of the selected text
---@param end_line integer: The end line of the selected text
---@return string: The formatted content string
M.format = function(content, start_line, end_line)
  local result = ""
  local last_end = 1

  ---Function to get the replacement for a placeholder
  ---@param placeholder string: The placeholder to be replaced
  ---@return string
  local function get_replacement(placeholder)
    if placeholder == "{{SELECTED_LINES}}" then
      local range_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
      return table.concat(range_lines, "\n")
    elseif placeholder == "{{NOW}}" then
      return tostring(os.date("Today is %a, %d %b %Y %H:%M:%S %z"))
      -- Add other placeholders here...
    else
      -- If not recognized, keep the original placeholder
      vim.notify("Unrecognized placeholder: " .. placeholder, vim.log.levels.WARN)
      return placeholder
    end
  end

  -- Find and replace all placeholders
  for placeholder_start, placeholder_end in content:gmatch("(){{.-}}()") do
    ---@diagnostic disable-next-line: param-type-mismatch
    local placeholder = content:sub(placeholder_start, placeholder_end - 1)
    result = result .. content:sub(last_end, placeholder_start - 1)
    result = result .. get_replacement(placeholder)
    last_end = placeholder_end
  end

  -- Append any remaining content after the last placeholder
  result = result .. content:sub(last_end)
  return result
end

return M
