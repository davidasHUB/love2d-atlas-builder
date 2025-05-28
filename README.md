## atlas builder modified 

this is a modified version of the [atlas builder](https://github.com/elloramir/packer) made by [ello](https://github.com/elloramir?tab=repositories)
my goals with this modification was...

- make the atlas builder works in new löve versions

i addead [nativefs](https://github.com/EngineerSmith/nativefs) to the project, the *io* lib doesn't work
because of sandboxed nature of löve2d.

- make a better serialization

the original implematation was really simple using only a tag system and that it...

### original
```lua
return {
  ["test_images/pipo-nekonin016.png"] = {x = 288, y = 128, w = 96, h = 128},
  ["test_images/pipo-nekonin020.png"] = {x = 96, y = 384, w = 96, h = 128},
  ["test_images/pipo-nekonin019.png"] = {x = 96, y = 256, w = 96, h = 128},
  ["test_images/pipo-nekonin018.png"] = {x = 0, y = 256, w = 96, h = 128},
  ["test_images/pipo-nekonin017.png"] = {x = 288, y = 0, w = 96, h = 128},
  ["test_images/pipo-nekonin007.png"] = {x = 0, y = 384, w = 96, h = 128},
  ["test_images/pipo-nekonin004.png"] = {x = 480, y = 0, w = 96, h = 128},
  ["test_images/pipo-nekonin006.png"] = {x = 480, y = 128, w = 96, h = 128},
  ["test_images/pipo-nekonin005.png"] = {x = 480, y = 256, w = 96, h = 128},
  ["test_images/pipo-nekonin002.png"] = {x = 384, y = 128, w = 96, h = 128},
  ["test_images/pipo-nekonin008.png"] = {x = 288, y = 256, w = 96, h = 128},
  ["test_images/pipo-nekonin001.png"] = {x = 0, y = 0, w = 96, h = 128},
  ["test_images/pipo-nekonin003.png"] = {x = 384, y = 0, w = 96, h = 128},
  ["test_images/pipo-nekonin009.png"] = {x = 384, y = 256, w = 96, h = 128},
  ["test_images/pipo-nekonin010.png"] = {x = 192, y = 256, w = 96, h = 128},
  ["test_images/pipo-nekonin011.png"] = {x = 96, y = 128, w = 96, h = 128},
  ["test_images/pipo-nekonin012.png"] = {x = 0, y = 128, w = 96, h = 128},
  ["test_images/pipo-nekonin013.png"] = {x = 192, y = 0, w = 96, h = 128},
  ["test_images/pipo-nekonin014.png"] = {x = 96, y = 0, w = 96, h = 128},
  ["test_images/pipo-nekonin015.png"] = {x = 192, y = 128, w = 96, h = 128},
}
}
```

... in the new version every time a image ends with a number the system understands this a animation sequence
and tries to bundle all the frames in a single list.

### new 
```lua
return {
	["pipo-nekonin"] = {
		{ frame_name = "pipo-nekonin001", number = 1 , x = 0, y = 0, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin002", number = 2 , x = 384, y = 128, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin003", number = 3 , x = 384, y = 0, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin004", number = 4 , x = 480, y = 0, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin005", number = 5 , x = 480, y = 256, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin006", number = 6 , x = 480, y = 128, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin007", number = 7 , x = 0, y = 384, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin008", number = 8 , x = 288, y = 256, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin009", number = 9 , x = 384, y = 256, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin010", number = 10 , x = 192, y = 256, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin011", number = 11 , x = 96, y = 128, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin012", number = 12 , x = 0, y = 128, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin013", number = 13 , x = 192, y = 0, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin014", number = 14 , x = 96, y = 0, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin015", number = 15 , x = 192, y = 128, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin016", number = 16 , x = 288, y = 128, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin017", number = 17 , x = 288, y = 0, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin018", number = 18 , x = 0, y = 256, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin019", number = 19 , x = 96, y = 256, w = 96, h = 128 },
		{ frame_name = "pipo-nekonin020", number = 20 , x = 96, y = 384, w = 96, h = 128 },
	},
}
```

this makes accesing frames a bit more easy and is really useful for making animations systems

```lua
	
local serial= require "serial"
	
function love.load()
	local frame_one = serial["pipo-nekokin"][1]
end 

```


#TODO
- [x] lua module target
- [ ] json target 
- [ ] c array target 
- [ ] Odin target 

### credits/links

- [atlas builder(original)](https://github.com/elloramir/packer)
- [ello(original creator)](https://github.com/elloramir?tab=repositories)

- [test images](https://pipoya.itch.io/pipoya-free-rpg-character-sprites-nekonin)
- [article about binary packing](https://codeincomplete.com/articles/bin-packing/)
- [cripboy](https://github.com/cripboy)
- [nativefs](https://github.com/EngineerSmith/nativefs)
