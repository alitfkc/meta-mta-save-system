----------------------------------------
--Player quit ( - oyundan çıkma - )
----------------------------------------
function player_quit()
    local account = getPlayerAccount(source)
    if account then 
        local save_table = get_data(source)
        setAccountData(account,"meta:save_system",save_table)
        outputChatBox("geldi1")
    end
end
addEventHandler("onPlayerQuit",root,player_quit)


--------------------------------------------
--player login ( - hesaba  girme - )
--------------------------------------------
function player_login(_,account)
    if account then 
        local table = getAccountData(account,"meta:save_system")
        if table then 
            load_data(source,table)
        end
    end
end
addEventHandler("onPlayerLogin",root,player_login)

-------------------------------------------
-- save data ( - veri kaydet - )
-------------------------------------------
function get_data(player)
    source = player
    local skills = {}
    for i = 0,230 do 
        local value = getPedStat(source,i)
        table.insert(skills,{i,value})
    end
    local weapons = {}
    for i = 0,12 do 
        local weapon = getPedWeapon(source,i)
        local ammo =  getPedTotalAmmo (source,i)
        table.insert(weapons,{weapon,ammo})
    end
    local model = getElementModel(source)
    local health = getElementHealth(source)
    local armor = getPedArmor(source)
    local money = getPlayerMoney(source)
    local dimens = getElementDimension(source)
    local interior = getElementInterior(source)
    local _,_,rz = getElementRotation(source)
    local x,y,z = getElementPosition(source)
    local position = {x,y,z,rz}
    local save_table = {}
    save_table.skills = skills
    save_table.weapons = weapons
    save_table.model = model 
    save_table.health = health
    save_table.armor = armor
    save_table.money = money
    save_table.dimens = dimens
    save_table.interior = interior
    save_table.position = position
    save_table = toJSON(save_table)
    return save_table
end


----------------------------------------------------------------
-- load data ( - veriyi yükle - )
----------------------------------------------------------------
function load_data(player,table)
    source = player
    table = fromJSON(table)
    for k,v in ipairs(table.skills) do 
        setPedStat(source,v[1],v[2])
    end
    for k,v in ipairs(table.weapons) do 
        giveWeapon(source,v[1],v[2])
    end
    setElementModel(source,table.model)
    setElementHealth(source,table.health)
    setPedArmor(source,table.armor)
    setPlayerMoney(source,table.money)
    local x,y,z,rz = unpack(table.position)
    setElementPosition(source,x,y,z)
    setElementRotation(source,0,0,rz)
    setElementDimension(source,table.dimens)
    setElementInterior(source,table.interior)
end

----------------------------------------------------------------
--player wasted ( - oyuncu ölme - )
-----------------------------------------------------------------
local wasted_player = {}
addEventHandler("onPlayerWasted", root, function()
    wasted_player[source] =  get_data(source)
end)

addEventHandler("onPlayerSpawn", root, function()
    local table =  wasted_player[source]
    if table then 
        table = fromJSON(table)
        for k,v in ipairs(table.skills) do 
            setPedStat(source,v[1],v[2])
        end
        for k,v in ipairs(table.weapons) do 
            giveWeapon(source,v[1],v[2])
        end
        setElementModel(source,table.model)
    end

end)
