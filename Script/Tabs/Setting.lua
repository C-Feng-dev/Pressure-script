function LoadSetting(defaultWatermark)
    Tabs['UI Settings'] = Window:AddTab('UI设置')
    MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
    MenuGroup:AddButton({
        Text = '关闭界面',
        DoubleClick = true,
        Func = function()
            Library:Unload()
        end
    })
    MenuGroup:AddButton({
        Text = '上方UI条',
        Default = true,
        Func = function(Value)
            Library:SetWatermarkVisibility(Value)
        end
    })
    MenuGroup:AddLabel('菜单按键'):AddKeyPicker('MenuKeybind', {
        Default = 'RightShift',
        NoUI = true,
        Text = '菜单键'
    })
    local defaultWatermark = defaultWatermark or true
    if defaultWatermark then
        local FrameTimer = tick()
        local FrameCounter = 0
        local FPS = 60
        local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
            FrameCounter += 1
            if (tick() - FrameTimer) >= 1 then
                FPS = FrameCounter;
                FrameTimer = tick();
                FrameCounter = 0;
            end
            Library:SetWatermark(('LinoriaLib | %s fps | %s ms'):format(
                math.floor(FPS),
                math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
            ))
        end)
    end
    Library.KeybindFrame.Visible = true
    Library:OnUnload(function()
        WatermarkConnection:Disconnect()
        print('已关闭!')
        Library.Unloaded = true
    end)
    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({'MenuKeybind'})
    ThemeManager:SetFolder('CFHub/Theme')
    SaveManager:SetFolder('CFHub/' .. ScriptPath("/"))
    SaveManager:BuildConfigSection(Tabs['UI Settings'])
    ThemeManager:ApplyToTab(Tabs['UI Settings'])
end