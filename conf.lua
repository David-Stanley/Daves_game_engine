gamewindow={}
gamewindow.width=1000
gamewindow.height=700

function love.conf(t)
  t.window.title="Daves game"
  t.window.width=gamewindow.width
  t.window.height=gamewindow.height
  t.window.vsync=true
  t.version="11.3"
  config = t
  t.identity="Davesgame"

end

