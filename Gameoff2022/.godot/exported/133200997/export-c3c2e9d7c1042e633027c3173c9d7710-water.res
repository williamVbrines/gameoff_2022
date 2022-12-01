RSRC                     VisualShader            ��������                                            c      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    input_name    script 	   function    source    texture    texture_type    op_type 	   operator    parameter_name 
   qualifier    default_value_enabled    default_value 	   constant    code    graph_offset    mode    modes/blend    modes/depth_draw    modes/cull    modes/diffuse    modes/specular    flags/depth_prepass_alpha    flags/depth_test_disabled    flags/sss_mode_skin    flags/unshaded    flags/wireframe    flags/skip_vertex_transform    flags/world_vertex_coords    flags/ensure_correct_normals    flags/shadows_disabled    flags/ambient_light_disabled    flags/shadow_to_opacity    flags/vertex_lighting    flags/particle_trails    flags/alpha_to_coverage     flags/alpha_to_coverage_and_one    nodes/vertex/0/position    nodes/vertex/2/node    nodes/vertex/2/position    nodes/vertex/3/node    nodes/vertex/3/position    nodes/vertex/4/node    nodes/vertex/4/position    nodes/vertex/5/node    nodes/vertex/5/position    nodes/vertex/6/node    nodes/vertex/6/position    nodes/vertex/7/node    nodes/vertex/7/position    nodes/vertex/8/node    nodes/vertex/8/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/7/node    nodes/fragment/7/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/12/node    nodes/fragment/12/position    nodes/fragment/13/node    nodes/fragment/13/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections    
   Texture2D #   res://textures/WaterNoiseTest2.png �g�;�	9   $   local://VisualShaderNodeInput_e2b64 `      %   local://VisualShaderNodeUVFunc_0pwta �      &   local://VisualShaderNodeTexture_ra7cb �      $   local://VisualShaderNodeInput_x8ub7 *      $   local://VisualShaderNodeInput_0ddm8 c      *   local://VisualShaderNodeMultiplyAdd_w3s7t �      '   local://VisualShaderNodeVectorOp_j6en3 4      -   local://VisualShaderNodeColorParameter_o144m �      &   local://VisualShaderNodeTexture_2nsrc       '   local://VisualShaderNodeVectorOp_w7577 K      %   local://VisualShaderNodeUVFunc_7hote �      $   local://VisualShaderNodeInput_rbmip +      &   local://VisualShaderNodeTexture_yt4b5 b      %   local://VisualShaderNodeUVFunc_v40fh �      $   local://VisualShaderNodeInput_o12dw       '   local://VisualShaderNodeVectorOp_8obmq 8      '   local://VisualShaderNodeVectorOp_64sb8 �      ,   local://VisualShaderNodeFloatConstant_4bn7p B      ,   local://VisualShaderNodeFloatConstant_mfrgw |         local://VisualShader_shcfd �         VisualShaderNodeInput             time          VisualShaderNodeUVFunc                   
   ���=���=      
                    VisualShaderNodeTexture    	                      VisualShaderNodeInput             vertex          VisualShaderNodeInput             normal          VisualShaderNodeMultiplyAdd                    2                         2     �?  �?  �?  �?      2                                     VisualShaderNodeVectorOp                                            ��L>��L>��L>                  VisualShaderNodeColorParameter             ColorParameter                    ���=��R?  �?         VisualShaderNodeTexture    	                      VisualShaderNodeVectorOp                                                                                            VisualShaderNodeUVFunc                   
   
�#<
�#<      
                    VisualShaderNodeInput             time          VisualShaderNodeTexture              	                      VisualShaderNodeUVFunc                   
   
�#<
�#<      
                    VisualShaderNodeInput             time          VisualShaderNodeVectorOp                                                                                           VisualShaderNodeVectorOp                                                  �?  �?  �?  �?                           VisualShaderNodeFloatConstant          ��L?         VisualShaderNodeFloatConstant             VisualShader ,         �  shader_type spatial;
uniform sampler2D tex_vtx_4;
uniform vec4 ColorParameter : source_color = vec4(0.000000, 0.098039, 0.823529, 1.000000);
uniform sampler2D tex_frg_3;
uniform sampler2D tex_frg_7;



void vertex() {
// Input:2
	float n_out2p0 = TIME;


// UVFunc:3
	vec2 n_in3p1 = vec2(0.10000, 0.10000);
	vec2 n_out3p0 = fma(vec2(n_out2p0), n_in3p1, UV);


// Texture2D:4
	vec4 n_out4p0 = texture(tex_vtx_4, n_out3p0);


// Input:6
	vec3 n_out6p0 = NORMAL;


// VectorOp:8
	vec3 n_in8p1 = vec3(0.20000, 0.20000, 0.20000);
	vec3 n_out8p0 = n_out6p0 * n_in8p1;


// Input:5
	vec3 n_out5p0 = VERTEX;


// MultiplyAdd:7
	vec4 n_out7p0 = fma(n_out4p0, vec4(n_out8p0, 0.0), vec4(n_out5p0, 0.0));


// Output:0
	VERTEX = vec3(n_out7p0.xyz);


}

void fragment() {
// ColorParameter:2
	vec4 n_out2p0 = ColorParameter;


// Input:6
	float n_out6p0 = TIME;


// UVFunc:5
	vec2 n_in5p1 = vec2(0.01000, 0.01000);
	vec2 n_out5p0 = fma(vec2(n_out6p0), n_in5p1, UV);


// Texture2D:3
	vec4 n_out3p0 = texture(tex_frg_3, n_out5p0);


// Input:9
	float n_out9p0 = TIME;


// UVFunc:8
	vec2 n_in8p1 = vec2(0.01000, 0.01000);
	vec2 n_out8p0 = fma(vec2(n_out9p0), n_in8p1, UV);


// Texture2D:7
	vec4 n_out7p0 = texture(tex_frg_7, n_out8p0);


// VectorOp:10
	vec4 n_out10p0 = n_out3p0 * n_out7p0;


// VectorOp:11
	vec4 n_in11p1 = vec4(1.25000, 1.25000, 1.25000, 1.25000);
	vec4 n_out11p0 = pow(n_out10p0, n_in11p1);


// VectorOp:4
	vec4 n_out4p0 = n_out2p0 + n_out11p0;


// FloatConstant:12
	float n_out12p0 = 0.800000;


// FloatConstant:13
	float n_out13p0 = 0.000000;


// Output:0
	ALBEDO = vec3(n_out4p0.xyz);
	ALPHA = n_out12p0;
	ROUGHNESS = n_out13p0;
	EMISSION = vec3(n_out11p0.xyz);


}
 )   
     �C   C*             +   
     �  4C,            -   
     \�  4C.            /   
      B  �B0            1   
     p�   D2            3   
     ��  �C4            5   
     \C  �C6            7   
     ��  �C8                                                                                                          9   
     �C  �C:            ;   
     z�    <            =   
      �  pB>         	   ?   
         pB@         
   A   
     p�  �CB            C   
     ��  �CD            E   
     %�  �CF            G   
     u�  DH            I   
    ���  DJ            K   
     ��  �CL            M   
     \�  �CN            O   
     C  DP            Q   
     C  DR       4                                                                         	                    
              
      
                                                                           RSRC