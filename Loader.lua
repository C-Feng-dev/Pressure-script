print("---------------------------加载中---------------------------")
local function load(url)
    loadstring(game:HttpGet(url))()
end
if game.PlaceId == 12411473842 then 
    load("https://raw.githubusercontent.com/C-Feng-dev/My-own-Script/refs/heads/main/Pressure/Pressure-Lobby.lua")
elseif game.PlaceId == 17355897213 then
    load("https://raw.githubusercontent.com/C-Feng-dev/My-own-Script/refs/heads/main/Pressure/Pressure-The%20Raveyard.lua")
elseif game.PlaceId == 12552538292 then
    load("https://raw.githubusercontent.com/C-Feng-dev/My-own-Script/refs/heads/main/Pressure/Pressure.lua")
else
    local suc,err = pcall(function()
        return load("https://raw.githubusercontent.com/C-Feng-dev/My-own-Script/refs/heads/main/Other-Place/" .. game.PlaceId .. ".lua")
    end)
    if suc == false then
        warn("注入时出现错误,报错为:" .. err .. ",已停止加载")
    end
end 
