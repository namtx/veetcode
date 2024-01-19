local M = {}
local curl = require("plenary.curl")
local cookie = require("veetcode.cookie")

function M.daily_problem_slug()
	local res = M.request({
		operationName = "questionOfToday",
		query = [[
        query questionOfToday {
          activeDailyCodingChallengeQuestion {
            date
            userStatus
            link
            question {
              acRate
              difficulty
              freqBar
              frontendQuestionId: questionFrontendId
              isFavor
              paidOnly: isPaidOnly
              status
              title
              titleSlug
              hasVideoSolution
              hasSolution
              topicTags {
                name
                id
                slug
              }
            }
          }
        }
      ]],
	})

	local data = vim.json.decode(res.body)

	return data.data.activeDailyCodingChallengeQuestion.question.titleSlug
end

function M.random_problem()
	local res = M.request({
		operationName = "randomQuestion",
		query = [[
      query randomQuestion($categorySlug: String, $filters: QuestionListFilterInput) {
        randomQuestion(categorySlug: $categorySlug, filters: $filters) {
          titleSlug
        }
      }
    ]],
		variables = {
			categorySlug = "all-code-essentials",
			filters = {
				difficulty = "MEDIUM",
			},
		},
	})

	local data = vim.json.decode(res.body)

	return data.data.randomQuestion.titleSlug
end

function M.fetch_question_editor_data_by_slug(slug)
	local res = M.request({
		operationName = "questionEditorData",
		query = [[
      query questionEditorData($titleSlug: String!) {
        question(titleSlug: $titleSlug) {
          questionId
          questionFrontendId
          codeSnippets {
            lang
            langSlug
            code
          }
          envInfo
        }
      }
    ]],
		variables = {
			titleSlug = slug,
		},
	})

	local data = vim.json.decode(res.body)

	local codeSnippets = data.data.question.codeSnippets
	for _, snippet in pairs(codeSnippets) do
		if snippet.langSlug == "cpp" then
			return snippet.code
		end
	end

	error("Cannot find the code for your preferences lang!")
end

function M.request(body)
	local leetcode_cookie = cookie.extract_leetcode_cookie()
	local cookieHeader = string.format("LEETCODE_SESSION=%s; csrftoken=%s", leetcode_cookie[1], leetcode_cookie[2])
	local res = curl.post("https://leetcode.com/graphql", {
		headers = {
			["Content-Type"] = "application/json",
			["Cookie"] = cookieHeader,
			["x-csrftoken"] = leetcode_cookie[2],
			["Referer"] = "https://leetcode.com",
			["Accept"] = "application/json",
		},
		body = vim.json.encode(body),
	})

	if res.status ~= 200 then
		print(res.body)
		error("Failed to request, please check the configuration!")
	end

	return res
end

return M
