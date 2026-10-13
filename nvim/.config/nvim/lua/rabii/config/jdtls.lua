local M = {}

function M.start()
	local jdtls = require("jdtls")

	local root = vim.fs.root(0, {
		"mvnw",
		"gradlew",
		"pom.xml",
		"build.gradle",
		"build.gradle.kts",
		".git",
	})
	if not root then
		return
	end

	local workspace = vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fs.basename(root)

	jdtls.start_or_attach({
		name = "jdtls",
		cmd = { vim.fn.stdpath("data") .. "/mason/bin/jdtls", "-data", workspace },
		root_dir = root,
		capabilities = require("blink.cmp").get_lsp_capabilities(),
		settings = {
			java = { signatureHelp = { enabled = true } },
		},
	})
end

return M
