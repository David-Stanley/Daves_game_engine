Menuoptions={'Resume game', 'New game', 'Save game', 'Load game', 'Settings', 'Exit'}
Menuselection = 1
Menuchoice = ''


function drawmenu(menu)
  love.graphics.setColor(0,1,1)
  if Menuselection < 1 then
    Menuselection = 1
  elseif Menuselection > #menu then
    Menuselection = #menu
  end
  for i, v in ipairs(menu) do
    local colour = {0.5, 0.5, 0.5, 100}
    if i == math.floor(Menuselection) then
      colour = {1, 1, 1, 100}
    end
    love.graphics.print({colour,menu[i]}, gamewindow.width/2-50, gamewindow.height/10+(50*i), 0, 2, 2)
  end
  love.graphics.setColor(1,1,1)
end

function menuselect()
  if Menuchoice == 'New game' then
    startgame()
  elseif Menuchoice == 'Load game' then
    loadgame()
  elseif Menuchoice == 'Resume game' then
    world = 'mainworld'
    playerenvtable(player1)
  elseif Menuchoice == 'Save game' then
    print('starting save process')
    savegame()
  elseif Menuchoice == 'Settings' then
    Menuoptions={'Resolution '..gamewindow.width..'X'..gamewindow.height,'Scale '..drawscale,'Render distance '..viewdistance, 'Back'}
    
  elseif Menuchoice == 'Resolution '..gamewindow.width..'X'..gamewindow.height then
    Menuoptions = {'1280x720','1920x1080','2560x1440','1920x1200','1200x1920','1280x900','Vsync on', 'Vsync off', 'detail high', 'detail low', 'Fullscreen on', 'Fullscreen off', 'Settings'}
  elseif Menuchoice == '1280x720' then
    love.window.setMode(1280,720)
    gamewindow.width = 1280
    gamewindow.height = 720
  elseif Menuchoice == '1280x900' then
    love.window.setMode(1280,900)
    gamewindow.width = 1280
    gamewindow.height = 900
  elseif Menuchoice == '1920x1200' then
    love.window.setMode(1920,1200)
    gamewindow.width = 1920
    gamewindow.height = 1200
  elseif Menuchoice == '1200x1920' then
    love.window.setMode(1200,1920)
    gamewindow.width = 1200
    gamewindow.height = 1920
  elseif Menuchoice == '1920x1080' then
    love.window.setMode(1920,1080)
    gamewindow.width = 1920
    gamewindow.height = 1080
  elseif Menuchoice == '2560x1440' then
    love.window.setMode(2560,1440)
    gamewindow.width = 2560
    gamewindow.height = 1440
  elseif Menuchoice == 'Vsync on' then
    love.window.setVSync(1)
  elseif Menuchoice == 'Vsync off' then
    love.window.setVSync(0)
  elseif Menuchoice == 'detail high' then
    detail = 'high'
  elseif Menuchoice == 'detail low' then
    detail = 'low'
  elseif Menuchoice == 'Fullscreen on' then
    love.window.setMode(gamewindow.width, gamewindow.height, {fullscreentype='exclusive',fullscreen=true})
    --love.window.setFullscreen(true, "desktop")
  elseif Menuchoice == 'Fullscreen off' then
    love.window.setFullscreen(false, "desktop")
    
  elseif Menuchoice == 'Render distance '..viewdistance then
    Menuoptions={'1000','2000','3000','4000','5000','6000','7000','8000','15000', 'Settings'}
  elseif Menuchoice == '10000' then
    viewdistance = 10000
  elseif Menuchoice == '20000' then
    viewdistance = 20000
  elseif Menuchoice == '30000' then
    viewdistance = 30000
  elseif Menuchoice == '40000' then
    viewdistance = 40000
  elseif Menuchoice == '50000' then
    viewdistance = 50000
  elseif Menuchoice == '60000' then
    viewdistance = 60000
  elseif Menuchoice == '70000' then
    viewdistance = 70000
  elseif Menuchoice == '80000' then
    viewdistance = 80000
  elseif Menuchoice == '150000' then
    viewdistance = 150000
    
  elseif Menuchoice == 'Scale '..drawscale then
    Menuoptions={'0.25', '0.5', '0.75', '1', '1.25', '1.5', '1.75', '2', 'Settings'}
  elseif Menuchoice == '0.25' then
    drawscale = 0.25
  elseif Menuchoice == '0.5' then
    drawscale = 0.5
  elseif Menuchoice == '0.75' then
    drawscale = 0.75
  elseif Menuchoice == '1' then
    drawscale = 1
  elseif Menuchoice == '1.25' then
    drawscale = 1.25
  elseif Menuchoice == '1.5' then
    drawscale = 1.5
  elseif Menuchoice == '1.75' then
    drawscale = 1.75
  elseif Menuchoice == '2' then
    drawscale = 2
  elseif Menuchoice == 'Back' then
    Menuoptions={'New game','Resume game','Save game', 'Load game', 'Settings', 'Exit'}
  elseif Menuchoice == 'Exit' then
    love.event.quit()
  end
  Menuchoice = ''
end