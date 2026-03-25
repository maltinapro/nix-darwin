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
        {
          "3rd/image.nvim",
          build = false, -- Nix provides imagemagick and magick lua bindings; no build step needed
          ft = { "markdown" },
          opts = {
            backend = "kitty",
            integrations = {
              markdown = {
                enabled = true,
                clear_in_insert_mode = false,
                download_remote_images = true,
                only_render_image_at_cursor = false,
                filetypes = { "markdown" },
              },
            },
            max_height_window_percentage = 50,
            kitty_method = "normal",
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

      -- Use the system clipboard for all yank/paste operations.
      -- On macOS, Neovim auto-detects pbcopy/pbpaste automatically.
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

      # --- Image Viewing ---
      imagemagick                # Image processing library required by image.nvim
      luajitPackages.magick      # Lua bindings for ImageMagick (used by image.nvim)
    ];
  };
}
