shader_type canvas_item;

uniform sampler2D mask;
uniform float scale : hint_range(0, 1.0, 0.1);

void fragment() {
	float s = scale == 0.0 ? 0.0 : pow(2.0, 10.0 * scale - 10.0);
	s *= 4.0f;
	vec2 offset = vec2(0.5, 0.5) * (1.0 - s);
	vec4 mask_color = texture(mask, UV * s + offset);
	mask_color.a *= 2.0f;
	COLOR.a = 1.0 - mask_color.a;
	
	if (scale <= 0.001) {
    COLOR.a = 0.0;

}
}


