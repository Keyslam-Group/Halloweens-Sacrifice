function love.conf(t)
   t.identity     = "Halloween's Sacrifice"
   t.version      = "11.2"
   t.console      = false
   t.gammacorrect = true

   t.window.title  = "Halloween's Sacrifice"
   t.window.width  = 1280
   t.window.height = 720
   t.window.vsync  = 0

   t.modules.audio    = true
   t.modules.data     = true
   t.modules.event    = true
   t.modules.font     = true
   t.modules.graphics = true
   t.modules.image    = true
   t.modules.joystick = true
   t.modules.keyboard = true
   t.modules.math     = true
   t.modules.mouse    = true
   t.modules.sound    = true
   t.modules.system   = true
   t.modules.timer    = true
   t.modules.window   = true

   t.modules.physics = false
   t.modules.touch   = false
   t.modules.video   = false
   t.modules.thread  = false
end
