return {
  { 
    "junegunn/fzf.vim",
    dependencies = {
      'junegunn/fzf',
    },
  },
  { 
    "LunarVim/lunar.nvim",
    config = function()
      vim.cmd('colorscheme lunar')
    end
  },
  { 
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  { "nvim-treesitter/playground" },
  { "tpope/vim-fugitive" },
  {
    'williamboman/mason.nvim',
    lazy = false,
    opts = {},
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        sources = {
          {name = 'nvim_lsp'},
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
        }),
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
      })
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    init = function()
      -- Reserve a space in the gutter
      -- This will avoid an annoying layout shift in the screen
      vim.opt.signcolumn = 'yes'
    end,
    config = function()
      local lsp_defaults = require('lspconfig').util.default_config

      -- Add cmp_nvim_lsp capabilities settings to lspconfig
      -- This should be executed before you configure any language server
      lsp_defaults.capabilities = vim.tbl_deep_extend(
        'force',
        lsp_defaults.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      -- LspAttach is where you enable features that only work
      -- if there is a language server active in the file
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local opts = {buffer = event.buf}

          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
          vim.keymap.set('n', 'gs', "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", opts)
          vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
          vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
          vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
          vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
          -- vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
          vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
          vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
          vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        end,
      })

      require('mason-lspconfig').setup({
        ensure_installed = {
          "intelephense",
        },
        handlers = {
          -- this first function is the "default handler"
          -- it applies to every language server without a "custom handler"
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,
        }
      })
    end
  },
  { 'tpope/vim-surround', },
  { 'wellle/targets.vim', },
  { 'tpope/vim-repeat' },
  {
    'gelguy/wilder.nvim',
    lazy = true,
    event = "CmdlineEnter",
    config = function()
      local wilder = require("wilder")
      -- local icons = lvim.icons

      wilder.setup({ modes = { ":", "/", "?" } })
      wilder.set_option("use_python_remote_plugin", 0)
      wilder.set_option("pipeline", {
        wilder.branch(
          wilder.cmdline_pipeline({ use_python = 0, fuzzy = 1, fuzzy_filter = wilder.lua_fzy_filter() }),
          wilder.vim_search_pipeline(),
          {
            wilder.check(function(_, x)
              return x == ""
            end),
            wilder.history(),
            wilder.result({
              -- draw = {
              --   function(_, x)
              --     return icons.ui.Calendar .. " " .. x
              --   end,
              -- },
            }),
          }
        ),
      })

      local popupmenu_renderer = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
        border = "rounded",
        highlights = {
          default = "Pmenu",
          border = "PmenuBorder", -- highlight to use for the border
          accent = wilder.make_hl("WilderAccent", "CmpItemAbbr", "CmpItemAbbrMatch"),
        },
        empty_message = wilder.popupmenu_empty_message_with_spinner(),
        highlighter = wilder.lua_fzy_highlighter(),
        left = {
          " ",
          wilder.popupmenu_devicons(),
          wilder.popupmenu_buffer_flags({
            flags = " a + ",
            -- icons = { ["+"] = icons.ui.Pencil, a = icons.ui.Indicator, h = icons.ui.File },
          }),
        },
        right = {
          " ",
          wilder.popupmenu_scrollbar(),
        },
      }))
      local wildmenu_renderer = wilder.wildmenu_renderer({
        apply_incsearch_fix = true,
        highlighter = wilder.lua_fzy_highlighter(),
        separator = " | ",
        left = { " ", wilder.wildmenu_spinner(), " " },
        right = { " ", wilder.wildmenu_index() },
      })
      wilder.set_option(
        "renderer",
        wilder.renderer_mux({
          [":"] = popupmenu_renderer,
          ["/"] = wildmenu_renderer,
          substitute = wildmenu_renderer,
        })
      )
    end,
    dependencies = { "romgrk/fzy-lua-native" },
  },
  {
    'dstein64/nvim-scrollview',
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = function()
      -- local icons = lvim.icons

      require("scrollview").setup({
        scrollview_mode = "virtual",
        excluded_filetypes = { "NvimTree", "terminal", "nofile", "Outline" },
        winblend = 0,
        signs_on_startup = { "diagnostics", "folds", "marks", "search", "spell" },
        -- diagnostics_error_symbol = icons.diagnostics.Error,
        -- diagnostics_warn_symbol = icons.diagnostics.Warning,
        -- diagnostics_info_symbol = icons.diagnostics.Information,
        -- diagnostics_hint_symbol = icons.diagnostics.Hint,
      })
    end,
  },
  {
    'github/copilot.vim',
    event = 'BufEnter',
    config = function ()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.api.nvim_set_keymap("i", "<C-Y>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
      vim.api.nvim_set_keymap('i', '<C-J>', '<Plug>(copilot-next)', {})
      vim.api.nvim_set_keymap('i', '<C-K>', '<Plug>(copilot-previous)', {})
      vim.api.nvim_set_keymap('i', '<C-E>', '<Plug>(copilot-dismiss)', {})
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup()
    end,
    -- config = function()
    --   require('indent_blankline').setup({
    --   enabled = true,
    --   buftype_exclude = { "terminal", "nofile" },
    --   filetype_exclude = {
    --     "help",
    --     "startify",
    --     "dashboard",
    --     "lazy",
    --     "neogitstatus",
    --     "NvimTree",
    --     "Trouble",
    --     "text",
    --   },
    --   -- char = lvim.icons.ui.LineLeft,
    --   -- context_char = lvim.icons.ui.LineLeft,
    --   show_trailing_blankline_indent = false,
    --   show_first_indent_level = true,
    --   use_treesitter = true,
    --   show_current_context = true,
    -- })
    -- end,
    -- event = "User FileOpened",
    -- enabled = true,
    -- -- enabled = lvim.builtin.indentlines.active,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup {
        signs = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signs_staged = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signs_staged_enable = true,
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true
        },
        auto_attach = true,
        attach_to_untracked = false,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
          use_focus = true,
        },
        current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
      }
    end,
  },
}
