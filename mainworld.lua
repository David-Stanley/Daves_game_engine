function mainworld(dt)
  NPC_timer = NPC_timer + dt
  --This controls the players movement and attack, but does not control dialgoue.
  playermovement(player1, dt)
  --This generates the environment for the player as the player walks out. It will generate by the row or column though, and therefore is error-prone
  --enviro_for_player()
  --FPS
  fps=love.timer.getFPS( )
  --This identifies if the NPC has enough health, hunger, etc. It also manages their inventory a bit.
  NPC_needs(CloseNPCs,dt)
  animal_needs(dt)
  
  --This is to determine whether the player is talking or not and is used to determine where the dialogue should begin with and if its the players turn
  if talking == false then
    dialog.next = false
  end
  
  --This turns on the player trading menu
  if tradingon == true then
    opentrading(Trader1, Trader2)
  end
  
  --This is the time. Work, play and home time are dependent upon this value
  daytime = daytime + (dt/60)
  
  if NPC_timer > 0.5 then
    check_blocks()
    NPC_needs(FarNPCs,NPC_timer)
    if daytime < 10 then
      lightlevel = 'morning'
      for i,v in ipairs(FarNPCs) do
        NPC_work(v, NPC_timer)
      end
    end
    
    --Play
    if daytime > 10 and daytime < 23 then
      for i,v in ipairs(FarNPCs) do
        NPC_downtime(v, NPC_timer)
      end
      --lightlevel='afternoon'
    end
    NPC_timer = 0
  end
  
  --Work
  if daytime < 16 then
    lightlevel = 'morning'
    for i,v in ipairs(CloseNPCs) do
      NPC_work(v, dt)
    end
  end
  
  --Play
  if daytime > 16 and daytime < 23 then
    for i,v in ipairs(CloseNPCs) do
      NPC_downtime(v, dt)
    end
    --lightlevel='afternoon'
  end
  
  
  --End of day
  if daytime > 24 then
  --Resets the time
    daytime = 0
  --Checks if theres any blocks that need altering to the town or environment
    check_blocks()
    --NPC things. Have them find homes and jobs from empty buildings. Generate kids if in love and enough room. Progress farm plants. Add another day to schedule.
    NPC_find_home()
    NPC_age_up(ListofNPCs)
    NPC_have_kids()
    NPC_find_job()
    check_farms()
    days = days + 1
    for i, v in ipairs(ListofNPCs) do
      if v.job == 'trader' then
        check_trade_goods(v)
      end
    end
    for i,v in ipairs(ListofNPCs) do
      NPC_downtime(v, dt)
      if v.coins < 200 then
        v.coins = v.coins + 100
        --print('Name is '..v.name..' and I have '..v.coins..' coins! I work as a '..v.job)
      end
      
      --v.coins = 10000000
    end
  end
  
  PeopleandBuildings = make_drawable()
end


function draw_mainworld()
  player1.loc='outside'
  local x, y = getmiddle(player1)
  --move camera to player
  love.graphics.translate((-x + (gamewindow.width/2)/drawscale) *drawscale, (-y+ (gamewindow.height/2)/drawscale)*drawscale)
  --love.graphics.translate((-player1.x + (gamewindow.width/2)) * 0.25, (-player1.y + (gamewindow.height/2)) * 0.25)
  love.graphics.scale(drawscale,drawscale)  
  --draw the environment and everything in it

  draw_mainworld_test()
  
  if lightlevel == 'afternoon' then
    love.graphics.draw(Afternoonlight, player1.x-2000, player1.y-1000)
  end
  if lightlevel == 'night' then
    love.graphics.draw(Nightlight, player1.x-2000, player1.y-1000)
  end
end