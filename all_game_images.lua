function remove_images(alldata)
  for i, v in ipairs(alldata[4]) do
    v.home = {v.home.x,v.home.y}
    if v.job == 'unemployed' then
      v.plan = {}
      v.jobwork = {}
    end
  end
end




function return_images(list)
  for i, v in ipairs(list) do
    for o, b in ipairs(towns[v.town]) do
      for e, d in ipairs(b.field) do
        if d.x == v.home[1] and d.y == v.home[2] then
          v.home = d
          if v.job == 'unemployed' then
            v.jobwork = v.home
          end
        elseif d.x == v.jobwork.x and d.y == v.jobwork.y then
          v.jobwork = d
        end
      end
    end
  end
end