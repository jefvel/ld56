shader_type canvas_item;
global uniform sampler2D noise_tex;
void vertex() {
	// Called for every vertex the material is visible on.
}

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	// Called for every pixel the material is visible on.
	float t = TIME * 0.02;
	vec2 pos = SCREEN_UV.xy;
	vec4 n = texture(noise_tex, mod(pos + vec2(t), vec2(1.0, 1.0)));

	vec4 n2 = texture(noise_tex, mod(-pos * 2.0 + vec2(t * 2.6, t * 0.2), vec2(1.0, 1.0)));
	//vec4 offs = texture(noise_tex, mod(n.gb * 0.1, vec2(1.0)));
	COLOR *= n;//texture(TEXTURE, UV + n.rg * 0.05);
	vec3 c = rgb2hsv(COLOR.rgb);
	c.g *= 1.12;
	c.b *= 1.7;
	c.g *= 0.3 + n2.b * 0.8;
	c.g = clamp(c.r, 0.0, 1.0);

	c = hsv2rgb(c);
	COLOR.rgb = c;
	//COLOR.rgb = mix(COLOR.rgb, vec3(1.0), 0.1);

	//COLOR = n;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
