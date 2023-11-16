# ✒️ Dante

A crapy and unpolished grammar checker powered by [GPT Assistant](https://openai.com/blog/introducing-gpts) and [Neovim builtin diff tool](https://neovim.io/doc/user/diff.html). Seriously, it's just a proof of concept.

## 💡 Idea

I want to experiment with the newlly released [GPT Assistant API](https://platform.openai.com/docs/assistants/overview). Vim/Neovim builtin diff tool is a good way to highlight the differences between the original text and the suggested one.

## ✨ Features

- Prompt selected line into GPT Assistant and highlight the differences with the original text.

## ⚡️ Requirements

- Neovim >= **0.9**
- curl
- Access to OpenAI GPT Assistant API

## 📦 Installation

1. Install using a plugin manager

```lua
-- using lazy.nvim
{
  "s1m0n38/dante.nvim",
  opts = {
	  assistant_id = "asst_........",
  },
}
```

2. [get an OpenAI API key](https://platform.openai.com/docs/api-reference/introduction) and add it to your environment as `OPENAI_API_KEY`.
1. Create a GPT Assistant and add its id to your configuration as `assistant_id`.

For example I create a GPT Assistant with the following settings:

- **Instructions**: `You are a helpful assistant whose job is to correct errors in English text. Correct spelling errors and improve grammar so that the generated text is as similar to the original as possible. The text is written in LaTeX and is for a master thesis. Reply only with the improved text without comments.`
- **Model**: `gpt-3.5-turbo-16k`

## 🚀 Usage

**Normal Mode**

- `:Dante` send current line to GPT Assistant.

**Visual Mode**

- `:'<,'>Dante` send selected lines to GPT Assistant.

Read the [documentation](https://neovim.io/doc/user/diff.html) to learn how to navigate between and edit differences.

## 🙏 Acknowledgments

This plugin was heavily inspired by:

- [jackMort/ChatGPT.nvim](https://github.com/jackMort/ChatGPT.nvim)
- [David-Kunz/gen.nvim](https://github.com/David-Kunz/gen.nvim)
- [Bryley/neoai.nvim](https://github.com/Bryley/neoai.nvim)

This very README is a copycat of [lazy.nvim](https://github.com/folke/lazy.nvim) README.
