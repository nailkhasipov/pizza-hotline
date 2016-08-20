debug = true

player = { 
  x = 200, 
  y = 510, 
  speed = 200,
  width = 30, 
  height = 15 
}

function love.load()
  
end

function love.update(dt)
	-- действие выхода из игры
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

	if love.keyboard.isDown('left','a') then
    if player.x > 0 then -- определяем левую границу экрана
      player.x = player.x - (player.speed*dt)
    end
  elseif love.keyboard.isDown('right','d') then
    if player.x < (love.graphics.getWidth() - player.width) then
      player.x = player.x + (player.speed*dt)
    end
  end
end

function love.draw()
 -- рисуем нашего персонажа
 love.graphics.setColor(255,255,255,255)
 love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
end