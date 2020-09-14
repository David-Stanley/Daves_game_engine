function NPC_homework(NPC, dt)
  if NPC.loc ~= 'home' and #NPC.plan < 1 then
    task ={}
    task.x = math.random(NPC.home.x, NPC.home.x + NPC.home.w)
    task.y = math.random(NPC.home.y, NPC.home.y + NPC.home.h)
    task.loc = 'home'
    task.action = 'gohome'
    table.insert(NPC.plan, task)
  end
  
  
  if NPC.awakeness < 80 and #NPC.plan < 1 then
    for i, v in ipairs(NPC.home.interiors) do
      if v.type == 'bed' then
        task = {}
        task.x = v.x + v.w/2
        task.y = v.y + v.h/2
        task.action = 'sleep'
        task.loc = 'bed'
        task.timeout = 20
        table.insert(NPC.plan, task)
      end
    end
  end
  
  
end

function NPCsleep(NPC, task, dt)
  NPC_experimental_travel_2(NPC, NPC.plan[1], dt)
  NPC.awakeness = NPC.awakeness + dt
  if NPC.awakeness > 100 then
    table.remove(NPC.plan, 1)
  end
end


function NPC_go_home(NPC, dt)
  NPC_experimental_travel_2(NPC, NPC.plan[1], dt)
  if NPC.loc == 'home' then
    table.remove(NPC.plan,1)
  end
end