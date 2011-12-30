MOAISim.openWindow ( "Particles", 320, 480 )

viewport = MOAIViewport.new ()
viewport:setSize ( 320, 480 )
viewport:setScale ( 320, 480 )

layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
MOAISim.pushRenderPass ( layer )

------------------------------
-- Instructional textbox
------------------------------
font = MOAIFont.new ()
charcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-'
font:loadFromTTF ( 'arial-rounded.ttf', charcodes, 16, 163 )

textbox = MOAITextBox.new ()
textbox:setString ( "Press TAB to surge" )
textbox:setFont ( font )
textbox:setTextSize ( font:getScale ())
textbox:setRect ( -150, -230, 150, 230 )
textbox:setYFlip ( true )
layer:insertProp ( textbox )

------------------------------
-- Deck for particles
------------------------------
-- a white 10x10 .png
sparkDeck = MOAIGfxQuad2D.new ()
sparkDeck:setTexture ( "cathead.png" )
sparkDeck:setRect ( -5, -5, 5, 5 )

------------------------------
-- Particle scripts
------------------------------

-- pack registers for scripts
reg1 = MOAIParticleScript.packReg ( 1 )
reg2 = MOAIParticleScript.packReg ( 2 )
reg3 = MOAIParticleScript.packReg ( 3 )
reg4 = MOAIParticleScript.packReg ( 4 )
reg5 = MOAIParticleScript.packReg ( 5 )
CONST = MOAIParticleScript.packConst

 ----------
 --init script
 ----------
sparkInitScript = MOAIParticleScript.new ()
-- this takes the registers you created above and turns them into random number generators
-- returning values between the last two parameters
sparkInitScript:randVec ( reg1, reg2, CONST(12), CONST(128) )
sparkInitScript:rand ( reg3, CONST(-90), CONST(90) )
sparkInitScript:rand ( reg4, CONST(0.5), CONST(1.2) )

----------
-- render script
----------
sparkRenderScript = MOAIParticleScript.new ()
--this makes the sprite appear
sparkRenderScript:sprite ()
-- this controls the amount your particle cloud will spread out over the x axis
-- and how fast / smooth it spreads. Note it is getting a random value from
-- one of the script registers
sparkRenderScript:easeDelta	( MOAIParticleScript.PARTICLE_X, CONST(0), reg1, MOAIEaseType.SHARP_EASE_IN )
-- this does the same over the y axis
sparkRenderScript:easeDelta	( MOAIParticleScript.PARTICLE_Y, CONST(0), reg2, MOAIEaseType.SHARP_EASE_IN )
-- this sets a random starting rotation for each particle
sparkRenderScript:set ( MOAIParticleScript.SPRITE_ROT, reg3 )
-- this applies a random amount of rotation to each particle during its lifetime
sparkRenderScript:ease ( MOAIParticleScript.SPRITE_ROT, CONST(0), reg3, MOAIEaseType.LINEAR )
-- this makes the particle fade out near the end of its lifetime
sparkRenderScript:ease ( MOAIParticleScript.SPRITE_OPACITY, CONST(1), CONST(0), MOAIEaseType.SHARP_EASE_OUT )
-- this makes each particle randomly bigger or smaller than the original size
sparkRenderScript:set	( MOAIParticleScript.SPRITE_X_SCL, reg4 )
sparkRenderScript:set	( MOAIParticleScript.SPRITE_Y_SCL, reg4 )

------------------------------
-- Particle system
------------------------------
sparkSystem = MOAIParticleSystem.new ()
-- max num of particles, size of each
sparkSystem:reserveParticles ( 64, 10 )
-- max num of sprites
sparkSystem:reserveSprites ( 64 )
sparkSystem:reserveStates ( 1 )
-- deck can be set like a prop
sparkSystem:setDeck ( sparkDeck )
sparkSystem:start ()
-- particle system can be inserted like a prop
layer:insertProp ( sparkSystem )

------------------------------
-- Particle forces
------------------------------
gravity = MOAIParticleForce.new ()
gravity:initLinear ( 0, -100 )
gravity:setType( MOAIParticleForce.FORCE )

------------------------------
-- Particle state
------------------------------
-- a state holds a particle cloud's lifetime, physics properties
-- and which scripts govern its behavior
sparkState = MOAIParticleState.new ()
-- particle lifetime, random between the two values in seconds
sparkState:setTerm ( 0.5, 2 )
sparkState:setInitScript ( sparkInitScript )
sparkState:setRenderScript ( sparkRenderScript )
sparkState:pushForce (gravity)

-- sets the system to this state
sparkSystem:setState ( 1, sparkState )

------------------------------
-- Thread for user input
------------------------------
mainThread = MOAIThread.new ()
mainThread:run(
	function()
		local run = true
		while run do
			coroutine.yield()
			if MOAIInputMgr.device.keyboard:keyDown(9) then -- Tab
				-- parameters for surge
				-- 1 : number of sprites emitted
				-- 2, 3 : (x, y) origin point of particle cloud
				-- 4, 5 : (x, y) destination point for particle cloud drift
				-- Note that I'm manually applying a small X-direction movement here
				-- but the downward movement is a result of the particle force
				-- defined as 'gravity' above
				sparkSystem:surge(128, 0, 0, 25, 0)
			end
		end
	end
)