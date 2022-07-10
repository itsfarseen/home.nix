-- xvim:foldmethod=marker:

-- Auto reload {{{


local cfg = vim.fn.stdpath("config")
Flush = function()
	local s = vim.api.nvim_buf_get_name(0)
	if string.match(s, "^" .. cfg .. "*") == nil then
		return
	end
	s = string.sub(s, 6 + string.len(cfg), -5)
	local val = string.gsub(s, "%/", ".")
	package.loaded[val] = nil
end
vim.cmd([[
  augroup reload_init_lua
  autocmd!
  autocmd BufWrite *.lua,*vim call v:lua.Flush()
  augroup end
]])

-- }}}

-- Packer {{{

-- Bootstrap Part 1 {{{
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	packer_bootstrap = vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end
-- }}}

-- Auto compile {{{
vim.cmd([[
  augroup packer_user_config
  autocmd!
  autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
]])
-- }}}

local lualine = require("config.lualine")
local rust = require("config.rust")
local colorscheme = require("config.colorscheme")
local on_attach = require("config.lsp-keybindings").on_attach;

require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	lualine.setup(use)
	rust.setup(use)

	-- File types
	use({
		"nathom/filetype.nvim",
		config = function()
			vim.g.did_load_filetypes = 1
		end,
	})
	use({
		"sheerun/vim-polyglot",
	})
	use("neovim/nvim-lspconfig")
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	-- Completion {{{
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("saadparwaiz1/cmp_luasnip") -- Snippets source for nvim-cmp
	use("L3MON4D3/LuaSnip") -- Snippets plugin
	-- }}}

	colorscheme.setup(use)

	-- Language Specific {{{
	-- Lua formatter
	use({ "ckipp01/stylua-nvim" })
	-- Flutter
	use({ "akinsho/flutter-tools.nvim", requires = "nvim-lua/plenary.nvim" })
	-- }}}

	-- Handy extensions --

	-- Buf Delete {{{
	use({
		"famiu/bufdelete.nvim",
		config = function()
			vim.cmd([[
					nnoremap <leader>x :Bdelete<CR>
				]])
		end,
	})
	-- }}}

	-- Git Signs {{{
	use({
		"lewis6991/gitsigns.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("gitsigns").setup({
				keymaps = {
					-- Default keymap options
					noremap = true,

					["n ]h"] = { expr = true, "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'" },
					["n [h"] = { expr = true, "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'" },

					["n <leader>gs"] = "<cmd>Gitsigns stage_hunk<CR>",
					["v <leader>gs"] = ":Gitsigns stage_hunk<CR>",
					["n <leader>gu"] = "<cmd>Gitsigns undo_stage_hunk<CR>",
					["n <leader>gr"] = "<cmd>Gitsigns reset_hunk<CR>",
					["v <leader>gr"] = ":Gitsigns reset_hunk<CR>",
					["n <leader>gR"] = "<cmd>Gitsigns reset_buffer<CR>",
					["n <leader>gp"] = "<cmd>Gitsigns preview_hunk<CR>",
					["n <leader>gb"] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
					["n <leader>gS"] = "<cmd>Gitsigns stage_buffer<CR>",
					["n <leader>gU"] = "<cmd>Gitsigns reset_buffer_index<CR>",

					-- Text objects
					["o ih"] = ":<C-U>Gitsigns select_hunk<CR>",
					["x ih"] = ":<C-U>Gitsigns select_hunk<CR>",
				},
			})
		end,
	})
	-- }}}

	-- Surround {{{
	use({
		"ur4ltz/surround.nvim",
		config = function()
			require("surround").setup({ mappings_style = "sandwich", space_on_closing_char = true })
		end,
	})
	-- }}}

	-- Preview registers on pressing <double-quotes> {{{
	use({
		"tversteeg/registers.nvim",
		config = function()
			vim.g.registers_normal_mode = 0
			vim.g.registers_visual_mode = 0
		end,
	})
	-- }}}

	-- Telescope {{{
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = function()
			vim.cmd([[
        nnoremap <c-p> <cmd>Telescope find_files<cr>
        nnoremap <leader>ff <cmd>Telescope find_files<cr>
        nnoremap <leader>fgg <cmd>Telescope live_grep<cr>
        nnoremap <leader>fb <cmd>Telescope buffers<cr>
        nnoremap <leader>fh <cmd>Telescope help_tags<cr>
        nnoremap <leader>fm <cmd>Telescope marks<cr>
        nnoremap <leader>fr <cmd>Telescope lsp_references<cr>
        nnoremap <leader>fs <cmd>Telescope lsp_document_symbols<cr>
        nnoremap <leader>fS <cmd>Telescope lsp_workspace_symbols<cr>
        nnoremap <leader>fa <cmd>Telescope lsp_code_actions<cr>
        nnoremap <leader>fe <cmd>Telescope diagnostics<cr>
        nnoremap <leader>fd <cmd>Telescope lsp_definitions<cr>
        nnoremap <leader>fD <cmd>Telescope lsp_type_definitions<cr>
        nnoremap <leader>fi <cmd>Telescope lsp_implementations<cr>
        nnoremap <leader>fgs <cmd>Telescope git_status<cr>
				nnoremap <leader>ft <cmd>Telescope treesitter<cr>
			]])
		end,
	})
	-- }}}

	-- File tree {{{
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icon
		},
		config = function()
			local tree_cb = require("nvim-tree.config").nvim_tree_callback
			require("nvim-tree").setup({
				filters = {
					custom = { ".git" },
				},
				view = {
					mappings = {
						list = {
							{ key = { "l" }, cb = tree_cb("edit") },
							{ key = { "h" }, cb = tree_cb("close_node") },
						},
					},
				},
			})
			-- vim.cmd('NvimTreeOpen')
			-- vim.cmd('call feedkeys("\\<c-w>\\<c-p>")')
			vim.cmd([[
        nnoremap <leader>e <cmd>NvimTreeOpen<cr><cmd>NvimTreeFocus<cr>
        nnoremap <leader>E <cmd>NvimTreeClose<cr>
        nnoremap <leader>o <c-w><c-p>
        ]])
		end,
	})
	-- }}}

	-- Commenting {{{
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	-- }}}

	-- Find/Replace variants of a word {{{
	use("tpope/vim-abolish")
	-- }}}

	-- Iron REPL {{{
	use("axvr/zepl.vim")
	-- }}}

	-- Bootstrap Part 2 {{{
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
	-- }}}
end)

-- }}}

-- Editor options {{{
vim.o.number = true
vim.g.mapleader = " "
vim.cmd("filetype indent on")
-- }}}

vim.cmd([[set mouse=a]])

-- Show documentation (K) {{{
vim.api.nvim_set_keymap("n", "K", ":lua ShowDocumentation()<cr>", { noremap = true, silent = true })
function ShowDocumentation()
	local filetype = vim.bo.filetype
	if vim.tbl_contains({ "vim", "help" }, filetype) then
		vim.cmd("h " .. vim.fn.expand("<cword>"))
	elseif vim.tbl_contains({ "man" }, filetype) then
		vim.cmd("Man " .. vim.fn.expand("<cword>"))
	elseif vim.fn.expand("%:t") == "Cargo.toml" then
		require("crates").show_popup()
	else
		vim.lsp.buf.hover()
	end
end

-- }}}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = true,
	underline = true,
	signs = true,
})
vim.cmd([[
  set updatetime=300
	augroup cursor_hover
	autocmd!
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, {border = "single", focusable = false})
  autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
	augroup end
]])

-- Key binds

vim.cmd([[
	inoremap jk <ESC>

  nnoremap <leader>l  :wincmd l <CR>
  nnoremap <leader>h  :wincmd h <CR>
  nnoremap <leader>k  :wincmd k <CR>
  nnoremap <leader>j  :wincmd j <CR>

  nnoremap <leader>wl  :rightbelow vsplit <CR>
  nnoremap <leader>wh  :leftabove vsplit <CR>
  nnoremap <leader>wk  :leftabove split <CR>
  nnoremap <leader>wj  :rightbelow split <CR>

  nnoremap <leader>,  :bprev <CR>
  nnoremap <leader>.  :bnext <CR>

  nnoremap <leader>;  :tabprev <CR>
  nnoremap <leader>'  :tabnext <CR>

  nnoremap <leader>:  :tabnew <CR>
  nnoremap <leader>"  :tabclose <CR>

  nnoremap <c-s> :w<CR>
  nnoremap <leader>c :close<CR>

  nnoremap <leader><leader> :noh<CR>:pclose<CR>

	tnoremap <Esc> <C-\><C-N>
]])

vim.o.completeopt = "menu,menuone,noselect"
vim.opt.signcolumn = "yes"

local nvim_lsp = require("lspconfig")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local border = {
	{ "🭽", "FloatBorder" },
	{ "▔", "FloatBorder" },
	{ "🭾", "FloatBorder" },
	{ "▕", "FloatBorder" },
	{ "🭿", "FloatBorder" },
	{ "▁", "FloatBorder" },
	{ "🭼", "FloatBorder" },
	{ "▏", "FloatBorder" },
}

-- LSP settings (for overriding per client)
local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}


-- To highlight codefences returned from denols
vim.g.markdown_fenced_languages = {
	"ts=typescript"
}

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "jedi_language_server", "denols", "tsserver", "jsonls", "sumneko_lua", "hls", "svelte", "gopls" , "dhall_lsp_server"}
local commonSetup = {
	on_attach = on_attach,
	capabilities = capabilities,
	handlers = handlers,
	flags = {
		debounce_text_changes = 150,
	},
}
local specificSetup = {
	sumneko_lua = {
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					-- Setup your lua path
					-- path = runtime_path,
					path = vim.split(package.path, ";"),
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim", "awesome", "client", "root", "screen" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					-- library = vim.api.nvim_get_runtime_file("", true),
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
						["/usr/share/awesome/lib"] = true,
					},
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
				commands = {
					-- Format = {
					-- 	require("stylua-nvim").format_file(),
					-- },
				},
			},
		},
	},
	hls = {
		cmd = { "haskell-language-server", "--lsp" },
		settings = {
			haskell = { formattingProvider = "fourmolu" },
		},
	},
	jsonls = {
		cmd = { "vscode-json-languageserver", "--stdio" },
	},
}
for _, lsp in ipairs(servers) do
	local setupTable
	if specificSetup[lsp] == nil then
		setupTable = commonSetup
	else
		setupTable = {}
		for k, v in pairs(commonSetup) do
			setupTable[k] = v
		end
		for k, v in pairs(specificSetup[lsp]) do
			setupTable[k] = v
		end
	end
	nvim_lsp[lsp].setup(setupTable)
end

vim.cmd([[
	augroup FormatAutogroup
	autocmd!
	autocmd BufWritePost * lua vim.lsp.buf.format()
	augroup END
]])

local luasnip = require("luasnip")

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		-- ["<Tab>"] = function(fallback)
		-- 	if cmp.visible() then
		-- 		cmp.select_next_item()
		-- 	elseif luasnip.expand_or_jumpable() then
		-- 		luasnip.expand_or_jump()
		-- 	else
		-- 		fallback()
		-- 	end
		-- end,
		-- ["<S-Tab>"] = function(fallback)
		-- 	if cmp.visible() then
		-- 		cmp.select_prev_item()
		-- 	elseif luasnip.jumpable(-1) then
		-- 		luasnip.jump(-1)
		-- 	else
		-- 		fallback()
		-- 	end
		-- end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "crates" },
	},
})

require("nvim-treesitter.configs").setup({
	-- ensure_installed = "all",

	-- Install languages synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- List of parsers to ignore installing
	ignore_install = {},

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- list of language that will be disabled
		disable = {},

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
})
