// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hidden/BOXOPHOBIC/Texture Packer Blit"
{
	Properties
	{
		[HideInInspector]_MainTex("Dummy Texture", 2D) = "white" {}
		[NoScaleOffset]_Packer_TexR("Packer_TexR", 2D) = "white" {}
		[NoScaleOffset]_Packer_TexG("Packer_TexG", 2D) = "white" {}
		[NoScaleOffset]_Packer_TexB("Packer_TexB", 2D) = "white" {}
		[NoScaleOffset]_Packer_TexA("Packer_TexA", 2D) = "white" {}
		[Space(10)]_Packer_FloatR("Packer_FloatR", Range( 0 , 1)) = 0
		_Packer_FloatG("Packer_FloatG", Range( 0 , 1)) = 0
		_Packer_FloatB("Packer_FloatB", Range( 0 , 1)) = 0
		_Packer_FloatA("Packer_FloatA", Range( 0 , 1)) = 0
		[IntRange][Space(10)]_Packer_ActionB("Packer_ActionB", Range( 0 , 4)) = 0
		[IntRange][Space(10)]_Packer_ActionR("Packer_ActionR", Range( 0 , 4)) = 0
		[IntRange][Space(10)]_Packer_ActionG("Packer_ActionG", Range( 0 , 4)) = 0
		[IntRange][Space(10)]_Packer_ChannelR("Packer_ChannelR", Range( 0 , 4)) = 0
		[IntRange][Space(10)]_Packer_ActionA("Packer_ActionA", Range( 0 , 4)) = 0
		[IntRange]_Packer_ChannelG("Packer_ChannelG", Range( 0 , 4)) = 0
		[IntRange]_Packer_ChannelB("Packer_ChannelB", Range( 0 , 4)) = 0
		[IntRange]_Packer_ChannelA("Packer_ChannelA", Range( 0 , 4)) = 0
		[Space(10)]_Packer_TexR_Storage("Packer_TexR_Storage", Float) = 0
		_Packer_TexG_Storage("Packer_TexG_Storage", Float) = 0
		_Packer_TexB_Storage("Packer_TexB_Storage", Float) = 0
		[ASEEnd]_Packer_TexA_Storage("Packer_TexA_Storage", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" "PreviewType"="Plane" }
	LOD 0

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

			uniform sampler2D _MainTex;
			uniform float _Packer_TexR_Storage;
			uniform float _Packer_ActionR;
			uniform float _Packer_ChannelR;
			uniform float _Packer_FloatR;
			uniform sampler2D _Packer_TexR;
			uniform float _Packer_TexG_Storage;
			uniform float _Packer_ActionG;
			uniform float _Packer_ChannelG;
			uniform float _Packer_FloatG;
			uniform sampler2D _Packer_TexG;
			uniform float _Packer_TexB_Storage;
			uniform float _Packer_ActionB;
			uniform float _Packer_ChannelB;
			uniform float _Packer_FloatB;
			uniform sampler2D _Packer_TexB;
			uniform float _Packer_TexA_Storage;
			uniform float _Packer_ActionA;
			uniform float _Packer_ChannelA;
			uniform float _Packer_FloatA;
			uniform sampler2D _Packer_TexA;
			inline float GammaToLinearFloat100_g13( float value )
			{
				return GammaToLinearSpaceExact(value);
			}
			
			inline float LinearToGammaFloat102_g13( float value )
			{
				return LinearToGammaSpaceExact(value);
			}
			
			inline float GammaToLinearFloat100_g10( float value )
			{
				return GammaToLinearSpaceExact(value);
			}
			
			inline float LinearToGammaFloat102_g10( float value )
			{
				return LinearToGammaSpaceExact(value);
			}
			
			inline float GammaToLinearFloat100_g12( float value )
			{
				return GammaToLinearSpaceExact(value);
			}
			
			inline float LinearToGammaFloat102_g12( float value )
			{
				return LinearToGammaSpaceExact(value);
			}
			
			inline float GammaToLinearFloat100_g11( float value )
			{
				return GammaToLinearSpaceExact(value);
			}
			
			inline float LinearToGammaFloat102_g11( float value )
			{
				return LinearToGammaSpaceExact(value);
			}
			

			
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
				int Storage114_g13 = (int)_Packer_TexR_Storage;
				int Action173_g13 = (int)_Packer_ActionR;
				int Channel31_g13 = (int)_Packer_ChannelR;
				float ifLocalVar24_g13 = 0;
				if( Channel31_g13 == 0 )
				ifLocalVar24_g13 = _Packer_FloatR;
				float2 uv_Packer_TexR26 = i.ase_texcoord1.xy;
				float4 break23_g13 = tex2Dlod( _Packer_TexR, float4( uv_Packer_TexR26, 0, 0.0) );
				float R39_g13 = break23_g13.r;
				float ifLocalVar13_g13 = 0;
				if( Channel31_g13 == 1 )
				ifLocalVar13_g13 = R39_g13;
				float G40_g13 = break23_g13.g;
				float ifLocalVar12_g13 = 0;
				if( Channel31_g13 == 2 )
				ifLocalVar12_g13 = G40_g13;
				float B41_g13 = break23_g13.b;
				float ifLocalVar11_g13 = 0;
				if( Channel31_g13 == 3 )
				ifLocalVar11_g13 = B41_g13;
				float A42_g13 = break23_g13.a;
				float ifLocalVar17_g13 = 0;
				if( Channel31_g13 == 4 )
				ifLocalVar17_g13 = A42_g13;
				float GRAY135_g13 = ( ( R39_g13 * 0.3 ) + ( G40_g13 * 0.59 ) + ( B41_g13 * 0.11 ) );
				float ifLocalVar62_g13 = 0;
				if( Channel31_g13 == 555 )
				ifLocalVar62_g13 = GRAY135_g13;
				float ifLocalVar154_g13 = 0;
				if( Channel31_g13 == 14 )
				ifLocalVar154_g13 = ( R39_g13 * A42_g13 );
				float ifLocalVar159_g13 = 0;
				if( Channel31_g13 == 24 )
				ifLocalVar159_g13 = ( G40_g13 * A42_g13 );
				float ifLocalVar165_g13 = 0;
				if( Channel31_g13 == 34 )
				ifLocalVar165_g13 = ( B41_g13 * A42_g13 );
				float ifLocalVar147_g13 = 0;
				if( Channel31_g13 == 5554 )
				ifLocalVar147_g13 = ( GRAY135_g13 * A42_g13 );
				float temp_output_22_0_g13 = ( ifLocalVar24_g13 + ifLocalVar13_g13 + ifLocalVar12_g13 + ifLocalVar11_g13 + ifLocalVar17_g13 + ifLocalVar62_g13 + ifLocalVar154_g13 + ifLocalVar159_g13 + ifLocalVar165_g13 + ifLocalVar147_g13 );
				float ifLocalVar180_g13 = 0;
				if( Action173_g13 == 0 )
				ifLocalVar180_g13 = temp_output_22_0_g13;
				float ifLocalVar171_g13 = 0;
				if( Action173_g13 == 1 )
				ifLocalVar171_g13 = ( 1.0 - temp_output_22_0_g13 );
				float Value112_g13 = ( ifLocalVar180_g13 + ifLocalVar171_g13 );
				float ifLocalVar105_g13 = 0;
				if( Storage114_g13 == 0.0 )
				ifLocalVar105_g13 = Value112_g13;
				float value100_g13 = Value112_g13;
				float localGammaToLinearFloat100_g13 = GammaToLinearFloat100_g13( value100_g13 );
				float ifLocalVar93_g13 = 0;
				if( Storage114_g13 == 1.0 )
				ifLocalVar93_g13 = localGammaToLinearFloat100_g13;
				float value102_g13 = Value112_g13;
				float localLinearToGammaFloat102_g13 = LinearToGammaFloat102_g13( value102_g13 );
				float ifLocalVar107_g13 = 0;
				if( Storage114_g13 == 2.0 )
				ifLocalVar107_g13 = localLinearToGammaFloat102_g13;
				float R74 = ( ifLocalVar105_g13 + ifLocalVar93_g13 + ifLocalVar107_g13 );
				int Storage114_g10 = (int)_Packer_TexG_Storage;
				int Action173_g10 = (int)_Packer_ActionG;
				int Channel31_g10 = (int)_Packer_ChannelG;
				float ifLocalVar24_g10 = 0;
				if( Channel31_g10 == 0 )
				ifLocalVar24_g10 = _Packer_FloatG;
				float2 uv_Packer_TexG51 = i.ase_texcoord1.xy;
				float4 break23_g10 = tex2Dlod( _Packer_TexG, float4( uv_Packer_TexG51, 0, 0.0) );
				float R39_g10 = break23_g10.r;
				float ifLocalVar13_g10 = 0;
				if( Channel31_g10 == 1 )
				ifLocalVar13_g10 = R39_g10;
				float G40_g10 = break23_g10.g;
				float ifLocalVar12_g10 = 0;
				if( Channel31_g10 == 2 )
				ifLocalVar12_g10 = G40_g10;
				float B41_g10 = break23_g10.b;
				float ifLocalVar11_g10 = 0;
				if( Channel31_g10 == 3 )
				ifLocalVar11_g10 = B41_g10;
				float A42_g10 = break23_g10.a;
				float ifLocalVar17_g10 = 0;
				if( Channel31_g10 == 4 )
				ifLocalVar17_g10 = A42_g10;
				float GRAY135_g10 = ( ( R39_g10 * 0.3 ) + ( G40_g10 * 0.59 ) + ( B41_g10 * 0.11 ) );
				float ifLocalVar62_g10 = 0;
				if( Channel31_g10 == 555 )
				ifLocalVar62_g10 = GRAY135_g10;
				float ifLocalVar154_g10 = 0;
				if( Channel31_g10 == 14 )
				ifLocalVar154_g10 = ( R39_g10 * A42_g10 );
				float ifLocalVar159_g10 = 0;
				if( Channel31_g10 == 24 )
				ifLocalVar159_g10 = ( G40_g10 * A42_g10 );
				float ifLocalVar165_g10 = 0;
				if( Channel31_g10 == 34 )
				ifLocalVar165_g10 = ( B41_g10 * A42_g10 );
				float ifLocalVar147_g10 = 0;
				if( Channel31_g10 == 5554 )
				ifLocalVar147_g10 = ( GRAY135_g10 * A42_g10 );
				float temp_output_22_0_g10 = ( ifLocalVar24_g10 + ifLocalVar13_g10 + ifLocalVar12_g10 + ifLocalVar11_g10 + ifLocalVar17_g10 + ifLocalVar62_g10 + ifLocalVar154_g10 + ifLocalVar159_g10 + ifLocalVar165_g10 + ifLocalVar147_g10 );
				float ifLocalVar180_g10 = 0;
				if( Action173_g10 == 0 )
				ifLocalVar180_g10 = temp_output_22_0_g10;
				float ifLocalVar171_g10 = 0;
				if( Action173_g10 == 1 )
				ifLocalVar171_g10 = ( 1.0 - temp_output_22_0_g10 );
				float Value112_g10 = ( ifLocalVar180_g10 + ifLocalVar171_g10 );
				float ifLocalVar105_g10 = 0;
				if( Storage114_g10 == 0.0 )
				ifLocalVar105_g10 = Value112_g10;
				float value100_g10 = Value112_g10;
				float localGammaToLinearFloat100_g10 = GammaToLinearFloat100_g10( value100_g10 );
				float ifLocalVar93_g10 = 0;
				if( Storage114_g10 == 1.0 )
				ifLocalVar93_g10 = localGammaToLinearFloat100_g10;
				float value102_g10 = Value112_g10;
				float localLinearToGammaFloat102_g10 = LinearToGammaFloat102_g10( value102_g10 );
				float ifLocalVar107_g10 = 0;
				if( Storage114_g10 == 2.0 )
				ifLocalVar107_g10 = localLinearToGammaFloat102_g10;
				float G78 = ( ifLocalVar105_g10 + ifLocalVar93_g10 + ifLocalVar107_g10 );
				int Storage114_g12 = (int)_Packer_TexB_Storage;
				int Action173_g12 = (int)_Packer_ActionB;
				int Channel31_g12 = (int)_Packer_ChannelB;
				float ifLocalVar24_g12 = 0;
				if( Channel31_g12 == 0 )
				ifLocalVar24_g12 = _Packer_FloatB;
				float2 uv_Packer_TexB57 = i.ase_texcoord1.xy;
				float4 break23_g12 = tex2Dlod( _Packer_TexB, float4( uv_Packer_TexB57, 0, 0.0) );
				float R39_g12 = break23_g12.r;
				float ifLocalVar13_g12 = 0;
				if( Channel31_g12 == 1 )
				ifLocalVar13_g12 = R39_g12;
				float G40_g12 = break23_g12.g;
				float ifLocalVar12_g12 = 0;
				if( Channel31_g12 == 2 )
				ifLocalVar12_g12 = G40_g12;
				float B41_g12 = break23_g12.b;
				float ifLocalVar11_g12 = 0;
				if( Channel31_g12 == 3 )
				ifLocalVar11_g12 = B41_g12;
				float A42_g12 = break23_g12.a;
				float ifLocalVar17_g12 = 0;
				if( Channel31_g12 == 4 )
				ifLocalVar17_g12 = A42_g12;
				float GRAY135_g12 = ( ( R39_g12 * 0.3 ) + ( G40_g12 * 0.59 ) + ( B41_g12 * 0.11 ) );
				float ifLocalVar62_g12 = 0;
				if( Channel31_g12 == 555 )
				ifLocalVar62_g12 = GRAY135_g12;
				float ifLocalVar154_g12 = 0;
				if( Channel31_g12 == 14 )
				ifLocalVar154_g12 = ( R39_g12 * A42_g12 );
				float ifLocalVar159_g12 = 0;
				if( Channel31_g12 == 24 )
				ifLocalVar159_g12 = ( G40_g12 * A42_g12 );
				float ifLocalVar165_g12 = 0;
				if( Channel31_g12 == 34 )
				ifLocalVar165_g12 = ( B41_g12 * A42_g12 );
				float ifLocalVar147_g12 = 0;
				if( Channel31_g12 == 5554 )
				ifLocalVar147_g12 = ( GRAY135_g12 * A42_g12 );
				float temp_output_22_0_g12 = ( ifLocalVar24_g12 + ifLocalVar13_g12 + ifLocalVar12_g12 + ifLocalVar11_g12 + ifLocalVar17_g12 + ifLocalVar62_g12 + ifLocalVar154_g12 + ifLocalVar159_g12 + ifLocalVar165_g12 + ifLocalVar147_g12 );
				float ifLocalVar180_g12 = 0;
				if( Action173_g12 == 0 )
				ifLocalVar180_g12 = temp_output_22_0_g12;
				float ifLocalVar171_g12 = 0;
				if( Action173_g12 == 1 )
				ifLocalVar171_g12 = ( 1.0 - temp_output_22_0_g12 );
				float Value112_g12 = ( ifLocalVar180_g12 + ifLocalVar171_g12 );
				float ifLocalVar105_g12 = 0;
				if( Storage114_g12 == 0.0 )
				ifLocalVar105_g12 = Value112_g12;
				float value100_g12 = Value112_g12;
				float localGammaToLinearFloat100_g12 = GammaToLinearFloat100_g12( value100_g12 );
				float ifLocalVar93_g12 = 0;
				if( Storage114_g12 == 1.0 )
				ifLocalVar93_g12 = localGammaToLinearFloat100_g12;
				float value102_g12 = Value112_g12;
				float localLinearToGammaFloat102_g12 = LinearToGammaFloat102_g12( value102_g12 );
				float ifLocalVar107_g12 = 0;
				if( Storage114_g12 == 2.0 )
				ifLocalVar107_g12 = localLinearToGammaFloat102_g12;
				float B79 = ( ifLocalVar105_g12 + ifLocalVar93_g12 + ifLocalVar107_g12 );
				int Storage114_g11 = (int)_Packer_TexA_Storage;
				int Action173_g11 = (int)_Packer_ActionA;
				int Channel31_g11 = (int)_Packer_ChannelA;
				float ifLocalVar24_g11 = 0;
				if( Channel31_g11 == 0 )
				ifLocalVar24_g11 = _Packer_FloatA;
				float2 uv_Packer_TexA60 = i.ase_texcoord1.xy;
				float4 break23_g11 = tex2Dlod( _Packer_TexA, float4( uv_Packer_TexA60, 0, 0.0) );
				float R39_g11 = break23_g11.r;
				float ifLocalVar13_g11 = 0;
				if( Channel31_g11 == 1 )
				ifLocalVar13_g11 = R39_g11;
				float G40_g11 = break23_g11.g;
				float ifLocalVar12_g11 = 0;
				if( Channel31_g11 == 2 )
				ifLocalVar12_g11 = G40_g11;
				float B41_g11 = break23_g11.b;
				float ifLocalVar11_g11 = 0;
				if( Channel31_g11 == 3 )
				ifLocalVar11_g11 = B41_g11;
				float A42_g11 = break23_g11.a;
				float ifLocalVar17_g11 = 0;
				if( Channel31_g11 == 4 )
				ifLocalVar17_g11 = A42_g11;
				float GRAY135_g11 = ( ( R39_g11 * 0.3 ) + ( G40_g11 * 0.59 ) + ( B41_g11 * 0.11 ) );
				float ifLocalVar62_g11 = 0;
				if( Channel31_g11 == 555 )
				ifLocalVar62_g11 = GRAY135_g11;
				float ifLocalVar154_g11 = 0;
				if( Channel31_g11 == 14 )
				ifLocalVar154_g11 = ( R39_g11 * A42_g11 );
				float ifLocalVar159_g11 = 0;
				if( Channel31_g11 == 24 )
				ifLocalVar159_g11 = ( G40_g11 * A42_g11 );
				float ifLocalVar165_g11 = 0;
				if( Channel31_g11 == 34 )
				ifLocalVar165_g11 = ( B41_g11 * A42_g11 );
				float ifLocalVar147_g11 = 0;
				if( Channel31_g11 == 5554 )
				ifLocalVar147_g11 = ( GRAY135_g11 * A42_g11 );
				float temp_output_22_0_g11 = ( ifLocalVar24_g11 + ifLocalVar13_g11 + ifLocalVar12_g11 + ifLocalVar11_g11 + ifLocalVar17_g11 + ifLocalVar62_g11 + ifLocalVar154_g11 + ifLocalVar159_g11 + ifLocalVar165_g11 + ifLocalVar147_g11 );
				float ifLocalVar180_g11 = 0;
				if( Action173_g11 == 0 )
				ifLocalVar180_g11 = temp_output_22_0_g11;
				float ifLocalVar171_g11 = 0;
				if( Action173_g11 == 1 )
				ifLocalVar171_g11 = ( 1.0 - temp_output_22_0_g11 );
				float Value112_g11 = ( ifLocalVar180_g11 + ifLocalVar171_g11 );
				float ifLocalVar105_g11 = 0;
				if( Storage114_g11 == 0.0 )
				ifLocalVar105_g11 = Value112_g11;
				float value100_g11 = Value112_g11;
				float localGammaToLinearFloat100_g11 = GammaToLinearFloat100_g11( value100_g11 );
				float ifLocalVar93_g11 = 0;
				if( Storage114_g11 == 1.0 )
				ifLocalVar93_g11 = localGammaToLinearFloat100_g11;
				float value102_g11 = Value112_g11;
				float localLinearToGammaFloat102_g11 = LinearToGammaFloat102_g11( value102_g11 );
				float ifLocalVar107_g11 = 0;
				if( Storage114_g11 == 2.0 )
				ifLocalVar107_g11 = localLinearToGammaFloat102_g11;
				float A80 = ( ifLocalVar105_g11 + ifLocalVar93_g11 + ifLocalVar107_g11 );
				float4 appendResult48 = (float4(R74 , G78 , B79 , A80));
				
				
				finalColor = appendResult48;
				return finalColor;
			}
			ENDCG
		}
	}
	
	
	
}
/*ASEBEGIN
Version=18806
1920;20;1906;1009;1214.726;813.3753;2.155619;True;False
Node;AmplifyShaderEditor.RangedFloatNode;59;2176,192;Float;False;Property;_Packer_FloatB;Packer_FloatB;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;142;3328,448;Float;False;Property;_Packer_TexA_Storage;Packer_TexA_Storage;20;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;259;2176,336;Float;False;Property;_Packer_ActionB;Packer_ActionB;9;1;[IntRange];Create;True;0;0;0;False;1;Space(10);False;0;1;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;1024,336;Float;False;Property;_Packer_ActionG;Packer_ActionG;11;1;[IntRange];Create;True;0;0;0;False;1;Space(10);False;0;1;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;1024,448;Float;False;Property;_Packer_TexG_Storage;Packer_TexG_Storage;18;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;257;-128,336;Float;False;Property;_Packer_ActionR;Packer_ActionR;10;1;[IntRange];Create;True;0;0;0;False;1;Space(10);False;0;1;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-128,272;Float;False;Property;_Packer_ChannelR;Packer_ChannelR;12;1;[IntRange];Create;True;0;0;0;False;1;Space(10);False;0;1;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-128,448;Float;False;Property;_Packer_TexR_Storage;Packer_TexR_Storage;17;0;Create;True;0;0;0;False;1;Space(10);False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-128,192;Float;False;Property;_Packer_FloatR;Packer_FloatR;5;0;Create;True;0;0;0;False;1;Space(10);False;0;0.519;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;1024,192;Float;False;Property;_Packer_FloatG;Packer_FloatG;6;0;Create;True;0;0;0;False;0;False;0;0.356;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;2176,448;Float;False;Property;_Packer_TexB_Storage;Packer_TexB_Storage;19;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-128,0;Inherit;True;Property;_Packer_TexR;Packer_TexR;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;60;3328,0;Inherit;True;Property;_Packer_TexA;Packer_TexA;4;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;67;2176,272;Float;False;Property;_Packer_ChannelB;Packer_ChannelB;15;1;[IntRange];Create;True;0;0;0;False;0;False;0;3;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;51;1024,0;Inherit;True;Property;_Packer_TexG;Packer_TexG;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;66;1024,272;Float;False;Property;_Packer_ChannelG;Packer_ChannelG;14;1;[IntRange];Create;True;0;0;0;False;0;False;0;2;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;3328,272;Float;False;Property;_Packer_ChannelA;Packer_ChannelA;16;1;[IntRange];Create;True;0;0;0;False;0;False;0;4;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;260;3328,336;Float;False;Property;_Packer_ActionA;Packer_ActionA;13;1;[IntRange];Create;True;0;0;0;False;1;Space(10);False;0;1;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;57;2176,0;Inherit;True;Property;_Packer_TexB;Packer_TexB;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;64;3328,192;Float;False;Property;_Packer_FloatA;Packer_FloatA;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;262;3840,0;Inherit;False;Texture Packer Channel;-1;;11;e76e01ea35349c34d9155714d95a561c;0;5;19;COLOR;0,0,0,0;False;25;FLOAT;0;False;10;INT;0;False;172;INT;0;False;56;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;261;1536,0;Inherit;False;Texture Packer Channel;-1;;10;e76e01ea35349c34d9155714d95a561c;0;5;19;COLOR;0,0,0,0;False;25;FLOAT;0;False;10;INT;0;False;172;INT;0;False;56;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;264;384,0;Inherit;False;Texture Packer Channel;-1;;13;e76e01ea35349c34d9155714d95a561c;0;5;19;COLOR;0,0,0,0;False;25;FLOAT;0;False;10;INT;0;False;172;INT;0;False;56;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;263;2688,0;Inherit;False;Texture Packer Channel;-1;;12;e76e01ea35349c34d9155714d95a561c;0;5;19;COLOR;0,0,0,0;False;25;FLOAT;0;False;10;INT;0;False;172;INT;0;False;56;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;4160,0;Float;False;A;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;1856,0;Float;False;G;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;3008,0;Float;False;B;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;704,0;Float;False;R;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-128,768;Inherit;False;74;R;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;-128,1008;Inherit;False;80;A;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;146;-128,928;Inherit;False;79;B;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;144;-128,848;Inherit;False;78;G;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;48;128,768;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;155;4480,0;Inherit;True;Property;_MainTex;Dummy Texture;0;1;[HideInInspector];Create;False;0;0;0;True;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;320,768;Float;False;True;-1;2;;0;1;Hidden/BOXOPHOBIC/Texture Packer Blit;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Opaque=RenderType;PreviewType=Plane;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;262;19;60;0
WireConnection;262;25;64;0
WireConnection;262;10;68;0
WireConnection;262;172;260;0
WireConnection;262;56;142;0
WireConnection;261;19;51;0
WireConnection;261;25;50;0
WireConnection;261;10;66;0
WireConnection;261;172;258;0
WireConnection;261;56;138;0
WireConnection;264;19;26;0
WireConnection;264;25;47;0
WireConnection;264;10;65;0
WireConnection;264;172;257;0
WireConnection;264;56;72;0
WireConnection;263;19;57;0
WireConnection;263;25;59;0
WireConnection;263;10;67;0
WireConnection;263;172;259;0
WireConnection;263;56;140;0
WireConnection;80;0;262;0
WireConnection;78;0;261;0
WireConnection;79;0;263;0
WireConnection;74;0;264;0
WireConnection;48;0;143;0
WireConnection;48;1;144;0
WireConnection;48;2;146;0
WireConnection;48;3;145;0
WireConnection;0;0;48;0
ASEEND*/
//CHKSM=8947A5F28E6CF4228DF9D59CF75BF964F2700BCE