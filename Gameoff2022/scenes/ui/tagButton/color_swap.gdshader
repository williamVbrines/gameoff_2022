shader_type canvas_item;

uniform vec4 from_1 : source_color = vec4(0.0);
uniform vec4 to_1 : source_color = vec4(0.0);
uniform vec4 from_2 : source_color = vec4(0.0);
uniform vec4 to_2 : source_color = vec4(0.0);

void fragment() {
	vec4 color = COLOR;
	
	if (color == from_1) color = to_1;
	else if (color == from_2) color = to_2;
	
	COLOR = color;
	
}
