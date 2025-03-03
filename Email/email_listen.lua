function split(str, pat)   
  local t = { }
  local fpat = "(.-)"..pat
  local last_end = 1
  local s, e, cap = str:find(fpat, 1)
  while s do
    if s~=1 or cap ~= "" then
      table.insert(t, cap)
    end
    last_end = e+1
    s, e, cap = str:find(fpat, last_end)
  end
  if last_end <= #str then
    cap = str:sub(last_end)
    table.insert(t, cap)
  end
  return t
end

rednet.open("top")
rednet.send(434, "$REQUEST")

id, msg = rednet.receive()

msg = string.gsub(msg, "$RESPONSE", "")
print("Message:\n"..msg)
io.read()

t = split(msg, "!SP!")
for i=1,table.getn(t),1 do
  print(t[i])
end

emailn = table.getn(t)/3
print("Received "..emailn.." emails.")

for i=1,table.getn(t),3 do
  print("From: "..t[i])
  print("At:"..t[i+1])
  print(t[i+2].."\n")
  print("Hit a key for the next message")
  io.read()
end
