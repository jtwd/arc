class_name Painter
extends RefCounted

## Every visual in the game goes through here. There are no image assets:
## a shape is a list of control points, and this turns it into paint.
##
## Ported from tools/render-test/index.html, which is the browser sandbox.
## Keep the two in step when the look changes.

const TAU_12 := 0.5235987756

## Live counters, read by the debug panel. Reset once per frame by game.gd.
static var paint_calls: int = 0
static var polys: int = 0


# --- noise ------------------------------------------------------------------

static func hashf(n: float) -> float:
	var s := sin(n * 127.1) * 43758.5453
	return s - floor(s)


static func vnoise(x: float) -> float:
	var i := floor(x)
	var f := x - i
	var u := f * f * (3.0 - 2.0 * f)
	return lerp(hashf(i), hashf(i + 1.0), u)


## Signed noise in -1..1 that drifts slowly with time.
static func n11(s: float, t: float) -> float:
	return vnoise(s + t * 0.45) * 2.0 - 1.0


# --- geometry ---------------------------------------------------------------

static func centroid(p: PackedVector2Array) -> Vector2:
	var c := Vector2.ZERO
	for v in p:
		c += v
	return c / float(maxi(p.size(), 1))


static func mean_radius(p: PackedVector2Array, c: Vector2) -> float:
	var r := 0.0
	for v in p:
		r += v.distance_to(c)
	return r / float(maxi(p.size(), 1))


## Scale about a centre and translate in one pass. Doing these as two steps
## allocated a whole extra point array per band, which at 56 shapes a frame is
## most of a millisecond for nothing.
static func scale_move(p: PackedVector2Array, c: Vector2, k: float, d: Vector2) -> PackedVector2Array:
	var out := PackedVector2Array()
	out.resize(p.size())
	for i in p.size():
		out[i] = c + (p[i] - c) * k + d
	return out


## Drifts each control point on its own noise channel, so an edge never sits
## perfectly still. This is the bleed and wobble pass.
static func wobble(p: PackedVector2Array, seed_v: float, t: float, amp: float) -> PackedVector2Array:
	if amp <= 0.0:
		return p
	var out := PackedVector2Array()
	out.resize(p.size())
	for i in p.size():
		var s := seed_v + float(i) * 3.77
		out[i] = p[i] + Vector2(n11(s, t), n11(s + 41.3, t)) * amp
	return out


## Control points to a smooth closed outline, by running a quadratic through
## the midpoints of each pair. Few points in, organic shape out.
##
## `sub` is the cost dial. Three is enough for anything under about 40 pixels
## across; only large washes need more.
static func smooth(p: PackedVector2Array, sub: int = 3) -> PackedVector2Array:
	var n := p.size()
	if n < 3:
		return p
	var out := PackedVector2Array()
	out.resize(n * sub)
	var w := 0
	for i in n:
		var prev := p[(i - 1 + n) % n]
		var cur := p[i]
		var nxt := p[(i + 1) % n]
		var m0 := (prev + cur) * 0.5
		var m1 := (cur + nxt) * 0.5
		for s in sub:
			var t := float(s) / float(sub)
			out[w] = m0.lerp(cur, t).lerp(cur.lerp(m1, t), t)
			w += 1
	return out


## An irregular closed blob, the workhorse for organic shapes.
static func blob(c: Vector2, r: Vector2, n: int, seed_v: float) -> PackedVector2Array:
	var out := PackedVector2Array()
	out.resize(n)
	for i in n:
		var a := float(i) / float(n) * TAU
		var k := 0.82 + vnoise(seed_v + float(i) * 2.3) * 0.36
		out[i] = c + Vector2(cos(a) * r.x * k, sin(a) * r.y * k)
	return out


## A tapered limb running from the origin down +y. Two of these and a pivot
## is an arm.
static func limb(length: float, w0: float, w1: float) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(-w0, 0.0), Vector2(w0, 0.0),
		Vector2(w1 * 0.9, length * 0.55), Vector2(w1, length),
		Vector2(-w1, length), Vector2(-w1 * 0.9, length * 0.55),
	])


# --- painting ---------------------------------------------------------------

## One watercolour shape: a wet bleed past the edge, the body, then two
## quantised pigment bands for form.
##
## The bands are drawn as shrunken, offset copies rather than a clipped
## overdraw, because Godot's 2D draw calls have no clip. On blobby shapes the
## result is the same and it costs two polygons instead of a stencil.
##
## Centre and radius are taken from the control points rather than the smoothed
## outline: close enough to identical, and a third of the loop.
static func paint(ci: CanvasItem, pts: PackedVector2Array, base: Color, shade: Color,
		seed_v: float, t: float, amp: float, bands: bool = true, sub: int = 3) -> void:
	var w := wobble(pts, seed_v, t, amp)
	var c := centroid(w)
	var r := mean_radius(w, c)
	var p := smooth(w, sub)

	paint_calls += 1
	polys += 2

	var bleed := base
	bleed.a = 0.28
	ci.draw_colored_polygon(scale_move(p, c, 1.075, Vector2.ZERO), bleed)
	ci.draw_colored_polygon(p, base)

	if bands:
		var off := r * 0.13
		ci.draw_colored_polygon(scale_move(p, c, 0.92, Vector2(off, off)), shade)
		var deep := shade.darkened(0.16)
		deep.a = 0.55
		ci.draw_colored_polygon(scale_move(p, c, 0.76, Vector2(off * 1.8, off * 1.8)), deep)
		polys += 2


## A damp contact shadow. Never a hard ellipse.
static func shadow(ci: CanvasItem, at: Vector2, r: float, col: Color, t: float) -> void:
	var c := col
	c.a = 0.16
	var p := smooth(wobble(blob(at, Vector2(r, r * 0.34), 8, at.x * 0.3), 900.0, t, 1.0), 3)
	ci.draw_colored_polygon(p, c)
	polys += 1
