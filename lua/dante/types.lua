---@meta

--- lua/dante/init.lua ---------------------------------------------------------

--- lua/dante/config.lua -------------------------------------------------------

---@alias Layout "right" | "left" | "above" | "below" | "overlay"

---@class Preset
---@field client AiOptions: client options for ai.nvim
---@field request RequestObject: request object

---@class DanteOptions
---@field verbose boolean: report the usage of the model with vim.notify
---@field layout Layout: layout of of the response buffer
---@field presets Preset[]: list of presets

--- lua/dante/utils.lua --------------------------------------------------------
