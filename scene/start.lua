--[[
The MIT License (MIT)
Copyright (c) 2011 Reflare UG
https://github.com/reflare/Moai-Libraries
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files 
(the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

module(..., package.seeall)

function new (l)
	
	----------------------------------------------------------------
	--background
	----------------------------------------------------------------
	local bg = {}
	bg.texture = MOAITexture.new()
	bg.texture:load('bg.png')
	bg.gfx = MOAIGfxQuad2D.new ()
	bg.gfx:setTexture(bg.texture)
	bg.gfx:setRect (-384,512,384,-512)
	bg.sprite = MOAIProp2D.new()
	bg.sprite:setDeck(bg.gfx)
	l:insertProp(bg.sprite)

	----------------------------------------------------------------
	--Start Button
	----------------------------------------------------------------
	local btn = {}
	btn.texture = MOAITexture.new()
	btn.texture:load("btnStart.png")
	btn.gfx = MOAIGfxQuad2D.new()
	btn.gfx:setTexture(btn.texture)
	btn.gfx:setRect(-256,-128,256,128)
	btn.prop = MOAIProp2D.new()
	btn.prop:setDeck(btn.gfx)
	l:insertProp(btn.prop)

	function btnStartDown(event)
		if (event.phase == "ended") then
			scene.swap("demo","slideLeft")
		end
	end

	display.addListener(btn.prop,btnStartDown)
end