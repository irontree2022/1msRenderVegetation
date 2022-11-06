// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BOXOPHOBIC/The Vegetation Engine/Elements/Default/Motion Wind Flow"
{
	Properties
	{
		[StyledBanner(Wind Flow Element)]_Banner("Banner", Float) = 0
		[StyledMessage(Info, Use the Motion Flow elements to change the wind direction based on the Element Texture. Element Texture XY is used a World XZ direction and Texture A is used as alpha mask. Particle Color A is used as Element Intensity multiplier., 0,0)]_Message("Message", Float) = 0
		[StyledCategory(Render Settings)]_RenderCat("[ Render Cat ]", Float) = 0
		_ElementIntensity("Element Intensity", Range( 0 , 1)) = 1
		[StyledMessage(Info, When using a higher Layer number the Global Volume will create more render textures to render the elements. Try using fewer layers when posibble., _ElementLayerMessage, 1, 10, 10)]_ElementLayerMessage("Element Layer Message", Float) = 0
		[StyledEnum(Default _Layer 1 _Layer 2 _Layer 3 _Layer 4 _Layer 5 _Layer 6 _Layer 7 _Layer 8)]_ElementLayerValue("Element Layer", Float) = 0
		[StyledCategory(Element Settings)]_ElementCat("[ Element Cat ]", Float) = 0
		[NoScaleOffset][StyledTextureSingleLine]_MainTex("Element Texture", 2D) = "white" {}
		[StyledSpace(10)]_MainTexSpace("#MainTex Space", Float) = 0
		[StyledRemapSlider(_MainTexMinValue, _MainTexMaxValue, 0, 1)]_MainTexRemap("Element Remap", Vector) = (0,0,0,0)
		[StyledToggle]_InvertX("Invert Texture X", Float) = 0
		[StyledToggle]_InvertY("Invert Texture Y", Float) = 0
		[StyledRemapSlider(_NoiseMinValue, _NoiseMaxValue, 0, 1)]_NoiseRemap("Noise Remap", Vector) = (0,0,0,0)
		[StyledCategory(Advanced)]_AdvancedCat("[ Advanced Cat ]", Float) = 0
		[StyledMessage(Info, Use this feature to fade out elements close to a volume edges to avoid rendering issues when the element is exiting the volume., _ElementFadeSupport, 1, 2, 10)]_ElementFadeMessage("Enable Fade Message", Float) = 0
		[ASEEnd][StyledToggle]_ElementFadeSupport("Enable Edge Fade Support", Float) = 0
		[HideInInspector]_IsVersion("_IsVersion", Float) = 400
		[HideInInspector]_IsElementShader("_IsElementShader", Float) = 1
		[HideInInspector]_IsMotionShader("_IsMotionShader", Float) = 1

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
		ColorMask RG
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
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			// Element Type Define
			#define TVE_IS_MOTION_SHADER


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
				float4 ase_color : COLOR;
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
			uniform half _IsMotionShader;
			uniform half _Message;
			uniform half _Banner;
			uniform sampler2D _MainTex;
			uniform float _InvertX;
			uniform float _InvertY;
			uniform float _ElementIntensity;
			uniform half4 TVE_ColorsCoord;
			uniform half4 TVE_ExtrasCoord;
			uniform half4 TVE_MotionCoord;
			uniform half4 TVE_ReactCoord;
			uniform half TVE_ElementsFadeValue;
			uniform float _ElementFadeSupport;
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

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
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
				float4 tex2DNode17_g18705 = tex2D( _MainTex, ( 1.0 - i.ase_texcoord1.xy ) );
				float4 break469_g18705 = tex2DNode17_g18705;
				half MainTex_R73_g18705 = break469_g18705.r;
				half MainTex_G265_g18705 = break469_g18705.g;
				float3 appendResult274_g18705 = (float3((MainTex_R73_g18705*2.0 + -1.0) , 0.0 , (MainTex_G265_g18705*2.0 + -1.0)));
				float3 temp_output_275_0_g18705 = mul( unity_ObjectToWorld, float4( appendResult274_g18705 , 0.0 ) ).xyz;
				float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
				float temp_output_7_0_g19303 = -ase_objectScale.x;
				half normalX_WS284_g18705 = ( ( temp_output_275_0_g18705.x - temp_output_7_0_g19303 ) / ( ase_objectScale.x - temp_output_7_0_g19303 ) );
				half Invert_Texture_X489_g18705 = _InvertX;
				float lerpResult502_g18705 = lerp( normalX_WS284_g18705 , ( 1.0 - normalX_WS284_g18705 ) , Invert_Texture_X489_g18705);
				float temp_output_7_0_g19298 = -ase_objectScale.z;
				half normalZ_WS285_g18705 = ( ( temp_output_275_0_g18705.z - temp_output_7_0_g19298 ) / ( ase_objectScale.z - temp_output_7_0_g19298 ) );
				half Invert_Texture_Y545_g18705 = _InvertY;
				float lerpResult503_g18705 = lerp( normalZ_WS285_g18705 , ( 1.0 - normalZ_WS285_g18705 ) , Invert_Texture_Y545_g18705);
				float3 appendResult496_g18705 = (float3(lerpResult502_g18705 , lerpResult503_g18705 , 1.0));
				half3 Final_MotionFlow_RGB495_g18705 = appendResult496_g18705;
				half MainTex_A74_g18705 = break469_g18705.a;
				half4 Colors37_g19314 = TVE_ColorsCoord;
				half4 Extras37_g19314 = TVE_ExtrasCoord;
				half4 Motion37_g19314 = TVE_MotionCoord;
				half4 React37_g19314 = TVE_ReactCoord;
				half4 localIS_ELEMENT37_g19314 = IS_ELEMENT( Colors37_g19314 , Extras37_g19314 , Motion37_g19314 , React37_g19314 );
				float4 temp_output_35_0_g19312 = localIS_ELEMENT37_g19314;
				float temp_output_7_0_g19313 = TVE_ElementsFadeValue;
				float2 temp_cast_4 = (temp_output_7_0_g19313).xx;
				float2 temp_output_851_0_g18705 = saturate( ( ( abs( (( (temp_output_35_0_g19312).zw + ( (temp_output_35_0_g19312).xy * (WorldPosition).xz ) )*2.0 + -1.0) ) - temp_cast_4 ) / ( 1.0 - temp_output_7_0_g19313 ) ) );
				float2 break852_g18705 = ( temp_output_851_0_g18705 * temp_output_851_0_g18705 );
				half Enable_Fade_Support454_g18705 = _ElementFadeSupport;
				float lerpResult842_g18705 = lerp( 1.0 , ( 1.0 - saturate( ( break852_g18705.x + break852_g18705.y ) ) ) , Enable_Fade_Support454_g18705);
				half FadeOut_Mask656_g18705 = lerpResult842_g18705;
				half Element_Intensity56_g18705 = ( _ElementIntensity * i.ase_color.a * FadeOut_Mask656_g18705 );
				half Final_MotionFlow_A498_g18705 = ( MainTex_A74_g18705 * Element_Intensity56_g18705 );
				float4 appendResult510_g18705 = (float4(Final_MotionFlow_RGB495_g18705 , Final_MotionFlow_A498_g18705));
				
				
				finalColor = appendResult510_g18705;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "TVEShaderElementGUI"
	
	
}
/*ASEBEGIN
Version=18909
1920;0;1920;1029;1423.464;1770.379;1;True;False
Node;AmplifyShaderEditor.FunctionNode;144;-640,-1024;Inherit;False;Base Element;2;;18705;0e972c73cae2ee54ea51acc9738801d0;6,477,2,478,0,145,3,481,1,576,0,491,0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;117;-640,-1280;Inherit;False;Define ELEMENT MOTION;47;;19315;6eebc31017d99e84e811285e6a5d199d;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-256,-1280;Half;False;Property;_Message;Message;1;0;Create;True;0;0;0;True;1;StyledMessage(Info, Use the Motion Flow elements to change the wind direction based on the Element Texture. Element Texture XY is used a World XZ direction and Texture A is used as alpha mask. Particle Color A is used as Element Intensity multiplier., 0,0);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-384,-1280;Half;False;Property;_Banner;Banner;0;0;Create;True;0;0;0;True;1;StyledBanner(Wind Flow Element);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-304,-1024;Float;False;True;-1;2;TVEShaderElementGUI;0;1;BOXOPHOBIC/The Vegetation Engine/Elements/Default/Motion Wind Flow;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;2;False;-1;True;True;True;True;False;False;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;3;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;PreviewType=Plane;True;0;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;0;0;144;0
ASEEND*/
//CHKSM=8AD8533716499261793E6AC0284D3378C39820E6