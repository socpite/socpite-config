

call plug#begin('~/.vim/plugged')

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'MysticalDevil/inlay-hints.nvim'
Plug 'github/copilot.vim'
Plug 'numToStr/Comment.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'wincent/command-t'

" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'm4xshen/autoclose.nvim'
Plug 'rebelot/kanagawa.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'tpope/vim-sensible'
Plug 'ziglang/zig.vim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'christoomey/vim-tmux-navigator'

call plug#end()

" don't show parse errors in a separate window
let g:zig_fmt_parse_errors = 0
" disable format-on-save from `ziglang/zig.vim`
let g:zig_fmt_autosave = 0

" enable format-on-save from nvim-lspconfig + ZLS
"
" Formatting with ZLS matches `zig fmt`.
" The Zig FAQ answers some questions about `zig fmt`:
" https://github.com/ziglang/zig/wiki/FAQ
autocmd BufWritePre *.zig,*.zon lua vim.lsp.buf.format()

:lua << EOF
require('wincent.commandt').setup()
  local lspconfig = require('lspconfig')
  require("inlay-hints").setup({
  	commands = { enable = true }, -- Enable InlayHints commands, include `InlayHintsToggle`, `InlayHintsEnable` and `InlayHintsDisable`
  	autocmd = { enable = true } -- Enable the inlay hints on `LspAttach` event
})
  require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
  require("autoclose").setup({
  	keys = {
      		["<Del>"] = { escape = true, close = true, pair = "''", disabled_filetypes = {} },
      		["<S-Del>"] = { escape = true, close = true, pair = '""', disabled_filetypes = {} },
   	},
  })
	-- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

        -- For `mini.snippets` users:
        -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
        -- insert({ body = args.body }) -- Insert at cursor
        -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
        -- require("cmp.config").set_onetime({ sources = {} })
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<S-Enter>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
      { name = 'nvim_lsp_signature_help' },
    }, {
      { name = 'buffer' },
    })
  })

  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]-- 

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['zls'].setup {
	capabilities = capabilities,
	settings = {
		zls = {
			inlay_hints_show_variable_type_hints = false,
			enable_argument_placeholders = false,
		}
	}
  }
  require('lspconfig')['html'].setup {}
  require('lspconfig')['pyright'].setup {}
  require('Comment').setup()
EOF

imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
imap <C-L> <Plug>(copilot-accept-word) 
let g:copilot_no_tab_map = v:true
map <C-/> gcc
map <C-A-o> :CommandT<Enter>
set number

colorscheme kanagawa
