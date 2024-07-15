function FancyError()
  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1, 1)
  print("Can't connect to github.com")
end

response = http.get("https://raw.githubusercontent.com/ma3rxofficial/CCStuff/main/Installer/Installer.lua")

if not response then
	FancyError()
end

file = fs.open("Installer.lua", "w")
file.write(response.readAll())
file.close()

shell.run("Installer.lua")
