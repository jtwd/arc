extends Node2D

## Rung 1: the watercolour look running in Godot. There is no game here yet.
##
## Layer order is the whole point of this file:
##   world  ->  paper reserve  ->  contact shadows  ->  figures  ->  wash  ->  paper
## Figures render into their own SubViewport so the reserve can be taken from
## the finished silhouette rather than from each body part.
##
## The world renders into a SubViewport too, but for a different reason: it is
## 82% of the frame's geometry work and it is static apart from a slow drift,
## so it is baked a few times a second instead of sixty.

const W := 960
const H := 600
const WASH_DUR := 2.6

var pal: Palette
var pal_next: Palette

var world: World
var world_vp: SubViewport
var world_rect: TextureRect
var figures_vp: SubViewport
var alegus: Alegus
var reserve_rect: TextureRect
var figure_rect: TextureRect
var shadows: Node2D
var wash_rect: ColorRect
var paper_rect: ColorRect
var reserve_mat: ShaderMaterial
var wash_mat: ShaderMaterial
var paper_mat: ShaderMaterial

var wob_t: float = 0.0
var wob_amp: float = 1.5
var wash_t: float = -1.0
var wash_swapped: bool = false

## The render spec drifts the wobble at 0.15 Hz, so ten bakes a second is
## already far more than the eye can follow.
var bake_hz: float = 10.0
var _bake_accum: float = 0.0
var _bakes_this_second: int = 0
var _bake_rate: int = 0
var _second_accum: float = 0.0

var stats: Label
var _last_paints: int = 0


func _ready() -> void:
	pal = Palette.stone()
	pal_next = Palette.rivers()
	RenderingServer.set_default_clear_color(pal.paper)

	world_vp = _make_viewport(false)
	add_child(world_vp)
	world = World.new()
	world_vp.add_child(world)

	world_rect = _full_rect_texture(world_vp.get_texture(), 0)
	add_child(world_rect)

	figures_vp = _make_viewport(true)
	add_child(figures_vp)
	var figure_root := Node2D.new()
	figures_vp.add_child(figure_root)
	alegus = Alegus.new()
	figure_root.add_child(alegus)

	reserve_rect = _full_rect_texture(figures_vp.get_texture(), 10)
	reserve_mat = ShaderMaterial.new()
	reserve_mat.shader = load("res://shaders/reserve.gdshader")
	reserve_rect.material = reserve_mat
	add_child(reserve_rect)

	shadows = load("res://scripts/shadows.gd").new()
	shadows.z_index = 20
	shadows.set("target", alegus)
	add_child(shadows)

	figure_rect = _full_rect_texture(figures_vp.get_texture(), 30)
	var fm := CanvasItemMaterial.new()
	# a transparent SubViewport hands back premultiplied alpha; without this the
	# figures carry a dark fringe against the paper
	fm.blend_mode = CanvasItemMaterial.BLEND_MODE_PREMULT_ALPHA
	figure_rect.material = fm
	add_child(figure_rect)

	wash_rect = _full_rect_color(40)
	wash_mat = ShaderMaterial.new()
	wash_mat.shader = load("res://shaders/wash.gdshader")
	wash_rect.material = wash_mat
	add_child(wash_rect)

	paper_rect = _full_rect_color(50)
	paper_mat = ShaderMaterial.new()
	paper_mat.shader = load("res://shaders/paper.gdshader")
	paper_mat.set_shader_parameter("paper_tex", _make_paper_texture())
	paper_rect.material = paper_mat
	add_child(paper_rect)

	_build_ui()
	_apply_palette(pal)
	world.build()
	_bake_world()


func _make_viewport(transparent: bool) -> SubViewport:
	var vp := SubViewport.new()
	vp.size = Vector2i(W, H)
	vp.transparent_bg = transparent
	vp.disable_3d = true
	vp.gui_disable_input = true
	if transparent:
		vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	else:
		# the world is baked on demand, not every frame
		vp.render_target_update_mode = SubViewport.UPDATE_DISABLED
	return vp


## Paper tooth, baked once into a small tiling texture. Built through a byte
## array rather than set_pixel, which would take the best part of a second.
func _make_paper_texture(size: int = 256) -> ImageTexture:
	var data := PackedByteArray()
	data.resize(size * size)
	var rng := RandomNumberGenerator.new()
	rng.seed = 1337
	for i in data.size():
		data[i] = 150 + int(rng.randf() * 90.0)
	var img := Image.create_from_data(size, size, false, Image.FORMAT_L8, data)
	return ImageTexture.create_from_image(img)


func _full_rect_texture(tex: Texture2D, z: int) -> TextureRect:
	var r := TextureRect.new()
	r.texture = tex
	r.position = Vector2.ZERO
	r.size = Vector2(W, H)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_SCALE
	r.z_index = z
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


func _full_rect_color(z: int) -> ColorRect:
	var r := ColorRect.new()
	r.color = Color(1, 1, 1, 1)
	r.position = Vector2.ZERO
	r.size = Vector2(W, H)
	r.z_index = z
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


func _bake_world() -> void:
	world.wob_t = wob_t
	world.wob_amp = wob_amp
	world.queue_redraw()
	world_vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	_bakes_this_second += 1


func _apply_palette(p: Palette) -> void:
	pal = p
	RenderingServer.set_default_clear_color(p.paper)
	world.pal = p
	alegus.pal = p
	shadows.set("pal", p)
	reserve_mat.set_shader_parameter("paper_color", p.paper)
	wash_mat.set_shader_parameter("paper_color", p.paper)
	paper_mat.set_shader_parameter("paper_tint", p.paper.darkened(0.2))
	alegus.queue_redraw()
	_bake_world()


func _process(delta: float) -> void:
	# counters hold last frame's totals, because drawing happens after _process
	_last_paints = Painter.paint_calls
	Painter.paint_calls = 0
	Painter.polys = 0

	wob_t += delta

	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	alegus.wob_t = wob_t
	alegus.wob_amp = wob_amp
	alegus.advance(delta, dir)

	shadows.set("wob_t", wob_t)
	shadows.queue_redraw()

	_bake_accum += delta
	if _bake_accum >= 1.0 / bake_hz:
		_bake_accum = 0.0
		_bake_world()

	_second_accum += delta
	if _second_accum >= 1.0:
		_second_accum = 0.0
		_bake_rate = _bakes_this_second
		_bakes_this_second = 0

	if wash_t >= 0.0:
		wash_t += delta
		var k := wash_t / WASH_DUR
		var pr := (k / 0.5) if k < 0.5 else (1.0 - (k - 0.5) / 0.5)
		wash_mat.set_shader_parameter("progress", clampf(pr, 0.0, 1.0))
		# swap exactly once, at the moment the frame is bare paper
		if k >= 0.5 and not wash_swapped:
			wash_swapped = true
			var prev := pal
			_apply_palette(pal_next)
			pal_next = prev
		if k >= 1.0:
			wash_t = -1.0
			wash_mat.set_shader_parameter("progress", 0.0)

	_update_stats()


func _update_stats() -> void:
	if stats == null:
		return
	var proc_ms := Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0
	stats.text = "%d fps\nprocess %.2f ms\nworld   %.2f ms @ %d/s\nfigures %.2f ms\npaints  %d" % [
		Engine.get_frames_per_second(),
		proc_ms,
		world.last_draw_usec / 1000.0,
		_bake_rate,
		alegus.last_draw_usec / 1000.0,
		_last_paints,
	]


func start_wash() -> void:
	if wash_t < 0.0:
		wash_t = 0.0
		wash_swapped = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_SPACE:
			start_wash()


# --- debug panel ------------------------------------------------------------

func _build_ui() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)

	var box := VBoxContainer.new()
	box.position = Vector2(W - 210, 10)
	box.custom_minimum_size = Vector2(200, 0)
	box.add_theme_constant_override("separation", 3)
	layer.add_child(box)

	stats = Label.new()
	box.add_child(stats)

	_check(box, "Pigment bands", true, _on_bands)
	_check(box, "Paper reserve", true, _on_reserve)
	_check(box, "Bleed and wobble", true, _on_wobble)
	_check(box, "Paper composite", true, _on_paper)
	_check(box, "Jointed", true, _on_jointed)

	# bisect switches: turn a whole layer off to find where the time goes
	_check(box, "Layer: world", true, _on_layer_world)
	_check(box, "Layer: figures", true, _on_layer_figures)

	_slider(box, "wobble", 0.0, 4.0, 0.1, wob_amp, _on_amp)
	_slider(box, "bake Hz", 1.0, 60.0, 1.0, bake_hz, _on_bake_hz)

	var b := Button.new()
	b.text = "Age transition  (space)"
	b.pressed.connect(start_wash)
	box.add_child(b)


func _check(parent: Node, text: String, on: bool, cb: Callable) -> void:
	var c := CheckButton.new()
	c.text = text
	c.button_pressed = on
	c.toggled.connect(cb)
	parent.add_child(c)


func _slider(parent: Node, text: String, lo: float, hi: float, step: float,
		value: float, cb: Callable) -> void:
	var l := Label.new()
	l.text = text
	parent.add_child(l)
	var s := HSlider.new()
	s.min_value = lo
	s.max_value = hi
	s.step = step
	s.value = value
	s.custom_minimum_size = Vector2(200, 16)
	s.value_changed.connect(cb)
	parent.add_child(s)


func _on_bands(v: bool) -> void:
	world.bands = v
	alegus.bands = v
	_bake_world()


func _on_reserve(v: bool) -> void:
	reserve_mat.set_shader_parameter("enabled", v)


func _on_wobble(v: bool) -> void:
	wob_amp = 1.5 if v else 0.0


func _on_paper(v: bool) -> void:
	paper_mat.set_shader_parameter("enabled", v)


func _on_jointed(v: bool) -> void:
	alegus.jointed = v


func _on_layer_world(v: bool) -> void:
	world_rect.visible = v


func _on_layer_figures(v: bool) -> void:
	reserve_rect.visible = v
	figure_rect.visible = v
	shadows.visible = v


func _on_amp(v: float) -> void:
	wob_amp = v


func _on_bake_hz(v: float) -> void:
	bake_hz = maxf(v, 1.0)
