tradeoptionnumber = 1
Buynum = 0
BuyorSell = 'buy'

function drawtrading(player, NPC)
  count = 1
  while count ~= 10 do
    love.graphics.draw(Image_table['UItile'], gamewindow.width / 10 * count - 50, gamewindow.height - gamewindow.height/5)
    --love.graphics.draw(UI.tile, gamewindow.width / 10 * 10 - 100, gamewindow.height/10 * count)
    count = count + 1
  end
  count = 1
  for i,v in ipairs(NPC.items) do
    if count > 9 then
      love.graphics.rectangle("fill", gamewindow.width / 10 * 10 - 50, gamewindow.height - gamewindow.height/5+15, 30, 30)
    end
    if count == tradeoptionnumber and tradeoptionnumber < 10 then
      love.graphics.rectangle("line", gamewindow.width / 10 * count - 50, gamewindow.height - gamewindow.height/5, 60, 60)
    elseif tradeoptionnumber > 9 then
      love.graphics.rectangle("line", gamewindow.width / 10 * 9 - 50, gamewindow.height - gamewindow.height/5, 60, 60)
    end
    if i > tradeoptionnumber - 9 and (i == tradeoptionnumber or count < 10) then
      count = count+1
      if v.specialtype == 'armour' then
        love.graphics.draw(Image_table[v.image], gamewindow.width / 10 * (count-1) - 50 -20, gamewindow.height - gamewindow.height/5 - 75)
      else
        love.graphics.draw(Image_table[v.image], gamewindow.width / 10 * (count-1) - 50, gamewindow.height - gamewindow.height/5)
      end
      love.graphics.print(tostring(v.num), gamewindow.width / 10 * (count-1) - 50, gamewindow.height - gamewindow.height/5)
      if BuyorSell == 'buy' then
        love.graphics.print(tostring(v.item), gamewindow.width / 10 * (count-1) - 50, gamewindow.height - gamewindow.height/5-40)
        love.graphics.print(tostring('value: '..v.value), gamewindow.width / 10 * (count-1) - 50, gamewindow.height - gamewindow.height/5-20)
      end
    end
  end
  love.graphics.print(tostring(BuyorSell), 10, 270, 0, 2, 2)
end



function opentrading(player, NPC)
  if #NPC.items < 1 then
    return
  end
  if NPC.items[tradeoptionnumber] == nil then-- or tradeoptionnumber > #NPC.items then
    tradeoptionnumber = 1
  end
  
  if NPC.items[tradeoptionnumber].num < 1 or NPC.items[tradeoptionnumber].item == 'empty' then
    table.remove(NPC.items, tradeoptionnumber)
  end
  if player.items[player.invnum].num < 1 and player.items[player.invnum].item ~= 'empty' then
    player.items[player.invnum] = create_item(0, 0, 'empty', 0, 1, "empty",0, false)
  end
  Trader1 = player
  Trader2 = NPC
  tradingon = true
  talking = false
  if Buynum > 1 then
    if BuyorSell == 'buy' then
    if player.items[player.invnum].item == NPC.items[tradeoptionnumber].item and player.items[player.invnum].item ~= 'empty' then
      if player.coins >= NPC.items[tradeoptionnumber].value+NPC.items[tradeoptionnumber].value/player.charisma then
        player.items[player.invnum].num = player.items[player.invnum].num + 1
        NPC.items[tradeoptionnumber].num = NPC.items[tradeoptionnumber].num - 1
        player.coins = player.coins - (NPC.items[tradeoptionnumber].value+NPC.items[tradeoptionnumber].value/player.charisma)
        NPC.coins = NPC.coins + NPC.items[tradeoptionnumber].value+NPC.items[tradeoptionnumber].value/player.charisma
      end
    elseif NPC.items[tradeoptionnumber].item ~= 'empty' and player.items[player.invnum].item == 'empty' then
      if player.coins >= NPC.items[tradeoptionnumber].value then
        player.items[player.invnum] = create_item(0, 0, NPC.items[tradeoptionnumber].item, 1, NPC.items[tradeoptionnumber].damage, NPC.items[tradeoptionnumber].image, NPC.items[tradeoptionnumber].value, false, NPC.items[tradeoptionnumber].specialtype, NPC.items[tradeoptionnumber].specialvalue)
        NPC.items[tradeoptionnumber].num = NPC.items[tradeoptionnumber].num - 1
        player.coins = player.coins - (NPC.items[tradeoptionnumber].value+NPC.items[tradeoptionnumber].value/player.charisma)
        NPC.coins = NPC.coins + NPC.items[tradeoptionnumber].value+NPC.items[tradeoptionnumber].value/player.charisma
      end
    end
    elseif BuyorSell == 'sell' then
      if player.items[player.invnum].item == NPC.items[tradeoptionnumber].item and player.items[player.invnum].item ~= 'empty' then
        if NPC.coins >= player.items[player.invnum].value then
          player.items[player.invnum].num = player.items[player.invnum].num - 1
          NPC.items[tradeoptionnumber].num = NPC.items[tradeoptionnumber].num + 1
          NPC.coins = NPC.coins - player.items[player.invnum].value
          player.coins = player.coins + NPC.items[tradeoptionnumber].value
        end
      elseif player.items[player.invnum].item ~= 'empty' then
        if NPC.coins >= player.items[player.invnum].value then
          table.insert(NPC.items,create_item(0, 0, player.items[player.invnum].item, 1, player.items[player.invnum].damage, player.items[player.invnum].image,player.items[player.invnum].value, false, player.items[player.invnum].specialtype, player.items[player.invnum].specialvalue))
          player.items[player.invnum].num = player.items[player.invnum].num - 1
          NPC.coins = NPC.coins - player.items[player.invnum].value
          player.coins = player.coins + NPC.items[tradeoptionnumber].value
          end
      end
    end
    Buynum = 0
  end
end


function NPC2NPCfoodtrade(trader, buyer, item, amount)
  local buyerloc =false
  local wanteditem
  local wanteditemloc
  if amount == nil then
    table.insert(buyer.nobuy, item)
    return
  end
  ---if trader doesn't exist, then quit
  if trader == nil then
    return
  end
  --check trader for item
  for i, v in ipairs(trader.items) do
    if v.specialtype == 'food' then
      amount = math.floor(v.specialvalue/amount)
      if v.num < 20 then
        print('out of fruit')
        table.insert(buyer.nobuy, item)
      end
      wanteditem=v
      wanteditemloc=i
    end
  end
  ---if trader doesn't have item
  if wanteditem == nil then
    table.insert(buyer.nobuy, item)
    return
  end
  --if buyer doesn't have enough coins, then limit to the amount that can be bought.
  if buyer.coins < wanteditem.value * amount then
    amount = math.floor(buyer.coins/wanteditem.value)
  end  
  if wanteditem.num < amount then
    amount = wanteditem.num
  end
  
  
  ---check if item exists already
  for i, v in ipairs(buyer.items) do
    if v.item == item then
      buyerloc = i
      buyer.items[i].num = buyer.items[i].num + amount
      trader.items[wanteditemloc].num = trader.items[wanteditemloc].num-amount
      trader.coins = trader.coins + (amount*wanteditem.value)
      buyer.coins = buyer.coins - (amount*wanteditem.value)
      if trader.items[wanteditemloc].num < 1 then
        table.remove(trader.items,wanteditemloc)
      end
      return
    end
  end
  
  
  --if item doesn't exist in inventory
  if buyerloc == false then
    for i, v in ipairs(buyer.items) do
      if v.item == 'empty' then
        buyerloc = i
        buyer.items[i]= create_item(0, 0, wanteditem.item, amount, wanteditem.damage, wanteditem.image, wanteditem.value, false, wanteditem.specialtype, wanteditem.specialvalue)
        trader.items[wanteditemloc].num = trader.items[wanteditemloc].num-amount
        if trader.items[wanteditemloc].num < 1 then
          trader.items[wanteditemloc] = create_item(0, 0, 'empty', 0, 1, "empty",0, false)
        end
        return
      end
    end
  end
  
  if buyerloc == false then
    table.insert(buyer.items, create_item(0, 0, wanteditem.item, amount, wanteditem.damage, wanteditem.image, wanteditem.value, false, wanteditem.specialtype, wanteditem.specialvalue))
    return
  end
end



function NPC2NPCtrade(trader, buyer, item, amount)
  local buyerloc =false
  local wanteditem
  local wanteditemloc
  if amount == nil then
    table.insert(buyer.nobuy, item)
    return
  end
  ---if trader doesn't exist, then quit
  if trader == nil or buyer == nil or item == nil then
    return
  end
  --check trader for item
  for i, v in ipairs(trader.items) do
    if v.item == item then
      if item =='fruit' then
        if v.num < 20 then
          print('out of fruit')
          table.insert(buyer.nobuy, item)
        end
      end
      wanteditem=v
      wanteditemloc=i
    end
  end
  ---if trader doesn't have item
  if wanteditem == nil then
    table.insert(buyer.nobuy, item)
    return
  end
  --if buyer doesn't have enough coins, then limit to the amount that can be bought.
  if buyer.coins < wanteditem.value * amount then
    amount = math.floor(buyer.coins/wanteditem.value)
  end  
  if wanteditem.num < amount then
    amount = wanteditem.num
  end
  
  
  ---check if item exists already
  for i, v in ipairs(buyer.items) do
    if v.item == item then
      buyerloc = i
      buyer.items[i].num = buyer.items[i].num + amount
      trader.items[wanteditemloc].num = trader.items[wanteditemloc].num-amount
      if trader.items[wanteditemloc].num < 1 then
        table.remove(trader.items, wanteditemloc)
      end
      trader.coins = trader.coins + (amount*wanteditem.value)
      buyer.coins = buyer.coins - (amount*wanteditem.value)
      return
    end
  end
  
  
  --if item doesn't exist in inventory
  if buyerloc == false then
    buyerloc = i
    table.insert(buyer.items, create_item(0, 0, wanteditem.item, amount, wanteditem.damage, wanteditem.image, wanteditem.value, false, wanteditem.specialtype, wanteditem.specialvalue))
    trader.items[wanteditemloc].num = trader.items[wanteditemloc].num-amount
    if trader.items[wanteditemloc].num < 1 then
      table.remove(trader.items,wanteditemloc)
    end
    return
  end
  
  if buyerloc == false then
    return
  end
end



function NPCsellitem(Worker, task, dt)
  if task.x == nil then
    table.remove(Worker.plan, 1)
    return
  end
  NPC_experimental_travel_2(Worker, task, dt)
  if Worker.loc == 'trader' then
    task.time = task.time - dt
    if task.time < 0 then
      NPC2NPCtrade(Worker, task.worker, task.item, task.amount)
      table.remove(Worker.plan,1)
      Worker.working = false
    end
  end
end

function NPCbuyitem(Worker, task, dt)
  NPC_experimental_travel_2(Worker, task, dt)
  if Worker.loc == task.loc then
    task.time = task.time - dt
    if task.time < 0 then
      NPC2NPCtrade(task.worker, Worker, task.item, task.amount)
      table.remove(Worker.plan,1)
    end
  end
end

function itemoverstock(Worker, item, max, min)
  local count = 0
  for i, v in ipairs(Worker.items) do
    if v.item == item then
      count = count + v.num
      if count > max then
        task = {}
        for o, b in ipairs(towns[Worker.town]) do
          for e, d in ipairs(b.field) do
            if d.btype == 'trader' then                                                                 ---WILL NEED TO IMPROVE WHEN MULTIPLE TRADERS!
              if #d.workers > 0 then
                task.x = d.x + d.w/2 + math.random(-30, 30)
                task.y = d.y + d.h/2 + 80
                task.worker = find_NPC_by_name(d.workers[1])
              end
            end
          end
        end
        task.action = 'sell'
        task.amount = count-min
        task.loc = 'trader'
        task.time = 1
        task.item = item
        return task
      end
    end
  end
end

function itemunderstock(NPC, item, amount, min)
  local count = 0
  for i, v in ipairs(NPC.items) do
    if v.item == item then
      count = count + v.num
    end
  end
  if count < min then
    task = {}
    for o, b in ipairs(towns[NPC.town]) do
      for e, d in ipairs(b.field) do
        if d.btype == 'trader' then                                                                 ---WILL NEED TO IMPROVE WHEN MULTIPLE TRADERS!
          if #d.workers > 0 then
            task.x = d.x + d.w/2 + math.random(-30, 30)
            task.y = d.y + d.h/2 + 80
            task.timeout = 180
            task.worker = find_NPC_by_name(d.workers[1])
            task.amount = amount
            task.action = 'buy'
            task.loc = 'action'
          end
        end
      end
    end
    task.time = 1
    task.item = item
    return task
  else
    return
  end

end

function foodunderstock(NPC, amount, min)
  local count = 0
  for i, v in ipairs(NPC.items) do
    if v.specialtype == 'food' then
      count = count + v.specialvalue
    end
  end
  if count < min then
    task = {}
    for o, b in ipairs(towns[NPC.town]) do
      for e, d in ipairs(b.field) do
        if d.btype == 'trader' then                                                                 ---WILL NEED TO IMPROVE WHEN MULTIPLE TRADERS!
          if #d.workers > 0 then
            task.x = d.x + d.w/2 + math.random(-30,30)
            task.y = d.y + d.h/2 + 80
            task.timeout = 180
            task.loc = 'trader'
            task.worker = find_NPC_by_name(d.workers[1])
            task.amount = amount
            task.action = 'buy'
          end
        end
      end
    end
    task.time = 1
    task.specialtype = 'food'
    return task
  end
end

function checkamount(NPC, item, min)
  local count = 0
  for i, v in ipairs(NPC.items) do
    if v.item == item then
      count = count + v.num
      if count >= min then
        return true
      end
    end
  end
  return false
end


function check_trade_goods(trader)
  armouravailable = {}
  for i, v in ipairs(trader.items) do
    if v.specialtype == 'food' then
      foodavailable = true
    elseif v.specialtype == 'armour' then
      table.insert(armouravailable,v)
    end
  end
end