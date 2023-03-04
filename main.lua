function love.load()
  audio = love.audio.newSource("sound3.wav", "static");
  
  audio:play();
  
  damping = .99
  
  listener_x = 800 / 4
  listener_y = 600 / 4
  
  current = {}
  previous = {}
  
  states = {}
  
  local img_data = love.image.newImageData("img.jpg")
  
  local SIZE_FACTOR = 0.5;
  
  for i = 1, 600 / 4, 1 do
    current[i] = {}
    previous[i] = {}
    
    states[i] = {}
    
    for j = 1, 800 / 4, 1 do
      current[i][j] = 0
      previous[i][j] = 0
      
      states[i][j] = 0;
      
      if(i == 600 / 8 and j == 800 / 8) then
        previous[i][j] = 100;
      end
      
      if img_data:getPixel(j - 1, i - 1) > 0.5 then
        states[i][j] = 1;
      end
    end
  end
end

function love.update(dt)
  if love.keyboard.isDown("l") then
    listener_x = math.floor(love.mouse.getX() / 4)
    listener_y = math.floor(love.mouse.getY() / 4)
  end
  
  for k = 1, 20, 1 do
    
    if love.keyboard.isDown("o") then
      current[math.floor(love.mouse.getY() / 4)][math.floor(love.mouse.getX() / 4)] = math.max(0, previous[math.floor(love.mouse.getY() / 4)][math.floor(love.mouse.getX() / 4)]) + 1
    end
    
    for i = 2, 600 / 4 - 1, 1 do
      for j = 2, 800 / 4 - 1, 1 do
        if states[i][j] == 0 then
          current[i][j] = (previous[i - 1][j] + previous[i + 1][j] + previous[i][j - 1] + previous[i][j + 1]) / 2 - current[i][j]
          
          current[i][j] = current[i][j] * damping
        end
      end
    end
    
    current, previous = previous, current
  end
end

function love.draw()
  for i = 1, 600 / 4, 1 do
    for j = 1, 800 / 4, 1 do      
      local r = math.max(0, math.min(current[i][j], 1))
      
      love.graphics.setColor(r, r, r)
      
      love.graphics.rectangle("fill", j * 4 - 4, i * 4 - 4, 4, 4)
    end
  end
  
  for i = 1, 600 / 4, 1 do
    for j = 1, 800 / 4, 1 do      
      if states[i][j] == 1 then
        love.graphics.setColor(1, 1, 1)
        
        love.graphics.rectangle("fill", j * 4 - 4, i * 4 - 4, 4, 4)
      end      
    end
  end
  
  audio:setVolume(math.max(0, current[listener_y][listener_x] / 20));
  --audio:setVolume(math.max(0, current[math.floor(love.mouse.getY() / 4)][math.floor(love.mouse.getX() / 4)] / 20));
  audio:play();
end