shader_type spatial;
render_mode blend_mix;

uniform vec4 highlight_color : source_color;
uniform float str : hint_range(0.0, 300, 0.01);

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void fragment()
{
	float basic_fresnel = fresnel(str, NORMAL, VIEW);
	ALBEDO = highlight_color.rgb * basic_fresnel;
	ALPHA = basic_fresnel;

}