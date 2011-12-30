--[[
The MIT License (MIT)
Copyright (c) 2011 Reflare UG
https://github.com/reflare/Moai-Libraries
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

reflare = require("reflareLib")
display = require("display")

------------------------------------------
-- Globals
------------------------------------------
scenes = {}
aDuration = 0.5

------------------------------------------
-- Function Overrides
------------------------------------------

local function newInsertProp(target, prop)
	target:oldInsertProp(prop)
	table.insert(target.props,prop)
end

--[[
local function addObject (target, object)
	target.objects[target.objects] = object
end
]]

------------------------------------------
-- Push Scene
------------------------------------------

function push ( sceneName, effect )
	prnt("Pushing Scene <"..sceneName..">")
	local s = MOAILayer2D.new()
	table.insert(scenes,s)
	s.name = sceneName
	s:setViewport(viewport)
	s.props = {}
	--s.addObject = addObject
	s.oldInsertProp = s.insertProp
	s.insertProp = newInsertProp
	require(sceneName).new(s)
	MOAISim.pushRenderPass(s)
	
	print("POST SETUP PROP TABLE FOR SCENE")
	print(s)
	print(s.props)
	
	if effect == "fade" then
		for i=1,#s.props do
			s.props[i]:setColor(0,0,0,0)
		end
		for i=1,#s.props do
			s.props[i]:seekColor(1,1,1,1,aDuration)
		end
	elseif effect == "slideLeft" then
		local x,y = MOAISim.getDeviceSize()
		s:setLoc(x,0)
		s:seekLoc(0,0,aDuration)
	elseif effect == "slideRight" then
		local x,y = MOAISim.getDeviceSize()
		s:setLoc(-x,0)
		s:seekLoc(0,0,aDuration)
	end
end

------------------------------------------
-- Pop Scene
------------------------------------------

function pop ( effect )
	local num = #scenes
	local s = scenes[num]
	
	print("SCENE STACK ON POP")
	print(s)
	
	print("ENTER POP PROP TABLE FOR SCENE")
	print(s)
	print(s.props)
	
	for i=1,#s.props do
		display.removeListener(s.props[i])
		s.props[i] = nil
	end
	
	local function clean()
		prnt("Poping Scene <"..s.name..">")
		s:clear()
		s = nil
		table.remove(scenes,num)
		MOAISim:forceGarbageCollection()
	end
	
	if effect == "fade" then
		for i=1,#s.props do
			s.props[i]:seekColor(0,0,0,0,aDuration)
			display.performWithDelay(aDuration*100,clean)
		end
	elseif effect == "slideLeft" then
		local x,y = MOAISim.getDeviceSize()
		s:seekLoc(-x,0,aDuration)
		display.performWithDelay(aDuration*100,clean)
	elseif effect == "slideRight" then
		local x,y = MOAISim.getDeviceSize()
		s:seekLoc(x,0,aDuration)
		display.performWithDelay(aDuration*100,clean)
	else
		clean()
	end
end

------------------------------------------
-- Swap Scene
------------------------------------------

function swap ( sceneName, animation )
	pop(animation)
	push(sceneName,animation)
end