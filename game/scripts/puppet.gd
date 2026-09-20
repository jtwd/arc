class_name Puppet
extends Node2D

## Base for anything jointed. A puppet is a list of painted shapes on pivots:
## no mesh, no rig, no skinning, no image files.
##
## Godot's draw_set_transform only sets a flat transform, so the stack is kept
## here by hand. push_joint returns the transform to hand back to pop_joint,
## which keeps the call sites readable without nesting closures inside _draw.

var _cur := Transform2D.IDENTITY

var pal: Palette
var wob_t: float = 0.0
var wob_amp: float = 1.5
var bands: bool = true


func begin(base: Transform2D = Transform2D.IDENTITY) -> void:
	_cur = base
	draw_set_transform_matrix(_cur)


func push_joint(offset: Vector2, angle: float) -> Transform2D:
	var prev := _cur
	_cur = _cur * Transform2D(angle, offset)
	draw_set_transform_matrix(_cur)
	return prev


func pop_joint(prev: Transform2D) -> void:
	_cur = prev
	draw_set_transform_matrix(_cur)


func push_scale(s: Vector2) -> void:
	_cur = _cur * Transform2D(0.0, s, 0.0, Vector2.ZERO)
	draw_set_transform_matrix(_cur)


func part(pts: PackedVector2Array, base: Color, shade: Color, seed_v: float) -> void:
	Painter.paint(self, pts, base, shade, seed_v, wob_t, wob_amp, bands)
