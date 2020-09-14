



function NPCsocialise(NPC, task, dt, anywhere)
  if anywhere == false or anywhere == nil then
    if NPC.loc == 'outside' then
      NPC_travel(NPC, task.entertainment.x, task.entertainment.y, dt, 'nearrec')
    elseif NPC.loc == 'nearrec' then
      NPC_travel(NPC, task.x, task.y, dt, 'rec')
    elseif NPC.loc == 'rec' then
      
    else
      NPC_travel(NPC, NPC.x + NPC.w/2, math.floor(NPC.y/1000)*1000+950, dt, 'outside')
    end
    if NPC.loc == 'rec' then
      for i, v in ipairs(ListofNPCs) do
        if v.name ~= NPC.name then
          if NPC.w+NPC.x+100 > v.x-100 and
            NPC.x-100 < v.w+v.x+100 and
            NPC.y+NPC.h+100 > v.y-100 and
            NPC.y-100 < v.y+v.h+100 then
              if v.name ~= nil then
                if NPC.relationship[v.name] ~= nil then
                  NPC.relationship[v.name][1] = NPC.relationship[v.name][1] + dt
                  if v.relationship[NPC.name] ~= nil then
                    if NPC.relationship[v.name][1] > 200 and v.relationship[NPC.name][1] > 200 and #NPC.spouse == 0 and #v.spouse == 0 and #v.home.occupants < 3 then
                      table.remove(NPC.home.occupants, tablefind(NPC.home.occupants,NPC))
                      NPC.home = v.home
                      table.insert(NPC.spouse, v.name)
                      table.insert(v.spouse, NPC.name)
                      NPC.dialog['Who is your partner?']={v.name}
                      v.dialog['Who is your partner?']={NPC.name}
                      table.insert(v.home.occupants, NPC)
                      for m,n in ipairs(NPC.home.interiors) do
                        if n.type == 'bed' then
                          add_interior_objects(NPC.home, 'bed', 'bed1', n.x+n.w, n.y)
                          break
                        end
                      end
                      
                    end
                  end
                else
                  NPC.relationship[v.name] = {dt}
                end
              end
            end
          end
        end
      end
  elseif anywhere == true then 
    for i, v in ipairs(ListofNPCs) do
        if v.name ~= NPC.name then
          if NPC.w+NPC.x+100 > v.x-100 and
            NPC.x-100 < v.w+v.x+100 and
            NPC.y+NPC.h+100 > v.y-100 and
            NPC.y-100 < v.y+v.h+100 then
              if v.name ~= nil then
                if NPC.relationship[v.name] ~= nil then
                  NPC.relationship[v.name][1] = NPC.relationship[v.name][1] + dt/10
                  if v.relationship[NPC.name] ~= nil then
                    if NPC.relationship[v.name][1] > 200 and v.relationship[NPC.name][1] > 200 and #NPC.spouse == 0 and #v.spouse == 0 and #v.home.occupants < 3 then
                      table.remove(NPC.home.occupants, tablefind(NPC.home.occupants,NPC))
                      NPC.home = v.home
                      table.insert(NPC.spouse, v.name)
                      table.insert(v.spouse, NPC.name)
                      table.insert(v.home.occupants, NPC)
                      for m,n in ipairs(NPC.home.interiors) do
                        if n.type == 'bed' then
                          add_interior_objects(NPC.home, 'bed', 'bed1', n.x+n.w, n.y)
                          break
                        end
                      end
                    end
                  end
                else
                  NPC.relationship[v.name] = {dt}
                end
              end
            end
          end
        end
      end
  end