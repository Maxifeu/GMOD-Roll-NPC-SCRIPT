local font = "Open Sans" || "Titillium Web"
surface.CreateFont("font_new_1", {font = font, size = 16})
include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

function OpenNPCUI()
	local scrw, scrh = ScrW(), ScrH()
    local actu = 0

    local npcuimg = vgui.Create("DFrame")
    npcuimg:SetPos(scrw * .3, scrh * .2)
    npcuimg:SetSize(400, 200)
    npcuimg:SetTitle("")
    npcuimg:Center()
    npcuimg:SlideDown(0.25)
    npcuimg:ShowCloseButton(false)
    npcuimg:MakePopup()
    npcuimg.Paint = function(pan, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
        draw.RoundedBox(0, 0, 0, w, 40, Color(50, 50, 50))
        surface.SetDrawColor(25, 25, 25)
        surface.DrawOutlinedRect(0, 0, w, h, 5)
        draw.SimpleText( "Vos Spins : " .. LocalPlayer():GetNWInt("Tokens"), "font_new_1", 310, 143, Color( 255, 255, 255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    local npcuimgclose = vgui.Create("DImageButton", npcuimg)
    npcuimgclose:SetPos(365, 10)
    npcuimgclose:SetSize(25, 25)
    npcuimgclose:SetImage("nano/npc/croix.png")
    npcuimgclose.DoClick = function()
        npcuimg:Close()
    end

    local npcuirollbutt = vgui.Create("DButton", npcuimg)
    npcuirollbutt:SetPos(25, 130)
    npcuirollbutt:SetSize(100, 30)
    npcuirollbutt:SetText("")
    npcuirollbutt.Paint = function(pan, w, h)
        draw.SimpleText( "Spin", "font_new_1", w / 2, h /2, Color( 255, 255, 255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.RoundedBox(0, 0, 0, w, h, (pan:IsDown() and Color( 0, 68, 145, 155) ) or ( pan:IsHovered() and Color( 0, 74, 182, 155) ) or Color( 0, 132, 255, 82))
        draw.RoundedBox(0, 1, 1, w-2, h-2, (pan:IsDown() and Color( 0, 68, 145, 155) ) or ( pan:IsHovered() and Color( 0, 74, 182, 155) ) or Color( 0, 132, 255, 82))
    end 
    npcuirollbutt.DoClick = function()
        net.Start("NPCROLL")
        net.SendToServer()
        npcuimg:Close()
    end

    local npcuimgnom = vgui.Create("DLabel", npcuimg)
    npcuimgnom:SetPos(178, 10)
    npcuimgnom:SetSize(100, 20)
    npcuimgnom:SetText("Spin Magie")

    local npcuirollbuttbuy = vgui.Create("DButton", npcuimg)
    npcuirollbuttbuy:SetPos(25, 65)
    npcuirollbuttbuy:SetSize(100, 30)
    npcuirollbuttbuy:SetText("")
    npcuirollbuttbuy.Paint = function(pan, w, h)
        draw.SimpleText( "Acheter un Spin", "font_new_1", w / 2, h /2, Color( 255, 255, 255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.RoundedBox(0, 0, 0, w, h, (pan:IsDown() and Color( 0, 68, 145, 155) ) or ( pan:IsHovered() and Color( 0, 74, 182, 155) ) or Color( 0, 132, 255, 82))
        draw.RoundedBox(0, 1, 1, w-2, h-2, (pan:IsDown() and Color( 0, 68, 145, 155) ) or ( pan:IsHovered() and Color( 0, 74, 182, 155) ) or Color( 0, 132, 255, 82))
    end
    npcuirollbuttbuy.DoClick = function(s) 
        net.Start("BUYSPIN")
        net.SendToServer()
    end
end

local function ResultatSpin(argument)
    local resspin = vgui.Create("DFrame")
    resspin:SetSize(400, 200)
    resspin:Center()
    resspin:SetTitle("")
    resspin:MakePopup()
    resspin:ShowCloseButton(false)

    local npcuirollspinres = vgui.Create("DLabel", resspin)
    npcuirollspinres:SetPos(108, 90)
    npcuirollspinres:SetSize(300, 30)
    npcuirollspinres:SetText("")
    npcuirollspinres.Paint = function(pan, w, h)
        draw.SimpleText("Vous contrôlez la magie " .. argument .. ".", "font_new_1")
    end

    function resspin:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
        draw.RoundedBox(0, 0, 0, w, 40, Color(50, 50, 50))
        surface.SetDrawColor(25, 25, 25)
        surface.DrawOutlinedRect(0, 0, w, h, 5)
    end
    local resspinname = vgui.Create("DLabel", resspin)
    resspinname:SetPos(178, 10)
    resspinname:SetSize(200, 20)
    resspinname:SetText("Spin Magie")

    local resspinclose = vgui.Create("DImageButton", resspin)
    resspinclose:SetPos(365, 10)
    resspinclose:SetSize(25, 25)
    resspinclose:SetImage("nano/npc/croix.png")
    resspinclose.DoClick = function()
        resspin:Close()
    end
end

net.Receive("resultatspin", function()
    local picked_value = net.ReadString()
    ResultatSpin(picked_value)
end)

net.Receive("NPCUI", OpenNPCUI)