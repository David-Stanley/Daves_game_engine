--Information intially loaded to do with the player

playerlist={}

function create_player(x, y)
  if player1 == nil then
    player1={}
  end
  player1.chunk = 0
  player1.superattack=false
  player1.superattack2=false
  player1.superattack3=false
  player1.superattackcooldown = 0
  player1.weaptilt = 1
  player1.health = 100
  player1.maxhealth=100
  player1.weakness={}
  
  --Look variables
  player1.name = 'Dave'
  player1.colour = human.colours[math.random(1,#human.colours)]
  player1.head = player1.colour..human.head[math.random(1,#human.head)]
  player1.eyes = human.eyes[math.random(1, #human.eyes)]..'eyes'
  player1.body = player1.colour..human.body[math.random(1,#human.body)]
  player1.mouth = human.mouth[math.random(1,#human.mouth)]
  player1.hair = human.hair[math.random(1,#human.hair)]
  player1.hand= player1.colour..'hand'
  player1.feet = player1.colour..human.feet[math.random(1,#human.body)]
  
  
  

  player1.armour = 0
  player1.armourimage = nil
  player1.armourholder ={}
  player1.feet1x=0
  player1.feet1y=0
  player1.feet2x=30
  player1.feet2y=-10
  player1.visible = true
  player1.image = 'player1'
  player1.x = x
  player1.y = y
  player1.w = Image_table[player1.image]:getWidth()
  player1.h = Image_table[player1.image]:getHeight()
  player1.speed = 4
  player1.direction = "up"
  player1.dirface = 1


  --create_item(x, y, name, num, damage, image, value, ground, specialtype, specialvalue)
  
  --Ownership
  player1.items = {create_item(0,0, "hatchet", 1, 1000, "hatchetitem", 100, false,'hatchet',10),create_item(0, 0, 'empty', 0, 1, "empty",0, false),create_item(0, 0, 'empty', 0, 1, "empty",0, false),create_item(0, 0, 'empty', 0, 1, "empty",0, false),create_item(0, 0, 'building tent', 1, 1, "tent_construction_item",0, false,'building','tent'),create_item(0, 0, 'empty', 0, 1, "empty",0, false),create_item(0, 0, 'grassarmour3', 1, 10, 'grassarmour3', 100, false, 'armour', 10),create_item(0, 0, 'grassarmour2', 1, 10, 'grassarmour2', 100, false, 'armour', 10),create_item(0, 0, 'grassarmour1', 1, 10, 'grassarmour1', 100, false, 'armour', 10),}
  player1.held = player1.items[1]
  player1.itemx = 0
  player1.invnum = 1
  player1.land = {}
  player1.question = 'intro'
  player1.coins = 1000
  player1.block = false
  player1.stamina = 100


  ----crafting---
  player1.craftables = {}
  player1.extra_inventory = {}
  craftingitem = {}
  craftingitem.item = create_item(0, 0, 'tent construction', 1, 1, 'tent_construction_item', 500, false, 'construction')
  craftingitem.cost = {create_item(0, 0, 'logs', 10, 5, 'logsitem',1, false), create_item(0, 0, 'leaves', 10, 5, 'leavesitem',1, false)}
  table.insert(player1.craftables,  craftingitem)

  ----levels----
  player1.defense = 1
  player1.strength = 1
  player1.charisma = 1
  player1.agility = 1
  player1.magic = 1
  player1.perception = 1
  player1.intelligence = 1
  player1.crafting = 1


  table.insert(playerlist,player1)
end

function playermovement(player_action, dt)
  condense_inventory(player_action.items, true)
  if player_action.armour == nil then
    player_action.armour = 0
  end
  player1.held = player1.items[player1.invnum]
  if player_action.health < 0 then
    create_player(0, 0)
  end
  
  -- player speed
  if love.keyboard.isDown("lshift") then
    player_action.speed=600 *dt
  else
    player_action.speed=300 *dt
  end
  
  -- player item select
  
  if love.keyboard.isDown("1") then
    player_action.held = player_action.items[1]
    player_action.invnum = 1
  end
  
  if love.keyboard.isDown("2") then
    player_action.held = player_action.items[2]
    player_action.invnum = 2
  end
  
  if love.keyboard.isDown("3") then
    player_action.held = player_action.items[3]
    player_action.invnum = 3
  end
  
  if love.keyboard.isDown("4") then
    player_action.held = player_action.items[4]
    player_action.invnum = 4
  end
  
  if love.keyboard.isDown("5") then
    player_action.held = player_action.items[5]
    player_action.invnum = 5
  end
  
  if love.keyboard.isDown("6") then
    player_action.held = player_action.items[6]
    player_action.invnum = 6
  end
  
  if love.keyboard.isDown("7") then
    player_action.held = player_action.items[7]
    player_action.invnum = 7
  end
  
  if love.keyboard.isDown("8") then
    player_action.held = player_action.items[8]
    player_action.invnum = 8
  end
  
  if love.keyboard.isDown("9") then
    player_action.held = player_action.items[9]
    player_action.invnum = 9
  end
  
  -- player movementd
  if love.keyboard.isDown("s") and player_action.block == false then
    player_moving(player1, dt)
    player_action.direction="down"
    if player1.superattack == false and collision(player_action.x, player_action.y + player_action.speed, player_action.w, player_action.h) then
      player_action.y = player_action.y + player_action.speed
    end
  end
  if love.keyboard.isDown("w") and player_action.block == false then
    player_moving(player1, dt)
    player_action.direction="up"
    if player1.superattack == false and collision(player_action.x, player_action.y - player_action.speed, player_action.w, player_action.h) then
      player_action.y = player_action.y - player_action.speed
    end
  end
  if love.keyboard.isDown("a") and player_action.block == false then
    player_moving(player1, dt)
    player_action.direction="left"
    player_action.dirface = 1
    player_action.diroffset=0
    if player1.superattack == false and collision(player_action.x - player_action.speed, player_action.y, player_action.w, player_action.h) then
      player_action.x = player_action.x - player_action.speed
    end
  end
  if love.keyboard.isDown("d") and player_action.block == false then
    player_moving(player1, dt)
    player_action.direction="right"
    player_action.dirface = -1
    player_action.diroffset=Image_table[player_action.image]:getWidth()
    if player1.superattack == false and collision(player_action.x + player_action.speed, player_action.y, player_action.w, player_action.h) then
      player_action.x = player_action.x + player_action.speed
      
    end
  end
  
  if not love.keyboard.isDown("d") and not love.keyboard.isDown("w") and not love.keyboard.isDown("s") and not love.keyboard.isDown("a") and player1.superattack==false then
    player_action.feet1x=0
    player_action.feet1y=0
    player_action.feet2x=30
    player_action.feet2y=0
  end
  if love.keyboard.isDown("v") then
    daytime=daytime+(5*dt)
  end
  
  if love.keyboard.isDown('q') then
    world = 'menu'
  end
  
  if love.keyboard.isDown('k') then
    player_action.block = true
  else
    player_action.block = false
  end
  
  if love.keyboard.isDown("space") and tradingon == false and player_action.block == false then
    player_event(player_action, dt)
  end
  
  --Superattacks--
  if player_action.superattack == true then
    superattack(player_action, dt)
  elseif player_action.superattack2 == true then
    superattack2(player_action,dt)
  elseif player_action.superattack3 == true then
    superattack3(player_action,dt)
  elseif player_action.superattackcooldown > 0 then
    player_action.superattackcooldown = player_action.superattackcooldown - dt
  end
  if player_action.superattack2 == false then
    player_action.weaptilt = 1
  end
end
  

function player_event(player_action, dt)
  player_action.itemx = player_action.itemx + -player_action.dirface * dt*100
  if player_action.itemx > 10 or player_action.itemx < -10 then
    player_action.itemx = 0
  end
  
  local a_left 
  local a_righttrader
  local a_top
  local a_bottom
  
  --View of player
  if player_action.direction == "right" then
    a_left = player_action.x + 15
    a_right = a_left + player_action.w + 15
    a_top = player_action.y 
    a_bottom = a_top + player_action.h 
  end
  if player_action.direction == "left" then
    a_left = player_action.x - 15
    a_right = a_left + player_action.w - 15
    a_top = player_action.y
    a_bottom = a_top + player_action.h 
  end
  if player_action.direction == "up" then
    a_left = player_action.x
    a_right = a_left + player_action.w
    a_top = player_action.y - 15
    a_bottom = a_top + player_action.h - 15
  end
  if player_action.direction == "down" then
    a_left = player_action.x
    a_right = a_left + player_action.w
    a_top = player_action.y + 15
    a_bottom = a_top + player_action.h + 15
  end
  
  
  if player_action.held.damage > 0 then
    for i,v in ipairs(player_action.playerenvirolist) do
      if v.x >= a_left - 10000 and v.x <= a_left + 10000 and v.y >= a_top - 10000 and v.y <= a_top + 10000 then
        for o,b in ipairs(v.field) do
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
              if player_action.held.specialtype == q then
                damage_multi = player_action.held.specialvalue
              end
            end
            b.health= b.health-player_action.held.damage * damage_multi * dt
            if b.health <= 0 then
              drop_inventory(b)
              table.remove(v.field,o)
            end
            end
          end
        end
      end
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
            b.health= b.health-player_action.held.damage * damage_multi * dt
            b.x = b.x -(player_action.held.damage * damage_multi * dt) * player_action.dirface
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
    
    for o,b in ipairs(Buildinglist) do
      local b_left = b.x
      local b_right = b.x + b.h
      local b_bottom = b.y + b.w
      local b_top = b.y
      
      if b.btype == 'construction' and a_right > b_left and
        a_left < b_right and
        a_bottom > b_top and
        a_top < b_bottom then
        if player_action.held.specialtype == 'hammer' then
          b.completion= b.completion + player_action.held.specialvalue*dt
          if b.completion >= b.health then
            construction_complete(b)
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
            b.health= b.health-player_action.held.damage * damage_multi * dt
          end
        end
      end
  if player_action.held.item == 'empty' then
    for i,b in ipairs(grounditemslist) do
        local b_left = b.x
        local b_right = b.x + b.w
        local b_bottom = b.y + b.h
        local b_top = b.y
        
        if a_right > b_left and
        a_left < b_right and
        a_bottom > b_top and
        a_top < b_bottom then
          player_action.held = b
          player_action.items[player_action.invnum]=b
          table.remove(grounditemslist,i)
        end
      end
    end
    

    
  for i,b in ipairs(grounditemslist) do
    
    local b_left = b.x
    local b_right = b.x + b.w
    local b_bottom = b.y + b.h
    local b_top = b.y
    
    if a_right > b_left and
    a_left < b_right and
    a_bottom > b_top and
    a_top < b_bottom then
      if b.item == player_action.held.item then
        player_action.items[player_action.invnum].num = player_action.items[player_action.invnum].num + b.num
        table.remove(grounditemslist,i)
      else
        for m, n in ipairs(player_action.items) do
          if b.item == n.item then
            player_action.items[m].num = player_action.items[m].num + b.num
            table.remove(grounditemslist,i)
            return
          end
        end
      end
    end
  end
  
  
  
  if player_action.held.item ~= 'empty' then
    local emptyhand
    for m, n in ipairs(player_action.items) do
      if n.item == 'empty' then
        emptyhand = m
      end
    end
    
    
    -----------------------------------ALTER THIS TO GAIN SECOND INVENTORY---------------------------

    
    for i,b in ipairs(grounditemslist) do
        local b_left = b.x
        local b_right = b.x + b.w
        local b_bottom = b.y + b.h
        local b_top = b.y
        
        if a_right > b_left and
        a_left < b_right and
        a_bottom > b_top and
        a_top < b_bottom then
          for m, n in ipairs(player_action.items) do
            if n.item == 'empty' then
              emptyhand = m
            end
          end
          if emptyhand == nil then
            table.insert(player_action.extra_inventory,b)
            table.remove(grounditemslist,i)
          else
            player_action.items[emptyhand]=b
            table.remove(grounditemslist,i)
          end
        end
      end
    end
  end
  


function player_moving(player, dt)
  tradingon = false
  talking=false
  player.question='intro'
  dialog.select = 1
  local speed = 60
  --when on ground, foot goes back
  if player.feet1y == 0 then
    player.feet1x = player.feet1x - dt*player.speed*speed
  end
  
  --when in air, foot goes forward
  if player.feet1y == -10 then
    player.feet1x = player.feet1x + dt*player.speed*speed
  end
  
  --When foot at end, foot goes up
  if player.feet1x <= 0 then
    player.feet1x = 0
    player.feet1y = player.feet1y - dt*player.speed*speed
  end
  
  --Prevent foot up forever
  if player.feet1y < -10 then
    player.feet1y = -10
  end
  
  --bring foot down
  if player.feet1x >= 30 then
    player.feet1x = 30
    player.feet1y = player.feet1y + dt*player.speed*speed*2
  end
  
  --Prevent foot down forever
  if player.feet1y > 0 then
    player.feet1y = 0
  end
  
  if player.feet2y == 0 then
    player.feet2x = player.feet2x - dt*player.speed*speed
  end
  if player.feet2y == -10 then
    player.feet2x = player.feet2x + dt*player.speed*speed
  end
  if player.feet2x <= 0 then
    player.feet2x = 0
    player.feet2y = player.feet2y - dt*player.speed*speed
  end
  if player.feet2y < -10 then
    player.feet2y = -10
  end
  if player.feet2x >= 30 then
    player.feet2x = 30
    player.feet2y = player.feet2y + dt*player.speed*speed*2
  end
  if player.feet2y > 0 then
    player.feet2y = 0
  end
  
end

