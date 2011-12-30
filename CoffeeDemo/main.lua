-- 
-- Abstract: List View Tutorial Sample File, (aka Coffee Demo) 
--  
-- Version: 1.1, better support for landscape layout on the iPad!
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
--
-- Demonstrates how to create a list view using the Table View Library.
-- A list view is a collection of content organized in rows that the user
-- can scroll up or down on touch. Tapping on each row can execute a 
-- custom function.

--import the table view library
local tableView = require("tableView")

--import the button events library
local ui = require("ui")

display.setStatusBar( display.HiddenStatusBar ) 

--initial values
local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight

local myList, backBtn, detailScreenText

local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(77, 77, 77)

--Uncomment the line below to see a background image
--local background = display.newImage("coffeeBg.png")

--setup a destination for the list items
local detailScreen = display.newGroup()

local detailBg = display.newRect(0,0,display.contentWidth,display.contentHeight-display.screenOriginY)
detailBg:setFillColor(255,255,255)
detailScreen:insert(detailBg)

detailScreenText = display.newText("You tapped item", 0, 0, native.systemFontBold, 24)
detailScreenText:setTextColor(0, 0, 0)
detailScreen:insert(detailScreenText)
detailScreenText.x = math.floor(display.contentWidth/2)
detailScreenText.y = math.floor(display.contentHeight/2) 	
detailScreen.x = display.contentWidth
 
--setup the table
local data = {}  --note: the declaration of this variable was moved up higher to broaden its scope

--iPad: setup a color fill for selected items
local selected = display.newRect(0, 0, 50, 50)  --add acolor fill to show the selected item
selected:setFillColor(67,141,241,180)  --set the color fill to light blue
selected.isVisible = false  --hide color fill until needed

--setup functions to execute on touch of the list view items
function listButtonRelease( event )
	self = event.target
	local id = self.id
	print(self.id)
	
	detailScreenText.text = "You tapped ".. data[id].title --added this line to make the right side of the screen more interesting
	--check for screen width of the iPad
	if system.getInfo("model") == "iPad" then			
		selected.width, selected.height = self.width, self.height --iPad: set the color fill width and height
		selected.y = self.y + self.height*0.5 --iPad: move the color fill to wherever the user tapped
		selected.isVisible = true --iPad: show the fill color
	else
		transition.to(myList, {time=400, x=display.contentWidth*-1, transition=easing.outExpo })
		transition.to(detailScreen, {time=400, x=0, transition=easing.outExpo })
		transition.to(backBtn, {time=400, x=math.floor(backBtn.width/2) + screenOffsetW*.5 + 6, transition=easing.outExpo })
		transition.to(backBtn, {time=400, alpha=1 })
	
		delta, velocity = 0, 0
	end
end

function backBtnRelease( event )
	print("back button released")
	transition.to(myList, {time=400, x=0, transition=easing.outExpo })
	transition.to(detailScreen, {time=400, x=display.contentWidth, transition=easing.outExpo })
	transition.to(backBtn, {time=400, x=math.floor(backBtn.width/2)+backBtn.width, transition=easing.outExpo })
	transition.to(backBtn, {time=400, alpha=0 })

	delta, velocity = 0, 0
end

--setup each row as a new table, then add title, subtitle, and image
data[1] = {}
data[1].title = "Hot Coffee"
data[1].subtitle = "Grounds brewed in hot water"
data[1].image = "coffee1.png"

data[2] = {}
data[2].title = "Iced Coffee"
data[2].subtitle = "Chilled coffee with ice"
data[2].image = "coffee2.png"

data[3] = {}
data[3].title = "Espresso"
data[3].subtitle = "Hot water forced through"
data[3].image = "coffee3.png"

data[4] = {}
data[4].title = "Cappuccino"
data[4].subtitle = "Espresso with frothy milk"
data[4].image = "coffee4.png"

data[5] = {}
data[5].title = "Latte"
data[5].subtitle = "More milk and less froth"
data[5].image = "coffee5.png"

data[6] = {}
data[6].title = "Americano"
data[6].subtitle = "Espresso with hot water"
data[6].image = "coffee6.png"

--iPad: duplicate some of the sample data to make the list longer
for i=1, 6 do
	table.insert(data, data[i])
end

local topBoundary = display.screenOriginY + 40
local bottomBoundary = display.screenOriginY + 0

-- create the list of items
myList = tableView.newList{
	data=data, 
	default="listItemBg.png",
	--default="listItemBg_white.png",
	over="listItemBg_over.png",
	onRelease=listButtonRelease,
	top=topBoundary,
	bottom=bottomBoundary,
	--backgroundColor={ 255, 255, 255 },  --commented this out because we're going to add it down below
    callback = function( row )
                         local g = display.newGroup()

                         local img = display.newImage(row.image)
                         g:insert(img)
                         img.x = math.floor(img.width*0.5 + 6)
                         img.y = math.floor(img.height*0.5) 

                         local title =  display.newText( row.title, 0, 0, native.systemFontBold, 14 )
                         title:setTextColor(0, 0, 0)
                         --title:setTextColor(255, 255, 255)
                         g:insert(title)
                         title.x = title.width*0.5 + img.width + 6
                         title.y = 30

                         local subtitle =  display.newText( row.subtitle, 0, 0, native.systemFont, 12 )
                         subtitle:setTextColor(80,80,80)
                         --subtitle:setTextColor(180,180,180)
                         g:insert(subtitle)
                         subtitle.x = subtitle.width*0.5 + img.width + 6
                         subtitle.y = title.y + title.height + 6

                         return g   
                  end 
}

local function scrollToTop()
	myList:scrollTo(topBoundary-1)
end

--Setup the nav bar 
local navBar = ui.newButton{
	default = "navBar.png",
	onRelease = scrollToTop
}
navBar.x = display.contentWidth*.5
navBar.y = math.floor(display.screenOriginY + navBar.height*0.5)

local navHeader = display.newText("Coffee", 0, 0, native.systemFontBold, 16)
navHeader:setTextColor(255, 255, 255)
navHeader.x = display.contentWidth*.5
navHeader.y = navBar.y

--Setup the back button
backBtn = ui.newButton{ 
	default = "backButton.png", 
	over = "backButton_over.png", 
	onRelease = backBtnRelease
}
backBtn.x = math.floor(backBtn.width/2) + backBtn.width + screenOffsetW
backBtn.y = navBar.y 
backBtn.alpha = 0

--Add a white background to the list.  
--It didn't move with the list when it appeared on the larger screen of the iPad.
local listBackground = display.newRect( 0, 0, myList.width, myList.height )
listBackground:setFillColor(255,255,255)
myList:insert(1,listBackground)

--*** iPad: The lines below are some layout tweaks for the larger display size ***
if system.getInfo("model") == "iPad" then	
	--Rather than creating a new graphic, let's just stretch the black bar at the top of the screen
	navBar.xScale = 6  

	--Set new default text since the list is now on the left
	detailScreenText.text = "Tap an item on the left" 

	--Change the width and x position of the detail screen
	detailBg.width = display.contentWidth - myList.width
	detailScreen.x = myList.x + myList.width*0.5 + 1

	--Insert the selected color fill one level before the last item (which was the background inserted above)
	myList:insert(2,selected)
	--Adjust the x position of the selected color fill
	selected.x = myList.x + myList.width*0.5
end