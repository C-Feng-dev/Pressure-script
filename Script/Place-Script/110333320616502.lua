--Grace
local loadsuc, OrionLib = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/C-Feng-dev/Orion/refs/heads/main/main.lua'))()
end)
if loadsuc ~= true then
    warn("OrionLib加载错误,原因:" .. OrionLib)
    return
end
print("--OrionLib已加载完成--------------------------------加载中--")
OrionLib:MakeNotification({
    Name = "加载中...",
    Content = "可能会有短暂卡顿",
    Image = "rbxassetid://4483345998",
    Time = 4
})
local Connects = {}
local noautoinst = {}
local Players = game:GetService("Players") -- 玩家服务
local RS = game:GetService("ReplicatedStorage")
local Character = Players.LocalPlayer.Character -- 本地玩家Character
local humanoid = Character:FindFirstChild("Humanoid") -- 本地玩家humanoid
local PlayerGui = Players.LocalPlayer.PlayerGui--本地玩家PlayerGui
local Window = OrionLib:MakeWindow({
    IntroText = "Grace",
    Name = "Grace",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "Cfg/Grace"
})
local function Notify(name,content,time,Sound,SoundId) -- 信息
    OrionLib:MakeNotification({
        Name = name,
        Content = content,
        Image = "rbxassetid://4483345998",
        Time = time or "3",
        Sound = Sound,
        SoundId = SoundId
    })
end
local function createBilltoesp(theobject,name,color,hlset) -- 创建BillboardGui-颜色:Color3.new(r,g,b)
    local bill = Instance.new("BillboardGui", theobject) -- 创建BillboardGui
    bill.AlwaysOnTop = true
    bill.Size = UDim2.new(0, 100, 0, 50)
    bill.Adornee = theobject
    bill.MaxDistance = 2000
    bill.Name = name .. "esp"
    local mid = Instance.new("Frame", bill) -- 创建Frame-圆形
    mid.AnchorPoint = Vector2.new(0.5, 0.5)
    mid.BackgroundColor3 = color
    mid.Size = UDim2.new(0, 8, 0, 8)
    mid.Position = UDim2.new(0.5, 0, 0.5, 0)
    Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", mid)
    local txt = Instance.new("TextLabel", bill) -- 创建TextLabel-显示
    txt.AnchorPoint = Vector2.new(0.5, 0.5)
    txt.BackgroundTransparency = 1
    txt.TextColor3 =color
    txt.Size = UDim2.new(1, 0, 0, 20)
    txt.Position = UDim2.new(0.5, 0, 0.7, 0)
    txt.Text = name
    Instance.new("UIStroke", txt)
    if hlset then
        local hl = Instance.new("Highlight",PlayerGui)
        hl.Name = name .. "透视高光"
        hl.Adornee = theobject
        hl.DepthMode = "AlwaysOnTop"
        hl.FillColor = color
        hl.FillTransparency = "0.6"
    end
    task.spawn(function()
        while hl do
            if hl.Adornee == nil or not hl.Adornee:IsDescendantOf(workspace) then
                hl:Destroy()
            end
            task.wait()
        end
    end)
end
local function espmodel(themodel,modelname,name,r,g,b,hlset) -- Esp物品(Model对象)用
    if themodel:IsA("Model") and themodel.Parent.Name ~= Players and themodel.Name == modelname then
        createBilltoesp(themodel, name, Color3.new(r,g,b),hlset)
    end
end
local function unesp(name) -- unEsp物品用
    for _, esp in pairs(workspace:GetDescendants()) do
        if esp.Name == name .. "esp" then
            esp:Destroy()
        end
    end
    for _, hl in pairs(workspace:GetDescendants()) do
        if hl.Name == name .. "透视高光" then
            hl:Destroy()
        end
    end
end
local function createPlatform(name, sizeVector3,positionVector3) -- 创建平台-Vector3.new(x,y,z)
    if Platform then
        Platform:Destroy() -- 移除多余平台
    end
    Platform = Instance.new("Part")
    Platform.Name =name
    Platform.Size = sizeVector3
    Platform.Position = positionVector3
    Platform.Anchored = true
    Platform.Parent = workspace
    Platform.Transparency = 1
    Platform.CastShadow = false
end
local function teleportPlayerTo(player,toPositionVector3,saveposition) -- 传送玩家-Vector3.new(x,y,z)
    if player.Character:FindFirstChild("HumanoidRootPart") then
        if saveposition then
            playerPositions[player.UserId] = player.Character.HumanoidRootPart.CFrame
        end
        player.Character.HumanoidRootPart.CFrame = CFrame.new(toPositionVector3)
    end
end
local function teleportPlayerBack(player) -- 返回玩家 
    if playerPositions[player.UserId] then
        player.Character.HumanoidRootPart.CFrame = playerPositions[player.UserId]
        playerPositions[player.UserId] = nil -- 清除坐标
    else
        warn("返回失败!存储玩家原坐标的数值无法用于返回")
    end
end
local function chatMessage(chat) -- 发送信息
    game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(tostring(chat))
end
local function NotifiEntity(inst,EntityName,NotifyName,mode)
    if mode == "spawn" then
        if inst.Name == EntityName and OrionLib:IsRunning() then
            if OrionLib.Flags.NotifyEntities.Value then
                Notify("实体提醒",NotifyName .. "出现")
            end        
            if OrionLib.Flags.chatNotifyEntities.Value then
                chatMessage(NotifyName .. "出现")
            end
        end
    elseif mode == "remove" then
        if inst.Name == EntityName and OrionLib:IsRunning() then
            if OrionLib.Flags.NotifyEntities.Value then
                Notify("实体提醒",NotifyName .. "消失")
            end        
            if OrionLib.Flags.chatNotifyEntities.Value then
                chatMessage(NotifyName .. "消失")
            end
        end
    end
end
local function loadfinish() -- 加载完成后向控制台发送
    print("--------------------------加载完成--------------------------")
    print("--Grace Script已加载完成")
    print("--欢迎使用!" .. game.Players.LocalPlayer.Name)
    print("--此服务器游戏ID为:" .. game.GameId)
    print("--此服务器位置ID为:" .. game.PlaceId)
    print("--此服务器UUID为:" .. game.JobId)
    print("--此服务器上的游戏版本为:version_" .. game.PlaceVersion)
    print("--------------------------欢迎使用--------------------------")
end
--Function结束-其他
task.spawn(function()--关闭esp的Connect
	while (OrionLib:IsRunning()) do
		task.wait()
	end
	for _, Connection in pairs(Connects) do
		Connection:Disconnect()
	end
end)
loadfinish()--其他结束->加载完成信息
Notify("加载完成", "已成功加载")
local Tab = Window:MakeTab({
    Name = "主界面",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Esp = Window:MakeTab({
    Name = "透视",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Del = Window:MakeTab({
    Name = "删除",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local another = Window:MakeTab({
    Name = "杂项",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local others = Window:MakeTab({
    Name = "其他",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
Tab:AddToggle({
    Name = "实体提醒",
    Default = true,
    Flag = "NotifyEntities",
    Save = true
})
Tab:AddToggle({
    Name = "实体播报",
    Default = false,
    Flag = "chatNotifyEntities",
    Save = true
})
Tab:AddToggle({
    Name = "自动躲避",
    Default = false,
    Flag = "avoid",
    Save = true
})
Tab:AddButton({ -- 手动返回
    Name = "手动返回",
    Callback = function()
        teleportPlayerBack(Players.LocalPlayer)
    end
})
local Section = Tab:AddSection({
    Name = "交互"
})
Tab:AddToggle({ -- 轻松交互
    Name = "自动拉杆",
    Default = false,
    Flag = "autolever"
})
local Section = Tab:AddSection({
    Name = "其他"
})
Tab:AddButton({ -- 自动过关
    Name = "自动过关",
    Callback = function()
        if OrionLib.Flags.sureautogame.Value then
            local suc,err = pcall(function()
                RS.KillClient:Destroy()
                RS.SendGoatman:Destroy()
                RS.SendRush:Destroy()
                RS.SendSorrow:Destroy()
                RS.SendWorm:Destroy()
                RS.Worm:Destroy()
                RS.elkman:Destroy()
                RS.Rush:Destroy()
            end)
            if not suc then
                warn("删除RS内物品时出错:" .. err .. ",可能已删除")
            end
            task.spawn(function()
                while OrionLib.Flags.sureautogame.Value do
                    for _, touch in ipairs(workspace:GetDescendants()) do
                        if touch:IsA("TouchTransmitter") then
                            x = touch:FindFirstAncestorWhichIsA("Part")
                            if x then
                                if game:GetService("Players").LocalPlayer:DistanceFromCharacter(x.Position) <= 12 then
                                    x.CFrame = Character:FindFirstChildWhichIsA("BasePart").CFrame
                                end
                            end
                        end
                    end
                    task.wait(0.2)
                end
            end)
        else
            Notify("自动过关","请二次确认后再使用")
        end
    end
})
Tab:AddToggle({ -- 玩家提醒
    Name = "自动过关(二次确认)",
    Default = false,
    Flag = "sureautogame"
})
Tab:AddToggle({ -- 高亮
    Name = "高亮(低质量)",
    Default = true,
    Callback = function(Value)
        local Light = game:GetService("Lighting")
        if Value then
            FullBrightLite = true
            task.spawn(function()
                while FullBrightLite and OrionLib:IsRunning() do
                    Light.Ambient = Color3.new(1, 1, 1)
                    Light.ColorShift_Bottom = Color3.new(1, 1, 1)
                    Light.ColorShift_Top = Color3.new(1, 1, 1)
                    task.wait()
                end
            end)
        else
            FullBrightLite = false
            Light.Ambient = Color3.new(0, 0, 0)
            Light.ColorShift_Bottom = Color3.new(0, 0, 0)
            Light.ColorShift_Top = Color3.new(0, 0, 0)
        end
    end
})
Tab:AddButton({
    Name = "伪God mode",
    Callback = function()
        local suc,err = pcall(function()
            RS.KillClient:Destroy()
        end)
            if not suc then
            Notify("伪God mode","删除时出错,可能已删除")
            warn("删除时出错:" .. err .. ",可能已删除")
        end
    end
})
Tab:AddButton({
    Name = "返回大厅",
    Callback = function()
        game.ReplicatedStorage.byebyemyFRIENDbacktothelobby:FireServer()        
    end
})
Tab:AddSlider({
	Name = "视场角",
	Min = 0,
	Max = 20,
	Default = 0,
	Increment = 1,
	ValueName = "+",
	Callback = function(Value)
        game:GetService("ReplicatedFirst").CamFOV.Value = Value
    end
})
Tab:AddToggle({ -- 玩家提醒
    Name = "玩家提醒",
    Default = false,
    Flag = "PlayerNotifications"
})
Esp:AddToggle({ -- door
    Name = "门透视",
    Default = true,
    Callback = function(Value)
        if Value then
            doorsesp = true
            for _, themodel in pairs(workspace:GetDescendants()) do
                if themodel.Parent.Name == "Door" then
                    espmodel(themodel,"Door","门","0","1","0",true)
                end
            end
            local esp = workspace.DescendantAdded:Connect(function(themodel)
                if themodel.Parent.Name == "Door" then
                    espmodel(themodel,"Door","门","0","1","0",true)
                end
            end)
            table.insert(Connects,esp)
            task.spawn(function()
                while OrionLib:IsRunning() do
                    if doorsesp ~= true then
                        break
                    end
                    for _, hl in pairs(PlayerGui:GetChildren()) do
                        if hl.Name == "门透视高光" then
                            hl:Destroy()   
                        end   
                    end
                    task.wait(0.1)
                end
            end)
        else
            doorsesp = false
            esp:Disconnect()
            unesp("门")
        end
    end
})
Del:AddToggle({
    Name = "删除蓝眼",
    Default = true,
    Flag = "noblueeyes"
})
Del:AddButton({
    Name = "删除Goatman",
    Callback = function()
        local suc,err = pcall(function()
            RS.SendGoatman:Destroy()
        end)
            if not suc then
            Notify("删除Goatman","删除时出错,可能已删除")
            warn("删除时出错:" .. err .. ",可能已删除")
        end
    end
})
Del:AddButton({ 
    Name = "删除Rush",
    Callback = function()
        local suc,err = pcall(function()
            RS.SendRush:Destroy()
            RS.Rush:Destroy()
        end)
            if not suc then
            Notify("删除Rush","删除时出错,可能已删除")
            warn("删除时出错:" .. err .. ",可能已删除")
        end
    end
})
Del:AddButton({ 
    Name = "删除Sorrow",
    Callback = function()
        local suc,err = pcall(function()
            RS.SendSorrow:Destroy()
        end)
            if not suc then
            Notify("删除Sorrow","删除时出错,可能已删除")
            warn("删除时出错:" .. err .. ",可能已删除")
        end
    end
})
Del:AddButton({ 
    Name = "删除Worm",
    Callback = function()
        local suc,err = pcall(function()
            RS.SendWorm:Destroy()
            RS.Worm:Destroy()
        end)
            if not suc then
            Notify("删除Worm","删除时出错,可能已删除")
            warn("删除时出错:" .. err .. ",可能已删除")
        end
    end
})
Del:AddButton({ 
    Name = "删除elkman",
    Callback = function()
        local suc,err = pcall(function()
            RS.elkman:Destroy()
        end)
            if not suc then
            Notify("删除elkman","删除时出错,可能已删除")
            warn("删除时出错:" .. err .. ",可能已删除")
        end
    end
})
local Section = another:AddSection({
    Name = "倒计时设置"
})
another:AddLabel("需要至少激活一次倒计时才可使用")
another:AddTextbox({
	Name = "计时器时间",
	TextDisappear = true,
	Callback = function(Value)
		workspace.DEATHTIMER.Value = Value
	end	  
})
others:AddButton({
    Name = "注入Infinity Yield",
    Callback = function()
        Notify("注入Infinity Yield", "尝试注入中")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        Notify("注入Infinity Yield", "注入完成(如果没有加载则重试)")
    end
})
others:AddButton({
    Name = "注入Dex v2 white(会卡顿)",
    Callback = function()
        Notify("注入Dex v2 white", "尝试注入中")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/MariyaFurmanova/Library/main/dex2.0'))()
        Notify("注入Dex v2 white", "注入完成(如果没有加载则重试)")
    end
})
others:AddButton({
    Name = "删除此窗口",
    Callback = function()
        workspaceDA:Disconnect()
        workspaceDR:Disconnect()
        workspaceCA:Disconnect()
        workspaceCR:Disconnect()
        for _, Connection in pairs(EspConnects) do
            Connection:Disconnect()
        end
        OrionLib:Destroy()
    end
})
others:AddButton({
    Name = "加入随机大厅",
    Callback = function()
        Notify("加入游戏", "尝试加入中")
        TeleportService:Teleport(12411473842)
    end
})
local Section = others:AddSection({
    Name = "关于"
})
others:AddLabel("此服务器上的游戏ID为:" .. game.GameId)
others:AddLabel("此服务器上的游戏版本为:version_" .. game.PlaceVersion)
others:AddLabel("此服务器位置ID为:" .. game.PlaceId)
others:AddParagraph("此服务器UUID为:", game.JobId)
local workspaceDA = workspace.DescendantAdded:Connect(function(inst)
    NotifiEntity(inst,"Rush","Rush(粉怪)","spawn")
    if inst.Name == "eyes" and OrionLib.Flags.noblueeyes.Value then
        inst:FireServer()
    end
    if inst.Name == "Touched" and OrionLib.Flags.autolever.Value then
        inst:FireServer()
    end
end)
local workspaceDR = workspace.DescendantRemoving:Connect(function(inst)
    NotifiEntity(inst,"Rush","Rush(粉怪)","remove")
end)