-- INITIALISATION --
function init()
--initiliase variables
ball_fixtures = {}
ball_bodies = {}
ball_joints = {}
ball_sprites = {}
wall_fixtures = {}
wall_bodies = {}
wall_sprites = {}
wall_textures = {}
previous_X={}
previous_Y={}
mousedown=false
gamewidth=60
gameheight=60
destroyed=0
c=0
eventcount=1
camerax_target=0
cameray_target=0
mode=0
score=0
downX=0
downY=0
moveX=0
moveY=0
upX=0
upY=0
mouseX=0
mouseY=0
xDown=0
yDown=0
lastX=0
lastY=0
start_width=0
start_height=0
x=0
y=0
pinching=false
pointer1x=0
pointer2x=0
pointer1y=0
pointer2y=0



timerDown=0
trackplayer=false
screen_width,screen_height=MOAIEnvironment.getScreenSize()
if screen_width==0 then screen_width=800 end
if screen_height==0 then screen_height=480 end
--MOAIUntzSystem.initialize ()
--sound = MOAIUntzSound.new ()
--sound:load ( 'pop.wav' )
--sound:setVolume ( 1 )
--sound:setLooping ( false )
print "Init complete"
end

function graphics()
-- setup graphics
--MOAISim.openWindow ( "test", screen_width, screen_height )
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

print "graphics complete"
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
fadeinAction = logo:seekColor ( 1, 1, 1, 1, 0)
callWithDelay ( 1, fadeoutSplash)
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
fadeoutAction = logo:seekColor ( 0,0,0,0, 0 )
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
c=0
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
gamepartition = MOAIPartition.new ()
layer:setPartition ( gamepartition )

--layer_hud:setParallax ( 1,1 )
hudQuad = MOAIGfxQuad2D.new ()
hudQuad:setTexture ( "button1.png" )
hudQuad:setRect (-64,-196,0,-128)
hudbutton1 = MOAIProp2D.new ()
hudbutton1:setDeck ( hudQuad )
hudbutton1.name="Button1"
layer_hud:insertProp ( hudbutton1 )

hudQuad = MOAIGfxQuad2D.new ()
hudQuad:setTexture ( "button2.png" )
hudQuad:setRect (0,-196,64,-128)
hudbutton2 = MOAIProp2D.new ()
hudbutton2:setDeck ( hudQuad )
hudbutton2.name="Button2"
layer_hud:insertProp ( hudbutton2 )

hudQuad = MOAIGfxQuad2D.new ()
hudQuad:setTexture ( "button3.png" )
hudQuad:setRect (64,-196,128,-128)
hudbutton3 = MOAIProp2D.new ()
hudbutton3:setDeck ( hudQuad )
hudbutton3.name="Button3"
layer_hud:insertProp ( hudbutton3 )

hudQuad = MOAIGfxQuad2D.new ()
hudQuad:setTexture ( "button4.png" )
hudQuad:setRect (128,-196,196,-128)
hudbutton4 = MOAIProp2D.new ()
hudbutton4:setDeck ( hudQuad )
hudbutton4.name="Button4"
layer_hud:insertProp ( hudbutton4 )

partition = MOAIPartition.new ()
layer_hud:setPartition ( partition )
partition:insertProp ( hudbutton1 )
partition:insertProp ( hudbutton2 )
partition:insertProp ( hudbutton3 )
partition:insertProp ( hudbutton4 )

--background layer
gfxQuad1 = MOAIGfxQuad2D.new ()
gfxQuad1:setTexture ( "background.png" )
gfxQuad1:setRect ( -120,-120,120,120)
prop2 = MOAIProp2D.new ()
prop2:setDeck ( gfxQuad1 )
layer2:insertProp ( prop2 )

layer1:setParallax ( 0.25,0.25 )
gfxQuad2 = MOAIGfxQuad2D.new ()
gfxQuad2:setTexture ( "background2.png" )
gfxQuad2:setRect ( -20,-20,20,20)
prop1 = MOAIProp2D.new ()
prop1:setDeck ( gfxQuad2 )
--layer1:insertProp ( prop1)

-- textures
texture = MOAIGfxQuad2D.new ()
texture:setTexture ( 'ball1.png' )
texture:setRect ( -1, -1, 1, 1)

texture2 = MOAIGfxQuad2D.new ()
texture2:setTexture ( 'ball2.png' )
texture2:setRect ( -1,-1,1,1)

texture3 = MOAIGfxQuad2D.new ()
texture3:setTexture ( 'ball3.png' )
texture3:setRect ( -1,-1,1,1)

texture5 = MOAIGfxQuad2D.new ()
texture5:setTexture ( 'ball4.png' )
texture5:setRect ( -1, -1, 1, 1)

texture4 = MOAIGfxQuad2D.new ()
texture4:setTexture ( 'chain.png' )
texture4:setRect ( -1, -1, 1, 1)

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
font:loadFromTTF ( 'arial.TTF', charcodes, 24, 163 )
scorebox = MOAITextBox.new ()
popscorebox = {}
popscorebox_counter=0
popscorebox[0] = MOAITextBox.new ()
popscorebox[1] = MOAITextBox.new ()
popscorebox[2] = MOAITextBox.new ()
popscorebox[3] = MOAITextBox.new ()
popscorebox[4] = MOAITextBox.new ()
popscorebox[5] = MOAITextBox.new ()

-- setup camera
camera = MOAITransform.new ()
camera2 = MOAITransform.new ()
layer:setCamera ( camera )

print "Setup Game Complete"
end

function add_player()

-- player
body = world:addBody ( MOAIBox2DBody.DYNAMIC )
body:setTransform(0,-4,0)
--body:setFixedRotation(true)
body:setAngularDamping(1)
body:setLinearDamping(0.1);
fixture = body:addCircle( 0,0,2 )
fixture:setDensity ( 0.5)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.5)
fixture:setFilter ( 0x01 )
fixture.userdata=-1
fixture.name="Player"
body:resetMassData()
fixture:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x01)

tileLib = MOAITileDeck2D.new ()
tileLib:setTexture ( "ball1.png" )
tileLib:setSize ( 2,2 )
tileLib:setRect ( -1,-1,1,1)

tileLib2 = MOAITileDeck2D.new ()
tileLib2:setTexture ( "meter.png" )
tileLib2:setSize ( 1,1 )
tileLib2:setRect ( -1,-1,1,1)

playerimage = MOAIGfxQuad2D.new ()
playerimage:setRect ( -2,-2,2,2)
playerimage:setTexture ( 'ball1.png' )
		
playerprop = MOAIProp2D.new ()
playerprop.name="Player"
--playerprop:setDeck ( tileLib )
playerprop:setDeck ( playerimage )
playerprop:setParent ( body )
gamepartition:insertProp ( playerprop )

playerarrowprop = MOAIProp2D.new ()
playerarrowprop:setDeck ( tileLib2 )
--playerarrowprop:setParent ( body )
playerarrowprop:setVisible(false)
gamepartition:insertProp ( playerarrowprop )

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
end

function start_game()
loadLevel()
add_player()

-- setup camera fitter / tracker
fitter = MOAICameraFitter2D.new ()
fitter:setViewport ( viewport )
fitter:setCamera ( camera )
fitter:setBounds ( -200,-200,200,200 )
fitter:setMin ( 20 )
--fitter:start ()
anchor = MOAICameraAnchor2D.new ()
anchor:setParent ( playerprop )
anchor:setRect ( -1,-1,1,1 )
fitter:insertAnchor ( anchor )

layer_splash:setCamera ( camera )
layer_menu:setCamera ( camera )
layer:setCamera ( camera )
layer1:setCamera ( camera )
layer2:setCamera ( camera )
layer_hud:setCamera ( camera2 )

layer:setViewport(viewport)
layer1:setViewport(viewport)
layer2:setViewport(viewport)
layer_hud:setViewport(viewport)



mainThread = MOAIThread.new ()
mainThread:run ( 

	function ()
		while not gameOver do
		coroutine.yield ()		
				timerDown=timerDown+1
				text = '<c:7f3>'..score..'<c>'
				scorebox:setString ( text )
				scorebox:setFont ( font )
				scorebox:setTextSize ( 2)
				bx,by= body:getPosition()
				if trackplayer==true then camera:setLoc(bx,by) end
				cx,cy=camera:getLoc()
				if trackplayer~=true then
					camera:setLoc(cx+camerax_target,cy+cameray_target)
				end
				bx,by=camera:getLoc()
				scorebox:setRect ( bx-4,by,bx+4,by-7.5)
				scorebox:setYFlip ( true )
				layer:insertProp ( scorebox )
				--hudbutton1:setLoc(bx-64,by-128)
				--hudbutton2:setLoc(bx,by-128)
				--hudbutton3:setLoc(bx+64,by-128)
				--hudbutton4:setLoc(bx+128,by-128)

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
			
					
		-- pinchzoom
			if pinching then
				if idx==0 then 
				pointer1x=x 
				pointer1y=y
				end
				if idx==1 then
				pointer2x=x
				pointer2y=y
				end
				
				if pinchstart and idx==1 then
				print ("pointer2x="..pointer2x.." pointer1x="..pointer1x)
				
				start_width=pointer2x-pointer1x
				start_height=pointer2y-pointer1y
				
				start_distance=math.sqrt(start_width*start_width+start_height*start_height)
				print ("Set start_distance to "..start_distance)
				pinchstart=false
				end
			
			if pinchstart==false then
					width=pointer2x-pointer1x
					height=pointer2y-pointer1y
					distance=math.sqrt(width*width+height*height)
					diffX=distance-start_distance
					diffX=diffX/1000
			
				--print ("Distance="..diffX)
				
				setxScl=old_xScl-diffX
				if setxScl<0.01 then setxScl=0.01 end
				if setxScl>0.5 then setxScl=0.5 end
				--print ("Xscale="..setxScl)
				camera:setScl(setxScl,setxScl)
			
			end
				
			end
		
			if idx==0 and eventType == MOAITouchSensor.TOUCH_DOWN then
			print(" 1st finger down ")
			if pinching~=true then
				pointerCallback ( x, y )
				clickCallback ( true )
			end
			end
			
			if idx==0 and eventType == MOAITouchSensor.TOUCH_UP then
			print(" 1st finger up ")
			if pinching~=true then
				pointerCallback ( x, y )
				clickCallback ( false )
			end
			end
			
			if idx==0 and eventType == MOAITouchSensor.TOUCH_MOVE then
			print(" 1st finger moving ")
			if pinching~=true then
				pointerCallback ( x, y )
			end
			end
			
			if idx==1 and eventType == MOAITouchSensor.TOUCH_DOWN then
			print("  2nd finger down ")
			pinchstart=true
			pinching=true
			end
			
			if idx==1 and eventType == MOAITouchSensor.TOUCH_MOVE then
			print(" 2nd finger moving ")
			end
			
			if idx==1 and eventType == MOAITouchSensor.TOUCH_UP then
			print(" 2nd finger up ")
			pinching=false
			end		
	end
	)
end

print "Start Game Complete"
end

function stop_game()

end

-- GAME & Callback Routines --

function onCollide ( event, fixtureA, fixtureB, arbiter )

	if event == MOAIBox2DArbiter.BEGIN then	

		if fixtureA.name and fixtureB.name then
		--print( fixtureA.userdata.." collided with " .. fixtureB.userdata)
			
			
			if fixtureA.name=="Circle" and fixtureB.name=="Player" then 
					
					fixtureA.health=fixtureA.health-math.abs(fixtureB:getBody():getLinearVelocity())
					
					print ("Health="..fixtureA.health)
					
					if fixtureA.health<0 then
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
			
			if fixtureB.name=="Circle" and fixtureA.name=="Player" then 
					
					fixtureB.health=fixtureB.health-math.abs(fixtureA:getBody():getLinearVelocity())
					
					print ("Health="..fixtureB.health)
					
					if fixtureB.health<0 then
						layer:removeProp ( ball_sprites[fixtureB.userdata] )
						bx,by= fixtureB:getBody():getWorldCenter()
						particles(bx,by,particletexture)
						particles2(bx,by,particletexture4)
						popscore(bx,by,10)
						score=score+10	
						fixtureB:getBody():destroy()						
						destroyed=destroyed+1	
					end
			end
		
		if fixtureB.name=="Complex" and math.abs(fixtureA:getBody():getLinearVelocity())>5 then 
				
					bx,by= fixtureB:getBody():getWorldCenter()
					particles(bx,by,particletexture)
					particles2(bx,by,particletexture4)
					popscore(bx,by,100)
					score=score+100	
					--fixtureA:getBody():destroy()						
					--destroyed=destroyed+1	
					ball_joints[fixtureB.userdata]:destroy()
			end
			
		if fixtureA.name=="Complex" and math.abs(fixtureB:getBody():getLinearVelocity())>5 then 
				
					bx,by= fixtureA:getBody():getWorldCenter()
					particles(bx,by,particletexture)
					particles2(bx,by,particletexture4)
					popscore(bx,by,100)
					score=score+100	
					--fixtureA:getBody():destroy()						
					--destroyed=destroyed+1	
					ball_joints[fixtureA.userdata]:destroy()
			end
				
			
		
		if fixtureB.name=="Welded" and math.abs(fixtureA:getBody():getLinearVelocity())>5 then 
				
					bx,by= fixtureB:getBody():getWorldCenter()
					particles(bx,by,particletexture)
					particles2(bx,by,particletexture4)
					popscore(bx,by,100)
					score=score+100	
					--fixtureA:getBody():destroy()						
					--destroyed=destroyed+1	
					ball_joints[fixtureB.userdata]:destroy()
					fixtureB.name="Circle"
			end
			
		if fixtureA.name=="Welded" and math.abs(fixtureB:getBody():getLinearVelocity())>5 then 
				
					bx,by= fixtureA:getBody():getWorldCenter()
					particles(bx,by,particletexture)
					particles2(bx,by,particletexture4)
					popscore(bx,by,100)
					score=score+100	
					--fixtureA:getBody():destroy()						
					--destroyed=destroyed+1	
					ball_joints[fixtureA.userdata]:destroy()
					fixtureA.name="Circle"
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

	lastX=x
	lastY=y
	mouseX, mouseY = layer:wndToWorld ( x, y )
	hudX,hudY=layer_hud:wndToWorld ( x, y )		
	bx,by= body:getPosition()	
	pick = partition:propForPoint ( hudX,hudY )
	gamepick = gamepartition:propForPoint ( mouseX,mouseY )

	if mousedown==true then
		-- zooming
		if playerpicked~=true and gamepick~=true then 
		--fitter:stop ()
			diffX=xDown-x
			diffX=diffX/1000
			if mode==4 then 
				print ("old_xScl="..old_xScl.." diffx="..diffX.." xdown="..lastX)
				setxScl=old_xScl-diffX
				if setxScl<0.01 then setxScl=0.01 end
				if setxScl>0.5 then setxScl=0.5 end
				print ("Xscale="..setxScl)
				camera:setScl(setxScl,setxScl)
			end
		end
			
		-- panning
		if playerpicked~=true and gamepick~=true and mode~=4 then

			trackplayer=false
			cx,cy=camera:getLoc()
			
			gotoX=cx-mouseX+downX
			gotoY=cy-mouseY+downY
			
				if gotoX<gamewidth*-1 then gotoX=gamewidth*-1 end
				if gotoX>gamewidth then gotoX=gamewidth end
				if gotoY<gameheight*-1 then gotoY=gameheight*-1 end
				if gotoY>gameheight then gotoY=gameheight end
			
			print ("mousex="..mouseX)
			
			camera:seekLoc(gotoX,gotoY,0)
			

		end

	end

	
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
		--playerprop:seekRot(angle,0)
		
			scalex=math.sqrt(mousex*mousex+mousey*mousey)
			if scalex>5 then scalex=5 end
						
			playerarrowprop:setVisible(true)
			playerarrowprop:seekScl ( scalex,scalex)
			playerarrowprop:seekRot(angle,0)
			playerarrowprop:seekLoc ( bx,by)

	end
	
	if pick then 
			if pick.name=="Button1" then
			buttonX=hudX-(screen_width/2*-1)-64-32
			buttonY=hudY-(screen_height/2*-1)-32
			
			end
			if pick.name=="Button2" then
			buttonX=hudX-(screen_width/2*-1)-64-32
			buttonY=hudY-(screen_height/2*-1)-32

			end
			if pick.name=="Button3" then
			buttonX=hudX-(screen_width/2*-1)-64-32
			buttonY=hudY-(screen_height/2*-1)-32
			
			end
			if pick.name=="Button4" then
			buttonX=hudX-(screen_width/2*-1)-64-32
			buttonY=hudY-(screen_height/2*-1)-32
			
			end
	end

end
		
function clickCallback ( down )

-- pointer DOWN
	if down==true then		
	timerDown=0
	
	old_xScl,old_yScl=camera:getScl()
	old_x,old_y=camera:getLoc()
	mousedown=true
	buttonpicked=false
	downX=mouseX
	downY=mouseY
	xDown=lastX
	yDown=lastY
	
		if gamepick  then
			if gamepick.name=="Player" then
				playerpicked=true
				body:setLinearVelocity(0,0)
				pickX=mouseX
				pickY=mouseY
			end
		end
		
			if pick then 
			
			if pick.name=="Button1" and mousedown then
			buttonX=hudX-(screen_width/2*-1)-64-32
			buttonY=hudY-(screen_height/2*-1)-32
			
			print ("Button1 X="..buttonX.." buttonY="..buttonY)
			mode=1
			buttonpicked=true


			end
			
			if pick.name=="Button2" and mousedown then
			buttonX=hudX-(screen_width/2*-1)-64-32
			buttonY=hudY-(screen_height/2*-1)-32
			
			print ("Button2 X="..buttonX.." buttonY="..buttonY)
			mode=2
			buttonpicked=true

			end
			if pick.name=="Button3" and mousedown then
			buttonX=hudX-(screen_width/2*-1)-64-32
			buttonY=hudY-(screen_height/2*-1)-32
			
			print ("Button3 X="..buttonX.." buttonY="..buttonY)
			mode=3
			buttonpicked=true

			end
			if pick.name=="Button4" and mousedown then
			buttonX=hudX-(screen_width/2*-1)-64-32
			buttonY=hudY-(screen_height/2*-1)-32
			
			print ("Button4 X="..buttonX.." buttonY="..buttonY)
			mode=4
			buttonpicked=true

			end				
		end
		
		if buttonpicked==false and playerpicked==false and mode==1 then
			print "ACTION 1"
			add_actor(mouseX,mouseY,2,2,0.02,0.3,0.1,"Circle","Dynamic","christmasball2.png","True",50)
		end
		if buttonpicked==false and playerpicked==false and mode==2 then
			print "ACTION 2"
			add_actor(mouseX,mouseY,4,4,0.02,0.3,0.1,"Circle","Dynamic","christmasball3.png","False",50)
		end

	end

-- pointer UP	
	if down==false then 
		mousedown=false 
		if playerpicked then

			playerarrowprop:setVisible(false)
			bx,by= body:getPosition()
			
			forceX=bx-mouseX
			forceY=by-mouseY
			body:applyForce( forceX *800000, forceY *800000,bx,by)
			particles2(bx,by,particletexture4)
			trackplayer=true
			playerpicked=false
			--fitter:start ()
			--sound:play ()	
			--viewport:setRotation(angle)
		end
	end	
end


function pointerCallback_menu( x, y )	

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
			layer2:insertProp ( system )

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
			layer2:insertProp ( system2 )

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


function loadLevel()
level1()
print "Load level complete"	
end

function level1()
print "Loading level"
--add_actor(x,y,width,height,density,friction,restitution,actorname,bodytype,texture_image,welded,health)
--walls
--top
add_actor(0,60,240,5,0.02,0.3,0.1,"Box","Static","wall1.png","False",1)
--bottom
add_actor(0,-60,240,5,0.02,0.3,0.1,"Box","Static","wall1.png","False",1)
--left
add_actor(-60,0,5,240,0.02,0.3,0.1,"Box","Static","wall1.png","False",1)
--right
add_actor(60,0,5,240,0.02,0.3,0.1,"Box","Static","wall1.png","False",1)

-- static obstacles

-- bunch of boxes
add_actor(0,0,2,2,0.02,0.3,0.1,"Box","Dynamic","ground.png","False",50)


-- bunch of exlodable circles

for x = 2, 5 do
for y = 2, 5 do
add_actor(x*2,y*2,8,8,0.02,0.3,0.2,"Circle","Dynamic","roundsweet.png","False",100)
end
end

-- welded
add_actor(5,-20,5,5,0.02,0.3,0.1,"Circle","Dynamic","christmasball2.png","True",50)

-- bouncer like pinball
add_actor(5,5,5,5,0.02,0.3,4,"Circle2","Static","bounce.png","False",50)

-- other bits
add_bridge(0,0,20,20,20)
--add_spinner(-10,-20,10,1,"platform1.png")

add_actor(45,-40,5,5,0.02,0.3,0.1,"Complex","Dynamic","none.png","True",50)

end

function add_actor(x,y,width,height,density,friction,restitution,actorname,bodytype,texture_image,welded,health)
print "Adding actor"
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
		
			ball_bodies[c]:setTransform(x,y,0)
		
		if actorname=="Circle2" then 

		texture = MOAIGfxQuad2D.new ()
		texture:setTexture ( texture_image )
		texture:setRect ( width/2*-1,width/2*-1,width/2,width/2)
		ball_sprites[c]:setDeck ( texture ) 
		
		ball_fixtures[c] = ball_bodies[c]:addCircle ( 0,0,width/2)
		end
		
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
		--ball_bodies[c]:setFixedRotation(true)		
		end
		if actorname=="Triangle" then 
		texture = MOAIGfxQuad2D.new ()
		texture:setTexture ( texture_image )
		texture:setRect ( width/2*-1.5,height/2*-1.5,width/2*1.5,height/2*1.5)
		ball_sprites[c]:setDeck ( texture ) 
		t = { 1*width,-1*width,0*width,1*width,-1*width,-1*width }
		ball_fixtures[c] = ball_bodies[c]:addPolygon (t)
		end
		
		if actorname=="Complex" then 
		texture = MOAIGfxQuad2D.new ()
		texture:setTexture ( texture_image )
		texture:setRect ( width/2*-1.5,height/2*-1.5,width/2*1.5,height/2*1.5)
		
		--shape1
		ball_sprites[c]:setDeck ( texture ) 
		t = { 1*width,-1*width,0*width,1*width,-1*width,-1*width }
		ball_fixtures[c] = ball_bodies[c]:addPolygon (t)
		ball_fixtures[c]:setDensity ( density )
		ball_fixtures[c]:setFriction ( friction )
		ball_fixtures[c]:setRestitution ( restitution)
		ball_fixtures[c].userdata=c
		ball_bodies[c]:resetMassData()		
		ball_fixtures[c]:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x03 )		
		ball_sprites[c]:setParent ( ball_bodies[c] )
		ball_fixtures[c].name="Complex"
		
		c=c+1
		
		--shape2
		ball_bodies[c] = world:addBody ( MOAIBox2DBody.DYNAMIC )
		ball_bodies[c]:setTransform(x,y,120)
		ball_bodies[c]:resetMassData()	
		ball_sprites[c] = MOAIProp2D.new ()
		ball_sprites[c]:setDeck ( texture ) 
		t = { 1*width,-1*width,0*width,1*width,-1*width,-1*width }
		ball_fixtures[c] = ball_bodies[c]:addPolygon (t)
		ball_fixtures[c]:setDensity ( density )
		ball_fixtures[c]:setFriction ( friction )
		ball_fixtures[c]:setRestitution ( restitution)
		ball_fixtures[c].userdata=c
		ball_fixtures[c].name=actorname	
		
		ball_bodies[c]:resetMassData()		
		ball_fixtures[c]:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x03 )		
		ball_sprites[c]:setParent ( ball_bodies[c] )
		ball_fixtures[c].name="Complex"
		ball_joints[c-1]=world:addWeldJoint ( ball_bodies[c-1],ball_bodies[c],baseX,baseY)
		
		c=c+1
		
		--shape3
		ball_bodies[c] = world:addBody ( MOAIBox2DBody.DYNAMIC )
		ball_bodies[c]:setTransform(x,y,240)
		ball_bodies[c]:resetMassData()	
		ball_sprites[c] = MOAIProp2D.new ()
		ball_sprites[c]:setDeck ( texture ) 
		t = { 1*width,-1*width,0*width,1*width,-1*width,-1*width }
		ball_fixtures[c] = ball_bodies[c]:addPolygon (t)
		ball_fixtures[c].name="Complex"
		ball_joints[c-1]=world:addWeldJoint ( ball_bodies[c-1],ball_bodies[c],baseX,baseY)
		end

		
		
		ball_fixtures[c]:setDensity ( density )
		ball_fixtures[c]:setFriction ( friction )
		ball_fixtures[c]:setRestitution ( restitution)
		ball_fixtures[c].userdata=c
		ball_fixtures[c].name=actorname
		ball_fixtures[c].health=health
	
		ball_bodies[c]:resetMassData()		
		ball_fixtures[c]:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x03 )
		
		ball_sprites[c]:setParent ( ball_bodies[c] )
		
		if welded=="True" then
		ball_fixtures[c].name="Welded"
		fixedbody = world:addBody ( MOAIBox2DBody.STATIC )
		fixed_fixture = fixedbody:addRect ( -1999,-0.1,-2000,0.1)
		ball_joints[c]=world:addWeldJoint ( fixedbody,ball_bodies[c],baseX,baseY)
		end
		
		layer:insertProp ( ball_sprites[c] )

		c=c+1

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

function add_rope(baseX,baseY,baseX1,baseY1,length)
ropes = {}
rope_sprites = {}

texture = MOAIGfxQuad2D.new ()
texture:setTexture ( 'chain2.png' )
texture:setRect ( -1, -1, 1, 1)

ropes[0] = world:addBody ( MOAIBox2DBody.DYNAMIC )

bx,by= ropes[0] :getPosition()
ropes[0]:setTransform(baseX,baseY,0)
fixture = ropes[0] :addRect( -0.25,-1,0.25,1 )
fixture:setDensity ( 1)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.25)
fixture:setFilter ( 0x01 )
fixture.userdata=2
world:addWeldJoint ( ropes[0] , wall_bodies[1],baseX,baseY)
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
if y==length then 
print ("DOING Y")
world:addWeldJoint ( ropes[y] , wall_bodies[1],baseX1,baseY1) 
end
ropes[y]:resetMassData()
rope_sprites[y]=MOAIProp2D.new ()
rope_sprites[y]:setParent ( ropes[y] )
rope_sprites[y]:setDeck ( texture )
layer:insertProp ( rope_sprites[y] )

end
end

function add_breakable(baseX,baseY,width,height,texture_image)
spinner=world:addBody ( MOAIBox2DBody.DYNAMIC )

fixture = spinner:addRect( width*-1,height*-1,width,height)
spinner:setTransform(baseX,baseY,0)
spinner:setFixedRotation(false)	
bx,by= spinner:getPosition()
fixture:setDensity ( 1)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.25)
fixture:setFilter ( 0x01 )
fixture.userdata=2
fixedbody = world:addBody ( MOAIBox2DBody.STATIC )
fixed_fixture = fixedbody:addRect ( -2000,-0.1,-1999,0.1)
spinner:resetMassData()
world:addWeldJoint ( fixedbody,spinner,baseX,baseY)

sprite=MOAIProp2D.new ()
texture = MOAIGfxQuad2D.new ()
texture:setTexture ( texture_image )
texture:setRect ( width*-1,height*-1,width,height)
sprite:setParent ( spinner )
sprite:setDeck ( texture )
layer:insertProp ( sprite )
end

function add_spinner(baseX,baseY,width,height,texture_image)
spinner=world:addBody ( MOAIBox2DBody.DYNAMIC )

fixture = spinner:addRect( width*-1,height*-1,width,height)
spinner:setTransform(baseX,baseY,0)
spinner:setFixedRotation(false)	
bx,by= spinner:getPosition()
fixture:setDensity ( 1)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.25)
fixture:setFilter ( 0x01 )
fixture.userdata=2
fixedbody = world:addBody ( MOAIBox2DBody.STATIC )
fixed_fixture = fixedbody:addRect ( -2000,-0.1,-1900,0.1)
spinner:resetMassData()
world:addRevoluteJoint ( fixedbody,spinner,baseX,baseY)

sprite=MOAIProp2D.new ()
texture = MOAIGfxQuad2D.new ()
texture:setTexture ( texture_image )
texture:setRect ( width*-1,height*-1,width,height)
sprite:setParent ( spinner )
sprite:setDeck ( texture )
layer:insertProp ( sprite )
end




function add_bridge(baseX,baseY,baseX1,baseY1,length)
ropes = {}
rope_sprites = {}

ropes[0] = world:addBody ( MOAIBox2DBody.DYNAMIC )

bx,by= ropes[0] :getPosition()
ropes[0]:setTransform(baseX,baseY,0)
fixture = ropes[0] :addRect( -1,-0.25,1,0.25)
fixture:setDensity ( 1)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.25)
fixture:setFilter ( 0x01 )
fixture.userdata=2
world:addWeldJoint ( ropes[0] , wall_bodies[1],baseX,baseY)
ropes[0] :resetMassData()

for c = 1, length do
ropes[c] = world:addBody ( MOAIBox2DBody.DYNAMIC )

fixture = ropes[c]:addRect( -1,-0.25,1,0.25)
ropes[c]:setTransform(baseX+(c*-2),baseY,0)
bx,by= ropes[c]:getPosition()
fixture:setDensity ( 1)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.25)
fixture:setFilter ( 0x01 )
fixture.userdata=2
world:addRevoluteJoint ( ropes[c], ropes[c-1],baseX+1-c*2,baseY)

if c==length then 
world:addWeldJoint ( ropes[c] , wall_bodies[1],baseX,baseY) 
end
ropes[c]:resetMassData()
rope_sprites[c]=MOAIProp2D.new ()
rope_sprites[c]:setParent ( ropes[c] )
rope_sprites[c]:setDeck ( texture4 )
layer:insertProp ( rope_sprites[c] )

end
end


function add_stiff_rope(baseX,baseY,baseX1,baseY1,length)
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
if y==length then world:addRevoluteJoint ( ropes[y] , wall_bodies[1],baseX1,baseY1) end
ropes[y]:resetMassData()
rope_sprites[y]=MOAIProp2D.new ()
rope_sprites[y]:setParent ( ropes[y] )
rope_sprites[y]:setDeck ( texture4 )
layer:insertProp ( rope_sprites[y] )

end
end


-- main routines
print "Starting main routines"
init()
graphics()
splash()

----------------- download assets -------------

function getFile(filename,url)
c=assert(curl.new());
local file=assert(io.open(filename, "wb"));
assert(c:setopt(curl.OPT_WRITEFUNCTION, function (stream, buffer)
	stream:write(buffer)
	return string.len(buffer);
end));
assert(c:setopt(curl.OPT_WRITEDATA, file));
assert(c:setopt(curl.OPT_PROGRESSFUNCTION, function (_, dltotal, dlnow, uptotal, upnow)
end));
assert(c:setopt(curl.OPT_NOPROGRESS, false));
assert(c:setopt(curl.OPT_BUFFERSIZE, 5000));
--assert(c:setopt(curl.OPT_HTTPHEADER, "Connection: Keep-Alive", "Accept-Language: en-us"));
assert(c:setopt(curl.OPT_URL, url));
assert(c:setopt(curl.OPT_CONNECTTIMEOUT, 15));
--assert(c:perform());
c:perform({writefunction = function(str) 
				print "DOWNLOADED FILE?!"
			     end})
assert(c:close()); -- not necessary, as will be garbage collected soon
s="abcd$%^&*()";
assert(s == assert(curl.unescape(curl.escape(s))));
file:close();
print ("Image downloaded="..filename)
filesRemaining=filesRemaining-1
if filesRemaining>0 then downloadFile() end
c=nil
end

function downloadFile()
if filesRemaining==4 then getFile("button4.png","http://www.innovationtech.co.uk/moai/button4.png") end
if filesRemaining==3 then getFile("button3.png","http://www.innovationtech.co.uk/moai/button3.png") end
if filesRemaining==2 then getFile("button2.png","http://www.innovationtech.co.uk/moai/button2.png") end
if filesRemaining==1 then getFile("button1.png","http://www.innovationtech.co.uk/moai/button1.png") end
end

filesRemaining=4
--downloadFile()