local M = {}

---Callback function to handle the completion of a chat request.
---@param res table
---@param opts DanteOptions
---@return function
M.on_chat_completion = function(res, opts)
  return function(obj)
    local finish_reason = obj.choices[1].finish_reason
    local content = obj.choices[1].message.content
    if finish_reason == "stop" then
      local lines = vim.split(content, "\n", { plain = true, trimempty = false })
      vim.api.nvim_buf_set_lines(res.buf, -2, -1, true, lines)
      if opts.verbose and obj.usage then
        vim.notify("usage = " .. vim.inspect(obj.usage), vim.log.levels.INFO)
      end
      vim.notify("Done.", vim.log.levels.INFO)
    else
      vim.notify("An error occured during text genereation.", vim.log.levels.ERROR)
    end
  end
end

---Callback function to handle the completion chunk of a chat request.
---@param res table
---@param opts DanteOptions
---@return function
M.on_chat_completion_chunk = function(res, opts)
  return function(obj)
    local finish_reason = obj.choices[1].finish_reason
    local content = obj.choices[1].delta.content
    if finish_reason == nil then
      local lines = vim.split(content, "\n", { plain = true, trimempty = false })
      local last_line, last_column = require("dante.utils").last(res.buf)
      vim.api.nvim_buf_set_text(res.buf, last_line, last_column, last_line, last_column, lines)
      if opts.verbose and obj.usage then
        vim.notify("usage = " .. vim.inspect(obj.usage), vim.log.levels.INFO)
      end
    elseif finish_reason == "stop" then
      vim.notify("Done.", vim.log.levels.INFO)
    else
      vim.notify("An error occured during text genereation.", vim.log.levels.ERROR)
    end
  end
end

---Callback function to handle the exit of a chat request.
---@param req RequestTable
---@param res ResponseTable
---@param opts DanteOptions
---@param after_lines string[]
---@return function
---@diagnostic disable-next-line: unused-local
M.on_exit = function(req, res, opts, after_lines)
  return function()
    vim.api.nvim_buf_set_lines(res.buf, -1, -1, true, after_lines)
    vim.api.nvim_set_current_win(res.win)
    vim.cmd("diffthis")
    vim.api.nvim_set_current_win(req.win)
    vim.cmd("diffthis")
    vim.api.nvim_set_option_value("foldlevel", 999, { win = res.win })
    vim.api.nvim_set_option_value("foldlevel", 999, { win = req.win })
  end
end

return M
