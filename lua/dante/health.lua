local M = {}

---Validate the preset table
---@param preset Preset
---@return boolean: Whether the preset is valid
---@return string?: Error message
local function validatePreset(preset)
  -- Check if the preset has the required fields
  if not preset.client or not preset.request then
    return false, "Preset must contain 'client' and 'request' fields."
  end

  -- Validate client options
  if type(preset.client) ~= "table" or not preset.client.base_url then
    return false, "Client options must be a table with 'base_url' (required) and 'api_key' (optional)."
  end

  -- Validate request object
  local request = preset.request
  if type(request) ~= "table" or not request.model or not request.messages then
    return false, "Request must be a table with 'model' and 'messages'."
  end

  if type(request.messages) ~= "table" or #request.messages == 0 then
    return false, "Messages must be a non-empty table."
  end

  -- Check that all messages have the required fields
  for _, message in ipairs(request.messages) do
    if type(message) ~= "table" or not message.role or not message.content then
      return false, "Each message must be a table with 'role' and 'content'."
    end
  end

  return true
end


---Validate the options table obtained from merging defaults and user options
local function validate_opts_table()
  local opts = require("dante.config").options

  for preset_key, preset in pairs(opts.presets) do
    local ok, err = validatePreset(preset)
    if not ok then
      vim.health.error("Invalid preset `" .. preset_key .. "`: " .. err)
    else
      vim.health.ok("Preset `" .. preset_key .. "` is valid")
    end
  end

  if type(opts.verbose) ~= "boolean" then
    vim.health.error("Verbose option must be a boolean")
  else
    vim.health.ok("Verbose option is valid")
  end

  if vim.tbl_contains({ "right", "left", "above", "below" }, opts.layout) then
    vim.health.ok("Layout option is valid")
  else
    vim.health.error("Layout option must be 'right', 'left', 'above', or 'below'")
  end
end


local function check_dependencies()
  local ok, _ = pcall(function() require("ai") end)
  if not ok then
    vim.health.error("ai.nvim is not installed")
  else
    vim.health.ok("ai.nvim is installed")
  end
end


---This function is used to check the health of the plugin
---It's called by `:checkhealth` command
M.check = function()
  vim.health.start("dante.nvim health check")
  check_dependencies()
  validate_opts_table()
end


return M
