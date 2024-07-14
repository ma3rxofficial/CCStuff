function FancyError()
  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1, 1)
  print("Can't connect to github.com")
end

zapros = http.get("https://raw.githubusercontent.com/ma3rxofficial/CCStuff/main/Installer/Installer.lua")

if not zapros then
	FancyError()
end

file = fs.open("Installer.lua", "w")
file.write(zapros.readAll())
file.close()

shell.run("Installer.lua")
