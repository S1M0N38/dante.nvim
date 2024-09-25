local ai = require("ai")
local utils = require("dante.utils")
local callbacks = require("dante.callbacks")

local dante = {}

--- Setup global options for Dante
---@param options DanteOptions: global options for Dante
function dante.setup(options)
  require("dante.config").setup(options)
end

--- Setup the UI for Dante
---@param opts DanteOptions: The options for Dante
local function setup_ui(opts)
  -- Diff options
  local diff = {
    "internal",
    "filler",
    "closeoff",
    "followwrap",
    "iblank",
  }
  vim.cmd("set diffopt=" .. table.concat(diff, ","))

  -- Request
  local req = {
    name = vim.api.nvim_buf_get_name(0),
    buf = vim.api.nvim_get_current_buf(),
    win = vim.api.nvim_get_current_win(),
  }

  local buf_opts = {
    ft = vim.bo.filetype,
  }

  local win_opts = {
    wrap = vim.wo.wrap,
    lbr = vim.wo.linebreak,
    bri = vim.wo.breakindent,
  }

  -- Response
  local res = {
    buf = vim.api.nvim_create_buf(false, true),
    name = utils.generate_buf_name(),
  }
  vim.api.nvim_buf_set_name(res.buf, res.name)
  for opt, value in pairs(buf_opts) do
    vim.api.nvim_set_option_value(opt, value, { buf = res.buf })
  end

  -- TODO: do not open the window if overlay | vertical | horizontal
  res.win = vim.api.nvim_open_win(res.buf, true, { split = "right", win = req.win })
  for opt, value in pairs(win_opts) do
    vim.api.nvim_set_option_value(opt, value, { win = res.win })
  end

  return req, res
end

--- Represents a chat completion request to be sent to the model.
--- Reference: https://platform.openai.com/docs/api-reference/chat/create
----@alias RequestObject table (already defined in ai.nvim)

--- Run Dante with the given preset
---@param preset_key string: One of the presets from options
---@param start_line integer: The start line of the selected text
---@param end_line integer: The end line of the selected text
---@return integer: Job id of the running job (curl request)
function dante.main(preset_key, start_line, end_line)
  local opts = require("dante.config").options

  -- LLM Client
  local preset = vim.deepcopy(opts.presets[preset_key])
  local client = ai.Client:new(preset.client.base_url, preset.client.api_key)

  -- Format the messages content (e.g. substitute selected text)
  for _, message in ipairs(preset.request.messages) do
    message.content = utils.format(message.content, start_line, end_line)
  end

  local req, res = setup_ui(opts)

  -- Partition request buffer
  local before_lines = vim.api.nvim_buf_get_lines(req.buf, 0, start_line - 1, true)
  local after_lines = vim.api.nvim_buf_get_lines(req.buf, end_line, -1, true)

  -- Add line before the response
  vim.api.nvim_buf_set_lines(res.buf, 0, 0, true, before_lines)

  -- NOTE: maybe remove this
  -- vim.api.nvim_win_set_cursor(res_win, { start_line, 0 })

  local on_chat_completion = callbacks.on_chat_completion(res, opts)
  local on_chat_completion_chunk = callbacks.on_chat_completion_chunk(res, opts)

  local on_stdout = nil -- use ai.nvim on_stdout
  local on_stderr = nil -- use ai.nvim on_stderr
  local on_exit = callbacks.on_exit(res, req, opts, after_lines)

  return client:chat_completion_create(
    preset.request,
    on_chat_completion,
    on_chat_completion_chunk,
    on_stdout,
    on_stderr,
    on_exit
  )
end

return dante
