-- Pastebin version

function FancyError()
  term.setBackgroundColor(colours.grey)
  term.setTextColor(colours.white)
  term.clear()
  term.setCursorPos(2,2)

  print("Failed to connect to the GitHub!\n\n")
  term.setTextColour(colours.lightGrey)
  term.setCursorPos(2,4)

  print("An error occured while trying to")
  term.setCursorPos(2,5)
  print("connect to the server.")

  term.setCursorPos(2,6)
  print("Check the following things then try again:")

  term.setTextColour(colours.white)
  term.setCursorPos(1,8)
  print(" - Check that your internet is online and working")
  print(" - Ensure that the HTTP API is on")
  print(" - Ensure that github.com is whitelisted")
  print(" - Try accesing github.com in your browser")

  term.setCursorPos(2,18-1)
  term.setTextColour(colours.white)
  print(" Click anywhere to exit...")
  os.pullEvent("mouse_click")
  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1, 1)
  error()
end

zapros = http.get("https://raw.githubusercontent.com/ma3rxofficial/CCStuff/main/Installer/Installer.lua")

if not zapros then
	FancyError()
end

file = fs.open("Installer.lua", "w")
file.write(zapros.readAll())
file.close()

shell.run("installer")
