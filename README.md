# Invisible Encoder/Decoder

An encoder that makes strings invisible, replaces ASCII characters with zero-width unicode characters.

```lua
local Invisible = require('EncoderLibrary')

local string = '动态网自由门 天安門 天安门 法輪功 李洪志 Free Tibet 六四天安門事件 The Tiananmen Square protests of 1989 天安門大屠殺'
local encoded_string = Invisible.encode(string)
local decoded_string = Invisible.decode(encoded_string)

print(string.format('Our string: "%s"', string))
print(string.format('Encoded string: "%s"', encoded_string))
print(string.format('Decoded string: "%s"', decoded_string))

--Output
--[[
  Our string: "动态网自由门 天安門 天安门 法輪功 李洪志 Free Tibet 六四天安門事件 The Tiananmen Square protests of 1989 天安門大屠殺"
  Encoded string: "󠀠󠀣󠀣󠀪󠀠󠀢󠀤󠀩󠀠󠀢󠀧󠀩󠀠󠀣󠀤󠀡󠀠󠀢󠀣󠀩󠀠󠀢󠀣󠀪󠀠󠀣󠀤󠀢󠀠󠀢󠀩󠀪󠀠󠀢󠀥󠀦󠀠󠀣󠀤󠀣󠀠󠀢󠀤󠀦󠀠󠀢󠀨󠀡󠀠󠀣󠀤󠀢󠀠󠀢󠀥󠀩󠀠󠀢󠀨󠀨󠀠󠀣󠀤󠀤󠀠󠀢󠀦󠀢󠀠󠀢󠀧󠀩󠀠󠀤󠀣󠀠󠀣󠀣󠀪󠀠󠀢󠀧󠀥󠀠󠀢󠀧󠀪󠀠󠀣󠀣󠀪󠀠󠀢󠀨󠀥󠀠󠀢󠀤󠀨󠀠󠀣󠀤󠀤󠀠󠀢󠀦󠀡󠀠󠀢󠀣󠀩󠀠󠀤󠀣󠀠󠀣󠀣󠀪󠀠󠀢󠀧󠀥󠀠󠀢󠀧󠀪󠀠󠀣󠀣󠀪󠀠󠀢󠀨󠀥󠀠󠀢󠀤󠀨󠀠󠀣󠀤󠀤󠀠󠀢󠀦󠀢󠀠󠀢󠀧󠀩󠀠󠀤󠀣󠀠󠀣󠀤󠀡󠀠󠀢󠀨󠀪󠀠󠀢󠀥󠀪󠀠󠀣󠀤󠀣󠀠󠀢󠀩󠀩󠀠󠀢󠀨󠀡󠀠󠀣󠀣󠀪󠀠󠀢󠀤󠀩󠀠󠀢󠀦󠀪󠀠󠀤󠀣󠀠󠀣󠀤󠀡󠀠󠀢󠀦󠀨󠀠󠀢󠀥󠀣󠀠󠀣󠀤󠀡󠀠󠀢󠀩󠀡󠀠󠀢󠀨󠀡󠀠󠀣󠀣󠀪󠀠󠀢󠀪󠀢󠀠󠀢󠀦󠀢󠀠󠀤󠀣󠀠󠀨󠀡󠀠󠀢󠀢󠀥󠀠󠀢󠀡󠀢󠀠󠀢󠀡󠀢󠀠󠀤󠀣󠀠󠀩󠀥󠀠󠀢󠀡󠀦󠀠󠀪󠀩󠀠󠀢󠀡󠀢󠀠󠀢󠀢󠀧󠀠󠀤󠀣󠀠󠀣󠀣󠀪󠀠󠀢󠀤󠀤󠀠󠀢󠀨󠀤󠀠󠀣󠀣󠀪󠀠󠀢󠀦󠀦󠀠󠀢󠀦󠀦󠀠󠀣󠀣󠀪󠀠󠀢󠀧󠀥󠀠󠀢󠀧󠀪󠀠󠀣󠀣󠀪󠀠󠀢󠀨󠀥󠀠󠀢󠀤󠀨󠀠󠀣󠀤󠀤󠀠󠀢󠀦󠀡󠀠󠀢󠀣󠀩󠀠󠀣󠀣󠀩󠀠󠀢󠀩󠀧󠀠󠀢󠀤󠀪󠀠󠀣󠀣󠀩󠀠󠀢󠀩󠀨󠀠󠀢󠀩󠀣󠀠󠀤󠀣󠀠󠀩󠀥󠀠󠀢󠀡󠀥󠀠󠀢󠀡󠀢󠀠󠀤󠀣󠀠󠀩󠀥󠀠󠀢󠀡󠀦󠀠󠀪󠀨󠀠󠀢󠀢󠀡󠀠󠀪󠀨󠀠󠀢󠀢󠀡󠀠󠀢󠀡󠀪󠀠󠀢󠀡󠀢󠀠󠀢󠀢󠀡󠀠󠀤󠀣󠀠󠀩󠀤󠀠󠀢󠀢󠀤󠀠󠀢󠀢󠀨󠀠󠀪󠀨󠀠󠀢󠀢󠀥󠀠󠀢󠀡󠀢󠀠󠀤󠀣󠀠󠀢󠀢󠀣󠀠󠀢󠀢󠀥󠀠󠀢󠀢󠀢󠀠󠀢󠀢󠀧󠀠󠀢󠀡󠀢󠀠󠀢󠀢󠀦󠀠󠀢󠀢󠀧󠀠󠀢󠀢󠀦󠀠󠀤󠀣󠀠󠀢󠀢󠀢󠀠󠀢󠀡󠀣󠀠󠀤󠀣󠀠󠀥󠀪󠀠󠀦󠀨󠀠󠀦󠀧󠀠󠀦󠀨󠀠󠀤󠀣󠀠󠀣󠀣󠀪󠀠󠀢󠀧󠀥󠀠󠀢󠀧󠀪󠀠󠀣󠀣󠀪󠀠󠀢󠀨󠀥󠀠󠀢󠀤󠀨󠀠󠀣󠀤󠀤󠀠󠀢󠀦󠀡󠀠󠀢󠀣󠀩󠀠󠀣󠀣󠀪󠀠󠀢󠀧󠀥󠀠󠀢󠀧󠀨󠀠󠀣󠀣󠀪󠀠󠀢󠀨󠀨󠀠󠀢󠀧󠀡󠀠󠀣󠀤󠀡󠀠󠀢󠀨󠀥󠀠󠀢󠀩󠀧󠀠󠀢󠀡"
  Decoded string: "动态网自由门 天安門 天安门 法輪功 李洪志 Free Tibet 六四天安門事件 The Tiananmen Square protests of 1989 天安門大屠殺"
]]
```
