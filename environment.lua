



function create_environment2(env_type, enx, eny, list)
  local envblock = {}
  envblock.field = {}
  envblock.x = enx
  envblock.y = eny
  envblock.env_type = env_type
  envblock.amount = false
  for o, b in pairs(towns) do
    for i, v in ipairs(b) do
      if v.x == envblock.x and v.y == envblock.y then
        return
      end
    end
  end
    
  if env_type=="empty" then
    envblock.image = 'emptybackground'
    table.insert(list,envblock)
  end
  if env_type=="lush" then
    envblock.image = 'lushbackground'
    create_tree_field(envblock)
    table.insert(list,envblock)
  end
end



function new_world_created(startingpointx, startingpointy, endpointx, endpointy)
  envirolist = {}
  envirolist.x = (startingpointx + endpointx)/2
  envirolist.y = (startingpointy + endpointy)/2
  local temp = {}
  temp.x = envirolist.x
  temp.y = envirolist.y
  
  local initialpointx = startingpointx
  
  while startingpointx ~= endpointx do
    create_environment2("lush", startingpointx, startingpointy, envirolist)
    startingpointx = startingpointx + 10000
    if startingpointx == endpointx and startingpointy ~= endpointy - 10000 then
      startingpointx = initialpointx
      startingpointy = startingpointy + 10000
    end
  end
  for i, v in ipairs(envirolist) do
    print(envirolist.x..envirolist.y.."savedata"..i)
    v.amount = #v.field
    love.filesystem.write(envirolist.x..envirolist.y.."savedata"..i..'.txt', lume.serialize(v))
  end
  table.insert(mainworlds, envirolist)
  print(#mainworlds, #envirolist)
  envirolistnum = #envirolist
  temp.num = #envirolist
  table.insert(enviro_coords, temp)
  print(temp.x, temp.y, '...........................................................................')
end
  
  
  
function enviro_for_player()
  
  local EPx = ((math.floor((player1.x)/1000))*1000)
  local EPy = ((math.floor((player1.y)/1000))*1000)
  
  local Wx = enviro_coords.ox
  local Wy = enviro_coords.oy
  
  if  EPx + 10000 > enviro_coords.x then
    while Wy <= enviro_coords.y do
      create_environment("lush", EPx + 10000, Wy)
      Wy = Wy + 10000
    end
  end
  
  if  EPx - 10000 < enviro_coords.ox then
    while Wy <= enviro_coords.y do
      create_environment("lush", EPx - 10000, Wy)
      Wy = Wy + 10000
    end
  end
  
  if  EPy + 10000 > enviro_coords.y then
    while Wx <= enviro_coords.x do
      create_environment("lush", Wx, EPy + 10000)
      Wx = Wx + 10000
    end
  end
  
    if  EPy - 10000 < enviro_coords.oy then
    while Wx <= enviro_coords.x do
      create_environment("lush", Wx, EPy - 10000)
      Wx = Wx + 10000
    end
  end
  
end  


function create_tree_field(envblock)
  local x = envblock.x
  local y = envblock.y
  
  repeat
    repeat
      object = {}
      local chance = math.random(1,100)
      if chance <= 20 then
        object.image = 'treeimage'
        object.weakness={'hatchet'}
        object.items={create_item(0, 0, 'logs', 10, 5, 'logsitem',1, false), create_item(0, 0, 'leaves', 10, 5, 'leavesitem',1, false)}
        object.property='tree'
      elseif chance > 70 and chance < 74 then
        object.image = 'rockimage'
        object.weakness={'pickaxe'}
        object.property='bigrock'
        object.items={create_item(0, 0, 'rocks', 1, 5, 'rocksitem',10, false)}
      elseif chance >76 and chance < 75 then ----Turned off
        object.image = 'pond1'
        object.weakness={}
        object.property='pond'
        object.items={}
        
      end
      if object.image ~= nil then
        object.x = x
        object.y = y
        object.w = Image_table[object.image]:getWidth()
        object.h = Image_table[object.image]:getHeight()
        object.health=500
        chance = math.random(1,100)
        table.insert(envblock.field, object)
      end
      y = y + 1000 --object image height
    until (y > envblock.y + 9999)
    y = envblock.y
    x = x + 1000 -- object image width
  until(x > envblock.x + 9999)
end

function check_blocks()
  for r, m in pairs(towns) do
    for e, d in ipairs(m.enviro) do
      for i, v in ipairs(d) do
        if #v.field == 0 then
          v.image = 'emptybackground'
          for q, w in ipairs(enviro_coords) do
            if w.x == v.x and w.y == v.y then
              table.remove(w, q)
            end
          end
          table.insert(towns[m.townname],v)
          table.remove(m.enviro,tablefind(m.enviro,v)) 
          table.remove(m.townenviro,tablefind(m.townenviro,v)) 
          table.remove(player1.playerenvirolist, tablefind(player1.playerenvirolist, v))
          table.remove(d,i)
        end
      end
    end
  end
end

function check_farms()
  for r, m in pairs(towns) do
    for i, v in ipairs(m) do
      for o, b in ipairs(v.field) do
        if b.btype == 'farm' then
          for e, d in ipairs(b.interiors) do
            if math.random(1,4) > 0 then
              if d.type == 'seeded' then
                d.type = 'seedling'
                d.image = 'dirtpile_seedling'
              elseif d.type == 'seedling' then
                d.type = 'fruit'
                d.image = 'dirtpile_fruit'
              end
            end
          end
        end
      end
    end
  end
end