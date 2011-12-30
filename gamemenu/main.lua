MOAISim.openWindow ( "test", 960, 480 )
viewport = MOAIViewport.new ()
viewport:setSize ( 960, 480 )
viewport:setScale ( 64,0 )

function alert_menu()
alert_layer = MOAILayer2D.new ()
MOAISim.pushRenderPass ( alert_layer )
alert_layer:setViewport ( viewport )

alert_partition = MOAIPartition.new ()
alert_layer:setPartition ( alert_partition )

addButton ( -5,0, 0.5, 0.5, "OK","ok.png")
addButton ( 5,0, 0.5, 0.5, "Cancel","cancel.png" )

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
	gfxQuad:setRect ( -5,-5,5,5 )
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
	
function clickCallback ( down )
	if down then alert_menu() end
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

input()
