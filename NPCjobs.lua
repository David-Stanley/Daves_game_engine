


function NPC_work(Worker, dt)
  conversation_builder_work(Worker)

  ------Send worker to work-------
  if Worker.workday ~= days then
    task ={}
    task.action = 'gotowork'
    task.loc = 'workplace'
    task.x = Worker.jobwork.x + (Worker.jobwork.w / 2)
    task.y = Worker.jobwork.y + (Worker.jobwork.h / 2)
    table.insert(Worker.plan, task)
    Worker.workday = days
    Worker.nobuy = {}
  end
  
  ---Trader---
  
  if Worker.job == 'trader' then 
    if Worker.loc == 'workplace' then
      NPC_travel(Worker, Worker.jobwork.x + (Worker.jobwork.w / 2), Worker.jobwork.y + Worker.jobwork.h+20, dt, 'work_task_loc')
    end
  end
  
  ---Builder---
  if Worker.job == 'builder' then
    if #Worker.plan < 1 then  
      local count1 = false
      for count2, n in ipairs(Worker.items) do
        if Worker.items[count2].item == 'hammer' then
          Worker.held = Worker.items[count2]
          Worker.invnum = count2
          count1 =true 
        end
      end
      if count1 == false then
        for o, b in ipairs(towns[Worker.town]) do
          for e, d in ipairs(b.field) do
            if d.btype == 'trader' then                                                                 ---WILL NEED TO IMPROVE WHEN MULTIPLE TRADERS!
              if #d.workers > 0 then
                task = {}
                task.x = d.x +math.random(20,d.w-20)
                task.y = d.y + math.random(80, d.h)
                task.worker = find_NPC_by_name(d.workers[1])
                task.action = 'buy'
                task.loc = 'trader'
                task.amount = 1
                task.time = 10
                task.item = 'hammer'
                table.insert(Worker.plan, task)
              end
            end
          end
        end
      end
    end
  end
  
  
  -----Crafter------
  if Worker.job == 'crafter' then
    local task
    local decision = 0
    if #Worker.plan < 1 then
      decision = math.random(1,23)
    end
    
    if decision >13 and #Worker.plan < 1 then
      task = itemunderstock(Worker, 'leaves', 50, 10)
      if task ~= nil then
        table.insert(Worker.plan, task)
      elseif checkamount(Worker, 'leaves', 10) then
        task = {}
        task.action = "create_armour"
        task.item = 'grassarmour'..math.random(1,3)
        task.armour = 5
        task.neededitem = 'leaves'
        task.num = 10
        task.completion = 0
        table.insert(Worker.plan, task)
      end
    end
    if decision == 2 and #Worker.plan < 1 then
      task = itemoverstock(Worker, 'grassarmour1', 1, 0)
      task = itemoverstock(Worker, 'grassarmour2', 1, 0)
      task = itemoverstock(Worker, 'grassarmour3', 1, 0)
      if task ~= nil then
        table.insert(Worker.plan, task)
      end
    end
    if decision >= 3 and decision <= 6 and #Worker.plan < 1 then
      NPC_make_item_task(Worker, 'logs', 25, 5, 'hatchet', 10, 'hatchetitem','hatchet',10)
    end
    if decision ==7 and #Worker.plan < 1 then
      NPC_make_item_task(Worker, 'logs', 25, 5, 'pickaxe', 10, 'pickaxeitem','pickaxe',10)
    end
    if decision >=8 and decision <=11 and #Worker.plan < 1 then
      NPC_make_item_task(Worker, 'logs', 25, 5, 'hoe', 10, 'hoeitem','hoe',10)
    end
    if decision >=12 and decision <= 13 and #Worker.plan < 1 then
      NPC_make_item_task(Worker, 'logs', 25, 5, 'knife', 20, 'knifeitem','weapon',10)
    end
  end

  
  
  ----Guard----
  if Worker.job == 'Guard' then
    if #Worker.plan < 1 then  
      local count1 = false
      for count2,n in ipairs(Worker.items) do
        if Worker.items[count2].item == 'knife' then
          Worker.held = Worker.items[count2]
          Worker.invnum = count2
          count1 = true
        end
      end
      if count1 == false then
        for o, b in ipairs(towns[Worker.town]) do
          for e, d in ipairs(b.field) do
            if d.btype == 'trader' then                                                                 ---WILL NEED TO IMPROVE WHEN MULTIPLE TRADERS!
              if #d.workers > 0 then
                task = {}
                task.x = d.x + math.random(20,d.w-20)
                task.y = d.y + math.random(80, d.h)
                task.worker = find_NPC_by_name(d.workers[1])
                task.action = 'buy'
                task.loc = 'trader'
                task.amount = 1
                task.time = 10
                task.item = 'knife'
                table.insert(Worker.plan, task)
              end
            end
          end
        end
      end
    end
    if #Worker.plan < 1 then
      task = {}
      local location = towns[Worker.town][math.random(1,#towns[Worker.town])]
      task.x = location.x
      task.y = location.y
      task.action = 'random_patrol'
      task.loc = 'outside2'
      table.insert(Worker.plan, task)
      end
  end
  
  
    
  
  
  -----STONECUTTER
  
  
  if Worker.job == 'stonecutter' then
    
    if #Worker.plan < 1 then
      local task = itemoverstock(Worker, 'rocks', 5, 0)
      if task ~= nil then
        table.insert(Worker.plan, task)
      end
    end
    NPC_plan_resource_gather(Worker, 'pickaxe', 'bigrock')
  end
    
    
    
  ------WOODCUTTER-----------
  
  if Worker.job == 'woodcutter' then
    
    if #Worker.plan < 1 then
      local task = itemoverstock(Worker, 'logs', 30, 0)
      if task ~= nil then
        table.insert(Worker.plan, task)
      end
      task = itemoverstock(Worker, 'leaves', 30, 0)
      if task ~= nil then
        table.insert(Worker.plan, task)
      end
    end
    
    

    NPC_plan_resource_gather(Worker, 'hatchet', 'tree')
  end
  
  
  
  
  -----------FARMWORK---------------------------------------
  if Worker.job == 'farmer' then
    
    if #Worker.jobwork.interiors < 432 and #Worker.plan < 1 then
      
      local count1 = false
      for count2, n in ipairs(Worker.items) do
        if Worker.items[count2].item == 'hoe' then
          Worker.held = Worker.items[count2]
          Worker.invnum = count2
          count1 = true
          local varx = 100 * math.floor(#Worker.jobwork.interiors - (math.floor(#Worker.jobwork.interiors/18)*18))
          if varx == 0 then
            varx = 100
          end
          local vary = 100 * (math.floor(#Worker.jobwork.interiors/18 + 1))
          while vary ~= 2500 do
            task = {}
            task.x = Worker.jobwork.x + varx
            task.y = Worker.jobwork.y + vary
            task.action = 'create_dirt_mound'
            task.time = 0.5
            table.insert(Worker.plan, task)
            varx = varx+100
            if varx == 2200 then
              varx = 100
              vary = vary + 100
            end
          end
        end
      end
      if count1 == false then
        for o, b in ipairs(towns[Worker.town]) do
          for e, d in ipairs(b.field) do
            if d.btype == 'trader' then                                                                 ---WILL NEED TO IMPROVE WHEN MULTIPLE TRADERS!
              if #d.workers > 0 then
                task = {}
                task.x = d.x +math.random(20,d.w-20)
                task.y = d.y + math.random(80, d.h)
                task.worker = find_NPC_by_name(d.workers[1])
                task.action = 'buy'
                task.amount = 1
                task.time = 10
                task.loc = 'trader'
                task.item = 'hoe'
                table.insert(Worker.plan, task)
              end
            end
          end
        end

      end
    end
    if Worker.farming > 50 and #Worker.jobwork.interiors < 864 and #Worker.jobwork.interiors > 432 and #Worker.plan < 1 then
      local varx = 50
      local vary = 100
      while vary ~= 2500 do
        task = {}
        task.x = Worker.jobwork.x + varx
        task.y = Worker.jobwork.y + vary
        task.action = 'create_dirt_mound'
        task.time = 0.5
        table.insert(Worker.plan, task)
        varx = varx+100
        if varx == 2150 then
          varx = 50
          vary = vary + 100
        end
      end
    end
    if Worker.farming > 20 and #Worker.jobwork.interiors < 152 and #Worker.jobwork.interiors > 103 and #Worker.plan < 1 then
      local varx = 100
      local vary = 50
      while vary ~= 950 do
        task = {}
        task.x = Worker.jobwork.x + varx
        task.y = Worker.jobwork.y + vary
        task.action = 'create_dirt_mound'
        task.time = 0.5
        table.insert(Worker.plan, task)
        varx = varx+100
        if varx == 200 then
          varx = 100
          vary = vary + 100
        end
      end
    end
    if Worker.farming > 30 and #Worker.jobwork.interiors < 200 and #Worker.jobwork.interiors > 152 and #Worker.plan < 1 then
      local varx = 50
      local vary = 50
      while vary ~= 950 do
        task = {}
        task.x = Worker.jobwork.x + varx
        task.y = Worker.jobwork.y + vary
        task.action = 'create_dirt_mound'
        task.time = 0.5
        table.insert(Worker.plan, task)
        varx = varx+100
        if varx == 750 then
          varx = 50
          vary = vary + 100
        end
      end
    end
  

    
    if #Worker.plan < 1 then
      local task = itemoverstock(Worker, 'fruit', 50, 20)
      if task ~= nil then
        table.insert(Worker.plan,task)
      end
    end
    
    
    if #Worker.plan < 1 then
      for i, v in ipairs(Worker.jobwork.interiors) do
        if v.type == 'fruit' then
          task = {}
          task.x = v.x
          task.y = v.y
          task.action = 'harvest'
          task.time = 0.5
          task.object = v
          table.insert(Worker.plan, task)
        end
      end
    end
    
    
    if #Worker.plan < 1 then
      for i, v in ipairs(Worker.jobwork.interiors) do
        if v.type == 'dirtmound' then
          task = {}
          task.x = v.x
          task.y = v.y
          task.action = 'plant_seed'
          task.time = 0.5
          task.object = v
          table.insert(Worker.plan, task)
        end
      end
    end
  end
  if #Worker.plan < 1 and daytime > 8 and Worker.job ~= 'trader' then
    NPC_downtime(Worker, dt)
  end
end
    
    
    
    
    
function till_farm(Worker, task, dt)
  NPC_travel(Worker, task.x, task.y, dt, 'work_task_loc')
  if Worker.loc == 'work_task_loc' then
    if math.random(1,1000) > 999 then
      Worker.farming = Worker.farming + 1
    end
    object = {}
    object.x = task.x
    object.y = task.y
    object.type = 'dirtmound'
    task.time = task.time - dt
    if task.time < 0 then
      object.image = 'dirtpile'
      table.insert(Worker.jobwork.interiors, object)
      table.remove(Worker.plan,1)
      Worker.loc = "workplace"
    end
  end
end

function plant_seed(Worker, task, dt)
  NPC_travel(Worker, task.x, task.y, dt, 'work_task_loc')
  if Worker.loc == 'work_task_loc' then
    if math.random(1,1000) > 999 then
      Worker.farming = Worker.farming + 1
    end
    task.time = task.time - (Worker.farming * dt)
    if task.time < 0 then
      task.object.image = 'dirtpile_seed'
      task.object.type='seeded'
      table.remove(Worker.plan,1)
      Worker.loc = "workplace"
    end
  end
end

function harvest(Worker, task, dt)
  local additem
  NPC_travel(Worker, task.x, task.y, dt, 'work_task_loc')
  if Worker.loc == 'work_task_loc' then
    task.time = task.time - (Worker.farming * dt)
    if math.random(1,1000) > 999 then
      Worker.farming = Worker.farming + 1
    end
    if task.time < 0 then
      local additem=true
      for i, v in ipairs(Worker.items) do
        if v.item=='fruit' then
          v.num = v.num+1
          additem=false
        end
      end
      if additem == true then
        table.insert(Worker.items, create_item(0, 0, 'fruit', math.random(1, Worker.farming), 1, 'fruititem',10, false, 'food', 40))
      end
      task.object.image = 'dirtpile'
      task.object.type='dirtmound'
      table.remove(Worker.plan,1)
      Worker.loc = "workplace"
    end
  end
end


function NPC_cut_tree(Worker, task, dt)
  NPC_experimental_travel_2(Worker, task, dt)
  if Worker.loc == task.loc then
    if NPC_kill_enviro(Worker, dt) == 'dead' then
      table.remove(Worker.plan, 1)
      Worker.loc = 'outside'
    end
  end
end

function create_armour(Worker, task, dt)
  local slot
  if checkamount(Worker, task.neededitem, task.num) == false then
    table.remove(Worker.plan, 1)
  end
  if math.random(1,10000) > 9999 then
    Worker.crafting = Worker.crafting + 1
  end
  task.completion = task.completion + math.random(0,Worker.crafting)*dt*3
  if task.completion > task.armour then
    table.insert(Worker.items, create_item(0, 0, task.item, 1, task.armour, task.item, task.armour*10, false, 'armour', task.armour))
    table.remove(Worker.plan,1)
    task = itemoverstock(Worker, task.item, 1, 0)
    if task ~= nil then
      table.insert(Worker.plan, task)
    end
  end
end

function create_tool(Worker, task, dt)
  local slot
  NPC_experimental_travel_2(Worker, Worker.plan[1], dt)
  if checkamount(Worker, task.neededitem, task.num) == false then
    table.remove(Worker.plan, 1)
  end
  if math.random(1,10000) > 9999 then
    Worker.crafting = Worker.crafting + 1
end
  task.completion = task.completion + math.random(0,Worker.crafting)*dt*3
  if task.completion > task.dam then
    table.insert(Worker.items, create_item(0, 0, task.item, 1, task.dam, task.image, task.dam*10, false, task.itemtype, task.itemspecialvalue))
    table.remove(Worker.plan,1)
    task = itemoverstock(Worker, task.item, 1, 0)
    if task ~= nil then
      table.insert(Worker.plan, task)
    end
  end
end



function NPC_random_patrol(Worker, task, dt)
  NPC_experimental_travel_2(Worker, task, dt)
  if Worker.loc == task.loc then
    Worker.loc = 'outside'
    table.remove(Worker.plan, 1)
  end
end



function NPC_make_item_task(Worker, itemneeded, itemneededmax, itemneededmin, itemcreated, itemdam, itemimage,itemtype,itemspecialvalue)
  task = itemunderstock(Worker, itemneeded, itemneededmax, itemneededmin)
  if task ~= nil then
    table.insert(Worker.plan, task)
  elseif checkamount(Worker, itemneeded, itemneededmin) then
    task = {}
    task.action = "create_tool"
    task.x = Worker.jobwork.x + (Worker.jobwork.w / 2)
    task.y = Worker.jobwork.y + (Worker.jobwork.h / 2)
    task.loc = 'workplace'
    task.item = itemcreated
    task.dam = itemdam
    task.neededitem = itemneeded
    task.num = itemneededmin
    task.image = itemimage
    task.itemtype = itemtype
    task.itemspecialvalue=itemspecialvalue
    task.completion = 0
    table.insert(Worker.plan, task)
  end
end

function NPC_build_building(Worker, task, dt)
  if Worker.loc == 'outside' then
    NPC_travel_outside(Worker, task.x, task.y, dt, 'near_work_task_loc')
  elseif Worker.loc == 'near_work_task_loc' then
    NPC_travel(Worker, task.x, task.y, dt, 'work_task_loc')
  elseif Worker.loc == 'work_task_loc' then
    Worker.itemx = Worker.itemx + -Worker.dirface * dt * 100
    if Worker.itemx >10 or Worker.itemx < -10 then
      Worker.itemx = 0
    end
    task.countdown = task.countdown - Worker.held.specialvalue * dt
  else
    NPC_travel(Worker, Worker.x + Worker.w/2, math.floor(Worker.y/1000)*1000+950, dt, 'outside')
  end
  if task.countdown < 0 then
    if not within(task.construction.x,task.construction.x+(task.construction.w/2),player1.x) and not within(task.construction.y, task.construction.y+(task.construction.h/2), player1.y) then
      table.insert(task.field, task.construction)
      table.remove(Worker.plan, 1)
      Worker.loc = 'finishedjob'
    end
  end
end


function NPC_plan_resource_gather(Worker, tool, resource)
  if #Worker.plan < 1 then  
    local count1 = false
    for count2,n in ipairs(Worker.items) do
      if Worker.items[count2].item == tool then
        Worker.held = Worker.items[count2]
        Worker.invnum = count2
        count1 = true
        local target = findnearestwithtrait(Worker, towns[Worker.town].townenviro,resource)
        if target ~= nil then
          task = {}
          task.target = target
          task.x = target.x
          task.y = target.y + 200
          task.time = 3
          task.timeout = 300
          task.loc = 'outside2'
          task.action = 'cut_tree'
          table.insert(Worker.plan, task)
        end
      end
    end
    if count1 == false then
      for o, b in ipairs(towns[Worker.town]) do
        for e, d in ipairs(b.field) do
          if d.btype == 'trader' then                                                                 ---WILL NEED TO IMPROVE WHEN MULTIPLE TRADERS!
            if #d.workers > 0 then
              task = {}
              task.x = d.x + math.random(20,d.w-20)
              task.y = d.y + math.random(80, d.h)
              task.worker = find_NPC_by_name(d.workers[1])
              task.action = 'buy'
              task.amount = 1
              task.time = 10
              task.loc = 'trader'
              task.item = tool
              table.insert(Worker.plan, task)
            end
          end
        end
      end
    end
  end
end