-- https://medium.com/@chrisatmachine/lunarvim-as-a-java-ide-da65c4a77fb4

--require("lvim.lsp.manager").setup("jdtls")
--require('mason').setup()

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })

local status, jdtls = pcall(require, "jdtls")
if not status then
   print('jdtls not loaded, stopping')
 return
end

local home = os.getenv "HOME"
local workspace_path = home .. "/.local/share/lunarvim/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name

local os_config = "linux"
if vim.fn.has "mac" == 1 then
  os_config = "mac"
end

local capabilities = require("lvim.lsp").common_capabilities()
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

lvim.builtin.dap.active = true
local bundles = {}
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
vim.list_extend(
  bundles,
  vim.split(
    vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
    "\n"
  )
)

lvim.builtin.dap.active = true
local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. mason_path .. "packages/jdtls/lombok.jar",
    "-jar",
    vim.fn.glob(mason_path .. "packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    mason_path .. "packages/jdtls/config_" .. os_config,
    "-data",
    workspace_dir,
  },
  root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
  capabilities = capabilities,

  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name = "JavaSE-14",
            path = "~/jdk-14",
          },
          {
            name = "JavaSE-17",
            path = "/usr/lib/jvm/java-17-openjdk-amd64",
          },
        },
      },
      maven = {
        downloadSources = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all", -- literals, all, none
        },
      },
      format = {
        enabled = false,
      },
    },
    signatureHelp = { enabled = true },
    extendedClientCapabilities = extendedClientCapabilities,
  },
  init_options = {
    bundles = bundles,
  },
}

config["on_attach"] = function(client, bufnr)
  local _, _ = pcall(vim.lsp.codelens.refresh)
 require("jdtls").setup_dap({ hotcodereplace = "auto" })
 require("lvim.lsp").on_attach(client, bufnr)
  local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
  if status_ok then
    jdtls_dap.setup_dap_main_class_configs()
  end
end

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.java" },
  callback = function()
    local _, _ = pcall(vim.lsp.codelens.refresh)
  end,
})

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "google_java_format", filetypes = { "java" } },
}

-- require("dap").configurations.java = {
--     {
--       type = 'java';
--       request = 'attach';
--       name = "Debug (Attach) - Remote";
--       hostName = "127.0.0.1";
--       port = 8787;
--     },
--   }

  local continue = function()
    if vim.fn.filereadable('.vscode/launch.json') then
      require('dap.ext.vscode').load_launchjs()
    else
      require("dap").configurations.java = {
      {
        type = 'java';
        request = 'attach';
        name = "Debug (Attach) - Remote";
        hostName = "127.0.0.1";
        port = 8787;
      },
      {
        type = 'java';
        request = 'attach';
        name = "Attach - Surefire";
        hostName = "127.0.0.1";
        port = 5005;
      },
      {
        type = 'java';
        request = 'attach';
        name = "Attach - Maven";
        hostName = "127.0.0.1";
        port = 8000;
      },
    }
    end
    require('dap').continue()
  end

lvim.lsp.buffer_mappings.normal_mode["<leader>dc"] = { continue, "Start/Continue debug" }
require('dap.ext.vscode').load_launchjs('.vscode/launch.json', { java = {'java'} })


require("jdtls").start_or_attach(config)

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local opts = {
  mode = "n",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local vopts = {
  mode = "v",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local mappings = {
  J = {
    name = "Java",
    o = { "<Cmd>lua require'jdtls'.organize_imports()<CR>", "Organize Imports" },
    v = { "<Cmd>lua require('jdtls').extract_variable()<CR>", "Extract Variable" },
    c = { "<Cmd>lua require('jdtls').extract_constant()<CR>", "Extract Constant" },
    t = { "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", "Test Method" },
    T = { "<Cmd>lua require'jdtls'.test_class()<CR>", "Test Class" },
    u = { "<Cmd>JdtUpdateConfig<CR>", "Update Config" },
  },
}

local vmappings = {
  J = {
    name = "Java",
    v = { "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", "Extract Variable" },
    c = { "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", "Extract Constant" },
    m = { "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "Extract Method" },
  },
}

which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
--which_key.register(vmappings, vopts)

