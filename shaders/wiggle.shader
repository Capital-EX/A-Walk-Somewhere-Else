shader_type canvas_item;
uniform sampler2D noise;
uniform float scale = 0.003f;
uniform bool enabled = true;
void fragment() {
	vec2 uv = UV;
	vec2 noise_pixel_size = vec2(512f);
	vec2 noise_uv = UV / TEXTURE_PIXEL_SIZE / noise_pixel_size;
	vec2 sample = texture(noise, noise_uv + TIME - mod(TIME, 0.15)).rb;
	vec2 rb = (sample - 0.5) * scale;
	uv += rb * float(enabled);
	vec4 color = texture(TEXTURE, clamp(vec2(0f, 0f), uv, vec2(1f,1f)));
	COLOR.rgba = color;
}
