util.AddNetworkString("NPCROLL")
util.AddNetworkString("resultatspin")
util.AddNetworkString("BUYSPIN")

local function C_CreateTable()
    if not file.IsDir("npcspin", "DATA") then
        file.CreateDir("npcspin")
    end
end

hook.Add("PlayerSpawn", "Instaltable", function()
    C_CreateTable()
end)

local function Spawn(ply)
    if not file.IsDir("npcspin/" .. ply:SteamID64() , "DATA") then
        file.CreateDir("npcspin/" .. ply:SteamID64())
    end
    if file.Exists("npcspin/" .. ply:SteamID64() .. "/spin.txt", "DATA") then
        local read = file.Read("npcspin/" .. ply:SteamID64() .. "/spin.txt", "DATA")
        ply:SetNWInt("Tokens", tonumber(read))
    else
        file.Write("npcspin/" .. ply:SteamID64() .. "/spin.txt")
        ply:SetNWInt("Tokens", 2)
    end
end

hook.Add("PlayerInitialSpawn", "SPAWN_LUCAS", Spawn)

net.Receive("NPCROLL", function(len, ply)
    if ply:GetNWInt("Tokens") <= 0 then 
        ply:ChatPrint("Vous n'avez plus de spin !") -- Message when you don't have enough spins
        return 
    end
    file.Write("npcspin/" .. ply:SteamID64() .. "/spin.txt", (ply:GetNWInt("Tokens") or 1) -1)
    ply:SetNWInt("Tokens", (ply:GetNWInt("Tokens") - 1))

    ply:ChatPrint("Vous avez spin votre magie !") -- Message when you successfuly spin 

    local magies = {"du Feu", "de la Glace", "de l'Air", "de l'Eau"} -- Edit Here what you want to spin

    local value = math.random(1,#magies)

	local picked_value = magies[value]

    local magie = {
        magie = picked_value,
        spin = ply:GetNWInt("Tokens")
    }

    local converted = util.TableToJSON(magie)
    file.Write("npcspin/" .. ply:SteamID64() .. "/magic.json", converted)
	net.Start("resultatspin")
      net.WriteString(picked_value)
    net.Send(ply)
end)

net.Receive("BUYSPIN", function(len, ply)
    if ply:getDarkRPVar("money") < 50000 then
        ply:ChatPrint("Vous n'avez pas assez.") -- Message when you don't have enough money to buy a spin
        return 
    end
    ply:addMoney(-50000) -- How much One Spin cost
    ply:ChatPrint("Vous avez acheté un Spin !") -- Message when you buy a spin
    file.Write("npcspin/" .. ply:SteamID64() .. "/spin.txt", (ply:GetNWInt("Tokens") or 0) + 1)
    ply:SetNWInt("Tokens", (ply:GetNWInt("Tokens") or 0) + 1)
end)

local function FindPlayerByName(Name) 
    for k,v in pairs(player.GetAll()) do 
        if v:Nick() == Name then    
            return v 
        end
    end 
end 



local staffs = { -- YOU NEED TO PUT YOUR STAFF GROUPS WHO CAN GIVE SPINS HERE
    ["superadmin"] = true, 
}
concommand.Add("addspin", function(ply, spin, args )
if not staffs[ply:GetUserGroup()] then 
    ply:ChatPrint("Vous n'êtes pas superadmin !") -- YOU HAVE TO PUT THIS TO : You're not superadmin !
    return 
end

    local targ = FindPlayerByName(args[1])
    if targ == nil then
        ply:ChatPrint("Pseudo invalide ou joueur déconnecté") -- MESSAGE IF THE PLAYER NAME IS INCORRECT OR DECONNECTED
        return
    end

    file.Write("npcspin/" .. targ:SteamID64() .. "/spin.txt", (targ:GetNWInt("Tokens") or 0) + (tonumber(args[2]) or 0))
    targ:SetNWInt("Tokens", (targ:GetNWInt("Tokens") or 0) + (tonumber(args[2]) or 0))
    ply:ChatPrint("Vous avez ajouté " .. args[2] .. " spins magie à " .. targ:Nick() .. ".")
    targ:ChatPrint("Vous avez reçu " .. args[2] .. " spins de magie.")
end)
