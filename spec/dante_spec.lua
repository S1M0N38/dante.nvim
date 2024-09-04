---@diagnostic disable: undefined-global
local dante = require("dante")

local opts = {
  presets = {
    ["default"] = {
      client = {
        base_url = "https://api.groq.com/openai/v1",
        -- base_url = "http://localhost:11434/v1", -- Ollama (Local)
        api_key = vim.fn.getenv("GROQ_API_KEY_DANTE_NVIM"),
      },
      request = {
        temperature = 0.0001,
        -- NOTE: Groq is soo fast that I need to used the slower model (70b) to test the stream option.
        -- Otherwise, the new completion chunk is returned before the previous one is processed.
        model = "llama-3.1-70b-versatile", -- Groq (External)
        -- model = "llama-3.1-8b-instant", -- Groq (External)
        -- model = "llama3.1:8b-instruct-q6_K", -- Ollama (Local)
        stream = false,
      },
    },
  },
}

---Get response buffer by matching the buffer name: "[Dante]"
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
  local correct_lines, start_line, end_line, res_buf

  setup(function()
    dante.setup(opts)
    vim.cmd("edit ./spec/examples/who-is-dante-fix.md")
    correct_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    vim.cmd("edit ./spec/examples/who-is-dante.md")
    start_line, end_line = 7, 19 -- line to be fixed
  end)

  teardown(function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end)

  it("fix incorrect lines in md file (stream=false)", function()
    -- Run dante.main
    local job_id = dante.main("default", start_line, end_line)
    vim.fn.jobwait({ job_id }, 10000)

    -- Compare the generated lines with the correct lines
    res_buf = get_res_buf()
    local generated_lines = vim.api.nvim_buf_get_lines(res_buf, 0, -1, true)
    for i, generated_line in ipairs(generated_lines) do
      assert.are.same(correct_lines[i], generated_line, "line " .. i .. " is not equal to correct line")
    end
  end)

  it("fix incorrect lines in md file (stream=true)", function()
    opts.presets["default"].request.stream = true
    dante.setup(opts)

    -- Run dante.main
    local job_id = dante.main("default", start_line, end_line)
    vim.fn.jobwait({ job_id }, 10000)

    -- Compare the generated lines with the correct lines
    res_buf = get_res_buf()
    local generated_lines = vim.api.nvim_buf_get_lines(res_buf, 0, -1, true)
    for i, generated_line in ipairs(generated_lines) do
      assert.are.same(correct_lines[i], generated_line, "line " .. i .. " is not equal to correct line")
    end
  end)
end)

describe("dante.main with placeholders in the selected lines", function()
  local correct_lines, start_line, end_line, res_buf

  it("fix incorrect lines in txt file", function()
    -- Setup
    dante.setup(opts)
    vim.cmd("edit ./spec/examples/placeholders-fix.txt")
    correct_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    vim.cmd("edit ./spec/examples/placeholders.txt")
    start_line, end_line = 1, 12 -- line to be fixed (all lines)

    -- Run dante.main
    local job_id = dante.main("default", start_line, end_line)
    vim.fn.jobwait({ job_id }, 10000)

    -- Compare the generated lines with the correct lines
    res_buf = get_res_buf()
    local generated_lines = vim.api.nvim_buf_get_lines(res_buf, 0, -1, true)
    for i, generated_line in ipairs(generated_lines) do
      assert.are.same(correct_lines[i], generated_line, "line " .. i .. " is not equal to correct line")
    end

    -- Teardown
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end)
end)
