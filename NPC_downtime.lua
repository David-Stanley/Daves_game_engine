function NPC_downtime(NPC, dt)
  if NPC.working == true then
    NPC.working = false
  end
  
  if NPC.awakeness < 60 and #NPC.plan < 1 then
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
  
  if #NPC.plan < 1 then
    local choice = NPC_trait_chosen(NPC)
    if choice[1] == 'adventerous' then
      choice = 'park'
    elseif choice[1] == 'neurotic' then
      choice = 'home'
    elseif choice[1] == 'funlover' then
      choice = 'pub'
    elseif choice[1] == 'agreeableness' then
      choice = 'townhall'
    elseif choice[1] == 'ambition' then
      choice = 'guild'
    end
    
    for i, v in ipairs(towns[NPC.town]) do
      for o, b in ipairs(v.field) do
        if b.btype == choice then
          if choice == 'home' and #ListofNPCs > 10 then
            --NPC_homework(NPC, dt)
            return
          end
          task = {}
          task.action='recreation'
          task.timeout = 20
          task.entertainment = b
          task.x = b.x + math.random(20, b.w-20)
          task.y = b.y + math.random(20, b.h-20)
          table.insert(NPC.plan, task)
        end
      end
    end
  end
end
  
  ----------TASKS BEING DONE-------------

