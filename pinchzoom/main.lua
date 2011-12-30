MOAISim.openWindow ( "test", 960, 480 )

layer = MOAILayer2D.new ()
MOAISim.pushRenderPass ( layer )

viewport = MOAIViewport.new ()
viewport:setSize ( 960, 480 )
viewport:setScale ( 960, 480 )
layer:setViewport ( viewport )

mouseX = 0
mouseY = 0

function pointerCallback ( x, y )
	
	local oldX = mouseX
	local oldY = mouseY
	
	mouseX, mouseY = layer:wndToWorld ( x, y )
	
	if pick then
		pick:addLoc ( mouseX - oldX, mouseY - oldY )
	end
end
		
function clickCallback ( down )
	
end

if MOAIInputMgr.device.pointer then
	
	-- mouse input
	MOAIInputMgr.device.pointer:setCallback ( pointerCallback )
	MOAIInputMgr.device.mouseLeft:setCallback ( clickCallback )
else

pinching=false
pointer1x=0
pointer2x=0
pointer1y=0
pointer2y=0
	-- touch input
	MOAIInputMgr.device.touch:setCallback ( 
	
		function ( eventType, idx, x, y, tapCount )

		--print ("Eventype="..eventType.." idx="..idx)
			if pinching then
				if idx==0 then 
				pointer1x=x 
				pointer1y=y
				end
				if idx==1 then
				pointer2x=x
				pointer2y=y
				end
				
				width=pointer2x-pointer1x
				height=pointer2y-pointer1y
				print ("width="..width.." height="..height)
				
			end
		
			if idx==0 and eventType == 1 then
			if pinching~=true then print("panning") end
			end
			
			if idx==0 and eventType == MOAITouchSensor.TOUCH_DOWN then
			--print(" first finger down ")
			end
			
			if idx==0 and eventType == MOAITouchSensor.TOUCH_UP then
			--print(" first finger up ")
			--print ("Pinch finished!")
			
			pinching=false
			end
			
			if idx==1 and eventType == 1 then
			--print(" second finger move ")
			end
			
			if idx==1 and eventType == MOAITouchSensor.TOUCH_DOWN then
			--print("  second finger down ")
			pinching=true
			end
			
			if idx==1 and eventType == MOAITouchSensor.TOUCH_UP then
			--print(" second finger up ")

			end		
		end
			
	)
end




