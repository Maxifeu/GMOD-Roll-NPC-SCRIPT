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
        ply:ChatPrint("Vous n'avez plus de spin !")
        return 
    end
    file.Write("npcspin/" .. ply:SteamID64() .. "/spin.txt", (ply:GetNWInt("Tokens") or 1) -1)
    ply:SetNWInt("Tokens", (ply:GetNWInt("Tokens") - 1))

    ply:ChatPrint("Vous avez spin votre magie !")

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
        ply:ChatPrint("Vous n'avez pas assez.")
        return 
    end
    ply:addMoney(-50000) -- How much One Spin cost
    ply:ChatPrint("Vous avez acheté un Spin !")
    file.Write("npcspin/" .. ply:SteamID64() .. "/spin.txt", (ply:GetNWInt("Tokens") or 0) + 1)
    ply:SetNWInt("Tokens", (ply:GetNWInt("Tokens") or 0) + 1)
end)