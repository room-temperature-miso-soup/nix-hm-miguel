{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      #terminal
      toggleterm-nvim

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
      blink-cmp
      
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
      mini-icons

      # Editor Features
      nvim-autopairs
      comment-nvim

      # Zig Support
      zig-vim
    ];

    extraPackages = with pkgs; [
      # Language servers
      gopls
      pyright
      zls
      
      # Tools
      ripgrep
      fd
      zig
      
      # Tree-sitter CLI
      tree-sitter

      # Compiler
      gcc

      #Python Tools
      poetry
      pyenv




      # Clipboard tool (choose one based on your environment)
      xclip # For X11
     # wl-clipboard # For Wayland
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

      -- mini.icons setup
      require('mini.icons').setup()

      -- LSP setup
      local lspconfig = require('lspconfig')
      
      -- Zig LSP setup
      lspconfig.zls.setup{
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        on_attach = function(client, bufnr)
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- LSP Keybindings
          local bufopts = { noremap=true, silent=true, buffer=bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        end,
      }

      -- Completion setup with nvim-cmp and blink.cmp
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local blink = require('blink.cmp')

      -- Initialize blink.cmp
      blink.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end,
          ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'blink' },
        },
      })

      -- Setup other plugins
      require('Comment').setup()
      require('nvim-autopairs').setup()
      require('gitsigns').setup()
      require('which-key').setup()     
      
      -- Terminal configuration
      require('toggleterm').setup({
        direction = 'float',
        float_opts = {
          border = 'curved',
          width = function()
            return math.floor(vim.o.columns * 0.8)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.8)
          end,
          winblend = 3,
        },
        shell = vim.o.shell,
        close_on_exit = true,
        insert_mappings = true,
        terminal_mappings = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
      })

      -- Terminal keymaps
      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

      -- Global terminal toggle mapping
      vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', 
        {noremap = true, silent = true})
    '';
  };
}
