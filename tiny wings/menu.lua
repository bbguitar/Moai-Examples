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

partition_menu = MOAIPartition.new ()
layer_menu:setPartition ( partition_menu)

menubutton = MOAIGfxQuad2D.new ()
menubutton:setTexture ( "images/button1.png" )
menubutton:setRect ( -64, -64, 64, 64 )
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
