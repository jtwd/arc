shader_type canvas_item;
render_mode blend_mul;

// Paper composite. Multiplies the finished frame by a tooth-and-mottle texture
// and a soft vignette.
//
// Fixed to the screen, not to the world: the scene is painted onto the glass,
// so the grain must not swim when anything moves.

uniform float grain : hint_range(0.0, 1.0) = 0.34;
uniform float vignette : hint_range(0.0, 1.0) = 0.20;
uniform vec4 paper_tint : source_color = vec4(0.80, 0.78, 0.73, 1.0);
uniform bool enabled = true;

float hash2(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float vnoise2(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash2(i), hash2(i + vec2(1.0, 0.0)), u.x),
			   mix(hash2(i + vec2(0.0, 1.0)), hash2(i + vec2(1.0, 1.0)), u.x), u.y);
}

void fragment() {
	if (!enabled) {
		COLOR = vec4(1.0);
	} else {
		float tooth = hash2(floor(SCREEN_UV * vec2(1920.0, 1200.0)));
		float mottle = vnoise2(SCREEN_UV * 5.0);
		float paper = 1.0 - grain * (0.55 * (1.0 - tooth) + 0.45 * (1.0 - mottle));
		float d = distance(SCREEN_UV, vec2(0.5));
		float vig = 1.0 - smoothstep(0.38, 0.98, d) * vignette;
		vec3 tint = mix(vec3(1.0), paper_tint.rgb, 0.25);
		COLOR = vec4(tint * paper * vig, 1.0);
	}
}
