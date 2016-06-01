## Cheatcode
Add konami code style cheatcodes to your game. Intended for [LÖVE](https://love2d.org/)


## Usage
```lua
Cheatcode = require('cheatcode')

local codes = {}
codes['{up}{up}{down}{down}{left}{right}{left}{right}ba{return}'] = function() lives = lives + 99 end
codes.bighead = function() bighead = not bighead end
Cheatcode(codes)

function love.keypressed(key)
  Cheatcode.handle(key)
end
```

## Performance

Since this runs on every keypress, performance is important.

Don't worry, it runs in constant time `O(1)`! Feel free to add all the cheatcodes you want.

