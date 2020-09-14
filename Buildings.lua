
--Lisit of buildings

--Cheap values for the town. When adding more towns, this list will be superseeded.


function construction_complete(b)
  b.outside= b.oldoutside
  b.inside= b.oldinside
  b.btype = b.oldtype
  if b.btype == 'home' then
    b.doorx = b.x + (b.w / 2)
    b.doory = b.y + 900
    add_interior_objects(b, 'bed', 'bed2', b.x+math.random(10,b.w/2-Image_table['bed2']:getWidth()), b.y+math.random(150,b.h-Image_table['bed2']:getHeight()))
  end
end


function create_building_object(btype, outside, inside, doorwidth, maxworkers, occupied, entry, job, backyard, health, constructionimage)
  local i = 0
  local building = {}
  if health == nil then
    building.health = 1000
  else
    building.health = health
  end
  building.job = job
  building.btype = btype
  building.outside = outside
  building.inside = inside
  building.image= building.outside
  print('const',constructionimage)
  if constructionimage == nil then
    building.constructionimage = outside
  else
    building.constructionimage = constructionimage
  end
  building.w = Image_table[building.outside]:getWidth()
  building.h = Image_table[building.outside]:getHeight()
  
  if backyard == nil then
    backyard = 0
  end
  building.backyard = backyard
  building.maxworkers = maxworkers
  building.workers = {}
  building.interiors={}
  building.occupants = {}
  building.entry = entry
  return (building)
end



function create_basic_town(x, y, name)
  --Create the town blocks
  --local size = 0--10000
  --local x
  --local y
  --local count = 0
  --x=-size
  --y=-size
  --while y < size do
    --while x < size do
      --print(x, y)
      --create_environment2("empty",x,y)
      --print(count)
      --count= count+1
      --x = x + 10000
      --end
    --y= y+10000
    --x = -size
    
  --end
  if name == nil then
    name = 'town' .. #towns
  end
  
  towns[name] = {}
  towns[name].x = x
  towns[name].y = y
  towns[name].townname=name
  print('new town created: ',towns[name].townname)
  print('Total towns: ', #towns)
  create_environment2("empty",x,y, towns[name])
  create_environment2("empty",x+10000,y, towns[name])
  --Buildings for the town!
  
  --homes
  tentgroup = {'blue','brown','cyan','gold','green','purple','red','tan'}
  local count = 1
  while count ~= 7 do
    local colour = math.random(1, #tentgroup)
    local building = create_building("home",tentgroup[colour].."tentoutside",tentgroup[colour].."tentinside",0, 0, math.random(125,650), math.random(0,500), 125, 0, false, true, 'unemployed', 150, 100, name)
    if building ~= nil then
      print('tent loc',building.x, building.y)
      building.housetype = 'tent'
    end
    count=count+1
  end
  

  
  
  --Work  buildings
  farm = create_building("farm","farm1","farm1",0, 0, 125, 0, 125, 1, false, true, 'farmer',0,0, name)
  farm = create_building("farm","farm1","farm1",0, 0, 125, 0, 125, 1, false, true, 'farmer',0,0, name)
  
  
  trading_caravan = create_building("trader","trader1outside","trader1inside",0, 0, 125, 0, 125, 1, false, true, 'trader', 120,0, name)
  townhall = create_building("townhall","townhall1outside","townhall1inside",0, 0, 125, 0, 125, 1, false, true, 'mayor',0,0, name)
  crafttent = create_building("crafter","Crafter1outside",'Crafter1inside',0, 0, 125, 0, 125, 1, false, true, 'crafter',0,0, name)
  sawmill = create_building("sawmill","Sawmill1outside","Sawmill1inside",0, 0, 125, 0, 125, 1, false, true, 'woodcutter',0,0, name)
  
  
  
  --Recreation buildings
  park = create_building("park","Park1","Park1",0, 0, 125, 0, 125, 0, false, true, '',0,0, name)
  
  --Add people
  local ppcount = 1
  for o, b in ipairs(Buildinglist) do
    if b.btype == 'home' then
      create_NPC("NPC1", b, 'I have no parents. I came to be out of sheer willpower, with an urge to develop this town. I am an original.', nil, 0, 0, name)
    end
  end
end



function create_building(btype, outside, inside, x, y, offsetx, offsety, doorwidth, maxworkers, occupied, entry, job, backyard, health, townname)
  local i = 0
  building = {}
  if health == nil then
    building.health = 1000
  else
    building.health = health
  end
  building.job = job
  building.btype = btype
  building.outside = outside
  building.inside = inside
  building.image= building.outside
  building.w = Image_table[building.outside]:getWidth()
  building.h = Image_table[building.outside]:getHeight()-- - 50
  local count = 0
  local loc
  while count < 100 do
    count = count + 1
    local blockchoice = math.random(1, #towns[townname])
    for i, v in ipairs(towns[townname]) do

      if i == blockchoice then
        building.x = math.random(v.x, 10000)
        building.y = math.random(v.y, 10000)
        loc = v
        if check_for_build_collusion(building, Buildinglist) then
          if check_for_town_land(building, towns[townname]) then
            count = 101
          end
        end
      end
    end
  end
  if count == 100 then
    return
  end
  if backyard == nil then
    backyard = 0
  end
  building.backyard = backyard
  building.doorx = building.x + (building.w / 2)
  building.doory = building.y + 900
  building.maxworkers = maxworkers
  building.workers = {}
  building.interiors={}
  if building.btype == 'home' then
    add_interior_objects(building, 'bed', 'bed2', building.x+math.random(10,building.w/2-Image_table['bed2']:getWidth()), building.y+math.random(150,building.h-Image_table['bed2']:getHeight()))
  end
  building.occupants = {}
  building.entry = entry
  --table.insert(Buildinglist, building)
  table.insert(loc.field, building)
  table.insert(Buildinglist, building)
  return (building)
end





function add_interior_objects(building, objecttype, image, x, y)
  interobj = {}
  interobj.type = objecttype
  interobj.x = x
  interobj.y = y
  interobj.image = image
  interobj.w =Image_table[image]:getWidth()
  interobj.h =Image_table[image]:getHeight()
  if interobj.type == 'bench' then
    interobj.seats = {'unoccupied','unoccupied','unoccupied'}
  end
  table.insert(building.interiors,interobj)
end
  




function create_random_workplace(townname)
  local num = math.random(1, 6)
  local b
  if num <=2 then
    b= create_building("farm","farm1","farm1",x, y, 125, 0, 125, 1, false, true,'farmer',0,0,townname)
  elseif num ==3 then
    b= create_building("minehut","Minehut1outside","Minehut1inside",0, 0, 125, 0, 125, 1, false, true, 'stonecutter',0,0,townname)
  elseif num ==4 then
    b=create_building("crafter","Crafter1outside","Crafter1inside",x, y, 125, 0, 125, 1, false, true,'crafter',0,0,townname)
  elseif num ==5 then
    b=create_building("sawmill","Sawmill1outside","Sawmill1inside",x, y, 125, 0, 125, 1, false, true,'woodcutter',0,0,townname)
  elseif num ==6 then
    b=create_building("Guardhouse","Guardhouseoutside","Guardhouseinside",x, y, 125, 0, 125, 3, false, true,'Guard', 100,0,townname)
  end
  return b
end

