local config = {}

config.defaults = {

  -- notify with extra information
  verbose = false,

  -- list of presets
  presets = {
    ["default"] = {
      client = {
        base_url = "https://api.openai.com/v1",
        api_key = nil,
      },
      request = {
        model = "gpt-4o-mini",
        temperature = 0.0001, -- some provider complain about integer values
        stream = false,
        messages = {
          {
            role = "system",
            content = [[
  You are an assistant responsible for correcting errors in text.
  Refine the spelling and grammar while closely adhering to the original version.

  - If the text is formatted in a specific syntax (e.g., LaTeX, Markdown, Vimdoc, ...), abide by that syntax.
  - Use the same language and terminology appropriate for the context.
  - Return only the enhanced text without commentary.
  - Maintain the integrity of the original text's line breaks and spacing (i.e., follow the original text's `\n`)

  Do NOT return the generated text enclosed in triple ticks (```).
  ]],
          },
          {
            role = "user",
            content = "{{SELECTED_LINES}}",
          },
        },
      },
    },
  },
}

---@class ClientOptions
---@field base_url string: base url of the api
---@field api_key string: api key

---@class Preset
---@field client ClientOptions: client options
---@field request RequestObject: request object

---@class Options
---@field verbose boolean: report the usage of the model with vim.notify
---@field presets Preset[]: list of presets
config.options = {}

---Setup the ai.nvim client options.
---It must be called before using other ai.nvim functions.
---@param opts Options: config table
config.setup = function(opts)
  config.options = vim.tbl_deep_extend("force", {}, config.defaults, opts or {})
end

return config
