--Regretevator-WIP
print("--------------------成功注入，正在加载中--------------------")
local loadsuc, OrionLib = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/C-Feng-dev/Orion/refs/heads/main/main.lua'))()
end)
if loadsuc ~= true then
    warn("OrionLib加载错误,原因:" .. OrionLib)
    return
end
local Ver = "WIP"
print("--OrionLib已加载完成--------------------------------加载中--")
local EspConnects = {}
local TeleportService = game:GetService("TeleportService") -- 传送服务
local Players = game:GetService("Players") -- 玩家服务
local Character = Players.LocalPlayer.Character -- 本地玩家Character
local humanoid = Character:FindFirstChild("Humanoid") -- 本地玩家humanoid
local PlayerGui = Players.LocalPlayer.PlayerGui--本地玩家PlayerGui
OrionLib:MakeNotification({
    Name = "加载中...",
    Content = "可能会有短暂卡顿",
    Image = "rbxassetid://4483345998",
    Time = 4
})
local function Notify(name,content,time,usesound,sound) -- 信息
    OrionLib:MakeNotification({
        Name = name,
        Content = content,
        Image = "rbxassetid://4483345998",
        Time = time or "3",
        sound = sound,
        useSound = usesound
    })
end
local function nofloorerr()
    Notify("透视失败","楼层未出现",3,true)
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
        local hl = Instance.new("Highlight",bill)
        hl.Name = name .. "透视高光"
        hl.Parent = PlayerGui
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
local function espmodel(modelname,name,r,g,b,hlset) -- Esp物品(Model对象)用
    for _, themodel in pairs(workspace:GetDescendants()) do
        if themodel:IsA("Model") and themodel.Parent.Name ~= Players and themodel.Name == modelname then
            createBilltoesp(themodel,name, Color3.new(r,g,b),hlset)
        end
    end
    local esp = workspace.DescendantAdded:Connect(function(themodel)
        if themodel:IsA("Model") and themodel.Parent.Name ~= Players and themodel.Name == modelname then
            createBilltoesp(themodel,name, Color3.new(r,g,b),hlset)
        end
    end)
    table.insert(EspConnects,esp)
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
local function teleportPlayerTo(player,toPositionVector3,saveposition) -- 传送玩家-Vector3.new(x,y,z)
    if player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(toPositionVector3)
    end
end
local Window = OrionLib:MakeWindow({
    IntroText = "Regretevator",
    Name = "Regretevator",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "RegretevatorScript"
})
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
local TP = Window:MakeTab({
    Name = "传送",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local others = Window:MakeTab({
    Name = "其他",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Section = Tab:AddSection({
    Name = "通用"
})
Tab:AddToggle({ -- 轻松交互
    Name = "轻松交互",
    Default = true,
    Callback = function(Value)
        if Value then
            ezinst = true
            task.spawn(function()
                while ezinst and OrionLib:IsRunning() do
                    for _, toezInteract in pairs(workspace:GetDescendants()) do
                        if toezInteract:IsA("ProximityPrompt") then
                            toezInteract.HoldDuration = "0"
                            toezInteract.RequiresLineOfSight = false
                            toezInteract.MaxActivationDistance = "12"
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            ezinst = false
        end
    end
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
Tab:AddToggle({ -- 玩家提醒
    Name = "玩家提醒",
    Default = false,
    Flag = "PlayerNotifications"
})
Esp:AddButton({
    Name = "Jaoba透视(Jaoba楼层)",
    Callback = function()
        if workspace.UES == nil then
            nofloorerr()
            return
        end
        createBilltoesp(workspace.UES.Build.JAOBA,"Jaoba",Color3.new(1,1,1),true)
    end
})
Esp:AddButton({
    Name = "Lampert透视(3008楼层)",
    Callback = function()
        if workspace.3008_Room == nil then
            nofloorerr()
            return
        end
        createBilltoesp(workspace.3008_Room.Build.Lampert,"Lampert",Color3.new(1,1,1),true)
    end
})

TP:AddButton({
    Name = "柴火透视",
    Callback = function()
        for _, theEsp in pairs(workspace:GetDescendants()) do
        if workspace.idk == nil then
            nofloorerr()
            return
        end
        teleportPlayerTo(player,toPositionVector3,saveposition)
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
        for _, Connection in pairs(EspConnects) do
            Connection:Disconnect()
        end
        OrionLib:Destroy()
    end
})
local Section = others:AddSection({
    Name = "关于"
})
others:AddLabel("此服务器上的游戏ID为:" .. game.GameId)
others:AddLabel("此服务器上的游戏版本为:version_" .. game.PlaceVersion)
others:AddLabel("此服务器位置ID为:" .. game.PlaceId)
others:AddParagraph("此服务器UUID为:", game.JobId)
others:AddLabel("版本:" .. Ver)
Players.PlayerAdded:Connect(function(player)
    if OrionLib.Flags.PlayerNotifications.Value then
        if player:IsFriendsWith(Players.LocalPlayer.UserId) then
            Notififriend = "(好友)"
        else
            Notififriend = ""
        end
        Notify("玩家提醒", player.Name .. Notififriend .. "已加入", 2,false)
    end
    if OrionLib.Flags.playeresp.Value and player ~= Players.LocalPlayer then
        createBilltoesp(player.Character, player.Name, Color3.new(238, 201, 0))
    end
end)
Players.PlayerRemoving:Connect(function(player)
    if OrionLib.Flags.PlayerNotifications.Value then
        if player:IsFriendsWith(Players.LocalPlayer.UserId) then
            Notififriend = "(好友)"
        else
            Notififriend = ""
        end
        Notify("玩家提醒", player.Name .. Notififriend .. "已退出", 2,false)
    end
end)
