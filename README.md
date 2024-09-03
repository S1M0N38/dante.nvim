# ✒️ Dante

An unpolished grammar checker powered by OpenAI models and [Neovim's builtin diff tool](https://neovim.io/doc/user/diff.html). Seriously, it's just a proof of concept.

https://github.com/S1M0N38/dante.nvim/assets/22257750/33ed003f-5160-428f-b3a2-dc4bb697f76b

## 💡 Idea

I wanted to experiment with the newly released [GPT Assistant API](https://platform.openai.com/docs/assistants/overview). Vim/Neovim's builtin diff tool is a good way to highlight the differences between the original text and the suggested one.

**Edit**: I moved from the GPT Assistant API back to the *chat completions* API because it was easier to implement the API in a non-blocking fashion.

*The detailed reasons why I decided to develop dante.nvim are explained in this [Reddit post](https://www.reddit.com/r/neovim/comments/182p87j/dantenvim_a_simple_ai_writing_assistant/).*

## ✨ Features

- Prompt selected line into LLM and highlight the differences with the original text.

## ⚡️ Requirements

- Neovim >= **0.9**
- curl
- Access to OpenAI API or compatible API (e.g., [LiteLLM](https://docs.litellm.ai/docs/simple_proxy))

## 📦 Installation

1. Install using a plugin manager

```lua
-- using lazy.nvim
{
  "s1m0n38/dante.nvim",
  opts = {
    -- these are the global options and will be used as default in every preset
    -- If global options are not specified, the plugin will use the default values
    model = "gpt-3.5-turbo",
    temperature = 0,

    presets = {
      default = {
        -- when options are not specified, the global config will be used
      },
      readme = {
        -- these options will override the global config
        model = "gpt-4",
        temperature = 0.3,
        prompt = "You are tasked as an assistant primarily responsible for rectifying errors within English text. Please amend spelling inaccuracies and augment grammar; ensure that the refined text closely adheres to the original version. Given that the text is authored in Markdown intended for a README file, please abide by the Markdown syntax accordingly. Provide your corrections in the form of the enhanced text only, devoid of commentary. Maintain the integrity of the original text's new lines and the spacing. Do NOT enclose the generated text into triple ticks.",
      },
      -- Add more presets here...
    },
  },

  -- Not required but it improves upon built-in diff view with char diff
  dependencies = {
    {
      "rickhowe/diffchar.vim",
      keys = {
        { "[z", "<Plug>JumpDiffCharPrevStart", desc = "Previous diff", silent = true },
        { "]z", "<Plug>JumpDiffCharNextStart", desc = "Next diff", silent = true },
        -- { "do", "<Plug>GetDiffCharPair", desc = "Obtain diff", silent = true },
        -- { "dp", "<Plug>PutDiffCharPair", desc = "Put diff", silent = true },
        {
          "do",
          "<Plug>GetDiffCharPair | <Plug>JumpDiffCharNextStart",
          desc = "Obtain diff and Next diff",
          silent = true,
        },
        {
          "dp",
          "<Plug>PutDiffCharPair | <Plug>JumpDiffCharNextStart",
          desc = "Put diff and Next diff",
          silent = true,
        },
      },
    },
  },
}
```

2. [Get an OpenAI API key](https://platform.openai.com/docs/api-reference/introduction) and add it to your environment as `OPENAI_API_KEY`.

## 🚀 Usage

**Normal Mode**

- `:Dante <preset>` sends the current line to LLM. If no preset is specified, the `default` preset will be used.

**Visual Mode**

- `:'<,'>Dante <preset>` sends the selected lines to LLM. If no preset is specified, the `default` preset will be used.

Read the Neovim [documentation](https://neovim.io/doc/user/diff.html) to learn how to navigate between and edit differences.

For obtaining the best results, you should:

- Carefully write your own prompt for your specific use case.
- Avoid breaking lines at a fixed column (e.g., 80). Instead, use a new line when you feel it's necessary (just like writing with pen and paper) or a double new line for paragraph separation.
- Selecting smaller chunks of text focuses on the details, but you may miss the big picture.
- Use a powerful model like `gpt-4`, but it's more expensive and slower.
- For text files with a lot of lines, you may want to increase the "linematch" diffopt to 300 or more. This is a temporary workaround until I find a better solution.

## ⚠️ Warnings

Be cautious of the text you are feeding into Dante. There is no mechanism to mitigate prompt injection, and the resulting text can be unexpected.

![example-prompt-injection](https://github.com/S1M0N38/dante.nvim/assets/22257750/c707db0f-4f67-4286-b774-fee11963c3dc)

## 🙏 Acknowledgments

This plugin was heavily inspired by:

- [jackMort/ChatGPT.nvim](https://github.com/jackMort/ChatGPT.nvim)
- [David-Kunz/gen.nvim](https://github.com/David-Kunz/gen.nvim)
- [Bryley/neoai.nvim](https://github.com/Bryley/neoai.nvim)

This very README is a copycat of [lazy.nvim](https://github.com/folke/lazy.nvim) README.
