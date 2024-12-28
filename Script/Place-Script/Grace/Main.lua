local EspConnects = {}
local Players = game:GetService("Players") -- 玩家服务
local Character = Players.LocalPlayer.Character -- 本地玩家Character
local humanoid = Character:FindFirstChild("Humanoid") -- 本地玩家humanoid
local PlayerGui = Players.LocalPlayer.PlayerGui--本地玩家PlayerGui
local RS = game:GetService("ReplicatedStorage")
local function createBilltoesp(theobject,name,color,hlset) -- 创建BillboardGui-颜色:Color3.new(r,g,b)
    bill = Instance.new("BillboardGui", theobject) -- 创建BillboardGui
    bill.AlwaysOnTop = true
    bill.Size = UDim2.new(0, 100, 0, 50)
    bill.Adornee = theobject
    bill.MaxDistance = 2000
    bill.Name = name .. "esp"
    mid = Instance.new("Frame", bill) -- 创建Frame-圆形
    mid.AnchorPoint = Vector2.new(0.5, 0.5)
    mid.BackgroundColor3 = color
    mid.Size = UDim2.new(0, 8, 0, 8)
    mid.Position = UDim2.new(0.5, 0, 0.5, 0)
    Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", mid)
    txt = Instance.new("TextLabel", bill) -- 创建TextLabel-显示
    txt.AnchorPoint = Vector2.new(0.5, 0.5)
    txt.BackgroundTransparency = 1
    txt.TextColor3 =color
    txt.Size = UDim2.new(1, 0, 0, 20)
    txt.Position = UDim2.new(0.5, 0, 0.7, 0)
    txt.Text = name
    Instance.new("UIStroke", txt)
    if hlset then
        hl = Instance.new("Highlight",PlayerGui)
        hl.Name = name .. "透视高光"
        hl.Adornee = theobject
        hl.DepthMode = "AlwaysOnTop"
        hl.FillColor = color
        hl.FillTransparency = "0.6"
        task.spawn(function()
            while hl do
                if hl.Adornee == nil or not hl.Adornee:IsDescendantOf(workspace) then
                    hl:Destroy()
                end
                task.wait()
            end
        end)
    end
end
local Tabs = {
    Main = Window:AddTab('主界面'),
    Act = Window:AddTab('行为'),
    Misc = Window:AddTab('杂项')
}
local MainEntity = Tabs.Main:AddLeftGroupbox('实体')
MainEntity:AddToggle('NotifyEntities',{
    Text = "实体提醒",
    Default = true
})
MainEntity:AddToggle('chatNotifyEntities',{
    Text = "实体播报",
    Default = false
})
local MainAutoInstTabbox = Tabs.Main:AddRightTabbox() -- Add Tabbox on right side
local autoinstTab = MainAutoInstTabbox:AddTab('自动交互')
local autoinstDistanceTab = MainAutoInstTabbox:AddTab('交互距离')
autoinstDistanceTab:AddLabel("交互距离超过40可能会导致交互bug")
autoinstTab:AddToggle('autolever',{
    Text = "自动拉杆",
    Default = false,
    Callback = function(Value)
        if Value == true then
            autolever = true
        else
            autolever = false
        end
        while autolever do  
            for _, breaker in pairs(workspace.Rooms:GetDescendants()) do
                if breaker.Name == "Breaker" then
                    if Players.LocalPlayer:DistanceFromCharacter(breaker:WaitForChild("base").Position) <= Options.autoleverdistance.Value then
                        breaker.Touched:FireServer()
                    end
                end
            end
            task.wait(0.1)
        end
    end
})
autoinstTab:AddToggle('autodoor',{
    Text = "自动开门(黄门)",
    Default = false,
    Callback = function(Value)
        if Value == true then
            autodoor = true
        else
            autodoor = false
        end
        while autodoor do
            for _, door in pairs(workspace.Rooms:GetDescendants()) do
                if door.Name == "TouchInterest" and door.Parent.Name == "kickBox" and Players.LocalPlayer:DistanceFromCharacter(door.Parent.Position) <= Options.autodoordistance.Value then
                    door.Parent.Parent.RemoteEvent:FireServer()
                end
            end
            task.wait(0.1)
        end
    end
})
autoinstDistanceTab:AddSlider('autoinstdistance',{
    Text = "交互距离",
    Min = 12,
    Max = 100,
    Default = 12,
    Rounding = 1,
})
autoinstDistanceTab:AddSlider('autoleverdistance',{
    Text = "自动拉杆距离",
    Min = 5,
    Max = 100,
    Default = 20,
    Rounding = 1,
})
autoinstDistanceTab:AddSlider('autodoordistance',{
    Text = "自动开门距离",
    Min = 5,
    Max = 100,
    Default = 20,
    Rounding = 1,
})
local MainOther = Tabs.Main:AddLeftGroupbox('其他')
MainOther:AddButton({ -- 自动过关
    Text = "自动过关",
    Tooltip = '请删除所有实体生成再使用自动过关',
    DoubleClick = true,
    Func = function()
        task.spawn(function()
            while Toggles.sureautogame.Value do
                hitboxes = {}
                for _, hitbox in pairs(workspace.Rooms:GetDescendants()) do
                    if hitbox.Name == "hitBox" then
                        table.insert(hitboxes,hitbox)
                    end
                end
                for _, i in pairs(hitboxes) do
                    teleportPlayerTo(i.CFrame)
                end
                hitboxes = {}
                task.wait(0.02)
            end
        end)
    end
})
MainOther:AddButton({
    Text = "返回大厅",
    DoubleClick = true,
    Func = function()
        game.ReplicatedStorage.byebyemyFRIENDbacktothelobby:FireServer()        
    end
})
MainOther:AddButton({
	Text = "自杀(启动伪God mode后失效)",
    DoubleClick = true,
	Func = function()
        if RS.KillClient then
            RS.KillClient:InvokeServer()
        else
            Library:Notify("已失效")
        end
	end	  
})
MainOther:AddToggle('PlayerNotifications',{ -- 玩家提醒
    Text = "玩家提醒",
    Default = false,
})
local MainCamera = Tabs.Main:AddLeftGroupbox('相机设置')
MainCamera:AddSlider('CamFOV',{
	Text = "视场角",
	Min = 0,
	Max = 20,
	Default = game:GetService("ReplicatedFirst").CamFOV.Value or 0,
	Rounding = 1,
	Suffix = "+",
	Callback = function(Value)
        game:GetService("ReplicatedFirst").CamFOV.Value = Value
    end
})
MainCamera:AddToggle('FullBrightLite',{ -- 高亮
    Text = "高亮(低质量)",
    Default = true,
    Callback = function(Value)
        local Light = game:GetService("Lighting")
        if Value then
            task.spawn(function()
                while Toggles.FullBrightLite.Value do
                    Light.Ambient = Color3.new(1, 1, 1)
                    Light.ColorShift_Bottom = Color3.new(1, 1, 1)
                    Light.ColorShift_Top = Color3.new(1, 1, 1)
                    task.wait(0.1)
                end
            end)
        else
            Light.Ambient = Color3.new(0, 0, 0)
            Light.ColorShift_Bottom = Color3.new(0, 0, 0)
            Light.ColorShift_Top = Color3.new(0, 0, 0)
        end
    end
})
local ActEsp = Tabs.Act:AddLeftGroupbox('透视')
local ActDel = Tabs.Act:AddRightGroupbox('删除')
ActEsp:AddToggle('doorsesp',{
    Text = "门透视",
    Default = true,
    Callback = function(Value)
        if Value then
            for _, themodel in pairs(workspace:GetDescendants()) do
                if themodel.Name == "Door" then
                    if themodel.Parent.Parent.Name == "Rooms" then--第一个Parent为房间号
                        if themodel:WaitForChild("Door"):IsA("Model") then
                            createBilltoesp(themodel:WaitForChild("Door"),"门", Color3.new(0,1,0),true)
                        elseif themodel:WaitForChild("Door"):IsA("Part") then
                            createBilltoesp(themodel,"门", Color3.new(0,1,0),true)
                        end
                    end
                end
            end
            esp = workspace.DescendantAdded:Connect(function(themodel)
                if themodel.Name == "Door" then
                    if themodel.Parent.Parent.Name == "Rooms" then
                        if themodel:WaitForChild("Door"):IsA("Model") then
                            createBilltoesp(themodel:WaitForChild("Door"),"门", Color3.new(0,1,0),true)
                        elseif themodel:WaitForChild("Door"):IsA("Part") then
                            createBilltoesp(themodel,"门", Color3.new(0,1,0),true)
                        end
                    end
                end
            end)
            table.insert(EspConnects,esp)
            task.spawn(function()
                while Toggles.doorsesp.Value do
                    if doorsesp ~= true then
                        esp:Disconnect()
                        for _, hl in pairs(PlayerGui:GetChildren()) do
                            if hl.Name == "门透视高光" then
                                hl:Destroy()   
                            end   
                        end
                        break
                    end
                    task.wait(0.1)
                end
            end)
        else
            unesp("门")
        end
    end
})
ActEsp:AddToggle('leveresp',{ -- door
    Text = "拉杆透视",
    Default = true,
    Callback = function(Value)
        if Value then
            for _, themodel in pairs(workspace:GetDescendants()) do
                if themodel.Name == "Breaker" then
                    if themodel.Parent.Parent.Name == "Rooms" then
                        createBilltoesp(themodel,"拉杆", Color3.new(1,0,0),false)
                    end
                end
            end
            esp = workspace.DescendantAdded:Connect(function(themodel)
                if themodel.Name == "Breaker" then
                    if themodel.Parent.Parent.Name == "Rooms" then
                        createBilltoesp(themodel,"拉杆", Color3.new(1,0,0),false)
                    end
                end
            end)
            table.insert(EspConnects,esp)
            task.spawn(function()
                while OrionLib:IsRunning() do
                    if leveresp ~= true then
                        esp:Disconnect()
                        for _, hl in pairs(PlayerGui:GetChildren()) do
                            if hl.Name == "拉杆透视高光" then
                                hl:Destroy()   
                            end   
                        end
                        break
                    end
                    task.wait(0.1)
                end
            end)
        else
            unesp("拉杆")
        end
    end
})
ActEsp:AddToggle('SafeRoomVaultesp',{
    Text = "安全区井口透视",
    Default = true,
    Callback = function(Value)
        if Value then
            for _, themodel in pairs(workspace:GetDescendants()) do
                if themodel.Name == "VaultEntrance" then
                    if themodel.Parent.Name == "SafeRoom" then--第一个Parent为房间号
                        createBilltoesp(themodel:WaitForChild("Hinged"),"井口", Color3.new(0,1,0),true)
                    end
                end
            end
            esp = workspace.DescendantAdded:Connect(function(themodel)
                if themodel.Name == "VaultEntrance" then
                    if themodel.Parent.Name == "SafeRoom" then
                        createBilltoesp(themodel:WaitForChild("Hinged"),"井口", Color3.new(0,1,0),true)
                    end
                end
            end)
            table.insert(EspConnects,esp)
            task.spawn(function()
                while OrionLib:IsRunning() do
                    if SafeRoomVaultesp ~= true then
                        esp:Disconnect()
                        for _, hl in pairs(PlayerGui:GetChildren()) do
                            if hl.Name == "井口透视高光" then
                                hl:Destroy()   
                            end   
                        end
                        break
                    end
                    task.wait(0.1)
                end
            end)
        else
            unesp("井口")
        end
    end
})
ActDel:AddButton({
    Text = "God mode",
    Tooltip = '被某些实体击杀时可能会导致bug',
    DoubleClick = true,
    Func = function()
        suc,err = pcall(function()
            RS.KillClient:Destroy()
            Library:Notify("成功开启伪God mode",3)
        end)
            if not suc then
            Library:Notify("开启伪God mode时出错,可能已启用过此功能",3)
        end
    end
})
ActDel:AddToggle('noblueeyes',{
    Text = "删除蓝眼",
    Default = true
})
ActDel:AddToggle('noredeyes',{
    Text = "删除红眼",
    Default = true
})
ActDel:AddToggle('norush',{ 
    Text = "删除Rush",
    Default = true
})
ActDel:AddToggle('noworm',{ 
    Text = "删除Worm",
    Default = true
})
ActDel:AddToggle('noelkman',{ 
    Text = "删除elkman",
    Default = true
})
ActDel:AddToggle('nodozer',{ 
    Text = "删除Dozer",
    Default = true
})
ActDel:AddButton({
    Text = "防止Goatman生成",
    DoubleClick = true,
    Func = function()
        suc,err = pcall(function()
            RS.SendGoatman:Destroy()
            Library:Notify("成功启用防止Goatman生成",3)
        end)
            if not suc then
            Library:Notify("启用防止Goatman生成时出错,可能已启用过此功能",3)
        end
    end
})
ActDel:AddButton({ 
    Text = "删除Rush生成",
    DoubleClick = true,
    Func = function()
        suc,err = pcall(function()
            RS.SendRush:Destroy()
            RS.Rush:Destroy()
            Library:Notify("成功启用防止Rush生成",3)
        end)
            if not suc then
            Library:Notify("启用防止Rush生成时出错,可能已启用过此功能",3)
        end
    end
})
ActDel:AddButton({ 
    Text = "删除Sorrow生成",
    DoubleClick = true,
    Func = function()
        suc,err = pcall(function()
            RS.SendSorrow:Destroy()
            Library:Notify("成功启用防止Sorrow生成",3)
        end)
            if not suc then
            Library:Notify("启用防止Sorrow生成时出错,可能已启用过此功能",3)
        end
    end
})
ActDel:AddButton({ 
    Text = "删除Worm生成",
    DoubleClick = true,
    Func = function()
        suc,err = pcall(function()
            RS.SendWorm:Destroy()
            RS.Worm:Destroy()
            Library:Notify("成功启用防止Worm生成",3)
        end)
            if not suc then
            Library:Notify("启用防止Worm生成时出错,可能已启用过此功能",3)
        end
    end
})
local MiscTimer = Tabs.Misc:AddLeftGroupbox('计时器')
local MiscScript = Tabs.Misc:AddRightGroupbox('注入')
MiscTimer:AddInput('Timerstime',{
	Text = "计时器时间",
    Tooltip = '需要至少激活一次倒计时才可使用',
    Numeric = true,
    Finished = true,
	Callback = function(Value)
		workspace.DEATHTIMER.Value = Value
	end	  
})
MiscScript:AddButton({
    Text = "注入Infinity Yield",
    Func = function()
        Library:Notify("尝试注入Infinity Yield中",3)
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        Library:Notify("注入完成(如果没有加载则重试)",3)
    end
})
MiscScript:AddButton({
    Text = "注入Dex v2 white(可能会卡顿)",
    Func = function()
        Library:Notify("尝试注入Dex v2 white中",3)
        loadstring(game:HttpGet('https://raw.githubusercontent.com/MariyaFurmanova/Library/main/dex2.0'))()
        Library:Notify("注入完成(如果没有加载则重试)",3)
    end
})
workspaceDA = workspace.DescendantAdded:Connect(function(inst)
    NotifiEntity(inst,"Rush","Rush(粉怪)","spawn",Toggles.norush.Value)
    NotifiEntity(inst,"Worm","Worm(白怪)","spawn",Toggles.noworm.Value)
    if inst.Name == "Rush" and Toggles.norush.Value then
        inst:Destroy()
        RS.SendRush.Carnation.tinnitus.Playing = false
    end
    if inst.Name == "Worm" and Toggles.noworm.Value then
        inst:Destroy()
        RS.SendWorm.Slugfish.tinnitus.Playing = false
    end
    if inst.Name == "eye" and Toggles.noblueeyes.Value then
        inst:Destroy()
    end
    if inst.Name == "eyePrime" and Toggles.noredeyes.Value then
        inst:Destroy()
    end
    if inst.Name == "elkman" and Toggles.noelkman.Value then
        inst:Destroy()
    end
end)
workspaceDR = workspace.DescendantRemoving:Connect(function(inst)
    NotifiEntity(inst,"Rush","Rush(粉怪)","remove",Toggles.norush.Value)
    NotifiEntity(inst,"Worm","Worm(白怪)","remove",Toggles.noworm.Value)
end)
PlayersGuiDR = PlayerGui.DescendantAdded:Connect(function(inst)
    if inst.Name == "smilegui" and Toggles.nodozer.Value then
        inst:Destroy()
    end
end)

LoadSetting(false)