class_name World
extends Node2D

## Ground and scenery. No reserve is taken around any of this: the bare paper
## ring is what marks a thing as a figure, so set dressing must never have one.

const GND_TOP := 240.0
const W := 960.0
const H := 600.0

var pal: Palette
var wob_t: float = 0.0
var wob_amp: float = 1.5
var bands: bool = true

var _scenery: Array[Dictionary] = []

## Wall time of the last bake, read by the debug panel.
var last_draw_usec: int = 0


func build() -> void:
	_scenery.clear()
	for i in 16:
		var y := GND_TOP + 18.0 + Painter.hashf(float(i) * 5.1) * (H - GND_TOP - 40.0)
		_scenery.append({
			"pos": Vector2(30.0 + Painter.hashf(float(i) * 3.3) * (W - 60.0), y),
			"rock": Painter.hashf(float(i) * 9.7) > 0.52,
			"s": 0.6 + Painter.hashf(float(i) * 2.2) * 0.8,
			"seed": float(i) * 17.0 + 3.0,
		})
	queue_redraw()


func _draw() -> void:
	if pal == null:
		return
	var t0 := Time.get_ticks_usec()
	draw_rect(Rect2(0, 0, W, GND_TOP + 42.0), pal.sky_lo)
	draw_rect(Rect2(0, GND_TOP, W, H - GND_TOP), pal.ground)

	# a soft band where ground meets sky, so the horizon is a wash and not a seam
	Painter.paint(self, Painter.blob(Vector2(W * 0.5, GND_TOP + 4.0),
		Vector2(W * 0.62, 18.0), 12, 88.0), pal.horizon, pal.sky_lo,
		5.0, wob_t, wob_amp, bands, 5)

	for i in 13:
		var x := fposmod(float(i) * 151.0, W)
		var y := GND_TOP + 14.0 + fposmod(float(i) * 97.0, H - GND_TOP - 24.0)
		Painter.paint(self, Painter.blob(Vector2(x, y),
			Vector2(70.0 + Painter.hashf(float(i)) * 70.0,
					16.0 + Painter.hashf(float(i) * 2.0) * 16.0), 9, float(i) * 13.0 + 5.0),
			pal.patch, pal.patch_shade, float(i) * 31.0 + 2.0, wob_t, wob_amp, bands, 4)

	for s in _scenery:
		var p: Vector2 = s["pos"]
		var k: float = s["s"] * (0.78 + 0.34 * ((p.y - GND_TOP) / (H - GND_TOP)))
		if s["rock"]:
			Painter.paint(self, Painter.blob(p, Vector2(26.0 * k, 17.0 * k), 8, s["seed"]),
				pal.rock, pal.rock_shade, s["seed"], wob_t, wob_amp, bands, 2)
		else:
			for b in 3:
				var ox := (float(b) - 1.0) * 8.0 * k
				Painter.paint(self, PackedVector2Array([
					p + Vector2(ox, 0.0),
					p + Vector2(ox + 3.0 * k, -22.0 * k),
					p + Vector2(ox - 3.0 * k, -21.0 * k)]),
					pal.tuft, pal.tuft_shade, s["seed"] + float(b), wob_t, wob_amp, bands, 2)

	last_draw_usec = Time.get_ticks_usec() - t0
