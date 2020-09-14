Listofanimals = {}

function create_Animal(image, lair, weakness,speed, health, body, head, feet)
  animal = {}
  animal.body = body
  animal.head = head
  animal.feet = feet
  animal.feet1x=30
  animal.feet1y=-10
  animal.feet2x=0
  animal.feet2y=0
  animal.health = health
  animal.x = lair.x
  animal.y = lair.y
  animal.w = Image_table[animal.body]:getWidth()
  animal.h = Image_table[animal.body]:getHeight()
  animal.items = {create_item(0, 0, 'Wolfhead', 1, 1, 'wolfheaditem', 200, false)}
  animal.invnum = 1
  animal.dirface=1
  animal.direction = 'left'
  animal.diroffset = 0
  animal.visible=true
  animal.lair = lair
  animal.loc = "atlocation"
  animal.speed = speed
  animal.weakness={weakness}
  animal.hunger = 100
  animal.plan={}
  animal.dialog = {}
  animal.dialog['intro'] = {"Grrr"}
  table.insert(Listofanimals, animal)
  return (animal)
end


function animal_needs(dt)
  for i, v in ipairs(Listofanimals) do
    if v.loc == 'atlocation' then
      task={}
      task.action = 'travel'
      task.x = v.lair.x + math.random(-10000, 10000)
      task.y = v.lair.y + math.random(-10000, 10000)
      v.loc = 'travelling'
      table.insert(v.plan, task)
    end
    animaltaskhandler(v, dt)
    v.hunger = v.hunger - dt/20
    if v.health < 0 then
      drop_inventory(v)
      table.remove(Listofanimals,tablefind(Listofanimals,v))
    end
  end
end


function animaltaskhandler(animal, dt)
  if #animal.plan > 0 then
    if animal.plan[1].action == 'travel' then
      NPC_travel_outside(animal, animal.plan[1].x, animal.plan[1].y, dt,'atlocation')
      if animal.loc == 'atlocation' then
        table.remove(animal.plan,1)
      end
    end
  end
end