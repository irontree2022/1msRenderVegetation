// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BOXOPHOBIC/The Vegetation Engine/Objects/Prop Standard Lit"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[StyledCategory(Render Settings, 5, 10)]_RenderingCat("[ Rendering Cat ]", Float) = 0
		[Enum(Opaque,0,Transparent,1)]_RenderMode("Render Mode", Float) = 0
		[Enum(Off,0,On,1)]_RenderZWrite("Render ZWrite", Float) = 1
		[IntRange]_RenderPriority("Render Priority", Range( -100 , 100)) = 0
		[Enum(Both,0,Back,1,Front,2)]_RenderCull("Render Faces", Float) = 0
		[Enum(Flip,0,Mirror,1,Same,2)]_RenderNormals("Render Normals", Float) = 0
		[StyledSpace(10)]_ReceiveSpace("# Receive Space", Float) = 0
		[Enum(Off,0,On,1)]_RenderDecals("Receive Decals", Float) = 1
		[Enum(Off,0,On,1)]_RenderSSR("Receive SSR/SSGI", Float) = 1
		[Enum(Off,0,On,1)][Space(10)]_RenderClip("Alpha Clipping", Float) = 1
		_Cutoff("Alpha Treshold", Range( 0 , 1)) = 0.5
		[StyledSpace(10)]_FadeSpace("# Fade Space", Float) = 0
		[StyledCategory(Global Settings)]_GlobalCat("[ Global Cat ]", Float) = 0
		[StyledEnum(Default _Layer 1 _Layer 2 _Layer 3 _Layer 4 _Layer 5 _Layer 6 _Layer 7 _Layer 8)]_LayerExtrasValue("Layer Extras", Float) = 0
		[StyledSpace(10)]_LayersSpace("# Layers Space", Float) = 0
		[StyledMessage(Info, Procedural Variation in use. The Variation might not work as expected when switching from one LOD to another., _VertexVariationMode, 1 , 0, 10)]_VariationGlobalsMessage("# Variation Globals Message", Float) = 0
		_GlobalOverlay("Global Overlay", Range( 0 , 1)) = 1
		_GlobalWetness("Global Wetness", Range( 0 , 1)) = 1
		_GlobalEmissive("Global Emissive", Range( 0 , 1)) = 1
		[StyledRemapSlider(_ColorsMaskMinValue, _ColorsMaskMaxValue, 0, 1, 10, 0)]_ColorsMaskRemap("Colors Mask", Vector) = (0,0,0,0)
		[StyledRemapSlider(_OverlayMaskMinValue, _OverlayMaskMaxValue, 0, 1, 10, 0)]_OverlayMaskRemap("Overlay Mask", Vector) = (0,0,0,0)
		[HideInInspector]_OverlayMaskMinValue("Overlay Mask Min Value", Range( 0 , 1)) = 0.45
		[HideInInspector]_OverlayMaskMaxValue("Overlay Mask Max Value", Range( 0 , 1)) = 0.55
		_OverlayBottomValue("Overlay Bottom", Range( 0 , 1)) = 0.5
		[StyledCategory(Main Settings)]_MainCat("[ Main Cat ]", Float) = 0
		[NoScaleOffset][StyledTextureSingleLine]_MainAlbedoTex("Main Albedo", 2D) = "white" {}
		[NoScaleOffset][StyledTextureSingleLine]_MainNormalTex("Main Normal", 2D) = "bump" {}
		[NoScaleOffset][StyledTextureSingleLine]_MainMaskTex("Main Mask", 2D) = "white" {}
		[Space(10)][StyledVector(9)]_MainUVs("Main UVs", Vector) = (1,1,0,0)
		[HDR]_MainColor("Main Color", Color) = (1,1,1,1)
		_MainNormalValue("Main Normal", Range( -8 , 8)) = 1
		_MainMetallicValue("Main Metallic", Range( 0 , 1)) = 0
		_MainOcclusionValue("Main Occlusion", Range( 0 , 1)) = 1
		_MainSmoothnessValue("Main Smoothness", Range( 0 , 1)) = 1
		[StyledCategory(Detail Settings)]_DetailCat("[ Detail Cat ]", Float) = 0
		[Enum(Off,0,On,1)]_DetailMode("Detail Mode", Float) = 0
		[Enum(Overlay,0,Replace,1)]_DetailBlendMode("Detail Blend", Float) = 1
		[Enum(Vertex Blue,0,Projection,1)]_DetailTypeMode("Detail Type", Float) = 0
		[Enum(UV 0,0,UV 2,1)]_DetailCoordMode("Detail Coord", Float) = 0
		[Enum(Top,0,Bottom,1)]_DetailProjectionMode("Detail Projection", Float) = 0
		[StyledSpace(10)]_DetailSpace("# Detail Space", Float) = 0
		[NoScaleOffset][Space(10)][StyledTextureSingleLine]_SecondAlbedoTex("Detail Albedo", 2D) = "white" {}
		[NoScaleOffset][StyledTextureSingleLine]_SecondNormalTex("Detail Normal", 2D) = "bump" {}
		[NoScaleOffset][StyledTextureSingleLine]_SecondMaskTex("Detail Mask", 2D) = "white" {}
		[Space(10)][StyledVector(9)]_SecondUVs("Detail UVs", Vector) = (1,1,0,0)
		[HDR]_SecondColor("Detail Color", Color) = (1,1,1,1)
		_SecondNormalValue("Detail Normal", Range( -8 , 8)) = 1
		_SecondMetallicValue("Detail Metallic", Range( 0 , 1)) = 0
		_SecondOcclusionValue("Detail Occlusion", Range( 0 , 1)) = 1
		_SecondSmoothnessValue("Detail Smoothness", Range( 0 , 1)) = 1
		[Space(10)]_DetailNormalValue("Detail Use Main Normal", Range( 0 , 1)) = 0.5
		[Enum(Main Mask,0,Detail Mask,1)][Space(10)]_DetailMaskMode("Detail Mask Source", Float) = 0
		[Enum(Off,0,On,1)]_DetailMaskInvertMode("Detail Mask Invert", Float) = 0
		_DetailMeshValue("Detail Mask Offset", Range( -1 , 1)) = 0
		[StyledRemapSlider(_DetailBlendMinValue, _DetailBlendMaxValue,0,1)]_DetailBlendRemap("Detail Blending", Vector) = (0,0,0,0)
		[HideInInspector]_DetailBlendMinValue("Detail Blend Min Value", Range( 0 , 1)) = 0.2
		[HideInInspector]_DetailBlendMaxValue("Detail Blend Max Value", Range( 0 , 1)) = 0.3
		[StyledCategory(Occlusion Settings)]_OcclusionCat("[ Occlusion Cat ]", Float) = 0
		[StyledRemapSlider(_VertexOcclusionMinValue, _VertexOcclusionMaxValue, 0, 1)]_VertexOcclusionRemap("Vertex Occlusion Mask", Vector) = (0,0,0,0)
		[StyledCategory(Subsurface Settings)]_SubsurfaceCat("[ Subsurface Cat ]", Float) = 0
		[StyledRemapSlider(_SubsurfaceMaskMinValue, _SubsurfaceMaskMaxValue,0,1)]_SubsurfaceMaskRemap("Subsurface Mask", Vector) = (0,0,0,0)
		[Space(10)][DiffusionProfile]_SubsurfaceDiffusion("Subsurface Diffusion", Float) = 0
		[HideInInspector]_SubsurfaceDiffusion_Asset("Subsurface Diffusion", Vector) = (0,0,0,0)
		[HideInInspector][Space(10)][ASEDiffusionProfile(_SubsurfaceDiffusion)]_SubsurfaceDiffusion_asset("Subsurface Diffusion", Vector) = (0,0,0,0)
		[Space(10)]_TranslucencyIntensityValue("Translucency Intensity", Range( 0 , 50)) = 1
		_TranslucencyNormalValue("Translucency Normal", Range( 0 , 1)) = 0.1
		_TranslucencyScatteringValue("Translucency Scattering", Range( 1 , 50)) = 2
		_TranslucencyDirectValue("Translucency Direct", Range( 0 , 1)) = 1
		_TranslucencyAmbientValue("Translucency Ambient", Range( 0 , 1)) = 0.2
		_TranslucencyShadowValue("Translucency Shadow", Range( 0 , 1)) = 1
		[StyledMessage(Warning,  Translucency is not supported in HDRP. Diffusion Profiles will be used instead., 10, 5)]_TranslucencyHDMessage("# Translucency HD Message", Float) = 0
		[StyledCategory(Gradient Settings)]_GradientCat("[ Gradient Cat ]", Float) = 0
		[StyledRemapSlider(_GradientMinValue, _GradientMaxValue, 0, 1)]_GradientMaskRemap("Gradient Mask", Vector) = (0,0,0,0)
		[StyledCategory(Noise Settings)]_NoiseCat("[ Noise Cat ]", Float) = 0
		[StyledRemapSlider(_NoiseMinValue, _NoiseMaxValue, 0, 1)]_NoiseMaskRemap("Noise Mask", Vector) = (0,0,0,0)
		[StyledCategory(Emissive Settings)]_EmissiveCat("[ Emissive Cat]", Float) = 0
		[NoScaleOffset][StyledTextureSingleLine]_EmissiveTex("Emissive Texture", 2D) = "white" {}
		[Space(10)][StyledVector(9)]_EmissiveUVs("Emissive UVs", Vector) = (1,1,0,0)
		[Enum(None,0,Any,10,Baked,20,Realtime,30)]_EmissiveFlagMode("Emissive Baking", Float) = 0
		[HDR]_EmissiveColor("Emissive Color", Color) = (0,0,0,0)
		[StyledCategory(Perspective Settings)]_PerspectiveCat("[ Perspective Cat ]", Float) = 0
		[StyledCategory(Size Fade Settings)]_SizeFadeCat("[ Size Fade Cat ]", Float) = 0
		[StyledMessage(Info, The Size Fade feature is recommended to be used to fade out vegetation at a distance in combination with the LOD Groups or with a 3rd party culling system., _SizeFadeMode, 1, 0, 10)]_SizeFadeMessage("# Size Fade Message", Float) = 0
		[StyledCategory(Motion Settings)]_MotionCat("[ Motion Cat ]", Float) = 0
		[StyledMessage(Info, Procedural variation in use. Use the Scale settings if the Variation is breaking the bending and rolling animation., _VertexVariationMode, 1 , 0, 10)]_VariationMotionMessage("# Variation Motion Message", Float) = 0
		[ASEEnd][StyledSpace(10)]_MotionSpace("# Motion Space", Float) = 0
		[HideInInspector]_IsTVEShader("_IsTVEShader", Float) = 1
		[HideInInspector]_IsVersion("_IsVersion", Float) = 400
		[HideInInspector]_Color("Legacy Color", Color) = (0,0,0,0)
		[HideInInspector]_MainTex("Legacy MainTex", 2D) = "white" {}
		[HideInInspector]_BumpMap("Legacy BumpMap", 2D) = "white" {}
		[HideInInspector]_render_normals_options("_render_normals_options", Vector) = (1,1,1,0)
		[HideInInspector]_MaxBoundsInfo("_MaxBoundsInfo", Vector) = (1,1,1,1)
		[HideInInspector]_VertexVariationMode("_VertexVariationMode", Float) = 0
		[HideInInspector]_VertexMasksMode("_VertexMasksMode", Float) = 0
		[HideInInspector]_IsPropShader("_IsPropShader", Float) = 1
		[HideInInspector]_IsStandardShader("_IsStandardShader", Float) = 1
		[HideInInspector]_render_cull("_render_cull", Float) = 0
		[HideInInspector]_render_src("_render_src", Float) = 1
		[HideInInspector]_render_dst("_render_dst", Float) = 0
		[HideInInspector]_render_zw("_render_zw", Float) = 1

		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5
		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
		Cull [_render_cull]
		AlphaToMask Off
		HLSLINCLUDE
		#pragma target 4.0

		#ifndef ASE_TESS_FUNCS
		#define ASE_TESS_FUNCS
		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}
		
		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		#endif //ASE_TESS_FUNCS

		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }
			
			Blend [_render_src] [_render_dst], One Zero
			ZWrite [_render_zw]
			ZTest LEqual
			Offset 0,0
			ColorMask RGBA
			

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 100202
			#define ASE_USING_SAMPLING_MACROS 1

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			
			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK

			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_FORWARD

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			#if ASE_SRP_VERSION <= 70108
			#define REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
			#endif

			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
			    #define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#pragma shader_feature_local TVE_ALPHA_CLIP
			#pragma shader_feature_local TVE_DETAIL_MODE_OFF TVE_DETAIL_MODE_ON
			#pragma shader_feature_local TVE_DETAIL_BLEND_OVERLAY TVE_DETAIL_BLEND_REPLACE
			#pragma shader_feature_local TVE_DETAIL_TYPE_VERTEX_BLUE TVE_DETAIL_TYPE_PROJECTION
			//TVE Shader Type Defines
			#define TVE_IS_OBJECT_SHADER
			//TVE Pipeline Defines
			#define THE_VEGETATION_ENGINE
			#define IS_UNIVERSAL_PIPELINE
			//TVE Batching Support Defines
			#define TVE_VERTEX_DATA_BATCHED
			//TVE Injection Defines
			//SHADER INJECTION POINT BEGIN
           //1msRenderVegetation (Instanced Indirect)
           #include "Assets/BasicRenderingFramework/shaders/1msRenderVegetation_Include.cginc"
           #pragma instancing_options procedural:setup forwardadd
           #pragma multi_compile GPU_FRUSTUM_ON __
			//SHADER INJECTION POINT END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord : TEXCOORD2;
				#endif
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 screenPos : TEXCOORD6;
				#endif
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_texcoord9 : TEXCOORD9;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _NoiseMaskRemap;
			half4 _MainUVs;
			half4 _EmissiveColor;
			float4 _SubsurfaceDiffusion_Asset;
			half4 _ColorsMaskRemap;
			half4 _SubsurfaceMaskRemap;
			float4 _GradientMaskRemap;
			half4 _OverlayMaskRemap;
			float4 _MaxBoundsInfo;
			half4 _EmissiveUVs;
			half4 _VertexOcclusionRemap;
			half4 _DetailBlendRemap;
			half4 _SecondColor;
			half4 _SecondUVs;
			float4 _Color;
			float4 _SubsurfaceDiffusion_asset;
			half4 _MainColor;
			half3 _render_normals_options;
			half _DetailCoordMode;
			half _DetailMeshValue;
			half _render_cull;
			half _RenderMode;
			half _SizeFadeCat;
			half _RenderDecals;
			half _RenderZWrite;
			half _TranslucencyShadowValue;
			half _RenderSSR;
			float _SubsurfaceDiffusion;
			half _EmissiveFlagMode;
			half _MainNormalValue;
			half _OverlayBottomValue;
			half _DetailMaskMode;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half _SecondMetallicValue;
			half _MainMetallicValue;
			half _GlobalEmissive;
			half _DetailNormalValue;
			half _DetailProjectionMode;
			half _SecondNormalValue;
			half _OverlayMaskMinValue;
			half _LayerExtrasValue;
			half _GlobalOverlay;
			half _MotionSpace;
			half _DetailBlendMaxValue;
			half _DetailBlendMinValue;
			half _DetailMaskInvertMode;
			half _OverlayMaskMaxValue;
			half _RenderCull;
			half _GlobalCat;
			half _VertexVariationMode;
			half _DetailBlendMode;
			half _LayersSpace;
			half _Cutoff;
			half _MainCat;
			half _DetailMode;
			half _SubsurfaceCat;
			half _RenderNormals;
			half _VariationGlobalsMessage;
			half _MotionCat;
			half _OcclusionCat;
			half _SizeFadeMessage;
			half _TranslucencyHDMessage;
			half _render_src;
			half _IsStandardShader;
			half _render_zw;
			half _IsPropShader;
			half _render_dst;
			half _ReceiveSpace;
			half _PerspectiveCat;
			half _EmissiveCat;
			half _RenderPriority;
			half _GradientCat;
			half _TranslucencyDirectValue;
			half _FadeSpace;
			half _MainOcclusionValue;
			half _IsTVEShader;
			half _DetailSpace;
			half _DetailTypeMode;
			half _DetailCat;
			half _TranslucencyScatteringValue;
			half _TranslucencyNormalValue;
			half _RenderClip;
			half _IsVersion;
			half _RenderingCat;
			half _VertexMasksMode;
			half _VariationMotionMessage;
			half _TranslucencyAmbientValue;
			half _NoiseCat;
			half _TranslucencyIntensityValue;
			half _SecondOcclusionValue;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			TEXTURE2D(_BumpMap);
			SAMPLER(sampler_BumpMap);
			TEXTURE2D(_MainTex);
			SAMPLER(sampler_MainTex);
			TEXTURE2D(_MainAlbedoTex);
			SAMPLER(sampler_MainAlbedoTex);
			TEXTURE2D(_SecondAlbedoTex);
			TEXTURE2D(_SecondMaskTex);
			SAMPLER(sampler_SecondMaskTex);
			TEXTURE2D(_MainNormalTex);
			TEXTURE2D(_MainMaskTex);
			half4 TVE_OverlayColor;
			half4 TVE_ExtrasParams;
			TEXTURE2D_ARRAY(TVE_ExtrasTex);
			half4 TVE_ExtrasCoord;
			SAMPLER(samplerTVE_ExtrasTex);
			float TVE_ExtrasUsage[9];
			TEXTURE2D(_SecondNormalTex);
			TEXTURE2D(_EmissiveTex);
			SAMPLER(sampler_EmissiveTex);
			half TVE_OverlaySmoothness;


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 vertexToFrag11_g52308 = ( ( v.texcoord.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				o.ase_texcoord7.xy = vertexToFrag11_g52308;
				float2 lerpResult1545_g51945 = lerp( v.texcoord.xy , v.texcoord1.xyzw.xy , _DetailCoordMode);
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				#if defined(TVE_DETAIL_TYPE_VERTEX_BLUE)
				float2 staticSwitch3466_g51945 = lerpResult1545_g51945;
				#elif defined(TVE_DETAIL_TYPE_PROJECTION)
				float2 staticSwitch3466_g51945 = (ase_worldPos).xz;
				#else
				float2 staticSwitch3466_g51945 = lerpResult1545_g51945;
				#endif
				float2 vertexToFrag11_g52243 = ( ( staticSwitch3466_g51945 * (_SecondUVs).xy ) + (_SecondUVs).zw );
				o.ase_texcoord7.zw = vertexToFrag11_g52243;
				half Mesh_DetailMask90_g51945 = v.ase_color.b;
				float vertexToFrag11_g52208 = ( ( Mesh_DetailMask90_g51945 - 0.5 ) + _DetailMeshValue );
				o.ase_texcoord8.x = vertexToFrag11_g52208;
				float3 vertexToFrag3890_g51945 = ase_worldPos;
				o.ase_texcoord8.yzw = vertexToFrag3890_g51945;
				
				float2 vertexToFrag11_g52248 = ( ( v.texcoord.xy * (_EmissiveUVs).xy ) + (_EmissiveUVs).zw );
				o.ase_texcoord9.xy = vertexToFrag11_g52248;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord9.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				OUTPUT_SH( normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz );

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord;
					o.lightmapUVOrVertexSH.xy = v.texcoord * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );
				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( positionCS.z );
				#else
					half fogFactor = 0;
				#endif
				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
				
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				
				o.clipPos = positionCS;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				o.screenPos = ComputeScreenPos(positionCS);
				#endif
				return o;
			}
			
			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual  
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag ( VertexOutput IN 
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						, FRONT_FACE_TYPE ase_vface : FRONT_FACE_SEMANTIC ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif
				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 ScreenPos = IN.screenPos;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#endif
	
				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float2 vertexToFrag11_g52308 = IN.ase_texcoord7.xy;
				half2 Main_UVs15_g51945 = vertexToFrag11_g52308;
				float4 tex2DNode29_g51945 = SAMPLE_TEXTURE2D( _MainAlbedoTex, sampler_MainAlbedoTex, Main_UVs15_g51945 );
				float3 temp_output_51_0_g51945 = ( (_MainColor).rgb * (tex2DNode29_g51945).rgb );
				half3 Main_Albedo99_g51945 = temp_output_51_0_g51945;
				float2 vertexToFrag11_g52243 = IN.ase_texcoord7.zw;
				half2 Second_UVs17_g51945 = vertexToFrag11_g52243;
				half3 Second_Albedo153_g51945 = (( _SecondColor * SAMPLE_TEXTURE2D( _SecondAlbedoTex, sampler_SecondMaskTex, Second_UVs17_g51945 ) )).rgb;
				#ifdef UNITY_COLORSPACE_GAMMA
				float staticSwitch1_g52209 = 2.0;
				#else
				float staticSwitch1_g52209 = 4.594794;
				#endif
				float vertexToFrag11_g52208 = IN.ase_texcoord8.x;
				float temp_output_3919_0_g51945 = vertexToFrag11_g52208;
				float3 unpack4112_g51945 = UnpackNormalScale( SAMPLE_TEXTURE2D( _MainNormalTex, sampler_MainAlbedoTex, Main_UVs15_g51945 ), _MainNormalValue );
				unpack4112_g51945.z = lerp( 1, unpack4112_g51945.z, saturate(_MainNormalValue) );
				half3 Main_Normal137_g51945 = unpack4112_g51945;
				float3 tanToWorld0 = float3( WorldTangent.x, WorldBiTangent.x, WorldNormal.x );
				float3 tanToWorld1 = float3( WorldTangent.y, WorldBiTangent.y, WorldNormal.y );
				float3 tanToWorld2 = float3( WorldTangent.z, WorldBiTangent.z, WorldNormal.z );
				float3 tanNormal4099_g51945 = Main_Normal137_g51945;
				float3 worldNormal4099_g51945 = float3(dot(tanToWorld0,tanNormal4099_g51945), dot(tanToWorld1,tanNormal4099_g51945), dot(tanToWorld2,tanNormal4099_g51945));
				float3 Main_Normal_WS4101_g51945 = worldNormal4099_g51945;
				float lerpResult1537_g51945 = lerp( Main_Normal_WS4101_g51945.y , -Main_Normal_WS4101_g51945.y , _DetailProjectionMode);
				#if defined(TVE_DETAIL_TYPE_VERTEX_BLUE)
				float staticSwitch3467_g51945 = temp_output_3919_0_g51945;
				#elif defined(TVE_DETAIL_TYPE_PROJECTION)
				float staticSwitch3467_g51945 = ( ( lerpResult1537_g51945 * 0.5 ) + _DetailMeshValue );
				#else
				float staticSwitch3467_g51945 = temp_output_3919_0_g51945;
				#endif
				half Blend_Source1540_g51945 = staticSwitch3467_g51945;
				float4 tex2DNode35_g51945 = SAMPLE_TEXTURE2D( _MainMaskTex, sampler_MainAlbedoTex, Main_UVs15_g51945 );
				half Main_Mask57_g51945 = tex2DNode35_g51945.b;
				float4 tex2DNode33_g51945 = SAMPLE_TEXTURE2D( _SecondMaskTex, sampler_SecondMaskTex, Second_UVs17_g51945 );
				half Second_Mask81_g51945 = tex2DNode33_g51945.b;
				float lerpResult1327_g51945 = lerp( Main_Mask57_g51945 , Second_Mask81_g51945 , _DetailMaskMode);
				float lerpResult4058_g51945 = lerp( lerpResult1327_g51945 , ( 1.0 - lerpResult1327_g51945 ) , _DetailMaskInvertMode);
				float temp_output_7_0_g52238 = _DetailBlendMinValue;
				half Mask_Detail147_g51945 = saturate( ( ( saturate( ( Blend_Source1540_g51945 + ( Blend_Source1540_g51945 * lerpResult4058_g51945 ) ) ) - temp_output_7_0_g52238 ) / ( _DetailBlendMaxValue - temp_output_7_0_g52238 ) ) );
				float3 lerpResult235_g51945 = lerp( Main_Albedo99_g51945 , ( Main_Albedo99_g51945 * Second_Albedo153_g51945 * staticSwitch1_g52209 ) , Mask_Detail147_g51945);
				float3 lerpResult208_g51945 = lerp( Main_Albedo99_g51945 , Second_Albedo153_g51945 , Mask_Detail147_g51945);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float3 staticSwitch4062_g51945 = lerpResult235_g51945;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float3 staticSwitch4062_g51945 = lerpResult208_g51945;
				#else
				float3 staticSwitch4062_g51945 = lerpResult235_g51945;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float3 staticSwitch255_g51945 = Main_Albedo99_g51945;
				#elif defined(TVE_DETAIL_MODE_ON)
				float3 staticSwitch255_g51945 = staticSwitch4062_g51945;
				#else
				float3 staticSwitch255_g51945 = Main_Albedo99_g51945;
				#endif
				half3 Blend_Albedo265_g51945 = staticSwitch255_g51945;
				half3 Blend_AlbedoTinted2808_g51945 = ( float3(1,1,1) * float3(1,1,1) * float3(1,1,1) * Blend_Albedo265_g51945 );
				half3 Blend_AlbedoColored863_g51945 = Blend_AlbedoTinted2808_g51945;
				half3 Blend_AlbedoAndSubsurface149_g51945 = Blend_AlbedoColored863_g51945;
				half3 Global_OverlayColor1758_g51945 = (TVE_OverlayColor).rgb;
				float lerpResult3567_g51945 = lerp( _OverlayBottomValue , 1.0 , Main_Normal_WS4101_g51945.y);
				half Main_AlbedoTex_G3526_g51945 = tex2DNode29_g51945.g;
				half Second_AlbedoTex_G3581_g51945 = (SAMPLE_TEXTURE2D( _SecondAlbedoTex, sampler_SecondMaskTex, Second_UVs17_g51945 )).g;
				float lerpResult3579_g51945 = lerp( Main_AlbedoTex_G3526_g51945 , Second_AlbedoTex_G3581_g51945 , Mask_Detail147_g51945);
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch3574_g51945 = Main_AlbedoTex_G3526_g51945;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch3574_g51945 = lerpResult3579_g51945;
				#else
				float staticSwitch3574_g51945 = Main_AlbedoTex_G3526_g51945;
				#endif
				float3 vertexToFrag3890_g51945 = IN.ase_texcoord8.yzw;
				float3 PositionWS_PerVertex3905_g51945 = vertexToFrag3890_g51945;
				float3 Position82_g52261 = PositionWS_PerVertex3905_g51945;
				float temp_output_84_0_g52261 = _LayerExtrasValue;
				float4 lerpResult88_g52261 = lerp( TVE_ExtrasParams , SAMPLE_TEXTURE2D_ARRAY( TVE_ExtrasTex, samplerTVE_ExtrasTex, ( (TVE_ExtrasCoord).zw + ( (TVE_ExtrasCoord).xy * (Position82_g52261).xz ) ),temp_output_84_0_g52261 ) , TVE_ExtrasUsage[(int)temp_output_84_0_g52261]);
				float4 break89_g52261 = lerpResult88_g52261;
				half Global_Extras_Overlay156_g51945 = break89_g52261.b;
				float temp_output_1025_0_g51945 = ( _GlobalOverlay * Global_Extras_Overlay156_g51945 );
				half Overlay_Commons1365_g51945 = temp_output_1025_0_g51945;
				float temp_output_7_0_g52234 = _OverlayMaskMinValue;
				half Overlay_Mask269_g51945 = saturate( ( ( ( ( ( lerpResult3567_g51945 * 0.5 ) + staticSwitch3574_g51945 ) * Overlay_Commons1365_g51945 ) - temp_output_7_0_g52234 ) / ( _OverlayMaskMaxValue - temp_output_7_0_g52234 ) ) );
				float3 lerpResult336_g51945 = lerp( Blend_AlbedoAndSubsurface149_g51945 , Global_OverlayColor1758_g51945 , Overlay_Mask269_g51945);
				half3 Final_Albedo359_g51945 = lerpResult336_g51945;
				
				float3 unpack4114_g51945 = UnpackNormalScale( SAMPLE_TEXTURE2D( _SecondNormalTex, sampler_SecondMaskTex, Second_UVs17_g51945 ), _SecondNormalValue );
				unpack4114_g51945.z = lerp( 1, unpack4114_g51945.z, saturate(_SecondNormalValue) );
				half3 Second_Normal179_g51945 = unpack4114_g51945;
				float3 lerpResult230_g51945 = lerp( float3( 0,0,1 ) , Second_Normal179_g51945 , Mask_Detail147_g51945);
				float3 lerpResult3372_g51945 = lerp( float3( 0,0,1 ) , Main_Normal137_g51945 , _DetailNormalValue);
				float3 lerpResult3376_g51945 = lerp( Main_Normal137_g51945 , BlendNormal( lerpResult3372_g51945 , Second_Normal179_g51945 ) , Mask_Detail147_g51945);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float3 staticSwitch4063_g51945 = BlendNormal( Main_Normal137_g51945 , lerpResult230_g51945 );
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float3 staticSwitch4063_g51945 = lerpResult3376_g51945;
				#else
				float3 staticSwitch4063_g51945 = BlendNormal( Main_Normal137_g51945 , lerpResult230_g51945 );
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float3 staticSwitch267_g51945 = Main_Normal137_g51945;
				#elif defined(TVE_DETAIL_MODE_ON)
				float3 staticSwitch267_g51945 = staticSwitch4063_g51945;
				#else
				float3 staticSwitch267_g51945 = Main_Normal137_g51945;
				#endif
				float3 temp_output_13_0_g52210 = staticSwitch267_g51945;
				float3 switchResult12_g52210 = (((ase_vface>0)?(temp_output_13_0_g52210):(( temp_output_13_0_g52210 * _render_normals_options ))));
				half3 Blend_Normal312_g51945 = switchResult12_g52210;
				half3 Final_Normal366_g51945 = Blend_Normal312_g51945;
				
				float2 vertexToFrag11_g52248 = IN.ase_texcoord9.xy;
				half2 Emissive_UVs2468_g51945 = vertexToFrag11_g52248;
				half Global_Extras_Emissive4203_g51945 = break89_g52261.r;
				float lerpResult4206_g51945 = lerp( 1.0 , Global_Extras_Emissive4203_g51945 , _GlobalEmissive);
				half3 Final_Emissive2476_g51945 = ( (( _EmissiveColor * SAMPLE_TEXTURE2D( _EmissiveTex, sampler_EmissiveTex, Emissive_UVs2468_g51945 ) )).rgb * lerpResult4206_g51945 );
				
				half Main_Metallic237_g51945 = ( tex2DNode35_g51945.r * _MainMetallicValue );
				half Second_Metallic226_g51945 = ( tex2DNode33_g51945.r * _SecondMetallicValue );
				float lerpResult278_g51945 = lerp( Main_Metallic237_g51945 , Second_Metallic226_g51945 , Mask_Detail147_g51945);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float staticSwitch4064_g51945 = Main_Metallic237_g51945;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float staticSwitch4064_g51945 = lerpResult278_g51945;
				#else
				float staticSwitch4064_g51945 = Main_Metallic237_g51945;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch299_g51945 = Main_Metallic237_g51945;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch299_g51945 = staticSwitch4064_g51945;
				#else
				float staticSwitch299_g51945 = Main_Metallic237_g51945;
				#endif
				half Blend_Metallic306_g51945 = staticSwitch299_g51945;
				float lerpResult342_g51945 = lerp( Blend_Metallic306_g51945 , 0.0 , Overlay_Mask269_g51945);
				half Final_Metallic367_g51945 = lerpResult342_g51945;
				
				half Main_Smoothness227_g51945 = ( tex2DNode35_g51945.a * _MainSmoothnessValue );
				half Second_Smoothness236_g51945 = ( tex2DNode33_g51945.a * _SecondSmoothnessValue );
				float lerpResult266_g51945 = lerp( Main_Smoothness227_g51945 , Second_Smoothness236_g51945 , Mask_Detail147_g51945);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float staticSwitch4065_g51945 = Main_Smoothness227_g51945;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float staticSwitch4065_g51945 = lerpResult266_g51945;
				#else
				float staticSwitch4065_g51945 = Main_Smoothness227_g51945;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch297_g51945 = Main_Smoothness227_g51945;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch297_g51945 = staticSwitch4065_g51945;
				#else
				float staticSwitch297_g51945 = Main_Smoothness227_g51945;
				#endif
				half Blend_Smoothness314_g51945 = staticSwitch297_g51945;
				half Global_OverlaySmoothness311_g51945 = TVE_OverlaySmoothness;
				float lerpResult343_g51945 = lerp( Blend_Smoothness314_g51945 , Global_OverlaySmoothness311_g51945 , Overlay_Mask269_g51945);
				half Final_Smoothness371_g51945 = lerpResult343_g51945;
				half Global_Extras_Wetness305_g51945 = break89_g52261.g;
				float lerpResult3673_g51945 = lerp( 0.0 , Global_Extras_Wetness305_g51945 , _GlobalWetness);
				half Final_SmoothnessAndWetness4130_g51945 = saturate( ( Final_Smoothness371_g51945 + lerpResult3673_g51945 ) );
				
				float lerpResult240_g51945 = lerp( 1.0 , tex2DNode35_g51945.g , _MainOcclusionValue);
				half Main_Occlusion247_g51945 = lerpResult240_g51945;
				float lerpResult239_g51945 = lerp( 1.0 , tex2DNode33_g51945.g , _SecondOcclusionValue);
				half Second_Occlusion251_g51945 = lerpResult239_g51945;
				float lerpResult294_g51945 = lerp( Main_Occlusion247_g51945 , Second_Occlusion251_g51945 , Mask_Detail147_g51945);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float staticSwitch4066_g51945 = Main_Occlusion247_g51945;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float staticSwitch4066_g51945 = lerpResult294_g51945;
				#else
				float staticSwitch4066_g51945 = Main_Occlusion247_g51945;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch310_g51945 = Main_Occlusion247_g51945;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch310_g51945 = staticSwitch4066_g51945;
				#else
				float staticSwitch310_g51945 = Main_Occlusion247_g51945;
				#endif
				half Blend_Occlusion323_g51945 = staticSwitch310_g51945;
				
				float localCustomAlphaClip3735_g51945 = ( 0.0 );
				half Final_AlphaFade3727_g51945 = 1.0;
				float Main_Alpha316_g51945 = ( _MainColor.a * tex2DNode29_g51945.a );
				half AlphaTreshold2132_g51945 = _Cutoff;
				#ifdef TVE_ALPHA_CLIP
				float staticSwitch3792_g51945 = ( Main_Alpha316_g51945 - ( AlphaTreshold2132_g51945 - 0.5 ) );
				#else
				float staticSwitch3792_g51945 = Main_Alpha316_g51945;
				#endif
				half Final_Alpha3754_g51945 = staticSwitch3792_g51945;
				float temp_output_661_0_g51945 = ( Final_AlphaFade3727_g51945 * Final_Alpha3754_g51945 );
				float Alpha3735_g51945 = temp_output_661_0_g51945;
				float Treshold3735_g51945 = 0.5;
				{
				#if TVE_ALPHA_CLIP
				clip(Alpha3735_g51945 - Treshold3735_g51945);
				#endif
				}
				half Final_Clip914_g51945 = saturate( Alpha3735_g51945 );
				
				float3 Albedo = Final_Albedo359_g51945;
				float3 Normal = Final_Normal366_g51945;
				float3 Emission = Final_Emissive2476_g51945;
				float3 Specular = 0.5;
				float Metallic = Final_Metallic367_g51945;
				float Smoothness = Final_SmoothnessAndWetness4130_g51945;
				float Occlusion = Blend_Occlusion323_g51945;
				float Alpha = Final_Clip914_g51945;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData;
				inputData.positionWS = WorldPosition;
				inputData.viewDirectionWS = WorldViewDirection;
				inputData.shadowCoord = ShadowCoords;

				#ifdef _NORMALMAP
					#if _NORMAL_DROPOFF_TS
					inputData.normalWS = TransformTangentToWorld(Normal, half3x3( WorldTangent, WorldBiTangent, WorldNormal ));
					#elif _NORMAL_DROPOFF_OS
					inputData.normalWS = TransformObjectToWorldNormal(Normal);
					#elif _NORMAL_DROPOFF_WS
					inputData.normalWS = Normal;
					#endif
					inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				#else
					inputData.normalWS = WorldNormal;
				#endif

				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;
				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS );
				#ifdef _ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif
				
				inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				half4 color = UniversalFragmentPBR(
					inputData, 
					Albedo, 
					Metallic, 
					Specular, 
					Smoothness, 
					Occlusion, 
					Emission, 
					Alpha);

				#ifdef _TRANSMISSION_ASE
				{
					float shadow = _TransmissionShadow;

					Light mainLight = GetMainLight( inputData.shadowCoord );
					float3 mainAtten = mainLight.color * mainLight.distanceAttenuation;
					mainAtten = lerp( mainAtten, mainAtten * mainLight.shadowAttenuation, shadow );
					half3 mainTransmission = max(0 , -dot(inputData.normalWS, mainLight.direction)) * mainAtten * Transmission;
					color.rgb += Albedo * mainTransmission;

					#ifdef _ADDITIONAL_LIGHTS
						int transPixelLightCount = GetAdditionalLightsCount();
						for (int i = 0; i < transPixelLightCount; ++i)
						{
							Light light = GetAdditionalLight(i, inputData.positionWS);
							float3 atten = light.color * light.distanceAttenuation;
							atten = lerp( atten, atten * light.shadowAttenuation, shadow );

							half3 transmission = max(0 , -dot(inputData.normalWS, light.direction)) * atten * Transmission;
							color.rgb += Albedo * transmission;
						}
					#endif
				}
				#endif

				#ifdef _TRANSLUCENCY_ASE
				{
					float shadow = _TransShadow;
					float normal = _TransNormal;
					float scattering = _TransScattering;
					float direct = _TransDirect;
					float ambient = _TransAmbient;
					float strength = _TransStrength;

					Light mainLight = GetMainLight( inputData.shadowCoord );
					float3 mainAtten = mainLight.color * mainLight.distanceAttenuation;
					mainAtten = lerp( mainAtten, mainAtten * mainLight.shadowAttenuation, shadow );

					half3 mainLightDir = mainLight.direction + inputData.normalWS * normal;
					half mainVdotL = pow( saturate( dot( inputData.viewDirectionWS, -mainLightDir ) ), scattering );
					half3 mainTranslucency = mainAtten * ( mainVdotL * direct + inputData.bakedGI * ambient ) * Translucency;
					color.rgb += Albedo * mainTranslucency * strength;

					#ifdef _ADDITIONAL_LIGHTS
						int transPixelLightCount = GetAdditionalLightsCount();
						for (int i = 0; i < transPixelLightCount; ++i)
						{
							Light light = GetAdditionalLight(i, inputData.positionWS);
							float3 atten = light.color * light.distanceAttenuation;
							atten = lerp( atten, atten * light.shadowAttenuation, shadow );

							half3 lightDir = light.direction + inputData.normalWS * normal;
							half VdotL = pow( saturate( dot( inputData.viewDirectionWS, -lightDir ) ), scattering );
							half3 translucency = atten * ( VdotL * direct + inputData.bakedGI * ambient ) * Translucency;
							color.rgb += Albedo * translucency * strength;
						}
					#endif
				}
				#endif

				#ifdef _REFRACTION_ASE
					float4 projScreenPos = ScreenPos / ScreenPos.w;
					float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, WorldNormal ).xyz * ( 1.0 - dot( WorldNormal, WorldViewDirection ) );
					projScreenPos.xy += refractionOffset.xy;
					float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR( projScreenPos ) * RefractionColor;
					color.rgb = lerp( refraction, color.rgb, color.a );
					color.a = 1;
				#endif

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual
			AlphaToMask Off

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 100202
			#define ASE_USING_SAMPLING_MACROS 1

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_SHADOWCASTER

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#pragma shader_feature_local TVE_ALPHA_CLIP
			//TVE Shader Type Defines
			#define TVE_IS_OBJECT_SHADER
			//TVE Pipeline Defines
			#define THE_VEGETATION_ENGINE
			#define IS_UNIVERSAL_PIPELINE
			//TVE Batching Support Defines
			#define TVE_VERTEX_DATA_BATCHED
			//TVE Injection Defines
			//SHADER INJECTION POINT BEGIN
           //1msRenderVegetation (Instanced Indirect)
           #include "Assets/BasicRenderingFramework/shaders/1msRenderVegetation_Include.cginc"
           #pragma instancing_options procedural:setup forwardadd
           #pragma multi_compile GPU_FRUSTUM_ON __
			//SHADER INJECTION POINT END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _NoiseMaskRemap;
			half4 _MainUVs;
			half4 _EmissiveColor;
			float4 _SubsurfaceDiffusion_Asset;
			half4 _ColorsMaskRemap;
			half4 _SubsurfaceMaskRemap;
			float4 _GradientMaskRemap;
			half4 _OverlayMaskRemap;
			float4 _MaxBoundsInfo;
			half4 _EmissiveUVs;
			half4 _VertexOcclusionRemap;
			half4 _DetailBlendRemap;
			half4 _SecondColor;
			half4 _SecondUVs;
			float4 _Color;
			float4 _SubsurfaceDiffusion_asset;
			half4 _MainColor;
			half3 _render_normals_options;
			half _DetailCoordMode;
			half _DetailMeshValue;
			half _render_cull;
			half _RenderMode;
			half _SizeFadeCat;
			half _RenderDecals;
			half _RenderZWrite;
			half _TranslucencyShadowValue;
			half _RenderSSR;
			float _SubsurfaceDiffusion;
			half _EmissiveFlagMode;
			half _MainNormalValue;
			half _OverlayBottomValue;
			half _DetailMaskMode;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half _SecondMetallicValue;
			half _MainMetallicValue;
			half _GlobalEmissive;
			half _DetailNormalValue;
			half _DetailProjectionMode;
			half _SecondNormalValue;
			half _OverlayMaskMinValue;
			half _LayerExtrasValue;
			half _GlobalOverlay;
			half _MotionSpace;
			half _DetailBlendMaxValue;
			half _DetailBlendMinValue;
			half _DetailMaskInvertMode;
			half _OverlayMaskMaxValue;
			half _RenderCull;
			half _GlobalCat;
			half _VertexVariationMode;
			half _DetailBlendMode;
			half _LayersSpace;
			half _Cutoff;
			half _MainCat;
			half _DetailMode;
			half _SubsurfaceCat;
			half _RenderNormals;
			half _VariationGlobalsMessage;
			half _MotionCat;
			half _OcclusionCat;
			half _SizeFadeMessage;
			half _TranslucencyHDMessage;
			half _render_src;
			half _IsStandardShader;
			half _render_zw;
			half _IsPropShader;
			half _render_dst;
			half _ReceiveSpace;
			half _PerspectiveCat;
			half _EmissiveCat;
			half _RenderPriority;
			half _GradientCat;
			half _TranslucencyDirectValue;
			half _FadeSpace;
			half _MainOcclusionValue;
			half _IsTVEShader;
			half _DetailSpace;
			half _DetailTypeMode;
			half _DetailCat;
			half _TranslucencyScatteringValue;
			half _TranslucencyNormalValue;
			half _RenderClip;
			half _IsVersion;
			half _RenderingCat;
			half _VertexMasksMode;
			half _VariationMotionMessage;
			half _TranslucencyAmbientValue;
			half _NoiseCat;
			half _TranslucencyIntensityValue;
			half _SecondOcclusionValue;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			TEXTURE2D(_BumpMap);
			SAMPLER(sampler_BumpMap);
			TEXTURE2D(_MainTex);
			SAMPLER(sampler_MainTex);
			TEXTURE2D(_MainAlbedoTex);
			SAMPLER(sampler_MainAlbedoTex);


			
			float3 _LightDirection;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float2 vertexToFrag11_g52308 = ( ( v.ase_texcoord.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				o.ase_texcoord2.xy = vertexToFrag11_g52308;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif
				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

				float4 clipPos = TransformWorldToHClip( ApplyShadowBias( positionWS, normalWS, _LightDirection ) );

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				o.clipPos = clipPos;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual  
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag(	VertexOutput IN 
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );
				
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float localCustomAlphaClip3735_g51945 = ( 0.0 );
				half Final_AlphaFade3727_g51945 = 1.0;
				float2 vertexToFrag11_g52308 = IN.ase_texcoord2.xy;
				half2 Main_UVs15_g51945 = vertexToFrag11_g52308;
				float4 tex2DNode29_g51945 = SAMPLE_TEXTURE2D( _MainAlbedoTex, sampler_MainAlbedoTex, Main_UVs15_g51945 );
				float Main_Alpha316_g51945 = ( _MainColor.a * tex2DNode29_g51945.a );
				half AlphaTreshold2132_g51945 = _Cutoff;
				#ifdef TVE_ALPHA_CLIP
				float staticSwitch3792_g51945 = ( Main_Alpha316_g51945 - ( AlphaTreshold2132_g51945 - 0.5 ) );
				#else
				float staticSwitch3792_g51945 = Main_Alpha316_g51945;
				#endif
				half Final_Alpha3754_g51945 = staticSwitch3792_g51945;
				float temp_output_661_0_g51945 = ( Final_AlphaFade3727_g51945 * Final_Alpha3754_g51945 );
				float Alpha3735_g51945 = temp_output_661_0_g51945;
				float Treshold3735_g51945 = 0.5;
				{
				#if TVE_ALPHA_CLIP
				clip(Alpha3735_g51945 - Treshold3735_g51945);
				#endif
				}
				half Final_Clip914_g51945 = saturate( Alpha3735_g51945 );
				
				float Alpha = Final_Clip914_g51945;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					#ifdef _ALPHATEST_SHADOW_ON
						clip(Alpha - AlphaClipThresholdShadow);
					#else
						clip(Alpha - AlphaClipThreshold);
					#endif
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif
				return 0;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0
			AlphaToMask Off

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 100202
			#define ASE_USING_SAMPLING_MACROS 1

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#pragma shader_feature_local TVE_ALPHA_CLIP
			//TVE Shader Type Defines
			#define TVE_IS_OBJECT_SHADER
			//TVE Pipeline Defines
			#define THE_VEGETATION_ENGINE
			#define IS_UNIVERSAL_PIPELINE
			//TVE Batching Support Defines
			#define TVE_VERTEX_DATA_BATCHED
			//TVE Injection Defines
			//SHADER INJECTION POINT BEGIN
           //1msRenderVegetation (Instanced Indirect)
           #include "Assets/BasicRenderingFramework/shaders/1msRenderVegetation_Include.cginc"
           #pragma instancing_options procedural:setup forwardadd
           #pragma multi_compile GPU_FRUSTUM_ON __
			//SHADER INJECTION POINT END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _NoiseMaskRemap;
			half4 _MainUVs;
			half4 _EmissiveColor;
			float4 _SubsurfaceDiffusion_Asset;
			half4 _ColorsMaskRemap;
			half4 _SubsurfaceMaskRemap;
			float4 _GradientMaskRemap;
			half4 _OverlayMaskRemap;
			float4 _MaxBoundsInfo;
			half4 _EmissiveUVs;
			half4 _VertexOcclusionRemap;
			half4 _DetailBlendRemap;
			half4 _SecondColor;
			half4 _SecondUVs;
			float4 _Color;
			float4 _SubsurfaceDiffusion_asset;
			half4 _MainColor;
			half3 _render_normals_options;
			half _DetailCoordMode;
			half _DetailMeshValue;
			half _render_cull;
			half _RenderMode;
			half _SizeFadeCat;
			half _RenderDecals;
			half _RenderZWrite;
			half _TranslucencyShadowValue;
			half _RenderSSR;
			float _SubsurfaceDiffusion;
			half _EmissiveFlagMode;
			half _MainNormalValue;
			half _OverlayBottomValue;
			half _DetailMaskMode;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half _SecondMetallicValue;
			half _MainMetallicValue;
			half _GlobalEmissive;
			half _DetailNormalValue;
			half _DetailProjectionMode;
			half _SecondNormalValue;
			half _OverlayMaskMinValue;
			half _LayerExtrasValue;
			half _GlobalOverlay;
			half _MotionSpace;
			half _DetailBlendMaxValue;
			half _DetailBlendMinValue;
			half _DetailMaskInvertMode;
			half _OverlayMaskMaxValue;
			half _RenderCull;
			half _GlobalCat;
			half _VertexVariationMode;
			half _DetailBlendMode;
			half _LayersSpace;
			half _Cutoff;
			half _MainCat;
			half _DetailMode;
			half _SubsurfaceCat;
			half _RenderNormals;
			half _VariationGlobalsMessage;
			half _MotionCat;
			half _OcclusionCat;
			half _SizeFadeMessage;
			half _TranslucencyHDMessage;
			half _render_src;
			half _IsStandardShader;
			half _render_zw;
			half _IsPropShader;
			half _render_dst;
			half _ReceiveSpace;
			half _PerspectiveCat;
			half _EmissiveCat;
			half _RenderPriority;
			half _GradientCat;
			half _TranslucencyDirectValue;
			half _FadeSpace;
			half _MainOcclusionValue;
			half _IsTVEShader;
			half _DetailSpace;
			half _DetailTypeMode;
			half _DetailCat;
			half _TranslucencyScatteringValue;
			half _TranslucencyNormalValue;
			half _RenderClip;
			half _IsVersion;
			half _RenderingCat;
			half _VertexMasksMode;
			half _VariationMotionMessage;
			half _TranslucencyAmbientValue;
			half _NoiseCat;
			half _TranslucencyIntensityValue;
			half _SecondOcclusionValue;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			TEXTURE2D(_BumpMap);
			SAMPLER(sampler_BumpMap);
			TEXTURE2D(_MainTex);
			SAMPLER(sampler_MainTex);
			TEXTURE2D(_MainAlbedoTex);
			SAMPLER(sampler_MainAlbedoTex);


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 vertexToFrag11_g52308 = ( ( v.ase_texcoord.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				o.ase_texcoord2.xy = vertexToFrag11_g52308;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				o.clipPos = positionCS;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual  
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif
			half4 frag(	VertexOutput IN 
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float localCustomAlphaClip3735_g51945 = ( 0.0 );
				half Final_AlphaFade3727_g51945 = 1.0;
				float2 vertexToFrag11_g52308 = IN.ase_texcoord2.xy;
				half2 Main_UVs15_g51945 = vertexToFrag11_g52308;
				float4 tex2DNode29_g51945 = SAMPLE_TEXTURE2D( _MainAlbedoTex, sampler_MainAlbedoTex, Main_UVs15_g51945 );
				float Main_Alpha316_g51945 = ( _MainColor.a * tex2DNode29_g51945.a );
				half AlphaTreshold2132_g51945 = _Cutoff;
				#ifdef TVE_ALPHA_CLIP
				float staticSwitch3792_g51945 = ( Main_Alpha316_g51945 - ( AlphaTreshold2132_g51945 - 0.5 ) );
				#else
				float staticSwitch3792_g51945 = Main_Alpha316_g51945;
				#endif
				half Final_Alpha3754_g51945 = staticSwitch3792_g51945;
				float temp_output_661_0_g51945 = ( Final_AlphaFade3727_g51945 * Final_Alpha3754_g51945 );
				float Alpha3735_g51945 = temp_output_661_0_g51945;
				float Treshold3735_g51945 = 0.5;
				{
				#if TVE_ALPHA_CLIP
				clip(Alpha3735_g51945 - Treshold3735_g51945);
				#endif
				}
				half Final_Clip914_g51945 = saturate( Alpha3735_g51945 );
				
				float Alpha = Final_Clip914_g51945;
				float AlphaClipThreshold = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				#ifdef ASE_DEPTH_WRITE_ON
				outputDepth = DepthValue;
				#endif

				return 0;
			}
			ENDHLSL
		}
		
		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 100202
			#define ASE_USING_SAMPLING_MACROS 1

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_META

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#pragma shader_feature_local TVE_ALPHA_CLIP
			#pragma shader_feature_local TVE_DETAIL_MODE_OFF TVE_DETAIL_MODE_ON
			#pragma shader_feature_local TVE_DETAIL_BLEND_OVERLAY TVE_DETAIL_BLEND_REPLACE
			#pragma shader_feature_local TVE_DETAIL_TYPE_VERTEX_BLUE TVE_DETAIL_TYPE_PROJECTION
			//TVE Shader Type Defines
			#define TVE_IS_OBJECT_SHADER
			//TVE Pipeline Defines
			#define THE_VEGETATION_ENGINE
			#define IS_UNIVERSAL_PIPELINE
			//TVE Batching Support Defines
			#define TVE_VERTEX_DATA_BATCHED
			//TVE Injection Defines
			//SHADER INJECTION POINT BEGIN
           //1msRenderVegetation (Instanced Indirect)
           #include "Assets/BasicRenderingFramework/shaders/1msRenderVegetation_Include.cginc"
           #pragma instancing_options procedural:setup forwardadd
           #pragma multi_compile GPU_FRUSTUM_ON __
			//SHADER INJECTION POINT END


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _NoiseMaskRemap;
			half4 _MainUVs;
			half4 _EmissiveColor;
			float4 _SubsurfaceDiffusion_Asset;
			half4 _ColorsMaskRemap;
			half4 _SubsurfaceMaskRemap;
			float4 _GradientMaskRemap;
			half4 _OverlayMaskRemap;
			float4 _MaxBoundsInfo;
			half4 _EmissiveUVs;
			half4 _VertexOcclusionRemap;
			half4 _DetailBlendRemap;
			half4 _SecondColor;
			half4 _SecondUVs;
			float4 _Color;
			float4 _SubsurfaceDiffusion_asset;
			half4 _MainColor;
			half3 _render_normals_options;
			half _DetailCoordMode;
			half _DetailMeshValue;
			half _render_cull;
			half _RenderMode;
			half _SizeFadeCat;
			half _RenderDecals;
			half _RenderZWrite;
			half _TranslucencyShadowValue;
			half _RenderSSR;
			float _SubsurfaceDiffusion;
			half _EmissiveFlagMode;
			half _MainNormalValue;
			half _OverlayBottomValue;
			half _DetailMaskMode;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half _SecondMetallicValue;
			half _MainMetallicValue;
			half _GlobalEmissive;
			half _DetailNormalValue;
			half _DetailProjectionMode;
			half _SecondNormalValue;
			half _OverlayMaskMinValue;
			half _LayerExtrasValue;
			half _GlobalOverlay;
			half _MotionSpace;
			half _DetailBlendMaxValue;
			half _DetailBlendMinValue;
			half _DetailMaskInvertMode;
			half _OverlayMaskMaxValue;
			half _RenderCull;
			half _GlobalCat;
			half _VertexVariationMode;
			half _DetailBlendMode;
			half _LayersSpace;
			half _Cutoff;
			half _MainCat;
			half _DetailMode;
			half _SubsurfaceCat;
			half _RenderNormals;
			half _VariationGlobalsMessage;
			half _MotionCat;
			half _OcclusionCat;
			half _SizeFadeMessage;
			half _TranslucencyHDMessage;
			half _render_src;
			half _IsStandardShader;
			half _render_zw;
			half _IsPropShader;
			half _render_dst;
			half _ReceiveSpace;
			half _PerspectiveCat;
			half _EmissiveCat;
			half _RenderPriority;
			half _GradientCat;
			half _TranslucencyDirectValue;
			half _FadeSpace;
			half _MainOcclusionValue;
			half _IsTVEShader;
			half _DetailSpace;
			half _DetailTypeMode;
			half _DetailCat;
			half _TranslucencyScatteringValue;
			half _TranslucencyNormalValue;
			half _RenderClip;
			half _IsVersion;
			half _RenderingCat;
			half _VertexMasksMode;
			half _VariationMotionMessage;
			half _TranslucencyAmbientValue;
			half _NoiseCat;
			half _TranslucencyIntensityValue;
			half _SecondOcclusionValue;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			TEXTURE2D(_BumpMap);
			SAMPLER(sampler_BumpMap);
			TEXTURE2D(_MainTex);
			SAMPLER(sampler_MainTex);
			TEXTURE2D(_MainAlbedoTex);
			SAMPLER(sampler_MainAlbedoTex);
			TEXTURE2D(_SecondAlbedoTex);
			TEXTURE2D(_SecondMaskTex);
			SAMPLER(sampler_SecondMaskTex);
			TEXTURE2D(_MainNormalTex);
			TEXTURE2D(_MainMaskTex);
			half4 TVE_OverlayColor;
			half4 TVE_ExtrasParams;
			TEXTURE2D_ARRAY(TVE_ExtrasTex);
			half4 TVE_ExtrasCoord;
			SAMPLER(samplerTVE_ExtrasTex);
			float TVE_ExtrasUsage[9];
			TEXTURE2D(_EmissiveTex);
			SAMPLER(sampler_EmissiveTex);


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 vertexToFrag11_g52308 = ( ( v.ase_texcoord.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				o.ase_texcoord2.xy = vertexToFrag11_g52308;
				float2 lerpResult1545_g51945 = lerp( v.ase_texcoord.xy , v.texcoord1.xy , _DetailCoordMode);
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				#if defined(TVE_DETAIL_TYPE_VERTEX_BLUE)
				float2 staticSwitch3466_g51945 = lerpResult1545_g51945;
				#elif defined(TVE_DETAIL_TYPE_PROJECTION)
				float2 staticSwitch3466_g51945 = (ase_worldPos).xz;
				#else
				float2 staticSwitch3466_g51945 = lerpResult1545_g51945;
				#endif
				float2 vertexToFrag11_g52243 = ( ( staticSwitch3466_g51945 * (_SecondUVs).xy ) + (_SecondUVs).zw );
				o.ase_texcoord2.zw = vertexToFrag11_g52243;
				half Mesh_DetailMask90_g51945 = v.ase_color.b;
				float vertexToFrag11_g52208 = ( ( Mesh_DetailMask90_g51945 - 0.5 ) + _DetailMeshValue );
				o.ase_texcoord3.x = vertexToFrag11_g52208;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord3.yzw = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord4.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord5.xyz = ase_worldBitangent;
				float3 vertexToFrag3890_g51945 = ase_worldPos;
				o.ase_texcoord6.xyz = vertexToFrag3890_g51945;
				
				float2 vertexToFrag11_g52248 = ( ( v.ase_texcoord.xy * (_EmissiveUVs).xy ) + (_EmissiveUVs).zw );
				o.ase_texcoord7.xy = vertexToFrag11_g52248;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.w = 0;
				o.ase_texcoord5.w = 0;
				o.ase_texcoord6.w = 0;
				o.ase_texcoord7.zw = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = o.clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				float4 ase_tangent : TANGENT;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_color = v.ase_color;
				o.ase_tangent = v.ase_tangent;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 vertexToFrag11_g52308 = IN.ase_texcoord2.xy;
				half2 Main_UVs15_g51945 = vertexToFrag11_g52308;
				float4 tex2DNode29_g51945 = SAMPLE_TEXTURE2D( _MainAlbedoTex, sampler_MainAlbedoTex, Main_UVs15_g51945 );
				float3 temp_output_51_0_g51945 = ( (_MainColor).rgb * (tex2DNode29_g51945).rgb );
				half3 Main_Albedo99_g51945 = temp_output_51_0_g51945;
				float2 vertexToFrag11_g52243 = IN.ase_texcoord2.zw;
				half2 Second_UVs17_g51945 = vertexToFrag11_g52243;
				half3 Second_Albedo153_g51945 = (( _SecondColor * SAMPLE_TEXTURE2D( _SecondAlbedoTex, sampler_SecondMaskTex, Second_UVs17_g51945 ) )).rgb;
				#ifdef UNITY_COLORSPACE_GAMMA
				float staticSwitch1_g52209 = 2.0;
				#else
				float staticSwitch1_g52209 = 4.594794;
				#endif
				float vertexToFrag11_g52208 = IN.ase_texcoord3.x;
				float temp_output_3919_0_g51945 = vertexToFrag11_g52208;
				float3 unpack4112_g51945 = UnpackNormalScale( SAMPLE_TEXTURE2D( _MainNormalTex, sampler_MainAlbedoTex, Main_UVs15_g51945 ), _MainNormalValue );
				unpack4112_g51945.z = lerp( 1, unpack4112_g51945.z, saturate(_MainNormalValue) );
				half3 Main_Normal137_g51945 = unpack4112_g51945;
				float3 ase_worldTangent = IN.ase_texcoord3.yzw;
				float3 ase_worldNormal = IN.ase_texcoord4.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord5.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal4099_g51945 = Main_Normal137_g51945;
				float3 worldNormal4099_g51945 = float3(dot(tanToWorld0,tanNormal4099_g51945), dot(tanToWorld1,tanNormal4099_g51945), dot(tanToWorld2,tanNormal4099_g51945));
				float3 Main_Normal_WS4101_g51945 = worldNormal4099_g51945;
				float lerpResult1537_g51945 = lerp( Main_Normal_WS4101_g51945.y , -Main_Normal_WS4101_g51945.y , _DetailProjectionMode);
				#if defined(TVE_DETAIL_TYPE_VERTEX_BLUE)
				float staticSwitch3467_g51945 = temp_output_3919_0_g51945;
				#elif defined(TVE_DETAIL_TYPE_PROJECTION)
				float staticSwitch3467_g51945 = ( ( lerpResult1537_g51945 * 0.5 ) + _DetailMeshValue );
				#else
				float staticSwitch3467_g51945 = temp_output_3919_0_g51945;
				#endif
				half Blend_Source1540_g51945 = staticSwitch3467_g51945;
				float4 tex2DNode35_g51945 = SAMPLE_TEXTURE2D( _MainMaskTex, sampler_MainAlbedoTex, Main_UVs15_g51945 );
				half Main_Mask57_g51945 = tex2DNode35_g51945.b;
				float4 tex2DNode33_g51945 = SAMPLE_TEXTURE2D( _SecondMaskTex, sampler_SecondMaskTex, Second_UVs17_g51945 );
				half Second_Mask81_g51945 = tex2DNode33_g51945.b;
				float lerpResult1327_g51945 = lerp( Main_Mask57_g51945 , Second_Mask81_g51945 , _DetailMaskMode);
				float lerpResult4058_g51945 = lerp( lerpResult1327_g51945 , ( 1.0 - lerpResult1327_g51945 ) , _DetailMaskInvertMode);
				float temp_output_7_0_g52238 = _DetailBlendMinValue;
				half Mask_Detail147_g51945 = saturate( ( ( saturate( ( Blend_Source1540_g51945 + ( Blend_Source1540_g51945 * lerpResult4058_g51945 ) ) ) - temp_output_7_0_g52238 ) / ( _DetailBlendMaxValue - temp_output_7_0_g52238 ) ) );
				float3 lerpResult235_g51945 = lerp( Main_Albedo99_g51945 , ( Main_Albedo99_g51945 * Second_Albedo153_g51945 * staticSwitch1_g52209 ) , Mask_Detail147_g51945);
				float3 lerpResult208_g51945 = lerp( Main_Albedo99_g51945 , Second_Albedo153_g51945 , Mask_Detail147_g51945);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float3 staticSwitch4062_g51945 = lerpResult235_g51945;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float3 staticSwitch4062_g51945 = lerpResult208_g51945;
				#else
				float3 staticSwitch4062_g51945 = lerpResult235_g51945;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float3 staticSwitch255_g51945 = Main_Albedo99_g51945;
				#elif defined(TVE_DETAIL_MODE_ON)
				float3 staticSwitch255_g51945 = staticSwitch4062_g51945;
				#else
				float3 staticSwitch255_g51945 = Main_Albedo99_g51945;
				#endif
				half3 Blend_Albedo265_g51945 = staticSwitch255_g51945;
				half3 Blend_AlbedoTinted2808_g51945 = ( float3(1,1,1) * float3(1,1,1) * float3(1,1,1) * Blend_Albedo265_g51945 );
				half3 Blend_AlbedoColored863_g51945 = Blend_AlbedoTinted2808_g51945;
				half3 Blend_AlbedoAndSubsurface149_g51945 = Blend_AlbedoColored863_g51945;
				half3 Global_OverlayColor1758_g51945 = (TVE_OverlayColor).rgb;
				float lerpResult3567_g51945 = lerp( _OverlayBottomValue , 1.0 , Main_Normal_WS4101_g51945.y);
				half Main_AlbedoTex_G3526_g51945 = tex2DNode29_g51945.g;
				half Second_AlbedoTex_G3581_g51945 = (SAMPLE_TEXTURE2D( _SecondAlbedoTex, sampler_SecondMaskTex, Second_UVs17_g51945 )).g;
				float lerpResult3579_g51945 = lerp( Main_AlbedoTex_G3526_g51945 , Second_AlbedoTex_G3581_g51945 , Mask_Detail147_g51945);
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch3574_g51945 = Main_AlbedoTex_G3526_g51945;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch3574_g51945 = lerpResult3579_g51945;
				#else
				float staticSwitch3574_g51945 = Main_AlbedoTex_G3526_g51945;
				#endif
				float3 vertexToFrag3890_g51945 = IN.ase_texcoord6.xyz;
				float3 PositionWS_PerVertex3905_g51945 = vertexToFrag3890_g51945;
				float3 Position82_g52261 = PositionWS_PerVertex3905_g51945;
				float temp_output_84_0_g52261 = _LayerExtrasValue;
				float4 lerpResult88_g52261 = lerp( TVE_ExtrasParams , SAMPLE_TEXTURE2D_ARRAY( TVE_ExtrasTex, samplerTVE_ExtrasTex, ( (TVE_ExtrasCoord).zw + ( (TVE_ExtrasCoord).xy * (Position82_g52261).xz ) ),temp_output_84_0_g52261 ) , TVE_ExtrasUsage[(int)temp_output_84_0_g52261]);
				float4 break89_g52261 = lerpResult88_g52261;
				half Global_Extras_Overlay156_g51945 = break89_g52261.b;
				float temp_output_1025_0_g51945 = ( _GlobalOverlay * Global_Extras_Overlay156_g51945 );
				half Overlay_Commons1365_g51945 = temp_output_1025_0_g51945;
				float temp_output_7_0_g52234 = _OverlayMaskMinValue;
				half Overlay_Mask269_g51945 = saturate( ( ( ( ( ( lerpResult3567_g51945 * 0.5 ) + staticSwitch3574_g51945 ) * Overlay_Commons1365_g51945 ) - temp_output_7_0_g52234 ) / ( _OverlayMaskMaxValue - temp_output_7_0_g52234 ) ) );
				float3 lerpResult336_g51945 = lerp( Blend_AlbedoAndSubsurface149_g51945 , Global_OverlayColor1758_g51945 , Overlay_Mask269_g51945);
				half3 Final_Albedo359_g51945 = lerpResult336_g51945;
				
				float2 vertexToFrag11_g52248 = IN.ase_texcoord7.xy;
				half2 Emissive_UVs2468_g51945 = vertexToFrag11_g52248;
				half Global_Extras_Emissive4203_g51945 = break89_g52261.r;
				float lerpResult4206_g51945 = lerp( 1.0 , Global_Extras_Emissive4203_g51945 , _GlobalEmissive);
				half3 Final_Emissive2476_g51945 = ( (( _EmissiveColor * SAMPLE_TEXTURE2D( _EmissiveTex, sampler_EmissiveTex, Emissive_UVs2468_g51945 ) )).rgb * lerpResult4206_g51945 );
				
				float localCustomAlphaClip3735_g51945 = ( 0.0 );
				half Final_AlphaFade3727_g51945 = 1.0;
				float Main_Alpha316_g51945 = ( _MainColor.a * tex2DNode29_g51945.a );
				half AlphaTreshold2132_g51945 = _Cutoff;
				#ifdef TVE_ALPHA_CLIP
				float staticSwitch3792_g51945 = ( Main_Alpha316_g51945 - ( AlphaTreshold2132_g51945 - 0.5 ) );
				#else
				float staticSwitch3792_g51945 = Main_Alpha316_g51945;
				#endif
				half Final_Alpha3754_g51945 = staticSwitch3792_g51945;
				float temp_output_661_0_g51945 = ( Final_AlphaFade3727_g51945 * Final_Alpha3754_g51945 );
				float Alpha3735_g51945 = temp_output_661_0_g51945;
				float Treshold3735_g51945 = 0.5;
				{
				#if TVE_ALPHA_CLIP
				clip(Alpha3735_g51945 - Treshold3735_g51945);
				#endif
				}
				half Final_Clip914_g51945 = saturate( Alpha3735_g51945 );
				
				
				float3 Albedo = Final_Albedo359_g51945;
				float3 Emission = Final_Emissive2476_g51945;
				float Alpha = Final_Clip914_g51945;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = Albedo;
				metaInput.Emission = Emission;
				
				return MetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend [_render_src] [_render_dst], One Zero
			ZWrite [_render_zw]
			ZTest LEqual
			Offset 0,0
			ColorMask RGBA

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 100202
			#define ASE_USING_SAMPLING_MACROS 1

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_2D

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			#define ASE_NEEDS_VERT_NORMAL
			#pragma shader_feature_local TVE_ALPHA_CLIP
			#pragma shader_feature_local TVE_DETAIL_MODE_OFF TVE_DETAIL_MODE_ON
			#pragma shader_feature_local TVE_DETAIL_BLEND_OVERLAY TVE_DETAIL_BLEND_REPLACE
			#pragma shader_feature_local TVE_DETAIL_TYPE_VERTEX_BLUE TVE_DETAIL_TYPE_PROJECTION
			//TVE Shader Type Defines
			#define TVE_IS_OBJECT_SHADER
			//TVE Pipeline Defines
			#define THE_VEGETATION_ENGINE
			#define IS_UNIVERSAL_PIPELINE
			//TVE Batching Support Defines
			#define TVE_VERTEX_DATA_BATCHED
			//TVE Injection Defines
			//SHADER INJECTION POINT BEGIN
           //1msRenderVegetation (Instanced Indirect)
           #include "Assets/BasicRenderingFramework/shaders/1msRenderVegetation_Include.cginc"
           #pragma instancing_options procedural:setup forwardadd
           #pragma multi_compile GPU_FRUSTUM_ON __
			//SHADER INJECTION POINT END


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _NoiseMaskRemap;
			half4 _MainUVs;
			half4 _EmissiveColor;
			float4 _SubsurfaceDiffusion_Asset;
			half4 _ColorsMaskRemap;
			half4 _SubsurfaceMaskRemap;
			float4 _GradientMaskRemap;
			half4 _OverlayMaskRemap;
			float4 _MaxBoundsInfo;
			half4 _EmissiveUVs;
			half4 _VertexOcclusionRemap;
			half4 _DetailBlendRemap;
			half4 _SecondColor;
			half4 _SecondUVs;
			float4 _Color;
			float4 _SubsurfaceDiffusion_asset;
			half4 _MainColor;
			half3 _render_normals_options;
			half _DetailCoordMode;
			half _DetailMeshValue;
			half _render_cull;
			half _RenderMode;
			half _SizeFadeCat;
			half _RenderDecals;
			half _RenderZWrite;
			half _TranslucencyShadowValue;
			half _RenderSSR;
			float _SubsurfaceDiffusion;
			half _EmissiveFlagMode;
			half _MainNormalValue;
			half _OverlayBottomValue;
			half _DetailMaskMode;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half _SecondMetallicValue;
			half _MainMetallicValue;
			half _GlobalEmissive;
			half _DetailNormalValue;
			half _DetailProjectionMode;
			half _SecondNormalValue;
			half _OverlayMaskMinValue;
			half _LayerExtrasValue;
			half _GlobalOverlay;
			half _MotionSpace;
			half _DetailBlendMaxValue;
			half _DetailBlendMinValue;
			half _DetailMaskInvertMode;
			half _OverlayMaskMaxValue;
			half _RenderCull;
			half _GlobalCat;
			half _VertexVariationMode;
			half _DetailBlendMode;
			half _LayersSpace;
			half _Cutoff;
			half _MainCat;
			half _DetailMode;
			half _SubsurfaceCat;
			half _RenderNormals;
			half _VariationGlobalsMessage;
			half _MotionCat;
			half _OcclusionCat;
			half _SizeFadeMessage;
			half _TranslucencyHDMessage;
			half _render_src;
			half _IsStandardShader;
			half _render_zw;
			half _IsPropShader;
			half _render_dst;
			half _ReceiveSpace;
			half _PerspectiveCat;
			half _EmissiveCat;
			half _RenderPriority;
			half _GradientCat;
			half _TranslucencyDirectValue;
			half _FadeSpace;
			half _MainOcclusionValue;
			half _IsTVEShader;
			half _DetailSpace;
			half _DetailTypeMode;
			half _DetailCat;
			half _TranslucencyScatteringValue;
			half _TranslucencyNormalValue;
			half _RenderClip;
			half _IsVersion;
			half _RenderingCat;
			half _VertexMasksMode;
			half _VariationMotionMessage;
			half _TranslucencyAmbientValue;
			half _NoiseCat;
			half _TranslucencyIntensityValue;
			half _SecondOcclusionValue;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			TEXTURE2D(_BumpMap);
			SAMPLER(sampler_BumpMap);
			TEXTURE2D(_MainTex);
			SAMPLER(sampler_MainTex);
			TEXTURE2D(_MainAlbedoTex);
			SAMPLER(sampler_MainAlbedoTex);
			TEXTURE2D(_SecondAlbedoTex);
			TEXTURE2D(_SecondMaskTex);
			SAMPLER(sampler_SecondMaskTex);
			TEXTURE2D(_MainNormalTex);
			TEXTURE2D(_MainMaskTex);
			half4 TVE_OverlayColor;
			half4 TVE_ExtrasParams;
			TEXTURE2D_ARRAY(TVE_ExtrasTex);
			half4 TVE_ExtrasCoord;
			SAMPLER(samplerTVE_ExtrasTex);
			float TVE_ExtrasUsage[9];


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float2 vertexToFrag11_g52308 = ( ( v.ase_texcoord.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				o.ase_texcoord2.xy = vertexToFrag11_g52308;
				float2 lerpResult1545_g51945 = lerp( v.ase_texcoord.xy , v.ase_texcoord1.xy , _DetailCoordMode);
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				#if defined(TVE_DETAIL_TYPE_VERTEX_BLUE)
				float2 staticSwitch3466_g51945 = lerpResult1545_g51945;
				#elif defined(TVE_DETAIL_TYPE_PROJECTION)
				float2 staticSwitch3466_g51945 = (ase_worldPos).xz;
				#else
				float2 staticSwitch3466_g51945 = lerpResult1545_g51945;
				#endif
				float2 vertexToFrag11_g52243 = ( ( staticSwitch3466_g51945 * (_SecondUVs).xy ) + (_SecondUVs).zw );
				o.ase_texcoord2.zw = vertexToFrag11_g52243;
				half Mesh_DetailMask90_g51945 = v.ase_color.b;
				float vertexToFrag11_g52208 = ( ( Mesh_DetailMask90_g51945 - 0.5 ) + _DetailMeshValue );
				o.ase_texcoord3.x = vertexToFrag11_g52208;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord3.yzw = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord4.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord5.xyz = ase_worldBitangent;
				float3 vertexToFrag3890_g51945 = ase_worldPos;
				o.ase_texcoord6.xyz = vertexToFrag3890_g51945;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.w = 0;
				o.ase_texcoord5.w = 0;
				o.ase_texcoord6.w = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				float4 ase_tangent : TANGENT;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_texcoord1 = v.ase_texcoord1;
				o.ase_color = v.ase_color;
				o.ase_tangent = v.ase_tangent;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_texcoord1 = patch[0].ase_texcoord1 * bary.x + patch[1].ase_texcoord1 * bary.y + patch[2].ase_texcoord1 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 vertexToFrag11_g52308 = IN.ase_texcoord2.xy;
				half2 Main_UVs15_g51945 = vertexToFrag11_g52308;
				float4 tex2DNode29_g51945 = SAMPLE_TEXTURE2D( _MainAlbedoTex, sampler_MainAlbedoTex, Main_UVs15_g51945 );
				float3 temp_output_51_0_g51945 = ( (_MainColor).rgb * (tex2DNode29_g51945).rgb );
				half3 Main_Albedo99_g51945 = temp_output_51_0_g51945;
				float2 vertexToFrag11_g52243 = IN.ase_texcoord2.zw;
				half2 Second_UVs17_g51945 = vertexToFrag11_g52243;
				half3 Second_Albedo153_g51945 = (( _SecondColor * SAMPLE_TEXTURE2D( _SecondAlbedoTex, sampler_SecondMaskTex, Second_UVs17_g51945 ) )).rgb;
				#ifdef UNITY_COLORSPACE_GAMMA
				float staticSwitch1_g52209 = 2.0;
				#else
				float staticSwitch1_g52209 = 4.594794;
				#endif
				float vertexToFrag11_g52208 = IN.ase_texcoord3.x;
				float temp_output_3919_0_g51945 = vertexToFrag11_g52208;
				float3 unpack4112_g51945 = UnpackNormalScale( SAMPLE_TEXTURE2D( _MainNormalTex, sampler_MainAlbedoTex, Main_UVs15_g51945 ), _MainNormalValue );
				unpack4112_g51945.z = lerp( 1, unpack4112_g51945.z, saturate(_MainNormalValue) );
				half3 Main_Normal137_g51945 = unpack4112_g51945;
				float3 ase_worldTangent = IN.ase_texcoord3.yzw;
				float3 ase_worldNormal = IN.ase_texcoord4.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord5.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal4099_g51945 = Main_Normal137_g51945;
				float3 worldNormal4099_g51945 = float3(dot(tanToWorld0,tanNormal4099_g51945), dot(tanToWorld1,tanNormal4099_g51945), dot(tanToWorld2,tanNormal4099_g51945));
				float3 Main_Normal_WS4101_g51945 = worldNormal4099_g51945;
				float lerpResult1537_g51945 = lerp( Main_Normal_WS4101_g51945.y , -Main_Normal_WS4101_g51945.y , _DetailProjectionMode);
				#if defined(TVE_DETAIL_TYPE_VERTEX_BLUE)
				float staticSwitch3467_g51945 = temp_output_3919_0_g51945;
				#elif defined(TVE_DETAIL_TYPE_PROJECTION)
				float staticSwitch3467_g51945 = ( ( lerpResult1537_g51945 * 0.5 ) + _DetailMeshValue );
				#else
				float staticSwitch3467_g51945 = temp_output_3919_0_g51945;
				#endif
				half Blend_Source1540_g51945 = staticSwitch3467_g51945;
				float4 tex2DNode35_g51945 = SAMPLE_TEXTURE2D( _MainMaskTex, sampler_MainAlbedoTex, Main_UVs15_g51945 );
				half Main_Mask57_g51945 = tex2DNode35_g51945.b;
				float4 tex2DNode33_g51945 = SAMPLE_TEXTURE2D( _SecondMaskTex, sampler_SecondMaskTex, Second_UVs17_g51945 );
				half Second_Mask81_g51945 = tex2DNode33_g51945.b;
				float lerpResult1327_g51945 = lerp( Main_Mask57_g51945 , Second_Mask81_g51945 , _DetailMaskMode);
				float lerpResult4058_g51945 = lerp( lerpResult1327_g51945 , ( 1.0 - lerpResult1327_g51945 ) , _DetailMaskInvertMode);
				float temp_output_7_0_g52238 = _DetailBlendMinValue;
				half Mask_Detail147_g51945 = saturate( ( ( saturate( ( Blend_Source1540_g51945 + ( Blend_Source1540_g51945 * lerpResult4058_g51945 ) ) ) - temp_output_7_0_g52238 ) / ( _DetailBlendMaxValue - temp_output_7_0_g52238 ) ) );
				float3 lerpResult235_g51945 = lerp( Main_Albedo99_g51945 , ( Main_Albedo99_g51945 * Second_Albedo153_g51945 * staticSwitch1_g52209 ) , Mask_Detail147_g51945);
				float3 lerpResult208_g51945 = lerp( Main_Albedo99_g51945 , Second_Albedo153_g51945 , Mask_Detail147_g51945);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float3 staticSwitch4062_g51945 = lerpResult235_g51945;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float3 staticSwitch4062_g51945 = lerpResult208_g51945;
				#else
				float3 staticSwitch4062_g51945 = lerpResult235_g51945;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float3 staticSwitch255_g51945 = Main_Albedo99_g51945;
				#elif defined(TVE_DETAIL_MODE_ON)
				float3 staticSwitch255_g51945 = staticSwitch4062_g51945;
				#else
				float3 staticSwitch255_g51945 = Main_Albedo99_g51945;
				#endif
				half3 Blend_Albedo265_g51945 = staticSwitch255_g51945;
				half3 Blend_AlbedoTinted2808_g51945 = ( float3(1,1,1) * float3(1,1,1) * float3(1,1,1) * Blend_Albedo265_g51945 );
				half3 Blend_AlbedoColored863_g51945 = Blend_AlbedoTinted2808_g51945;
				half3 Blend_AlbedoAndSubsurface149_g51945 = Blend_AlbedoColored863_g51945;
				half3 Global_OverlayColor1758_g51945 = (TVE_OverlayColor).rgb;
				float lerpResult3567_g51945 = lerp( _OverlayBottomValue , 1.0 , Main_Normal_WS4101_g51945.y);
				half Main_AlbedoTex_G3526_g51945 = tex2DNode29_g51945.g;
				half Second_AlbedoTex_G3581_g51945 = (SAMPLE_TEXTURE2D( _SecondAlbedoTex, sampler_SecondMaskTex, Second_UVs17_g51945 )).g;
				float lerpResult3579_g51945 = lerp( Main_AlbedoTex_G3526_g51945 , Second_AlbedoTex_G3581_g51945 , Mask_Detail147_g51945);
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch3574_g51945 = Main_AlbedoTex_G3526_g51945;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch3574_g51945 = lerpResult3579_g51945;
				#else
				float staticSwitch3574_g51945 = Main_AlbedoTex_G3526_g51945;
				#endif
				float3 vertexToFrag3890_g51945 = IN.ase_texcoord6.xyz;
				float3 PositionWS_PerVertex3905_g51945 = vertexToFrag3890_g51945;
				float3 Position82_g52261 = PositionWS_PerVertex3905_g51945;
				float temp_output_84_0_g52261 = _LayerExtrasValue;
				float4 lerpResult88_g52261 = lerp( TVE_ExtrasParams , SAMPLE_TEXTURE2D_ARRAY( TVE_ExtrasTex, samplerTVE_ExtrasTex, ( (TVE_ExtrasCoord).zw + ( (TVE_ExtrasCoord).xy * (Position82_g52261).xz ) ),temp_output_84_0_g52261 ) , TVE_ExtrasUsage[(int)temp_output_84_0_g52261]);
				float4 break89_g52261 = lerpResult88_g52261;
				half Global_Extras_Overlay156_g51945 = break89_g52261.b;
				float temp_output_1025_0_g51945 = ( _GlobalOverlay * Global_Extras_Overlay156_g51945 );
				half Overlay_Commons1365_g51945 = temp_output_1025_0_g51945;
				float temp_output_7_0_g52234 = _OverlayMaskMinValue;
				half Overlay_Mask269_g51945 = saturate( ( ( ( ( ( lerpResult3567_g51945 * 0.5 ) + staticSwitch3574_g51945 ) * Overlay_Commons1365_g51945 ) - temp_output_7_0_g52234 ) / ( _OverlayMaskMaxValue - temp_output_7_0_g52234 ) ) );
				float3 lerpResult336_g51945 = lerp( Blend_AlbedoAndSubsurface149_g51945 , Global_OverlayColor1758_g51945 , Overlay_Mask269_g51945);
				half3 Final_Albedo359_g51945 = lerpResult336_g51945;
				
				float localCustomAlphaClip3735_g51945 = ( 0.0 );
				half Final_AlphaFade3727_g51945 = 1.0;
				float Main_Alpha316_g51945 = ( _MainColor.a * tex2DNode29_g51945.a );
				half AlphaTreshold2132_g51945 = _Cutoff;
				#ifdef TVE_ALPHA_CLIP
				float staticSwitch3792_g51945 = ( Main_Alpha316_g51945 - ( AlphaTreshold2132_g51945 - 0.5 ) );
				#else
				float staticSwitch3792_g51945 = Main_Alpha316_g51945;
				#endif
				half Final_Alpha3754_g51945 = staticSwitch3792_g51945;
				float temp_output_661_0_g51945 = ( Final_AlphaFade3727_g51945 * Final_Alpha3754_g51945 );
				float Alpha3735_g51945 = temp_output_661_0_g51945;
				float Treshold3735_g51945 = 0.5;
				{
				#if TVE_ALPHA_CLIP
				clip(Alpha3735_g51945 - Treshold3735_g51945);
				#endif
				}
				half Final_Clip914_g51945 = saturate( Alpha3735_g51945 );
				
				
				float3 Albedo = Final_Albedo359_g51945;
				float Alpha = Final_Clip914_g51945;
				float AlphaClipThreshold = 0.5;

				half4 color = half4( Albedo, Alpha );

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				return color;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthNormals"
			Tags { "LightMode"="DepthNormals" }

			ZWrite On
			Blend One Zero
            ZTest LEqual
            ZWrite On

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 100202
			#define ASE_USING_SAMPLING_MACROS 1

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_DEPTHNORMALSONLY

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#pragma shader_feature_local TVE_ALPHA_CLIP
			//TVE Shader Type Defines
			#define TVE_IS_OBJECT_SHADER
			//TVE Pipeline Defines
			#define THE_VEGETATION_ENGINE
			#define IS_UNIVERSAL_PIPELINE
			//TVE Batching Support Defines
			#define TVE_VERTEX_DATA_BATCHED
			//TVE Injection Defines
			//SHADER INJECTION POINT BEGIN
           //1msRenderVegetation (Instanced Indirect)
           #include "Assets/BasicRenderingFramework/shaders/1msRenderVegetation_Include.cginc"
           #pragma instancing_options procedural:setup forwardadd
           #pragma multi_compile GPU_FRUSTUM_ON __
			//SHADER INJECTION POINT END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float3 worldNormal : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _NoiseMaskRemap;
			half4 _MainUVs;
			half4 _EmissiveColor;
			float4 _SubsurfaceDiffusion_Asset;
			half4 _ColorsMaskRemap;
			half4 _SubsurfaceMaskRemap;
			float4 _GradientMaskRemap;
			half4 _OverlayMaskRemap;
			float4 _MaxBoundsInfo;
			half4 _EmissiveUVs;
			half4 _VertexOcclusionRemap;
			half4 _DetailBlendRemap;
			half4 _SecondColor;
			half4 _SecondUVs;
			float4 _Color;
			float4 _SubsurfaceDiffusion_asset;
			half4 _MainColor;
			half3 _render_normals_options;
			half _DetailCoordMode;
			half _DetailMeshValue;
			half _render_cull;
			half _RenderMode;
			half _SizeFadeCat;
			half _RenderDecals;
			half _RenderZWrite;
			half _TranslucencyShadowValue;
			half _RenderSSR;
			float _SubsurfaceDiffusion;
			half _EmissiveFlagMode;
			half _MainNormalValue;
			half _OverlayBottomValue;
			half _DetailMaskMode;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half _SecondMetallicValue;
			half _MainMetallicValue;
			half _GlobalEmissive;
			half _DetailNormalValue;
			half _DetailProjectionMode;
			half _SecondNormalValue;
			half _OverlayMaskMinValue;
			half _LayerExtrasValue;
			half _GlobalOverlay;
			half _MotionSpace;
			half _DetailBlendMaxValue;
			half _DetailBlendMinValue;
			half _DetailMaskInvertMode;
			half _OverlayMaskMaxValue;
			half _RenderCull;
			half _GlobalCat;
			half _VertexVariationMode;
			half _DetailBlendMode;
			half _LayersSpace;
			half _Cutoff;
			half _MainCat;
			half _DetailMode;
			half _SubsurfaceCat;
			half _RenderNormals;
			half _VariationGlobalsMessage;
			half _MotionCat;
			half _OcclusionCat;
			half _SizeFadeMessage;
			half _TranslucencyHDMessage;
			half _render_src;
			half _IsStandardShader;
			half _render_zw;
			half _IsPropShader;
			half _render_dst;
			half _ReceiveSpace;
			half _PerspectiveCat;
			half _EmissiveCat;
			half _RenderPriority;
			half _GradientCat;
			half _TranslucencyDirectValue;
			half _FadeSpace;
			half _MainOcclusionValue;
			half _IsTVEShader;
			half _DetailSpace;
			half _DetailTypeMode;
			half _DetailCat;
			half _TranslucencyScatteringValue;
			half _TranslucencyNormalValue;
			half _RenderClip;
			half _IsVersion;
			half _RenderingCat;
			half _VertexMasksMode;
			half _VariationMotionMessage;
			half _TranslucencyAmbientValue;
			half _NoiseCat;
			half _TranslucencyIntensityValue;
			half _SecondOcclusionValue;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			TEXTURE2D(_BumpMap);
			SAMPLER(sampler_BumpMap);
			TEXTURE2D(_MainTex);
			SAMPLER(sampler_MainTex);
			TEXTURE2D(_MainAlbedoTex);
			SAMPLER(sampler_MainAlbedoTex);


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 vertexToFrag11_g52308 = ( ( v.ase_texcoord.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				o.ase_texcoord3.xy = vertexToFrag11_g52308;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 normalWS = TransformObjectToWorldNormal( v.ase_normal );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				o.worldNormal = normalWS;

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				o.clipPos = positionCS;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual  
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif
			half4 frag(	VertexOutput IN 
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float localCustomAlphaClip3735_g51945 = ( 0.0 );
				half Final_AlphaFade3727_g51945 = 1.0;
				float2 vertexToFrag11_g52308 = IN.ase_texcoord3.xy;
				half2 Main_UVs15_g51945 = vertexToFrag11_g52308;
				float4 tex2DNode29_g51945 = SAMPLE_TEXTURE2D( _MainAlbedoTex, sampler_MainAlbedoTex, Main_UVs15_g51945 );
				float Main_Alpha316_g51945 = ( _MainColor.a * tex2DNode29_g51945.a );
				half AlphaTreshold2132_g51945 = _Cutoff;
				#ifdef TVE_ALPHA_CLIP
				float staticSwitch3792_g51945 = ( Main_Alpha316_g51945 - ( AlphaTreshold2132_g51945 - 0.5 ) );
				#else
				float staticSwitch3792_g51945 = Main_Alpha316_g51945;
				#endif
				half Final_Alpha3754_g51945 = staticSwitch3792_g51945;
				float temp_output_661_0_g51945 = ( Final_AlphaFade3727_g51945 * Final_Alpha3754_g51945 );
				float Alpha3735_g51945 = temp_output_661_0_g51945;
				float Treshold3735_g51945 = 0.5;
				{
				#if TVE_ALPHA_CLIP
				clip(Alpha3735_g51945 - Treshold3735_g51945);
				#endif
				}
				half Final_Clip914_g51945 = saturate( Alpha3735_g51945 );
				
				float Alpha = Final_Clip914_g51945;
				float AlphaClipThreshold = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				
				#ifdef ASE_DEPTH_WRITE_ON
				outputDepth = DepthValue;
				#endif
				
				return float4(PackNormalOctRectEncode(TransformWorldToViewDir(IN.worldNormal, true)), 0.0, 0.0);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "GBuffer"
			Tags { "LightMode"="UniversalGBuffer" }
			
			Blend [_render_src] [_render_dst], One Zero
			ZWrite [_render_zw]
			ZTest LEqual
			Offset 0,0
			ColorMask RGBA
			

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 100202
			#define ASE_USING_SAMPLING_MACROS 1

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			#pragma multi_compile _ _GBUFFER_NORMALS_OCT
			
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_GBUFFER

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"

			#if ASE_SRP_VERSION <= 70108
			#define REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
			#endif

			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
			    #define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#pragma shader_feature_local TVE_ALPHA_CLIP
			#pragma shader_feature_local TVE_DETAIL_MODE_OFF TVE_DETAIL_MODE_ON
			#pragma shader_feature_local TVE_DETAIL_BLEND_OVERLAY TVE_DETAIL_BLEND_REPLACE
			#pragma shader_feature_local TVE_DETAIL_TYPE_VERTEX_BLUE TVE_DETAIL_TYPE_PROJECTION
			//TVE Shader Type Defines
			#define TVE_IS_OBJECT_SHADER
			//TVE Pipeline Defines
			#define THE_VEGETATION_ENGINE
			#define IS_UNIVERSAL_PIPELINE
			//TVE Batching Support Defines
			#define TVE_VERTEX_DATA_BATCHED
			//TVE Injection Defines
			//SHADER INJECTION POINT BEGIN
           //1msRenderVegetation (Instanced Indirect)
           #include "Assets/BasicRenderingFramework/shaders/1msRenderVegetation_Include.cginc"
           #pragma instancing_options procedural:setup forwardadd
           #pragma multi_compile GPU_FRUSTUM_ON __
			//SHADER INJECTION POINT END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord : TEXCOORD2;
				#endif
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 screenPos : TEXCOORD6;
				#endif
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_texcoord9 : TEXCOORD9;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _NoiseMaskRemap;
			half4 _MainUVs;
			half4 _EmissiveColor;
			float4 _SubsurfaceDiffusion_Asset;
			half4 _ColorsMaskRemap;
			half4 _SubsurfaceMaskRemap;
			float4 _GradientMaskRemap;
			half4 _OverlayMaskRemap;
			float4 _MaxBoundsInfo;
			half4 _EmissiveUVs;
			half4 _VertexOcclusionRemap;
			half4 _DetailBlendRemap;
			half4 _SecondColor;
			half4 _SecondUVs;
			float4 _Color;
			float4 _SubsurfaceDiffusion_asset;
			half4 _MainColor;
			half3 _render_normals_options;
			half _DetailCoordMode;
			half _DetailMeshValue;
			half _render_cull;
			half _RenderMode;
			half _SizeFadeCat;
			half _RenderDecals;
			half _RenderZWrite;
			half _TranslucencyShadowValue;
			half _RenderSSR;
			float _SubsurfaceDiffusion;
			half _EmissiveFlagMode;
			half _MainNormalValue;
			half _OverlayBottomValue;
			half _DetailMaskMode;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half _SecondMetallicValue;
			half _MainMetallicValue;
			half _GlobalEmissive;
			half _DetailNormalValue;
			half _DetailProjectionMode;
			half _SecondNormalValue;
			half _OverlayMaskMinValue;
			half _LayerExtrasValue;
			half _GlobalOverlay;
			half _MotionSpace;
			half _DetailBlendMaxValue;
			half _DetailBlendMinValue;
			half _DetailMaskInvertMode;
			half _OverlayMaskMaxValue;
			half _RenderCull;
			half _GlobalCat;
			half _VertexVariationMode;
			half _DetailBlendMode;
			half _LayersSpace;
			half _Cutoff;
			half _MainCat;
			half _DetailMode;
			half _SubsurfaceCat;
			half _RenderNormals;
			half _VariationGlobalsMessage;
			half _MotionCat;
			half _OcclusionCat;
			half _SizeFadeMessage;
			half _TranslucencyHDMessage;
			half _render_src;
			half _IsStandardShader;
			half _render_zw;
			half _IsPropShader;
			half _render_dst;
			half _ReceiveSpace;
			half _PerspectiveCat;
			half _EmissiveCat;
			half _RenderPriority;
			half _GradientCat;
			half _TranslucencyDirectValue;
			half _FadeSpace;
			half _MainOcclusionValue;
			half _IsTVEShader;
			half _DetailSpace;
			half _DetailTypeMode;
			half _DetailCat;
			half _TranslucencyScatteringValue;
			half _TranslucencyNormalValue;
			half _RenderClip;
			half _IsVersion;
			half _RenderingCat;
			half _VertexMasksMode;
			half _VariationMotionMessage;
			half _TranslucencyAmbientValue;
			half _NoiseCat;
			half _TranslucencyIntensityValue;
			half _SecondOcclusionValue;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			TEXTURE2D(_BumpMap);
			SAMPLER(sampler_BumpMap);
			TEXTURE2D(_MainTex);
			SAMPLER(sampler_MainTex);
			TEXTURE2D(_MainAlbedoTex);
			SAMPLER(sampler_MainAlbedoTex);
			TEXTURE2D(_SecondAlbedoTex);
			TEXTURE2D(_SecondMaskTex);
			SAMPLER(sampler_SecondMaskTex);
			TEXTURE2D(_MainNormalTex);
			TEXTURE2D(_MainMaskTex);
			half4 TVE_OverlayColor;
			half4 TVE_ExtrasParams;
			TEXTURE2D_ARRAY(TVE_ExtrasTex);
			half4 TVE_ExtrasCoord;
			SAMPLER(samplerTVE_ExtrasTex);
			float TVE_ExtrasUsage[9];
			TEXTURE2D(_EmissiveTex);
			SAMPLER(sampler_EmissiveTex);
			half TVE_OverlaySmoothness;


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 vertexToFrag11_g52308 = ( ( v.texcoord.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				o.ase_texcoord7.xy = vertexToFrag11_g52308;
				float2 lerpResult1545_g51945 = lerp( v.texcoord.xy , v.texcoord1.xyzw.xy , _DetailCoordMode);
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				#if defined(TVE_DETAIL_TYPE_VERTEX_BLUE)
				float2 staticSwitch3466_g51945 = lerpResult1545_g51945;
				#elif defined(TVE_DETAIL_TYPE_PROJECTION)
				float2 staticSwitch3466_g51945 = (ase_worldPos).xz;
				#else
				float2 staticSwitch3466_g51945 = lerpResult1545_g51945;
				#endif
				float2 vertexToFrag11_g52243 = ( ( staticSwitch3466_g51945 * (_SecondUVs).xy ) + (_SecondUVs).zw );
				o.ase_texcoord7.zw = vertexToFrag11_g52243;
				half Mesh_DetailMask90_g51945 = v.ase_color.b;
				float vertexToFrag11_g52208 = ( ( Mesh_DetailMask90_g51945 - 0.5 ) + _DetailMeshValue );
				o.ase_texcoord8.x = vertexToFrag11_g52208;
				float3 vertexToFrag3890_g51945 = ase_worldPos;
				o.ase_texcoord8.yzw = vertexToFrag3890_g51945;
				
				float2 vertexToFrag11_g52248 = ( ( v.texcoord.xy * (_EmissiveUVs).xy ) + (_EmissiveUVs).zw );
				o.ase_texcoord9.xy = vertexToFrag11_g52248;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord9.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				OUTPUT_SH( normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz );

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord;
					o.lightmapUVOrVertexSH.xy = v.texcoord * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );
				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( positionCS.z );
				#else
					half fogFactor = 0;
				#endif
				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
				
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				
				o.clipPos = positionCS;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				o.screenPos = ComputeScreenPos(positionCS);
				#endif
				return o;
			}
			
			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual  
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif
			FragmentOutput frag ( VertexOutput IN 
								#ifdef ASE_DEPTH_WRITE_ON
								,out float outputDepth : ASE_SV_DEPTH
								#endif
								 )
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif
				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 ScreenPos = IN.screenPos;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#endif
	
				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float2 vertexToFrag11_g52308 = IN.ase_texcoord7.xy;
				half2 Main_UVs15_g51945 = vertexToFrag11_g52308;
				float4 tex2DNode29_g51945 = SAMPLE_TEXTURE2D( _MainAlbedoTex, sampler_MainAlbedoTex, Main_UVs15_g51945 );
				float3 temp_output_51_0_g51945 = ( (_MainColor).rgb * (tex2DNode29_g51945).rgb );
				half3 Main_Albedo99_g51945 = temp_output_51_0_g51945;
				float2 vertexToFrag11_g52243 = IN.ase_texcoord7.zw;
				half2 Second_UVs17_g51945 = vertexToFrag11_g52243;
				half3 Second_Albedo153_g51945 = (( _SecondColor * SAMPLE_TEXTURE2D( _SecondAlbedoTex, sampler_SecondMaskTex, Second_UVs17_g51945 ) )).rgb;
				#ifdef UNITY_COLORSPACE_GAMMA
				float staticSwitch1_g52209 = 2.0;
				#else
				float staticSwitch1_g52209 = 4.594794;
				#endif
				float vertexToFrag11_g52208 = IN.ase_texcoord8.x;
				float temp_output_3919_0_g51945 = vertexToFrag11_g52208;
				float3 unpack4112_g51945 = UnpackNormalScale( SAMPLE_TEXTURE2D( _MainNormalTex, sampler_MainAlbedoTex, Main_UVs15_g51945 ), _MainNormalValue );
				unpack4112_g51945.z = lerp( 1, unpack4112_g51945.z, saturate(_MainNormalValue) );
				half3 Main_Normal137_g51945 = unpack4112_g51945;
				float3 tanToWorld0 = float3( WorldTangent.x, WorldBiTangent.x, WorldNormal.x );
				float3 tanToWorld1 = float3( WorldTangent.y, WorldBiTangent.y, WorldNormal.y );
				float3 tanToWorld2 = float3( WorldTangent.z, WorldBiTangent.z, WorldNormal.z );
				float3 tanNormal4099_g51945 = Main_Normal137_g51945;
				float3 worldNormal4099_g51945 = float3(dot(tanToWorld0,tanNormal4099_g51945), dot(tanToWorld1,tanNormal4099_g51945), dot(tanToWorld2,tanNormal4099_g51945));
				float3 Main_Normal_WS4101_g51945 = worldNormal4099_g51945;
				float lerpResult1537_g51945 = lerp( Main_Normal_WS4101_g51945.y , -Main_Normal_WS4101_g51945.y , _DetailProjectionMode);
				#if defined(TVE_DETAIL_TYPE_VERTEX_BLUE)
				float staticSwitch3467_g51945 = temp_output_3919_0_g51945;
				#elif defined(TVE_DETAIL_TYPE_PROJECTION)
				float staticSwitch3467_g51945 = ( ( lerpResult1537_g51945 * 0.5 ) + _DetailMeshValue );
				#else
				float staticSwitch3467_g51945 = temp_output_3919_0_g51945;
				#endif
				half Blend_Source1540_g51945 = staticSwitch3467_g51945;
				float4 tex2DNode35_g51945 = SAMPLE_TEXTURE2D( _MainMaskTex, sampler_MainAlbedoTex, Main_UVs15_g51945 );
				half Main_Mask57_g51945 = tex2DNode35_g51945.b;
				float4 tex2DNode33_g51945 = SAMPLE_TEXTURE2D( _SecondMaskTex, sampler_SecondMaskTex, Second_UVs17_g51945 );
				half Second_Mask81_g51945 = tex2DNode33_g51945.b;
				float lerpResult1327_g51945 = lerp( Main_Mask57_g51945 , Second_Mask81_g51945 , _DetailMaskMode);
				float lerpResult4058_g51945 = lerp( lerpResult1327_g51945 , ( 1.0 - lerpResult1327_g51945 ) , _DetailMaskInvertMode);
				float temp_output_7_0_g52238 = _DetailBlendMinValue;
				half Mask_Detail147_g51945 = saturate( ( ( saturate( ( Blend_Source1540_g51945 + ( Blend_Source1540_g51945 * lerpResult4058_g51945 ) ) ) - temp_output_7_0_g52238 ) / ( _DetailBlendMaxValue - temp_output_7_0_g52238 ) ) );
				float3 lerpResult235_g51945 = lerp( Main_Albedo99_g51945 , ( Main_Albedo99_g51945 * Second_Albedo153_g51945 * staticSwitch1_g52209 ) , Mask_Detail147_g51945);
				float3 lerpResult208_g51945 = lerp( Main_Albedo99_g51945 , Second_Albedo153_g51945 , Mask_Detail147_g51945);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float3 staticSwitch4062_g51945 = lerpResult235_g51945;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float3 staticSwitch4062_g51945 = lerpResult208_g51945;
				#else
				float3 staticSwitch4062_g51945 = lerpResult235_g51945;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float3 staticSwitch255_g51945 = Main_Albedo99_g51945;
				#elif defined(TVE_DETAIL_MODE_ON)
				float3 staticSwitch255_g51945 = staticSwitch4062_g51945;
				#else
				float3 staticSwitch255_g51945 = Main_Albedo99_g51945;
				#endif
				half3 Blend_Albedo265_g51945 = staticSwitch255_g51945;
				half3 Blend_AlbedoTinted2808_g51945 = ( float3(1,1,1) * float3(1,1,1) * float3(1,1,1) * Blend_Albedo265_g51945 );
				half3 Blend_AlbedoColored863_g51945 = Blend_AlbedoTinted2808_g51945;
				half3 Blend_AlbedoAndSubsurface149_g51945 = Blend_AlbedoColored863_g51945;
				half3 Global_OverlayColor1758_g51945 = (TVE_OverlayColor).rgb;
				float lerpResult3567_g51945 = lerp( _OverlayBottomValue , 1.0 , Main_Normal_WS4101_g51945.y);
				half Main_AlbedoTex_G3526_g51945 = tex2DNode29_g51945.g;
				half Second_AlbedoTex_G3581_g51945 = (SAMPLE_TEXTURE2D( _SecondAlbedoTex, sampler_SecondMaskTex, Second_UVs17_g51945 )).g;
				float lerpResult3579_g51945 = lerp( Main_AlbedoTex_G3526_g51945 , Second_AlbedoTex_G3581_g51945 , Mask_Detail147_g51945);
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch3574_g51945 = Main_AlbedoTex_G3526_g51945;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch3574_g51945 = lerpResult3579_g51945;
				#else
				float staticSwitch3574_g51945 = Main_AlbedoTex_G3526_g51945;
				#endif
				float3 vertexToFrag3890_g51945 = IN.ase_texcoord8.yzw;
				float3 PositionWS_PerVertex3905_g51945 = vertexToFrag3890_g51945;
				float3 Position82_g52261 = PositionWS_PerVertex3905_g51945;
				float temp_output_84_0_g52261 = _LayerExtrasValue;
				float4 lerpResult88_g52261 = lerp( TVE_ExtrasParams , SAMPLE_TEXTURE2D_ARRAY( TVE_ExtrasTex, samplerTVE_ExtrasTex, ( (TVE_ExtrasCoord).zw + ( (TVE_ExtrasCoord).xy * (Position82_g52261).xz ) ),temp_output_84_0_g52261 ) , TVE_ExtrasUsage[(int)temp_output_84_0_g52261]);
				float4 break89_g52261 = lerpResult88_g52261;
				half Global_Extras_Overlay156_g51945 = break89_g52261.b;
				float temp_output_1025_0_g51945 = ( _GlobalOverlay * Global_Extras_Overlay156_g51945 );
				half Overlay_Commons1365_g51945 = temp_output_1025_0_g51945;
				float temp_output_7_0_g52234 = _OverlayMaskMinValue;
				half Overlay_Mask269_g51945 = saturate( ( ( ( ( ( lerpResult3567_g51945 * 0.5 ) + staticSwitch3574_g51945 ) * Overlay_Commons1365_g51945 ) - temp_output_7_0_g52234 ) / ( _OverlayMaskMaxValue - temp_output_7_0_g52234 ) ) );
				float3 lerpResult336_g51945 = lerp( Blend_AlbedoAndSubsurface149_g51945 , Global_OverlayColor1758_g51945 , Overlay_Mask269_g51945);
				half3 Final_Albedo359_g51945 = lerpResult336_g51945;
				
				float2 vertexToFrag11_g52248 = IN.ase_texcoord9.xy;
				half2 Emissive_UVs2468_g51945 = vertexToFrag11_g52248;
				half Global_Extras_Emissive4203_g51945 = break89_g52261.r;
				float lerpResult4206_g51945 = lerp( 1.0 , Global_Extras_Emissive4203_g51945 , _GlobalEmissive);
				half3 Final_Emissive2476_g51945 = ( (( _EmissiveColor * SAMPLE_TEXTURE2D( _EmissiveTex, sampler_EmissiveTex, Emissive_UVs2468_g51945 ) )).rgb * lerpResult4206_g51945 );
				
				half Main_Metallic237_g51945 = ( tex2DNode35_g51945.r * _MainMetallicValue );
				half Second_Metallic226_g51945 = ( tex2DNode33_g51945.r * _SecondMetallicValue );
				float lerpResult278_g51945 = lerp( Main_Metallic237_g51945 , Second_Metallic226_g51945 , Mask_Detail147_g51945);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float staticSwitch4064_g51945 = Main_Metallic237_g51945;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float staticSwitch4064_g51945 = lerpResult278_g51945;
				#else
				float staticSwitch4064_g51945 = Main_Metallic237_g51945;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch299_g51945 = Main_Metallic237_g51945;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch299_g51945 = staticSwitch4064_g51945;
				#else
				float staticSwitch299_g51945 = Main_Metallic237_g51945;
				#endif
				half Blend_Metallic306_g51945 = staticSwitch299_g51945;
				float lerpResult342_g51945 = lerp( Blend_Metallic306_g51945 , 0.0 , Overlay_Mask269_g51945);
				half Final_Metallic367_g51945 = lerpResult342_g51945;
				
				half Main_Smoothness227_g51945 = ( tex2DNode35_g51945.a * _MainSmoothnessValue );
				half Second_Smoothness236_g51945 = ( tex2DNode33_g51945.a * _SecondSmoothnessValue );
				float lerpResult266_g51945 = lerp( Main_Smoothness227_g51945 , Second_Smoothness236_g51945 , Mask_Detail147_g51945);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float staticSwitch4065_g51945 = Main_Smoothness227_g51945;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float staticSwitch4065_g51945 = lerpResult266_g51945;
				#else
				float staticSwitch4065_g51945 = Main_Smoothness227_g51945;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch297_g51945 = Main_Smoothness227_g51945;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch297_g51945 = staticSwitch4065_g51945;
				#else
				float staticSwitch297_g51945 = Main_Smoothness227_g51945;
				#endif
				half Blend_Smoothness314_g51945 = staticSwitch297_g51945;
				half Global_OverlaySmoothness311_g51945 = TVE_OverlaySmoothness;
				float lerpResult343_g51945 = lerp( Blend_Smoothness314_g51945 , Global_OverlaySmoothness311_g51945 , Overlay_Mask269_g51945);
				half Final_Smoothness371_g51945 = lerpResult343_g51945;
				half Global_Extras_Wetness305_g51945 = break89_g52261.g;
				float lerpResult3673_g51945 = lerp( 0.0 , Global_Extras_Wetness305_g51945 , _GlobalWetness);
				half Final_SmoothnessAndWetness4130_g51945 = saturate( ( Final_Smoothness371_g51945 + lerpResult3673_g51945 ) );
				
				float lerpResult240_g51945 = lerp( 1.0 , tex2DNode35_g51945.g , _MainOcclusionValue);
				half Main_Occlusion247_g51945 = lerpResult240_g51945;
				float lerpResult239_g51945 = lerp( 1.0 , tex2DNode33_g51945.g , _SecondOcclusionValue);
				half Second_Occlusion251_g51945 = lerpResult239_g51945;
				float lerpResult294_g51945 = lerp( Main_Occlusion247_g51945 , Second_Occlusion251_g51945 , Mask_Detail147_g51945);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float staticSwitch4066_g51945 = Main_Occlusion247_g51945;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float staticSwitch4066_g51945 = lerpResult294_g51945;
				#else
				float staticSwitch4066_g51945 = Main_Occlusion247_g51945;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch310_g51945 = Main_Occlusion247_g51945;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch310_g51945 = staticSwitch4066_g51945;
				#else
				float staticSwitch310_g51945 = Main_Occlusion247_g51945;
				#endif
				half Blend_Occlusion323_g51945 = staticSwitch310_g51945;
				
				float localCustomAlphaClip3735_g51945 = ( 0.0 );
				half Final_AlphaFade3727_g51945 = 1.0;
				float Main_Alpha316_g51945 = ( _MainColor.a * tex2DNode29_g51945.a );
				half AlphaTreshold2132_g51945 = _Cutoff;
				#ifdef TVE_ALPHA_CLIP
				float staticSwitch3792_g51945 = ( Main_Alpha316_g51945 - ( AlphaTreshold2132_g51945 - 0.5 ) );
				#else
				float staticSwitch3792_g51945 = Main_Alpha316_g51945;
				#endif
				half Final_Alpha3754_g51945 = staticSwitch3792_g51945;
				float temp_output_661_0_g51945 = ( Final_AlphaFade3727_g51945 * Final_Alpha3754_g51945 );
				float Alpha3735_g51945 = temp_output_661_0_g51945;
				float Treshold3735_g51945 = 0.5;
				{
				#if TVE_ALPHA_CLIP
				clip(Alpha3735_g51945 - Treshold3735_g51945);
				#endif
				}
				half Final_Clip914_g51945 = saturate( Alpha3735_g51945 );
				
				float3 Albedo = Final_Albedo359_g51945;
				float3 Normal = float3(0, 0, 1);
				float3 Emission = Final_Emissive2476_g51945;
				float3 Specular = 0.5;
				float Metallic = Final_Metallic367_g51945;
				float Smoothness = Final_SmoothnessAndWetness4130_g51945;
				float Occlusion = Blend_Occlusion323_g51945;
				float Alpha = Final_Clip914_g51945;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData;
				inputData.positionWS = WorldPosition;
				inputData.viewDirectionWS = WorldViewDirection;
				inputData.shadowCoord = ShadowCoords;

				#ifdef _NORMALMAP
					#if _NORMAL_DROPOFF_TS
					inputData.normalWS = TransformTangentToWorld(Normal, half3x3( WorldTangent, WorldBiTangent, WorldNormal ));
					#elif _NORMAL_DROPOFF_OS
					inputData.normalWS = TransformObjectToWorldNormal(Normal);
					#elif _NORMAL_DROPOFF_WS
					inputData.normalWS = Normal;
					#endif
					inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				#else
					inputData.normalWS = WorldNormal;
				#endif

				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;
				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS );
				#ifdef _ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif

				BRDFData brdfData;
				InitializeBRDFData( Albedo, Metallic, Specular, Smoothness, Alpha, brdfData);
				half4 color;
				color.rgb = GlobalIllumination( brdfData, inputData.bakedGI, Occlusion, inputData.normalWS, inputData.viewDirectionWS);
				color.a = Alpha;
			
				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif
				
				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif
				
				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif
				
				return BRDFDataToGbuffer(brdfData, inputData, Smoothness, Emission + color.rgb);
			}

			ENDHLSL
		}
		
	}
	/*ase_lod*/
	CustomEditor "TVEShaderCoreGUI"
	Fallback "Hidden/BOXOPHOBIC/The Vegetation Engine/Fallback"
	
}
/*ASEBEGIN
Version=18910
1920;0;1920;1029;2728.772;828.158;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;10;-2176,-768;Half;False;Property;_render_cull;_render_cull;213;1;[HideInInspector];Create;True;0;3;Both;0;Back;1;Front;2;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;398;-1344,-896;Inherit;False;Compile All Shaders;-1;;51944;e67c8238031dbf04ab79a5d4d63d1b4f;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1984,-768;Half;False;Property;_render_src;_render_src;214;1;[HideInInspector];Create;True;0;0;0;True;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-1984,-896;Half;False;Property;_IsStandardShader;_IsStandardShader;212;1;[HideInInspector];Create;True;0;0;0;True;0;False;1;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1600,-768;Half;False;Property;_render_zw;_render_zw;216;1;[HideInInspector];Create;True;0;2;Opaque;0;Transparent;1;0;True;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;341;-2176,384;Inherit;False;Define TVE VERTEX DATA BATCHED;-1;;51943;749c61e1189c7f8408d9e6db94560d1d;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;382;-2176,-384;Inherit;False;Base Shader;0;;51945;856f7164d1c579d43a5cf4968a75ca43;80,3882,1,3880,1,3957,0,4028,1,4029,1,3900,1,3903,1,3904,1,4204,1,3908,1,4172,1,1300,1,1298,1,4179,1,3586,0,1271,0,3889,1,3658,0,1708,0,3509,1,1712,0,3873,1,1715,1,1714,1,1717,1,1718,1,916,1,1763,0,1762,0,3568,1,1949,1,1776,0,3475,1,4210,1,893,0,1745,0,3479,0,3501,0,3221,2,1646,0,1757,0,2807,0,3886,0,2953,0,3887,0,3243,0,3888,0,3728,0,3949,0,2172,0,3883,0,2658,0,1742,0,3484,0,1735,1,1736,1,1733,1,1737,1,1734,1,3575,1,878,1,1550,1,4067,0,4068,0,4072,0,4070,0,4069,0,860,0,3544,1,2261,1,2260,1,2032,1,2054,1,2060,1,2036,1,2062,1,2039,1,4177,1,3592,1,2750,0;0;19;FLOAT3;0;FLOAT3;528;FLOAT3;2489;FLOAT;531;FLOAT;4135;FLOAT;529;FLOAT;3678;FLOAT;530;FLOAT;4127;FLOAT;4122;FLOAT;4134;FLOAT;1235;FLOAT3;1230;FLOAT;1461;FLOAT;1290;FLOAT;721;FLOAT;532;FLOAT;629;FLOAT3;534
Node;AmplifyShaderEditor.RangedFloatNode;127;-2176,-896;Half;False;Property;_IsPropShader;_IsPropShader;211;1;[HideInInspector];Create;True;0;0;0;True;0;False;1;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;397;-1568,384;Inherit;False;Define PIPELINE UNIVERSAL;-1;;51941;71dc7add32e5f6247b1fb74ecceddd3e;0;0;1;FLOAT;529
Node;AmplifyShaderEditor.FunctionNode;343;-1856,384;Inherit;False;Define TVE IS OBJECT SHADER;-1;;51940;1237b3cc9fbfe714d8343c91216dc9b4;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1792,-768;Half;False;Property;_render_dst;_render_dst;215;1;[HideInInspector];Create;True;0;2;Opaque;0;Transparent;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;399;-1536,-896;Inherit;False;Compile Core;-1;;51942;634b02fd1f32e6a4c875d8fc2c450956;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;389;-1376,-384;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;28cd5599e02859647ae1798e4fcaef6c;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;392;-1376,-384;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;28cd5599e02859647ae1798e4fcaef6c;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;True;False;False;False;False;0;False;-1;False;False;False;False;False;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;391;-1376,-384;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;28cd5599e02859647ae1798e4fcaef6c;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;390;-1376,-384;Float;False;True;-1;2;TVEShaderCoreGUI;0;18;BOXOPHOBIC/The Vegetation Engine/Objects/Prop Standard Lit;28cd5599e02859647ae1798e4fcaef6c;True;Forward;0;1;Forward;18;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;2;True;10;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;4;0;True;True;1;1;True;20;0;True;7;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;1;True;17;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/BOXOPHOBIC/The Vegetation Engine/Fallback;0;0;Standard;38;Workflow;1;Surface;0;  Refraction Model;0;  Blend;0;Two Sided;0;Fragment Normal Space,InvertActionOnDeselection;0;Transmission;0;  Transmission Shadow;0.5,True,1013;Translucency;0;  Translucency Strength;1,False,-1;  Normal Distortion;0.5,False,-1;  Scattering;2,False,-1;  Direct;0.9,False,-1;  Ambient;0.1,False,-1;  Shadow;0.5,False,-1;Cast Shadows;1;  Use Shadow Threshold;0;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;1;Built-in Fog;1;_FinalColorxAlpha;0;Meta Pass;1;Override Baked GI;0;Extra Pre Pass;0;DOTS Instancing;1;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;0;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Write Depth;0;  Early Z;0;Vertex Position,InvertActionOnDeselection;1;0;8;False;True;True;True;True;True;True;True;False;;True;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;394;-1376,-384;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;28cd5599e02859647ae1798e4fcaef6c;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;True;1;1;True;20;0;True;7;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;1;True;17;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;1;LightMode=Universal2D;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;393;-1376,-384;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;28cd5599e02859647ae1798e4fcaef6c;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;401;-1376,-384;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;28cd5599e02859647ae1798e4fcaef6c;True;GBuffer;0;7;GBuffer;1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;True;1;1;True;20;0;True;7;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;True;17;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;1;LightMode=UniversalGBuffer;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;400;-1376,-324;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;28cd5599e02859647ae1798e4fcaef6c;True;DepthNormals;0;6;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=DepthNormals;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.CommentaryNode;37;-2176,-1024;Inherit;False;1026.438;100;Internal;0;;1,0.252,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;340;-2176,256;Inherit;False;1026.438;100;Features;0;;0,1,0.5,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;33;-2176,-512;Inherit;False;1022.896;100;Final;0;;0,1,0.5,1;0;0
WireConnection;390;0;382;0
WireConnection;390;1;382;528
WireConnection;390;2;382;2489
WireConnection;390;3;382;529
WireConnection;390;4;382;530
WireConnection;390;5;382;531
WireConnection;390;6;382;532
ASEEND*/
//CHKSM=9CAC14C036720366FC3E3B9CF73743E522F5EDA0
