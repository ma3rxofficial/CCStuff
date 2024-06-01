--[[
      Демонстрация работы библиотеки buffering, которая уменьшает
      общее количество обращений к библиотеке term, записывая ее значения,
      и изменяя их только в том случае, если заданные пользователем
      значения отличаются от записанных. Короче говоря - буфферизация!
]]

SpeedOS.LoadAPI("SpeedAPI/buffering")

buffering.setBackgroundColor(colors.white)
term.clear()

buffering.setTextColor(colors.black)
buffering.setCursorPos(1, 1)

term.write("Hello, World!")
buffering.setCursorPos(1, 2)
print("Background Color: "..buffering.backgroundColor)
print("Text Color: "..buffering.textColor)
