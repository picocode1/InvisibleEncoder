# Invisible Encoder/Decoder

An encoder that makes strings invisible, replaces ASCII characters with zero-width unicode characters, also has an edited base64


```lua
local Invisible = require('Library')

local string = 'Hello World!'
local encoded_string = Invisible.encode(string)
local decoded_string = Invisible.decode(encoded_string)

local b64string =  Invisible.pog64(string)
local b64encoded_string =  Invisible.pog64(Invisible.encode(string))
local b64decoded_string =  Invisible.pog64(Invisible.decode(encoded_string))

print(string.format('Our string: "%s"', string))
print(string.format('Encoded string: "%s"', encoded_string))
print(string.format('Decoded string: "%s"\nBase64', decoded_string))

print(string.format('Our string: "%s"', b64string))
print(string.format('Encoded string: "%s"', b64encoded_string))
print(string.format('Decoded string: "%s"', b64decoded_string))

--Output
--[[
  Our string: "Hello World!"
  Encoded string: "󠁈󠁥󠁬󠁬󠁯󠀠󠁗󠁯󠁲󠁬󠁤󠀡"
  Decoded string: "Hello World!"

  Base64
  Our string: "AEgAZQBsAGwAbwAgAFcAbwByAGwAZAAh"
  Encoded string: "APMAoACBAIgA8wCgAIEApQDzAKAAgQCsAPMAoACBAKwA8wCgAIEArwDzAKAAgACgAPMAoACBAJcA8wCgAIEArwDzAKAAgQCyAPMAoACBAKwA8wCgAIEApADzAKAAgACh"
  Decoded string: "AEgAZQBsAGwAbwAgAFcAbwByAGwAZAAh"
]]
```
