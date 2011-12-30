function add_actor(x,y,width,height,density,friction,restitution,actorname,bodytype,texture_image)
		density=0+density
		restitution=0+restitution
		friction=0+friction
		ball_sprites[c] = MOAIProp2D.new ()
		
		if bodytype=="Dynamic" then 
		ball_bodies[c] = world:addBody ( MOAIBox2DBody.DYNAMIC )
		end
		if bodytype=="Static" then 
		ball_bodies[c] = world:addBody ( MOAIBox2DBody.STATIC )
		end
		
			ball_bodies[c]:setTransform(x*2,y*2,0)
		
		if actorname=="Circle" then 

		texture = MOAIGfxQuad2D.new ()
		texture:setTexture ( texture_image )
		texture:setRect ( width/2*-1,width/2*-1,width/2,width/2)
		ball_sprites[c]:setDeck ( texture ) 
		
		ball_fixtures[c] = ball_bodies[c]:addCircle ( 0,0,width/2)
		end
		if actorname=="Box" then 
		texture = MOAIGfxQuad2D.new ()
		texture:setTexture ( texture_image )
		texture:setRect ( width/2*-1,height/2*-1,width/2,height/2)
		ball_sprites[c]:setDeck ( texture ) 
		ball_fixtures[c] = ball_bodies[c]:addRect ( width/2*-1,height/2*-1,width/2,height/2)	
		end
		if actorname=="Triangle" then 
		texture = MOAIGfxQuad2D.new ()
		texture:setTexture ( texture_image )
		texture:setRect ( width/2*-1.5,height/2*-1.5,width/2*1.5,height/2*1.5)
		ball_sprites[c]:setDeck ( texture ) 
		t = { 1*width,-1*width,0*width,1*width,-1*width,-1*width }
		ball_fixtures[c] = ball_bodies[c]:addPolygon (t)
		end

		ball_fixtures[c]:setDensity ( density )
		ball_fixtures[c]:setFriction ( friction )
		ball_fixtures[c]:setRestitution ( restitution)
		ball_fixtures[c].userdata=c
		ball_fixtures[c].name=actorname
	
		ball_bodies[c]:resetMassData()		
		ball_fixtures[c]:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x03 )
		
		ball_sprites[c]:setParent ( ball_bodies[c] )
		
		layer:insertProp ( ball_sprites[c] )

		c=c+1
		print ("Added Actor")
end

function onLevelLoad ( task, responseCode )

	print ( "onFinish" )
	print ( responseCode )

	if ( task:getSize ()) then
		filecontents=( task:getString ())
		--print (filecontents)
		local file = io.open("level.lua", "w")
		file:write(filecontents)
		file:close()
		dofile ("level.lua")
	else
		print ( "nothing" )
	end
end



--Functions

function onCollide ( event, fixtureA, fixtureB, arbiter )

	if event == MOAIBox2DArbiter.BEGIN then	
		if fixtureA.userdata and fixtureB.userdata then
		print( fixtureA.userdata.." collided with " .. fixtureB.userdata)		
			
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

function drawHills(numberOfHills,pixelStep,hillOffsetY)
			hillStartX=-40
			--a starting y coordinate, around the vertical center of the stage
			hillStartY=-100
			-- defining hill width, in pixels, that is the stage width divided by the number of hills
			hillWidth=(screen_width*2/numberOfHills)
			-- defining the number of slices of the hill. This number is determined by the width of the hill in pixels divided by the amount of pixels between two points
			hillSlices=hillWidth/pixelStep
			hillSliceWidth=(hillWidth/pixelStep)+1

			-- looping through the hills
			for i=0,numberOfHills,1 do
				-- setting a random hill height in pixels
				randomHeight=math.random()*300+40
				-- this is necessary to make all hills (execept the first one) begin where the previous hill ended
				if(i~=0) then hillStartY=hillStartY-randomHeight end

				-- looping through hill slices
				for j=0,hillSlices,1 do
				
						bodytest = world:addBody ( MOAIBox2DBody.STATIC )
						-- defining the point of the hill
						x=j*pixelStep+hillWidth*i
						y=hillStartY+randomHeight*math.cos(2*math.pi/hillSlices*j)+hillOffsetY
	
						point4x=(j*pixelStep+hillWidth*i)/32+hillStartX
						point4y=-40
						
						point3x=(j*pixelStep+hillWidth*i)/32+hillStartX
						point3y=((hillStartY+randomHeight*math.cos(2*math.pi/hillSliceWidth*j))/32)+hillOffsetY
						
						
						point2x=((j+1)*pixelStep+hillWidth*i)/32+hillStartX
						point2y=(hillStartY+randomHeight*math.cos(2*math.pi/hillSliceWidth*(j+1)))/32+hillOffsetY
						
						point1x=((j+1)*pixelStep+hillWidth*i)/32+hillStartX
						point1y=-40
						
						print ("point1x="..point1x.." point1y="..point1y.." point2x="..point2x.." point2y="..point2y)
						print ("point3x="..point3x.." point3y="..point3y.." point4x="..point4x.." point4y="..point4y)
						t = { point1x,point1y,point2x,point2y,point3x,point3y,point4x,point4y }
						bodytest:addPolygon (t)	
				
						--add_actor(x,y,pixelStep/32,pixelStep/32,0.5,0.5,0.5,"Box","Static","images/cloud.png")						
				end
				-- this is also necessary to make all hills (execept the first one) begin where the previous hill ended
				hillStartY = hillStartY+randomHeight
			end
end

-- MENU --
print ("loading menu")

function pointerCallback_menu( x, y )	
	local oldX = mouseX
	local oldY = mouseY
	mouseX, mouseY = layer_menu:wndToWorld ( x, y )
end
		
function clickCallback_menu ( down )
	
	if down then	
	pick = partition_menu:propForPoint ( mouseX, mouseY )
		if pick then
			if pick.name=="Button1" then
				layer_menu:setViewport(nil)
				print ("Loading from internet")
				task = MOAIHttpTask.new ()
				task:setCallback ( onLevelLoad )
				task:httpGet ( "www.innovationtech.co.uk/moai/level1.lua" )
				start_game()
			end
			if pick.name=="Button2" then
				layer_menu:setViewport(nil)
				print ("Loading from internet")
				task = MOAIHttpTask.new ()
				task:setCallback ( onLevelLoad )
				task:httpGet ( "www.innovationtech.co.uk/moai/level2.lua" )
				start_game()
			end
		end
	end	
	if down==false then

	end
end

function setup_menu()
print ("setup menu")
layer_menu=MOAILayer2D.new()
MOAISim.pushRenderPass ( layer_menu )

partition_menu = MOAIPartition.new ()
layer_menu:setPartition ( partition_menu)

menubutton = MOAIGfxQuad2D.new ()
menubutton:setTexture ( "cathead.png" )
menubutton:setRect ( -4,-4,4,4 )
menubutton_prop = MOAIProp2D.new ()
menubutton_prop:setLoc(-8,0)
menubutton_prop:setDeck ( menubutton )
menubutton_prop.name = "Button1" 
partition_menu:insertProp ( menubutton_prop )

menubutton2 = MOAIGfxQuad2D.new ()
menubutton2:setTexture ( "cathead.png" )
menubutton2:setRect ( -4,-4,4,4 )
menubutton_prop2 = MOAIProp2D.new ()
menubutton_prop2:setLoc(8,0)
menubutton_prop2:setDeck ( menubutton )
menubutton_prop2.name = "Button2" 
partition_menu:insertProp ( menubutton_prop2 )

end

function menu()
print ("activating menu")
layer_menu:setViewport ( viewport )

if MOAIInputMgr.device.pointer then
	
	-- mouse input
	MOAIInputMgr.device.pointer:setCallback ( pointerCallback_menu )
	MOAIInputMgr.device.mouseLeft:setCallback ( clickCallback_menu )
else

	-- touch input
	MOAIInputMgr.device.touch:setCallback ( 
	
		function ( eventType, idx, x, y, tapCount )

			pointerCallback_menu ( x, y )
		
			if eventType == MOAITouchSensor.TOUCH_DOWN then
				clickCallback_menu ( true )
			elseif eventType == MOAITouchSensor.TOUCH_UP then
				clickCallback_menu ( false )
			end
		end
	)
end
end


-- alert menu

function alert_menu()
alert_layer = MOAILayer2D.new ()
MOAISim.pushRenderPass ( alert_layer )
alert_layer:setViewport ( viewport )

alert_partition = MOAIPartition.new ()
alert_layer:setPartition ( alert_partition )

addButton ( screen_width/8*-1,0, 1,1, "OK","ok.png")
addButton ( screen_width/8,0, 1,1, "Cancel","cancel.png" )

if MOAIInputMgr.device.pointer then
	
	-- mouse input
	MOAIInputMgr.device.pointer:setCallback ( pointerCallback_alert )
	MOAIInputMgr.device.mouseLeft:setCallback ( clickCallback_alert )
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
end

function alert_menu_close()
alert_layer:setViewport(nil)
input()
end

function addButton ( x, y, xScl, yScl, name, texture )
	local prop = MOAIProp2D.new ()
	gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( texture )
	gfxQuad:setRect ( screen_width/16*-1,screen_width/16*-1,screen_width/16,screen_width/16)
	prop:setDeck ( gfxQuad )
	prop:setPriority ( 5 )
	prop:setLoc ( x, y )
	prop:setScl ( xScl, yScl )
	prop.name = name
	alert_partition:insertProp ( prop )
end

function pointerCallback_alert( x, y )
	
	local oldX = mouseX
	local oldY = mouseY	
	mouseX, mouseY = alert_layer:wndToWorld ( x, y )

end
		
function clickCallback_alert ( down )
	
	if down then
		
		pick = alert_partition:propForPoint ( mouseX, mouseY )
		
		if pick then
			print ( pick.name )
			if pick.name=="Cancel" then alert_menu_close() end
		end
	else
		if pick then
			pick = nil
		end
	end
end

function input()
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
end

function start_game()
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
fitter:setBounds ( -100,-100,100,100 )
fitter:setMin ( 20 )
fitter:start ()
anchor = MOAICameraAnchor2D.new ()
anchor:setParent ( sprite )
anchor:setRect ( -1,-1,1,1 )
fitter:insertAnchor ( anchor )
input()
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

viewport:setScale ( 64, 0 )

-- set up the world and start its simulation
world = MOAIBox2DWorld.new ()
world:setGravity ( 0, -10 )
world:setUnitsToMeters ( 2 )
world:start ()

-- textures
texture = MOAIGfxQuad2D.new ()
texture:setTexture ( 'cathead.png' )
texture:setRect ( -1, -1, 1, 1)


particletexture = MOAIGfxQuad2D.new ()
particletexture:setTexture ( 'cathead.png' )
particletexture:setRect ( -0.8, -0.8, 0.8, 0.8)

-- layers
layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
layer:setBox2DWorld ( world )


-- MAIN GAMES BEGIN

setup_menu()
menu()





