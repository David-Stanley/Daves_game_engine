grounditemslist = {}


--list of items



function create_item(x, y, name, num, damage, image, value, ground, specialtype, specialvalue)
  item = {}
  item.tilt = 0
  item.item = name
  item.num = num
  item.damage = damage
  item.image = image
  item.x = x
  item.y = y
  item.w = Image_table[item.image]:getWidth()
  item.h = Image_table[item.image]:getHeight()
  item.value = value
  item.specialtype = specialtype
  item.specialvalue = specialvalue
  if ground==true then
    table.insert(grounditemslist,item)
  else
    return item
  end
end

function drop_inventory(object)
  local x
  local y
  for i, v in ipairs(object.items) do
    if v.item ~= 'empty' then
      x = math.random(-80, 80)
      y = math.random(-80, 80)
      create_item(object.x + (object.w/2) + x, object.y + (object.h/2) + y, object.items[i].item, object.items[i].num, object.items[i].damage, object.items[i].image,object.items[i].value, true, object.items[i].specialtype, object.items[i].specialvalue)
    end
  end
end




function condense_inventory(inventory, player)
  
  for i, v in ipairs(inventory) do
    if v.num < 1 and player ~= true then
      table.remove(inventory, tablefind(inventory,v))
      --inventory[i] = create_item(0, 0, 'empty', 0, 1, "empty",0, false)
    end
    if v.item ~= 'empty' then
      for o, b in ipairs(inventory) do
        if v.item == b.item and v.image == b.image and v.value == b.value then
          if i ~= o then
            v.num = v.num + b.num
            if player == true then
              inventory[o] = create_item(0, 0, 'empty', 0, 1, "empty",0, false)
            else
              table.remove(inventory, tablefind(inventory,b))
            end
          end
        end
      end
    elseif player ~= true then
      table.remove(inventory,i)
    end
  end
end