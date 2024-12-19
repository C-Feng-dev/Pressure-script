--Grace  
Connects = {}
noautoinst = {}
Players = game:GetService("Players") -- 玩家服务
RS = game:GetService("ReplicatedStorage")
Character = Players.LocalPlayer.Character -- 本地玩家Character
humanoid = Character:FindFirstChild("Humanoid") -- 本地玩家humanoid
PlayerGui = Players.LocalPlayer.PlayerGui--本地玩家PlayerGui
function createBilltoesp(theobject,name,color,hlset) -- 创建BillboardGui-颜色:Color3.new(r,g,b)
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
    --[[if hlset then
        hl = Instance.new("Highlight",PlayerGui)
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
    end)]]
end
function unesp(name) -- unEsp物品用
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
function teleportPlayerTo(toPositionVector3) -- 传送玩家-Vector3.new(x,y,z)
    if Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = toPositionVector3
    end
end
function chatMessage(chat) -- 发送信息
    game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(tostring(chat))
end
function NotifiEntity(inst,EntityName,NotifyName,mode,delflag)
    if mode == "spawn" then
        if inst.Name == EntityName and OrionLib:IsRunning() then
            if delflag then
                Notify("实体删除",NotifyName .. "已被删除")
            elseif OrionLib.Flags.NotifyEntities.Value then
                Notify("实体提醒",NotifyName .. "出现")
            end        
            if OrionLib.Flags.chatNotifyEntities.Value then
                chatMessage(NotifyName .. "出现")
            end
        end
    elseif mode == "remove" then
        if inst.Name == EntityName and OrionLib:IsRunning() then
            if OrionLib.Flags.NotifyEntities.Value then
                if delflag then
                    Notify("实体删除",NotifyName .. "已被删除")
                else
                    Notify("实体提醒",NotifyName .. "消失")
                end
            end        
            if OrionLib.Flags.chatNotifyEntities.Value then
                chatMessage(NotifyName .. "消失")
            end
        end
    end
end
loadstring(game:HttpGet('https://raw.githubusercontent.com/C-Feng-dev/My-own-Script/refs/heads/LinoriaLib-Gui/Script/Place-Script/Grace/Main.lua'))()