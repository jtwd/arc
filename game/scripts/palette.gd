class_name Palette
extends Resource

## One age's colours. Everything visual in the game reads from one of these,
## so an age is a palette plus a room pool, not an asset set.

@export var name_id: String = "stone"

@export var paper: Color
@export var sky: Color
@export var sky_lo: Color
@export var horizon: Color
@export var ground: Color
@export var ground_shade: Color
@export var patch: Color
@export var patch_shade: Color
@export var rock: Color
@export var rock_shade: Color
@export var tuft: Color
@export var tuft_shade: Color
@export var skin: Color
@export var skin_shade: Color
@export var hide: Color
@export var hide_shade: Color
@export var hair: Color
@export var hair_shade: Color
@export var wood: Color
@export var wood_shade: Color
@export var stone_head: Color
@export var stone_head_shade: Color
@export var shadow: Color
@export var glow: Color


static func stone() -> Palette:
	var p := Palette.new()
	p.name_id = "Stone"
	p.paper = Color.html("#EDE6D6")
	p.sky = Color.html("#C6D4DD")
	p.sky_lo = Color.html("#A9BECD")
	p.horizon = Color.html("#DCE6EA")
	p.ground = Color.html("#E2E9EC")
	p.ground_shade = Color.html("#B9CBD6")
	p.patch = Color.html("#D2E0E6")
	p.patch_shade = Color.html("#A8BFCC")
	p.rock = Color.html("#93A1AB")
	p.rock_shade = Color.html("#64737F")
	p.tuft = Color.html("#9DAE9F")
	p.tuft_shade = Color.html("#6E8071")
	p.skin = Color.html("#C68C5F")
	p.skin_shade = Color.html("#9A6540")
	p.hide = Color.html("#AC7348")
	p.hide_shade = Color.html("#7C4F2F")
	p.hair = Color.html("#3B2A1C")
	p.hair_shade = Color.html("#241810")
	p.wood = Color.html("#8A6440")
	p.wood_shade = Color.html("#5C4026")
	p.stone_head = Color.html("#9AA3A8")
	p.stone_head_shade = Color.html("#6B757B")
	p.shadow = Color.html("#2E2419")
	p.glow = Color.html("#E28E3E")
	return p


static func rivers() -> Palette:
	var p := Palette.new()
	p.name_id = "Rivers"
	p.paper = Color.html("#F1E5CB")
	p.sky = Color.html("#E7CC92")
	p.sky_lo = Color.html("#D3AE6B")
	p.horizon = Color.html("#F0DFB4")
	p.ground = Color.html("#E9D6AA")
	p.ground_shade = Color.html("#C7A469")
	p.patch = Color.html("#DFC894")
	p.patch_shade = Color.html("#B8934F")
	p.rock = Color.html("#C08A4E")
	p.rock_shade = Color.html("#8A5C30")
	p.tuft = Color.html("#6FA894")
	p.tuft_shade = Color.html("#437C6A")
	p.skin = Color.html("#C68C5F")
	p.skin_shade = Color.html("#9A6540")
	p.hide = Color.html("#AC7348")
	p.hide_shade = Color.html("#7C4F2F")
	p.hair = Color.html("#3B2A1C")
	p.hair_shade = Color.html("#241810")
	p.wood = Color.html("#8A6440")
	p.wood_shade = Color.html("#5C4026")
	p.stone_head = Color.html("#B99A6A")
	p.stone_head_shade = Color.html("#8A6F46")
	p.shadow = Color.html("#2E2419")
	p.glow = Color.html("#E2A63E")
	return p
