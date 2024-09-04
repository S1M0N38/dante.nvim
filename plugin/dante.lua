local function preset_keys()
  local presets = require("dante.config").options.presets
  local keys = {}
  for key, _ in pairs(presets) do
    table.insert(keys, key)
  end
  return keys
end

local function is_available_preset(preset)
  local presets = require("dante.config").options.presets
  return presets[preset] ~= nil
end

local function dante_cmd(opts)
  -- Force the user to select a range of text
  if opts.range ~= 2 then
    vim.notify("Dante: please select a range of text.", vim.log.levels.WARN)
    return
  end

  -- Check if the user selected a valid preset
  local selected_preset = opts.args or "default"
  if selected_preset == "" then
    selected_preset = "default"
  end
  if not is_available_preset(selected_preset) then
    vim.notify("Dante: " .. selected_preset .. " is an invalid preset", vim.log.levels.WARN)
    vim.notify("Dante: available presets are: " .. vim.inspect(preset_keys()), vim.log.levels.WARN)
    return
  end

  vim.notify("Dante: running with preset " .. selected_preset)
  require("dante").main(selected_preset, opts.line1, opts.line2)
end

vim.api.nvim_create_user_command("Dante", dante_cmd, {
  nargs = "?",
  range = true,
  desc = "Dante command with preset completions",
  complete = function(arg_lead, _, _)
    return vim
      .iter(preset_keys())
      :filter(function(preset)
        return preset:find(arg_lead) ~= nil
      end)
      :totable()
  end,
})
