debug = true

player = { 
  x = 200, 
  y = 510, 
  speed = 200,
  width = 40, 
  height = 30 
}

-- Таймеры
-- Определяем переменные здесь,чтобы use их в ф-ях
canShoot = true
canShootTimerMax = 0.2 
canShootTimer = canShootTimerMax

-- Хранилище частиц
bullets = {} -- массив пуль рисуется и обновляется

function love.load()
  
end

function love.update(dt)
	-- действие выхода из игры
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

	-- движение персонажа
  if love.keyboard.isDown('left','a') then
    if player.x > 0 then -- определяем левую границу экрана
      player.x = player.x - (player.speed*dt)
    end
  elseif love.keyboard.isDown('right','d') then
    if player.x < (love.graphics.getWidth() - player.width) then
      player.x = player.x + (player.speed*dt)
    end
  end
  
  -- Запускаем таймер каждый раз
  canShootTimer = canShootTimer - (1 * dt)
  if canShootTimer < 0 then
    canShoot = true
  end
  
  -- Стреляем
  if love.keyboard.isDown(' ', 'rctrl', 'lctrl', 'ctrl') and canShoot then
    -- Создаем новые пули
    newBullet = { 
      x = player.x + (player.width/2), 
      y = player.y,
      width = 10,
      height = 26
    }
    table.insert(bullets, newBullet)
    canShoot = false
    canShootTimer = canShootTimerMax
  end 
  
  -- заставляем пули двигаться
  for i, bullet in ipairs(bullets) do
    bullet.y = bullet.y - (250 * dt)

    if bullet.y < 0 then -- удаляем пули если они выходя за конец экрана
      table.remove(bullets, i)
    end
  end
end

function love.draw()
  -- рисуем нашего персонажа
  love.graphics.setColor(255,255,255,255)
  love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
 
  -- рисуем пули
  for i, bullet in ipairs(bullets) do
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.width, bullet.height)
  end
end