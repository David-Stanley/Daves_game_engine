function check_for_build_collusion(building, buildinglist)
  local a_left = building.x
  local a_right = building.x + building.w
  local a_top = building.y
  local a_bottom = building.y + building.h
  for i, v in ipairs(buildinglist) do
    local b_left = v.x - 200
    local b_right = v.x + v.w + 200 
    local b_top = v.y - 200
    local b_bottom = v.y + v.h + 200 
    
    if a_right > b_left and
        a_left < b_right and
        a_bottom > b_top and
        a_top < b_bottom then
      return(false)
    end
  end
  return(true)
end

function check_for_town_land(building, townblocklist)
  local point1check = false
  local point2check = false
  local point3check = false
  local point4check = false
  local point1 = {building.x, building.y}
  local point2 = {building.x+building.w, building.y}
  local point3 = {building.x, building.y+building.h}
  local point4 = {building.x+building.w, building.y+building.h}
  for i, v in ipairs(townblocklist) do
    local b_left = v.x
    local b_right = b_left + 10000
    local b_top = v.y
    local b_bottom = b_top + 10000
    if point1check == true then
    elseif point1[1]>b_left and point1[1] < b_right and point1[2] > b_top and point1[2] < b_bottom then
      point1check = true
    end
    
    if point2check == true then
    elseif point2[1]>b_left and point2[1] < b_right and point2[2] > b_top and point2[2] < b_bottom then
      point2check = true
    end
    
    if point3check == true then
    elseif point3[1]>b_left and point3[1] < b_right and point3[2] > b_top and point3[2] < b_bottom then
      point3check = true
    end
    
    if point4check == true then
    elseif point4[1]>b_left and point4[1] < b_right and point4[2] > b_top and point4[2] < b_bottom then
      point4check = true
    end
    if point1check == true and point2check == true and point3check == true and point4check == true then
      return true
    end
  end
  return false
end

function collision(xvalue, yvalue, wvalue, hvalue)
  local a_left = xvalue
  local a_right = a_left + wvalue
  local a_top = yvalue + hvalue/1.1
  local a_bottom = a_top - hvalue/2 + hvalue
    
  movement = true
  for i,v in ipairs(player1.playerenvirolist) do
    if v.x >= a_left - 10000 and v.x <= a_left + 10000 and v.y >= a_top - 10000 and v.y <= a_top + 10000 then
      for o,b in ipairs(v.field) do
        local b_left = b.x
        local b_right = b.x + b.w
        local b_bottom = b.y + b.h
        local b_top = b.y
        
        if b.property == 'tree' then
          b_left = b.x + 400
          b_right = b.x + 550
          b_top = b.y + 900
        elseif b.property == 'bigrock' then
          b_top = b.y +900
        end
          
        
        if a_right > b_left and
        a_left < b_right and
        a_bottom > b_top and
        a_top < b_bottom then
        return(false)
        end
      end
    end
  end

  for o,b in ipairs(Buildinglist) do
    b.image =  b.outside
    b.interior= false
    local b_left = b.x
    local b_right = b.x + b.w
    local b_bottom = b.y + b.h
    local b_top = b.y + b.backyard
      
    if a_right > b_left and
    a_left < b_right and
    a_bottom > b_top and
    a_top < b_bottom then
      movement = false
      
      if a_right > b_left + wvalue and
      a_left < b_right - wvalue and
      a_bottom > b_top + hvalue and
      a_top < b_bottom and b.entry == true then
        movement = true
        b.image = b.inside
        b.interior = true
        player1.loc = ''
      end
    end
  end
return(movement)
end

function playerenvtable(player, distance)
  if distance == nil then
    distance = 200000 --10000
  end
  player.playerenvirolist = {}
  local a_left = player1.x
  local a_right = a_left + player1.w
  local a_top = player1.y + player1.h/2
  local a_bottom = a_top - player1.h/2 + player1.h
  local envirolist = envirolistplayer
  if player.name == player1.name then
  local a_right = a_left + player1.w
  local a_top = player1.y + player1.h/2
  local a_bottom = a_top - player1.h/2 + player1.h
  local envirolist = envirolistplayer
  if player.name == player1.name then
    for e,d in ipairs(mainworlds) do
      for i,v in ipairs(d) do
        if v.x >= a_left - distance and v.x <= a_left + distance and v.y >= a_top - distance and v.y <= a_top + distance then
          table.insert(player.playerenvirolist, v)
        end
      end
    end
  else
    --player.playerenvirolist = townenviro
  end
end
end      

function nearest_collision(orgx, orgy,xvalue, yvalue, wvalue, hvalue)
  local a_left = xvalue
  local x = value
  local a_right = a_left + wvalue
  local a_top = yvalue
  local a_bottom = a_top + hvalue
    
  while true do
    for i,v in ipairs(player1.playerenvirolist) do
      if v.x >= a_left - 10000 and v.x <= a_left + 10000 and v.y >= a_top - 10000 and v.y <= a_top + 10000 then
        for o,b in ipairs(v.field) do
          local b_left = b.x
          local b_right = b.x + b.w
          local b_bottom = b.y + b.h
          local b_top = b.y
            
          if a_right > b_left and
          a_left < b_right and
          a_bottom > b_top and
          a_top < b_bottom then
          movement = false
          end
        end
      end
    end
    
    for i,v in ipairs(townblocklist) do
      if v.x >= a_left - 10000 and v.x <= a_left + 10000 and v.y >= a_top - 10000 and v.y <= a_top + 10000 then
        for o,b in ipairs(v.field) do
          b.image =  b.outside
          b.interior= false
          local b_left = b.x
          local b_right = b.x + b.w
          local b_bottom = b.y + b.h
          local b_top = b.y
            
          if a_right > b_left and
          a_left < b_right and
          a_bottom > b_top and
          a_top < b_bottom then
            movement = false
            
            
            local doorleft = b.doorx
            local doorright = b.doorox
            local doorbottom = b.y + b.h
            local doortop = b.y + b.h      
          


            
            
            
            
            if a_right > b_left + wvalue and
            a_left < b_right - wvalue and
            a_bottom > b_top + hvalue and
            a_top < b_bottom + hvalue and b.entry == true then
              movement = true
            end
          end
        end
      end
    end
  if movement == false then
    if orgx > 0 then
      if math.floor(orgx) - math.floor(xvalue) > 0 then
        xvalue = xvalue +1
        a_left = xvalue
        a_right = a_left + wvalue
      elseif math.floor(orgx) - math.floor(xvalue) < 0 then
        xvalue = xvalue -1
        a_left = xvalue
        a_right = a_left + wvalue
      end
    elseif orgx < 0 then
      if math.floor(orgx) - math.floor(xvalue) < 0 then
        xvalue = xvalue -1
        a_left = xvalue
        a_right = a_left + wvalue
      elseif math.floor(orgx) - math.floor(xvalue) > 0 then
        xvalue = xvalue +1
        a_left = xvalue
        a_right = a_left + wvalue
      end
    end
    if math.floor(orgx) - math.floor(xvalue) == 0 then
      return xvalue
    end
  end
  if movement == true then
    return xvalue
  end
  end
end

function nearest_collision2(orgx, orgy,xvalue, yvalue, wvalue, hvalue)
  local norgx = orgx
  local a_left = orgx
  local a_right = a_left + wvalue
  local a_top = yvalue
  local a_bottom = a_top + hvalue
  local movement = true
  while math.floor(orgx) ~= xvalue do
    for i,v in ipairs(envirolist) do
      if v.x >= a_left - 10000 and v.x <= a_left + 10000 and v.y >= a_top - 10000 and v.y <= a_top + 10000 then
        for o,b in ipairs(v.field) do
          local b_left = b.x
          local b_right = b.x + b.w
          local b_bottom = b.y + b.h
          local b_top = b.y
            
          if a_right > b_left and
          a_left < b_right and
          a_bottom > b_top and
          a_top < b_bottom then
            movement = false
          end
        end
      end
    end
    
    for i,v in ipairs(townblocklist) do
      if v.x >= a_left - 10000 and v.x <= a_left + 10000 and v.y >= a_top - 10000 and v.y <= a_top + 10000 then
        for o,b in ipairs(v.field) do
          local b_left = b.x
          local b_right = b.x + b.w
          local b_bottom = b.y + b.h
          local b_top = b.y
            
          if a_right > b_left and
          a_left < b_right and
          a_bottom > b_top and
          a_top < b_bottom then
            movement = false
            
            
            local doorleft = b.doorx
            local doorright = b.doorox
            local doorbottom = b.y + b.h
            local doortop = b.y + b.h      
          


            
            
            
            
            if a_right > b_left + wvalue and
            a_left < b_right - wvalue and
            a_bottom > b_top + hvalue and
            a_top < b_bottom + hvalue and b.entry == true then
              movement = true
            end
          end
        end
      end
    end
  if movement == false then
    return orgx
  end
  if movement == true then
    if math.floor(orgx) < math.floor(xvalue) then
      orgx = norgx
      norgx = norgx + 1
      local a_left = norgx
      local a_right = a_left + wvalue
    elseif math.floor(orgx) > math.floor(xvalue) then
      orgx = norgx
      norgx = norgx -1
      local a_left = norgx
      local a_right = a_left + wvalue
    else
      return orgx
    end
  end
  end
end





function NPC_collision(speed,xvalue, yvalue, wvalue, hvalue, targetx, targety, xorg, yorg, dt, NPC)
  local a_left = xvalue
  local a_right = a_left + wvalue
  local a_top = yvalue + hvalue/2
  local a_bottom = a_top - hvalue/2 + hvalue
      
  local o_left = xorg
  local o_right = o_left + wvalue
  local o_top = yorg + hvalue/2
  local o_bottom = o_top - hvalue/2 + hvalue
  
  for i,v in ipairs(towns[NPC.town]) do
      for o,b in ipairs(v.field) do
        local b_left = b.x
        local b_right = b.x + b.w
        local b_bottom = b.y + b.h
        local b_top = b.y
         
         
        --NPC suffers collision 
        if a_right > b_left and
        a_left < b_right and
        a_bottom > b_top and
        a_top < b_bottom then
          
          
          --Target is inside
          if a_right > b_left + wvalue and
          a_left < b_right - wvalue and
          a_bottom > b_top + hvalue and
          a_top < b_bottom + hvalue and b.entry == true and targetx < b_right and targetx > b_left and targety > b_top and targety < b_bottom then
            return {xvalue, yvalue}
            
          --In a collision but needs to go down to access building
        elseif targetx < b_right and targetx > b_left and targety > b_top and targety < b_bottom then
          return({xorg, yorg + speed * dt})
            
          --If stuck in collision, go down  
          elseif o_right > b_left and
          o_left < b_right and
          o_bottom > b_top and
          o_top < b_bottom then
            local angle = math.atan2((targety - yorg), (0))
            local yspeed = speed * math.sin(angle)
            return({xorg+ speed * dt, yvalue + speed * dt})
          
          elseif a_right > b_left and
        a_left < b_right then
            if targety < b.y then
              targety = b.y - hvalue
            else
              targety = b.y + b.h + hvalue
            end
            local angle = math.atan2((targety - yorg), (0))
            speed = speed * math.sin(angle)
            return({xorg, yorg + speed * dt})
            
          elseif a_bottom > b_top and
        a_top < b_bottom then
            if targetx < b.x then
              targetx = b.x - wvalue
            else
              targetx = b.x + b.w + wvalue
            end
            local angle = math.atan2(0 , (targetx- xorg))
            speed = speed * math.cos(angle)
            return({xorg - speed * dt, yorg})
          end
          

        
        end
      end
    end
    return({xvalue, yvalue})
  end
  
function findnearest(person, list)
  local result
  for i, v in ipairs(list) do
    if result == nil or math.abs(v.x - person.x) + math.abs(v.y - person.y) < result then
      closest = v
      result = math.abs(v.x - person.x) + math.abs(v.y - person.y)
    end
  end
  return(closest)
end

function findnearestwithtrait(person, list, trait)
  local result
  for i, v in ipairs(list) do
    for o, b in ipairs(v.field) do
      if b.property == trait then
        if result == nil or math.abs(b.x - person.x) + math.abs(b.y - person.y) < result then
          closest = b
          result = math.abs(b.x - person.x) + math.abs(b.y - person.y)
        end
      end
    end
  end
  return(closest)
end



function check_chunks()
  ---This function only loads in chunks near the player to save on ram
  
  --The radius that loads around the player
  local distance=80000
  local sdistance= distance/2
  
  --Iterate through mainworlds to find what no longer belongs.
  for i=#mainworlds,1,-1 do
    v=mainworlds[i]
    
    if v.x ~= nil and not (within(v.x, v.x+distance, player1.x+sdistance) and not within(v.y, v.y+distance, player1.y+sdistance)) and not coords_exist_towns_env(v.x,v.y) then
      for o,b in ipairs(v) do
        --if nothing has changed since chunk was last saved, no reason to overwrite data
        if b.amount ~= #b.field then
          love.filesystem.write(v.x..v.y.."savedata"..o..'.txt', lume.serialize(b))
        end
      end
      --Removing from list
      table.remove(mainworlds,i)
      i=i-1
    end
  end
  
  --Checks for unloaded chunks that need to be loaded in
  for num, v in ipairs(enviro_coords) do
    local templist
    --Check if chunk is near player and also not a part of a town
    if within(v.x, v.x+distance, player1.x+sdistance) and within(v.y, v.y+distance, player1.y+sdistance) and not coords_exist_towns(v.x,v.y) then
      
      --If mainworlds is empty, it needs to be replaced
      if #mainworlds == 0 then
        print('mainworlds is none')
        d = {}
        d.x = 'a'
        d.y = 'b'
        if d.x ~=v.x and d.y~=v.y then
          templist = {}
          i=1
          ---loads all blocks in chunk
          while i ~= v.num+1 do
            print('loading ',v.x, v.y)
            envblock = love.filesystem.read(v.x..v.y.."savedata"..i..'.txt')
            envblock = lume.deserialize(envblock)
            envblock.amount = #envblock.field
            table.insert(templist, envblock)
            if i ==1 then
              templist.x = v.x
              templist.y = v.y
            end
            i = i+1
          end
        end
      end
      if templist ~= nil then
        table.insert(mainworlds,templist)
      end
      if not coords_exist(mainworlds,v.x,v.y) then
        templist = {}
        i=1
        while i ~= v.num+1 do
          
          --print('loading ',v.x, v.y)
          envblock = love.filesystem.read(v.x..v.y.."savedata"..i..'.txt')
          envblock = lume.deserialize(envblock)
          
          envblock.amount = #envblock.field
          table.insert(templist, envblock)
          
          if i ==1 then
            templist.x = v.x
            templist.y = v.y
            
          end
          i = i+1
        end
      end
      if templist ~= nil then
        table.insert(mainworlds,templist)
      end
    end
  end
end

function check_chunks_for_town(townname)
  local distance=60000
  local sdistance= distance/2
  if towns[townname].enviro == nil then
    towns[townname].enviro = {}
  end
  for i=#mainworlds,1,-1 do
    v=mainworlds[i]
    
    if v.x == nil then
      break
    end
    --print(not (within(v.x, v.x+distance, player1.x+sdistance) and within(v.y, v.y+distance, player1.y+sdistance)))
    if within(v.x, v.x+distance, towns[townname].x+sdistance) and within(v.y, v.y+distance, towns[townname].y+sdistance) and notintowns(v.x, v.y) then
      print(v.x, v.y)
      table.insert(towns[townname].enviro, v)
    end
  end
  towns[townname].townenviro = {} --change later
  for i, v in ipairs(towns[townname].enviro) do
    for e,d in ipairs(v) do
      table.insert(towns[townname].townenviro,d)
    end
  end
end


function NPC_experimental_travel_2(NPC, task, dt)
  --Check if neccessary
  if NPC.loc == task.loc then
    return
  end
  NPC.maxspeed = NPC.maxspeed+(dt/100)
  ---NPC_collusion_values
  local a_left = NPC.x
  local a_right = NPC.x + NPC.w
  local a_top = NPC.y
  local a_bottom = NPC.y + NPC.h
  local speed = NPC.speed * dt
  
  --Check if on target
  --if task.x > a_left-3 and task.x < a_right+3 and task.y > a_top-3 and task.y < a_bottom+3 then
  if task.x > a_left - speed and task.x < a_right + speed and task.y < a_bottom + speed and task.y > a_top - speed then
    NPC.loc = task.loc
    return
  end
  
  ---Make feet move
  
  
  

  --if going around building
  if task.newx ~= nil and task.newy ~= nil then
    --Check if at loc
    if task.newx > a_left-3 and task.newx < a_right+3 and task.newy > a_top-3 and task.newy < a_bottom+3 then
      task.newx = nil
      task.newy = nil
      
      return
    end
    
    --Get angle
    angle = math.atan2((NPC.y - task.newy), (NPC.x - task.newx))
    
    --Get speed for x-axis
    NPC.xspeed = NPC.speed * math.cos(angle)
    
    --Direction
    if NPC.xspeed > 0 then 
      NPC.dirface = 1
      NPC.diroffset=0
      NPC.direction = 'left'
    elseif NPC.xspeed < 0 then 
      NPC.dirface = -1
      NPC.diroffset=NPC.w
      NPC.direction = 'right'
    end

    --Movement of the y-axis
    NPC.yspeed = NPC.speed * math.sin(angle)

    --New co-ordinate locations
    NPC.x = NPC.x - (NPC.xspeed * dt)
    NPC.y = NPC.y - (NPC.yspeed * dt)
    NPC_moving(NPC,dt)
    return
  end

  ---Default is outside
  NPC.loc = 'outside'

  --Get angle to move towards
  angle = math.atan2((NPC.y - task.y), (NPC.x - task.x))
  
  --Movement of the x-axis
  NPC.xspeed = NPC.speed * math.cos(angle)
  
  --Direction
  if NPC.xspeed > 0 then 
    NPC.dirface = 1
    NPC.diroffset=0
    NPC.direction = 'left'
  elseif NPC.xspeed < 0 then 
    NPC.dirface = -1
    NPC.diroffset=NPC.w
    NPC.direction = 'right'
  end
  
  --Movement of the y-axis
  NPC.yspeed = NPC.speed * math.sin(angle)
  
  --New co-ordinate locations
  Newx = NPC.x - (NPC.xspeed * dt)
  Newy = NPC.y - (NPC.yspeed * dt)
  
  --NPC_collusion_values_to_be
  local o_left = Newx
  local o_right = Newx + NPC.w
  local o_top = Newy
  local o_bottom = Newy + NPC.h
  local middley= (o_top + o_bottom) / 2
  local middlex= (o_right + o_left) / 2
  
  
  if NPC.closetoplayer == true then
    for i,v in ipairs(Buildinglist) do
      --Check if building even close enough to check
      if v.x >= NPC.x - 20000 and v.x <= NPC.x + 20000 and v.y >=NPC.y - 20000 and
      NPC.y <= NPC.y + 20000 then 
        
        --create size of building
        local b_left = v.x
        local b_right = v.x + v.w
        local b_top = v.y + v.backyard
        local b_bottom = v.y + v.h
        
        --Check if overlap exists for new co-ordinates
        if o_right > b_left and
          o_left < b_right and
          o_bottom > b_top and
          o_top < b_bottom then
          
          
          --Check if target is inside building
          if v.entry == true and task.x < b_right and task.x > b_left and task.y > b_top and task.y < b_bottom then--and middlex > b_left and middlex < b_right and middley > task.y then
            NPC.loc = 'inside'
            NPC.x = Newx
            NPC.y = Newy
            NPC_moving(NPC,dt)
            return
          elseif task.x < b_right and task.x > b_left and task.y > b_top and task.y < b_bottom then
            NPC.loc ='inside'
            task.newy = b_bottom + NPC.h + 1
            task.newx = Newx
            NPC_moving(NPC,dt)
            return
            
          --Check if already in building and need to exit
          elseif a_right > b_left and
            a_left < b_right and
            a_bottom > b_top + 10 and
            a_top < b_bottom - 10 then
            NPC.loc ='inside'
            if task.x>NPC.x then
              task.newx = b_right + NPC.w
            else
              task.newx = b_left - NPC.w
            end
            task.newy= b_bottom + NPC.h + 1
            NPC.y = NPC.y + (NPC.speed*dt)
            NPC_moving(NPC,dt)
            return
          end
          
          --test to see which direction the collusion was from. Default is from the left.
          local closest = 'left'
          local closest_val = math.abs(middlex - b_left)
          
          
          if closest_val > math.abs(middlex - b_right) then
            closest = 'right'
            closest_val = math.abs(middlex - b_right)
          elseif closest_val > math.abs(middley - b_top) then
            closest = 'top'
            closest_val = math.abs(middley - b_top)
          elseif closest_val > math.abs(middley - b_bottom) then
            closest = 'bottom'
          end
          if closest == 'left' or closest == 'right' then
            task.newx = NPC.x
            if NPC.y > task.y then
              task.newy = b_top - NPC.h - NPC.h/3
              NPC_moving(NPC,dt)
              return
            else
              task.newy = b_bottom + NPC.h + NPC.h/3
              NPC_moving(NPC,dt)
              return
            end
          else
            task.newy = NPC.y
            if NPC.x > task.x then
              task.newx = b_left - NPC.w - NPC.w/3
              NPC_moving(NPC,dt)
              return
            else
              task.newx = b_right + NPC.w + NPC.w/3
              NPC_moving(NPC,dt)
              return
            end
          end
        end
      end
    end
  end
  
  NPC.x = Newx
  NPC.y = Newy
  NPC_moving(NPC,dt)
end
        
function check_NPC()
  FarNPCs = {}
  CloseNPCs = {}
  for i, v in ipairs(ListofNPCs) do
    if v.x < player1.x + 40000 and v.x > player1.x - 40000 and v.y > player1.y -40000 and v.y < player1.y + 40000 then
      v.closetoplayer = true
      table.insert(CloseNPCs, v)
    else
      v.closetoplayer = false
      table.insert(FarNPCs, v)
    end
  end
  --print(#FarNPCs, #CloseNPCs)
end

function notintowns(x, y)
  for i, v in pairs(towns) do
    for o, b in ipairs(v.enviro) do
      if b.x == v.x and b.y == v.y then
        return false
      end
    end
  end
  return true
end
  