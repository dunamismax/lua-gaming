pico-8 cartridge
__lua__
-- pico-8 template
-- basic template for new games

function _init()
 cls()
 
 game_time = 0
 player = {
  x = 64,
  y = 64,
  color = 8
 }
 
 objects = {}
 
 -- create some demo objects
 for i=1,5 do
  add(objects, {
   x = rnd(128),
   y = rnd(128),
   vx = rnd(2) - 1,
   vy = rnd(2) - 1,
   color = flr(rnd(15)) + 1
  })
 end
end

function _update()
 game_time += 1/30
 
 -- player movement
 if btn(0) then player.x -= 1 end -- left
 if btn(1) then player.x += 1 end -- right
 if btn(2) then player.y -= 1 end -- up
 if btn(3) then player.y += 1 end -- down
 
 -- keep player on screen
 player.x = mid(0, player.x, 127)
 player.y = mid(0, player.y, 127)
 
 -- update objects
 for obj in all(objects) do
  obj.x += obj.vx
  obj.y += obj.vy
  
  -- bounce off edges
  if obj.x <= 0 or obj.x >= 127 then
   obj.vx = -obj.vx
  end
  if obj.y <= 0 or obj.y >= 127 then
   obj.vy = -obj.vy
  end
 end
end

function _draw()
 cls(1) -- dark blue background
 
 -- draw objects
 for obj in all(objects) do
  circfill(obj.x, obj.y, 3, obj.color)
 end
 
 -- draw player
 circfill(player.x, player.y, 4, player.color)
 
 -- ui
 print("pico-8 template", 20, 10, 7)
 print("time: "..flr(game_time), 10, 120, 6)
 print("arrows: move", 10, 110, 6)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000