// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BOXOPHOBIC/The Vegetation Engine/Helpers/I Made It"
{
	Properties
	{
		[StyledBanner(I Made It)]_Banner("Banner", Float) = 0
		[StyledMessage(Info, Use this helper shader to set your maps and the converter will pack them to be used with the vegetation shaders. All the other parameters will be set on the vegetation materials., 5, 5 )]_MainMessage("!!! Main Message !!!", Float) = 0
		[StyledCategory(Settings)]_SettingsCategory("[ Settings Category ]", Float) = 0
		[Enum(Leaf,0,Bark,1)]_ShaderMode("Shader Mode", Float) = 0
		[Enum(Subsurface Map,0,Thickness Map,1)]_SubsurfaceMode("Subsurface Mode", Float) = 0
		[StyledCategory(Base Maps)]_BaseCategory("[ Base Category ]", Float) = 0
		[NoScaleOffset]_AlbedoTex("Albedo (RGB) Alpha (A)", 2D) = "white" {}
		[NoScaleOffset]_NormalTex("Normal", 2D) = "bump" {}
		[StyledCategory(Surface Maps)]_SurfaceCategory("[ Surface Category ]", Float) = 0
		[StyledMessage(Info, Use a Mask Map for the surface shading. If any separate map is added the converter will pack that specific map., 5, 10 )]_SurfaceMessage("!!! Surface Message !!!", Float) = 0
		[NoScaleOffset]_MaskTex("Mask Metallic (R) Occlusion (G) Mask (B) Smoothness (A)", 2D) = "gray" {}
		[NoScaleOffset]_MetallicTex("Metallic", 2D) = "gray" {}
		[NoScaleOffset]_OcclusionTex("Occlusion", 2D) = "gray" {}
		[NoScaleOffset]_SmoothnessTex("Smoothness", 2D) = "gray" {}
		[StyledCategory(Leaf Maps)]_LeafCategory("[ Leaf Category ]", Float) = 0
		[StyledMessage(Info, The Subsurface will be packed in the Main Mask blue channel for foliage shaders. Add this map only for leaf materials., 5, 10 )]_LeafMessage("!!! Leaf Message !!!", Float) = 0
		[NoScaleOffset]_SubsurfaceTex("Subsurface or Thickness", 2D) = "gray" {}
		[StyledCategory(Bark Maps)]_BarkCategory("[ Bark Category ]", Float) = 0
		[StyledMessage(Info, The Height or Detail Mask will be packed in the Main Mask blue channel for bark shaders. Add this map only for bark materials., 5, 10 )]_BarkMessage("!!! Bark Message !!!", Float) = 0
		[NoScaleOffset]_HeightTex("Height or Detail Mask", 2D) = "gray" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			//Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform half _BarkCategory;
			uniform float _SurfaceMessage;
			uniform half _SurfaceCategory;
			uniform half _LeafCategory;
			uniform float _ShaderMode;
			uniform sampler2D _MaskTex;
			uniform sampler2D _MetallicTex;
			uniform sampler2D _HeightTex;
			uniform float _MainMessage;
			uniform float _SubsurfaceMode;
			uniform sampler2D _SubsurfaceTex;
			uniform sampler2D _OcclusionTex;
			uniform half _Banner;
			uniform float _LeafMessage;
			uniform float _BarkMessage;
			uniform half _BaseCategory;
			uniform half _SettingsCategory;
			uniform sampler2D _SmoothnessTex;
			uniform sampler2D _NormalTex;
			uniform sampler2D _AlbedoTex;
			SamplerState sampler_AlbedoTex;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_AlbedoTex437 = i.ase_texcoord1.xy;
				float4 tex2DNode437 = tex2D( _AlbedoTex, uv_AlbedoTex437 );
				clip( tex2DNode437.a - 0.5);
				
				
				finalColor = tex2DNode437;
				return finalColor;
			}
			ENDCG
		}
	}
	
	
	
}
/*ASEBEGIN
Version=18600
1927;7;1906;1014;3017.316;485.1;1;True;False
Node;AmplifyShaderEditor.SamplerNode;437;-2176,-128;Inherit;True;Property;_AlbedoTex;Albedo (RGB) Alpha (A);6;1;[NoScaleOffset];Create;False;0;0;False;0;False;-1;None;d9cd529f91ad42d0a2fc257448fe699b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-2176,-768;Half;False;Property;_Banner;Banner;0;0;Create;True;0;0;True;1;StyledBanner(I Made It);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;451;-1728,-512;Inherit;False;Property;_LeafMessage;!!! Leaf Message !!!;15;0;Create;True;0;0;True;1;StyledMessage(Info, The Subsurface will be packed in the Main Mask blue channel for foliage shaders. Add this map only for leaf materials., 5, 10 );False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;445;-2176,832;Inherit;True;Property;_OcclusionTex;Occlusion;12;1;[NoScaleOffset];Create;False;0;0;True;0;False;-1;None;None;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;450;-1328,-768;Inherit;False;Property;_SubsurfaceMode;Subsurface Mode;4;1;[Enum];Create;False;2;Subsurface Map;0;Thickness Map;1;0;True;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;449;-2176,1376;Inherit;True;Property;_SubsurfaceTex;Subsurface or Thickness;16;1;[NoScaleOffset];Create;False;0;0;True;0;False;-1;None;None;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;446;-2176,1024;Inherit;True;Property;_SmoothnessTex;Smoothness;13;1;[NoScaleOffset];Create;False;0;0;True;0;False;-1;None;None;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;438;-2176,128;Inherit;True;Property;_NormalTex;Normal;7;1;[NoScaleOffset];Create;False;0;0;True;0;False;-1;None;9dfc9a282cd0490b9ffd3c16f5555d14;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;455;-2176,-640;Half;False;Property;_SettingsCategory;[ Settings Category ];2;0;Create;True;0;0;True;1;StyledCategory(Settings);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;453;-1504,-512;Inherit;False;Property;_BarkMessage;!!! Bark Message !!!;18;0;Create;True;0;0;True;1;StyledMessage(Info, The Height or Detail Mask will be packed in the Main Mask blue channel for bark shaders. Add this map only for bark materials., 5, 10 );False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;435;-1952,-640;Half;False;Property;_BaseCategory;[ Base Category ];5;0;Create;True;0;0;True;1;StyledCategory(Base Maps);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;447;-1536,-640;Half;False;Property;_LeafCategory;[ Leaf Category ];14;0;Create;True;0;0;True;1;StyledCategory(Leaf Maps);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;454;-1520,-768;Inherit;False;Property;_ShaderMode;Shader Mode;3;1;[Enum];Create;False;2;Leaf;0;Bark;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;441;-1760,-640;Half;False;Property;_SurfaceCategory;[ Surface Category ];8;0;Create;True;0;0;True;1;StyledCategory(Surface Maps);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;452;-1312,-640;Half;False;Property;_BarkCategory;[ Bark Category ];17;0;Create;True;0;0;True;1;StyledCategory(Bark Maps);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;444;-1968,-512;Inherit;False;Property;_SurfaceMessage;!!! Surface Message !!!;9;0;Create;True;0;0;True;1;StyledMessage(Info, Use a Mask Map for the surface shading. If any separate map is added the converter will pack that specific map., 5, 10 );False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;448;-2176,1568;Inherit;True;Property;_HeightTex;Height or Detail Mask;19;1;[NoScaleOffset];Create;False;0;0;True;0;False;-1;None;None;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;357;-2176,-512;Inherit;False;Property;_MainMessage;!!! Main Message !!!;1;0;Create;True;0;0;True;1;StyledMessage(Info, Use this helper shader to set your maps and the converter will pack them to be used with the vegetation shaders. All the other parameters will be set on the vegetation materials., 5, 5 );False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;442;-2176,640;Inherit;True;Property;_MetallicTex;Metallic;11;1;[NoScaleOffset];Create;False;0;0;True;0;False;-1;None;None;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;440;-2176,384;Inherit;True;Property;_MaskTex;Mask Metallic (R) Occlusion (G) Mask (B) Smoothness (A);10;1;[NoScaleOffset];Create;False;0;0;True;0;False;-1;None;029ca72742c94299aa081f9a95e2a0f0;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClipNode;457;-1792,-128;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;456;-1376,-128;Float;False;True;-1;2;;100;1;BOXOPHOBIC/The Vegetation Engine/Helpers/I Made It;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
Node;AmplifyShaderEditor.CommentaryNode;37;-2176,-896;Inherit;False;1023.392;100;Internal;0;;1,0.252,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;33;-2176,-256;Inherit;False;1024.392;100;Final;0;;0.3439424,0.5960785,0,1;0;0
WireConnection;457;0;437;0
WireConnection;457;1;437;4
WireConnection;456;0;457;0
ASEEND*/
//CHKSM=347A00B8F9CDEBD2AC24A7217E332C00E354E61F