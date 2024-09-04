<h1 align="center">✎&nbsp;&nbsp;dante.nvim&nbsp;&nbsp;✧</h1>

<p align="center">
  <a href="https://github.com/S1M0N38/dante.nvim/actions/workflows/tests.yml">
    <img alt="Tests workflow" src="https://img.shields.io/github/actions/workflow/status/S1M0N38/dante.nvim/tests.yml?style=for-the-badge&label=Tests"/>
  </a>
  <a href="https://luarocks.org/modules/S1M0N38/dante.nvim">
    <img alt="LuaRocks release" src="https://img.shields.io/luarocks/v/S1M0N38/dante.nvim?style=for-the-badge&color=5d2fbf"/>
  </a>
  <a href="https://github.com/S1M0N38/dante.nvim/releases">
    <img alt="GitHub release" src="https://img.shields.io/github/v/release/S1M0N38/dante.nvim?style=for-the-badge&label=GitHub"/>
  </a>
  <a href="https://www.reddit.com/r/neovim/comments/182p87j/dantenvim_a_simple_ai_writing_assistant/">
    <img alt="Reddit post" src="https://img.shields.io/badge/post-reddit?style=for-the-badge&label=Reddit&color=FF5700"/>
  </a>
</p>

______________________________________________________________________

> [!IMPORTANT]
> This is heavy refactoring of the original dante.nvim plugin. If you want to
> use the previous version, stick to `a6955468391665d6465b371e81d1a80eac4cf0f1`
> commit.

## ⚡️ Requirements

- Test on Neovim ≥ **0.10**
- [cURL](https://curl.se/)
- Access to [OpenAI compatible API](https://github.com/S1M0N38/ai.nvim?tab=readme-ov-file#-llm-providers)

## 📦 Installation

```lua
-- using lazy.nvim
{
  "S1M0N38/dante.nvim",
  cmd = "Dante",
  opts = {
    presets = {
      ["default"] = {
        client = {
          base_url = "https://api.openai.com/v1", -- Provider base URL
          api_key = "YOUR_API_KEY", -- Provider API key
        },
      },
    },
  },
  dependencies = {
    { "S1M0N38/ai.nvim", version="~1.0.0" },
  }
}
```

## 🚀 Usage

Read the documentation with [`:help dante`](https://github.com/S1M0N38/dante.nvim/blob/main/doc/dante.txt)

> [!NOTE]
> Vim/Neovim plugins are usually shipped with :help documentation. Learning how
> to navigate it is a really valuable skill. If you are not familiar with it,
> start with `:help` and read the first 20 lines.

> [!TIP]
> This plugin ships with a bare minimum configuration. The idea is that the
> user can define their own presets to interact with different LLM providers
> and customize the requests down to the last LLM parameter. The downside is
> that the opts table could become quite large and verbose, however in Neovim
> configuration == code so you can dry it up with utility functions.

## 🙏 Acknowledgments

This plugin was inspired by:

- [jackMort/ChatGPT.nvim](https://github.com/jackMort/ChatGPT.nvim)
- [David-Kunz/gen.nvim](https://github.com/David-Kunz/gen.nvim)
- [Bryley/neoai.nvim](https://github.com/Bryley/neoai.nvim)
- [olimorris/codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim)

This very README is a copycat of [lazy.nvim](https://github.com/folke/lazy.nvim) README.
