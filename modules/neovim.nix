{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Theme
      tokyonight-nvim

      # Telescope and dependencies
      telescope-nvim
      plenary-nvim
      telescope-fzf-native-nvim

      # LSP Support
      nvim-lspconfig
      
      # Treesitter
      nvim-treesitter.withAllGrammars
    ];

    extraPackages = with pkgs; [
      # Language servers
      gopls
      pyright
      
      # Tools for telescope
      ripgrep
      fd
    ];

    extraLuaConfig = ''
      -- Basic settings
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.smartindent = true
      vim.opt.termguicolors = true  -- Enable true colors for theme
      
      -- Theme setup
      vim.cmd[[colorscheme tokyonight]]
      
      -- Set leader key
      vim.g.mapleader = " "
      
      -- Telescope setup and keymaps
      require('telescope').setup{}
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Live grep' })
      
      -- LSP Configuration
      local lspconfig = require('lspconfig')
      
      -- Go configuration
      lspconfig.gopls.setup{
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
      }
      
      -- Python configuration
      lspconfig.pyright.setup{
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true
            }
          }
        }
      }
      
      -- Global LSP keymaps
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Goto Definition' })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Goto References' })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
    '';
  };
}
