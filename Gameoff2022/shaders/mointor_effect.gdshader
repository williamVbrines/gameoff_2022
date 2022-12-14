//---CRT Shader---
shader_type canvas_item;

uniform float scanline_count : hint_range(0, 1800) = 50.0;
uniform float scanline_opacity : hint_range(0.0, 1.0) = 0.5;
uniform float vignette_intensity = 0.4; // Size of the vignette, how far towards the middle it should go.
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.5;
uniform float vignette_cutoff : hint_range(0.0, 1.0) = 0.0;
uniform float curve  : hint_range(0.0, 5.0) = 3.0;
vec2 uv_curve(vec2 uv)
{
	uv = (uv - 0.5) * 2.0;
	
	//You can modify the numbers and try different values
	uv.x *= 1.0 + pow(abs(uv.y) / curve, 2.0);
	uv.y *= 1.0 + pow(abs(uv.x) / curve, 2.0);
	
	//The scale part (you can delete it when you want)
	uv /= 1.2;
	
	uv = (uv/2.0) + 0.5;
	return uv;
}

// Adds a vignette shadow to the edges of the image
float vignette(vec2 uv){
	uv *= 1.0 - uv.xy;
	float vignette = uv.x * uv.y * 15.0;
	return pow(vignette, vignette_intensity * vignette_opacity);
}

void fragment()
{	
	
	//You can modify the *3.0, *-3.0 for a bigger or smaller 
	float r = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x* 0.0), 0.0).r;
	float g = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x* 0.0), 0.0).g;
	float b = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x* -0.0), 0.0).b;
	
	
	//If you dont want scanlines you can just delete this part
	float s = sin(uv_curve(SCREEN_UV).y * scanline_count * PI * 2.0);
	s = (s * 0.5 + 0.5) * 0.9 + 0.1;
	vec4 scan_line = vec4(vec3(pow(s, 0.25)), 1.0);
	
	
	COLOR = vec4(r, g, b, 1.0);
	COLOR.rgb -= vec3((s * scanline_opacity)) ;
	COLOR.rgb *= vignette(UV);
	COLOR.rgb *= vec3(step(vignette_cutoff, vignette(UV)));
}