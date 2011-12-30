-- INITIALISATION --
function init()
--initiliase variables
ball_fixtures = {}
ball_bodies = {}
ball_sprites = {}
wall_fixtures = {}
wall_bodies = {}
wall_sprites = {}
wall_textures = {}
destroyed=0
c=0
score=0
mouseX=0
mouseY=0
screen_width,screen_height=MOAIEnvironment.getScreenSize()
if screen_width==0 then screen_width=800 end
if screen_height==0 then screen_height=480 end
end

function graphics()
-- setup graphics
MOAISim.openWindow ( "test", screen_width, screen_height )
viewport = MOAIViewport.new ()
viewport:setSize ( screen_width, screen_height )
viewport:setScale ( screen_width, screen_height )
-- setup all layers
layer_splash = MOAILayer2D.new ()
layer_menu=MOAILayer2D.new()
layer= MOAILayer2D.new ()
layer1= MOAILayer2D.new ()
layer2= MOAILayer2D.new ()
layer_hud= MOAILayer2D.new ()

layer_splash:setCamera ( camera )
layer_menu:setCamera ( camera )
layer:setCamera ( camera )
layer1:setCamera ( camera )
layer2:setCamera ( camera )
layer_hud:setCamera ( camera )

MOAISim.pushRenderPass ( layer2 )
MOAISim.pushRenderPass ( layer1 )
MOAISim.pushRenderPass ( layer )
MOAISim.pushRenderPass ( layer_menu )
MOAISim.pushRenderPass ( layer_hud )
MOAISim.pushRenderPass ( layer_splash )


end

-- SPLASH --
function splash()
--layer_splash = MOAILayer2D.new ()
--MOAISim.pushRenderPass ( layer_splash )

layer_splash:setViewport ( viewport )

partition = MOAIPartition.new ()
layer_splash:setPartition ( partition )

logoGfx = MOAIGfxQuad2D.new ()
logoGfx:setTexture ( "splash.png" )
logoGfx:setRect ( screen_width/2*-1, screen_height/2*-1, screen_width/2, screen_height/2)

logo = MOAIProp2D.new ()
logo:setDeck ( logoGfx )
layer_splash:insertProp ( logo )
logo:seekColor ( 0, 0, 0, 0, 0 )
fadeinAction = logo:seekColor ( 1, 1, 1, 1, 5)
callWithDelay ( 5, fadeoutSplash)
end

function callWithDelay ( delay, func,...)

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

function fadeoutSplash()
fadeoutAction = logo:seekColor ( 0,0,0,0, 5 )
setup_menu()
menu()
end

-- MENU --
function setup_menu()

partition_menu = MOAIPartition.new ()
layer_menu:setPartition ( partition_menu)

gfxQuad = MOAIGfxQuad2D.new ()
gfxQuad:setTexture ( "button1.png" )
gfxQuad:setRect ( -64, -64, 64, 64 )
local prop = MOAIProp2D.new ()
prop:setDeck ( gfxQuad )
prop.name = "Button1" 
partition_menu:insertProp ( prop )

end

function menu()

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

-- GAME --
function setup_game()

layer:clear()
layer1:clear()
layer2:clear()

-- set up the world and start its simulation
world = MOAIBox2DWorld.new ()
world:setGravity ( 0, -10 )
world:setUnitsToMeters ( 2 )
world:start ()

-- layers
-- debug draw
--layer = MOAILayer2D.new ()
layer:setBox2DWorld ( world )
layer:setCamera ( camera )

--background layer
layer2:setParallax ( 0.5, 0.5 )
gfxQuad = MOAIGfxQuad2D.new ()
gfxQuad:setTexture ( "background.png" )
gfxQuad:setRect ( -320,-320,320,320)
prop = MOAIProp2D.new ()
prop:setDeck ( gfxQuad )
prop:setScl ( 1,1)
layer2:insertProp ( prop )

layer1:setParallax ( 1,1 )
gfxQuad = MOAIGfxQuad2D.new ()
gfxQuad:setTexture ( "background2.png" )
gfxQuad:setRect ( -320,-320,320,320)
prop = MOAIProp2D.new ()
prop:setDeck ( gfxQuad )
prop:setScl ( 2.5,3 )
layer1:insertProp ( prop )

layer_hud:setParallax ( 1,1 )
hudQuad = MOAIGfxQuad2D.new ()
hudQuad:setTexture ( "button2.png" )
hudQuad:setRect ( screen_width/2*-1,screen_height/2*-1,(screen_width/2*-1)+64,(screen_height/2*-1)+64)
hudbutton = MOAIProp2D.new ()
hudbutton:setDeck ( hudQuad )
hudbutton.name="Button2"
layer2:insertProp ( hudbutton )

partition = MOAIPartition.new ()
layer_hud:setPartition ( partition )
partition:insertProp ( hudbutton )


-- textures
texture = MOAIGfxQuad2D.new ()
texture:setTexture ( 'ball1.png' )
texture:setRect ( -1, -1, 1, 1)

texture2 = MOAIGfxQuad2D.new ()
texture2:setTexture ( 'ball2.png' )
texture2:setRect ( -0.6,-0.6,0.6,0.6)

texture3 = MOAIGfxQuad2D.new ()
texture3:setTexture ( 'ball3.png' )
texture3:setRect ( -1,-1,1,1)

texture5 = MOAIGfxQuad2D.new ()
texture5:setTexture ( 'ball4.png' )
texture5:setRect ( -1, -1, 1, 1)

texture4 = MOAIGfxQuad2D.new ()
texture4:setTexture ( 'chain.png' )
texture4:setRect ( -0.5, -1, 0.5, 1)

particletexture = MOAIGfxQuad2D.new ()
particletexture:setTexture ( 'particle.png' )
particletexture:setRect ( -0.8, -0.8, 0.8, 0.8)

particletexture2 = MOAIGfxQuad2D.new ()
particletexture2:setTexture ( 'particle2.png' )
particletexture2:setRect ( -0.8, -0.8, 0.8, 0.8)

particletexture3= MOAIGfxQuad2D.new ()
particletexture3:setTexture ( 'particle3.png' )
particletexture3:setRect ( -0.8, -0.8, 0.8, 0.8)

particletexture4= MOAIGfxQuad2D.new ()
particletexture4:setTexture ( 'particle4.png' )
particletexture4:setRect ( -1,-1,1,1)

gfxQuad = MOAIGfxQuad2D.new ()
gfxQuad:setTexture ( "ball2.png" )
gfxQuad:setRect ( -64, -64, 64, 64 )

-- Text boxes
charcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-'

font = MOAIFont.new ()
font:loadFromTTF ( 'arial-rounded.TTF', charcodes, 24, 163 )
scorebox = MOAITextBox.new ()
popscorebox = {}
popscorebox_counter=0
popscorebox[0] = MOAITextBox.new ()
popscorebox[1] = MOAITextBox.new ()
popscorebox[2] = MOAITextBox.new ()
popscorebox[3] = MOAITextBox.new ()
popscorebox[4] = MOAITextBox.new ()
popscorebox[5] = MOAITextBox.new ()


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

tileLib = MOAITileDeck2D.new ()
tileLib:setTexture ( "ball1.png" )
tileLib:setSize ( 2,2 )
tileLib:setRect ( -1,-1,1,1)

playerprop = MOAIProp2D.new ()
playerprop:setDeck ( tileLib )
playerprop:setParent ( body )
layer:insertProp ( playerprop )

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
fitter:setBounds ( -50,-50,50,50 )
fitter:setMin ( 20 )
fitter:start ()
anchor = MOAICameraAnchor2D.new ()
anchor:setParent ( playerprop )
anchor:setRect ( -1,-1,1,1 )
fitter:insertAnchor ( anchor )end

function start_game()


make_walls()
add_rope(-10,30,25)
add_rope(0,30,10)
add_rope(10,30,20)
add_rope(20,30,25)
emitBox()

layer:setViewport(viewport)
layer1:setViewport(viewport)
layer2:setViewport(viewport)
layer_hud:setViewport(viewport)



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



end

function stop_game()

end

-- GAME & Callback Routines --

function onCollide ( event, fixtureA, fixtureB, arbiter )

	if event == MOAIBox2DArbiter.BEGIN then	
		if fixtureA.userdata and fixtureB.userdata then
		--print( fixtureA.userdata.." collided with " .. fixtureB.userdata)		
			
			if fixtureA.userdata>0 and fixtureB.userdata==-1 then
				if ball_sprites[fixtureA.userdata] and (fixtureB:getBody():getLinearVelocity()>5 or fixtureB:getBody():getLinearVelocity()<-5) then 
				
					layer:removeProp ( ball_sprites[fixtureA.userdata] )
					bx,by= fixtureA:getBody():getWorldCenter()
					
					if fixtureA.userdata<=50 then
						particles(bx,by,particletexture)
						particles2(bx,by,particletexture4)
						--popscore(bx,by,10)
						score=score+10
					end
					if fixtureA.userdata>50 and fixtureA.userdata<=70 then
						particles(bx,by,particletexture2)
						particles2(bx,by,particletexture4)
						popscore(bx,by,50)
					end
					if fixtureA.userdata>70 then
						particles(bx,by,particletexture3)
						particles2(bx,by,particletexture4)
						popscore(bx,by,100)
					end
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
	hudX,hudY=layer_hud:wndToWorld ( x, y )
		
	bx,by= body:getPosition()
	mouseX=mouseX-bx;
	mouseY=mouseY-by;
	

	if pick then
		pick:addLoc ( mouseX - oldX, mouseY - oldY )
	end
end
		
function clickCallback ( down )
	
	if down then
	
	pick = partition:propForPoint ( hudX,hudY )
	
		if pick then print (pick.name) 
			if pick.name=="Button2" then
			world:stop ()
			stop_game()
			layer:setViewport(nil)
			layer1:setViewport(nil)
			layer2:setViewport(nil)
			layer_hud:setViewport(nil)
			layer_menu:setViewport(viewport)
			menu()
			end
		end
		body:setLinearVelocity(0,0)
	end
	
	if down==false then
		bx,by= body:getPosition()
		body:applyForce( mouseX *5000, mouseY *5000,bx,by)
	end

end

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
			setup_game()
			start_game()
		end
		end
	end	
	if down==false then

	end
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
				--popscorebox[popscorebox_counter]:seekScl ( 1,1, 0)
				popscorebox[popscorebox_counter]:seekColor ( 0, 0, 0, 0, 4 )
				--popscorebox[popscorebox_counter]:seekScl ( 1.2, 1.2, 2)
				
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
			--render:rand			    ( MOAIParticleScript.SPRITE_ROT, CONST ( -180), CONST ( 180))
	
			state1:setInitScript ( init )
			state1:setRenderScript ( render )
			system2:setState ( 1, state1 )
		
			system2:surge (16,pX,pY,pX,pY)
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
			ball_fixtures[c] = ball_bodies[c]:addCircle ( 0,0,0.5)
			ball_sprites[c]:setDeck ( texture2 )
			ball_fixtures[c]:setDensity ( 0.2 )
		end
		if x>5 and x<=7 then
			ball_fixtures[c] = ball_bodies[c]:addRect ( -1,-1,1,1)			
			ball_sprites[c]:setDeck ( texture3 )
			ball_fixtures[c]:setDensity ( 0.02 )
		end
		
		if x>7 then
			--ball_fixtures[c] = ball_bodies[c]:addRect ( -1,-1,1,1)
			t = { 1,-1,0,1,-1,-1 }
			ball_fixtures[c] = ball_bodies[c]:addPolygon (t)
			
			ball_sprites[c]:setDeck ( texture5 )
			ball_fixtures[c]:setDensity ( 0.4 )
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

function add_rope(baseX,baseY,length)
ropes = {}
rope_sprites = {}

ropes[0] = world:addBody ( MOAIBox2DBody.DYNAMIC )

bx,by= ropes[0] :getPosition()
ropes[0]:setTransform(baseX,baseY,0)
fixture = ropes[0] :addRect( -0.25,-1,0.25,1 )
fixture:setDensity ( 1)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.25)
fixture:setFilter ( 0x01 )
fixture.userdata=2
world:addRevoluteJoint ( ropes[0] , wall_bodies[1],baseX,baseY)
ropes[0] :resetMassData()

for y = 1, length do
ropes[y] = world:addBody ( MOAIBox2DBody.DYNAMIC )

fixture = ropes[y]:addRect( -0.25,-1,0.25,1 )
ropes[y]:setTransform(baseX,baseY+(y*-2),0)
bx,by= ropes[y]:getPosition()
fixture:setDensity ( 1)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.25)
fixture:setFilter ( 0x01 )
fixture.userdata=2
world:addRevoluteJoint ( ropes[y], ropes[y-1],baseX,baseY+1-y*2)
ropes[y]:resetMassData()
rope_sprites[y]=MOAIProp2D.new ()
rope_sprites[y]:setParent ( ropes[y] )
rope_sprites[y]:setDeck ( texture4 )
layer:insertProp ( rope_sprites[y] )

end
end

-- main routines
init()
graphics()
splash()
