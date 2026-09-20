shader_type canvas_item;
render_mode blend_premul_alpha;

// The paper reserve. Replaces the ink outline that the first art review cut.
//
// A painter separates a subject from its background by leaving a ring of
// untouched paper around it, not by drawing a line around it. This dilates the
// figure layer's silhouette and emits the ring alone, so the contact shadow can
// be drawn between the ring and the figure. Without that the ring paints paper
// over the shadow at the feet and cuts the figure loose from the ground.
//
// It runs on the whole figure layer at once, never per body part. A per-part
// reserve would open paper gaps between an arm and the torso and slice the
// figure into pieces.

uniform vec4 paper_color : source_color = vec4(0.929, 0.902, 0.839, 1.0);
uniform float radius : hint_range(0.0, 16.0) = 3.4;
uniform bool enabled = true;

void fragment() {
	if (!enabled) {
		COLOR = vec4(0.0);
	} else {
		vec4 fig = texture(TEXTURE, UV);
		vec2 px = TEXTURE_PIXEL_SIZE * radius;
		float near = fig.a;
		for (int i = 0; i < 12; i++) {
			float a = float(i) * 0.5235988;
			near = max(near, texture(TEXTURE, UV + vec2(cos(a), sin(a)) * px).a);
		}
		float ring = near * (1.0 - fig.a);
		COLOR = vec4(paper_color.rgb * ring, ring);
	}
}
