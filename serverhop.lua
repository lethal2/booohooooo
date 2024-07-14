queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/Hackerman694200/tester/main/serverhop.lua'))()")
wait(1)
local gameId = 606849621

local function get(url)
    return game:HttpGet(url, true)
end

local function findSmallestServer()
    local servers = {}
    local nextPageCursor = ""
    repeat
        local url = "https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=Asc&limit=100"
        if nextPageCursor ~= "" then
            url = url .. "&cursor=" .. nextPageCursor
        end
        
        local data = game:GetService("HttpService"):JSONDecode(get(url))
        
        for _, server in ipairs(data.data) do
            if server.playing < server.maxPlayers then
                table.insert(servers, server)
            end
        end
        
        nextPageCursor = data.nextPageCursor
    until not nextPageCursor
    
    if #servers > 0 then
        table.sort(servers, function(a, b) return a.playing < b.playing end)
        return servers[1].id
    end
    
    return nil
end

local serverId = findSmallestServer()
if serverId then
    game:GetService("TeleportService"):TeleportToPlaceInstance(gameId, serverId)
else
    print("No suitable servers found.")
end
