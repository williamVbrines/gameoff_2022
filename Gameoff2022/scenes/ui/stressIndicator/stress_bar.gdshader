shader_type canvas_item;

uniform float x_cutoff : hint_range(0,0.999) = 0;
uniform vec4 bar_color : source_color;

void fragment() {
	float alph = step((1.0 - x_cutoff) , COLOR.r * (1.0 - UV.x));
	COLOR = vec4(bar_color.rgb,  alph * COLOR.a);
}
