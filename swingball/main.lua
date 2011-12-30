ball_fixtures = {}
ball_bodies = {}
ball_sprites = {}

--Functions

function onCollide ( event, fixtureA, fixtureB, arbiter )

	if event == MOAIBox2DArbiter.BEGIN then	
		if fixtureA.userdata and fixtureB.userdata then
		--print( fixtureA.userdata.." collided with " .. fixtureB.userdata)		
			
			if fixtureA.userdata>0 and fixtureB.userdata==-1 then
				if ball_sprites[fixtureA.userdata] then 
					layer:removeProp ( ball_sprites[fixtureA.userdata] )
					bx,by= fixtureA:getBody():getPosition()
					particles(bx,by)
					fixtureA:getBody():destroy()
				end
			end
		end
	end
	
	if event == MOAIBox2DArbiter.END then
	
	end
	
	if event == MOAIBox2DArbiter.PRE_SOLVE then
	

	end
	
	if event == MOAIBox2DArbiter.POST_SOLVE then

	end
end

function pointerCallback ( x, y )
	
	local oldX = mouseX
	local oldY = mouseY
	
	mouseX, mouseY = layer:wndToWorld ( x, y )
	
	bx,by= body:getPosition()
	mouseX=mouseX-bx;
	mouseY=mouseY-by;
	
	if pick then
		pick:addLoc ( mouseX - oldX, mouseY - oldY )
	end
end
		
function clickCallback ( down )
	
	if down then
		body:setLinearVelocity(0,0)

	end
	
	if down==false then
		bx,by= body:getPosition()
		body:applyForce( mouseX *-5000, mouseY *-5000,bx,by)

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


function particles(pX,pY)

			CONST = MOAIParticleScript.packConst

			local PARTICLE_X1 = MOAIParticleScript.packReg ( 1 )
			local PARTICLE_Y1 = MOAIParticleScript.packReg ( 2 )
			local PARTICLE_R0 = MOAIParticleScript.packReg ( 3 )
			local PARTICLE_R1 = MOAIParticleScript.packReg ( 4 )
			local PARTICLE_S0 = MOAIParticleScript.packReg ( 5 )
			local PARTICLE_S1 = MOAIParticleScript.packReg ( 6 )

			system = MOAIParticleSystem.new ()
			system:reserveParticles ( 256, 2 )
			system:reserveSprites ( 256 )
			system:reserveStates ( 1 )
			system:setDeck ( particletexture )
			system:start ()

			emitter = MOAIParticleDistanceEmitter.new ()
			emitter:setLoc ( 0, 0 )
			emitter:setSystem ( system )
			emitter:setMagnitude ( 0.125 )
			emitter:setAngle ( 260, 280 )
			emitter:setDistance ( 4 )
			emitter:start ()

			state1 = MOAIParticleState.new ()
			state1:setTerm ( 0, 1.25 )
			layer:insertProp ( system )

			local init = MOAIParticleScript.new ()
			init:rand		( PARTICLE_X1, CONST ( pX-2 ), CONST ( pX+2))
			init:rand		( PARTICLE_Y1, CONST ( pY-2), CONST ( pY+2))
			local render = MOAIParticleScript.new ()
			render:ease		( MOAIParticleScript.PARTICLE_X, MOAIParticleScript.PARTICLE_X, PARTICLE_X1, MOAIEaseType.LINEAR )
			render:ease		( MOAIParticleScript.PARTICLE_Y, MOAIParticleScript.PARTICLE_Y, PARTICLE_Y1, MOAIEaseType.LINEAR )

			render:sprite			()
			render:ease			    ( MOAIParticleScript.SPRITE_X_SCL, CONST ( 1 ), CONST ( 0.1),MOAIEaseType.EASE_IN)
			render:ease			    ( MOAIParticleScript.SPRITE_Y_SCL, CONST ( 1), CONST ( 0.1),MOAIEaseType.EASE_IN)
			render:ease			    ( MOAIParticleScript.SPRITE_OPACITY, CONST ( 1), CONST ( 0.1),MOAIEaseType.EASE_IN)
			render:rand			    ( MOAIParticleScript.SPRITE_ROT, CONST ( -180), CONST ( 180))
	
			state1:setInitScript ( init )
			state1:setRenderScript ( render )
			system:setState ( 1, state1 )
		
			system:surge (64,pX,pY,pX,pY)
end



-- setup graphics
MOAISim.openWindow ( "test", 960, 480 )
viewport = MOAIViewport.new ()
screenx=960
screeny=480
viewport:setSize ( screenx,screeny )
viewport:setScale ( 64, 0 )

-- set up the world and start its simulation
world = MOAIBox2DWorld.new ()
world:setGravity ( 0, -10 )
world:setUnitsToMeters ( 2 )
world:start ()

function onLevelEvent ( x, y, z )
world:setGravity(y,x*-1)
end

if MOAIInputMgr.device.level then
MOAIInputMgr.device.level:setCallback ( onLevelEvent )
end

-- textures
texture = MOAIGfxQuad2D.new ()
texture:setTexture ( 'ball1.png' )
texture:setRect ( -1, -1, 1, 1)

texture2 = MOAIGfxQuad2D.new ()
texture2:setTexture ( 'ball2.png' )
texture2:setRect ( -1, -1, 1, 1)

particletexture = MOAIGfxQuad2D.new ()
particletexture:setTexture ( 'particle.png' )
particletexture:setRect ( -0.8, -0.8, 0.8, 0.8)

-- layers
layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
layer:setBox2DWorld ( world )

-- player
body = world:addBody ( MOAIBox2DBody.DYNAMIC )
body:setTransform(0,-4,0)


--body:setFixedRotation(true)
--body:setAngularDamping(1)

fixture = body:addCircle( 0,0,1 )
fixture:setDensity ( 1)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.5)
fixture:setFilter ( 0x01 )
fixture.userdata=-1
body:resetMassData()
fixture:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x01)

sprite = MOAIProp2D.new ()
sprite:setDeck ( texture )
sprite:setParent ( body )
layer:insertProp ( sprite )

-- walls
platform1 = world:addBody ( MOAIBox2DBody.STATIC )
fixture2 = platform1:addRect (-20,30,30,29) --top
fixture2:setFilter ( 0x02 )
fixture2.userdata=0
fixture2:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x00 )

platform2 = world:addBody ( MOAIBox2DBody.STATIC )
fixture2 = platform2:addRect (-20,-30,-19,30) -- left
fixture2:setFilter ( 0x02 )
fixture2.userdata=0
fixture2:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x00 )

platform3 = world:addBody ( MOAIBox2DBody.STATIC )
fixture2 = platform3:addRect ( 29,-30,30,30) -- right
fixture2:setFilter ( 0x02 )
fixture2.userdata=0
fixture2:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x00 )

platform4 = world:addBody ( MOAIBox2DBody.STATIC )
fixture2 = platform4:addRect (-20,-20,30,-19) -- bottom
fixture2:setFilter ( 0x02 )
fixture2.userdata=0
fixture2:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x00 )

-- add rope

ropes = {}

ropes[0] = world:addBody ( MOAIBox2DBody.DYNAMIC )

bx,by= ropes[0] :getPosition()
fixture = ropes[0] :addRect( -0.25,-1,0.25,1 )
fixture:setDensity ( 1)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.25)
fixture:setFilter ( 0x01 )
fixture.userdata=-1
world:addRevoluteJoint ( ropes[0] , platform1,0,2)
ropes[0] :resetMassData()

for y = 1, 8 do
ropes[y] = world:addBody ( MOAIBox2DBody.DYNAMIC )

fixture = ropes[y]:addRect( -0.25,-1,0.25,1 )
ropes[y]:setTransform(0,(y*-2)+2,0)
bx,by= ropes[y]:getPosition()
fixture:setDensity ( 1)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.25)
fixture:setFilter ( 0x01 )
fixture.userdata=-1
world:addRevoluteJoint ( ropes[y], ropes[y-1],0,3-y*2)
ropes[y]:resetMassData()

end

body:setTransform(0,(9*-2)+2,0)
world:addRevoluteJoint ( body , ropes[8],0,3-9*2)
body:resetMassData()

-- add load of other balls

c=0
for x = 1, 10 do
        for y = 1, 10 do
		c=c+1
		ball_bodies[c] = world:addBody ( MOAIBox2DBody.DYNAMIC )
		ball_bodies[c]:setTransform(x*2,y*2,0)
		--ball_bodies[c]:setFixedRotation(true)
		
		if x<=5 then 
			ball_fixtures[c] = ball_bodies[c]:addCircle ( 0,0,1)
		end
		if x>5 then
			ball_fixtures[c] = ball_bodies[c]:addRect ( -1,-1,1,1)
		end

		
		ball_fixtures[c]:setDensity ( 0.02 )
		ball_fixtures[c]:setFriction ( 0.3 )
		ball_fixtures[c]:setRestitution ( 0.1)

		ball_fixtures[c].userdata=c	
				
		ball_bodies[c]:resetMassData()		
		ball_fixtures[c]:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x03 )

		
		ball_sprites[c] = MOAIProp2D.new ()
		ball_sprites[c]:setDeck ( texture2 )
		layer:insertProp ( ball_sprites[c] )
		ball_sprites[c]:setParent ( ball_bodies[c] )

		
			
        end
end

-- setup camera
camera = MOAITransform.new ()
layer:setCamera ( camera )
MOAISim.pushRenderPass ( layer )

-- setup camera fitter / tracker
fitter = MOAICameraFitter2D.new ()
fitter:setViewport ( viewport )
fitter:setCamera ( camera )
fitter:setBounds ( -50,-100,50,100 )
fitter:setMin ( 20 )
fitter:start ()
anchor = MOAICameraAnchor2D.new ()
anchor:setParent ( sprite )
anchor:setRect ( -1,-1,1,1 )
fitter:insertAnchor ( anchor )



