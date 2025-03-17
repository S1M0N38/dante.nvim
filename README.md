<div align="center">
   <h1>✎&nbsp;&nbsp;dante.nvim&nbsp;&nbsp;<a href="https://github.com/S1M0N38/ai.nvim">✧</a></h1>
   <p align="center">
      <a href="https://github.com/S1M0N38/dante.nvim/actions/workflows/run-tests.yml">
      <img alt="Tests workflow" src="https://img.shields.io/github/actions/workflow/status/S1M0N38/dante.nvim/run-tests.yml?style=for-the-badge&label=Tests"/>
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
   <div><video src="https://github.com/user-attachments/assets/1c9b2d29-944f-4a08-8135-cda8e61a0aa7" alt="Screencast: dante.nvim example usage"></div>
   <p><em>Write, generate improved text, navigate through differences and accept/reject them individually.</em></p>
   <hr>
</div>

## ⚡️ Requirements

- Tested on Neovim ≥ **0.10**
- [cURL](https://curl.se/)
- Access to an [OpenAI compatible API](https://github.com/S1M0N38/ai.nvim?tab=readme-ov-file#-llm-providers)

## 📦 Installation

You can install dante.nvim using your preferred plugin manager. Here's an example configuration for lazy.nvim:

```lua
-- Using lazy.nvim
{
  "S1M0N38/dante.nvim",
  lazy = true,
  cmd = "Dante",
  version = "*",
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
    { "S1M0N38/ai.nvim", version = ">=1.4.2" },
  }
}
```

For a more complex configuration with the same keymaps shown in the screencast, check [my own config](https://github.com/S1M0N38/dotfiles/blob/macos/config/lazyvim/lua/plugins/dante.lua).


## 🚀 Usage

To get started with dante.nvim, read the documentation with [`:help dante`](https://github.com/S1M0N38/dante.nvim/blob/main/doc/dante.txt). This will provide you with a comprehensive overview of the plugin's features and usage.

> [!NOTE]
> **Learning Vim/Neovim Documentation**: Vim/Neovim plugins are usually shipped with :help documentation. Learning how to navigate it is a valuable skill. If you are not familiar with it, start with `:help` and read the first 20 lines.

> [!TIP]
> **Customizing Configuration**: This plugin ships with a bare minimum configuration. The idea is that the user can define their own presets to interact with different LLM providers and customize the requests down to the last LLM parameter. The downside is that the opts table could become quite large and verbose, but in Neovim, configuration == code, so you can simplify it with utility functions.

## 🙏 Acknowledgments

This plugin was inspired by the following projects:

- [jackMort/ChatGPT.nvim](https://github.com/jackMort/ChatGPT.nvim)
- [David-Kunz/gen.nvim](https://github.com/David-Kunz/gen.nvim)
- [Bryley/neoai.nvim](https://github.com/Bryley/neoai.nvim)
- [olimorris/codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim)
