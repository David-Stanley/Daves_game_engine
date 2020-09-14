function love.keypressed(key, scancode, isrepeat)
  
  if world == 'mainworld' then
    if key =='return' and talking==true then
      player1.question = dialog.NPCtalk[dialog.select]
    end
    if key == 'return' then
      start_converation(player1, dt)
    elseif key == 'up' and talking == true then
      dialog.select = dialog.select -1
    elseif key == 'down' and talking == true then
      dialog.select = dialog.select +1
    end
    if key == 'm' then
      player1.coins = 1000
      player1.health = 100000
    end
    if key == 'p' then
      if gameinfo == true then
        gameinfo = false
      else
        gameinfo = true
      end
    end
    
    --crafting--
    if key == 'c' then
      if player1.currentlycrafting == true then
        player1.currentlycrafting = false
      else
        player1.currentlycrafting = true
        player1.invopen=false
        tradingon=false
      end
    end
    if key == 'i' then
      if player1.invopen==true then
        player1.invopen=false
        
      else
        player1.invopen=true
        player1.extrainvnum=1
        player1.currentlycrafting=false
        tradingon=false
      end
    end
    
    if key == 'left' and player1.invopen==true then
      if player1.extrainvnum > 1 then
        player1.extrainvnum=player1.extrainvnum - 1
      end
    end
    if key =='right' and player1.invopen==true then
      if player1.extrainvnum < #player1.extra_inventory then
        player1.extrainvnum=player1.extrainvnum + 1
      end
    end
      
    if key == 'return'and player1.invopen==true then
      if player1.extrainvnum >= #player1.extra_inventory then
        player1.extrainvnum= #player1.extra_inventory
      end
      if player1.extrainvnum == 0 and player1.items[player1.invnum].item == 'empty' then
        return
      elseif player1.extrainvnum == 0 then
        table.insert(player1.extra_inventory,player1.items[player1.invnum])
        player1.items[player1.invnum] = create_item(0, 0, 'empty', 0, 1, "empty",0, false)
        player1.held = player1.items[player1.invnum]
        print(player1.held)
        return
      end
      if player1.items[player1.invnum].item == 'empty' then
        player1.items[player1.invnum] = player1.extra_inventory[player1.extrainvnum]
        table.remove(player1.extra_inventory,player1.extrainvnum)
      elseif player1.items[player1.invnum].item == player1.extra_inventory[player1.extrainvnum].item then
        player1.extra_inventory[player1.extrainvnum].num = player1.extra_inventory[player1.extrainvnum].num + player1.items[player1.invnum].num
        player1.items[player1.invnum] = create_item(0, 0, 'empty', 0, 1, "empty",0, false)
      else
        table.insert(player1.extra_inventory,player1.items[player1.invnum])
        player1.items[player1.invnum] = create_item(0, 0, 'empty', 0, 1, "empty",0, false)
      end
      
    end
        
    --- trading ---
    if key == 'left' and tradeoptionnumber > 1 then
      tradeoptionnumber = tradeoptionnumber - 1
    end
    if key == 'right' then
      tradeoptionnumber = tradeoptionnumber + 1
    end
    if tradingon == true and key =='return' then
      Buynum=Buynum+1
    end
    if tradingon == true and key =='space' then
      if BuyorSell == 'buy' then
        BuyorSell = 'sell'
      elseif BuyorSell == 'sell' then
        BuyorSell = 'buy'
      end
    end
  elseif world == 'menu' then
    if key == 'up' then
      Menuselection = Menuselection - 1
    elseif key == 'down' then 
      Menuselection = Menuselection + 1
    elseif key == 'return' then
      Menuchoice = Menuoptions[Menuselection]
    end
  elseif world == 'textworld' then
    if key and key:match( '^[%w%s]$' ) then
      whatswritten = whatswritten..key
    elseif key == 'return' then
      textbox.name = whatswritten
      world=oldworld
    elseif key == 'backspace' then
      whatswritten = whatswritten:sub( 1, #whatswritten-1 )
    end
  end
  
  if key == 'j' and player1.block == false and player1.superattackcooldown <= 0 then
    if player1.superattack == true then
      player1.superattack2 = true
    end
    if player1.superattack2 == false and player1.superattack3 == false then
      player1.superattack = true
    end
    if player1.superattack2 == true and player1.superattack == false and player1.superattack3 == false then
      player1.superattack3 = true
    end
  end
end

function love.wheelmoved(x,y)
  if y > 0 then
    drawscale = drawscale + 0.05
  elseif y < 0 then
    drawscale = drawscale - 0.05
  end
end