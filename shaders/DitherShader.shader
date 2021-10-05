shader_type canvas_item;
uniform sampler2D dither;
uniform int offset = 0;

void fragment() {
	ivec2 iuv = ivec2(UV * vec2(700, 540));
	int x = int(iuv.x % 8);
	int y = int(iuv.y % 8);
	ivec2 puv = ivec2(x, y);
	vec2 duv = vec2(float(puv.x + offset * 8) / 512f, float(puv.y) / 8f);
	vec2 uv = UV;
	vec4 c = texture(TEXTURE, uv);
	COLOR = vec4(vec3(0), texture(dither, duv).r) * c;
}