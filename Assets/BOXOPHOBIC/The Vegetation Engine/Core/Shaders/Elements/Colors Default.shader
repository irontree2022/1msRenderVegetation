// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BOXOPHOBIC/The Vegetation Engine/Elements/Default/Colors Default"
{
	Properties
	{
		[StyledBanner(Color Element)]_Banner("Banner", Float) = 0
		[StyledMessage(Info, Use the Colors elements to add color tinting to the vegetation assets. Element Texture R is used as alpha mask. Particle Color RGB is used as Main multiplier and Alpha as Element Intensity multiplier., 0,0)]_Message("Message", Float) = 0
		[StyledCategory(Render Settings)]_RenderCat("[ Render Cat ]", Float) = 0
		_ElementIntensity("Element Intensity", Range( 0 , 1)) = 1
		[StyledMessage(Info, When using a higher Layer number the Global Volume will create more render textures to render the elements. Try using fewer layers when posibble., _ElementLayerMessage, 1, 10, 10)]_ElementLayerMessage("Element Layer Message", Float) = 0
		[StyledEnum(Default _Layer 1 _Layer 2 _Layer 3 _Layer 4 _Layer 5 _Layer 6 _Layer 7 _Layer 8)]_ElementLayerValue("Element Layer", Float) = 0
		[Enum(Constant,0,Seasons,1)]_ElementMode("Element Mode", Float) = 0
		[Enum(Multiply Material Colors,0,Replace Material Colors,1)]_ElementEffect("Element Effect", Float) = 0
		[StyledCategory(Element Settings)]_ElementCat("[ Element Cat ]", Float) = 0
		[NoScaleOffset][StyledTextureSingleLine]_MainTex("Element Texture", 2D) = "white" {}
		[StyledSpace(10)]_MainTexSpace("#MainTex Space", Float) = 0
		[StyledRemapSlider(_MainTexMinValue, _MainTexMaxValue, 0, 1)]_MainTexRemap("Element Remap", Vector) = (0,0,0,0)
		[HideInInspector]_MainTexMinValue("Element Min", Range( 0 , 1)) = 0
		[HideInInspector]_MainTexMaxValue("Element Max", Range( 0 , 1)) = 1
		[StyledVector(9)]_MainUVs("Element UVs", Vector) = (1,1,0,0)
		[HDR][Gamma]_MainColor("Element Color", Color) = (0.5019608,0.5019608,0.5019608,1)
		[HDR][Gamma]_AdditionalColor1("Winter Color", Color) = (0.5019608,0.5019608,0.5019608,1)
		[HDR][Gamma]_AdditionalColor2("Spring Color", Color) = (0.5019608,0.5019608,0.5019608,1)
		[HDR][Gamma]_AdditionalColor3("Summer Color", Color) = (0.5019608,0.5019608,0.5019608,1)
		[HDR][Gamma]_AdditionalColor4("Autumn Color", Color) = (0.5019608,0.5019608,0.5019608,1)
		[StyledRemapSlider(_NoiseMinValue, _NoiseMaxValue, 0, 1)]_NoiseRemap("Noise Remap", Vector) = (0,0,0,0)
		[StyledCategory(Advanced)]_AdvancedCat("[ Advanced Cat ]", Float) = 0
		[StyledMessage(Info, Use this feature to fade out elements close to a volume edges to avoid rendering issues when the element is exiting the volume., _ElementFadeSupport, 1, 2, 10)]_ElementFadeMessage("Enable Fade Message", Float) = 0
		[ASEEnd][StyledToggle]_ElementFadeSupport("Enable Edge Fade Support", Float) = 0
		[HideInInspector]_IsVersion("_IsVersion", Float) = 400
		[HideInInspector]_IsElementShader("_IsElementShader", Float) = 1
		[HideInInspector]_IsColorsShader("_IsColorsShader", Float) = 1
		[HideInInspector]_render_colormask("_render_colormask", Float) = 14

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "PreviewType"="Plane" }
	LOD 0

		CGINCLUDE
		#pragma target 2.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask [_render_colormask]
		ZWrite Off
		ZTest LEqual
		
		
		
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
			#define ASE_NEEDS_FRAG_COLOR
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			// Element Type Define
			#define TVE_IS_COLORS_SHADER


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
				float4 ase_color : COLOR;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform half _render_colormask;
			uniform half _IsColorsShader;
			uniform half _Banner;
			uniform half _Message;
			uniform half _IsElementShader;
			uniform half _MainTexSpace;
			uniform half _ElementLayerValue;
			uniform half _ElementLayerMessage;
			uniform half _IsVersion;
			uniform half4 _NoiseRemap;
			uniform half _RenderCat;
			uniform half4 _MainTexRemap;
			uniform half _AdvancedCat;
			uniform half _ElementFadeMessage;
			uniform half _ElementCat;
			uniform half _ElementEffect;
			uniform half4 _MainColor;
			uniform half4 TVE_SeasonOptions;
			uniform half4 _AdditionalColor1;
			uniform half4 _AdditionalColor2;
			uniform half TVE_SeasonLerp;
			uniform half4 _AdditionalColor3;
			uniform half4 _AdditionalColor4;
			uniform half _ElementMode;
			uniform sampler2D _MainTex;
			uniform half4 _MainUVs;
			uniform half _MainTexMinValue;
			uniform half _MainTexMaxValue;
			uniform half _ElementIntensity;
			uniform half4 TVE_ColorsCoord;
			uniform half4 TVE_ExtrasCoord;
			uniform half4 TVE_MotionCoord;
			uniform half4 TVE_ReactCoord;
			uniform half TVE_ElementsFadeValue;
			uniform half _ElementFadeSupport;
			half4 IS_ELEMENT( half4 Colors, half4 Extras, half4 Motion, half4 React )
			{
				#if defined (TVE_IS_COLORS_SHADER)
				return Colors;
				#elif defined (TVE_IS_EXTRAS_SHADER)
				return Extras;
				#elif defined (TVE_IS_MOTION_SHADER)
				return Motion;
				#elif defined (TVE_IS_REACT_SHADER)
				return React;
				#else
				return Colors;
				#endif
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_color = v.color;
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
				half4 Color_Main_RGBA49_g19248 = _MainColor;
				half TVE_SeasonOptions_X50_g19248 = TVE_SeasonOptions.x;
				half4 Color_Winter_RGBA58_g19248 = _AdditionalColor1;
				half4 Color_Spring_RGBA59_g19248 = _AdditionalColor2;
				half TVE_SeasonLerp54_g19248 = TVE_SeasonLerp;
				half4 lerpResult13_g19248 = lerp( Color_Winter_RGBA58_g19248 , Color_Spring_RGBA59_g19248 , TVE_SeasonLerp54_g19248);
				half TVE_SeasonOptions_Y51_g19248 = TVE_SeasonOptions.y;
				half4 Color_Summer_RGBA60_g19248 = _AdditionalColor3;
				half4 lerpResult14_g19248 = lerp( Color_Spring_RGBA59_g19248 , Color_Summer_RGBA60_g19248 , TVE_SeasonLerp54_g19248);
				half TVE_SeasonOptions_Z52_g19248 = TVE_SeasonOptions.z;
				half4 Color_Autumn_RGBA61_g19248 = _AdditionalColor4;
				half4 lerpResult15_g19248 = lerp( Color_Summer_RGBA60_g19248 , Color_Autumn_RGBA61_g19248 , TVE_SeasonLerp54_g19248);
				half TVE_SeasonOptions_W53_g19248 = TVE_SeasonOptions.w;
				half4 lerpResult12_g19248 = lerp( Color_Autumn_RGBA61_g19248 , Color_Winter_RGBA58_g19248 , TVE_SeasonLerp54_g19248);
				half Element_Mode55_g19248 = _ElementMode;
				half4 lerpResult30_g19248 = lerp( Color_Main_RGBA49_g19248 , ( ( TVE_SeasonOptions_X50_g19248 * lerpResult13_g19248 ) + ( TVE_SeasonOptions_Y51_g19248 * lerpResult14_g19248 ) + ( TVE_SeasonOptions_Z52_g19248 * lerpResult15_g19248 ) + ( TVE_SeasonOptions_W53_g19248 * lerpResult12_g19248 ) ) , Element_Mode55_g19248);
				half4 temp_output_487_0_g19248 = ( lerpResult30_g19248 * i.ase_color );
				half3 temp_output_486_0_g19248 = (temp_output_487_0_g19248).rgb;
				half3 Final_Colors_RGB142_g19248 = temp_output_486_0_g19248;
				half4 tex2DNode17_g19248 = tex2D( _MainTex, ( ( ( 1.0 - i.ase_texcoord1.xy ) * (_MainUVs).xy ) + (_MainUVs).zw ) );
				half temp_output_7_0_g19310 = _MainTexMinValue;
				half4 temp_cast_0 = (temp_output_7_0_g19310).xxxx;
				half4 break469_g19248 = saturate( ( ( tex2DNode17_g19248 - temp_cast_0 ) / ( _MainTexMaxValue - temp_output_7_0_g19310 ) ) );
				half MainTex_R73_g19248 = break469_g19248.r;
				half4 Colors37_g19314 = TVE_ColorsCoord;
				half4 Extras37_g19314 = TVE_ExtrasCoord;
				half4 Motion37_g19314 = TVE_MotionCoord;
				half4 React37_g19314 = TVE_ReactCoord;
				half4 localIS_ELEMENT37_g19314 = IS_ELEMENT( Colors37_g19314 , Extras37_g19314 , Motion37_g19314 , React37_g19314 );
				half4 temp_output_35_0_g19312 = localIS_ELEMENT37_g19314;
				half temp_output_7_0_g19313 = TVE_ElementsFadeValue;
				half2 temp_cast_1 = (temp_output_7_0_g19313).xx;
				half2 temp_output_851_0_g19248 = saturate( ( ( abs( (( (temp_output_35_0_g19312).zw + ( (temp_output_35_0_g19312).xy * (WorldPosition).xz ) )*2.0 + -1.0) ) - temp_cast_1 ) / ( 1.0 - temp_output_7_0_g19313 ) ) );
				half2 break852_g19248 = ( temp_output_851_0_g19248 * temp_output_851_0_g19248 );
				half Enable_Fade_Support454_g19248 = _ElementFadeSupport;
				half lerpResult842_g19248 = lerp( 1.0 , ( 1.0 - saturate( ( break852_g19248.x + break852_g19248.y ) ) ) , Enable_Fade_Support454_g19248);
				half FadeOut_Mask656_g19248 = lerpResult842_g19248;
				half Element_Intensity56_g19248 = ( _ElementIntensity * i.ase_color.a * FadeOut_Mask656_g19248 );
				half Final_Colors_A144_g19248 = ( temp_output_487_0_g19248.a * MainTex_R73_g19248 * Element_Intensity56_g19248 );
				half4 appendResult470_g19248 = (half4(Final_Colors_RGB142_g19248 , Final_Colors_A144_g19248));
				
				
				finalColor = ( ( _ElementEffect * 0.0 ) + appendResult470_g19248 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "TVEShaderElementGUI"
	
	
}
/*ASEBEGIN
Version=18909
1920;0;1920;1029;1383.167;1116.816;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;178;-640,-640;Half;False;Property;_render_colormask;_render_colormask;49;1;[HideInInspector];Create;True;0;0;0;True;0;False;14;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;186;-640,-768;Inherit;False;Define ELEMENT COLORS;47;;19238;378049ebac362e14aae08c2daa8ed737;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-384,-768;Half;False;Property;_Banner;Banner;0;0;Create;True;0;0;0;True;1;StyledBanner(Color Element);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-256,-768;Half;False;Property;_Message;Message;1;0;Create;True;0;0;0;True;1;StyledMessage(Info, Use the Colors elements to add color tinting to the vegetation assets. Element Texture R is used as alpha mask. Particle Color RGB is used as Main multiplier and Alpha as Element Intensity multiplier., 0,0);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;197;-640,-512;Inherit;False;Base Element;2;;19248;0e972c73cae2ee54ea51acc9738801d0;6,477,0,478,0,145,0,481,0,576,1,491,1;0;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-304,-512;Half;False;True;-1;2;TVEShaderElementGUI;0;1;BOXOPHOBIC/The Vegetation Engine/Elements/Default/Colors Default;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;1;False;-1;1;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;2;False;-1;True;True;True;True;True;False;0;True;178;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;3;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;PreviewType=Plane;True;0;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;0;0;197;0
ASEEND*/
//CHKSM=383B803193C7FCCC224D8BFFC7BD5284A88D5270