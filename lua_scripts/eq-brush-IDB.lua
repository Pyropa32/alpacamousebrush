function param1()
return "Minimum width", 0, 50, 15
end

function param2()
return "sharpness", 0, 20, 10
end

function param3()
return "calibration", 0, 20, 2
end

function main( x, y, p )
  local w = bs_width_max()
  table.insert( pts, { x = x, y = y } );

  local r,g,b = bs_fore()
  local a = bs_opacity() * 255

  bs_ellipse( x, y, w, w, 0, r, g, b, a )

  lastDrawX = x
  lastDrawY = y
  firstDraw = false

  return 1

end

function last( x, y, p )
  if bs_preview() then return 0 end
  
  bs_reset()

  local strokeSize = tablelength(pts)
  local r,g,b = bs_fore()
  local a = bs_opacity() * 255
  local minimum = (bs_param1() / 50) * rand_factor
  local currentW = 0
  local func = 0
  local calibration = bs_param3() / 2
  local delta_w = 0.1
  for index, point in ipairs( pts ) do
     --ignore below:
	delta_w = 0
	local t = index / strokeSize
       if perchance(0.10) == 1 then
		func = math.random(0,3)
	end
	if func == 0 then delta_w = delta_w + rise(t) end
	if func == 1 then delta_w = delta_w + const(t) end
	if func == 2 then delta_w = delta_w + lower(t) end
	if func == 3 then delta_w = delta_w + rise(t) end
	delta_w = math.min(0.2, math.max(-0.2, delta_w / strokeSize))
	currentW = currentW + delta_w
       local W = math.min(bs_width_max() * 1.2,math.max(currentW * bs_width_max() * calibration, minimum * bs_width_max()))
	local W = W * crossfade_fit(t-0.0001)
	bs_debug_log(delta_w)
     bs_ellipse(point.x, point.y, W, W, 0, r, g, b, a )
    --ignore above.
  
  end

end

function const(t)
return 0
end

function rise(t)
return math.random() * 5 + 0.2
end

function lower(t)
return -math.random() * 5 - 0.2
end

function bounce(t)
return 5*math.sin(t*math.pi*8)
end



function crossfade_fit(t)
local sharpness = bs_param2() / 10
return math.min( 1, math.abs( 1* math.sin( t*math.pi )^sharpness ) )
end


function perchance(chance)
local randnum = math.random()
if randnum < chance then
return 1 end

end


function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

pts = {}
bs_setmode(1)
math.randomseed(bs_ms()*100000000000)
lastDrawX = 0
lastDrawY = 0
rand_factor = math.random(75,100) / 100
firstDraw = true
