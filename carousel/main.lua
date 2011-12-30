screen_width,screen_height=MOAIEnvironment.getScreenSize()
if screen_width==0 then screen_width=800 end
if screen_height==0 then screen_height=480 end

MOAISim.openWindow ( "test", screen_width, screen_height )
viewport = MOAIViewport.new ()
viewport:setSize ( screen_width, screen_height )
viewport:setScale ( screen_width, screen_height )

layer = MOAILayer2D.new ()
MOAISim.pushRenderPass ( layer )

viewport = MOAIViewport.new ()
viewport:setSize ( screen_width,screen_height )
viewport:setScale ( screen_width,screen_height)
layer:setViewport ( viewport )

layer1 = MOAILayer2D.new ()
MOAISim.pushRenderPass ( layer1 )
layer1:setViewport ( viewport )
layer1:seekLoc(screen_width,0,0)
layer2 = MOAILayer2D.new ()
MOAISim.pushRenderPass ( layer2 )
layer2:setViewport ( viewport )
layer2:seekLoc(screen_width*2,0,0)

logoGfx = MOAIGfxQuad2D.new ()
logoGfx:setTexture ( "cathead.png" )
logoGfx:setRect (-64,-64,64,64)
prop1 = MOAIProp2D.new ()
prop1:setDeck ( logoGfx )
layer:insertProp ( prop1 )

logoGfx2 = MOAIGfxQuad2D.new ()
logoGfx2:setTexture ( "cathead.png" )
logoGfx2:setRect (-128,-128,128,128)
prop2 = MOAIProp2D.new ()
prop2:setDeck ( logoGfx2 )
layer1:insertProp ( prop2 )

logoGfx3 = MOAIGfxQuad2D.new ()
logoGfx3:setTexture ( "cathead.png" )
logoGfx3:setRect (-128,-128,12,128)
prop3 = MOAIProp2D.new ()
prop3:setDeck ( logoGfx3 )
layer2:insertProp ( prop3 )

function move_layers_left()
layer:moveLoc (screen_width*-1, 0, 2 ) -- move left 1 screen
layer1:moveLoc (screen_width*-1, 0, 2 ) -- move left 1 screen
layer2:moveLoc (screen_width*-1, 0, 2 ) -- move left 1 screen
end

function move_layers_right()
layer:moveLoc (screen_width, 0, 2 ) -- move right 1 screen
layer1:moveLoc (screen_width, 0, 2 ) -- move right 1 screen
layer2:moveLoc (screen_width, 0, 2 ) -- move right 1 screen
end

function pointerCallback( x, y )

	mouseX, mouseY = layer:wndToWorld ( x, y )

end
	
position=1
function clickCallback( down )
	
	if down then
		
	oldX = mouseX
	oldY = mouseY	
	else
		dif=oldX-mouseX
		
		if dif<-1 and position >1 then 
		move_layers_right()
		position=position-1
		end
		
		if dif>1 and position <3 then	
		move_layers_left()
		position=position+1
		end
	end

end
	
	
if MOAIInputMgr.device.pointer then
	
	-- mouse input
	MOAIInputMgr.device.pointer:setCallback ( pointerCallback)
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


