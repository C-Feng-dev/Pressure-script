print("---------------------------加载中---------------------------")
if game.PlaceId == 12411473842 then
    loadstring(game:HttpGet('https://raw.githubusercontent.com/C-Feng-dev/Pressure-script/refs/heads/main/Pressure-Lobby.lua'))()
elseif game.PlaceId == 17355897213 then
    loadstring(game:HttpGet('https://raw.githubusercontent.com/C-Feng-dev/Pressure-script/refs/heads/main/Pressure-The%20Raveyard.lua'))()
else
    loadstring(game:HttpGet('https://raw.githubusercontent.com/C-Feng-dev/Pressure-script/refs/heads/main/Pressure.lua'))()
    if game.PlaceId ~= 12552538292 then
        warn("疑似未在正确游戏内注入,可能会导致报错")
    end
end