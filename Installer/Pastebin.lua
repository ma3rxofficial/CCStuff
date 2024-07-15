-----------------------------------------------------------------------------------------------------------------------------------
-- Функция вывода ошибки о недоступности сайта github.com на пользовательском компьютере

function FancyError()
  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1, 1)
  print("Can't connect to github.com")
end

-----------------------------------------------------------------------------------------------------------------------------------
-- Делаем запрос для скачивания инсталлера и проверяем наличие ответа сервера

local response = http.get("https://raw.githubusercontent.com/ma3rxofficial/CCStuff/main/Installer/Installer.lua")

if not response then
	FancyError()
end

-----------------------------------------------------------------------------------------------------------------------------------
-- Создаем и запускаем скачанный файл Installer.lua

file = fs.open("Installer.lua", "w")
file.write(response.readAll())
file.close()

shell.run("Installer.lua")

-----------------------------------------------------------------------------------------------------------------------------------
