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
local ScriptPath = PlaceTable[game.GameId].Folder .. "/" .. PlaceTable[game.GameId].Place[game.PlaceId] 
print("--LinoriaLib等加载完成------------------------------加载中--")
if ScriptPath then
    Window = Library:CreateWindow({
        Title = PlaceTable[game.GameId].Main .. " - " .. PlaceTable[game.GameId].Place[game.PlaceId],
        Center = true,
        AutoShow =  true,
        TabPadding = 8,
        MenuFadeTime = 0.2
    })
end
local Tabs = {}
local suc,err = pcall(function()
    return load(baseUrl .. "Place-Script/" .. ScriptPath .. ".lua")
end)
if not suc then
    warn("尝试加载对应外挂时出现错误,报错为:" .. err .. ",已尝试加载中心")
    Library.Unloaded = true
    load(baseUrl .. "Tab/Hub.lua")
    return
end
Tabs['UI Settings'] = Window:AddTab('UI设置'),
Library:SetWatermarkVisibility(true)
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;
local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end
    Library:SetWatermark(('LinoriaLib | %s fps | %s ms'):format(math.floor(FPS), math.floor(
        game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())));
end);
Library.KeybindFrame.Visible = true
Library:OnUnload(function()
    print('已关闭!')
    WatermarkConnection:Disconnect()
    Library.Unloaded = true
end)
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('菜单')
MenuGroup:AddButton('关闭', function()
    Library:Unload()
end)
MenuGroup:AddToggle('WatermarkVisibility', {
    Text = '横条开关',
    Default = true,
    Callback = function(Value)
        if Value then
            Library:SetWatermarkVisibility(true)
        else
            Library:SetWatermarkVisibility(false)
        end
    end
})
MenuGroup:AddLabel('菜单按键'):AddKeyPicker('MenuKeybind', {
    Default = 'RightShift',
    NoUI = true,
    Text = '菜单键'
})
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:SetFolder('CFHub/Theme')
SaveManager:SetFolder('CFHub/' .. PlaceTable[game.GameId].Folder .. "/" .. PlaceTable[game.GameId].Place[game.PlaceId])
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:IgnoreThemeSettings()
SaveManager:LoadAutoloadConfig()
