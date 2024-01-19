local M = {}
local separator = require("plenary.path").path.sep

local cookie_file_path = vim.loop.os_homedir() .. separator .. ".veetcode"

function M.extract_leetcode_cookie()
	local cookie_string = M.read_cookie_file()
	local csrf_token = string.match(cookie_string, "csrftoken=([^;]+)")
	if not csrf_token then
		error("Invalid cookie!")
	end
	local leetcode_session = string.match(cookie_string, "LEETCODE_SESSION=([^;]+)")
	if not leetcode_session then
		error("Invalid cookie!")
	end
	return { leetcode_session, csrf_token }
end

function M.read_cookie_file()
	local file = io.open(cookie_file_path, "r")
	if not file then
		error("Cookie file does NOT exist!")
	end
	local content = file:read("*a")

	file:close()
	return content
end

function M.write_cookie_file(cookie_string)
	local file = io.open(cookie_file_path, "w")
	if not file then
		error("Cookie file does NOT exist!")
	end
	file:write(cookie_string)
	file:close()
end

function M.cookie_setup()
	local user_input = vim.fn.input("Enter leetcode cookie: ")

	M.write_cookie_file(user_input)
end

return M
