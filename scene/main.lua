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

display = require("display")
reflare = require ("reflareLib")

STAGE_WIDTH = 768
STAGE_HEIGHT = 1024
SCREEN_WIDTH = 0
SCREEN_HEIGHT = 0

local platform = MOAIEnvironment.getDevModel()

if platform:find("iPad") then
	-- Runs on iPad
	SCREEN_WIDTH = 768
	SCREEN_HEIGHT = 1024
elseif platform:find("iPhone") then
	-- Runs on iPhone
	SCREEN_WIDTH = 320
	SCREEN_HEIGHT = 480
else
	-- Runs on iPad
	SCREEN_WIDTH = 768
	SCREEN_HEIGHT = 1024
end

MOAISim.openWindow ( "Textboxes", SCREEN_WIDTH, SCREEN_HEIGHT )
viewport = MOAIViewport.new ()
viewport:setScale ( STAGE_WIDTH, STAGE_HEIGHT )
viewport:setSize ( SCREEN_WIDTH, SCREEN_HEIGHT )

layer = MOAILayer2D.new()
layer:setViewport( viewport )
MOAISim.pushRenderPass(layer) 

scene = require("scene")
scene.push("start")