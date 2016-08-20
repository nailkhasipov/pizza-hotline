debug = true

player = { x = 200, y = 510 }

function love.load()
  
end

function love.update(dt)
  
end

function love.draw()
 -- let's draw our hero
 love.graphics.setColor(255,255,255,255)
 love.graphics.rectangle("fill", player.x, player.y, 30, 15)
end