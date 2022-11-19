shader_type canvas_item;

uniform vec4 from_1 : source_color = vec4(0.0);
uniform vec4 to_1 : source_color = vec4(0.0);
uniform vec4 from_2 : source_color = vec4(0.0);
uniform vec4 to_2 : source_color = vec4(0.0);

void fragment() {
	vec4 color = COLOR;

	if (color.rgb == from_1.rgb) color = to_1;
	else if (color.rgb == from_2.rgb) color = to_2;
	
	COLOR = vec4(color.rgb , COLOR.a * color.a);
	
}
