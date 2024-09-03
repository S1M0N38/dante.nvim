---@diagnostic disable: undefined-global
local dante = require("dante")

local opts = {
  verbose = true,
  presets = {
    ["default"] = {
      client = {
        base_url = "https://api.groq.com/openai/v1",
        -- base_url = "http://localhost:11434/v1", -- Test with local LLM (Ollama)
        api_key = vim.fn.getenv("GROQ_API_KEY_DANTE_NVIM"),
      },
      request = {
        temperature = 0.0001,
        -- NOTE: Groq is soo fast that I need to used the slower model (70b) to test the stream option.
        -- Otherwise, the new completion chunk is returned before the previous one is processed.
        model = "llama-3.1-70b-versatile", -- Groq
        -- model = "llama-3.1-8b-instant", -- Groq
        -- model = "llama3.1:8b-instruct-q6_K", -- Test with local LLM (Ollama)
        stream = false,
      },
    },
  },
}

---Get all the lines from the correct.md file.
---Open a new buffer, read the lines and delete the buffer.
---@return string[] lines
local function get_correct_lines()
  vim.cmd("edit ./spec/examples/correct.md")
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  return lines
end

---Open the incorrect.md file and set the marks
---@return integer start_line
---@return integer end_line
local function select_incorrect_lines()
  vim.cmd("edit ./spec/examples/incorrect.md")
  vim.api.nvim_buf_set_mark(0, "<", 7, 0, {})
  vim.api.nvim_buf_set_mark(0, ">", 19, 0, {})
  return 7, 19
end

---Get the buffer by name
local function get_res_buf()
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    local full_name = vim.api.nvim_buf_get_name(buf)
    local name = full_name:match("^.+/(.+)$") or full_name
    if name:find("%[Dante%]") then
      return buf
    end
  end
end

describe("dante.main with default preset", function()
  it("fix incorrect lines (stream=false)", function()
    dante.setup(opts)

    -- Setup
    local correct_lines = get_correct_lines()
    local start_line, end_line = select_incorrect_lines()

    -- Run dante.main
    local job_id = dante.main("default", start_line, end_line)
    vim.fn.jobwait({ job_id }, 10000)

    -- Compare the generated lines with the correct lines
    local res_buf = get_res_buf()
    local generated_lines = vim.api.nvim_buf_get_lines(res_buf, 0, -1, true)
    for i, generated_line in ipairs(generated_lines) do
      assert.are.same(correct_lines[i], generated_line, "line " .. i .. " is not equal to correct line")
    end

    -- Cleanup
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end)

  it("fix incorrect lines (stream=true)", function()
    opts.presets["default"].request.stream = true
    dante.setup(opts)

    -- Setup
    local correct_lines = get_correct_lines()
    local start_line, end_line = select_incorrect_lines()

    -- Run dante.main
    local job_id = dante.main("default", start_line, end_line)
    vim.fn.jobwait({ job_id }, 10000)

    -- Compare the generated lines with the correct lines
    local res_buf = get_res_buf()
    local generated_lines = vim.api.nvim_buf_get_lines(res_buf, 0, -1, true)
    for i, generated_line in ipairs(generated_lines) do
      assert.are.same(correct_lines[i], generated_line, "line " .. i .. " is not equal to correct line")
    end

    -- Cleanup
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end)
end)
