extends Node2D

## Rung 1: the watercolour look running in Godot. There is no game here yet.
##
## Layer order is the whole point of this file:
##   world  ->  paper reserve  ->  contact shadows  ->  figures  ->  wash  ->  paper
## Figures render into their own SubViewport so the reserve can be taken from
## the finished silhouette rather than from each body part.

const W := 960
const H := 600
const WASH_DUR := 2.6

var pal: Palette
var pal_next: Palette

var world: World
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
var fps_label: Label


func _ready() -> void:
	pal = Palette.stone()
	pal_next = Palette.rivers()
	RenderingServer.set_default_clear_color(pal.paper)

	world = World.new()
	world.z_index = 0
	add_child(world)

	# figures live off-screen so the reserve sees one silhouette, not ten parts
	figures_vp = SubViewport.new()
	figures_vp.size = Vector2i(W, H)
	figures_vp.transparent_bg = true
	figures_vp.disable_3d = true
	figures_vp.gui_disable_input = true
	figures_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
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
	paper_rect.material = paper_mat
	add_child(paper_rect)

	_build_ui()
	_apply_palette(pal)
	world.build()


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


func _apply_palette(p: Palette) -> void:
	pal = p
	RenderingServer.set_default_clear_color(p.paper)
	world.pal = p
	alegus.pal = p
	shadows.set("pal", p)
	reserve_mat.set_shader_parameter("paper_color", p.paper)
	wash_mat.set_shader_parameter("paper_color", p.paper)
	paper_mat.set_shader_parameter("paper_tint", p.paper.darkened(0.2))
	world.queue_redraw()
	alegus.queue_redraw()


func _process(delta: float) -> void:
	wob_t += delta

	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	alegus.wob_t = wob_t
	alegus.wob_amp = wob_amp
	alegus.advance(delta, dir)

	world.wob_t = wob_t
	world.wob_amp = wob_amp
	world.queue_redraw()

	shadows.set("wob_t", wob_t)
	shadows.queue_redraw()

	if wash_t >= 0.0:
		wash_t += delta
		var k := wash_t / WASH_DUR
		# the front descends to bare paper, then recedes with the next age behind it
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

	if fps_label:
		fps_label.text = "%d fps" % Engine.get_frames_per_second()


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
	box.position = Vector2(W - 196, 12)
	box.custom_minimum_size = Vector2(184, 0)
	box.add_theme_constant_override("separation", 4)
	layer.add_child(box)

	fps_label = Label.new()
	box.add_child(fps_label)

	_check(box, "Pigment bands", true, _on_bands)
	_check(box, "Paper reserve", true, _on_reserve)
	_check(box, "Bleed and wobble", true, _on_wobble)
	_check(box, "Paper composite", true, _on_paper)
	_check(box, "Jointed", true, _on_jointed)

	var slider := HSlider.new()
	slider.min_value = 0.0
	slider.max_value = 4.0
	slider.step = 0.1
	slider.value = wob_amp
	slider.custom_minimum_size = Vector2(184, 16)
	slider.value_changed.connect(_on_amp)
	box.add_child(slider)

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


func _on_bands(v: bool) -> void:
	world.bands = v
	alegus.bands = v


func _on_reserve(v: bool) -> void:
	reserve_mat.set_shader_parameter("enabled", v)


func _on_wobble(v: bool) -> void:
	wob_amp = 1.5 if v else 0.0


func _on_paper(v: bool) -> void:
	paper_mat.set_shader_parameter("enabled", v)


func _on_jointed(v: bool) -> void:
	alegus.jointed = v


func _on_amp(v: float) -> void:
	wob_amp = v
