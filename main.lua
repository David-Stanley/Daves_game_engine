function love.load()
  math.randomseed(os.time())
  require('all_images')
  require("gameitems")
  require('NPC')
  require("player")
  require("environment")
  require("classic")
  require("Check_collisions")
  require("Unusual")
  require("Buildings")
  require('Animals')
  require('NPCjobs')
  require('dialog')
  require('Trading')
  require('NPC_homework')
  require('NPC_downtime')
  require('mainworld')
  lume = require('lume')
  require('all_game_images')
  require('menu')
  require('keypresses')
  require('combat')
  require('player_influence')
  require('textworld')
  require('NPC_socialisation')
  require('luamulti')
  
  
  --Creating the town aswell as declaring a few things that will be used later
  startgame()

end

function love.update(dt)
  fps=love.timer.getFPS( )
  timer = timer + dt
  if world == 'textworld' then
    
  end
  if world == 'menu' then
    menuselect()
  end
  if world == 'mainworld' then
    local i = 0
    
    if timer > 1 then      
      for i, v in pairs(towns) do
        check_chunks_for_town(v.townname)
      end
      timer = 0
      check_NPC()
      check_chunks()
      playerenvtable(player1, 30000)
    end
    if speed > 1 then
      dt = dt * speed
      while i ~= speed do
        mainworld(dt/speed)
        i=i+1
      end
    end
    if speed == 1 then
      while i ~= 3 do
        mainworld(dt/3)
        i=i+1
      end
    end
  end
  
  if love.keyboard.isDown("b") then
    speed = 50
  end
  if love.keyboard.isDown("n") then
    speed = 1
  end
  

  


end

function love.draw()
  
  if world == 'mainworld' then
    draw_mainworld()
    love.graphics.origin()
    if gameinfo == true then
      love.graphics.print('Days ' .. days .. ' Time ' .. math.floor(daytime*100)/100, 10, 60, 0, 2, 2)
      love.graphics.print('Coins ' .. player1.coins, 10, 110, 0, 2, 2)
      love.graphics.print('NPCs ' .. #ListofNPCs, 10, 180, 0, 2, 2)
      love.graphics.print('Health ' .. player1.health, 10, 230, 0, 2, 2)
      love.graphics.print('Coords'..player1.x..'x '..player1.y..'y')
    end
    draw_userinterface(player1)
    if player1.currentlycrafting==true then
      drawcraftmenu(player1)
    end
    if player1.invopen==true then
      drawopeninventory(player1)
    end
  elseif world == 'menu' then
    drawmenu(Menuoptions)
  elseif world == 'textworld' then
    drawtextworld()
  end
  if talking == true then
    draw_player_dialog()
  end
  if tradingon == true then
    drawtrading(player1, Trader2)
  end
  if gameinfo == true then
    love.graphics.print('Fps ' .. fps, 10, 10, 0, 2, 2)
  end

end