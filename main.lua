debug = true

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

player = { 
  x = 200, 
  y = 510, 
  speed = 200,
  width = 40, 
  height = 30 
}

isAlive = true
score = 0

-- Таймеры
-- Определяем переменные здесь,чтобы use их в ф-ях
canShoot = true
canShootTimerMax = 0.2 
canShootTimer = canShootTimerMax

-- Хранилище частиц
bullets = {} -- массив пуль рисуется и обновляется

 -- Создание врага
createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax
  
-- Хранилище врагов
enemies = {} -- массив врагов рисуется и обновляется

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
  
  
  -- Таймер на создание врагов
  createEnemyTimer = createEnemyTimer - (1 * dt)
  if createEnemyTimer < 0 then
    createEnemyTimer = createEnemyTimerMax

    -- Создание врага
    randomNumber = math.random(10, love.graphics.getWidth() - 10)
    newEnemy = { x = randomNumber, y = -10, width = 40, height = 30 }
    table.insert(enemies, newEnemy)
  end
  
  -- Двигаем врага
  for i, enemy in ipairs(enemies) do
    enemy.y = enemy.y + (200 * dt)

    if enemy.y > 850 then -- удаляем когда он зашел за экран
      table.remove(enemies, i)
    end
  end
  
  -- run our collision detection
  -- Since there will be fewer enemies on screen than bullets we'll loop them first
  -- Also, we need to see if the enemies hit our player
  for i, enemy in ipairs(enemies) do
    for j, bullet in ipairs(bullets) do
      if CheckCollision(enemy.x, enemy.y, enemy.width, enemy.height, bullet.x, bullet.y, bullet.width, bullet.height) then
        table.remove(bullets, j)
        table.remove(enemies, i)
        score = score + 1
      end
    end

    if CheckCollision(enemy.x, enemy.y, enemy.width, enemy.height, player.x, player.y, player.width, player.height) 
    and isAlive then
      table.remove(enemies, i)
      isAlive = false
    end
  end
  
  if not isAlive and love.keyboard.isDown('r') then
    -- remove all our bullets and enemies from screen
    bullets = {}
    enemies = {}

    -- reset timers
    canShootTimer = canShootTimerMax
    createEnemyTimer = createEnemyTimerMax

    -- move player back to default position
    player.x = 50
    player.y = 510

    -- reset our game state
    score = 0
    isAlive = true
  end
end

function love.draw()
  if isAlive then
    -- рисуем нашего персонажа
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
  else
    love.graphics.print("Нажмите 'R' начать заново", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
  end
  
 
  -- рисуем пули
  for i, bullet in ipairs(bullets) do
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.width, bullet.height)
  end
  
  -- Рисуем врагов
  for i, enemy in ipairs(enemies) do
    love.graphics.setColor(255,255,0,255)
    love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.width, enemy.height)
  end
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("SCORE: " .. tostring(score), 400, 10)
end