vim.filetype.add({
	extension = { pks = "sql", pkb = "sql", pls = "sql", plsql = "sql" },
})
-- only matters if treesitter highlighting is off for sql
vim.g.sql_type_default = "plsql"
