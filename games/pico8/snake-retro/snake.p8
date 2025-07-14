pico-8 cartridge
__lua__
-- snake retro
-- classic snake game

function _init()
 cls()
 
 -- game state
 game_state = "menu" -- menu, playing, game_over
 score = 0
 high_score = 0
 
 -- snake
 snake = {{x=8, y=8}}
 snake_dir = {x=1, y=0}
 next_dir = {x=1, y=0}
 
 -- food
 food = {x=4, y=4}
 
 -- game settings
 grid_size = 8
 board_width = 128 / grid_size
 board_height = 128 / grid_size
 
 -- timing
 move_timer = 0
 move_delay = 0.2
 
 -- particles
 particles = {}
 
 generate_food()
end

function _update()
 if game_state == "menu" then
  update_menu()
 elseif game_state == "playing" then
  update_game()
 elseif game_state == "game_over" then
  update_game_over()
 end
end

function _draw()
 cls(1) -- dark blue background
 
 if game_state == "menu" then
  draw_menu()
 elseif game_state == "playing" then
  draw_game()
 elseif game_state == "game_over" then
  draw_game_over()
 end
end

function update_menu()
 if btnp(4) or btnp(5) then -- z or x
  start_game()
 end
end

function update_game()
 -- input
 if btnp(0) and snake_dir.x == 0 then next_dir = {x=-1, y=0} end -- left
 if btnp(1) and snake_dir.x == 0 then next_dir = {x=1, y=0} end  -- right
 if btnp(2) and snake_dir.y == 0 then next_dir = {x=0, y=-1} end -- up
 if btnp(3) and snake_dir.y == 0 then next_dir = {x=0, y=1} end  -- down
 
 -- movement timer
 move_timer += 1/30
 if move_timer >= move_delay then
  move_timer = 0
  move_snake()
 end
 
 update_particles()
end

function update_game_over()
 if btnp(4) or btnp(5) then -- z or x
  game_state = "menu"
 end
end

function move_snake()
 snake_dir = next_dir
 
 -- calculate new head position
 local head = snake[1]
 local new_head = {
  x = head.x + snake_dir.x,
  y = head.y + snake_dir.y
 }
 
 -- wrap around screen
 if new_head.x < 0 then new_head.x = board_width - 1 end
 if new_head.x >= board_width then new_head.x = 0 end
 if new_head.y < 0 then new_head.y = board_height - 1 end
 if new_head.y >= board_height then new_head.y = 0 end
 
 -- check collision with self
 for segment in all(snake) do
  if new_head.x == segment.x and new_head.y == segment.y then
   game_over()
   return
  end
 end
 
 -- add new head
 add(snake, new_head, 1)
 
 -- check food collision
 if new_head.x == food.x and new_head.y == food.y then
  score += 10
  create_food_particles()
  generate_food()
  
  -- increase speed slightly
  move_delay = max(0.08, move_delay - 0.005)
 else
  -- remove tail
  del(snake, snake[#snake])
 end
end

function generate_food()
 repeat
  food.x = flr(rnd(board_width))
  food.y = flr(rnd(board_height))
 until not snake_collision(food.x, food.y)
end

function snake_collision(x, y)
 for segment in all(snake) do
  if segment.x == x and segment.y == y then
   return true
  end
 end
 return false
end

function start_game()
 game_state = "playing"
 score = 0
 snake = {{x=8, y=8}}
 snake_dir = {x=1, y=0}
 next_dir = {x=1, y=0}
 move_timer = 0
 move_delay = 0.2
 particles = {}
 generate_food()
end

function game_over()
 game_state = "game_over"
 if score > high_score then
  high_score = score
 end
 create_explosion_particles()
end

function create_food_particles()
 for i=1,8 do
  add(particles, {
   x = food.x * grid_size + 4,
   y = food.y * grid_size + 4,
   vx = rnd(2) - 1,
   vy = rnd(2) - 1,
   life = 15,
   color = 10 -- yellow
  })
 end
end

function create_explosion_particles()
 local head = snake[1]
 for i=1,16 do
  add(particles, {
   x = head.x * grid_size + 4,
   y = head.y * grid_size + 4,
   vx = rnd(4) - 2,
   vy = rnd(4) - 2,
   life = 30,
   color = 8 -- red
  })
 end
end

function update_particles()
 for p in all(particles) do
  p.x += p.vx
  p.y += p.vy
  p.life -= 1
  p.vx *= 0.9
  p.vy *= 0.9
  
  if p.life <= 0 then
   del(particles, p)
  end
 end
end

function draw_menu()
 -- title
 print("snake retro", 35, 20, 11)
 print("snake retro", 34, 19, 7)
 
 -- snake logo
 for i=0,6 do
  rectfill(20 + i*8, 40, 26 + i*8, 46, 11)
 end
 rectfill(76, 32, 82, 38, 11) -- head
 pset(78, 34, 0) -- eye
 
 -- instructions
 print("arrows: move", 30, 70, 6)
 print("z/x: select", 32, 80, 6)
 
 print("press z to start", 25, 100, 10)
 
 if high_score > 0 then
  print("high score: "..high_score, 20, 115, 9)
 end
end

function draw_game()
 -- draw snake
 for i, segment in ipairs(snake) do
  local color = i == 1 and 11 or 3 -- head is white, body is green
  rectfill(
   segment.x * grid_size,
   segment.y * grid_size,
   segment.x * grid_size + grid_size - 1,
   segment.y * grid_size + grid_size - 1,
   color
  )
  
  -- head details
  if i == 1 then
   pset(segment.x * grid_size + 2, segment.y * grid_size + 2, 0) -- eye
   pset(segment.x * grid_size + 5, segment.y * grid_size + 2, 0) -- eye
  end
 end
 
 -- draw food
 local food_color = flr(time() * 8) % 2 == 0 and 10 or 9
 rectfill(
  food.x * grid_size,
  food.y * grid_size,
  food.x * grid_size + grid_size - 1,
  food.y * grid_size + grid_size - 1,
  food_color
 )
 
 -- draw particles
 for p in all(particles) do
  local alpha = p.life / 30
  if alpha > 0 then
   pset(p.x, p.y, p.color)
  end
 end
 
 -- draw border
 rect(0, 0, 127, 127, 5)
 
 -- score
 print("score: "..score, 2, 2, 7)
 print("length: "..#snake, 2, 10, 7)
end

function draw_game_over()
 -- game background (faded)
 draw_game()
 
 -- overlay
 rectfill(20, 30, 107, 90, 0)
 rect(20, 30, 107, 90, 7)
 
 print("game over!", 38, 40, 8)
 print("final score: "..score, 30, 55, 7)
 
 if score == high_score and score > 0 then
  print("new high score!", 25, 65, 10)
 elseif high_score > 0 then
  print("high score: "..high_score, 28, 65, 9)
 end
 
 print("press z to continue", 22, 80, 6)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000