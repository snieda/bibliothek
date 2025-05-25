-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.plugins = {
	{'rmagatti/auto-session',               -- reload previously opened files
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
	-- {'jedrzejboczar/possession.nvim'},   -- similar to auto-session 
	{'folke/tokyonight.nvim'},              -- dark theme
	{'folke/trouble.nvim'},
	{'mfussenegger/nvim-jdtls'},            -- special initialized jdtls
	{'mfussenegger/nvim-dap-python'},       -- debug python
	{'MunifTanjim/prettier.nvim'},          -- common formatter
	{'iamcco/markdown-preview.nvim'},       -- markdown previewer
	-- {'vim/runtime/mswin.vim'},           -- type: behave mswin
	{'folke/zen-mode.nvim'},                -- maximize windows/views ???
	{'nvim-telescope/telescope-file-browser.nvim'}, -- filebrowser that should be better than lunars standard
	{'jay-babu/mason-nvim-dap.nvim'},       -- mason debug port extension
	{'theHamsta/nvim-dap-virtual-text'},    -- shows inline variable values
	{'declancm/maximize.nvim'},             -- maximize windows
	{'skywind3000/asyncrun.vim'},           -- async run nvim processes
	{'wfxr/minimap.vim'},                   -- minimap
	{'wellle/context.vim'},                 -- shows a line on top describing the current tree item
	{'SmiteshP/nvim-navic'},                -- simple statusline/winbar component that uses LSP to show your current code context
	{'xiyaowong/transparent.nvim'},         -- lunarvim transparency (:TransparentEnable)
  --  {'echasnovski/mini.nvim', version = '*' }, -- another minimap
	  {
		  "benlubas/molten-nvim",           -- fork of magma, interactive code with jupyter
		  version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
		  dependencies = { "3rd/image.nvim" },
		  build = ":UpdateRemotePlugins",
		  init = function()
			  -- these are examples, not defaults. Please see the readme
			  vim.g.molten_image_provider = "image.nvim"
			  vim.g.molten_output_win_max_height = 20
		  end,
	  },
	 --  {
		-- 'edluffy/hologram.nvim',         -- enable view of images
		-- config = function()
		--   require("hologram").setup()
		-- end,
		-- rocks = { "magick" },
		-- opts = {},
	 --  },
	  -- {
		 --  -- see the image.nvim readme for more information about configuring this plugin
		 --  "3rd/image.nvim",               -- enable view of images
		 --  opts = {
			--   backend = "kitty", -- whatever backend you would like to use
			--   max_width = 100,
			--   max_height = 12,
			--   max_height_window_percentage = math.huge,
			--   max_width_window_percentage = math.huge,
			--   window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
			--   window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
		 --  },
	  -- }
  }
  
  vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  require("nvim-dap-virtual-text").setup()
  require("telescope").load_extension "file_browser"
  -- require('mini.map').setup()
  -- require("mason").setup()
  -- require("mason-nvim-dap").setup({
  --     automatic_installation = true
  -- })
  
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
  vim.api.nvim_set_keymap('n', "<C-n>", "<cmd>new<cr>", { noremap = true, silent = true, desc = "New Buffer"})
  vim.api.nvim_set_keymap('n', "<C-x>", "<cmd>bd<cr>", { noremap = true, silent = true, desc = "Close Buffer"})
  vim.api.nvim_set_keymap('n', "<C-m>", "<cmd>tabedit %<cr>", { noremap = true, silent = true, desc = "Maximize Current Window"})
  vim.api.nvim_set_keymap('n', "<S-m>", "<cmd>tabclose<cr>", { noremap = true, silent = true, desc = "Restore Windows after Maximize"})
  vim.api.nvim_set_keymap('n', "<Tab>", "<cmd>BufferLineCycleNext<cr>", { noremap = true, silent = true, desc = "Goto Next File Buffer"})
  vim.api.nvim_set_keymap('n', "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { noremap = true, silent = true, desc = "Goto Next File Buffer"})
  vim.api.nvim_set_keymap('n', "<F3>", "<cmd>lua vim.lsp.buf.definition()<cr>", { noremap = true, silent = true, desc = "Goto Definition"})
  vim.api.nvim_set_keymap('n', "<F5>", "<cmd>lua require'dap'.step_into()<cr>", { noremap = true, silent = true, desc = "Debug: Step Into"})
  vim.api.nvim_set_keymap('n', "<F6>", "<cmd>lua require'dap'.step_over()<cr>", { noremap = true, silent = true, desc = "Debug: Step Over"})
  vim.api.nvim_set_keymap('n', "<F8>", "<cmd>lua require'dap'.continue()<cr>", { noremap = true, silent = true, desc = "Debug: Continue"})
  vim.api.nvim_set_keymap('n', "<F9>", "<cmd>AsyncRun -mode=term -save=1 python %<cr>", { noremap = true, silent = true, desc = "Run python for current file"})
  vim.api.nvim_set_keymap('n', "<S-F11>", "<cmd>term mvn exec:java -DmainClass=%:t:r<cr>", { noremap = true, silent = true, desc = "Debug: Start MainClass"})
  vim.api.nvim_set_keymap('n', "<F12>", "<cmd>term mvn test -Dtest=*%:t:r -Dmaven.surefire.debug<cr>", { noremap = true, silent = true, desc = "Debug: Start Maven Surefire"})
  
  -- DEBUG-ERROR: lunarvim jdtls -32601: No delegateCommandHandler for vscode.java.startDebugSession
  -- following vscode ts example for registering something:
					  -- commands.registerCommand(Commands.APPLY_WORKSPACE_EDIT, (obj) => {
					  -- 	let edit = languageClient.protocol2CodeConverter.asWorkspaceEdit(obj);
					  -- 	if (edit) {
					  -- 		workspace.applyEdit(edit);
					  -- 	}
					  -- });require("lvim.lsp.manager").setup("jdtls")
  
  -- lvim.plugins = {
  --   "mfussenegger/nvim-jdtls",
  -- }
  
  -- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })
  
  -- local dap = require('dap')
  -- dap.adapters.java = function(callback, config)
  --     vim.lsp.buf.execute_command({command = 'vscode.java.startDebugSession', function(err0, port)
  --       assert(not err0, vim.inspect(err0))
  --       callback({ type = 'server'; host = '127.0.0.1'; port = port; })
  --     end})
  --   end
  
  --   local continue = function()
  --     if vim.fn.filereadable('.vscode/launch.json') then
  --       require('dap.ext.vscode').load_launchjs()
  --     end
  --     require('dap').continue()
  --   end
  --   lvim.lsp.buffer_mappings.normal_mode["<leader>dc"] = { continue, "Start/Continue debug" }
  -- require('dap.ext.vscode').load_launchjs('.vscode/launch.json', { java = {'java'} })
  -- local adapter = {
  --     type = 'server';
  --     host = '127.0.0.1';
  --     port = 8080;
  --     enrich_config = function(config, on_config)
  --       local final_config = vim.deepcopy(config)
  --       final_config.extra_property = 'This got injected by the adapter'
  --       on_config(final_config)
  --     end;
  --   }
  -- -- vim.opt_local.shiftwidth = 2
  -- vim.opt_local.tabstop = 2
  -- vim.opt_local.cmdheight = 2 -- more space in the neovim command line for displaying messages
  
  -- local capabilities = require("lvim.lsp").common_capabilities()
  
  -- local status, jdtls = pcall(require, "jdtls")
  -- if not status then
  --   return
  -- end
  
  -- -- Determine OS
  -- local home = os.getenv("HOME")
  -- if vim.fn.has("mac") == 1 then
  --   WORKSPACE_PATH = home .. "/workspace/"
  --   CONFIG = "mac"
  -- elseif vim.fn.has("unix") == 1 then
  --   WORKSPACE_PATH = home .. "/workspace/"
  --   CONFIG = "linux"
  -- else
  --   print("Unsupported system")
  -- end
  
  -- -- Find root of project
  -- local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
  -- local root_dir = require("jdtls.setup").find_root(root_markers)
  -- if root_dir == "" then
  --   return
  -- end
  
  -- local extendedClientCapabilities = jdtls.extendedClientCapabilities
  -- extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
  
  -- local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  
  -- local workspace_dir = WORKSPACE_PATH .. project_name
  
  -- local bundles = {}
  -- local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
  -- vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
  -- vim.list_extend(
  --   bundles,
  --   vim.split(
  --     vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
  --     "\n"
  --   )
  -- )
  
  -- -- vscode-java-test bundles
  -- vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "/packages/vscode-java-test/server/*.jar"), "\n"))
  
  -- -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
  -- local config = {
  --   -- The command that starts the language server
  --   -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  --   cmd = {
  
  --     -- 💀
  --     "java", -- or '/path/to/java11_or_newer/bin/java'
  --     -- depends on if `java` is in your $PATH env variable and if it points to the right version.
  
  --     "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  --     "-Dosgi.bundles.defaultStartLevel=4",
  --     "-Declipse.product=org.eclipse.jdt.ls.core.product",
  --     "-Dlog.protocol=true",
  --     "-Dlog.level=ALL",
  --     "-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
  --     "-Xms1g",
  --     "--add-modules=ALL-SYSTEM",
  --     "--add-opens",
  --     "java.base/java.util=ALL-UNNAMED",
  --     "--add-opens",
  --     "java.base/java.lang=ALL-UNNAMED",
  
  --     -- 💀
  --     "-jar",
  --     vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
  --     -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
  --     -- Must point to the                                                     Change this to
  --     -- eclipse.jdt.ls installation                                           the actual version
  
  --     -- 💀
  --     "-configuration",
  --     home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. CONFIG,
  --     -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
  --     -- Must point to the                      Change to one of `linux`, `win` or `mac`
  --     -- eclipse.jdt.ls installation            Depending on your system.
  
  --     -- 💀
  --     -- See `data directory configuration` section in the README
  --     "-data",
  --     workspace_dir,
  --   },
  
  --   -- on_attach = require("lvim.lsp").on_attach,
  --   capabilities = capabilities,
  
  --   -- 💀
  --   -- This is the default if not provided, you can remove it. Or adjust as needed.
  --   -- One dedicated LSP server & client will be started per unique root_dir
  --   root_dir = root_dir,
  
  --   -- Here you can configure eclipse.jdt.ls specific settings
  --   -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  --   -- or https://github.com/redhat-developer/vscode-java#supported-vs-code-settings
  --   -- for a list of options
  --   settings = {
  --     java = {
  --       -- jdt = {
  --       --   ls = {
  --       --     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
  --       --   }
  --       -- },
  --       eclipse = {
  --         downloadSources = true,
  --       },
  --       configuration = {
  --         updateBuildConfiguration = "interactive",
  --         runtimes = {
  --           {
  --             name = "JavaSE-11",
  --             path = "~/.sdkman/candidates/java/11.0.2-open",
  --           },
  --           {
  --             name = "JavaSE-18",
  --             path = "~/.sdkman/candidates/java/18.0.1.1-open",
  --           },
  --         },
  --       },
  --       maven = {
  --         downloadSources = true,
  --       },
  --       implementationsCodeLens = {
  --         enabled = true,
  --       },
  --       referencesCodeLens = {
  --         enabled = true,
  --       },
  --       references = {
  --         includeDecompiledSources = true,
  --       },
  --       inlayHints = {
  --         parameterNames = {
  --           enabled = "all", -- literals, all, none
  --         },
  --       },
  --       format = {
  --         enabled = false,
  --         -- settings = {
  --         --   profile = "asdf"
  --         -- }
  --       },
  --     },
  --     signatureHelp = { enabled = true },
  --     completion = {
  --       favoriteStaticMembers = {
  --         "org.hamcrest.MatcherAssert.assertThat",
  --         "org.hamcrest.Matchers.*",
  --         "org.hamcrest.CoreMatchers.*",
  --         "org.junit.jupiter.api.Assertions.*",
  --         "java.util.Objects.requireNonNull",
  --         "java.util.Objects.requireNonNullElse",
  --         "org.mockito.Mockito.*",
  --       },
  --     },
  --     contentProvider = { preferred = "fernflower" },
  --     extendedClientCapabilities = extendedClientCapabilities,
  --     sources = {
  --       organizeImports = {
  --         starThreshold = 9999,
  --         staticStarThreshold = 9999,
  --       },
  --     },
  --     codeGeneration = {
  --       toString = {
  --         template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
  --       },
  --       useBlocks = true,
  --     },
  --   },
  
  --   flags = {
  --     allow_incremental_sync = true,
  --   },
  
  --   -- Language server `initializationOptions`
  --   -- You need to extend the `bundles` with paths to jar files
  --   -- if you want to use additional eclipse.jdt.ls plugins.
  --   --
  --   -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --   --
  --   -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  --   init_options = {
  --     -- bundles = {},
  --     bundles = bundles,
  --   },
  -- }
  
  -- config["on_attach"] = function(client, bufnr)
  --   local _, _ = pcall(vim.lsp.codelens.refresh)
  --   require("jdtls.dap").setup_dap_main_class_configs()
  --   require("jdtls").setup_dap({ hotcodereplace = "auto" })
  --   require("lvim.lsp").on_attach(client, bufnr)
  -- end
  
  -- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  --   pattern = { "*.java" },
  --   callback = function()
  --     local _, _ = pcall(vim.lsp.codelens.refresh)
  --   end,
  -- })
  
  -- -- This starts a new client & server,
  -- -- or attaches to an existing client & server depending on the `root_dir`.
  -- jdtls.start_or_attach(config)
  
  -- vim.cmd(
  --   [[command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)]]
  -- )
  -- vim.cmd([[command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()]])
  -- -- vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
  -- -- -- vim.cmd "command! -buffer JdtJol lua require('jdtls').jol()"
  -- -- vim.cmd "command! -buffer JdtBytecode lua require('jdtls').javap()"
  -- -- -- vim.cmd "command! -buffer JdtJshell lua require('jdtls').jshell()"
  
  -- local status_ok, which_key = pcall(require, "which-key")
  -- if not status_ok then
  --   return
  -- end
  
  -- local opts = {
  --   mode = "n", -- NORMAL mode
  --   prefix = "<leader>",
  --   buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  --   silent = true, -- use `silent` when creating keymaps
  --   noremap = true, -- use `noremap` when creating keymaps
  --   nowait = true, -- use `nowait` when creating keymaps
  -- }
  
  -- local vopts = {
  --   mode = "v", -- VISUAL mode
  --   prefix = "<leader>",
  --   buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  --   silent = true, -- use `silent` when creating keymaps
  --   noremap = true, -- use `noremap` when creating keymaps
  --   nowait = true, -- use `nowait` when creating keymaps
  -- }
  
  -- local mappings = {
  --   C = {
  --     name = "Java",
  --     o = { "<Cmd>lua require'jdtls'.organize_imports()<CR>", "Organize Imports" },
  --     v = { "<Cmd>lua require('jdtls').extract_variable()<CR>", "Extract Variable" },
  --     c = { "<Cmd>lua require('jdtls').extract_constant()<CR>", "Extract Constant" },
  --     t = { "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", "Test Method" },
  --     T = { "<Cmd>lua require'jdtls'.test_class()<CR>", "Test Class" },
  --     u = { "<Cmd>JdtUpdateConfig<CR>", "Update Config" },
  --   },
  -- }
  
  -- local vmappings = {
  --   C = {
  --     name = "Java",
  --     v = { "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", "Extract Variable" },
  --     c = { "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", "Extract Constant" },
  --     m = { "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "Extract Method" },
  --   },
  -- }
  
  -- which_key.register(mappings, opts)
  -- which_key.register(vmappings, vopts)
  -- which_key.register(vmappings, vopts)
  
  
