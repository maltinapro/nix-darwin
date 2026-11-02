{ inputs, pkgs, ... }:

{
  imports = [
    # This uses the 'nvchad' input from your flake.nix
    inputs.nvchad.homeManagerModules.default
  ];

  programs.nvchad = {
    enable = true;

    # Keep plugin definitions in NvChad-style custom Lua files.
    extraPlugins = ''
      return require("custom.plugins")
    '';

    extraConfig = ''
      require("custom.configs.copilotchat")
      require("custom.mappings")

      -- Prefer fd and ripgrep explicitly for Telescope finders/grep.
      pcall(function()
        require("telescope").setup {
          defaults = {
            vimgrep_arguments = {
              "rg",
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
              "--smart-case",
            },
          },
          pickers = {
            find_files = {
              find_command = {
                "fd",
                "--type",
                "f",
                "--hidden",
                "--follow",
                "--exclude",
                ".git",
              },
            },
          },
        }
      end)

      -- Protect terminal window from being overwritten
      vim.api.nvim_create_autocmd("TermOpen", {
        callback = function()
          vim.wo.winfixbuf = true
        end,
      })

      -- Use the system clipboard for all yank/paste operations.
      -- On macOS, Neovim auto-detects pbcopy/pbpaste automatically.
      vim.opt.clipboard = "unnamedplus"

      -- Fix file watchers (e.g. fluxMarkdown) losing track of the file after the first save.
      -- Neovim's default atomic save renames a temp file over the original, which changes
      -- the inode and breaks inode-based watchers on macOS. Setting backupcopy = "yes"
      -- makes Neovim write directly into the existing file instead, keeping the inode stable.
      vim.opt.backupcopy = "yes"
    '';
    extraPackages = with pkgs; [
      # --- Rust Essentials ---
      rust-analyzer      # The "Brain" (LSP) for code completion and errors
      rustfmt            # Automatically formats your code
      clippy             # Catches common mistakes (the Rust "Linter")
      cargo              # Package manager
      rustc              # The compiler

      # --- Java Essentials ---
      jdk21              # Java toolchain for language features and builds
      jdt-language-server # Java language server (`jdtls`)

      # --- NvChad / Neovim Essentials ---
      # Use Apple's system clang toolchain on macOS for native plugin builds.
      gnumake            # Needed to build avante.nvim (`make`)
      perl               # Needed by avante.nvim's vendored OpenSSL build
      nodejs             # Runs the Copilot language server (copilot.lua, Node.js >= 22)
      sqlite             # Lets avante.nvim read the Copilot login from auth.db (`sqlite3`)

      # --- Version Control ---
      git                # Required for Git status, branches, and Gitsigns

      # --- Debugging ---
      lldb               # Debugger (works great with Rust)
    ];
  };

  home.file.".config/nvim/lua/custom/plugins.lua".source = ./nvchad/custom/plugins.lua;
  home.file.".config/nvim/lua/custom/mappings.lua".source = ./nvchad/custom/mappings.lua;
  home.file.".config/nvim/lua/custom/configs/avante.lua".source = ./nvchad/custom/configs/avante.lua;
  home.file.".config/nvim/lua/custom/configs/copilotchat.lua".source = ./nvchad/custom/configs/copilotchat.lua;
  home.file.".config/nvim/lua/custom/configs/copilotchat_tools.lua".source = ./nvchad/custom/configs/copilotchat_tools.lua;
  home.file.".config/nvim/ftplugin/java.lua".source = ./nvchad/custom/ftplugin/java.lua;
}
