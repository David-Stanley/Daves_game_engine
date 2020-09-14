human = {}
human.colours = {'white', 'brown', 'black','latinx'}
human.head = {'roundhead'}
human.body = {'mediumbodynaked'}
human.feet = {'nakedfeet'}
human.eyes = {'sharp','big','eyepatch'}
human.hair = {'purplefemininespikey','redfemininespikey','blondefemininespikey','cyanfemininespikey','greenfemininespikey','blondefringelong','cyanfringelong','purplefringelong','redfringelong','blondefringeshort','redfringeshort','cyanfringeshort','purplefringeshort','blondeshort','redshort'}
human.mouth = {'straight','smirk','wow'}
human.hands = {'humanhands'}

function create_NPC(image, building, name, weakness, x, y, town)
  local NPC = {}
  NPC.superattack = false
  if #NamesforNPC == 0 then
    NPC.name=tostring(math.random(0,200000))
  else
    local namechoice = math.random(1,#NamesforNPC)
    NPC.name = NamesforNPC[namechoice]
    table.remove(NamesforNPC, namechoice)
  end
  if true then
    NPC.colour = human.colours[math.random(1,#human.colours)]
    NPC.head = NPC.colour..human.head[math.random(1,#human.head)]
    NPC.body = NPC.colour..human.body[math.random(1,#human.body)]
    NPC.feet = NPC.colour..human.feet[math.random(1,#human.body)]
    NPC.hand= NPC.colour..'hand'
    NPC.eyes = human.eyes[math.random(1, #human.eyes)]..'eyes'
    NPC.hair = human.hair[math.random(1,#human.hair)]
    NPC.mouth = human.mouth[math.random(1,#human.mouth)]
  end
  --NPC.body = 'naked1'
  NPC.weaptilt = 1
  NPC.armour = 0
  NPC.armourimage = nil
  NPC.armourholder= create_item(0, 0, 'empty', 0, 1, "empty",0, false)
  NPC.feet1x = 0
  NPC.feet2x = 30
  NPC.feet1y=0
  NPC.feet2y=-10
  NPC.maxhealth=800
  NPC.health = 800
  NPC.image= image
  NPC.x = x
  NPC.y = y
  NPC.town = town
  NPC.w = Image_table[NPC.image]:getWidth()
  NPC.h = Image_table[NPC.image]:getHeight()
  NPC.home = building
  NPC.items = {create_item(0, 0, 'fruit', 10, 1, 'fruititem', 10, false, 'food', 40)}
  NPC.nobuy = {}
  NPC.held = NPC.items[1]
  NPC.invnum = 1
  NPC.dirface=1
  NPC.direction = 'left'
  NPC.diroffset = 0
  NPC.visible=true
  NPC.job = "unemployed"
  NPC.jobwork = building
  NPC.loc = "outside"
  NPC.working = false
  NPC.maxspeed = 400
  NPC.speed = 400
  NPC.weakness={weakness}
  NPC.lastbuy = 0
  NPC.awakeness = 100
  NPC.hunger = 100
  NPC.coins = 1000
  NPC.age = 0
  NPC.workday = -1
  NPC.itemx = 0
  NPC.plan={}
  NPC.relationship={}
  NPC.spouse = {}
  NPC.socialloc = {}
  NPC.dialog = {}
  NPC.dialog['intro'] = {'Hello, my name is '..NPC.name}
  NPC.dialog['Hello, my name is '..NPC.name] = {'Rumours?','How do you feel?', 'What do you do?', 'What are you doing?', 'Who are your parents?', 'Who is your partner?','Ok, let us trade', 'What town do you belong to?'}
  NPC.dialog['What town do you belong to?'] = {'I belong to the '..town..'town'}
  NPC.dialog['Who is your partner?'] = {'I do not have a partner'}
  NPC.dialog['Who are your parents?'] = {name}
  NPC.dialog['What do you do?']={'I am a '..NPC.job}
  NPC.dialog['Rumours?'] = {'Apparently the mayor wants to sell a block of land!'}
  
  
  ---PERSONALITY TRAITS-----
  NPC.personality ={}
  table.insert(NPC.personality,{'ambition',math.random(1,100)})
  table.insert(NPC.personality,{'agreeableness',math.random(1,100)})
  table.insert(NPC.personality,{'funlover',math.random(1,100)})
  table.insert(NPC.personality,{'adventerous',math.random(1,100)})
  table.insert(NPC.personality,{'neurotic',math.random(1,100)})
  table.sort(NPC.personality,function(a,b)
    return a[2]>b[2]
  end)
  
  ---Skills---
  NPC.crafting = 1
  NPC.defense = 1
  NPC.strength = 1
  NPC.charisma = 1
  NPC.agility = 1
  NPC.magic = 1
  NPC.perception = 1
  NPC.intelligence = 1
  NPC.farming = 1
  
  
  --Status--
  NPC.knockback_status = 0
  
  table.insert(ListofNPCs, NPC)
  table.insert(NPC.home.occupants, NPC)
  return (NPC)
end



function NPC_find_job()
  for i, v in ipairs(ListofNPCs) do
    local count = 0
    if v.job == 'trader' or v.job == 'mayor' then
      v.coins = v.coins + 1000
      v.hunger = 100
    end
    if v.job == "unemployed" then
      for e, d in ipairs(towns[v.town]) do
        for o, b in ipairs(d.field) do
          if #b.workers < b.maxworkers and v.job == "unemployed" and b.job == 'trader' then
            v.job= b.job
            v.jobwork = b
            table.insert(b.workers, v.name)
          end
        end
      end
      for e, d in ipairs(towns[v.town]) do
        if v.job == 'unemployed' then
          count = count + 1
        end
        for o, b in ipairs(d.field) do
          if #b.workers < b.maxworkers and v.job == "unemployed" then
            v.job= b.job
            v.jobwork = b
            table.insert(b.workers, v.name)
          end
        end
      end
    end
    if v.job == 'unemployed' then
      if v.coins > 50 then
        local employment = create_random_workplace(v.town)
        if employment ~= nil then
          v.job = employment.job
          v.jobwork = employment
          table.insert(employment.workers, v.name)
          v.coins = v.coins - 50
          count = 0
        end
      end
    end
  end
end




function NPC_go_work(NPC, dt)
  if NPC.loc == 'workplace' then
    NPC.working = true
    table.remove(NPC.plan,1)
  else
    NPC_experimental_travel_2(NPC, NPC.plan[1], dt)
  end
end





--Too efficient to remove
--Now removed for less efficient but more effective travel
function NPC_travel_outside(NPC, locationx, locationy, dt,final_location)
  NPC_moving(NPC,dt)
  locationx = math.floor(locationx/1000) * 1000 + 50
  locationy = math.floor((locationy + 1000)/1000) * 1000 - 100
  local x = NPC.x - locationx
  local y = NPC.y - locationy
  if x > 5 then
    NPC.x = NPC.x - NPC.speed * dt
    NPC.dirface = 1
    NPC.diroffset=0
    NPC.direction = 'left'
  end
  if x < -5 then
    NPC.x = NPC.x + NPC.speed * dt
    NPC.dirface = -1
    NPC.diroffset=NPC.w
    NPC.direction = 'right'
  else
    --NPC_travel(NPC, locationx, locationy, dt, final_location)
    if y > 0 then
      NPC.y = NPC.y - NPC.speed * dt
    end
    if y < 0 then
      NPC.y = NPC.y + NPC.speed * dt
    end
  end
  if math.floor(NPC.x) > locationx -50 and math.floor(NPC.x) < locationx +900 and math.floor(NPC.y) < locationy +50 and math.floor(NPC.y) > locationy - 50 then
    NPC.loc = final_location
  end
end



---Best way of transport, but uses too much cpu.
function NPC_travel_experimental(NPC, locationx, locationy,dt, final_location)
  locationx = locationx + 50
  locationy = locationy + 50
  NPC_moving(NPC,dt)
  local x, y = getmiddle(NPC)
  angle = math.atan2((y - locationy), (x - locationx))
  NPC.xspeed = NPC.speed * math.cos(angle)
  if NPC.xspeed > 0 then 
    NPC.dirface = 1
    NPC.diroffset=0
    NPC.direction = 'left'
  elseif NPC.xspeed < 0 then 
    NPC.dirface = -1
    NPC.diroffset=NPC.w
    NPC.direction = 'right'
  end
  
  NPC.yspeed = NPC.speed * math.sin(angle)
  x = x - (NPC.xspeed * dt)
  y = y - (NPC.yspeed * dt)
  local check = NPC_collision(NPC.speed,x - NPC.w/2, y - NPC.h/2, NPC.w, NPC.h, locationx, locationy, NPC.x, NPC.y, dt, NPC)
  NPC.x = check[1]
  NPC.y = check[2]
  
  if math.floor(x) > locationx -NPC.w and math.floor(x) < locationx +NPC.w and math.floor(y) < locationy +NPC.h and math.floor(y) > locationy - NPC.h then
    NPC.loc = final_location
  end
  
end

function NPC_travel(NPC, locationx, locationy, dt, final_location)
  NPC_moving(NPC,dt)
  local x, y = getmiddle(NPC)
  angle = math.atan2((y - locationy), (x - locationx))
  NPC.xspeed = NPC.speed * math.cos(angle)
  NPC.yspeed = NPC.speed * math.sin(angle)
  if within(x,x - (NPC.xspeed * dt),locationx) then
    x = locationx
  else
    x = x - (NPC.xspeed * dt)
  end
  if within(y,y - (NPC.yspeed * dt),locationy) then
    y = locationy
  else
    y = y - (NPC.yspeed * dt)
  end
  NPC.x = x - NPC.w/2
  NPC.y = y - NPC.h/2
  if math.floor(x) > locationx -25 and math.floor(x) < locationx +25 and math.floor(y) < locationy +25 and math.floor(y) > locationy -25 then
    NPC.loc = final_location
  end
  if NPC.xspeed > 0 then 
    NPC.dirface = 1
    NPC.diroffset=0
    NPC.direction = 'left'
  elseif NPC.xspeed < 0 then 
    NPC.dirface = -1
    NPC.diroffset=NPC.w
    NPC.direction = 'right'
  end
end
 

function NPC_needs(ListofNPCs,dt)
  for i, v in ipairs(ListofNPCs) do
    if v.knockback_status > 0 then
      print(v.knockback_status)
      v.knockback_status = v.knockback_status-dt
    end
    if v.job == 'trader' then
      check_trade_goods(v)
      v.coins = 10000
    end
    --print(v.name, v.awakeness)
    v.dialog['What are you doing?'] = {'Nothing in particular'}
    if #v.plan > 1 and v.plan[2].action ~= nil then
      v.dialog['What are you doing?'] ={'My task is to '..v.plan[2].action}
      if v.plan[2].action == 'buy' then
        v.dialog['What are you doing?'] ={'My task is to buy some '..v.plan[2].item}
      end
    end
    v.dialog['What do you do?']={'I am a '..v.job}
    condense_inventory(v.items)
    taskhandler(v, dt)
    NPCsocialise(v, nil, dt, true)
    local task
    
    for o, b in ipairs(v.items) do
      if b.specialtype == 'armour' then
        if b.specialvalue ~= nil and b.specialvalue > v.armour+1 then
          v.armourimage = b.item
          v.armour = b.specialvalue
          local temp = v.armourholder
          v.armourholder =b
          b.num = b.num -1
          if b.num < 1 then
            table.remove(v.items, o)
          end
          
        elseif b.specialvalue ~= nil and b.specialvalue < v.armour then
          table.insert(v.plan, itemoverstock(v, b.item, 0, 0))
        end
      end
    end
    
    if #v.plan > 0 and v.plan[1].action ~= 'buy' and v.job ~= 'trader' and v.lastbuy ~= days and foodavailable == true then
      v.lastbuy=days
      task = itemunderstock(v, 'fruit', math.floor(100*(Find_NPC_trait(v, 'neurotic')/100)), 10) 
    end
    if #v.plan == 0 and #armouravailable > 0 and v.job ~= 'trader' then
      for e,d in ipairs(armouravailable) do
        if d.specialvalue > v.armour then
          local task = itemunderstock(v, d.item, 1, 1)
          if task ~= nil then
            task.timeout = 10
            table.insert(v.plan, task)
          end
        end
      end
    end
          
    if task ~= nil then
      v.loc = 'workplace'
      table.insert(v.plan, 1, task)
    end
    --print(v.name,' hunger ', v.hunger, ' health ', v.health,' awakeness ', v.awakeness)
    if #v.plan == 0 or v.plan[1].action ~= 'finditem' then
      NPC_pickup_item(v, dt)
    end
    if #v.plan ~= 0 then
      if v.plan[1].timeout == nil then
        v.plan[1].timeout = 60
      end
      --print(v.name, v.plan[1].action, v.plan[1].timeout)
      if v.plan[1].timeout < 0 then
        table.remove(v.plan, 1)
      else
        --print(v.plan[1].timeout, v.name, v.plan[1].action)
        v.plan[1].timeout=v.plan[1].timeout-dt
      end
    end
    if v.awakeness > 75 then
      v.awakeness= v.awakeness - dt/20
    end
    if v.closetoplayer == true then
      v.hunger = v.hunger - dt/10
    end
    v.speed=(v.maxspeed-50)*(v.awakeness/100) + 50
    if v.hunger > 120 then
      v.hunger = 120
    elseif v.hunger < 80 then
      for o, b in ipairs(v.items) do
        if b.specialtype == 'food' and v.hunger < 80 then
          v.hunger = v.hunger + b.specialvalue
          b.num = b.num-1
          if b.num < 1 and b.item ~= 'empty' then
            table.remove(v.items, o)
          end
        end
      end
    end
    
    
    --kill NPC--
    if v.hunger < 0 then
      --NPC_die(v)
    end
    if v.health < 0 then
      NPC_die(v)
    end
  end
end

function NPC_age_up(ListofNPCs,dt)
  for i, v in ipairs(ListofNPCs) do
    v.age = v.age + 1
    if v.age > 120 then
      NPC_die(v)
    end
  end
end

function NPC_kill_enviro(NPC, dt)
  local occured = false
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
  
  if towns[NPC.town].enviro == nil then
    return
  end
  
  if NPC.held.damage > 0 then
    for i,v in ipairs(towns[NPC.town].townenviro) do
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
          a_top < b_bottom and b.weakness ~= nil then
            occured = true
            if math.random(1,10000) > 9999 then
              NPC.strength = NPC.strength + 1
            end
            for a, q in ipairs(b.weakness) do
              if NPC.held.item == q then
                damage_multi = 10+NPC.strength
              end
            end
            b.health= b.health-NPC.held.damage * damage_multi * dt
            if b.health <= 0 then
              drop_inventory(b)
              table.remove(v.field,o)
              return('dead')
            end
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
      occured = true
      if NPC.held.item ~= 'empty' then
        for a, q in ipairs(b.weakness) do
          if NPC.held.item == q then
            damage_multi = 10
          end
        end
        b.health= b.health-NPC.held.damage * damage_multi * dt
        if b.health <= 0 then
          drop_inventory(b)
          table.remove(v.field,o)
          return('dead')
        end
      end
    end
  end
  if occured == false then
    return 'dead'
  end
end

function NPC_pickup_item(NPC, dt)
  if #NPC.plan < 1 or NPC.plan[1].action ~= 'attack' then
    for i,v in ipairs(grounditemslist) do
      if v.x >= NPC.x - 3000 and v.x <= NPC.x + 3000 and v.y >=NPC.y - 3000 and
      v.y <= NPC.y + 3000 then
        task = {}
        task.action = 'finditem'
        task.timeout = 1
        task.item = v
        table.insert(NPC.plan,1, task)
        return
      end
    end
  end
end
  
  
function NPC_pickup_item2(NPC, pickupitem, dt)
  pickupitemnum = tablefind(grounditemslist,pickupitem)
  NPC_travel_experimental(NPC, pickupitem.x, pickupitem.y, dt, NPC.loc)
  
  local a_left = NPC.x
  local a_right = a_left + NPC.w
  local a_top = NPC.y
  local a_bottom= a_top + NPC.h

  
  local b_left = pickupitem.x
  local b_right = pickupitem.x + pickupitem.w
  local b_bottom = pickupitem.y + pickupitem.h
  local b_top = pickupitem.y
  
  if a_right > b_left and
    a_left < b_right and
    a_bottom > b_top and
    a_top < b_bottom then
      if NPC.held.item == 'empty' then
        NPC.held = pickupitem
        NPC.items[NPC.invnum]= pickupitem
        table.remove(grounditemslist,pickupitemnum)
        table.remove(NPC.plan,1)
        return
      else
        for m, n in ipairs(NPC.items) do
          if pickupitem.item == n.item then
            NPC.items[m].num = NPC.items[m].num + pickupitem.num
            table.remove(grounditemslist,pickupitemnum)
            table.remove(NPC.plan,1)
            return
          else
            table.insert(NPC.items, pickupitem)
            table.remove(grounditemslist,pickupitemnum)
            table.remove(NPC.plan,1)
            return
          end
        if NPC.held.item ~= 'empty' then
          for m, n in ipairs(NPC.items) do
            if n.item == 'empty' then
              NPC.items[m] = pickupitem
              table.remove(grounditemslist,pickupitemnum)
              table.remove(NPC.plan,1)
              return
            end
          end
        end
      end
    
    end
  end
end

  

function NPC_die(NPC)
  --print(NPC.name, NPC.health, NPC.hunger, NPC.job, NPC.coins)
  drop_inventory(NPC)
  --print('date ',days, daytime)
  print('Dead',NPC.name, 'Health: ',NPC.health, 'Awake level: ',NPC.awakeness, 'Hunger: ',NPC.hunger, 'Location: ',NPC.loc, 'Worked as a ',NPC.job, 'Died with ',NPC.coins,'coins', NPC.age, 'age')
  for i, v in ipairs(NPC.items) do
    print(v.item,v.num)
  end
  table.remove(NPC.jobwork.workers,tablefind(NPC.jobwork.workers,NPC.name))
  table.remove(NPC.home.occupants,tablefind(NPC.home.occupants,NPC))
  if #NPC.relationship > 0 then
    table.remove(NPC.relationship[1].relationship, tablefind(NPC.relationship[1].relationship, NPC))
  end
  if NPC.closetoplayer == true then
    table.remove(CloseNPCs,tablefind(CloseNPCs,NPC))
  elseif NPC.closetoplayer == false then
    table.remove(FarNPCs,tablefind(FarNPCs,NPC))
  end
  table.remove(ListofNPCs,tablefind(ListofNPCs,NPC))
end


function NPC_have_kids()
  if #ListofNPCs > 1000 then
    return
  end
  for i, v in ipairs(ListofNPCs) do
    if #v.spouse > 0 and #v.home.occupants < 3 then
      local chance = math.random(1, 5)
      if chance > 4 then
        create_NPC("NPC"..math.random(1,7), v.home, v.name..' and '..v.spouse[1], '', v.x, v.y,v.town)
        
      end
    end
  end
end

function NPC_find_home()
  for r, m in pairs(towns) do
    for i, v in ipairs(m) do
      local count = 0
      for o, b in ipairs(v.field) do
        if b.btype == 'home' then
          if #b.occupants == 0 then
            b.health = b.health - 150
            if b.health < 0 then
              table.remove(v.field,o)
              table.remove(Buildinglist, tablefind(Buildinglist,b))
            end
          end
          if #b.occupants > 2 then
            for e, d in ipairs(m) do
              local chance = math.random(1,10)
              if #d.field == 0 and count == 0 and chance == 1 then
                if math.floor(d.x/1000) ~= math.floor(player1.x/1000) or math.floor(d.y/1000) ~= math.floor(player1.y/1000) then 
                  if b.occupants[3].coins > 300 then
                    local choice = math.random(1, #tentgroup)
                    local house = create_building("home",tentgroup[choice].."tentoutside",tentgroup[choice].."tentinside",d.x, d.y,math.random(125,650),math.random(0,500), 125, 0, false, true, 'unemployed', 150,100, b.occupants[3].town)
                    if house == nil then
                      return
                    end
                    b.occupants[3].coins = b.occupants[3].coins - 300
                    table.insert(d.field, house)
                    table.insert(house.occupants,b.occupants[3])
                    b.occupants[3].home = house
                    table.remove(b.occupants, 3)
                    count = 1
                    
                  end
                end
              end
              for r, m in ipairs(d.field) do
                if m.btype == 'home' then
                  if #m.occupants < 1 and count == 0 then
                    b.occupants[3].home = m
                    table.insert(m.occupants, b.occupants[3])
                    table.remove(b.occupants, 3)
                    count = 1
                    b.home = m
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  for i, v in ipairs(ListofNPCs) do
    if v.coins > 50000 and v.home.health < 1000 then
      local house = create_building("home","house1outside","house1inside",0, 0,0, 0, 125, 0, false, true, 'unemployed', 150,1000,v.town)
      if house == nil then
        return
      end
      v.coins = v.coins - 50000
      if #v.home.occupants > 1 then
        local person1 = v.home.occupants[1]
        local person2 = v.home.occupants[1]
        table.insert(house.occupants,person1)
        table.insert(house.occupants,person2)
        table.remove(v.home.occupants, 1)
        table.remove(v.home.occupants, 2)
        person1.home = house
        person2.home = house
      else
        local person1 = v
        table.insert(house.occupants,person1)
        table.remove(v.home.occupants, 1)
        person1.home = house
      end
    end
    if v.coins > 1000 and v.home.health < 500 then
      local house = create_building("home","yellowhutoutside","yellowhutinside",0, 0,0, 0, 125, 0, false, true, 'unemployed', 150,500,v.town)
      if house == nil then
        return
      end
      v.coins = v.coins - 1000
      if #v.home.occupants > 1 then
        local person1 = v.home.occupants[1]
        local person2 = v.home.occupants[1]
        table.insert(house.occupants,person1)
        table.insert(house.occupants,person2)
        table.remove(v.home.occupants, 1)
        table.remove(v.home.occupants, 2)
        person1.home = house
        person2.home = house
      else
        local person1 = v
        table.insert(house.occupants,person1)
        table.remove(v.home.occupants, 1)
        person1.home = house
      end
    end
  end
end

function NPC_moving(player, dt)
  
  --when on ground, foot goes back
  if player.feet1y == 0 then
    player.feet1x = player.feet1x - dt*player.speed/2
  end
  
  --when in air, foot goes forward
  if player.feet1y == -10 then
    player.feet1x = player.feet1x + dt*player.speed/2
  end
  
  --When foot at end, foot goes up
  if player.feet1x <= 0 then
    player.feet1x = 0
    player.feet1y = player.feet1y - dt*player.speed/2
  end
  
  --Prevent foot up forever
  if player.feet1y < -10 then
    player.feet1y = -10
  end
  
  --bring foot down
  if player.feet1x >= 30 then
    player.feet1x = 30
    player.feet1y = player.feet1y + dt*player.speed/2
  end
  
  --Prevent foot down forever
  if player.feet1y > 0 then
    player.feet1y = 0
  end
  
  if player.feet2y == 0 then
    player.feet2x = player.feet2x - dt*player.speed/2
  end
  if player.feet2y == -10 then
    player.feet2x = player.feet2x + dt*player.speed/2
  end
  if player.feet2x <= 0 then
    player.feet2x = 0
    player.feet2y = player.feet2y - dt*player.speed/2
  end
  if player.feet2y < -10 then
    player.feet2y = -10
  end
  if player.feet2x >= 30 then
    player.feet2x = 30
    player.feet2y = player.feet2y + dt*player.speed/2
  end
  if player.feet2y > 0 then
    player.feet2y = 0
  end
  
end

function NPC_trait_chosen(NPC)
  table.sort(NPC.personality,function(a,b)
    return a[2]>b[2]
  end)
  while true do
    for i, v in ipairs(NPC.personality) do
      if math.random(1,110) < v[2] then
        return v
      end
    end
  end
end

function Find_NPC_trait(NPC, trait)
  for i, v in ipairs(NPC.personality) do
    if v[1] == trait then
      return v[2]
    end
  end
end

function find_NPC_by_name(name)
  for i,v in ipairs(ListofNPCs) do
    if v.name == name then
      return v
    end
  end
end

function taskhandler(NPC, dt)
  if #NPC.plan > 0 and NPC.knockback_status <=0 then
    if NPC.plan[1].action == 'attack' then
      NPC_attack_enemy(NPC, NPC.plan[1].target,dt)
    elseif NPC.plan[1].action == 'finditem' then
      NPC_pickup_item2(NPC, NPC.plan[1].item, dt)
    elseif NPC.plan[1].action == 'create_dirt_mound' then
      till_farm(NPC, NPC.plan[1], dt)
    elseif NPC.plan[1].action == 'plant_seed' then
      plant_seed(NPC, NPC.plan[1], dt)
    elseif NPC.plan[1].action == 'harvest' then
      harvest(NPC, NPC.plan[1], dt)
    elseif NPC.plan[1].action == 'sell' then
      NPCsellitem(NPC, NPC.plan[1], dt)
    elseif NPC.plan[1].action == 'buy' then
      NPCbuyitem(NPC, NPC.plan[1], dt)
    elseif NPC.plan[1].action == 'cut_tree' then
      NPC_cut_tree(NPC, NPC.plan[1], dt)
    elseif NPC.plan[1].action == 'gotowork' then
      NPC_go_work(NPC, dt)
    elseif NPC.plan[1].action == 'buy' then
      if #NPC.nobuy > 1 then
        for i, v in ipairs(NPC.nobuy) do
          if v == NPC.plan[1].item then
            table.remove(NPC.plan, 1)
          end
        end
      end
      NPCbuyitem(NPC, NPC.plan[1], dt)
    elseif NPC.plan[1].action == 'recreation' then
      NPCsocialise(NPC, NPC.plan[1], dt)
    elseif NPC.plan[1].action == 'sleep' then
      NPCsleep(NPC, NPC.plan[1], dt)
    elseif NPC.plan[1].action == 'talk' and #NPC.spouse < 1 then
      NPCsocialise2(NPC, NPC.plan[1], dt)
    elseif NPC.plan[1].action == 'askout' then
      --NPC_ask_out(NPC, NPC.plan[1], dt)
    elseif NPC.plan[1].action == 'create_armour' then
      create_armour(NPC, NPC.plan[1], dt)
    elseif NPC.plan[1].action == 'create_tool' then
      create_tool(NPC, NPC.plan[1], dt)
    elseif NPC.plan[1].action == 'gohome' then
      NPC_go_home(NPC, dt)
    elseif NPC.plan[1].action == 'random_patrol' then
      NPC_random_patrol(NPC, NPC.plan[1], dt)
    elseif NPC.plan[1].action == 'construction' then
      NPC_build_building(NPC, NPC.plan[1], dt)
    end
  end
end