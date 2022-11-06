// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hidden/Baking Barrels"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Mask("Mask", 2D) = "white" {}
		_AmbientOcclusion("Ambient Occlusion", 2D) = "white" {}
		_SpecularSmoothness("Specular Smoothness", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Cutoff("Cutoff", Float) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		CGINCLUDE
		#pragma target 4.0
		ENDCG
		Cull Back
		

		Pass
		{
			Name "Unlit"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma multi_compile_fwdbase
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				float4 ase_tangent : TANGENT;
				float3 ase_normal : NORMAL;
			};

			struct v2f
			{
				UNITY_POSITION(pos);
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
			};

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _Normal;
			uniform float4 _Normal_ST;
			uniform sampler2D _AmbientOcclusion;
			uniform float4 _AmbientOcclusion_ST;
			uniform sampler2D _SpecularSmoothness;
			uniform float4 _SpecularSmoothness_ST;
			uniform sampler2D _Mask;
			uniform float4 _Mask_ST;
			uniform float _Cutoff;

			v2f vert(appdata v )
			{
				v2f o = (v2f)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
				o.ase_texcoord1.xyz = ase_worldTangent;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord3.xyz = ase_worldBitangent;
				float3 objectToViewPos = UnityObjectToViewPos(v.vertex.xyz);
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord.z = eyeDepth;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;

				v.vertex.xyz +=  float3(0,0,0) ;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}


			void frag(v2f i ,
				out half4 outGBuffer0 : SV_Target0, 
				out half4 outGBuffer1 : SV_Target1, 
				out half4 outGBuffer2 : SV_Target2, 
				out half4 outGBuffer3 : SV_Target3,
				out half4 outGBuffer4 : SV_Target4,
				out half4 outGBuffer5 : SV_Target5,
				out half4 outGBuffer6 : SV_Target6,
				out half4 outGBuffer7 : SV_Target7,
				out float outDepth : SV_Depth
			) 
			{
				UNITY_SETUP_INSTANCE_ID( i );
				float2 uv_MainTex = i.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode179 = tex2D( _MainTex, uv_MainTex );
				float4 appendResult188 = (float4(tex2DNode179.rgb , 1.0));
				
				float2 uv_Normal = i.ase_texcoord.xy * _Normal_ST.xy + _Normal_ST.zw;
				float2 uv_AmbientOcclusion = i.ase_texcoord.xy * _AmbientOcclusion_ST.xy + _AmbientOcclusion_ST.zw;
				float occlusion146 = tex2D( _AmbientOcclusion, uv_AmbientOcclusion ).r;
				float2 uv_SpecularSmoothness = i.ase_texcoord.xy * _SpecularSmoothness_ST.xy + _SpecularSmoothness_ST.zw;
				float4 tex2DNode142 = tex2D( _SpecularSmoothness, uv_SpecularSmoothness );
				float specular152 = ( tex2DNode142.a * 0.5 );
				float2 uv_Mask = i.ase_texcoord.xy * _Mask_ST.xy + _Mask_ST.zw;
				float smoothstepResult166 = smoothstep( 0.35 , -0.15 , ( ( 1.0 - ( occlusion146 * saturate( (i.ase_color.r*0.6 + 0.79) ) ) ) + specular152 + ( 1.0 - tex2D( _Mask, uv_Mask ).r ) ));
				float paintMask172 = smoothstepResult166;
				float3 lerpResult182 = lerp( UnpackNormal( tex2D( _Normal, uv_Normal ) ) , float3(0,0,1) , ( paintMask172 * occlusion146 ));
				float3 ase_worldTangent = i.ase_texcoord1.xyz;
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float3 ase_worldBitangent = i.ase_texcoord3.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal8_g3 = lerpResult182;
				float3 worldNormal8_g3 = float3(dot(tanToWorld0,tanNormal8_g3), dot(tanToWorld1,tanNormal8_g3), dot(tanToWorld2,tanNormal8_g3));
				float eyeDepth = i.ase_texcoord.z;
				float temp_output_4_0_g3 = ( -1.0 / UNITY_MATRIX_P[2].z );
				float temp_output_7_0_g3 = ( ( eyeDepth + temp_output_4_0_g3 ) / temp_output_4_0_g3 );
				float4 appendResult11_g3 = (float4((worldNormal8_g3*0.5 + 0.5) , temp_output_7_0_g3));
				
				float smoothness163 = tex2DNode142.a;
				float2 appendResult168 = (float2(specular152 , smoothness163));
				float2 appendResult175 = (float2(0.1 , 0.8));
				float2 lerpResult181 = lerp( appendResult168 , appendResult175 , paintMask172);
				float4 appendResult186 = (float4(lerpResult181 , occlusion146 , paintMask172));
				

				outGBuffer0 = appendResult188;
				outGBuffer1 = appendResult11_g3;
				outGBuffer2 = appendResult186;
				outGBuffer3 = 0;
				outGBuffer4 = 0;
				outGBuffer5 = 0;
				outGBuffer6 = 0;
				outGBuffer7 = 0;
				float alpha = ( tex2DNode179.a - _Cutoff );
				clip( alpha );
				outDepth = i.pos.z;
			}
			ENDCG
		}
	}
	
	
	
}
/*ASEBEGIN
Version=16307
1927;-213;1066;963;-11.75574;1360.025;2.618966;True;False
Node;AmplifyShaderEditor.VertexColorNode;137;-112,-416;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;140;810.8876,239.3147;Float;True;Property;_AmbientOcclusion;Ambient Occlusion;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;138;-112,-256;Float;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;0.6;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-112,-176;Float;False;Constant;_Float5;Float 5;6;0;Create;True;0;0;False;0;0.79;0.79;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;142;810.8876,15.31467;Float;True;Property;_SpecularSmoothness;Specular Smoothness;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;145;1091.888,-34.68533;Float;False;413;136;Fake Specular;2;152;148;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;141;112,-384;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;146;1114.888,255.3147;Float;False;occlusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;148;1114.888,15.31467;Float;False;0.5;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;143;320,-384;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;144;288,-464;Float;False;146;occlusion;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;152;1290.888,15.31467;Float;False;specular;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;480,-416;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;147;320,-288;Float;True;Property;_Mask;Mask;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;154;656,-416;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;656,-320;Float;False;152;specular;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;155;656,-240;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;157;864,-128;Float;False;Constant;_Float3;Float 3;5;0;Create;True;0;0;False;0;-0.15;-0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;159;880,-336;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;864,-208;Float;False;Constant;_Float4;Float 4;4;0;Create;True;0;0;False;0;0.35;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;166;1072,-288;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;163;1290.888,127.3147;Float;False;smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;172;1248,-288;Float;False;paintMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;164;1610.888,223.3147;Float;False;163;smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;160;1610.888,303.3147;Float;False;Constant;_paintSpecular;paintSpecular;8;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;165;1610.888,143.3147;Float;False;152;specular;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;167;1610.888,383.3147;Float;False;Constant;_paintSmoothness;paintSmoothness;8;0;Create;True;0;0;False;0;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;171;1610.888,-64.68533;Float;False;172;paintMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;173;1610.888,15.31467;Float;False;146;occlusion;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;174;1866.888,383.3147;Float;False;172;paintMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;178;1866.888,-208.6854;Float;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;180;1546.888,-288.6853;Float;True;Property;_Normal;Normal;4;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;175;1834.888,287.3147;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;168;1834.888,143.3147;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;1882.888,-64.68533;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;182;2080,-288;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;179;2096,-544;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;191;2272,-64;Float;False;Property;_Cutoff;Cutoff;5;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;185;2321.18,200.4965;Float;False;146;occlusion;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;181;2074.888,143.3147;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;189;2240,-352;Float;False;Constant;_Alpha1;Alpha1;5;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;190;2480,-80;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;187;2464,-288;Float;False;Pack Normal Depth;-1;;3;8e386dbec347c9f44befea8ff816d188;0;1;12;FLOAT3;0,0,0;False;3;FLOAT4;0;FLOAT3;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;186;2539.479,127.2396;Float;False;FLOAT4;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;188;2480,-496;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;128;2752,-272;Float;False;True;2;Float;;0;9;Hidden/Baking Barrels;f53051a8190f7044fa936bd7fbe116c1;True;Unlit;0;0;Unlit;10;False;False;False;True;0;False;-1;False;False;False;False;False;True;1;RenderType=Opaque=RenderType;True;4;0;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;0;0;1;True;False;10;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT;0;False;9;FLOAT3;0,0,0;False;0
WireConnection;141;0;137;1
WireConnection;141;1;138;0
WireConnection;141;2;139;0
WireConnection;146;0;140;1
WireConnection;148;0;142;4
WireConnection;143;0;141;0
WireConnection;152;0;148;0
WireConnection;149;0;144;0
WireConnection;149;1;143;0
WireConnection;154;0;149;0
WireConnection;155;0;147;1
WireConnection;159;0;154;0
WireConnection;159;1;153;0
WireConnection;159;2;155;0
WireConnection;166;0;159;0
WireConnection;166;1;156;0
WireConnection;166;2;157;0
WireConnection;163;0;142;4
WireConnection;172;0;166;0
WireConnection;175;0;160;0
WireConnection;175;1;167;0
WireConnection;168;0;165;0
WireConnection;168;1;164;0
WireConnection;176;0;171;0
WireConnection;176;1;173;0
WireConnection;182;0;180;0
WireConnection;182;1;178;0
WireConnection;182;2;176;0
WireConnection;181;0;168;0
WireConnection;181;1;175;0
WireConnection;181;2;174;0
WireConnection;190;0;179;4
WireConnection;190;1;191;0
WireConnection;187;12;182;0
WireConnection;186;0;181;0
WireConnection;186;2;185;0
WireConnection;186;3;174;0
WireConnection;188;0;179;0
WireConnection;188;3;189;0
WireConnection;128;0;188;0
WireConnection;128;1;187;0
WireConnection;128;2;186;0
WireConnection;128;8;190;0
ASEEND*/
//CHKSM=43E108DD493DC5996412CACAEC22CD044467E62E