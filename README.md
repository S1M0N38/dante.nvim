# ✒️ Dante

An unpolished grammar checker powered by OpenAI models and [Neovim builtin diff tool](https://neovim.io/doc/user/diff.html). Seriously, it's just a proof of concept.

![example usage](https://github.com/S1M0N38/dante.nvim/blob/main/usage.gif?raw=true)

## 💡 Idea

I want to experiment with the newlly released [GPT Assistant API](https://platform.openai.com/docs/assistants/overview). Vim/Neovim builtin diff tool is a good way to highlight the differences between the original text and the suggested one.

**Edit**: I move from GPT Assistant API back to *chat completions* API because it was easy to implement API in a non-blocking fashion.

*The detailed reasons why I decided to develop dante.nvim are explained in this [Reddit post](https://www.reddit.com/r/neovim/comments/182p87j/dantenvim_a_simple_ai_writing_assistant/).*

## ✨ Features

- Prompt selected line into LLM and highlight the differences with the original text.

## ⚡️ Requirements

- Neovim >= **0.9**
- curl
- Access to OpenAI API

## 📦 Installation

1. Install using a plugin manager

```lua
-- using lazy.nvim
{
  "s1m0n38/dante.nvim",
  opts = {
    model = "gpt-4-1106-preview", -- best model but more expensive
    temperature = 0, -- reduced creativity
    prompt = "You are tasked as an assistant primarily responsible for rectifying errors within English text. Please amend spelling inaccuracies and augment grammar; ensure that the refined text closely adheres to the original version. Given that the text is authored in LaTeX intended for a master's thesis, please abide by the LaTeX syntax accordingly. Eschew informal expressions and choose terminology appropriate for a scientific manuscript. Provide your corrections in the form of the enhanced text only, devoid of commentary. Maintain the integrity of the original text's new lines and the spacing.", -- system prompt
  },

  -- Not required but it improve upon built-in diff view with char diff
  dependencies = {
    {
      "rickhowe/diffchar.vim",
      keys = {
        { "[z", "<Plug>JumpDiffCharPrevStart", desc = "Previous diff", silent = true },
        { "]z", "<Plug>JumpDiffCharNextStart", desc = "Next diff", silent = true },
        { "do", "<Plug>GetDiffCharPair", desc = "Obtain diff", silent = true },
        { "dp", "<Plug>PutDiffCharPair", desc = "Put diff", silent = true },
      },
    },
  },
}
```

2. [get an OpenAI API key](https://platform.openai.com/docs/api-reference/introduction) and add it to your environment as `OPENAI_API_KEY`.

## 🚀 Usage

**Normal Mode**

- `:Dante` send current line to LLM.

**Visual Mode**

- `:'<,'>Dante` send selected lines to LLM.

Read the Neovim [documentation](https://neovim.io/doc/user/diff.html) to learn how to navigate between and edit differences.

For obtaining the best results, you should:

- Carefully write your own prompt for you specific use case.
- Avoid breaking lines at fix column (e.g. 80). Instead, use a new line when you feel it's necessary (just like writing with pen and paper) or double new line for paragraph separation.
- Selecting smaller chunks of text focus on the details but you may miss the big picture.
- Use a powerful model like `gpt-4` but it's more expensive and slower.

## 🙏 Acknowledgments

This plugin was heavily inspired by:

- [jackMort/ChatGPT.nvim](https://github.com/jackMort/ChatGPT.nvim)
- [David-Kunz/gen.nvim](https://github.com/David-Kunz/gen.nvim)
- [Bryley/neoai.nvim](https://github.com/Bryley/neoai.nvim)

This very README is a copycat of [lazy.nvim](https://github.com/folke/lazy.nvim) README.
