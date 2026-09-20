extends Node2D

## Contact shadows, drawn between the paper reserve and the figures.
##
## Their whole job is to put the figure back on the ground after the reserve has
## lifted it off the background. Order matters more than the drawing does.

var pal: Palette
var target: Alegus
var wob_t: float = 0.0


func _draw() -> void:
	if pal == null or target == null:
		return
	var s := target.depth_scale()
	Painter.shadow(self, target.position + Vector2(0.0, 2.0), 26.0 * 1.08 * s,
		pal.shadow, wob_t)
