class_name Alegus
extends Puppet

## Ten painted parts on eight pivots. That is the whole character.
## Swapping a weapon is swapping one polygon list; a new age is a new palette.

const SPEED := 240.0
const GND_TOP := 240.0
const BOUNDS := Rect2(28.0, 264.0, 904.0, 320.0)

const TORSO := PackedVector2Array([
	Vector2(-11, -78), Vector2(11, -78), Vector2(14, -56),
	Vector2(12, -36), Vector2(-12, -36), Vector2(-14, -56)])
const HAIR := PackedVector2Array([
	Vector2(-10, -92), Vector2(-6, -103), Vector2(6, -104),
	Vector2(12, -96), Vector2(10, -88), Vector2(-2, -91)])
const CLUB_SHAFT := PackedVector2Array([
	Vector2(-4, -2), Vector2(4, -2), Vector2(5, 20),
	Vector2(3, 26), Vector2(-3, 26), Vector2(-5, 20)])

var facing: float = 1.0
var stride: float = 0.0
var moving: bool = false
var jointed: bool = true          ## false draws the same art rigid, for comparison


func _ready() -> void:
	position = Vector2(400.0, 430.0)


func advance(delta: float, dir: Vector2) -> void:
	moving = dir.length() > 0.01
	if moving:
		position += dir * SPEED * delta
		position.x = clampf(position.x, BOUNDS.position.x, BOUNDS.end.x)
		position.y = clampf(position.y, BOUNDS.position.y, BOUNDS.end.y)
		stride += delta * 9.0
		if absf(dir.x) > 0.01:
			facing = 1.0 if dir.x > 0.0 else -1.0
	queue_redraw()


## Further up the frame reads as further away.
func depth_scale() -> float:
	return 0.78 + 0.34 * ((position.y - GND_TOP) / (600.0 - GND_TOP))


func _draw() -> void:
	if pal == null:
		return

	var s := 1.08 * depth_scale()
	var sw := 0.0
	var sw2 := 0.0
	var bob := 0.0
	if moving:
		sw = sin(stride) * 0.62
		sw2 = sin(stride + PI) * 0.62
		bob = absf(cos(stride)) * 4.0
	else:
		sw = sin(wob_t * 1.4) * 0.07
		sw2 = sin(wob_t * 1.4 + 1.0) * 0.07
		bob = sin(wob_t * 1.4) * 1.6
	if not jointed:
		sw = 0.0
		sw2 = 0.0

	begin(Transform2D(0.0, Vector2(0.0, -bob)))
	push_scale(Vector2(facing * s, s))
	var root := _cur

	# far side first, painted darker, so the two sides of the body separate
	# without anything being outlined
	var j := push_joint(Vector2(-3.0, -40.0), sw2 * 0.5)
	part(Painter.limb(40.0, 7.0, 5.0), pal.skin_shade, pal.hair_shade, 11.0)
	pop_joint(j)

	j = push_joint(Vector2(-5.0, -72.0), sw * 0.7 - 0.2)
	part(Painter.limb(34.0, 6.0, 4.5), pal.skin_shade, pal.hair_shade, 12.0)
	pop_joint(j)

	j = push_joint(Vector2(4.0, -40.0), sw * 0.5)
	part(Painter.limb(42.0, 8.0, 5.5), pal.skin, pal.skin_shade, 13.0)
	pop_joint(j)

	part(TORSO, pal.hide, pal.hide_shade, 14.0)
	part(Painter.blob(Vector2(2, -90), Vector2(12, 13), 9, 21.0), pal.skin, pal.skin_shade, 15.0)
	part(HAIR, pal.hair, pal.hair_shade, 16.0)

	# the near arm carries the club, so the whole weapon rides one pivot and a
	# new weapon form is one polygon list
	j = push_joint(Vector2(6.0, -74.0), sw2 * 0.7)
	part(Painter.limb(32.0, 6.5, 5.0), pal.skin, pal.skin_shade, 17.0)
	var wrist := push_joint(Vector2(0.0, 32.0), 0.0)
	part(CLUB_SHAFT, pal.wood, pal.wood_shade, 18.0)
	part(Painter.blob(Vector2(0, 32), Vector2(10, 11), 8, 44.0),
		pal.stone_head, pal.stone_head_shade, 19.0)
	pop_joint(wrist)
	pop_joint(j)

	# one ochre handprint per age cleared, so his arms are the progress record
	_cur = root
	draw_set_transform_matrix(_cur)
	var glow := pal.glow
	glow.a = 0.72
	Painter.paint(self, Painter.blob(Vector2(-9, -64), Vector2(4, 5), 7, 51.0),
		glow, pal.hide_shade, 20.0, wob_t, wob_amp, false)

	begin()
