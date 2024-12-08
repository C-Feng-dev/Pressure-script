if OrionLib and OrionLib:IsRunning() and TabFunction then
    local Window = TabFunction[1]
    local others = Window:MakeTab({
        Name = "其他",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
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
end