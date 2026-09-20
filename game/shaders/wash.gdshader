shader_type canvas_item;

// The age transition. The signature moment of a run and the payoff for the
// weapon re-forging.
//
// The frame runs like a wet painting: colour drains downward in streaks to bare
// paper, then the next age's palette floods back in behind it. Driven by one
// uniform so the game code only has to move a number from 0 to 1 and back.

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 paper_color : source_color = vec4(0.929, 0.902, 0.839, 1.0);

float hash1(float n) {
	return fract(sin(n * 127.1) * 43758.5453);
}

float vnoise1(float x) {
	float i = floor(x);
	float f = fract(x);
	float u = f * f * (3.0 - 2.0 * f);
	return mix(hash1(i), hash1(i + 1.0), u);
}

void fragment() {
	if (progress <= 0.0) {
		COLOR = vec4(0.0);
	} else {
		// the front descends in streaks rather than as a flat curtain
		float streak = vnoise1(UV.x * 6.0) * 0.26 + vnoise1(UV.x * 21.0 + 11.0) * 0.12;
		float front = progress * 1.38 - 0.19 - streak;
		float a = smoothstep(front + 0.05, front - 0.02, UV.y);
		COLOR = vec4(paper_color.rgb, clamp(a, 0.0, 1.0));
	}
}
