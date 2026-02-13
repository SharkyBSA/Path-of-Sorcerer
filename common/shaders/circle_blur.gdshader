shader_type canvas_item;

uniform vec4 modulate : source_color;
uniform float intensity : hint_range(0.0, 4.0) = 1.0;
uniform float falloff : hint_range(0.0, 1.0) = 0.5;
uniform int samples : hint_range(0, 64) = 16;
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {
	vec2 uv = UV*2.0-0.5;
	vec2 dir = uv - clamp(center, vec2(0.0), vec2(1.0));

	float dist = length(dir) * 2.0;
	float fall = pow(min(dist, 1.0), 3.0 * falloff);
	float step_scale = intensity / float(samples) * 0.05;

	vec4 color = texture(TEXTURE, uv);

	for (int i = 1; i <= samples; i++) {
		float fi = float(i);
		float offset = fi * step_scale * fall;
		color += texture(TEXTURE, uv - dir * offset);
	}

	color /= float(samples + 1);
	COLOR = color*modulate;
}