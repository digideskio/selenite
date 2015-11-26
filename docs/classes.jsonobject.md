## json.object

Stores and manipulates a JSON object.

### Methods

* **getjson** ( ): Returns the JSON object as a string. Alternatively, you can use the Lua tostring() function.
* **load** ( s ): Loads a JSON object from a string.
* **loadfromfile** ( filename ): Loads a JSON object from a file.
* **savetofile** ( filename ): Saves the JSON object to a file.

### Properties

* **akey**: Gets or sets the value of a key.

### Usage Example

```lua
local s = require "Selenite"
local j = s.json.object:new()
j['name.first'] = 'Carla'
j['name.last'] = 'Coe'
j.year = 2013
print(tostring(j))
--[[
this will print:
{
 "year": 2013,
 "name": {
  "first": "Carla",
  "last": "Coe"
 }
}
]]
j:release()
```