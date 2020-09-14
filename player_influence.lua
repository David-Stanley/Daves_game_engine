---Providing something for player to craft





function craft_item(player, crafted_item)
  for i,v in ipairs(crafted_item.cost) do
    if not checkamount(player, i.item, i.num) then
      return
    end
  end
  
  table.insert(player.extra_inventory, crafted_item.item)
end
  
  


----For finding building right

function findplayerbuilding(player, item)
  local building = {}
  building = DeepCopy(creatablebuildings[item.specialvalue])
  building.x = player.x- creatablebuildings[item.specialvalue].w/2
  building.y = player.y- creatablebuildings[item.specialvalue].h/2
  building.w = creatablebuildings[item.specialvalue].w
  building.h = creatablebuildings[item.specialvalue].h
  building.possible = false
  if check_for_build_collusion(building, Buildinglist) and check_for_town_land(building, townblocklist) then
    building.possible = true
  end
  return building
end












---- For giving the player buildings

function buyland(player)
  if player.coins > 200 then
    for i, v in ipairs(townblocklist) do
      if #v.field == 0 then
        textbox = v
        textworld_text = 'Name your property! Press return once you have decided'
        whatswritten=''
        oldworld = 'mainworld'
        world = 'textworld'
        player.coins = player.coins-200
        print('success',v.x,v.y)
        table.insert(player.land, v)
        table.insert(v.field, create_building('sign', 'boughtsign', 'boughtsign', v.x, v.y, 500, 700, 0, 0, 0, false, 'none', 0))
        dialog.NPCtalk = {'Wonderful, the location of your new pot of land is at x '..v.x..' and y '..v.y}
        return
      end
    end
  else
    dialog.NPCtalk ={'Do not waste my time, get 200 coins and then ask me'}
  end
end

function buildonland(player, NPC, pbuilding)
  print(pbuilding.btype)
  local task = {}
  task.action = 'construction'
  task.x = pbuilding.x + (pbuilding.w/2)
  task.y = pbuilding.y + (pbuilding.h/2)
  task.construction = pbuilding
  task.countdown = pbuilding.health
  task.timeout = 1000
  player.construction.field = {}
  task.field = player.construction.field
  table.insert(NPC.plan, task)
end