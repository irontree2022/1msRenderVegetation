// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Impostors/Examples/StandardCrossfade"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_ColorTint("Color Tint", Color) = (0,0,0,0)
		[NoScaleOffset]_Normal("Normal", 2D) = "bump" {}
		[NoScaleOffset]_Occlusion("Occlusion", 2D) = "white" {}
		_OcclusionAmount("Occlusion Amount", Range( 0 , 1)) = 1
		[NoScaleOffset]_SpecularSmoothness("Specular & Smoothness", 2D) = "white" {}
		_SpecSmoothTint("Spec Smooth Tint", Color) = (0.5019608,0.5019608,0.5019608,0.1176471)
		_DetailAlbedo("Detail Albedo", 2D) = "white" {}
		[NoScaleOffset]_DetailMask("Detail Mask", 2D) = "white" {}
		[NoScaleOffset]_DetailNormal("Detail Normal", 2D) = "bump" {}
		[Toggle(_USEDETAILMAPS_ON)] _UseDetailMaps("Use Detail Maps", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma shader_feature _USEDETAILMAPS_ON
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows dithercrossfade 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _DetailNormal;
		uniform sampler2D _DetailAlbedo;
		uniform float4 _DetailAlbedo_ST;
		uniform sampler2D _DetailMask;
		uniform float4 _ColorTint;
		uniform sampler2D _SpecularSmoothness;
		uniform float4 _SpecSmoothTint;
		uniform sampler2D _Occlusion;
		uniform float _OcclusionAmount;


		float3 AddDetail( float3 b , float t )
		{
			half oneMinusT = 1 - t;
			return half3(oneMinusT, oneMinusT, oneMinusT) + b * unity_ColorSpaceDouble.rgb * t;
		}


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 tex2DNode6 = UnpackNormal( tex2D( _Normal, uv_MainTex ) );
			float2 uv_DetailAlbedo = i.uv_texcoord * _DetailAlbedo_ST.xy + _DetailAlbedo_ST.zw;
			float4 tex2DNode15 = tex2D( _DetailMask, uv_MainTex );
			float3 lerpResult20 = lerp( tex2DNode6 , BlendNormals( UnpackNormal( tex2D( _DetailNormal, uv_DetailAlbedo ) ) , tex2DNode6 ) , tex2DNode15.r);
			#ifdef _USEDETAILMAPS_ON
				float3 staticSwitch29 = lerpResult20;
			#else
				float3 staticSwitch29 = tex2DNode6;
			#endif
			o.Normal = staticSwitch29;
			float4 temp_output_31_0 = ( _ColorTint * tex2D( _MainTex, uv_MainTex ) );
			float3 b13 = tex2D( _DetailAlbedo, uv_DetailAlbedo ).rgb;
			float t13 = tex2DNode15.r;
			float3 localAddDetail13 = AddDetail( b13 , t13 );
			#ifdef _USEDETAILMAPS_ON
				float4 staticSwitch30 = ( temp_output_31_0 * float4( localAddDetail13 , 0.0 ) );
			#else
				float4 staticSwitch30 = temp_output_31_0;
			#endif
			o.Albedo = staticSwitch30.rgb;
			float4 temp_output_26_0 = ( tex2D( _SpecularSmoothness, uv_MainTex ) * _SpecSmoothTint );
			o.Specular = temp_output_26_0.rgb;
			o.Smoothness = (temp_output_26_0).a;
			o.Occlusion = ( 1.0 - ( ( 1.0 - tex2D( _Occlusion, uv_MainTex ).r ) * _OcclusionAmount ) );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=15410
1928;85;1065;772;1556.515;811.2207;2.48534;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1276.388,-2.517048;Float;False;0;12;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-811.6846,323.2209;Float;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;16;-930.2218,104.8008;Float;True;Property;_DetailNormal;Detail Normal;9;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-423.5671,184.3663;Float;True;Property;_Normal;Normal;2;1;[NoScaleOffset];Create;True;0;0;False;0;None;096e8b491913f204ca1bd73901acfcec;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-423.8571,606.7608;Float;True;Property;_Occlusion;Occlusion;3;1;[NoScaleOffset];Create;True;0;0;False;0;None;40ce0b7000ac5df449255a5e0d17119f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;-426.4384,-276.45;Float;True;Property;_DetailMask;Detail Mask;8;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-435.06,-494.7381;Float;True;Property;_DetailAlbedo;Detail Albedo;7;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-437.4417,-47.96619;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;488be4821ece012498ce423c38511544;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;32;-696.5145,-123.4491;Float;False;Property;_ColorTint;Color Tint;1;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-398.9666,827.0817;Float;False;Property;_OcclusionAmount;Occlusion Amount;4;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;10;-108.3094,647.152;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-427.2519,406.044;Float;True;Property;_SpecularSmoothness;Specular & Smoothness;5;1;[NoScaleOffset];Create;True;0;0;False;0;None;a167f1cf54425724a8f890313aefc4d4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;19;38.45527,126.1322;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;13;-91.84138,-197.1854;Float;False;half oneMinusT = 1 - t@$return half3(oneMinusT, oneMinusT, oneMinusT) + b * unity_ColorSpaceDouble.rgb * t@;3;False;2;True;b;FLOAT3;0,0,0;In;;True;t;FLOAT;0;In;;AddDetail;False;False;0;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-90.38498,-105.0039;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;25;-116.7959,458.4807;Float;False;Property;_SpecSmoothTint;Spec Smooth Tint;6;0;Create;True;0;0;False;0;0.5019608,0.5019608,0.5019608,0.1176471;1,1,1,0.141;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;85.59625,236.8928;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;20;274.1569,-297.1058;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;89.4164,672.8557;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;301.109,-24.7533;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;27;226.3593,326.9926;Float;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;29;161.2332,-472.7453;Float;False;Property;_UseDetailMaps;Use Detail Maps;10;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;30;570.7776,-365.0427;Float;False;Property;_UseDetailMaps;Use Detail Maps;9;0;Fetch;True;0;0;False;0;0;0;0;False;_USEDETAILMAPS_ON;Toggle;2;Key0;Key1;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;11;200.1425,548.2894;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;561.7637,36.89568;Float;False;True;2;Float;;0;0;StandardSpecular;Impostors/Examples/StandardCrossfade;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;True;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;1;17;0
WireConnection;6;1;28;0
WireConnection;4;1;28;0
WireConnection;15;1;28;0
WireConnection;12;1;17;0
WireConnection;1;1;28;0
WireConnection;10;0;4;1
WireConnection;7;1;28;0
WireConnection;19;0;16;0
WireConnection;19;1;6;0
WireConnection;13;0;12;0
WireConnection;13;1;15;1
WireConnection;31;0;32;0
WireConnection;31;1;1;0
WireConnection;26;0;7;0
WireConnection;26;1;25;0
WireConnection;20;0;6;0
WireConnection;20;1;19;0
WireConnection;20;2;15;1
WireConnection;8;0;10;0
WireConnection;8;1;9;0
WireConnection;14;0;31;0
WireConnection;14;1;13;0
WireConnection;27;0;26;0
WireConnection;29;1;6;0
WireConnection;29;0;20;0
WireConnection;30;1;31;0
WireConnection;30;0;14;0
WireConnection;11;0;8;0
WireConnection;0;0;30;0
WireConnection;0;1;29;0
WireConnection;0;3;26;0
WireConnection;0;4;27;0
WireConnection;0;5;11;0
ASEEND*/
//CHKSM=23EA1CF50BE33F7DC0A0513FD128CA01D778DEBA