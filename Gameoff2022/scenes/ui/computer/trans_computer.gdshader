shader_type canvas_item;

uniform float cutoff_y : hint_range(0.0, 1.0, 0.001) = 0;

void fragment() {
	vec4 color = texture(SCREEN_TEXTURE,SCREEN_UV);
	COLOR = color;
	COLOR.rgb *= vec3(step(1.0-cutoff_y,1.0-SCREEN_UV.y));
}
