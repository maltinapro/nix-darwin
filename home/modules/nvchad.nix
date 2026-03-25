{ inputs, pkgs, ... }:

{
  imports = [
    # This uses the 'nvchad' input from your flake.nix
    inputs.nvchad.homeManagerModule 
  ];

  programs.nvchad = {
    enable = true;
    
    extraPlugins = ''
      return {
        {
          "MeanderingProgrammer/render-markdown.nvim",
          dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
          ft = { "markdown" },
          opts = {
            heading  = { enabled = true },
            code     = { enabled = true },
            dash     = { enabled = true },
            bullet   = { enabled = true },
            checkbox = { enabled = true },
            table    = { enabled = true },
            link     = { enabled = true },
          },
        },
      }
    '';

    extraConfig = ''
      -- Protect terminal window from being overwritten
      vim.api.nvim_create_autocmd("TermOpen", {
        callback = function()
          vim.wo.winfixbuf = true
        end,
      })

      -- System-wide clipboard integration (Cmd+C / Cmd+V)
      -- Explicitly configure macOS clipboard provider so pbcopy/pbpaste are found
      -- even when running inside a Nix-managed environment where PATH may differ.
      vim.g.clipboard = {
        name  = "macOS-clipboard",
        copy  = { ["+"] = "/usr/bin/pbcopy",  ["*"] = "/usr/bin/pbcopy"  },
        paste = { ["+"] = "/usr/bin/pbpaste", ["*"] = "/usr/bin/pbpaste" },
        cache_enabled = 0,
      }

      vim.opt.clipboard = "unnamedplus"

      -- Explicit visual-mode yank to system clipboard.
      -- 'y' / 'Y' are mapped so that selecting text in visual mode and pressing
      -- the standard yank key always writes to the '+' register (pbcopy), making
      -- the selection immediately available in any macOS GUI app.
      -- Note: <D-c> only works in GUI neovim (e.g. Neovide); terminal emulators
      -- intercept Cmd+C before it reaches neovim, so an explicit 'y' mapping is
      -- the reliable path for terminal users.
      vim.keymap.set("v", "y", '"+y', { noremap = true, silent = true, desc = "Yank selection to system clipboard" })

      vim.keymap.set({ "n", "v" }, "<D-c>", '"+y', { desc = "Copy to system clipboard" })
      vim.keymap.set("n", "<D-v>", '"+p', { desc = "Paste from system clipboard" })
      vim.keymap.set("v", "<D-v>", '"+P', { desc = "Paste from system clipboard" })
      vim.keymap.set("i", "<D-v>", "<C-r><C-o>+", { desc = "Paste from system clipboard" })
    '';
    extraPackages = with pkgs; [
      # --- Rust Essentials ---
      rust-analyzer      # The "Brain" (LSP) for code completion and errors
      rustfmt            # Automatically formats your code
      clippy             # Catches common mistakes (the Rust "Linter")
      cargo              # Package manager
      rustc              # The compiler
      
      # --- NvChad / Neovim Essentials ---
      ripgrep            # Required for NvChad's "Telescope" search
      fd                 # Fast file finder
      gcc                # Needed for compiling some Neovim plugins (Treesitter)
      
      # --- Version Control ---
      git                # Required for Git status, branches, and Gitsigns
      
      # --- Debugging ---
      lldb               # Debugger (works great with Rust)
    ];
  };
}
