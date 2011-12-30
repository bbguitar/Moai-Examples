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
			setup_game()
			start_game()
		end
		end
	end	
	if down==false then

	end
end

function setup_menu()
print ("setup menu")

partition_menu = MOAIPartition.new ()
layer_menu:setPartition ( partition_menu)

menubutton = MOAIGfxQuad2D.new ()
menubutton:setTexture ( "button1.png" )
menubutton:setRect ( -32,-32,32,32 )
local menubutton_prop = MOAIProp2D.new ()
menubutton_prop:setDeck ( menubutton )
menubutton_prop.name = "Button1" 
partition_menu:insertProp ( menubutton_prop )

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