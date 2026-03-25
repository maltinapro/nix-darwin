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

      -- System clipboard integration via pbcopy/pbpaste.
      -- Pin the absolute paths so they are found even in a Nix-managed environment.
      -- With clipboard=unnamedplus every yank/paste automatically uses the system
      -- clipboard; no extra keymaps are needed.
      vim.g.clipboard = {
        name  = "macOS-clipboard",
        copy  = { ["+"] = "/usr/bin/pbcopy",  ["*"] = "/usr/bin/pbcopy"  },
        paste = { ["+"] = "/usr/bin/pbpaste", ["*"] = "/usr/bin/pbpaste" },
        cache_enabled = 0,
      }

      vim.opt.clipboard = "unnamedplus"
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
