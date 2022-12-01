RSRC                     VisualShader            ��������                                            <      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    input_name    script    parameter_name 
   qualifier    hint    min    max    step    default_value_enabled    default_value    op_type 	   operator 	   function    source    texture    texture_type    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/7/node    nodes/fragment/7/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        $   local://VisualShaderNodeInput_rqppv ?      -   local://VisualShaderNodeFloatParameter_11kl2 t      '   local://VisualShaderNodeVectorOp_yaf55 �      )   local://VisualShaderNodeVectorFunc_rn0de r      '   local://VisualShaderNodeVectorOp_qjffj �      &   local://VisualShaderNodeTexture_qesly V	         local://VisualShader_ecyy7 �	         VisualShaderNodeInput             uv          VisualShaderNodeFloatParameter             Pixelation_Amount 	         
        �C         D         @        �?         VisualShaderNodeVectorOp                    
                 
                                       VisualShaderNodeVectorFunc                    
                                       VisualShaderNodeVectorOp                              
                 
                                       VisualShaderNodeTexture                                VisualShader          �  shader_type canvas_item;
uniform float Pixelation_Amount : hint_range(256, 512, 2);



void fragment() {
// Input:2
	vec2 n_out2p0 = UV;


// FloatParameter:3
	float n_out3p0 = Pixelation_Amount;


// VectorOp:4
	vec2 n_out4p0 = n_out2p0 * vec2(n_out3p0);


// VectorFunc:5
	vec2 n_out5p0 = floor(n_out4p0);


// VectorOp:6
	vec2 n_out6p0 = n_out5p0 / vec2(n_out3p0);


	vec4 n_out7p0;
// Texture2D:7
	n_out7p0 = textureLod(SCREEN_TEXTURE, n_out6p0, 0.0);


// Output:0
	COLOR.rgb = vec3(n_out7p0.xyz);


}
    
   D��B�DB                      
     kD  �B                 
     4�  pB!            "   
      �  C#            $   
      C  pB%            &   
     �C  �B'            (   
     �C  C)            *   
     D  C+                                                                                                                 RSRC