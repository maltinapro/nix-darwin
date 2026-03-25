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
          event = "VeryLazy", -- load early enough so nvim-tree integration is active
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
              nvim_tree = {
                enabled = true,
                clear_in_insert_mode = true, -- hide preview when entering insert mode (intentional; differs from markdown which keeps images visible while editing)
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

      -- Render image files (png/jpg/gif/webp/avif) inline when opened in a buffer.
      -- image.nvim handles the actual rendering; this autocmd ensures it is
      -- triggered for image filetypes that are not markdown (e.g. opened from nvim-tree).
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
        callback = function()
          local ok, image = pcall(require, "image")
          if not ok then return end
          -- Clear any previously rendered image to avoid stale/duplicate renders
          -- when navigating between image files.
          image.clear()
          local buf = vim.api.nvim_get_current_buf()
          local filepath = vim.api.nvim_buf_get_name(buf)
          if filepath ~= "" then
            image.from_file(filepath, { window = vim.api.nvim_get_current_win() }):render()
          end
        end,
      })
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
