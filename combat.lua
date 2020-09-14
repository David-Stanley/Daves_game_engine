function NPC_attack_enemy(attacker, defender,dt)
  if attacker.health < attacker.maxhealth/3 then
    attacker.superattack = false
    dt =dt * 4
    if attacker.loc ~='outside' and attacker.loc ~= 'nearhome' and attacker.loc ~= 'home' then
      NPC_travel(attacker, attacker.x + attacker.w/2, math.floor(attacker.y/1000)*1000+950, dt, 'outside')
      return
    end
    if attacker.loc == 'outside' then
      NPC_travel_outside(attacker, attacker.home.x, attacker.home.y, dt, 'nearhome')
      return
    end
    if attacker.loc == 'nearhome' then
      NPC_travel(attacker, attacker.home.x + attacker.home.w/2, attacker.home.y+ attacker.home.h/2, dt, 'home')
      return
    end
    if attacker.loc == 'home' then
      table.remove(attacker.plan, 1)
      return
    end
  end
  if attacker.superattack == true then
    NPC_attack_enemy_super(attacker,defender,dt)
    return
  end
  local check = combat_travel(attacker, defender,dt)
  if check == true then
    if math.random(1, 100) > 99 then
      attacker.superattack = true
    elseif attacker.superattack == false then
      NPC_kill_enemy(attacker,defender,dt)
    end
  end
end
  
  
function combat_travel(attacker, defender,dt)
  dt = dt *2
  NPC_moving(attacker,dt)
  local ax, ay = getmiddle(attacker)
  local dx, dy = getmiddle(defender)
  if math.floor(ax) > dx -defender.w and math.floor(ax) < dx +defender.w and math.floor(ay) < dy +defender.h - 100 and math.floor(ay) > dy - defender.h + 100 then
    return true
  end
  angle = math.atan2((ay - dy), (ax - dx))
  attacker.xspeed = attacker.speed * math.cos(angle)
  attacker.yspeed = attacker.speed * math.sin(angle)
  if attacker.xspeed <0 then
    attacker.dirface = -1
    attacker.diroffset=attacker.w
    attacker.direction = 'right'
  else
    attacker.dirface = 1
    attacker.diroffset=0
    attacker.direction = 'left'
  end
  x = ax - (attacker.xspeed * dt)
  y = ay - (attacker.yspeed * dt)
  local check = NPC_collision(attacker.speed,x - attacker.w/2, y - attacker.h/2, attacker.w, attacker.h, defender.x, defender.y, attacker.x, attacker.y, dt, attacker)
  attacker.x = check[1]
  attacker.y = check[2]
end


function NPC_kill_enemy(NPC, defender, dt)
  
  NPC.itemx = NPC.itemx + -NPC.dirface * dt * 100
  if NPC.itemx >10 or NPC.itemx < -10 then
    NPC.itemx = 0
  end
  
  local a_left 
  local a_right
  local a_top
  local a_bottom
  
  --View of player
  if NPC.direction == "right" then
    a_left = NPC.x + 15
    a_right = a_left + NPC.w + 15
    a_top = NPC.y 
    a_bottom = a_top + NPC.h 
  end
  if NPC.direction == "left" then
    a_left = NPC.x - 15
    a_right = a_left + NPC.w - 15
    a_top = NPC.y
    a_bottom = a_top + NPC.h 
  end
  if NPC.direction == "up" then
    a_left = NPC.x
    a_right = a_left + NPC.w
    a_top = NPC.y - 15
    a_bottom = a_top + NPC.h - 15
  end
  if NPC.direction == "down" then
    a_left = NPC.x
    a_right = a_left + NPC.w
    a_top = NPC.y + 15
    a_bottom = a_top + NPC.h + 15
  end
  
  if NPC.held.damage > 0 then
    b = defender
    local b_left = b.x
    local b_right = b.x + b.h
    local b_bottom = b.y + b.w
    local b_top = b.y
    local damage_multi = 1
    
    if a_right > b_left and
    a_left < b_right and
    a_bottom > b_top and
    a_top < b_bottom then
      for a, q in ipairs(b.weakness) do
        if NPC.held.item == q then
          damage_multi = 10
        end
      end
      if collision(b.x -(NPC.held.damage * damage_multi * dt) * NPC.dirface, b.y, b.w, b.h) then
        b.x = b.x -(NPC.held.damage * damage_multi * dt) * NPC.dirface
      end
      if b.block == false then
        if b.armour == nil then
          b.armour = 0
        end
        b.armour= b.armour-NPC.held.damage * damage_multi * dt
        if b.armour < 0 then
          b.health= b.health-NPC.held.damage * damage_multi * dt
          --armour--
          b.armour = 0
          b.armourimage = nil
          b.armourholder ={} 
        end
      end
      if b.health <= 0 then
        table.remove(NPC.plan,1)
      end
    end
  end
end

function NPC_attack_enemy_super(attacker,target, dt)
  attacker.items[attacker.invnum].tilt = attacker.items[attacker.invnum].tilt - 3 * dt
  if attacker.items[attacker.invnum].tilt < -1.5 then
    attacker.superattack = false
    attacker.items[attacker.invnum].tilt = 0
  end
  if attacker.itemx > 10 or attacker.itemx < -10 then
    attacker.itemx = 0
  end
  
  local a_left 
  local a_right
  local a_top
  local a_bottom
  
  --View of player
  if attacker.direction == "right" then
    a_left = attacker.x + 15
    a_right = a_left + attacker.w + 15
    a_top = attacker.y 
    a_bottom = a_top + attacker.h 
  end
  if attacker.direction == "left" then
    a_left = attacker.x - 15
    a_right = a_left + attacker.w - 15
    a_top = attacker.y
    a_bottom = a_top + attacker.h 
  end
  if attacker.direction == "up" then
    a_left = attacker.x
    a_right = a_left + attacker.w
    a_top = attacker.y - 15
    a_bottom = a_top + attacker.h - 15
  end
  if attacker.direction == "down" then
    a_left = attacker.x
    a_right = a_left + attacker.w
    a_top = attacker.y + 15
    a_bottom = a_top + attacker.h + 15
  end
  if attacker.held.damage > 0 and attacker.held.tilt < -0.9 then
    b=target
    local b_left = b.x
    local b_right = b.x + b.h
    local b_bottom = b.y + b.w
    local b_top = b.y
    local damage_multi = 1
        
    if a_right > b_left and
      a_left < b_right and
      a_bottom > b_top and
      a_top < b_bottom then
        if attacker.held.item ~= 'empty' then
          for a, q in ipairs(b.weakness) do
            if attacker.held.item == q then
              damage_multi = 10
            end
          end
          if b.block == false then
            if b.armour == nil then
              b.armour = 0
            end
            b.armour= b.armour-attacker.held.damage * damage_multi * dt
            if b.armour < 0 then
              b.health= b.health-attacker.held.damage * damage_multi * dt
              --armour--
              b.armour = 0
              b.armourimage = nil
              b.armourholder ={} 
            end
            if collision(b.x -(attacker.held.damage * damage_multi * 20) * attacker.dirface, b.y, b.w, b.h) then
              b.x = b.x -(attacker.held.damage * damage_multi * 20) * attacker.dirface
            end
          elseif b.block == true then
            b.health= b.health-(attacker.held.damage * damage_multi * 5/(b.armour+b.defense))
            if collision(b.x -(attacker.held.damage * damage_multi * 20) * attacker.dirface, b.y, b.w, b.h) then
              b.x = b.x -(attacker.held.damage * damage_multi * 20) * attacker.dirface
            end
          end
          if b.health <= 0 then
            table.remove(attacker.plan,1)
          end
          end
        end
      end
    end



function superattack(player_action, dt)

  player_action.items[player_action.invnum].tilt = player_action.items[player_action.invnum].tilt - 4 * dt
  
  if player_action.items[player_action.invnum].tilt < -1.5 then
    player_action.superattack = false
    if player_action.superattack2 == false then
      player_action.items[player_action.invnum].tilt = 0
    end
  end
  if player_action.itemx > 10 or player_action.itemx < -10 then
    player_action.itemx = 0
  end
  
  local a_left 
  local a_right
  local a_top
  local a_bottom
  
  --View of player
  if player_action.direction == "right" then
    a_left = player_action.x + 15
    a_right = a_left + player_action.w + 15
    a_top = player_action.y 
    a_bottom = a_top + player_action.h
    if collision(player_action.x + player_action.speed/2, player_action.y, player_action.w, player_action.h) and player_action.held.tilt < -0.4 then
      player_action.x = player_action.x + player_action.speed/2
      player_moving(player_action, dt)
    end

  end
  if player_action.direction == "left" then
    a_left = player_action.x - 15
    a_right = a_left + player_action.w - 15
    a_top = player_action.y
    a_bottom = a_top + player_action.h 
    if collision(player_action.x - player_action.speed/2, player_action.y, player_action.w, player_action.h) and player_action.held.tilt < -0.4 then
      player_action.x = player_action.x - player_action.speed/2
      player_moving(player_action, dt)
    end
  end
  if player_action.direction == "up" then
    a_left = player_action.x
    a_right = a_left + player_action.w
    a_top = player_action.y - 15
    a_bottom = a_top + player_action.h - 15
    if collision(player_action.x , player_action.y- player_action.speed/2, player_action.w, player_action.h) and player_action.held.tilt < -0.4 then
      player_action.y = player_action.y - player_action.speed/2
      player_moving(player_action, dt)
    end
  end
  if player_action.direction == "down" then
    a_left = player_action.x
    a_right = a_left + player_action.w
    a_top = player_action.y + 15
    a_bottom = a_top + player_action.h + 15
    if collision(player_action.x , player_action.y+ player_action.speed/2, player_action.w, player_action.h) and player_action.held.tilt < -0.4 then
      player_action.y = player_action.y + player_action.speed/2
      player_moving(player_action, dt)
    end
  end
  
  if player_action.held.tilt < -0.9 and player_action.held.specialtype == 'building' then
    local building = findplayerbuilding(player_action, player_action.held)
    
    building.oldoutside = building.outside
    building.oldinside = building.inside
    building.inside = building.constructionimage
    building.oldtype = building.btype
    building.btype = 'construction'
    building.outside = building.constructionimage
    building.completion = 0
    if building.possible then
      table.insert(Buildinglist, building)
      table.insert(player_action.land, building)
      player_action.held.num = player_action.held.num-1
      if player_action.held.num <= 0 then
        player_action.held = create_item(0, 0, 'empty', 0, 1, "empty",0, false)
        player_action.items[player_action.invnum] = create_item(0, 0, 'empty', 0, 1, "empty",0, false)
      end
    end
    
    player_action.superattack = false
    return
  end
  
  if player_action.held.specialtype == 'armour' or player_action.held.item == 'empty' then
    player_action.items[player_action.invnum].tilt = 0
    player_action.superattack=false
    local temp = player_action.armourholder
    player_action.armourimage = player_action.held.item
    player_action.armour = player_action.held.specialvalue
    player_action.armourholder =player_action.items[player_action.invnum]
    if temp.specialtype ~= 'armour' then
      player_action.items[player_action.invnum] = create_item(0, 0, 'empty', 0, 1, "empty",0, false)
    else
      player_action.items[player_action.invnum] =temp
    end
  elseif player_action.held.item == 'empty' and player_action.armour > 0 then
    player_action.armourimage = nil
    player_action.armour = 0
    player_action.items[player1.invnum] = player1.armourholder
    player_action.armourholder ={}    
    
  end
  
  if player_action.items[player1.invnum].specialtype == 'food' and player_action.held.tilt < -0.9 then
    player_action.health = player_action.health + (player_action.items[player1.invnum].specialvalue/10)
    if player_action.health > player_action.maxhealth then
      player_action.health = player_action.maxhealth
    end
    player_action.items[player1.invnum].num = player_action.items[player1.invnum].num - 1
    player_action.superattack = false
  end
  
  
  if player_action.held.damage > 0 and player_action.held.tilt < -1.5 and player_action.held.specialtype ~= 'armour' then
    for o,b in ipairs(ListofNPCs) do
      local b_left = b.x
      local b_right = b.x + b.h
      local b_bottom = b.y + b.w
      local b_top = b.y
      local damage_multi = 1
          
      if a_right > b_left and
        a_left < b_right and
        a_bottom > b_top and
        a_top < b_bottom then
          if player_action.held.item ~= '' then
            for a, q in ipairs(b.weakness) do
              if player_action.held.item == q then
                damage_multi = 10
              end
            end
            b.health= b.health-player_action.held.damage * damage_multi * 5
            b.x = b.x + player_action.speed *15 * -player_action.dirface
            --b.x = nearest_collision2(b.x, b.y,b.x -(player_action.held.damage * damage_multi * 20) * player_action.dirface, b.y, b.w, b.h)
            if #b.plan < 1 or b.plan[1].action ~= 'attack' then
              local task = {}
              task.action = 'attack'
              task.target = player_action
              table.insert(b.plan, 1, task)
            end
          end
      end
    end
  end
    
  for o,b in ipairs(Listofanimals) do
    local b_left = b.x
    local b_right = b.x + b.h
    local b_bottom = b.y + b.w
    local b_top = b.y
    local damage_multi = 1
        
    if a_right > b_left and
      a_left < b_right and
      a_bottom > b_top and
      a_top < b_bottom then
        if player_action.held.item ~= 'empty' then
          for a, q in ipairs(b.weakness) do
            if player_action.held.item == q then
              damage_multi = 10
            end
          end
          b.health= b.health-player_action.held.damage * damage_multi * 5
          b.x = b.x + player_action.speed * 15 * -player_action.dirface
        end
    end
  end
end

function superattack2(player_action, dt)
  --player_action.weaptilt=-1
  player_action.superattack = false
  player_action.items[player_action.invnum].tilt = player_action.items[player_action.invnum].tilt + 4 * dt*2
  
  if player_action.items[player_action.invnum].tilt > 0.5 then
    player_action.superattack2 = false
    if player_action.superattack3 == false then
      player_action.items[player_action.invnum].tilt = 0
    end
  end
  --player_action.itemx = 40
  
  
  local a_left 
  local a_right
  local a_top
  local a_bottom
  
  --View of player
  if player_action.direction == "right" then
    a_left = player_action.x + 15
    a_right = a_left + player_action.w + 15
    a_top = player_action.y 
    a_bottom = a_top + player_action.h
    if collision(player_action.x + player_action.speed/2, player_action.y, player_action.w, player_action.h) and player_action.held.tilt < -0.4 then
      player_action.x = player_action.x + player_action.speed/2
      player_moving(player_action, dt)
    end

  end
  if player_action.direction == "left" then
    a_left = player_action.x - 15
    a_right = a_left + player_action.w - 15
    a_top = player_action.y
    a_bottom = a_top + player_action.h 
    if collision(player_action.x - player_action.speed/2, player_action.y, player_action.w, player_action.h) and player_action.held.tilt < -0.4 then
      player_action.x = player_action.x - player_action.speed/2
      player_moving(player_action, dt)
    end
  end
  if player_action.direction == "up" then
    a_left = player_action.x
    a_right = a_left + player_action.w
    a_top = player_action.y - 15
    a_bottom = a_top + player_action.h - 15
    if collision(player_action.x , player_action.y- player_action.speed/2, player_action.w, player_action.h) and player_action.held.tilt < -0.4 then
      player_action.y = player_action.y - player_action.speed/2
      player_moving(player_action, dt)
    end
  end
  if player_action.direction == "down" then
    a_left = player_action.x
    a_right = a_left + player_action.w
    a_top = player_action.y + 15
    a_bottom = a_top + player_action.h + 15
    if collision(player_action.x , player_action.y+ player_action.speed/2, player_action.w, player_action.h) and player_action.held.tilt < -0.4 then
      player_action.y = player_action.y + player_action.speed/2
      player_moving(player_action, dt)
    end
  end
  
  
  if player_action.held.damage > 0 and player_action.held.tilt > 0.9 and player_action.held.specialtype ~= 'armour' then
    for o,b in ipairs(ListofNPCs) do
      local b_left = b.x
      local b_right = b.x + b.h
      local b_bottom = b.y + b.w
      local b_top = b.y
      local damage_multi = 1
          
      if a_right > b_left and
        a_left < b_right and
        a_bottom > b_top and
        a_top < b_bottom then
          if player_action.held.item ~= '' then
            for a, q in ipairs(b.weakness) do
              if player_action.held.item == q then
                damage_multi = 10
              end
            end
            b.health= b.health-player_action.held.damage * damage_multi * 5
            b.x = b.x + player_action.speed * 20 * -player_action.dirface
            --b.x = nearest_collision2(b.x, b.y,b.x -(player_action.held.damage * damage_multi * 20) * player_action.dirface, b.y, b.w, b.h)
            if #b.plan < 1 or b.plan[1].action ~= 'attack' then
              local task = {}
              task.action = 'attack'
              task.target = player_action
              table.insert(b.plan, 1, task)
            end
          end
      end
    end
  end
    
  for o,b in ipairs(Listofanimals) do
    local b_left = b.x
    local b_right = b.x + b.h
    local b_bottom = b.y + b.w
    local b_top = b.y
    local damage_multi = 1
        
    if a_right > b_left and
      a_left < b_right and
      a_bottom > b_top and
      a_top < b_bottom then
        if player_action.held.item ~= 'empty' then
          for a, q in ipairs(b.weakness) do
            if player_action.held.item == q then
              damage_multi = 10
            end
          end
          b.health= b.health-player_action.held.damage * damage_multi * 5
          b.x = b.x + player_action.speed * 20 * -player_action.dirface
        end
    end
  end
end

function superattack3(player_action, dt)
  --player_action.weaptilt=-1
  player_action.superattack = false
  player_action.superattack2 = false
  player_action.items[player_action.invnum].tilt = player_action.items[player_action.invnum].tilt - 4 * dt*2
  
  if player_action.items[player_action.invnum].tilt < -2.3 then
    player_action.superattack3 = false
    player_action.items[player_action.invnum].tilt = 0
    player_action.superattackcooldown = 1
  end
  --player_action.itemx = 40
  
  
  local a_left 
  local a_right
  local a_top
  local a_bottom
  
  --View of player
  if player_action.direction == "right" then
    a_left = player_action.x + 15
    a_right = a_left + player_action.w + 15
    a_top = player_action.y 
    a_bottom = a_top + player_action.h
    if collision(player_action.x + player_action.speed/2, player_action.y, player_action.w, player_action.h) and player_action.held.tilt < -0.4 then
      player_action.x = player_action.x + player_action.speed
      player_moving(player_action, dt)
    end

  end
  if player_action.direction == "left" then
    a_left = player_action.x - 15
    a_right = a_left + player_action.w - 15
    a_top = player_action.y
    a_bottom = a_top + player_action.h 
    if collision(player_action.x - player_action.speed/2, player_action.y, player_action.w, player_action.h) and player_action.held.tilt < -0.4 then
      player_action.x = player_action.x - player_action.speed
      player_moving(player_action, dt)
    end
  end
  if player_action.direction == "up" then
    a_left = player_action.x
    a_right = a_left + player_action.w
    a_top = player_action.y - 15
    a_bottom = a_top + player_action.h - 15
    if collision(player_action.x , player_action.y- player_action.speed/2, player_action.w, player_action.h) and player_action.held.tilt < -0.4 then
      player_action.y = player_action.y - player_action.speed
      player_moving(player_action, dt)
    end
  end
  if player_action.direction == "down" then
    a_left = player_action.x
    a_right = a_left + player_action.w
    a_top = player_action.y + 15
    a_bottom = a_top + player_action.h + 15
    if collision(player_action.x , player_action.y+ player_action.speed/2, player_action.w, player_action.h) and player_action.held.tilt < -0.4 then
      player_action.y = player_action.y + player_action.speed
      player_moving(player_action, dt)
    end
  end
  
  
  if player_action.held.damage > 0 and player_action.superattack3 == false and player_action.held.specialtype ~= 'armour' then
    for o,b in ipairs(ListofNPCs) do
      local b_left = b.x
      local b_right = b.x + b.h
      local b_bottom = b.y + b.w
      local b_top = b.y
      local damage_multi = 1
          
      if a_right > b_left and
        a_left < b_right and
        a_bottom > b_top and
        a_top < b_bottom then
          if player_action.held.item ~= '' then
            for a, q in ipairs(b.weakness) do
              if player_action.held.item == q then
                damage_multi = 10
              end
            end
            b.health= b.health-player_action.held.damage * damage_multi * 15
            b.x = b.x + player_action.speed * 30 * -player_action.dirface
            b.knockback_status = 0.25
            --b.x = nearest_collision2(b.x, b.y,b.x -(player_action.held.damage * damage_multi * 20) * player_action.dirface, b.y, b.w, b.h)
            if #b.plan < 1 or b.plan[1].action ~= 'attack' then
              local task = {}
              task.action = 'attack'
              task.target = player_action
              table.insert(b.plan, 1, task)
            end
          end
      end
    end
  end
    
  for o,b in ipairs(Listofanimals) do
    local b_left = b.x
    local b_right = b.x + b.h
    local b_bottom = b.y + b.w
    local b_top = b.y
    local damage_multi = 1
        
    if a_right > b_left and
      a_left < b_right and
      a_bottom > b_top and
      a_top < b_bottom then
        if player_action.held.item ~= 'empty' then
          for a, q in ipairs(b.weakness) do
            if player_action.held.item == q then
              damage_multi = 10
            end
          end
          b.health= b.health-player_action.held.damage * damage_multi * 15
          b.x = b.x + player_action.speed * 30 * -player_action.dirface
          b.knockback_status = 3
        end
    end
  end
end