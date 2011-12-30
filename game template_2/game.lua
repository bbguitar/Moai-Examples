print ("loading game")

-- GAME --
function setup_game()
-- clear game layers
layer:clear()
layer1:clear()
layer2:clear()

-- set up the world and start its simulation
world = MOAIBox2DWorld.new ()
world:setGravity ( 0, 0 )
world:setUnitsToMeters ( 2 )
world:start ()

-- layers
-- debug draw
layer:setBox2DWorld ( world )
layer:setCamera ( camera )

--background layer
gfxQuad1 = MOAIGfxQuad2D.new ()
gfxQuad1:setTexture ( "background.png" )
gfxQuad1:setRect(  -40,-40,40,40)

prop1 = MOAIProp2D.new ()
prop1:setDeck ( gfxQuad1 )
layer2:insertProp ( prop1 )

layer1:setParallax ( 0.5,0.5 )
gfxQuad2 = MOAIGfxQuad2D.new ()
gfxQuad2:setTexture ( "background2.png" )
gfxQuad2:setRect (  -30,-30,30,30)
prop2 = MOAIProp2D.new ()
prop2:setDeck ( gfxQuad2 )
layer1:insertProp ( prop2)

-- player
body = world:addBody ( MOAIBox2DBody.DYNAMIC )
body:setTransform(0,-4,0)
body:setFixedRotation(true)
--body:setAngularDamping(1)
body:setLinearDamping(0.5);
fixture = body:addCircle( 0,0,1 )
fixture:setDensity ( 1)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.5)
fixture:setFilter ( 0x01 )
fixture.userdata=-1
fixture.name="Player"
body:resetMassData()
fixture:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x01)

tileLib = MOAITileDeck2D.new ()
tileLib:setTexture ( "player.png" )
tileLib:setSize ( 2,2 )
tileLib:setRect ( -1,-1,1,1)

tileLib2 = MOAITileDeck2D.new ()
tileLib2:setTexture ( "meter.png" )
tileLib2:setSize ( 1,1 )
tileLib2:setRect ( -1,-1,1,1)

playerarrowprop = MOAIProp2D.new ()
playerarrowprop:setDeck ( tileLib2 )
playerarrowprop:setParent ( body )
playerarrowprop:setVisible(false)
playerarrowprop.name="PlayerArrow"
gamepartition:insertProp ( playerarrowprop )

playerprop = MOAIProp2D.new ()
playerprop.name="Player"
playerprop:setDeck ( tileLib )
playerprop:setParent ( body )
playerprop:setPriority(100)
gamepartition:insertProp ( playerprop )



curve = MOAIAnimCurve.new ()
curve:reserveKeys ( 9 )
curve:setKey ( 1, 0.00, 1, MOAIEaseType.FLAT )
curve:setKey ( 2, 3.00, 2, MOAIEaseType.FLAT )
curve:setKey ( 3, 3.50, 3, MOAIEaseType.FLAT ) -- blink
curve:setKey ( 4, 4.00, 4, MOAIEaseType.FLAT )
curve:setKey ( 5, 8.00, 4, MOAIEaseType.FLAT )
curve:setKey ( 6, 8.50, 3, MOAIEaseType.FLAT ) -- blink
curve:setKey ( 7, 9.00, 4, MOAIEaseType.FLAT )
curve:setKey ( 8, 9.50, 3, MOAIEaseType.FLAT ) -- blink
curve:setKey ( 9, 10.00, 4, MOAIEaseType.FLAT )

anim = MOAIAnim:new ()
anim:reserveLinks ( 1 )
anim:setLink ( 1, curve, playerprop, MOAIProp2D.ATTR_INDEX )
anim:setMode ( MOAITimer.LOOP )
anim:start ()

-- setup camera
camera = MOAITransform.new ()
layer:setCamera ( camera )

-- setup camera fitter / tracker
fitter = MOAICameraFitter2D.new ()
fitter:setViewport ( viewport )
fitter:setCamera ( camera )
fitter:setBounds ( -80,-80,80,80 )
fitter:setMin ( 20 )
fitter:start ()
anchor = MOAICameraAnchor2D.new ()
anchor:setParent ( playerprop )
anchor:setRect ( -1,-1,1,1 )
fitter:insertAnchor ( anchor )

end

function start_game()
loadLevel()

layer:setViewport(viewport)
layer1:setViewport(viewport)
layer2:setViewport(viewport)
layer_hud:setViewport(viewport)


layer_splash:setCamera ( camera )
layer_menu:setCamera ( camera )
layer:setCamera ( camera )
layer1:setCamera ( camera )
layer2:setCamera ( camera )
layer_hud:setCamera ( camera )

mainThread = MOAIThread.new ()
mainThread:run ( 

	function ()
		while not gameOver do
		coroutine.yield ()				
				text = '<c:7f3>'..score..'<c>'
				scorebox:setString ( text )
				scorebox:setFont ( font )
				scorebox:setTextSize ( 2)
				bx,by= body:getPosition()
				scorebox:setRect ( bx-4,by,bx+4,by-7.5)
				scorebox:setYFlip ( true )
				layer:insertProp ( scorebox )

		end

	end 
)

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

alert_menu()
end

function stop_game()

end

-- GAME & Callback Routines --

function onCollide ( event, fixtureA, fixtureB, arbiter )

	if event == MOAIBox2DArbiter.BEGIN then	

		if fixtureA.name and fixtureB.name then
		--print( fixtureA.userdata.." collided with " .. fixtureB.userdata)
			
			
			if fixtureA.name=="Circle" and fixtureB.name=="Player" and (fixtureB:getBody():getLinearVelocity()>5 or fixtureB:getBody():getLinearVelocity()<-5) then 
				
					layer:removeProp ( ball_sprites[fixtureA.userdata] )
					bx,by= fixtureA:getBody():getWorldCenter()
					particles(bx,by,particletexture)
					particles2(bx,by,particletexture4)
					popscore(bx,by,10)
					score=score+10	
					fixtureA:getBody():destroy()						
					destroyed=destroyed+1			
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
	hudX,hudY=layer_hud:wndToWorld ( x, y )
		
	bx,by= body:getPosition()
	
	pick = partition:propForPoint ( hudX,hudY )
	gamepick = gamepartition:propForPoint ( mouseX,mouseY )
	

	
	if playerpicked then

			mousex = pickX-mouseX
			mousey = pickY-mouseY
			angle = math.atan(mousey/mousex)/(math.pi/180)
		if (mousex<0) then
			angle =angle + 180;
		end
		if (mousex>=0 and mousey<0) then
			angle =angle + 360
		end

		angle=angle-90
		playerprop:seekRot(angle,0)
			scalex=math.sqrt(mousex*mousex+mousey*mousey)
			playerarrowprop:setVisible(true)
			playerarrowprop:seekScl ( scalex/2,0.2, 0)
			playerarrowprop:seekLoc ( (scalex/2)-2,-2, 0)

	end
	
end
		
function clickCallback ( down )
	
	if down then
	mousedown=true
	pick = partition:propForPoint ( hudX,hudY )
	--gamepick = gamepartition:propForPoint ( mouseX,mouseY )
	
		if gamepick then
			print (gamepick.name)
			if gamepick.name=="Player" then 
				playerpicked=true
				body:setLinearVelocity(0,0)
				pickX=mouseX
				pickY=mouseY
			end
		end

	end
	
	if down==false and playerpicked then
		playerpicked=false
		playerarrowprop:setVisible(false)
		mousedown=false
		bx,by= body:getPosition()
		
		forceX=bx-mouseX
		forceY=by-mouseY
		body:applyForce( forceX *10000, forceY *10000,bx,by)
		particles2(bx,by,particletexture)
		if soundon then sound:play ()	end
		--viewport:setRotation(angle)
	end

end

function make_walls()

wall_bodies[3] = world:addBody ( MOAIBox2DBody.STATIC )
wall_fixtures[3] = wall_bodies[3]:addRect ( -30,-50,-19,50) -- left
wall_fixtures[3]:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x00 )
wall_bodies[3]:resetMassData()	
wall_textures[3] = MOAIGfxQuad2D.new ()
wall_textures[3] :setTexture ( 'wall1.png' )
wall_textures[3] :setRect ( -50,-50,-19,50) -- left
wall_sprites[3]=MOAIProp2D.new ()
wall_sprites[3]:setParent ( wall_bodies[3] )
wall_sprites[3]:setDeck ( wall_textures[3] )
layer:insertProp ( wall_sprites[3])

wall_bodies[4] = world:addBody ( MOAIBox2DBody.STATIC )
wall_fixtures[4] = wall_bodies[4]:addRect ( 29,-50,40,50) -- right
wall_fixtures[4]:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x00 )
wall_bodies[4]:resetMassData()	
wall_textures[4] = MOAIGfxQuad2D.new ()
wall_textures[4] :setTexture ( 'wall1.png' )
wall_textures[4] :setRect ( 29,-50,50,50) -- right
wall_sprites[4]=MOAIProp2D.new ()
wall_sprites[4]:setParent ( wall_bodies[4] )
wall_sprites[4]:setDeck ( wall_textures[4] )
layer:insertProp ( wall_sprites[4])

wall_bodies[1] = world:addBody ( MOAIBox2DBody.STATIC )
wall_fixtures[1] = wall_bodies[1]:addRect (-30,50,30,29) --top
wall_fixtures[1]:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x00 )
wall_bodies[1]:resetMassData()	
wall_textures[1] = MOAIGfxQuad2D.new ()
wall_textures[1] :setTexture ( 'wall1.png' )
wall_textures[1] :setRect ( -30,50,30,29) --top
wall_sprites[1]=MOAIProp2D.new ()
wall_sprites[1]:setParent ( wall_bodies[1] )
wall_sprites[1]:setDeck ( wall_textures[1] )
layer:insertProp ( wall_sprites[1])

wall_bodies[2] = world:addBody ( MOAIBox2DBody.STATIC )
wall_fixtures[2] = wall_bodies[2]:addRect (-30,-50,30,-19) -- bottom
wall_fixtures[2]:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x00 )
wall_bodies[2]:resetMassData()	
wall_textures[2] = MOAIGfxQuad2D.new ()
wall_textures[2] :setTexture ( 'ground.png' )
wall_textures[2] :setRect (-40,-50,50,-19) -- bottom
wall_sprites[2]=MOAIProp2D.new ()
wall_sprites[2]:setParent ( wall_bodies[2] )
wall_sprites[2]:setDeck ( wall_textures[2] )
layer:insertProp ( wall_sprites[2])


end


function popscore(x,y,points)
				score=score+points
				text = ""..points
				popscorebox[popscorebox_counter]:setString ( text )
				popscorebox[popscorebox_counter]:setFont ( font )
				popscorebox[popscorebox_counter]:setTextSize ( 3)
				bx,by= body:getPosition()
				popscorebox[popscorebox_counter]:setRect ( bx,by+7,bx+8,by)
				
				popscorebox[popscorebox_counter]:setYFlip ( true )
				popscorebox[popscorebox_counter]:seekColor (  1, 1, 1, 1, 0)
				popscorebox[popscorebox_counter]:seekColor ( 0, 0, 0, 0, 4 )
				--popscorebox[popscorebox_counter]:seekScl ( 2,2, 3)
				
				layer:insertProp ( popscorebox[popscorebox_counter] )
				popscorebox_counter=popscorebox_counter+1
				if popscorebox_counter>4 then popscorebox_counter=0 end

end

function particles(pX,pY,pTexture)

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
			system:setDeck ( pTexture )
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
			render:ease			    ( MOAIParticleScript.SPRITE_OPACITY, CONST ( 1), CONST ( 0.6),MOAIEaseType.EASE_IN)
			render:rand			    ( MOAIParticleScript.SPRITE_ROT, CONST ( -180), CONST ( 180))
	
			state1:setInitScript ( init )
			state1:setRenderScript ( render )
			system:setState ( 1, state1 )
		
			system:surge (16,pX,pY,pX,pY)
end

function particles2(pX,pY,pTexture)

			CONST = MOAIParticleScript.packConst

			local PARTICLE_X1 = MOAIParticleScript.packReg ( 1 )
			local PARTICLE_Y1 = MOAIParticleScript.packReg ( 2 )
			local PARTICLE_R0 = MOAIParticleScript.packReg ( 3 )
			local PARTICLE_R1 = MOAIParticleScript.packReg ( 4 )
			local PARTICLE_S0 = MOAIParticleScript.packReg ( 5 )
			local PARTICLE_S1 = MOAIParticleScript.packReg ( 6 )

			system2 = MOAIParticleSystem.new ()
			system2:reserveParticles ( 256, 2 )
			system2:reserveSprites ( 256 )
			system2:reserveStates ( 1 )
			system2:setDeck ( pTexture )
			system2:start ()

			emitter2 = MOAIParticleDistanceEmitter.new ()
			emitter2:setLoc ( 0, 0 )
			emitter2:setSystem ( system2 )
			emitter2:setMagnitude ( 0.125 )
			emitter2:setAngle ( 260, 280 )
			emitter2:setDistance ( 4 )
			emitter2:start ()

			state1 = MOAIParticleState.new ()
			state1:setTerm ( 0, 1.25 )
			layer:insertProp ( system2 )

			local init = MOAIParticleScript.new ()
			init:rand		( PARTICLE_X1, CONST ( pX+2), CONST ( pX-2))
			init:rand		( PARTICLE_Y1, CONST ( pY+2), CONST ( pY-2))
			init:rand		( PARTICLE_S0, CONST ( pX), CONST ( pX))
			init:rand		( PARTICLE_S1, CONST ( pY), CONST ( pY))
			local render = MOAIParticleScript.new ()
			render:ease		( MOAIParticleScript.PARTICLE_X, MOAIParticleScript.PARTICLE_DX, PARTICLE_X1, MOAIEaseType.LINEAR )
			render:ease		( MOAIParticleScript.PARTICLE_Y, MOAIParticleScript.PARTICLE_DY, PARTICLE_Y1, MOAIEaseType.LINEAR )

			render:sprite			()
			render:ease			    ( MOAIParticleScript.SPRITE_X_SCL, CONST ( 0.1 ), CONST ( 1),MOAIEaseType.EASE_IN)
			--render:rand			    ( MOAIParticleScript.SPRITE_X_SCL, CONST ( 0), CONST ( 0.5))
			--render:rand			    ( MOAIParticleScript.SPRITE_Y_SCL, CONST ( 0), CONST ( 1))
			render:ease			    ( MOAIParticleScript.SPRITE_Y_SCL, CONST ( 0.1), CONST ( 1),MOAIEaseType.EASE_IN)
			render:ease			    ( MOAIParticleScript.SPRITE_OPACITY, CONST ( 1), CONST ( 0.6),MOAIEaseType.EASE_IN)
			render:rand			    ( MOAIParticleScript.SPRITE_ROT, CONST ( -180), CONST ( 180))
	
			state1:setInitScript ( init )
			state1:setRenderScript ( render )
			system2:setState ( 1, state1 )
		
			system2:surge (16,pX,pY,pX,pY)
end

function process_xml( var, name )

  if not name then name = "anonymous" end
  if "table" ~= type( var ) then
  
	print ("Processing xml!"..name)
	if string.find(name, "x1") then
	actors[counter]["x1"]=tostring(var)
	end
	if string.find(name, "y1") then
	actors[counter]["y1"]=tostring(var)
	end
		if string.find(name, "width") then
	actors[counter]["width"]=tostring(var)
	end
		if string.find(name, "height") then
	actors[counter]["height"]=tostring(var)
	end
		if string.find(name, "density") then
	actors[counter]["density"]=tostring(var)
	end
		if string.find(name, "friction") then
	actors[counter]["friction"]=tostring(var)
	end
		if string.find(name, "restitution") then
	actors[counter]["restitution"]=tostring(var)
	end
	if string.find(name, "actorname") then
	actors[counter]["actorname"]=tostring(var)
	end
	if string.find(name, "bodytype") then
	actors[counter]["bodytype"]=tostring(var)
	end
	if string.find(name, "image") then
	actors[counter]["image"]=tostring(var)
	end
  else
    -- for tables, recurse through children
    for k,v in pairs( var ) do
      local child
      if 1 == string.find( k, "%a[%w_]*" ) then
        -- key can be accessed using dot syntax
        child = name .. '.' .. k
      else
        -- key contains special characters
        child = name .. '["' .. k .. '"]'
			counter=counter+1
			actors[counter]={x1="",y1="",width="",height="",density="",friction="",restitution="",actorname="",bodytype=""}
			
			if counter>1 then
			node=counter-1
			if actors[node]["actorname"]=="Bridge" then 
				add_bridge(actors[node]["x1"],actors[node]["y1"],actors[node]["width"],actors[node]["height"],10)
			end
			if actors[node]["actorname"]=="Rope" then 
				add_rope(actors[node]["x1"],actors[node]["y1"],actors[node]["width"],actors[node]["height"],10)
			end
			if actors[node]["actorname"]=="Triangle" or actors[node]["actorname"]=="Circle" or actors[node]["actorname"]=="Box" then
				add_actor(actors[node]["x1"],actors[node]["y1"],actors[node]["width"],actors[node]["height"],actors[node]["density"],actors[node]["friction"],actors[node]["restitution"],actors[node]["actorname"],actors[node]["bodytype"],actors[node]["image"])
			end
			end
      end
      process_xml( v, child )
    end
  end
end
function print_r (t, indent)
  local indent=indent or ''
  for key,value in pairs(t) do
    io.write(indent,'[',tostring(key),']') 
    if type(value)=="table" then io.write(':\n') print_r(value,indent..'\t')
    else io.write(' = ',tostring(value),'\n') end
  end
end
function loadLevel()
c=0
counter=0
--xml = MOAIXmlParser.parseFile ( "level1.xml" )
--loadxml = assert(loadfile("level1.xml"))

function onFinish ( task, responseCode )

	if ( task:getSize ()) then
		xmlcontent= ( task:getString ())
		
		print (xmlcontent)
		
		
				text = "LOADED XML"
				popscorebox[popscorebox_counter]:setString ( text )
				popscorebox[popscorebox_counter]:setFont ( font )
				popscorebox[popscorebox_counter]:setTextSize ( 3)
				bx,by= body:getPosition()
				popscorebox[popscorebox_counter]:setRect ( bx,by+7,bx+8,by)

		
		
		xml=MOAIXmlParser.parseString(xmlcontent)
		actors = {}
		process_xml(xml)
	else
		print ( "nothing" )
	end
end

task = MOAIHttpTask.new ()

task:setCallback ( onFinish )
task:httpGet ( "http://www.innovationtech.co.uk/moai/level1.xml" )

--make_walls()
end

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