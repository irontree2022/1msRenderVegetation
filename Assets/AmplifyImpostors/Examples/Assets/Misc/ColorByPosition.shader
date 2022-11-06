// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Impostors/Examples/ColorByPosition"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Mask("Mask", 2D) = "white" {}
		_AmbientOcclusion("Ambient Occlusion", 2D) = "white" {}
		_SpecularSmoothness("Specular Smoothness", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _AmbientOcclusion;
		uniform float4 _AmbientOcclusion_ST;
		uniform sampler2D _SpecularSmoothness;
		uniform float4 _SpecularSmoothness_ST;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float2 uv_AmbientOcclusion = i.uv_texcoord * _AmbientOcclusion_ST.xy + _AmbientOcclusion_ST.zw;
			float occlusion97 = tex2D( _AmbientOcclusion, uv_AmbientOcclusion ).r;
			float2 uv_SpecularSmoothness = i.uv_texcoord * _SpecularSmoothness_ST.xy + _SpecularSmoothness_ST.zw;
			float4 tex2DNode49 = tex2D( _SpecularSmoothness, uv_SpecularSmoothness );
			float specular101 = ( tex2DNode49.a * 0.5 );
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float smoothstepResult52 = smoothstep( 0.35 , -0.15 , ( ( 1.0 - ( occlusion97 * saturate( (i.vertexColor.r*0.6 + 0.79) ) ) ) + specular101 + ( 1.0 - tex2D( _Mask, uv_Mask ).r ) ));
			float paintMask83 = smoothstepResult52;
			float3 lerpResult63 = lerp( UnpackNormal( tex2D( _Normal, uv_Normal ) ) , float3(0,0,1) , ( paintMask83 * occlusion97 ));
			o.Normal = lerpResult63;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 transform30 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 hsvTorgb44 = HSVToRGB( float3(abs( sin( ( transform30.x + transform30.z ) ) ),1.0,1.0) );
			float4 lerpResult59 = lerp( tex2D( _MainTex, uv_MainTex ) , float4( ( paintMask83 * hsvTorgb44 ) , 0.0 ) , paintMask83);
			o.Albedo = lerpResult59.rgb;
			float smoothness117 = tex2DNode49.a;
			float2 appendResult111 = (float2(specular101 , smoothness117));
			float2 appendResult108 = (float2(0.1 , 0.8));
			float2 lerpResult68 = lerp( appendResult111 , appendResult108 , paintMask83);
			float2 break119 = lerpResult68;
			float3 temp_cast_2 = (break119).xxx;
			o.Specular = temp_cast_2;
			o.Smoothness = break119.y;
			o.Occlusion = occlusion97;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=15501
378;253;1200;780;562.8884;1033.549;2.583621;False;False
Node;AmplifyShaderEditor.RangedFloatNode;95;-512,16;Float;False;Constant;_Float5;Float 5;6;0;Create;True;0;0;False;0;0.79;0.79;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-512,-64;Float;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;0.6;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;89;-512,-224;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;94;-288,-192;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;48;480,432;Float;True;Property;_AmbientOcclusion;Ambient Occlusion;2;0;Create;True;0;0;False;0;09eea9b1b26d9eb489d87839972a8ff3;09eea9b1b26d9eb489d87839972a8ff3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;120;761,158;Float;False;413;136;Fake Specular;2;101;116;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;784,448;Float;False;occlusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-112,-272;Float;False;97;occlusion;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;49;480,208;Float;True;Property;_SpecularSmoothness;Specular Smoothness;3;0;Create;True;0;0;False;0;d56a69fb0521f3246b44d8095fbfc1c8;d56a69fb0521f3246b44d8095fbfc1c8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;93;-80,-192;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;80,-224;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;30;688,-352;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;38;-80,-96;Float;True;Property;_Mask;Mask;1;0;Create;True;0;0;False;0;7f1493c796ce4494cb3cca9fea5b6d4c;7f1493c796ce4494cb3cca9fea5b6d4c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleNode;116;784,208;Float;False;0.5;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;70;256,-224;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;75;256,-48;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;256,-128;Float;False;101;specular;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;107;944,-320;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;960,208;Float;False;specular;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;34;1072,-320;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;480,-144;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;464,-16;Float;False;Constant;_Float4;Float 4;4;0;Create;True;0;0;False;0;0.35;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;464,64;Float;False;Constant;_Float3;Float 3;5;0;Create;True;0;0;False;0;-0.15;-0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;1280,336;Float;False;101;specular;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;1280,416;Float;False;117;smoothness;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;1280,576;Float;False;Constant;_paintSmoothness;paintSmoothness;8;0;Create;True;0;0;False;0;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;52;672,-96;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;1200,-240;Float;False;Constant;_Float8;Float 8;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;1280,496;Float;False;Constant;_paintSpecular;paintSpecular;8;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;960,320;Float;False;smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;35;1216,-320;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;1280,208;Float;False;97;occlusion;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;848,-96;Float;False;paintMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;108;1504,480;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;1536,576;Float;False;83;paintMask;0;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;44;1360,-320;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;111;1504,336;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;1280,128;Float;False;83;paintMask;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;1360,-416;Float;False;83;paintMask;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;1552,-592;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;40ce0b7000ac5df449255a5e0d17119f;59b3ff16914d514459bb451015521dfe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;62;1216,-96;Float;True;Property;_Normal;Normal;4;0;Create;True;0;0;False;0;None;93b159a83e4be0841bb1fd728cb94041;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;68;1744,336;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;1552,128;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;1632,-352;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;64;1536,-16;Float;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;59;1888,-464;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;1990.292,393.1819;Float;False;97;occlusion;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;63;1776,-96;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;119;1920,256;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2272,-32;Float;False;True;2;Float;;0;0;StandardSpecular;Impostors/Examples/ColorByPosition;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;94;0;89;1
WireConnection;94;1;92;0
WireConnection;94;2;95;0
WireConnection;97;0;48;1
WireConnection;93;0;94;0
WireConnection;90;0;100;0
WireConnection;90;1;93;0
WireConnection;116;0;49;4
WireConnection;70;0;90;0
WireConnection;75;0;38;1
WireConnection;107;0;30;1
WireConnection;107;1;30;3
WireConnection;101;0;116;0
WireConnection;34;0;107;0
WireConnection;76;0;70;0
WireConnection;76;1;105;0
WireConnection;76;2;75;0
WireConnection;52;0;76;0
WireConnection;52;1;54;0
WireConnection;52;2;53;0
WireConnection;117;0;49;4
WireConnection;35;0;34;0
WireConnection;83;0;52;0
WireConnection;108;0;69;0
WireConnection;108;1;67;0
WireConnection;44;0;35;0
WireConnection;44;1;96;0
WireConnection;44;2;96;0
WireConnection;111;0;102;0
WireConnection;111;1;118;0
WireConnection;68;0;111;0
WireConnection;68;1;108;0
WireConnection;68;2;86;0
WireConnection;88;0;85;0
WireConnection;88;1;99;0
WireConnection;56;0;84;0
WireConnection;56;1;44;0
WireConnection;59;0;1;0
WireConnection;59;1;56;0
WireConnection;59;2;84;0
WireConnection;63;0;62;0
WireConnection;63;1;64;0
WireConnection;63;2;88;0
WireConnection;119;0;68;0
WireConnection;0;0;59;0
WireConnection;0;1;63;0
WireConnection;0;3;119;0
WireConnection;0;4;119;1
WireConnection;0;5;98;0
ASEEND*/
//CHKSM=95341A14E0F0A4BDF0270B1A25FA6048F9BA0EFE