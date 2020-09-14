function tablefind(tab,el)
  for index, value in pairs(tab) do
      if value == el then
          return index
      end
  end
end

function getmiddle(object)
  local middlex = object.x + (object.w/2)
  local middley = object.y + (object.h/2)
  return(middlex),(middley)
end

function DeepCopy( Table, Cache ) -- Makes a deep copy of a table. 
    if type( Table ) ~= 'table' then
        return Table
    end

    Cache = Cache or {}
    if Cache[Table] then
        return Cache[Table]
    end

    local New = {}
    Cache[Table] = New
    for Key, Value in pairs( Table ) do
        New[DeepCopy( Key, Cache)] = DeepCopy( Value, Cache )
    end

    return New
end


function savegame()
  savedata = {days, daytime,player1,ListofNPCs, #envirolist, towns, enviro_coords, grounditemslist, world}
  
  --Removes issues with the data such as circular references
  print('removing circular data')
  remove_images(savedata)
  --Saves easy values
  print('saving day and daytime')
  love.filesystem.write("days.txt", lume.serialize(days))
  love.filesystem.write("daytime.txt", lume.serialize(daytime))
  print('Saving the number of environments, enviro_cords, and which world is in')
  love.filesystem.write("mainworldnum.txt", lume.serialize(#mainworlds))
  love.filesystem.write("envnum.txt", lume.serialize(#envirolist))
  love.filesystem.write("envirocords.txt", lume.serialize(enviro_coords))
  love.filesystem.write("world.txt", lume.serialize(world))
  --Saves the NPCs, but not before debugging any potential issues they may have
  print('testing NPCs')
  for i,v in ipairs(ListofNPCs) do
    print(v.name, v.job)
    lume.serialize(v)
  end
  print('saving NPCs')
  love.filesystem.write("NPCs.txt", lume.serialize(ListofNPCs))
  --Saves the player
  print('saving player')
  love.filesystem.write("player.txt", lume.serialize(player1))
  print('saving town')
  love.filesystem.write("town.txt", lume.serialize(towns))
  print('saving ground items')
  love.filesystem.write("Grounditems.txt", lume.serialize(grounditemslist))
  
  
  --saving all current world chunks
  for o,b in ipairs(mainworlds) do
    for i,v in ipairs(envirolist) do
      print(o,i)
      if v.amount ~= #v.field then
        love.filesystem.write(b.x..b.y.."savedata"..i..'.txt', lume.serialize(v))
      end
    end
  end
  loadgame()
end

function loadgame()
  days = lume.deserialize(love.filesystem.read("days.txt"))
  daytime = lume.deserialize(love.filesystem.read("daytime.txt"))
  mainworldnum = lume.deserialize(love.filesystem.read('mainworldnum.txt'))
  envirolistnum = lume.deserialize(love.filesystem.read("envnum.txt"))
  player1 = lume.deserialize(love.filesystem.read("player.txt"))
  ListofNPCs = lume.deserialize(love.filesystem.read("NPCs.txt"))
  towns= lume.deserialize(love.filesystem.read("town.txt"))
  enviro_coords = lume.deserialize(love.filesystem.read("envirocords.txt"))
  grounditemslist = lume.deserialize(love.filesystem.read("Grounditems.txt"))
  world = lume.deserialize(love.filesystem.read("world.txt"))
  
  print('howdyho')
  return_images(ListofNPCs)
  envirolist={}
  mainworlds = {}
end


function startgame()
  world = 'menu'
  detail = 'high'
  armouravailable = {}
  foodavailable = false
  enviro_coords = {}
  treelist = {}
  ListofNPCs = {}
  CloseNPCs = {}
  FarNPCs = {}
  NPC_timer = 0
  Buildinglist ={}
  towns = {}
  --townblocklist={}
  --townblocklist.x=0
  --townblocklist.y=0
  --townblocklist.enviro={}
  NamesforNPC ={'Anjuni','Anj','Alec','Alex','Andrew', 'Anna', 'Allie','Ally','Alice', 'Angela', 'Angie', 'Ange', 'Ash', 'Ashley','Alexa','Bart','Barry','Beth','Bec','Byron','Charlie','Charles','Catherine', 'Colin','Caiti','Dave','David','Davo','Dex','Demetri','Darren','Dazza','Davina','Elizabeth','Ed','Eddy','Eddie','Edward', 'Eve', 'Evie', 'Emily','Fred','Francine','Franco','Fran','Frannie','Frank', 'George', 'Gina', 'Garry','Gaz','Holly','Hol','Harry','Helen','Helina','Helsey','Helsing','Hazza','Izz','Izzy','Isobel','Inesh','Inesha','Imitri','Joule', 'Jones','Joelle','James', 'Justin','Jimmy','Jack','Jaki','Jacko','Jazza','Jasmine','Jax','Jerry','Kevin','Ken','Kenny','Kendel','Katie','Katherine','Kelsie','Liz','Lez','Leslie','Big Lez', 'Larry', 'Lex', 'Lexie', 'Lavid', 'Murray','Mertle', 'Merkle', "Ned", 'Nellie','Orthello','Olivia', 'Octradox','Patsy','Patrick','Patricia','Perry','Pamela','Pam','Quintin','Rodney',"Rachel",'Rach','Rex','Stanley',"Sam",'Samantha','Sally','Selwin','Tim','Timithi','Ted','Ulysseus','Veronica','Victoria','Vectrix','Victrix','Wamo','Xsaviour','Yella','Zed','Zara'}
  mainworlds = {}
  drawscale=1
  viewdistance = 150000
  timer = 5
  
  create_basic_town(80000, 0, 'Cowstra')
  create_basic_town(-80000, 0, 'Anjali')
  --create_basic_town(80000, 0, 'Strawton')
  dirface = 1
  diroffset=0
  daytime = 0
  NPC_find_job()
  for i, v in ipairs(ListofNPCs) do
    if v.job == 'trader' then
      v.coins = 10000000000
      --table.insert(v.items,create_item(0,0, "hatchet", 5, 10, "hatchetitem", 100, false, 'hatchet', 10))
      table.insert(v.items,create_item(0,0, "hoe", 10, 10, "hoeitem", 100, false, 'hoe', 10))
      table.insert(v.items,create_item(0,0, "pickaxe", 5, 10, "pickaxeitem", 100, false, 'pickaxe', 10))
      table.insert(v.items,create_item(0,0, "fruit", 700, 1, "fruititem", 10, false,'food',20))
      table.insert(v.items,create_item(0,0, "knife", 10, 20, "knifeitem", 200, false, 'weapon'))
      table.insert(v.items,create_item(0,0, "hammer", 10, 10, "hammeritem", 100, false,'hammer',100))
      --table.insert(v.items,create_item(0,0, "hatchet", 5, 10, "hatchetitem", 100, false, 'hatchet', 10))
      table.insert(v.items,create_item(0,0, "hatchet", 5, 10, "hatchetitem", 100, false, 'hatchet', 10))
    end
  end
  tradingon=false
  days=0
  speed=1
  
  --creatable buildings
  creatablebuildings= {}
  creatablebuildings['tent'] = create_building_object('home',"cyantentoutside","cyantentinside", 125, 0, false, true, 'unemployed', 150,1000,'tent_construction')


  local everything = 120000
  local left = -everything
  local right = -everything
  local chunksize = 10000 -- DONT CHANGE THIS ONE!
  while left < everything and right < everything do
    mainworlds = {}
    new_world_created(left,right,left+chunksize,right+chunksize)
    left = left+chunksize
    if left == everything then
      right = right+ chunksize
      left = -everything
    end
  end
  for i, v in ipairs(Buildinglist) do 
    if v.btype == 'townhall' then
      create_player(v.x+v.w/2, v.y+v.h/2)
      break
    end
  end
  for i, v in pairs(towns) do
    check_chunks_for_town(v.townname)
  end
end

function within(a,b,c)
  local shortest
  local largest
  if a > b then
    largest = a
    shortest = b
  elseif a < b then
    largest = b
    shortest = a
  else
    if c == a then 
      return true
    else
      return false
    end
  end
  if largest > c and shortest < c then
    return true
  else
    return false
  end
end

function coords_exist(list, x, y)
  for i,v in ipairs(list) do
    if v.x == x and v.y == y then
      return true
    end
  end
  return false
end

function coords_exist_towns(x, y)
  for o,b in pairs(towns) do
    for i, v in ipairs(towns[b.townname]) do
      if v.x == x and v.y == y then
        return true
      end
    end
  end
  return false
end

function coords_exist_towns_env(x, y)
  for o,b in pairs(towns) do
    for i, v in ipairs(towns[b.townname].enviro) do
      if v.x == x and v.y == y then
        return true
      end
    end
  end
  return false
end



function make_drawable()
  --empty table as will be completely altered
  local PeopleandBuildings ={}
  --collect NPC's and collect position + identity to distinguish from buildings
  for i,v in ipairs(ListofNPCs) do
    v.position = v.y + v.h
    v.identity = 'person'
    table.insert(PeopleandBuildings,v)
  end
  --collect buildings and collect position + identity to distinguish from NPCs
  for i,v in ipairs(Buildinglist) do
    v.position = v.y + v.h
    v.identity = 'building'
    table.insert(PeopleandBuildings,v)
  end
  for i,v in ipairs(player1.playerenvirolist) do
    if v.x >= player1.x - 10000 and v.x <= player1.x and v.y >=player1.y - 10000 and
    v.y <= player1.y then
      for o,b in ipairs(v.field) do
        b.position = b.y + b.h
        b.identity = 'env'
        table.insert(PeopleandBuildings, b)
      end
    end
  end
  --add yourself
  player1.position = player1.y + player1.h
  player1.identity = 'person'
  table.insert(PeopleandBuildings, player1)
  --Sort on the 'Z' axis (really just y+height
  table.sort(PeopleandBuildings,function(a,b)
    return a.position<b.position
  end)
  --Give table
  return PeopleandBuildings
end