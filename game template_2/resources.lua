print ("loading resources")
function load_resources()
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

particletexture = MOAIGfxQuad2D.new ()
particletexture:setTexture ( 'cloud.png' )
particletexture:setRect ( -0.8, -0.8, 0.8, 0.8)

--sound = MOAIUntzSound.new ()
--sound:load ( 'pop.wav' )
--sound:setVolume ( 1 )
--sound:setLooping ( false )

end
