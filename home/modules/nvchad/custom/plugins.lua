return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    opts = {
      heading = { enabled = true },
      code = { enabled = true },
      dash = { enabled = true },
      bullet = { enabled = true },
      checkbox = { enabled = true },
      table = { enabled = true },
      link = { enabled = true },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      -- Use Node.js from extraPackages for Copilot's language server binary.
      server = { type = "nodejs" },
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = false,
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatTests",
    },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = {
      -- lazy.nvim kills build processes after `git.timeout` (120s by default),
      -- but compiling the Rust libraries with cargo takes several minutes.
      function()
        require("lazy.core.config").options.git.timeout = 1800

        if vim.loop.os_uname().sysname == "Darwin" and vim.fn.executable("xcrun") == 1 then
          local sdkroot = vim.fn.trim(vim.fn.system("xcrun --show-sdk-path"))
          local clang = vim.fn.trim(vim.fn.system("xcrun -f clang"))
          local clangxx = vim.fn.trim(vim.fn.system("xcrun -f clang++"))

          if clang ~= "" then
            vim.env.CC = clang
            vim.env.HOST_CC = clang
          end

          if clangxx ~= "" then
            vim.env.CXX = clangxx
            vim.env.HOST_CXX = clangxx
          end

          if sdkroot ~= "" then
            vim.env.SDKROOT = sdkroot
            vim.env.LIBRARY_PATH = sdkroot .. "/usr/lib"
              .. (vim.env.LIBRARY_PATH and (":" .. vim.env.LIBRARY_PATH) or "")
            vim.env.CPATH = sdkroot .. "/usr/include"
              .. (vim.env.CPATH and (":" .. vim.env.CPATH) or "")
          end
        end
      end,
      "make",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "ColinKennedy/mega.cmdparse",
      "ColinKennedy/mega.logging",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- Reuse the Copilot login from `:Copilot auth` (see custom/configs/avante.lua).
      provider = "copilot",
      -- Keymaps are defined in custom/mappings.lua; avante's experimental auto suggestions stay off.
      behaviour = { auto_suggestions = false, auto_set_keymaps = false },
    },
    config = function(_, opts)
      require("custom.configs.avante").setup(opts)
    end,
  },
}
