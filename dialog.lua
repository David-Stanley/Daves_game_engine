dialog = {}
dialog.x = 20
dialog.y = gamewindow.height - gamewindow.height/4
dialog.w = gamewindow.width-40
dialog.h = gamewindow.height/4-20  
dialog.next = false
dialog.select = 1
  


  
function draw_player_dialog()
  dialog.x = 20
  dialog.y = gamewindow.height - gamewindow.height/4
  dialog.w = gamewindow.width-40
  dialog.h = gamewindow.height/4-20
  love.graphics.rectangle('fill', dialog.x, dialog.y, dialog.w, dialog.h)
  if dialog.select < 1 then
    dialog.select = 1
  elseif dialog.select > #dialog.NPCtalk and tradingon == false then
    dialog.select = #dialog.NPCtalk
  end
  local number = 1
  for i, v in ipairs(dialog.NPCtalk) do
    local colour = {0.5, 0.5, 0.5, 100}
    if i == math.floor(dialog.select) then
      colour = {0, 0, 0, 100}
    end
    if number < 7 and i < math.floor(dialog.select) + 6 and i > math.floor(dialog.select) - 6 then
      love.graphics.print({colour,dialog.NPCtalk[i]}, dialog.x + 100, dialog.y + ((30*number)*gamewindow.height/1000), 0, 2 * gamewindow.height/1000, 2 * gamewindow.height/1000)
      number = number+1
    end
    if dialog.headloc == 'left' then
      love.graphics.draw(Image_table[dialog.head], dialog.x + 100 , dialog.y, 0, -1, 1)
      love.graphics.draw(Image_table[dialog.eyes], dialog.x + 100 , dialog.y, 0, -1, 1)
      love.graphics.draw(Image_table[dialog.hair], dialog.x + 100 , dialog.y, 0, -1, 1)
      love.graphics.draw(Image_table[dialog.mouth], dialog.x + 100 , dialog.y, 0, -1, 1)
    else
      love.graphics.draw(Image_table[dialog.head], dialog.x + dialog.w-100 , dialog.y)
      love.graphics.draw(Image_table[dialog.eyes], dialog.x + dialog.w-100 , dialog.y)
      love.graphics.draw(Image_table[dialog.hair], dialog.x + dialog.w-100 , dialog.y)
      love.graphics.draw(Image_table[dialog.mouth], dialog.x + dialog.w-100 , dialog.y)
    end
  end
end

function opendialog(player, NPC)
  talking = true
  dialog.NPCtalk = NPC.dialog[player.question]
  dialog.NPC=NPC
  if dialog.NPCtalk == nil then
    dialog.NPCtalk = NPC.dialog['intro']
  end
  if player.question == 'Ok, let us trade' then
    opentrading(player, NPC)  
  elseif player.question == 'I am glad you want to contribute to our town, what will you name your property?' then
    buyland(player)
  elseif player.question == 'I will help you build that house!' then
    buildonland(player, NPC, create_building("playerhome","house1outside","house1inside",player.construction.x, player.construction.y, 125, 0, 125, 0, false, true))
  elseif player.question == 'I will help you build that farm!' then
    buildonland(player, NPC, create_building("farm","farm1","farm1",player.construction.x, player.construction.y, 125, 0, 125, 0, false, true, 'farmer'))
  elseif player.question == 'I will help you build that woodcuttershut!' then
    buildonland(player, NPC, create_building("sawmill","Sawmill1outside","Sawmill1inside",player.construction.x, player.construction.y, 125, 0, 125, 0, false, true, 'woodcutter'))
  elseif player.question == 'I will help you build that mininghut!' then
    buildonland(player, NPC, create_building("minehut","Minehut1outside","Minehut1inside",player.construction.x, player.construction.y, 125, 0, 125, 0, false, true, 'stonecutter'))
  end
  if NPC.job == 'builder' then
    for i, v in ipairs(player.land) do
      if v.name == player.question then
        player.construction = v
      end
    end
  end

  if #dialog.NPCtalk > 1 then
    dialog.head = player.head
    dialog.eyes = player.eyes
    dialog.hair = player.hair
    dialog.mouth = player.mouth
    dialog.headloc = 'right'
  elseif #dialog.NPCtalk == 1 then
    dialog.head = NPC.head
    dialog.eyes = NPC.eyes
    dialog.hair = NPC.hair
    dialog.mouth = NPC.mouth
    dialog.headloc = 'left'
  end
end

function conversation_builder_work(NPC)
  
  
  
  NPC.dialog['intro'] = {'Hello, my name is '..NPC.name}
  
  
  if NPC.job == 'mayor' then
    if not check_dialog_existance(NPC.dialog['Hello, my name is '..NPC.name], 'I would like to purchase a block of land') then
      table.insert(NPC.dialog['Hello, my name is '..NPC.name], 'I would like to purchase a block of land')
    end
    NPC.dialog['I would like to purchase a block of land'] = {'Sure, we can spare something, that will be 200 coins however'}
    NPC.dialog['Sure, we can spare something, that will be 200 coins however'] = {'I will buy the land', 'Sounds a bit steep, lets discuss something else'}
    NPC.dialog['I will buy the land'] = {'I am glad you want to contribute to our town, what will you name your property?'}
  end
  
  if NPC.jobwork.btype == 'trader' and NPC.loc == 'workplace' then
    NPC.dialog['intro'] = {'Hello, I am your local trader, '..NPC.name..'. Would you like to buy or sell any goods?'}
    NPC.dialog['Hello, I am your local trader, '..NPC.name..'. Would you like to buy or sell any goods?'] = {'Yes please','No thank you','Rumours?','What are you doing?'}
    NPC.dialog['Yes please']={'Ok, let us trade'}
    NPC.dialog['No thank you']={"Ok, goodbye then"}
    NPC.dialog['Ok, let us trade']={'Ok, let us trade'}
  end
  
  if NPC.jobwork.btype == 'farm' then
    NPC.dialog['intro'] = {'Gotta get this crop in and harvested. The fate of the town depends on it!'}
    NPC.dialog['Gotta get this crop in and harvested. The fate of the town depends on it!'] = NPC.dialog['Hello, my name is '..NPC.name]
    NPC.dialog["Trade"] = {'Ok, let us trade'}
    NPC.dialog['Ok, let us trade']={'Ok, let us trade'}
  end
  
  if NPC.job == 'builder' then
    if #player1.land > 0 then
      if not check_dialog_existance(NPC.dialog['Hello, my name is '..NPC.name], 'I own some land. Can you help me build something?') then
        table.insert(NPC.dialog['Hello, my name is '..NPC.name], 'I own some land. Can you help me build something?')
      end
      NPC.dialog['I own some land. Can you help me build something?'] = {'We can work something out. Which property?'}
      NPC.dialog['We can work something out. Which property?'] = {'I changed my mind'}
      NPC.dialog['Certainly, and what would like built?'] = {'I would like a farm there','I would like a house there','I would like a woodcutters hut there','I would like a stonecutters hut there'}
      NPC.dialog['I would like a farm there'] = {'I will help you build that farm!'}
      NPC.dialog['I would like a house there'] = {'I will help you build that house!'}
      NPC.dialog['I would like a woodcutters hut there'] = {'I will help you build that woodcuttershut!'}
      NPC.dialog['I would like a stonecutters hut there'] = {'I will help you build that mininghut!'}
    end
  end
end


function start_converation(player_action, dt)
  
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

  for o,b in ipairs(ListofNPCs) do
    local b_left = b.x
    local b_right = b.x + b.h
    local b_bottom = b.y + b.w
    local b_top = b.y
          
    if a_right > b_left and
      a_left < b_right and
      a_bottom > b_top and
      a_top < b_bottom then
        opendialog(player_action, b)
        talking=true
        if #b.plan == 0 then
          task = {}
          task.timeout = 10
          task.action = 'talking'
          table.insert(b.plan, 1, task)
        elseif b.plan[1].action ~= 'talking' then
          task = {}
          task.timeout = 10
          task.action = 'talking'
          table.insert(b.plan, 1, task)
        else
          b.plan[1].timeout = 10
        end
      end
    end
end

function check_dialog_existance(list, dialog)
  for i, v in pairs(list) do
    if v == dialog then
      return true
    end
  end
  return false
end