local _term = term

--Central Printing--
function cPrint(string, y2, _term)
	if _term == nil then
		_term = term
	end

    local tX, tY = _term.getSize()
    local b = string.len(string) / 2
    local x = (tX / 2) - b
	local y = tY / 2
	
	if y2 then
	  y = y2
	end

    _term.setCursorPos(x, y)
    _term.write(string)
end

--Central Cursoring--
function cCursor(string, _term)
	if _term == nil then
		_term = term
	end

        local tX, tY = _term.getSize()
        local b = string.len(string) / 2
        local x = (tX / 2) - b
	local y = tY / 2
	
	if y2 then
	  y = y2
	end

        return {x, y}
end

--Line of "-" printing--
function line(_term)
	if _term == nil then
		_term = term
	end

	if _term == term then
		print("---------------------------------------------------")
	else
		_term.write("---------------------------------------------------")
	end
end

--Line of " " printing--
function line2(_term)
	if _term == nil then
		_term = term
	end

	if _term == term then
		print("                                                  ")
	else
		_term.write("                                                  ")
	end
end

--Normal time returning-
function time(use_pindos)
    local time = os.time()
    formattedTime = textutils.formatTime(time, false)

    if use_pindos == true then
    	local formattedTime = textutils.formatTime(time, true)
    end

	return formattedTime
end

--Time with custom char--
function extraFormatTime( nTime, char, bTwentyFourHour )
	local sTOD = nil
	if not bTwentyFourHour then
		if nTime >= 12 then
			sTOD = "PM"
		else
			sTOD = "AM"
		end
		if nTime >= 13 then
			nTime = nTime - 12
		end
	end

	local nHour = math.floor(nTime)
	local nMinute = math.floor((nTime - nHour)*60)
	if sTOD then
		return string.format( "%d"..char.."%02d %s", nHour, nMinute, sTOD )
	else
		return string.format( "%d"..char.."%02d", nHour, nMinute )
	end
end

--Time & date--

function getDate()

local worldDays = os.day()
local month = 1
local day = worldDays
local year = 1
local leap = 28

-- get Year
i = 1
daysInYear = 365
while day > daysInYear do
if 1 < 4 then
daysInYear = 365
i = i + 1
leap = 28
else
daysInYear = 366
i = 1
leap = 29
end
year = year + 1
day = day - daysInYear
end

-- get Month
-- January
if day > 31 then
day = day - 31
month = month + 1
end
-- February
if day > leap then
day = day - leap
month = month + 1
end
-- March
if day > 31 then
day = day - 31
month = month + 1
end
-- April
if day > 30 then
day = day - 30
month = month + 1
end
-- May
if day > 31 then
day = day - 31
month = month + 1
end
-- June
if day > 30 then
day = day - 30
month = month + 1
end
-- July
if day > 31 then
day = day - 31
month = month + 1
end
-- August
if day > 31 then
day = day - 31
month = month + 1
end
-- September
if day > 30 then
day = day - 30
month = month + 1
end
-- October
if day > 31 then
day = day - 31
month = month + 1
end
-- November
if day > 30 then
day = day - 30
month = month + 1
end
-- December
if day > 31 then
day = day - 31
month = 1
year = year + 1
end

return day,month,year
end

function time_and_date(burzhui) 
	den, mesyac, god = getDate()
	if not burzhui then
		return tostring(den).."/"..tostring(mesyac).."/"..tostring(god).." "..time(false)
	else
		return tostring(den).."/"..tostring(mesyac).."/"..tostring(god).." "..time(true)
	end
end

--Get date without time--
function get_date() 
	den, mesyac, god = getDate()
	return tostring(den).."/"..tostring(mesyac).."/"..tostring(god)
end

--Extra exiting from program--
function extraExit(_term)
	if _term == nil then
		_term = term
	end

	_term.setBackgroundColor(colors.black)
	_term.setTextColor(colors.white)
	_term.setCursorPos(1, 1)
	_term.clear()
	error()
end

--HUY--
local function modRead(properties, char, _term)
	if _term == nil then
		_term = term
	end

	local w, h = _term.getSize()
	local defaults = {replaceChar = char, history = nil, visibleLength = nil, textLength = nil, 
		liveUpdates = nil, exitOnKey = nil}
	if not properties then properties = {} end
	for k, v in pairs(defaults) do if not properties[k] then properties[k] = v end end
	if properties.replaceChar then properties.replaceChar = properties.replaceChar:sub(1, 1) end
	if not properties.visibleLength then properties.visibleLength = w end

	local sx, sy = _term.getCursorPos()
	local line = ""
	local pos = 0
	local historyPos = nil

	local function redraw(repl)
		local scroll = 0
		if properties.visibleLength and sx + pos > properties.visibleLength + 1 then 
			scroll = (sx + pos) - (properties.visibleLength + 1)
		end

		_term.setCursorPos(sx, sy)
		local a = repl or properties.replaceChar
		if a then _term.write(string.rep(a, line:len() - scroll))
		else _term.write(line:sub(scroll + 1, -1)) end
		_term.setCursorPos(sx + pos - scroll, sy)
	end

	local function sendLiveUpdates(event, ...)
		if type(properties.liveUpdates) == "function" then
			local ox, oy = _term.getCursorPos()
			local a, data = properties.liveUpdates(line, event, ...)
			if a == true and data == nil then
				_term.setCursorBlink(false)
				return line
			elseif a == true and data ~= nil then
				_term.setCursorBlink(false)
				return data
			end
			_term.setCursorPos(ox, oy)
		end
	end

	_term.setCursorBlink(true)
	while true do
		local e, but, x, y, p4, p5 = os.pullEvent()

		if e == "char" then
			local s = false
			if properties.textLength and line:len() < properties.textLength then s = true
			elseif not properties.textLength then s = true end

			local canType = true
			if not properties.grantPrint and properties.refusePrint then
				local canTypeKeys = {}
				if type(properties.refusePrint) == "table" then
					for _, v in pairs(properties.refusePrint) do
						table.insert(canTypeKeys, tostring(v):sub(1, 1))
					end
				elseif type(properties.refusePrint) == "string" then
					for char in properties.refusePrint:gmatch(".") do
						table.insert(canTypeKeys, char)
					end
				end
				for _, v in pairs(canTypeKeys) do if but == v then canType = false end end
			elseif properties.grantPrint then
				canType = false
				local canTypeKeys = {}
				if type(properties.grantPrint) == "table" then
					for _, v in pairs(properties.grantPrint) do
						table.insert(canTypeKeys, tostring(v):sub(1, 1))
					end
				elseif type(properties.grantPrint) == "string" then
					for char in properties.grantPrint:gmatch(".") do
						table.insert(canTypeKeys, char)
					end
				end
				for _, v in pairs(canTypeKeys) do if but == v then canType = true end end
			end

			if s and canType then
				line = line:sub(1, pos) .. but .. line:sub(pos + 1, -1)
				pos = pos + 1
				redraw()
			end
		elseif e == "key" then
			if but == keys.enter then break
			elseif but == keys.left then if pos > 0 then pos = pos - 1 redraw() end
			elseif but == keys.right then if pos < line:len() then pos = pos + 1 redraw() end
			elseif (but == keys.up or but == keys.down) and properties.history then
				redraw(" ")
				if but == keys.up then
					if historyPos == nil and #properties.history > 0 then 
						historyPos = #properties.history
					elseif historyPos > 1 then 
						historyPos = historyPos - 1
					end
				elseif but == keys.down then
					if historyPos == #properties.history then historyPos = nil
					elseif historyPos ~= nil then historyPos = historyPos + 1 end
				end

				if properties.history and historyPos then
					line = properties.history[historyPos]
					pos = line:len()
				else
					line = ""
					pos = 0
				end

				redraw()
				local a = sendLiveUpdates("history")
				if a then return a end
			elseif but == keys.backspace and pos > 0 then
				redraw(" ")
				line = line:sub(1, pos - 1) .. line:sub(pos + 1, -1)
				pos = pos - 1
				redraw()
				local a = sendLiveUpdates("delete")
				if a then return a end
			elseif but == keys.home then
				pos = 0
				redraw()
			elseif but == keys.delete and pos < line:len() then
				redraw(" ")
				line = line:sub(1, pos) .. line:sub(pos + 2, -1)
				redraw()
				local a = sendLiveUpdates("delete")
				if a then return a end
			elseif but == keys["end"] then
				pos = line:len()
				redraw()
			elseif properties.exitOnKey then 
				if but == properties.exitOnKey or (properties.exitOnKey == "control" and 
						(but == 29 or but == 157)) then 
					_term.setCursorBlink(false)
					return nil
				end
			end
		end
		local a = sendLiveUpdates(e, but, x, y, p4, p5)
		if a then return a end
	end

	_term.setCursorBlink(false)
	if line ~= nil then line = line:gsub("^%s*(.-)%s*$", "%1") end
	return line
end



--Better version of inputs--
function centerRead(wid, begt, buttonColor, buttonTextColor, buttonTextInputColor, cancelEnabled, cancelColor, cancelTextColor, char, startChar, _term)
	if _term == nil then
		_term = term
	end
	local w, h = _term.getSize()
	local function liveUpdate(line, e, but, x, y, p4, p5)
		if _term.isColor() and e == "mouse_click" and x >= w/2 - wid/2 and x <= w/2 - wid/2 + 10 
				and y >= 13 and y <= 15 then
			return true, ""
		end
	end

	if not buttonColor then
		buttonColor = colors.gray
	end
	if not buttonTextColor then
		buttonTextColor = colors.white
	end
	if not buttonTextInputColor then
		buttonTextInputColor = colors.white
	end
	if not cancelColor then
		cancelColor = colors.red
	end
	if not cancelTextColor then
		cancelTextColor = colors.white
	end		

	if not begt then 
		begt = "" 
	end

	if not startChar then
		startChar = "> "
	end

	_term.setTextColor(buttonTextColor)
	_term.setBackgroundColor(buttonColor)

	for i = 8, 10 do
		_term.setCursorPos(w/2 - wid/2, i)
		_term.write(string.rep(" ", wid))
	end

	if _term.isColor() and cancelEnabled then
		_term.setBackgroundColor(cancelColor)
		_term.setTextColor(cancelTextColor)
		for i = 13, 15 do
			_term.setCursorPos(w/2 - wid/2 + 1, i)
			_term.write(string.rep(" ", 10))
		end
		_term.setCursorPos(w/2 - wid/2 + 2, 14)
		_term.write("> Cancel")
	end

	_term.setBackgroundColor(buttonColor)
	_term.setTextColor(buttonTextColor)
	_term.setCursorPos(w/2 - wid/2 + 1, 9)
	_term.write(startChar .. begt)
	_term.setTextColor(buttonTextInputColor)
	return modRead({visibleLength = w/2 + wid/2, liveUpdates = liveUpdate}, char)
end

--Slow printing init--
function _write( sText , _term)
	if _term == nil then
		_term = term
	end
	local w,h = _term.getSize()		
	local x,y = _term.getCursorPos()
	
	local nLinesPrinted = 0
	local function newLine()
		if y + 1 <= h then
			_term.setCursorPos(1, y + 1)
		else
			_term.setCursorPos(1, h)
			_term.scroll(1)
		end
		x, y = _term.getCursorPos()
		nLinesPrinted = nLinesPrinted + 1
	end
	
	-- Print the line with proper word wrapping
	while string.len(sText) > 0 do
		local whitespace = string.match( sText, "^[ \t]+" )
		if whitespace then
			-- Print whitespace
			_term.write( whitespace )
			x,y = _term.getCursorPos()
			sText = string.sub( sText, string.len(whitespace) + 1 )
		end
		
		local newline = string.match( sText, "^\n" )
		if newline then
			-- Print newlines
			newLine()
			sText = string.sub( sText, 2 )
		end
		
		local text = string.match( sText, "^[^ \t\n]+" )
		if text then
			sText = string.sub( sText, string.len(text) + 1 )
			if string.len(text) > w then
				-- Print a multiline word				
				while string.len( text ) > 0 do
					if x > w then
						newLine()
					end
					_term.write( text )
					text = string.sub( text, (w-x) + 2 )
					x,y = _term.getCursorPos()
				end
			else
				-- Print a word normally
				if x + string.len(text) - 1 > w then
					newLine()
				end
				_term.write( text )
				x,y = _term.getCursorPos()
			end
		end
	end
	
	return nLinesPrinted
end

--Slow printing--
function slowWrite( sText, nRate, _term )
	if _term == nil then
		_term = term
	end

    if nRate ~= nil and type( nRate ) ~= "number" then
        error( "bad argument #2 (expected number, got " .. type( nRate ) .. ")", 2 )
    end
    nRate = nRate or 20
    if nRate < 0 then
        error( "Rate must be positive", 2 )
    end

    local nSleep = 1 / nRate
        
    sText = tostring( sText )
    local x,y = _term.getCursorPos()
    local len = string.len( sText )
    
    for n=1,len do
        _term.setCursorPos( x, y )
        sleep( nSleep )
        local nLines = _write( string.sub( sText, 1, n ) , _term)
        local newX, newY = _term.getCursorPos()
        y = newY - nLines
    end
end

-- I recommend you to use this!
function slowPrint( sText, nRate, _term)
	if _term == nil then
			_term = term
	end
    slowWrite( sText, nRate , _term)
    print()
end

--Wait for some events--
function waitForEvent(event_list)
	local function pizda(ivent)
		for _, ivent2 in pairs(event_list) do
			if ivent2 == ivent then
				return true
			end
		end

		return false
	end

	local result_dolbaeba

	while true do
		event = os.pullEvent()

		if pizda(event) then
			result_dolbaeba = event
			break
		end
	end

	return result_dolbaeba
end

--Convert string to color--
function stringToColor(_string)
	return colors[_string]
end

--Convert string to boolean--
function stringToBoolean(_string)
	if string.lower(_string) == "true" then
		return true
	elseif string.lower(_string) == "false" then
		return false
	end
end
