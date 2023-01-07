local settings_ = {...}
local username = settings_[1]
local repo = settings_[2]
local token = settings_[3]
local http = game:GetService("HttpService")
local git = {}
function git.GetFile(FilePath)
	local url = string.format('https://api.github.com/repos/%s/%s/contents/%s', username, repo, FilePath)
	local response = http:RequestAsync(
		{
			Url = url,
			Method = "GET",
			Headers = {
				["Content-Type"] = "application/json",
				Accept = 'application/vnd.github.v3',
				Authorization = string.format('token %s', token)
			},
		}
	)
	return http:GetAsync(http:JSONDecode(response.Body).download_url)
end
function git.PutFile(FilePath, Contents)
	local url = string.format('https://api.github.com/repos/%s/%s/contents/%s', username, repo, FilePath)
	local response = http:RequestAsync(
		{
			Url = url,
			Method = "PUT",
			Headers = {
				["Content-Type"] = "application/json",
				Authorization = string.format('Bearer %s', token)
			},
			Body = http:JSONEncode({message = "Upload from console", content = Contents})
		}
	)
	return http:JSONDecode(response.Body)
end
return git
