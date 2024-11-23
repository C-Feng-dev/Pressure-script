print("--------------------成功注入，正在加载中--------------------")
local loadsuc, OrionLib = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/C-Feng-dev/Orion/refs/heads/main/main.lua'))()
end)
if loadsuc ~= true then
    warn("OrionLib加载错误,原因:" .. OrionLib)
    return
end
local Ver = "Alpha 0.0.2"
print("--OrionLib已加载完成--------------------------------加载中--")
OrionLib:MakeNotification({
    Name = "加载中...",
    Content = "可能会有短暂卡顿",
    Image = "rbxassetid://4483345998",
    Time = 4
})
local Window = OrionLib:MakeWindow({
    IntroText = "The Raveyard",
    Name = "Pressure-The Raveyard",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "PressureScript-Raveyard"
})
-- local设置
local EspConnects = {}
local TeleportService = game:GetService("TeleportService") -- 传送服务
local Players = game:GetService("Players") -- 玩家服务
local Character = Players.LocalPlayer.Character -- 本地玩家Character
local humanoid = Character:FindFirstChild("Humanoid") -- 本地玩家humanoid
local Espboxes = Players.LocalPlayer.PlayerGui
local RemoteFolder = game:GetService('ReplicatedStorage').Events -- Remote Event储存区之一
--local结束->Function设置
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
local function delNotifi(delthings) -- 删除信息
    Notify(delthings, "已成功删除")
end
local function entityNotifi(entityname) -- 实体提醒
    Notify("实体提醒", entityname)
end
local function copyitems(copyitem) -- 复制物品
    local create_NumberValue = Instance.new("NumberValue") -- copy items-type NumberValue
    create_NumberValue.Name = copyitem
    create_NumberValue.Parent = game.Players.LocalPlayer.PlayerFolder.Inventory
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
        hl.Parent = Players.LocalPlayer.PlayerGui
        hl.Adornee = theobject
        hl.DepthMode = "AlwaysOnTop"
        hl.FillColor = color
        hl.FillTransparency = "0.5"
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
local function espmodel(modelname,name,r,g,b,hlset) -- Esp物品(Model对象)用
    for _, themodel in pairs(workspace:GetDescendants()) do
        if themodel:IsA("Model") and themodel.Parent ~= Players and themodel.Name == modelname then
            createBilltoesp(themodel,name, Color3.new(r,g,b),hlset)
        end
    end
    local esp = workspace.DescendantAdded:Connect(function(themodel)
        if themodel:IsA("Model") and themodel.Parent ~= Players and themodel.Name == modelname then
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
local function loadfinish() -- 加载完成后向控制台发送
    print("--------------------------加载完成--------------------------")
    print("--Pressure Script已加载完成")
    print("--欢迎使用!" .. game.Players.LocalPlayer.Name)
    print("--此服务器游戏ID为:" .. game.GameId)
    print("--此服务器位置ID为:" .. game.PlaceId)
    print("--此服务器UUID为:" .. game.JobId)
    print("--此服务器上的游戏版本为:version_" .. game.PlaceVersion)
    print("--当前您位于The Raveyard")
    print("--------------------------欢迎使用--------------------------")
end
--Function结束-其他
task.spawn(function()--关闭esp的Connect
	while (OrionLib:IsRunning()) do
		task.wait()
	end
	for _, Connection in pairs(EspConnects) do
		Connection:Disconnect()
	end
end)
loadfinish()--其他结束->加载完成信息
Notify("加载完成", "已成功加载")
--Tab界面
local Tab = Window:MakeTab({
    Name = "主界面",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Del = Window:MakeTab({
    Name = "删除",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Esp = Window:MakeTab({
    Name = "透视",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local others = Window:MakeTab({
    Name = "其他",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
--子界面
local Section = Tab:AddSection({
    Name = "实体"
})
Tab:AddToggle({
    Name = "实体提醒",
    Default = true,
    Flag = "NotifyEntities",
    Save = true
})
local Section = Tab:AddSection({
    Name = "交互"
})
Tab:AddToggle({ -- 轻松交互
    Name = "轻松交互",
    Default = true,
    Callback = function(Value)
        if Value then
            ezinst = true
            task.spawn(function()
                while ezinst do
                    for _, toezInteract in pairs(workspace:GetDescendants()) do
                        if toezInteract:IsA("ProximityPrompt") then
                            toezInteract.HoldDuration = "0.01"
                            toezInteract.RequiresLineOfSight = false
                            toezInteract.MaxActivationDistance = "11.5"
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
Tab:AddToggle({ -- 轻松交互
    Name = "自动交互",
    Default = false,
    Callback = function(Value)
        if Value then
            autoinst = true
            task.spawn(function()
                while autoinst do -- 交互-循环
                    for _, descendant in pairs(workspace:GetDescendants()) do
                        local parentModel = descendant:FindFirstAncestorOfClass("Model")
                        if descendant:IsA("ProximityPrompt") and not table.find(noautoinst, parentModel.Name) then
                            descendant:InputHoldBegin()
                        end
                    end
                    task.wait(0.05)
                end
            end)
        else
            autoinst = false
        end
    end
})
local Section = Tab:AddSection({
    Name = "相机"
})
Tab:AddToggle({ -- 保持广角
    Name = "保持广角",
    Default = true,
    Callback = function(Value)
        if Value then
            keep120fov = true
            task.spawn(function()
                while game.Workspace.Camera.FieldOfView ~= "120" and keep120fov do
                    game.Workspace.Camera.FieldOfView = "120"
                    task.wait()
                end
            end)
        else
            keep120fov = false
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
                while FullBrightLite do
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
local Section = Tab:AddSection({
    Name = "其他"
})
Tab:AddButton({
    Name = "再来一局",
    Callback = function()
        Notify("再来一局","请稍等...")
        RemoteFolder.PlayAgain:FireServer()
    end
})
Tab:AddSlider({
    Name = "玩家透明度",
    Min = 0,
    Max = 1,
    Default = 0,
    Increment = 0.05,
    Callback = function(Value)
        for _, humanpart in pairs(Character:GetChildren()) do
            if humanpart:IsA("MeshPart") then
                humanpart.Transparency = Value
            end
        end
    end
})
Tab:AddToggle({ -- 玩家提醒
    Name = "玩家提醒",
    Default = true,
    Flag = "PlayerNotifications"
})
Del:AddToggle({
    Name = "删除z564",
    Default = true,
    Flag = "noBouncer",
    Save = true
})
Del:AddToggle({
    Name = "删除z565",
    Default = true,
    Flag = "noSkeletonHead",
    Save = true
})
Del:AddToggle({
    Name = "删除z566",
    Default = true,
    Flag = "noStatueRoot",
    Save = true
})
Esp:AddToggle({ -- door
    Name = "门透视",
    Default = true,
    Callback = function(Value)
        if Value then
            for _, themodel in pairs(workspace:GetDescendants()) do
                if themodel:IsA("Model") and themodel.Parent.Name == "Entrances" and themodel.Name == "CryptDoor" then
                    createBilltoesp(themodel,"门", Color3.new(0,1,0),true)
                end
                if themodel:IsA("Model") and themodel.Parent.Name == "Entrances" and themodel.Name == "GraveyardGate" then
                    createBilltoesp(themodel,"大门", Color3.new(0,1,0),true)
                end
            end
            local esp = workspace.DescendantAdded:Connect(function(themodel)
                if themodel:IsA("Model") and themodel.Parent.Name == "Entrances" and themodel.Name == "CryptDoor" then
                    createBilltoesp(themodel,"门", Color3.new(0,1,0),true)
                end
                if themodel:IsA("Model") and themodel.Parent.Name == "Entrances" and themodel.Name == "GraveyardGate" then
                    createBilltoesp(themodel,"大门", Color3.new(0,1,0),true)
                end
            end)
            table.insert(EspConnects,esp)
        else
            unesp("门")
            unesp("大门")
        end
    end
})
Esp:AddToggle({ -- 钱
    Name = "钱透视(待做)",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("5Currency", "5钱", "1", "1", "1",false)
            espmodel("10Currency", "10钱", "1", "1", "1",false)
            espmodel("15Currency", "15钱", "0.5", "0.5", "0.5",false)
            espmodel("20Currency", "20钱", "1", "1", "1",false)
            espmodel("25Currency", "25钱", "1", "1", "0",false)
            espmodel("50Currency", "50钱", "1", "0.5", "0",true)
            espmodel("100Currency", "100钱", "1", "0", "1",true)
            espmodel("200Currency", "200钱", "0", "1", "1",true)
            espmodel("Relic", "500钱", "0", "1", "1",true)
        else
            unesp("5钱")
            unesp("10钱")
            unesp("15钱")
            unesp("20钱")
            unesp("25钱")
            unesp("50钱")
            unesp("100钱")
            unesp("200钱")
            unesp("500钱")
        end
    end
})
Esp:AddToggle({ -- 实体
    Name = "实体透视",
    Default = true,
    Flag = "EntityEsp"
})
Esp:AddToggle({ -- 玩家
    Name = "玩家透视",
    Default = false,
    Callback = function(Value)
        for _, player in pairs(game.Players:GetPlayers()) do
            if Value then
                if player ~= game.Players.LocalPlayer then
                    createBilltoesp(player.Character, player.Name, Color3.new(238, 201, 0),false)
                end
            else
                if player.Character:FindFirstChildOfClass("BillboardGui") then
                    player.Character:FindFirstChildOfClass("BillboardGui"):Destroy()
                end
            end
        end
    end
})
local Section = others:AddSection({
    Name = "注入"
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
local Section = others:AddSection({
    Name = "删除(窗口)"
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
local Section = others:AddSection({
    Name = "加入"
})
others:AddButton({
    Name = "加入随机大厅",
    Callback = function()
        Notify("加入游戏", "尝试加入中")
        TeleportService:Teleport(12411473842)
    end
})
others:AddTextbox({
    Name = "使用UUID加入游戏",
    Callback = function(jobId)
        local function failtp()
            Notify("加入失败", "若UUID正确则可能对应的服务器为预留服务器")
            warn("加入游戏失败!")
        end
        Notify("加入游戏", "尝试加入中")
        TeleportService:TeleportToPlaceInstance(12552538292, jobId, Players.LocalPlayer)
        TeleportService.TeleportInitFailed:Connect(failtp)
    end
})
local Section = others:AddSection({
    Name = "关于"
})
others:AddLabel("此服务器上的游戏ID为:" .. game.GameId)
others:AddLabel("此服务器上的游戏版本为:version_" .. game.PlaceVersion)
others:AddLabel("此服务器位置ID为:" .. game.PlaceId)
others:AddParagraph("此服务器UUID为:", game.JobId)
others:AddLabel("版本:Raveyard_" .. Ver)
workspaceDA = workspace.DescendantAdded:Connect(function(inst) -- 其他
    if inst.Name == "Bouncer" then -- 无环境伤害
        if OrionLib.Flags.EntityEsp.Value then -- 实体esp
            createBilltoesp(inst, inst.Name, Color3.new(1, 0, 0), true)
        end
        if OrionLib.Flags.NotifyEntities.Value and OrionLib.Flags.noBouncer.Value == false then
            entityNotifi("z564出现")
        elseif OrionLib.Flags.noBouncer.Value then
            task.wait(0.1)
            inst:Destroy()
            delNotifi("z564")
        end
    end
    if inst.Name == "SkeletonHead" then
        if OrionLib.Flags.EntityEsp.Value then -- 实体esp
            createBilltoesp(inst, inst.Name, Color3.new(1, 0, 0), true)
        end
        if OrionLib.Flags.NotifyEntities.Value and OrionLib.Flags.noSkeletonHead.Value == false then
            entityNotifi("z565出现")
        elseif OrionLib.Flags.noSkeletonHead.Value then
            task.wait(0.1)
            inst:Destroy()
            delNotifi("z565")
        end
    end
    if inst.Name == "StatueRoot" then
        if OrionLib.Flags.EntityEsp.Value then -- 实体esp
            createBilltoesp(inst, inst.Name, Color3.new(1, 0, 0), true)
        end
        if OrionLib.Flags.NotifyEntities.Value and OrionLib.Flags.noStatueRoot.Value == false then
            entityNotifi("z566出现")
        elseif OrionLib.Flags.noStatueRoot.Value then
            task.wait(0.1)
            inst:Destroy()
            delNotifi("z566")
        end
    end
end)
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
