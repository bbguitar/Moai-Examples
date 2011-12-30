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

function new (l)
	
	----------------------------------------------------------------
	--background
	----------------------------------------------------------------
	local bg = {}
	bg.texture = MOAIGfxQuad2D.new ()
	bg.texture:setTexture('bg.png')
	bg.texture:setRect (-384,512,384,-512)
	bg.sprite = MOAIProp2D.new()
	bg.sprite:setDeck(bg.texture)
	l:insertProp(bg.sprite)

	----------------------------------------------------------------
	--info box
	----------------------------------------------------------------
	--[[local charcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-'

	local font = MOAIFont.new ()
	font:loadFromTTF ( 'swanse.ttf', charcodes, 25, 163 )

	local infoBox = MOAITextBox.new ()
	infoBox:setFont ( font )
	infoBox:setTextSize ( font:getScale ())
	infoBox:setString ( "Ready" )
	infoBox:setRect (-200,550,200,450)
	infoBox:setYFlip ( true )
	infoBox:setAlignment (MOAITextBox.CENTER_JUSTIFY)
	l:insertProp ( infoBox )]]
	
	----------------------------------------------------------------
	--Start Button
	----------------------------------------------------------------
	local btn2 = {}
	btn2.gfx = MOAIGfxQuad2D.new()
	btn2.gfx:setTexture("btnStart.png")
	btn2.gfx:setRect(-256,-128,256,128)
	btn2.prop = MOAIProp2D.new()
	btn2.prop:setDeck(btn2.gfx)
	btn2.prop:setLoc(0,-300)

	l:insertProp(btn2.prop)

	function btnBackDown(event)
		if (event.phase == "ended") then
			scene.swap("start","slideRight")
		end
	end

	display.addListener(btn2.prop,btnBackDown)

	----------------------------------------------------------------
	--box2d world
	----------------------------------------------------------------
	local world = MOAIBox2DWorld.new ()
	world:setGravity ( 0, 0 )
	world:setUnitsToMeters ( 1 / 30 )
	world:start ()
	world:setIterations(3,8)
	l:setBox2DWorld ( world )

	----------------------------------------------------------------
	--box2d bodies
	----------------------------------------------------------------
	-- walls
	local wallUp = world:addBody ( MOAIBox2DBody.STATIC )
	local wallDown = world:addBody ( MOAIBox2DBody.STATIC )
	local wallLeft = world:addBody ( MOAIBox2DBody.STATIC )
	local wallRight = world:addBody ( MOAIBox2DBody.STATIC )
	wallUp.fixture = wallUp:addRect(-384,-5,385,5)
	wallDown.fixture = wallDown:addRect(-385,-5,385,5)
	wallLeft.fixture = wallLeft:addRect(-5,512,5,-512)
	wallRight.fixture = wallRight:addRect(-5,512,5,-512)

	wallUp:setTransform(0,502)
	wallDown:setTransform(0,-502)
	wallLeft:setTransform(-370,0)
	wallRight:setTransform(370,0)

	----------------------------------------------------------------
	--create object function
	----------------------------------------------------------------

	local objectTexture = MOAIGfxQuad2D.new ()
	objectTexture:setTexture('object.png')
	objectTexture:setRect (-64,-64,64,64)

	local function makeObject ()
		--a dynamic body
		local dynamicBody = world:addBody ( MOAIBox2DBody.DYNAMIC )
		dynamicBody:setTransform(math.random(-300,300), math.random(-480,480))
		local velX = math.random(200,1300)
		dynamicBody:setLinearVelocity(velX,1500-velX)
	
		local circleFixture = dynamicBody:addCircle(0, 0, 36)
		circleFixture:setDensity(1)
		circleFixture:setRestitution(1)
		circleFixture:setFriction(0)
		dynamicBody:resetMassData()
	
		local object = MOAIProp2D.new()
		object:setDeck(objectTexture)
		object:setParent(dynamicBody)
		l:insertProp(object)
	end

	x = 1
	while x < 15 do
		makeObject()
		x = x + 1
	end

	local function updateFPS ()
		local frames = 0
	
		while true do
			coroutine.yield ()
			frames = frames + 1
			if frames % 10 == 0 then
				--infoBox:setString(string.format("%d",MOAISim.getPerformance()))
			end
		end
	end


	local thread = MOAIThread.new()
	thread:run(updateFPS)
end