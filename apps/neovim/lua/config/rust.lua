
local on_attach = require("config.lsp-keybindings").on_attach;

local function setup(use)
	use({
		"saecki/crates.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("crates").setup()
		end,
	})
	use({
		"simrat39/rust-tools.nvim",
		config = function() end,
	})

	vim.g.rustfmt_autosave = 1

	require("rust-tools").setup({
		tools = { autoSetHints = true, inlay_hints = { only_current_line = false } },
		server = { on_attach = on_attach },
	})
end

return {
	setup = setup
}
