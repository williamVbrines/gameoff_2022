shader_type canvas_item;

uniform float cuttoff : hint_range(0.0,1.0);
uniform sampler2D filter;

void fragment(){
	vec4 tex = texture(filter, UV);
	COLOR.a = tex.r - (cuttoff * 2.0 -1.0)  ;
}
