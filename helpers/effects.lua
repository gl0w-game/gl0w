local effects = {}
local moonshine = require "libs/moonshine"
effects.oldtv = moonshine(moonshine.effects.scanlines({pixel_size = 5})).chain(moonshine.effects.crt())
effects.godsray = moonshine(moonshine.effects.godsray({exposure = 2, decay = 0.91}))
effects.godsrayActive = moonshine(moonshine.effects.godsray({exposure = 25, decay = 0.95}))
return effects