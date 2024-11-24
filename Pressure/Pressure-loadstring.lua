print("---------------------------加载中---------------------------")
local function loadscript(url)
print("---------------------------注入中---------------------------")
    loadstring(game:HttpGet(url))()
end
if game.PlaceId == 12411473842 then
    loadscript("https://raw.githubusercontent.com/C-Feng-dev/Pressure-script/refs/heads/main/Pressure-Lobby.lua")
elseif game.PlaceId == 17355897213 then
    loadscript("https://raw.githubusercontent.com/C-Feng-dev/Pressure-script/refs/heads/main/Pressure-The%20Raveyard.lua")
elseif game.PlaceId == 12552538292 then
    loadscript("https://raw.githubusercontent.com/C-Feng-dev/Pressure-script/refs/heads/main/Pressure.lua")
else
    local suc,err = pcall function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/C-Feng-dev/Pressure-script/refs/heads/main/Pressure.lua"))()
    end
    if suc == false then
        warn("疑似未在正确游戏内注入,可能会导致报错,已加载默认配置")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/C-Feng-dev/Pressure-script/refs/heads/main/Pressure.lua"))()
    end
end
