sClockIn = "left"
sClockOut = "bottom"
sDataIn = "right"
sDataOut = "top"
sUserName = "???"

local bClock = false
local a = {}
local b = {}
local aPorts = {}

local aChat = { [1] = "<SYS> Welcome to MC-Chat! (Pause/Break to exit)" }
local nChatLine = 1

local sMessageOut = ""
local bRunning = true
local nBitCount = 0
local sBits = ""
local bIncoming = false
local sIncoming = ""

for n=1,8 do
  table.insert(b, 0)
  table.insert(aPorts, 0)
end

for n=0,255 do
  table.insert(a, 0)
  a[n] = b[1] .. b[2] .. b[3] .. b[4] .. b[5] .. b[6] .. b[7] .. b[8]
  b[8] = b[8] + 1
  for n2=1,7 do
    if b[9-n2] == 2 then
      b[9-n2] = 0
      b[8-n2] = b[8-n2] + 1
    end
  end
end


local function Int2Bin(int)
  return a[int]
end

local function ClockPulse(bC)
  sleep(0.005)
  redstone.setOutput(sClockOut, bC)
end  

local function chatBox()
  term.setCursorPos( 1, 17 )
  term.clearLine()
  for n=1,49 do
    io.write("-")
  end
end

local function addChat(str)
  if nChatLine < 16 then
    table.insert(aChat, str)
    nChatLine = nChatLine + 1
  else
    for n=1,15 do
      aChat[n] = aChat[n+1]
    end
    aChat[16] = str
  end
end


local function writeLine()
  term.setCursorPos( 1, 18 )
  term.clearLine()
  io.write("msg> " .. sMessageOut)
end

local function writeChat()
  term.setCursorPos( 1, 1 )
  for n=1,nChatLine do
    term.clearLine()
    print(aChat[n])
  end
end

local function writeSendLine()
  term.setCursorPos( 1, 18 )
  term.clearLine()
  io.write("<SENDING>" .. sMessageOut)
end

local function writeGetLine()
  term.setCursorPos( 1, 18 )
  term.clearLine()
  io.write("<INCOMIMG DATA>")
end

local function dataOut(str)
  bClock = false
  local sData = ""

  for n=1,string.len(str) do
    sData = sData .. Int2Bin(string.byte(string.sub(str,n,n)))
  end

  sData = sData .. "00000000"

  local nCount = string.len(sData)
  sleep(0.1)
  for n=1,nCount do
    if bClock == true then
      bClock = false
    else
      bClock = true
    end
    if string.sub(sData,n,n) == "1" then
      redstone.setOutput(sDataOut, true)
      ClockPulse(bClock)
      sleep(0.01)
    else
      redstone.setOutput(sDataOut, false)
      ClockPulse(bClock)
      sleep(0.01)
    end
  end
  bClock = false
  redstone.setOutput(sDataOut, false)
  redstone.setOutput(sClockOut, false)
end


term.clear()
term.setCursorPos( 1, 1 )
term.setCursorBlink( true )
chatBox()
writeChat()
writeLine()
while bRunning do
  local sEvent, param = os.pullEvent()
  if bIncoming == false then
    bClock = false
    if sEvent == "key" then
      if param == 197 then
        bRunning = false
      elseif param == 28 then
        if string.sub(sMessageOut,1,1) == "/" then
          if string.sub(sMessageOut,1,6) == "/name " then
            if string.len(sMessageOut) > 6 then
              if string.len(sMessageOut) < 13 then
                sUserName = string.sub(sMessageOut,7,string.len(sMessageOut))
                addChat("<SYS> Name changed to '" .. sUserName .. "'.")
              else
                addChat("<SYS> Name too long.(Limit 6 characters)")
              end
            end
          end
          sMessageOut = ""
          writeChat()
          writeLine()
        else
          if string.len(sMessageOut) > 0 then
            writeSendLine()
            sMessageOut = sUserName .. "> " .. sMessageOut
            addChat(sMessageOut)
            dataOut(sMessageOut)
            sMessageOut = ""
            writeChat()
            writeLine()
          end
        end
      elseif param == 14 then
        sMessageOut = string.sub(sMessageOut,1,string.len(sMessageOut)-1)
        writeLine()
      end
    end

    if sEvent == "char" then
      if string.len(sMessageOut) < 40 then
        sMessageOut = sMessageOut .. param
      end
      writeLine()
    end
  else
    if sEvent == "key" then
      if param == 207 then
        bIncoming = false
        sIncoming = ""
        writeChat()
        writeLine()
      end
    end
  end
  
  if sEvent == "redstone" then
    if redstone.getInput(sClockIn) ~= bClock then
      bClock = redstone.getInput(sClockIn)
      if bIncoming == false then
        bIncoming = true
        writeGetLine()
      end
      if redstone.getInput(sDataIn) then
        sBits = sBits .. "1"
        nBitCount = nBitCount + 1
      else
        sBits = sBits .. "0"
        nBitCount = nBitCount + 1
      end
      if nBitCount == 8 then
        if sBits == "00000000" then
          bIncoming = false
          addChat(sIncoming)
          sIncoming = ""
          writeChat()
          writeLine()
        else
          sIncoming = sIncoming .. string.char(tonumber(sBits,2))
        end
        sBits = ""
        nBitCount = 0
      end
    end
  end
end
term.clear()
term.setCursorPos( 1, 1 )