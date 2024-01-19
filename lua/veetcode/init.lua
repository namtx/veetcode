local M = {}

-- setup
function M.setup(opts)
	opts = opts or {}

	local path = opts["path"]
	if not path then
		vim.notify("Path is required", vim.log.levels.ERROR)
	end
	local lang = opts["lang"] or "cpp"

	-- mappings
	vim.keymap.set("n", "<leader>ln", function()
		local user_input = vim.fn.input("Enter problem URL: ")
		local problem_id = string.match(user_input, "/problems/([a-z-]+)")
		local file_name = path .. "/" .. lang .. "/" .. problem_id .. "." .. lang

		vim.cmd("lcd " .. path)
		vim.cmd("e " .. file_name)
	end, { silent = true, desc = "Solve a new Leetcode problem from URL" })
end

return M
