-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.plugins = {
  {'rmagatti/auto-session',
 		config = function()
			require("auto-session").setup({
				log_level = "info",
				auto_session_enable_last_session = true,
				auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
				auto_session_enabled = true,
				auto_save_enabled = true,
				auto_restore_enabled = true,
				-- auto_session_suppress_dirs = { "~/", "~/Projects" },
				auto_session_suppress_dirs = nil,
				auto_session_use_git_branch = true,
			})
		end},
  -- {'jedrzejboczar/possession.nvim'},
  {'folke/tokyonight.nvim'},
  {'folke/trouble.nvim'},
  {'mfussenegger/nvim-jdtls'},
  {'MunifTanjim/prettier.nvim'},
  {'iamcco/markdown-preview.nvim'},
  -- {'vim/runtime/mswin.vim'},    -- type: behave mswin
  {'folke/zen-mode.nvim'},
  {'nvim-telescope/telescope-file-browser.nvim'},
  {'jay-babu/mason-nvim-dap.nvim'},
  {'theHamsta/nvim-dap-virtual-text'},
  {'declancm/maximize.nvim'},
}

vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

require("telescope").load_extension "file_browser"

require("mason").setup()
require("mason-nvim-dap").setup({
    automatic_installation = true
})

-- telescope
vim.api.nvim_set_keymap('n', "<C-p>", "<cmd>Telescope find_files<cr>", { noremap = true, silent = true, desc = "Find file" })
vim.api.nvim_set_keymap('n', "<leader>fg", "<cmd>Telescope live_grep<cr>", { noremap = true, silent = true, desc = "Grep" })
vim.api.nvim_set_keymap('n', "<C-e>", "<cmd>Telescope buffers<cr>", { noremap = true, silent = true, desc = "Find buffer"})
vim.api.nvim_set_keymap('n', "<leader>fm", "<cmd>Telescope marks<cr>", { noremap = true, silent = true, desc = "Find mark"})
vim.api.nvim_set_keymap('n', "<C-h>", "<cmd>Telescope lsp_references<cr>", { noremap = true, silent = true, desc = "Find references (LSP)"})
vim.api.nvim_set_keymap('n', "<C-0>", "<cmd>Telescope lsp_document_symbols<cr>", { noremap = true, silent = true, desc = "Find symbols (LSP)"})
vim.api.nvim_set_keymap('n', "<leader>fc", "<cmd>Telescope lsp_incoming_calls<cr>", { noremap = true, silent = true, desc = "Find incoming calls (LSP)"})
vim.api.nvim_set_keymap('n', "<leader>fo", "<cmd>Telescope lsp_outgoing_calls<cr>", { noremap = true, silent = true, desc = "Find outgoing calls (LSP)"})
vim.api.nvim_set_keymap('n', "<C-4>", "<cmd>Telescope lsp_implementations<cr>", { noremap = true, silent = true, desc = "Find implementations (LSP)"})
vim.api.nvim_set_keymap('n', "<C-2>", "<cmd>Telescope commands<cr>", { noremap = true, silent = true, desc = "Find commands"})
vim.api.nvim_set_keymap('n', "<C-q>", "<cmd>qa!<cr>", { noremap = true, silent = true, desc = "Find commands"})
vim.api.nvim_set_keymap('n', "<C-s>", "<cmd>w<cr>", { noremap = true, silent = true, desc = "Save File"})
vim.api.nvim_set_keymap('n', "<F3>", "<cmd>lua vim.lsp.buf.definition()<cr>", { noremap = true, silent = true, desc = "Goto Definition"})
vim.api.nvim_set_keymap('n', "<F5>", "<cmd>lua require'dap'.step_into()<cr>", { noremap = true, silent = true, desc = "Debug: Step Into"})
vim.api.nvim_set_keymap('n', "<F6>", "<cmd>lua require'dap'.step_over()<cr>", { noremap = true, silent = true, desc = "Debug: Step Over"})
vim.api.nvim_set_keymap('n', "<F8>", "<cmd>lua require'dap'.continue()<cr>", { noremap = true, silent = true, desc = "Debug: Continue"})
vim.api.nvim_set_keymap('n', "<S-F11>", "<cmd>term mvn exec:java -DmaiClass=%:t:r<cr>", { noremap = true, silent = true, desc = "Debug: Start MainClass"})
vim.api.nvim_set_keymap('n', "<F12>", "<cmd>term mvn test -Dtest=*%:t:r -Dmaven.surefire.debug<cr>", { noremap = true, silent = true, desc = "Debug: Start Maven Surefire"})
