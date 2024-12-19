print("--------------------成功注入，正在加载中--------------------")
local baseUrl = "https://raw.githubusercontent.com/C-Feng-dev/My-own-Script/refs/heads/LinoriaLib-Gui/Script/"
local librepo = 'https://raw.githubusercontent.com/C-Feng-dev/LinoriaLib/main/' 
local function load(url)
    return loadstring(game:HttpGet(url))()
end
local Library = load(librepo .. 'Library.lua')
local ThemeManager = load(librepo .. 'addons/ThemeManager.lua')
local SaveManager = load(librepo .. 'addons/SaveManager.lua')
local PlaceTable = load(baseUrl .. "GameTable.lua")
local function ScriptPath(mid)
    return PlaceTable[game.GameId].Folder .. mid .. PlaceTable[game.GameId].Place[game.PlaceId]
end
print("--LinoriaLib等加载完成------------------------------加载中--")
Window = Library:CreateWindow({
    Title = "*CFHub* " .. ScriptPath(" - "),
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})
Library:Notify("加载中")
local suc,err = pcall(function()
    return load(baseUrl .. "Loader-Script/" .. ScriptPath("/") .. ".lua")
end)
if not suc then
    warn("尝试加载对应外挂时出现错误,报错为:" .. err .. ",已尝试加载中心")
    Library:Notify("加载失败!此UI将会在3秒后自动关闭")
    task.wait(3)
    Library:Unload()
    load(baseUrl .. "Tab/Hub.lua")
    return
end
function loadfinish(location) -- 加载完成后向控制台发送
    print("--------------------------加载完成--------------------------")
    print("--CF Hub已加载完成")
    print("--欢迎使用!" .. game.Players.LocalPlayer.Name)
    print("--此服务器游戏ID为:" .. game.GameId)
    print("--此服务器位置ID为:" .. game.PlaceId)
    print("--此服务器UUID为:" .. game.JobId)
    print("--此服务器上的游戏版本为:version_" .. game.PlaceVersion)
    print("--当前您位于:" .. location or "Unknown")
    print("--------------------------欢迎使用--------------------------")
end
loadfinish(ScriptPath(" - "))
Library:Notify("加载成功!")