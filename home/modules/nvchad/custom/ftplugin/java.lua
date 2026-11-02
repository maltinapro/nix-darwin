local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

if vim.fn.executable("jdtls") == 0 then
  vim.schedule(function()
    vim.notify("jdtls was not found in PATH. Rebuild nix-darwin to install jdt-language-server.", vim.log.levels.WARN, {
      title = "java lsp",
    })
  end)
  return
end

local root_dir = require("jdtls.setup").find_root({
  ".git",
  "mvnw",
  "gradlew",
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  "settings.gradle",
  "settings.gradle.kts",
})

if not root_dir or root_dir == "" then
  return
end

local project_name = vim.fn.fnamemodify(root_dir, ":t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_ok then
  capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
end

jdtls.start_or_attach({
  cmd = { "jdtls", "-data", workspace_dir },
  root_dir = root_dir,
  capabilities = capabilities,
  settings = {
    java = {
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      references = { includeDecompiledSources = true },
      configuration = { updateBuildConfiguration = "interactive" },
      completion = {
        importOrder = { "java", "javax", "com", "org" },
      },
    },
  },
  init_options = {
    bundles = {},
  },
})
