local others = Window:MakeTab({
    Name = "其他",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Section = others:AddSection({
    Name = "其他"
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
        OrionLib:Destroy()
    end
})
local Section = others:AddSection({
    Name = "关于"
})
others:AddLabel("此服务器上的游戏ID为:" .. game.GameId)
others:AddLabel("此服务器位置ID为:" .. game.PlaceId)
others:AddLabel("此服务器上的游戏版本为:version_" .. game.PlaceVersion)
others:AddParagraph("此服务器UUID为:", game.JobId)