local lz    = require("zlib")

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

logger=MOAILogMgr
logger:setLogLevel(MOAILogMgr.LOG_STATUS)
logger:log ("Loaded")

function onFinish ( task, responseCode )

	print ( "onFinish" )
	print ( responseCode )

	if ( task:getSize ()) then
		filecontents=( task:getString ())
		--print (filecontents)
		local file = io.open("download.lua", "w")
		file:write(filecontents)
		file:close()
		dofile ("download.lua")
	else
		print ( "nothing" )
	end
end

function getZip(filename,url)
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
assert(c:setopt(curl.OPT_HTTPHEADER, "Connection: Keep-Alive", "Accept-Language: en-us"));
assert(c:setopt(curl.OPT_URL, url));
assert(c:setopt(curl.OPT_CONNECTTIMEOUT, 15));
assert(c:perform());
assert(c:close()); -- not necessary, as will be garbage collected soon
s="abcd$%^&*()";
assert(s == assert(curl.unescape(curl.escape(s))));
file:close();
c=nil
print ("Image downloaded="..filename)
end

function ExtractZipAndCopyFiles(zipPath, zipFilename, destinationPath)
    local zfile, err = zip.open(zipPath .. zipFilename)

	print "Opened zip"
	
    -- iterate through each file insize the zip file
    for file in zfile:files() do
        local currFile, err = zfile:open(file.filename)
        local currFileContents = currFile:read("*a") -- read entire contents of current file
        local hBinaryOutput = io.open(destinationPath .. file.filename, "wb")

        -- write current file inside zip to a file outside zip
        if(hBinaryOutput)then
            hBinaryOutput:write(currFileContents)
            hBinaryOutput:close()
        end
    end

    zfile:close()
end

getZip("graphics.zip","http://www.innovationtech.co.uk/moai/graphics.zip")

ExtractZipAndCopyFiles("", "graphics.zip", "")
