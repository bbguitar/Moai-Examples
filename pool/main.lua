--Functions

function onCollide ( event, fixtureA, fixtureB, arbiter )

	if event == MOAIBox2DArbiter.BEGIN then	
		if fixtureA.userdata and fixtureB.userdata then
		--print( fixtureA.userdata.." collided with " .. fixtureB.userdata)		
			
			if fixtureA.userdata>0 and fixtureB.userdata==-1 then
				if ball_sprites[fixtureA.userdata] then 
					layer:removeProp ( ball_sprites[fixtureA.userdata] )
					bx,by= fixtureA:getBody():getWorldCenter()
					
					particles(bx,by)
					fixtureA:getBody():destroy()
					
					destroyed=destroyed+1
					
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


function onLevelEvent ( x, y, z )
world:setGravity(y,x*-1)
end

if MOAIInputMgr.device.level then
MOAIInputMgr.device.level:setCallback ( onLevelEvent )
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
			init:rand		( PARTICLE_X1, CONST ( pX+4), CONST ( pX-4))
			init:rand		( PARTICLE_Y1, CONST ( pY+4), CONST ( pY-4))
			init:rand		( PARTICLE_S0, CONST ( pX), CONST ( pX))
			init:rand		( PARTICLE_S1, CONST ( pY), CONST ( pY))
			local render = MOAIParticleScript.new ()
			render:ease		( MOAIParticleScript.PARTICLE_X, MOAIParticleScript.PARTICLE_DX, PARTICLE_X1, MOAIEaseType.LINEAR )
			render:ease		( MOAIParticleScript.PARTICLE_Y, MOAIParticleScript.PARTICLE_DY, PARTICLE_Y1, MOAIEaseType.LINEAR )

			render:sprite			()
			--render:ease			    ( MOAIParticleScript.SPRITE_X_SCL, CONST ( 0.1 ), CONST ( 0.5),MOAIEaseType.EASE_IN)
			render:rand			    ( MOAIParticleScript.SPRITE_X_SCL, CONST ( 0), CONST ( 0.5))
			render:rand			    ( MOAIParticleScript.SPRITE_Y_SCL, CONST ( 0), CONST ( 0.5))
			--render:ease			    ( MOAIParticleScript.SPRITE_Y_SCL, CONST ( 0.1), CONST ( 0.5),MOAIEaseType.EASE_IN)
			render:ease			    ( MOAIParticleScript.SPRITE_OPACITY, CONST ( 1), CONST ( 0.3),MOAIEaseType.EASE_IN)
			render:rand			    ( MOAIParticleScript.SPRITE_ROT, CONST ( -180), CONST ( 180))
	
			state1:setInitScript ( init )
			state1:setRenderScript ( render )
			system:setState ( 1, state1 )
		
			system:surge (32,pX,pY,pX,pY)
end

function emitBox()
for x = 1, 10 do
        for y = 1, 10 do
		c=c+1
		ball_bodies[c] = world:addBody ( MOAIBox2DBody.DYNAMIC )
		ball_bodies[c]:setTransform(x*2,y*2,0)
		--ball_bodies[c]:setFixedRotation(true)
		
					ball_sprites[c] = MOAIProp2D.new ()
					
		if x<=5 then 
			ball_fixtures[c] = ball_bodies[c]:addCircle ( 0,0,1)
			ball_sprites[c]:setDeck ( texture2 )
			ball_fixtures[c]:setDensity ( 0.02 )
		end
		if x>5 then
			ball_fixtures[c] = ball_bodies[c]:addRect ( -1,-1,1,1)
			ball_sprites[c]:setDeck ( texture3 )
			ball_fixtures[c]:setDensity ( 0.5 )
		end
		
		ball_sprites[c]:setParent ( ball_bodies[c] )
		layer:insertProp ( ball_sprites[c] )
		
		ball_fixtures[c]:setFriction ( 0.3 )
		ball_fixtures[c]:setRestitution ( 0.1)

		ball_fixtures[c].userdata=c	
				
		ball_bodies[c]:resetMassData()		
		ball_fixtures[c]:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x03 )
	
        end
end
end

-- walls
function make_walls()
wall_bodies[1] = world:addBody ( MOAIBox2DBody.STATIC )
wall_fixtures[1] = wall_bodies[1]:addRect (-20,30,30,29) --top
wall_fixtures[1]:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x00 )
wall_bodies[1]:resetMassData()	
wall_textures[1] = MOAIGfxQuad2D.new ()
wall_textures[1] :setTexture ( 'wall1.png' )
wall_textures[1] :setRect ( -20,30,30,29) --top
wall_sprites[1]=MOAIProp2D.new ()
wall_sprites[1]:setParent ( wall_bodies[1] )
wall_sprites[1]:setDeck ( wall_textures[1] )
layer:insertProp ( wall_sprites[1])

wall_bodies[2] = world:addBody ( MOAIBox2DBody.STATIC )
wall_fixtures[2] = wall_bodies[2]:addRect (-20,-20,30,-19) -- bottom
wall_fixtures[2]:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x00 )
wall_bodies[2]:resetMassData()	
wall_textures[2] = MOAIGfxQuad2D.new ()
wall_textures[2] :setTexture ( 'wall1.png' )
wall_textures[2] :setRect (-20,-20,30,-19) -- bottom
wall_sprites[2]=MOAIProp2D.new ()
wall_sprites[2]:setParent ( wall_bodies[2] )
wall_sprites[2]:setDeck ( wall_textures[2] )
layer:insertProp ( wall_sprites[2])

wall_bodies[3] = world:addBody ( MOAIBox2DBody.STATIC )
wall_fixtures[3] = wall_bodies[3]:addRect ( -20,-30,-19,30) -- left
wall_fixtures[3]:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x00 )
wall_bodies[3]:resetMassData()	
wall_textures[3] = MOAIGfxQuad2D.new ()
wall_textures[3] :setTexture ( 'wall1.png' )
wall_textures[3] :setRect ( -20,-30,-19,30) -- left
wall_sprites[3]=MOAIProp2D.new ()
wall_sprites[3]:setParent ( wall_bodies[3] )
wall_sprites[3]:setDeck ( wall_textures[3] )
layer:insertProp ( wall_sprites[3])

wall_bodies[4] = world:addBody ( MOAIBox2DBody.STATIC )
wall_fixtures[4] = wall_bodies[4]:addRect ( 29,-30,30,30) -- right
wall_fixtures[4]:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x00 )
wall_bodies[4]:resetMassData()	
wall_textures[4] = MOAIGfxQuad2D.new ()
wall_textures[4] :setTexture ( 'wall1.png' )
wall_textures[4] :setRect ( 29,-30,30,30) -- right
wall_sprites[4]=MOAIProp2D.new ()
wall_sprites[4]:setParent ( wall_bodies[4] )
wall_sprites[4]:setDeck ( wall_textures[4] )
layer:insertProp ( wall_sprites[4])
end


function callWithDelay ( delay, func, ... )
  local timer = MOAITimer.new ()
  timer:setSpan ( delay )
  timer:setListener ( MOAITimer.EVENT_TIMER_LOOP,
    function ()
      timer:stop ()
      timer = nil
      func ( unpack ( arg ))
    end
  )
  timer:start ()
end

-- add rope
function add_rope()
ropes = {}
rope_sprites = {}

ropes[0] = world:addBody ( MOAIBox2DBody.DYNAMIC )

bx,by= ropes[0] :getPosition()
fixture = ropes[0] :addRect( -0.25,-1,0.25,1 )
fixture:setDensity ( 1)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.25)
fixture:setFilter ( 0x01 )
fixture.userdata=-1
world:addRevoluteJoint ( ropes[0] , wall_bodies[1],0,2)
ropes[0] :resetMassData()

for y = 1, 10 do
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
rope_sprites[y]=MOAIProp2D.new ()
rope_sprites[y]:setParent ( ropes[y] )
rope_sprites[y]:setDeck ( texture3 )
layer:insertProp ( rope_sprites[y] )

end
end


-------------------------------------------------------------------------------

-- variables

ball_fixtures = {}
ball_bodies = {}
ball_sprites = {}
wall_fixtures = {}
wall_bodies = {}
wall_sprites = {}
wall_textures = {}
destroyed=0
c=0

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

-- textures
texture = MOAIGfxQuad2D.new ()
texture:setTexture ( 'ball1.png' )
texture:setRect ( -1, -1, 1, 1)

texture2 = MOAIGfxQuad2D.new ()
texture2:setTexture ( 'ball2.png' )
texture2:setRect ( -1, -1, 1, 1)

texture3 = MOAIGfxQuad2D.new ()
texture3:setTexture ( 'ball3.png' )
texture3:setRect ( -1, -1, 1, 1)

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

-- MAIN GAMES BEGIN
make_walls()
add_rope()
emitBox()

mainThread = MOAIThread.new ()
mainThread:run ( 

	function ()
		while not gameOver do
		coroutine.yield ()
		--print (destroyed)
			if destroyed>105 then emitBox()
				destroyed=0
			end
		end

	end 
)
