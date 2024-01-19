local M = {}
local cookie = require("veetcode.cookie")
local separator = require("plenary.path").path.sep
local api = require("veetcode.api")
local snippets = require("veetcode.snippets")

-- setup
function M.setup(opts)
	opts = opts or {}

	local path = opts["path"]
	if not path then
		vim.notify("Path is required", vim.log.levels.ERROR)
	end
	local lang = opts["lang"] or "cpp"

	local open_problem = function(problem_slug)
		local file_name = path .. separator .. lang .. separator .. problem_slug .. "." .. lang
		local file = io.open(file_name, "r")
		if file ~= nil then
			file:close()
			vim.cmd("lcd " .. path)
			vim.cmd("e " .. file_name)
			return
		end
		file = io.open(file_name, "w")
		local code = api.fetch_question_editor_data_by_slug(problem_slug)
		if not file then
			vim.notify("Failed to open file" .. file_name, vim.log.levels.ERROR)
			return
		end
		file:write("// " .. string.format("https://leetcode.com/problems/%s\n\n", problem_slug) .. code)
		file:close()

		vim.cmd("lcd " .. path)
		vim.cmd("e " .. file_name)
	end

	-- mappings
	vim.keymap.set("n", "<leader>ln", function()
		local user_input = vim.fn.input("Enter problem URL: ")

		local problem_slug = string.match(user_input, "/problems/([a-z-]+)")

		open_problem(problem_slug)
	end, { silent = true, desc = "Solve a new Leetcode problem from URL" })

	vim.keymap.set("n", "<leader>ls", function()
		cookie.cookie_setup()
	end, { silent = true, desc = "Setup leetcode" })

	vim.keymap.set("n", "<leader>lr", function()
		local random_problem_slug = api.random_problem()
		open_problem(random_problem_slug)
	end, { silent = true, desc = "Solve a random problem" })
end

return M
