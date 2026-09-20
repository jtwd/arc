shader_type canvas_item;
render_mode blend_mul;

// Paper composite. Multiplies the finished frame by a tooth-and-mottle texture
// and a soft vignette.
//
// Fixed to the screen, not to the world: the scene is painted onto the glass,
// so the grain must not swim when anything moves.
//
// The tooth is baked into a small tiling texture once at startup rather than
// hashed per pixel per frame. Five sine calls on every one of 576,000 pixels,
// sixty times a second, bought nothing that a texture read does not.

uniform sampler2D paper_tex : repeat_enable, filter_linear;
uniform vec2 tile = vec2(3.75, 2.34);
uniform float grain : hint_range(0.0, 1.0) = 0.34;
uniform float vignette : hint_range(0.0, 1.0) = 0.20;
uniform vec4 paper_tint : source_color = vec4(0.80, 0.78, 0.73, 1.0);
uniform bool enabled = true;

void fragment() {
	if (!enabled) {
		COLOR = vec4(1.0);
	} else {
		float tooth = texture(paper_tex, SCREEN_UV * tile).r;
		// one low-frequency term in screen space, so the tiling never reads
		float mottle = 0.5 + 0.5 * sin(SCREEN_UV.x * 7.0 + 1.3) * sin(SCREEN_UV.y * 5.0 + 0.7);
		float paper = 1.0 - grain * (0.6 * (1.0 - tooth) + 0.4 * (1.0 - mottle));
		float d = distance(SCREEN_UV, vec2(0.5));
		float vig = 1.0 - smoothstep(0.38, 0.98, d) * vignette;
		vec3 tint = mix(vec3(1.0), paper_tint.rgb, 0.25);
		COLOR = vec4(tint * paper * vig, 1.0);
	}
}
