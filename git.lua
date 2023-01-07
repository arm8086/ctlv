local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
function encode(data)
	return ((data:gsub('.', function(x) 
		local r,b='',x:byte()
		for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
		return r;
	end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
		if (#x < 6) then return '' end
		local c=0
		for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6 - i) or 0) end
		return b:sub(c + 1,c + 1)
	end)..({ '', '==', '=' })[#data % 3+1])
end
function decode(data)
	data = string.gsub(data, '[^'..b..'=]', '')
	return (data:gsub('.', function(x)
		if (x == '=') then return '' end
		local r,f='',(b:find(x)-1)
		for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
		return r;
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if (#x ~= 8) then return '' end
		local c=0
		for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
		return string.char(c)
	end))
end
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
			Body = http:JSONEncode({message = "Upload from console", content = encode(Contents)})
		}
	)
	return http:JSONDecode(response.Body)
end
return git
