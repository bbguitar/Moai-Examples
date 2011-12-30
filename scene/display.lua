--[[
The MIT License (MIT)
Copyright (c) 2011 Andrew Scott
https://github.com/anddrewscott/Moai-work/
Contributions by Reflare UG
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files 
(the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

module(..., package.seeall)

debugPrint = true
function prnt(message)
	if debugPrint == true then
		print(message)
	end
end


function makewalls()

	local wall = {}
	local wallBody = world:addBody ( MOAIBox2DBody.STATIC )
	wall[1] = wallBody:addRect (0,H, W,H ) --top
	wall[2] = wallBody:addRect (W,0, W,H ) --right
	wall[3] = wallBody:addRect (0,0, W,0 ) -- bottom
	wall[4] = wallBody:addRect (0,0, 0,H ) -- left

	for i = 1, 4 do
		wall[i].id = "wall"
	end
prnt("walls made")
end

savedtexture = {}

function maketexture(texture, image)
	texture = MOAIGfxQuad2D.new ()
	texture:setTexture ( image )
return texture
end

function newImage(image, xStart, yStart, xLength, yLength, save)
	 if save == true then
		if savedtexture[image] then
			prnt("'"..image.."'".." save exists. Using it")
			texture = savedtexture[image]
		else
			savedtexture[image] = maketexture(save, image)
			texture = savedtexture[image]
			prnt("'"..image.."'".." save does not exist")
		end
	elseif save == false then
		if savedtexture[image] then
			prnt("removing '"..image.."'".." save")
			texture = savedtexture[image]
			savedtexture[image] = nil
		end
	else
		prnt("not saving")
		texture = maketexture(save, image)
	end

	x, y = xLength*.5, yLength*.5
	texture:setRect  (-x, -y, x, y)

	name = MOAIProp2D.new ()
	name:setDeck ( texture )
	layer:insertProp ( name )
	name:setLoc(xStart, yStart)

	texture, x, y = nil
	return name
end


local default = {density = 1, friction = 0.3, cpfriction = 10, bounce = 0.2, mass = 1, radius = nil}

function addBody(imgname, bodytype, property) 
local zero, zero, xEnd, yEnd = imgname:getRect()
local xLoc, yLoc = imgname:getLoc()
local density = default.density
local friction = default.friction
local bounce = default.bounce
		if property.density then
			density = property.density
		end

		if property.friction then
			friction = property.friction
		end

		if property.bounce then
			bounce = property.bounce
		end	

		if property.radius then
			if property.radius == "img" then
				radius = xEnd
			else
				radius = property.radius
			end
		end
	if bodytype then
		if bodytype == "dynamic" then
			BodyType = MOAIBox2DBody.DYNAMIC 
		elseif bodytype == "static" then
			BodyType = MOAIBox2DBody.STATIC 
		elseif bodytype == "kinematic" then
			BodyType = MOAIBox2DBody.KINEMATIC
		else 
			prnt("fail. '"..bodytype.."' is not a body type!    Using dynamic.")
			BodyType = MOAIBox2DBody.DYNAMIC 
		end
	else
		BodyType = MOAIBox2DBody.DYNAMIC 
	end


	local body = world:addBody ( BodyType )
	if radius then
		fixture = body:addCircle (0, 0, radius )
	else
		fixture = body:addRect (-xEnd, -yEnd, xEnd, yEnd)
	end

	body:setTransform(xLoc,yLoc, 50, false)
	imgname:setLoc(0,0)

	fixture:setDensity ( density )
	fixture:setFriction ( friction )
	fixture:setRestitution ( bounce )
	imgname:setParent ( body )

	body:resetMassData() --VERY important. it is why the shapes weren't rotating!

	density,friction,bounce, bodytype, zero,xEnd,yEnd,xLoc,yLoc,radius,fixture, BodyType = nil
	return body
end


function cpaddBody(imgname, property)
local zero, zero, xEnd, yEnd = imgname:getRect()
local xLoc, yLoc = imgname:getLoc()

local density = default.density
local friction = default.cpfriction
local bounce = default.bounce
		if property.density then
			density = property.density
		end

		if property.friction then
			friction = property.friction
		end

		if property.bounce then
			bounce = property.bounce
		end	

		if property.radius then
			if property.radius == "img" then
				radius = xEnd
			else
				radius = property.radius
			end
		end

	mass = 1

	if radius then
		moment = MOAICpShape.momentForCircle ( mass, radius, 0, 0)
	else
		moment = MOAICpShape.momentForRect ( mass, -xEnd, -yEnd, xEnd, yEnd)
	end

	local body = MOAICpBody.new ( mass, moment )
	space:insertPrim ( body )

	if radius then
		shape = body:addCircle (radius , 0, 0 )
	else
		shape = body:addRect (-xEnd, -yEnd, xEnd, yEnd)
	end

	shape:setElasticity ( bounce )
	shape:setFriction ( friction )
	shape:setType ( 1 )

	space:insertPrim ( shape )
	imgname:setParent ( body )
	body:setPos(xLoc,yLoc)
	imgname:setLoc(0,0)
	density, friction, bounce, mass, zero, xEnd, yEnd, xLoc, yLoc, radius, moment, shape = nil
	return body
end

function cpmakewalls()
	wall = space:getStaticBody ()

	function addSegment ( x0, y0, x1, y1 )
		shape = wall:addSegment ( x0, y0, x1, y1 )
		shape:setElasticity ( 1 )
		shape:setFriction ( 0.1 )
		shape:setType ( 1 )
		shape.name = "wall"
		space:insertPrim ( shape )
	end

	addSegment ( 0, 0, W, 0 ) --bottom
	addSegment ( 0, H, W, H ) --top
	addSegment ( 0, 0, 0, H ) --left
	addSegment ( W, 0, W, H ) --right
prnt("walls made")
end

--[[
function checkSleep(target)
vx, vy = target:getVel()
prnt(round(vx, no), round(vy, no))
	if round(vx, no) == 0 and round(vy, no) == 0 then
		target:sleep()
	end
end
--]]

local target = {}
local targetfunc = {}
local event = {xStart = nil, yStart = nil, x = nil, y = nil, phase = nil, target = nil, inside = nil}

local prev = {x = nil, y = nil, phase = nil}

--[[
function removeSelf(var)
	if target[#target] then
		target[#target] = nil
		prnt(target[#target])
	end
	prnt("var in array: "..#target)
end
--]]


function addListener(obj, funct)
	prnt("adding listener")
	if obj.num then 
		if targetfunc[obj.num] == funct then
			prnt("That object is already being listened to.")
				return false
		else
			prnt("object listener overwritten with new function.")
			targetfunc[i] = funct --replace function with new function
		end
	else
		i = #target+1
		target[i] = obj
		targetfunc[i] = funct
		obj.num = i  --sets the object's .num value to the objects position in the listener table
		prnt("object listener set.")
	end
end

function removeListener(obj)
numb = #target-1
	if obj.num then --if object is being listened to
		for i = obj.num,  numb do --obj.num to find the objects position in the table.
			target[i] = target[i+1] --genius.
			targetfunc[i] = targetfunc[i+1] --oops forgot about the function
		end
		obj.num = nil
		target[#target] = nil
		targetfunc[#targetfunc] = nil
		prnt("Object listener removed")
	else
		--prnt("that object is not being listened to.")
			return false
	end
end

function onEvent(event)
prnt(event.phase)
	if event.phase == "began" then
		for i = 1, #target do	
			if target[i]:inside ( event.x, event.y ) then
				event.target = target[i]
				event.target.n = i
				targetfunc[event.target.n](event, mad)
			end
		end
		if event.target then
		prnt("target found")
				MOAIInputMgr.device.pointer:setCallback ( 
					function( x , y )
						event.x , event.y = layer:wndToWorld ( MOAIInputMgr.device.pointer:getLoc () )
							if event.x ~= prev.x or event.y ~= prev.y then
								prev.phase = event.phase
								event.phase = "moved"
								if event.target:inside ( event.x, event.y ) then 
									event.inside = true
								else
									event.inside = false
								end
							end
						prev.x , prev.y = event.x , event.y
						onEvent(event)
					end
				)
		end
	end
	if event.target and event.phase ~= "began" then
		targetfunc[event.target.n](event, mad)
		if event.phase == "ended" then
			event.target, event.xStart , event.yStart, event.x , event.y, event.inside = nil
			prev.phase, prev.x, prev.y = nil
			MOAIInputMgr.device.pointer:setCallback (function() return false end)
		end
	end
end

local receiver = nil
function onTouchEvent (event)
	local function passOn (event)
		event.target = target[i]
		event.target.n = i
		targetfunc[event.target.n](event, mad)
	end
	
	for i = 1, #target do	
		if target[i]:inside ( event.x, event.y ) then
			if event.phase == "began" then
				receiver = i
				passOn(event)
			else
				if receiver == i then
					passOn(event)
				end
			end
		end
	end	
end


function Callback()
	
	local function mouseDown ( down )
		if down then
			event.xStart, event.yStart = layer:wndToWorld ( MOAIInputMgr.device.pointer:getLoc () )
			event.x, event.y = event.xStart, event.yStart
			prev.x , prev.y = event.xStart, event.yStart
			event.phase = "began"
		else	
			event.phase = "ended"
		end
		onEvent(event)
	end
	
	local function touchEvent ( eventType,idx,x,y,tapCount )
		event = {}
		event.xStart, event.yStart = layer:wndToWorld(x,y)
		event.x, event.y = event.xStart, event.yStart
		prev.x , prev.y = event.xStart, event.yStart
		if (eventType == 0) then
			event.phase = "began"
			onTouchEvent(event)
		elseif (eventType == 1) then
			event.phase = "moved"
			onTouchEvent(event)
		else
			event.phase = "ended"
			onTouchEvent(event)
			receiver = nil
		end
	end
	
	if (MOAIInputMgr.device.mouseLeft) then
		type = "mouse"
		MOAIInputMgr.device.mouseLeft:setCallback (mouseDown)
	elseif (MOAIInputMgr.device.touch) then
		type = "touch"
		inputMethod = MOAIInputMgr.device.touch
		MOAIInputMgr.device.touch:setCallback (touchEvent)
	else
		prnt("Unsupported input platform!")
	end
end
Callback()

function alpha(target, alpha)
target:setColor(alpha,alpha,alpha,alpha )
end

function performWithDelay ( delay, func, repeats, ... )
  local t = MOAITimer.new ()
  t:setSpan (delay/100)
  t:setListener ( MOAITimer.EVENT_TIMER_LOOP,
    function ()
      t:stop ()
      t = nil
      func ( unpack ( arg ))
		if repeats then
			if repeats > 1 then
				prnt(repeats.." repeats to go")
				display.performWithDelay(delay, func, repeats - 1, unpack ( arg ))
			elseif repeats == 1 then
				prnt("ended")
			elseif repeats == 0 then
				display.performWithDelay(delay, func, 0, unpack ( arg ))
			end
		end
    end
  )
  t:start ()
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end


	local lastCheck = {sysMem = 0}
function checkMem(say)
    collectgarbage()
 
    local sysMem = collectgarbage("count") * .001

	local function printmem()
		lastCheck.sysMem = sysMem
		print ("Mem: " .. math.floor(sysMem*1000)*.001 .. "MB \t")
	end

	if say == true then
		printmem()
	elseif say == false then
		if lastCheck.sysMem ~= sysMem then
			printmem()
		end
	end
end