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
      fidget-nvim
      nvim-notify
      coc-nvim
      
      # Treesitter
      nvim-treesitter.withAllGrammars

      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      friendly-snippets

      # UI Improvements
      lualine-nvim
      gitsigns-nvim
      which-key-nvim
      nvim-web-devicons

      # Editor Features
      nvim-autopairs
      comment-nvim
    ];

    extraPackages = with pkgs; [
      # Language servers
      gopls
      pyright
      
      # Tools
      ripgrep
      fd
      
      # Node for coc
      nodejs

      # Tree-sitter CLI
      tree-sitter

      # Compiler
      gcc

      # Clipboard tool (choose one based on your environment)
      xclip # For X11
      wl-clipboard # For Wayland
    ];

    extraLuaConfig = ''
      -- Basic settings
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.smartindent = true
      vim.opt.termguicolors = true
      vim.opt.updatetime = 50
      vim.opt.signcolumn = "yes"
      
      -- Theme setup
      vim.cmd[[colorscheme tokyonight]]
      
      -- Set leader key
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
      
      -- Better window navigation
      vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
      vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
      vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
      vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

      -- Better indenting
      vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
      vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

      -- Move selected lines up/down
      vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
      vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

      -- Keep cursor centered when scrolling
      vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
      vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
      
      -- Telescope setup and keymaps
      require('telescope').setup{}
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find help' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Find word under cursor' })
      
      -- LSP Configuration
      require("fidget").setup{} -- LSP progress
      vim.notify = require("notify") -- Better notifications

      -- COC Configuration
      vim.g.coc_global_extensions = {
        'coc-pyright',
        'coc-go',
        'coc-snippets'
      }

      -- COC Keymaps
      vim.keymap.set('n', '[g', '<Plug>(coc-diagnostic-prev)', { silent = true })
      vim.keymap.set('n', ']g', '<Plug>(coc-diagnostic-next)', { silent = true })
      vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', { silent = true })
      vim.keymap.set('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
      vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
      vim.keymap.set('n', 'gr', '<Plug>(coc-references)', { silent = true })

      -- Use K to show documentation in preview window
      function _G.show_docs()
        local cw = vim.fn.expand('<cword>')
        if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
          vim.api.nvim_command('h ' .. cw)
        elseif vim.api.nvim_eval('coc#rpc#ready()') then
          vim.fn.CocActionAsync('doHover')
        else
          vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
        end
      end
      vim.keymap.set('n', 'K', '<CMD>lua _G.show_docs()<CR>', { silent = true })

      -- Completion setup with COC
      vim.keymap.set('i', '<TAB>', 'pumvisible() ? coc#_select_confirm() : "<TAB>"', { expr = true })
      vim.keymap.set('i', '<cr>', 'pumvisible() ? coc#_select_confirm() : "<cr>"', { expr = true })

      -- Setup other plugins
      require('Comment').setup({
        toggler = {
          line = '<leader>cc', -- Toggle line comment
          block = '<leader>cb', -- Toggle block comment
        },
        opleader = {
          line = '<leader>c', -- Line comment operator
          block = '<leader>b', -- Block comment operator
        },
      })
      require('nvim-autopairs').setup()
      require('gitsigns').setup()
      require('which-key').setup()     
     
    '';
  };
}
