shader_type canvas_item;

uniform vec4 line_color: source_color = vec4(1.0, 1.0, 1.0, 0.0);
uniform float line_thickness : hint_range(0, 10) = 1.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	float mx = smoothstep(1.9, 2.0, color.r + color.b);
	color.rgb = mix(color.rgb, line_color.rgb, mx);
	color.a = min(color.a, line_color.a);
	
	COLOR.rgb = color.rgb;
	COLOR.a = min(color.a, COLOR.a);
}