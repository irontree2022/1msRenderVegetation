// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BOXOPHOBIC/The Vegetation Engine/Elements/Default/Extras Wetness"
{
	Properties
	{
		[StyledBanner(Wetness Element)]_Banner("Banner", Float) = 0
		[StyledMessage(Info, Use the Wetness elements to dampen the global wetness effect on vegetation and props. Element Texture R is used as alpha mask. Particle Color R is used as values multiplier and Alpha as Element Intensity multiplier., 0,0)]_Message("Message", Float) = 0
		[StyledCategory(Render Settings)]_RenderCat("[ Render Cat ]", Float) = 0
		_ElementIntensity("Element Intensity", Range( 0 , 1)) = 1
		[StyledMessage(Info, When using a higher Layer number the Global Volume will create more render textures to render the elements. Try using fewer layers when posibble., _ElementLayerMessage, 1, 10, 10)]_ElementLayerMessage("Element Layer Message", Float) = 0
		[StyledEnum(Default _Layer 1 _Layer 2 _Layer 3 _Layer 4 _Layer 5 _Layer 6 _Layer 7 _Layer 8)]_ElementLayerValue("Element Layer", Float) = 0
		[Enum(Constant,0,Seasons,1)]_ElementMode("Element Mode", Float) = 0
		[StyledCategory(Element Settings)]_ElementCat("[ Element Cat ]", Float) = 0
		[NoScaleOffset][StyledTextureSingleLine]_MainTex("Element Texture", 2D) = "white" {}
		[StyledSpace(10)]_MainTexSpace("#MainTex Space", Float) = 0
		[StyledRemapSlider(_MainTexMinValue, _MainTexMaxValue, 0, 1)]_MainTexRemap("Element Remap", Vector) = (0,0,0,0)
		[HideInInspector]_MainTexMinValue("Element Min", Range( 0 , 1)) = 0
		[HideInInspector]_MainTexMaxValue("Element Max", Range( 0 , 1)) = 1
		[StyledVector(9)]_MainUVs("Element UVs", Vector) = (1,1,0,0)
		_MainValue("Element Value", Range( 0 , 1)) = 1
		_AdditionalValue1("Winter Value", Range( 0 , 1)) = 1
		_AdditionalValue2("Spring Value", Range( 0 , 1)) = 1
		_AdditionalValue3("Summer Value", Range( 0 , 1)) = 1
		_AdditionalValue4("Autumn Value", Range( 0 , 1)) = 1
		[StyledRemapSlider(_NoiseMinValue, _NoiseMaxValue, 0, 1)]_NoiseRemap("Noise Remap", Vector) = (0,0,0,0)
		[StyledCategory(Advanced)]_AdvancedCat("[ Advanced Cat ]", Float) = 0
		[StyledMessage(Info, Use this feature to fade out elements close to a volume edges to avoid rendering issues when the element is exiting the volume., _ElementFadeSupport, 1, 2, 10)]_ElementFadeMessage("Enable Fade Message", Float) = 0
		[ASEEnd][StyledToggle]_ElementFadeSupport("Enable Edge Fade Support", Float) = 0
		[HideInInspector]_IsVersion("_IsVersion", Float) = 400
		[HideInInspector]_IsElementShader("_IsElementShader", Float) = 1
		[HideInInspector]_IsExtrasShader("_IsExtrasShader", Float) = 1

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" "Queue"="Transparent" "PreviewType"="Plane" }
	LOD 0

		CGINCLUDE
		#pragma target 2.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask G
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
			#define TVE_IS_EXTRAS_SHADER


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
			uniform half _IsExtrasShader;
			uniform half _Banner;
			uniform half _Message;
			uniform half _MainValue;
			uniform half4 TVE_SeasonOptions;
			uniform half _AdditionalValue1;
			uniform half _AdditionalValue2;
			uniform half TVE_SeasonLerp;
			uniform half _AdditionalValue3;
			uniform half _AdditionalValue4;
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
			half GammaToLinearFloatFast( half sRGB )
			{
				return sRGB * (sRGB * (sRGB * 0.305306011h + 0.682171111h) + 0.012522878h);
			}
			
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
				half Value_Main157_g18710 = _MainValue;
				half TVE_SeasonOptions_X50_g18710 = TVE_SeasonOptions.x;
				half Value_Winter158_g18710 = _AdditionalValue1;
				half Value_Spring159_g18710 = _AdditionalValue2;
				half TVE_SeasonLerp54_g18710 = TVE_SeasonLerp;
				half lerpResult168_g18710 = lerp( Value_Winter158_g18710 , Value_Spring159_g18710 , TVE_SeasonLerp54_g18710);
				half TVE_SeasonOptions_Y51_g18710 = TVE_SeasonOptions.y;
				half Value_Summer160_g18710 = _AdditionalValue3;
				half lerpResult167_g18710 = lerp( Value_Spring159_g18710 , Value_Summer160_g18710 , TVE_SeasonLerp54_g18710);
				half TVE_SeasonOptions_Z52_g18710 = TVE_SeasonOptions.z;
				half Value_Autumn161_g18710 = _AdditionalValue4;
				half lerpResult166_g18710 = lerp( Value_Summer160_g18710 , Value_Autumn161_g18710 , TVE_SeasonLerp54_g18710);
				half TVE_SeasonOptions_W53_g18710 = TVE_SeasonOptions.w;
				half lerpResult165_g18710 = lerp( Value_Autumn161_g18710 , Value_Winter158_g18710 , TVE_SeasonLerp54_g18710);
				half Element_Mode55_g18710 = _ElementMode;
				half lerpResult181_g18710 = lerp( Value_Main157_g18710 , ( ( TVE_SeasonOptions_X50_g18710 * lerpResult168_g18710 ) + ( TVE_SeasonOptions_Y51_g18710 * lerpResult167_g18710 ) + ( TVE_SeasonOptions_Z52_g18710 * lerpResult166_g18710 ) + ( TVE_SeasonOptions_W53_g18710 * lerpResult165_g18710 ) ) , Element_Mode55_g18710);
				half Base_Extras_RGB213_g18710 = ( lerpResult181_g18710 * i.ase_color.r );
				half temp_output_9_0_g19299 = Base_Extras_RGB213_g18710;
				half sRGB8_g19299 = temp_output_9_0_g19299;
				half localGammaToLinearFloatFast8_g19299 = GammaToLinearFloatFast( sRGB8_g19299 );
				#ifdef UNITY_COLORSPACE_GAMMA
				float staticSwitch1_g19299 = temp_output_9_0_g19299;
				#else
				float staticSwitch1_g19299 = localGammaToLinearFloatFast8_g19299;
				#endif
				half3 appendResult209_g18710 = (half3(0.0 , staticSwitch1_g19299 , 0.0));
				half3 Final_Wetness_RGB249_g18710 = appendResult209_g18710;
				half4 tex2DNode17_g18710 = tex2D( _MainTex, ( ( ( 1.0 - i.ase_texcoord1.xy ) * (_MainUVs).xy ) + (_MainUVs).zw ) );
				half temp_output_7_0_g19310 = _MainTexMinValue;
				half4 temp_cast_0 = (temp_output_7_0_g19310).xxxx;
				half4 break469_g18710 = saturate( ( ( tex2DNode17_g18710 - temp_cast_0 ) / ( _MainTexMaxValue - temp_output_7_0_g19310 ) ) );
				half MainTex_R73_g18710 = break469_g18710.r;
				half4 Colors37_g19314 = TVE_ColorsCoord;
				half4 Extras37_g19314 = TVE_ExtrasCoord;
				half4 Motion37_g19314 = TVE_MotionCoord;
				half4 React37_g19314 = TVE_ReactCoord;
				half4 localIS_ELEMENT37_g19314 = IS_ELEMENT( Colors37_g19314 , Extras37_g19314 , Motion37_g19314 , React37_g19314 );
				half4 temp_output_35_0_g19312 = localIS_ELEMENT37_g19314;
				half temp_output_7_0_g19313 = TVE_ElementsFadeValue;
				half2 temp_cast_1 = (temp_output_7_0_g19313).xx;
				half2 temp_output_851_0_g18710 = saturate( ( ( abs( (( (temp_output_35_0_g19312).zw + ( (temp_output_35_0_g19312).xy * (WorldPosition).xz ) )*2.0 + -1.0) ) - temp_cast_1 ) / ( 1.0 - temp_output_7_0_g19313 ) ) );
				half2 break852_g18710 = ( temp_output_851_0_g18710 * temp_output_851_0_g18710 );
				half Enable_Fade_Support454_g18710 = _ElementFadeSupport;
				half lerpResult842_g18710 = lerp( 1.0 , ( 1.0 - saturate( ( break852_g18710.x + break852_g18710.y ) ) ) , Enable_Fade_Support454_g18710);
				half FadeOut_Mask656_g18710 = lerpResult842_g18710;
				half Element_Intensity56_g18710 = ( _ElementIntensity * i.ase_color.a * FadeOut_Mask656_g18710 );
				half Final_Wetness_A250_g18710 = ( MainTex_R73_g18710 * Element_Intensity56_g18710 );
				half4 appendResult475_g18710 = (half4(Final_Wetness_RGB249_g18710 , Final_Wetness_A250_g18710));
				
				
				finalColor = appendResult475_g18710;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "TVEShaderElementGUI"
	
	
}
/*ASEBEGIN
Version=18909
1920;0;1920;1029;767.6006;1973.039;1;True;False
Node;AmplifyShaderEditor.FunctionNode;133;-256,-1280;Inherit;False;Base Element;2;;18710;0e972c73cae2ee54ea51acc9738801d0;6,477,1,478,0,145,1,481,0,576,1,491,1;0;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;124;-256,-1536;Inherit;False;Define ELEMENT EXTRAS;47;;19315;adca672cb6779794dba5f669b4c5f8e3;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;0,-1536;Half;False;Property;_Banner;Banner;0;0;Create;True;0;0;0;True;1;StyledBanner(Wetness Element);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;120;128,-1536;Half;False;Property;_Message;Message;1;0;Create;True;0;0;0;True;1;StyledMessage(Info, Use the Wetness elements to dampen the global wetness effect on vegetation and props. Element Texture R is used as alpha mask. Particle Color R is used as values multiplier and Alpha as Element Intensity multiplier., 0,0);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;80,-1280;Half;False;True;-1;2;TVEShaderElementGUI;0;1;BOXOPHOBIC/The Vegetation Engine/Elements/Default/Extras Wetness;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;2;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;2;False;-1;True;True;False;True;False;False;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;3;RenderType=Opaque=RenderType;Queue=Transparent=Queue=0;PreviewType=Plane;True;0;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;0;0;133;0
ASEEND*/
//CHKSM=7A09555B0FFA2FCCB869F32D72576707FDF6A66A