----------------------------------------------------------------
-- Copyright (c) 2010-2011 Zipline Games, Inc. 
-- All Rights Reserved. 
-- http://getmoai.com
----------------------------------------------------------------

print ( "hello, moai!" )

viewport = MOAIViewport.new ()
viewport:setSize ( 640, 480 )
viewport:setScale ( 640, 480 )

layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
MOAISim.pushRenderPass ( layer )

MOAISim.openWindow ( "cathead", 640, 480 )

CONST = MOAIParticleScript.packConst

local PARTICLE_X1 = MOAIParticleScript.packReg ( 1 )
local PARTICLE_Y1 = MOAIParticleScript.packReg ( 2 )
local PARTICLE_R0 = MOAIParticleScript.packReg ( 3 )
local PARTICLE_R1 = MOAIParticleScript.packReg ( 4 )
local PARTICLE_S0 = MOAIParticleScript.packReg ( 5 )
local PARTICLE_S1 = MOAIParticleScript.packReg ( 6 )

----------------------------------------------------------------
local init = MOAIParticleScript.new ()

init:rand		( PARTICLE_X1, CONST ( -100 ), CONST ( 100))
init:rand		( PARTICLE_Y1, CONST ( -100 ), CONST ( 100 ))



local render = MOAIParticleScript.new ()
render:ease		( MOAIParticleScript.PARTICLE_X, MOAIParticleScript.PARTICLE_X, MOAIParticleScript.PARTICLE_X+PARTICLE_X1, MOAIEaseType.EASE_IN )
render:ease		( MOAIParticleScript.PARTICLE_Y, MOAIParticleScript.PARTICLE_Y, MOAIParticleScript.PARTICLE_Y+PARTICLE_Y1, MOAIEaseType.EASE_IN )

--render:add				( MOAIParticleScript.PARTICLE_X, MOAIParticleScript.PARTICLE_X, MOAIParticleScript.PARTICLE_DX )
--render:add				( MOAIParticleScript.PARTICLE_Y, MOAIParticleScript.PARTICLE_Y, MOAIParticleScript.PARTICLE_DY )


render:sprite			()
render:ease			    ( MOAIParticleScript.SPRITE_X_SCL, CONST ( 1 ), CONST ( 0.1),MOAIEaseType.EASE_IN)
render:ease			    ( MOAIParticleScript.SPRITE_Y_SCL, CONST ( 1), CONST ( 0.1),MOAIEaseType.EASE_IN)
render:ease			    ( MOAIParticleScript.SPRITE_OPACITY, CONST ( 1), CONST ( 0.1),MOAIEaseType.EASE_IN)
render:ease			    ( MOAIParticleScript.SPRITE_ROT, CONST ( -180), CONST ( 180),MOAIEaseType.EASE_IN)

----------------------------------------------------------------

texture = MOAIGfxQuad2D.new ()
texture:setTexture ( "cathead.png" )
texture:setRect ( -16, -16, 16, 16 )

system = MOAIParticleSystem.new ()
system:reserveParticles ( 256, 2 )
system:reserveSprites ( 256 )
system:reserveStates ( 1 )
system:setDeck ( texture )
system:start ()

emitter = MOAIParticleDistanceEmitter.new ()
emitter:setLoc ( 0, 0 )
emitter:setSystem ( system )
emitter:setMagnitude ( 0.125 )
emitter:setAngle ( 260, 280 )
emitter:setDistance ( 16 )
emitter:start ()


		state1 = MOAIParticleState.new ()
		state1:setTerm ( 0, 1.25 )
		state1:setInitScript ( init )
		state1:setRenderScript ( render )
		system:setState ( 1, state1 )
		
layer:insertProp ( system )

function pointerCallback ( x, y )
	
	mouseX, mouseY = layer:wndToWorld ( x, y )
	
	emitter:setLoc ( mouseX, mouseY )
	
	if MOAIInputMgr.device.mouseLeft:isUp () then
		--emitter:reset ()
	end
end
		
function clickCallback ( down )
	
	if down then

	emitter:setLoc ( -320,-50 )
		--system:surge ( 256)
	end
	
	if down==false then
		
	end

end

if MOAIInputMgr.device.pointer then
	
	-- mouse input
	MOAIInputMgr.device.pointer:setCallback ( pointerCallback )
	MOAIInputMgr.device.mouseLeft:setCallback ( clickCallback )
else

	-- touch input
	MOAIInputMgr.device.touch:setCallback ( 
	
		function ( eventType, idx, x, y, tapCount )

			pointerCallback ( x, y )
		
			if eventType == MOAITouchSensor.TOUCH_DOWN then
				clickCallback ( true )
			elseif eventType == MOAITouchSensor.TOUCH_UP then
				clickCallback ( false )
			end
		end
	)
end

