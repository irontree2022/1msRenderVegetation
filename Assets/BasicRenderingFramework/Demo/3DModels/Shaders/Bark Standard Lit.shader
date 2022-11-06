// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BOXOPHOBIC/The Vegetation Engine/Vegetation/Bark Standard Lit"
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
		[Enum(Off,0,On,1)]_RenderSpecular("Receive Specular", Float) = 1
		[Enum(Off,0,On,1)]_RenderDecals("Receive Decals", Float) = 1
		[Enum(Off,0,On,1)]_RenderSSR("Receive SSR/SSGI", Float) = 1
		[Enum(Off,0,On,1)][Space(10)]_RenderClip("Alpha Clipping", Float) = 1
		_Cutoff("Alpha Treshold", Range( 0 , 1)) = 0.5
		[StyledSpace(10)]_FadeSpace("# Fade Space", Float) = 0
		_FadeCameraValue("Fade by Camera Distance", Range( 0 , 1)) = 1
		[StyledCategory(Global Settings)]_GlobalCat("[ Global Cat ]", Float) = 0
		[StyledEnum(Default _Layer 1 _Layer 2 _Layer 3 _Layer 4 _Layer 5 _Layer 6 _Layer 7 _Layer 8)]_LayerExtrasValue("Layer Extras", Float) = 0
		[StyledEnum(Default _Layer 1 _Layer 2 _Layer 3 _Layer 4 _Layer 5 _Layer 6 _Layer 7 _Layer 8)]_LayerMotionValue("Layer Motion", Float) = 0
		[StyledEnum(Default _Layer 1 _Layer 2 _Layer 3 _Layer 4 _Layer 5 _Layer 6 _Layer 7 _Layer 8)]_LayerReactValue("Layer React", Float) = 0
		[StyledSpace(10)]_LayersSpace("# Layers Space", Float) = 0
		[StyledMessage(Info, Procedural Variation in use. The Variation might not work as expected when switching from one LOD to another., _VertexVariationMode, 1 , 0, 10)]_VariationGlobalsMessage("# Variation Globals Message", Float) = 0
		_GlobalOverlay("Global Overlay", Range( 0 , 1)) = 1
		_GlobalWetness("Global Wetness", Range( 0 , 1)) = 1
		_GlobalEmissive("Global Emissive", Range( 0 , 1)) = 1
		_GlobalSize("Global Size", Range( 0 , 1)) = 1
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
		_MainOcclusionValue("Main Occlusion", Range( 0 , 1)) = 1
		_MainSmoothnessValue("Main Smoothness", Range( 0 , 1)) = 1
		[StyledCategory(Detail Settings)]_DetailCat("[ Detail Cat ]", Float) = 0
		[Enum(Off,0,On,1)]_DetailMode("Detail Mode", Float) = 0
		[Enum(Overlay,0,Replace,1)]_DetailBlendMode("Detail Blend", Float) = 1
		[Enum(Vertex Blue,0,Projection,1)]_DetailTypeMode("Detail Type", Float) = 0
		[StyledSpace(10)]_DetailSpace("# Detail Space", Float) = 0
		[NoScaleOffset][Space(10)][StyledTextureSingleLine]_SecondAlbedoTex("Detail Albedo", 2D) = "white" {}
		[NoScaleOffset][StyledTextureSingleLine]_SecondNormalTex("Detail Normal", 2D) = "bump" {}
		[NoScaleOffset][StyledTextureSingleLine]_SecondMaskTex("Detail Mask", 2D) = "white" {}
		[Space(10)][StyledVector(9)]_SecondUVs("Detail UVs", Vector) = (1,1,0,0)
		[HDR]_SecondColor("Detail Color", Color) = (1,1,1,1)
		_SecondNormalValue("Detail Normal", Range( -8 , 8)) = 1
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
		[HDR]_VertexOcclusionColor("Vertex Occlusion Color", Color) = (1,1,1,1)
		[StyledRemapSlider(_VertexOcclusionMinValue, _VertexOcclusionMaxValue, 0, 1)]_VertexOcclusionRemap("Vertex Occlusion Mask", Vector) = (0,0,0,0)
		[HideInInspector]_VertexOcclusionMinValue("Vertex Occlusion Min Value", Range( 0 , 1)) = 0
		[HideInInspector]_VertexOcclusionMaxValue("Vertex Occlusion Max Value", Range( 0 , 1)) = 1
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
		[StyledSpace(10)]_MotionSpace("# Motion Space", Float) = 0
		_MotionAmplitude_10("Bending Amplitude", Range( 0 , 2)) = 0.05
		[IntRange]_MotionSpeed_10("Bending Speed", Range( 0 , 60)) = 2
		_MotionScale_10("Bending Scale", Range( 0 , 20)) = 0
		_MotionVariation_10("Bending Variation", Range( 0 , 20)) = 0
		[Space(10)]_MotionAmplitude_20("Rolling Amplitude", Range( 0 , 2)) = 0.1
		[IntRange]_MotionSpeed_20("Rolling Speed", Range( 0 , 60)) = 6
		_MotionScale_20("Rolling Scale", Range( 0 , 60)) = 0
		_MotionVariation_20("Rolling Variation", Range( 0 , 60)) = 5
		[Space(10)]_InteractionAmplitude("Interaction Amplitude", Range( 0 , 10)) = 1
		[ASEEnd]_InteractionVariation("Interaction Variation", Range( 0 , 1)) = 0
		[HideInInspector]_VertexRollingMode("Enable Motion Rolling", Float) = 1
		[HideInInspector][StyledToggle]_VertexDataMode("Enable Batching Support", Float) = 0
		[HideInInspector]_IsTVEShader("_IsTVEShader", Float) = 1
		[HideInInspector]_IsVersion("_IsVersion", Float) = 400
		[HideInInspector]_Color("Legacy Color", Color) = (0,0,0,0)
		[HideInInspector]_MainTex("Legacy MainTex", 2D) = "white" {}
		[HideInInspector]_BumpMap("Legacy BumpMap", 2D) = "white" {}
		[HideInInspector]_render_normals_options("_render_normals_options", Vector) = (1,1,1,0)
		[HideInInspector]_vertex_pivot_mode("_vertex_pivot_mode", Float) = 0
		[HideInInspector]_MaxBoundsInfo("_MaxBoundsInfo", Vector) = (1,1,1,1)
		[HideInInspector]_VertexVariationMode("_VertexVariationMode", Float) = 0
		[HideInInspector]_VertexMasksMode("_VertexMasksMode", Float) = 0
		[HideInInspector]_IsBarkShader("_IsBarkShader", Float) = 1
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
			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define ASE_ABSOLUTE_VERTEX_POS 1
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

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#pragma shader_feature_local TVE_ALPHA_CLIP
			#pragma shader_feature_local TVE_VERTEX_DATA_BATCHED
			#pragma shader_feature_local TVE_DETAIL_MODE_OFF TVE_DETAIL_MODE_ON
			#pragma shader_feature_local TVE_DETAIL_BLEND_OVERLAY TVE_DETAIL_BLEND_REPLACE

			//TVE Pipeline Defines
			#define THE_VEGETATION_ENGINE
			#define IS_UNIVERSAL_PIPELINE
			//TVE Shader Type Defines
			#define TVE_IS_VEGETATION_SHADER
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
				float4 ase_texcoord3 : TEXCOORD3;
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
				float4 ase_color : COLOR;
				float4 ase_texcoord9 : TEXCOORD9;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			half4 _SecondUVs;
			half4 _VertexOcclusionColor;
			float4 _SubsurfaceDiffusion_Asset;
			half4 _SecondColor;
			half4 _EmissiveColor;
			float4 _NoiseMaskRemap;
			half4 _ColorsMaskRemap;
			half4 _SubsurfaceMaskRemap;
			half4 _OverlayMaskRemap;
			float4 _GradientMaskRemap;
			half4 _VertexOcclusionRemap;
			half4 _DetailBlendRemap;
			float4 _Color;
			half4 _MainColor;
			half4 _MainUVs;
			float4 _MaxBoundsInfo;
			half4 _EmissiveUVs;
			float4 _SubsurfaceDiffusion_asset;
			half3 _render_normals_options;
			half _VertexDataMode;
			half _InteractionAmplitude;
			half _GlobalSize;
			half _InteractionVariation;
			half _LayerReactValue;
			half _MotionVariation_20;
			half _MotionVariation_10;
			float _MotionSpeed_10;
			half _MotionAmplitude_10;
			half _MotionScale_20;
			half _MotionSpeed_20;
			half _VertexRollingMode;
			half _LayerMotionValue;
			half _vertex_pivot_mode;
			half _MotionAmplitude_20;
			float _MotionScale_10;
			half _render_dst;
			half _OverlayBottomValue;
			half _DetailMaskMode;
			half _MainOcclusionValue;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half _RenderSpecular;
			half _GlobalEmissive;
			half _DetailNormalValue;
			half _SecondNormalValue;
			half _VertexOcclusionMaxValue;
			half _VertexOcclusionMinValue;
			half _OverlayMaskMaxValue;
			half _OverlayMaskMinValue;
			half _LayerExtrasValue;
			half _GlobalOverlay;
			half _MainNormalValue;
			half _EmissiveFlagMode;
			half _DetailBlendMaxValue;
			half _DetailBlendMinValue;
			half _DetailMaskInvertMode;
			half _DetailMeshValue;
			half _RenderMode;
			float _SubsurfaceDiffusion;
			half _RenderDecals;
			half _RenderPriority;
			half _TranslucencyIntensityValue;
			half _EmissiveCat;
			half _ReceiveSpace;
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
			half _IsBarkShader;
			half _IsStandardShader;
			half _render_src;
			half _render_cull;
			half _render_zw;
			half _NoiseCat;
			half _SizeFadeCat;
			half _TranslucencyAmbientValue;
			half _VertexMasksMode;
			half _RenderZWrite;
			half _TranslucencyShadowValue;
			half _RenderSSR;
			half _SecondOcclusionValue;
			half _MotionSpace;
			half _RenderCull;
			half _PerspectiveCat;
			half _VertexVariationMode;
			half _GradientCat;
			half _TranslucencyDirectValue;
			half _FadeSpace;
			half _GlobalCat;
			half _IsTVEShader;
			half _DetailSpace;
			half _DetailTypeMode;
			half _DetailCat;
			half _TranslucencyScatteringValue;
			half _TranslucencyNormalValue;
			half _RenderClip;
			half _IsVersion;
			half _RenderingCat;
			half _VariationMotionMessage;
			half _FadeCameraValue;
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
			half4 TVE_MotionParams;
			TEXTURE2D_ARRAY(TVE_MotionTex);
			half4 TVE_MotionCoord;
			SAMPLER(samplerTVE_MotionTex);
			float TVE_MotionUsage[9];
			TEXTURE2D(TVE_NoiseTex);
			float2 TVE_NoiseSpeed_Vegetation;
			float2 TVE_NoiseSpeed_Grass;
			half TVE_NoiseSize_Vegetation;
			half TVE_NoiseSize_Grass;
			SAMPLER(samplerTVE_NoiseTex);
			half4 TVE_ReactParams;
			TEXTURE2D_ARRAY(TVE_ReactTex);
			half4 TVE_ReactCoord;
			SAMPLER(samplerTVE_ReactTex);
			float TVE_ReactUsage[9];
			TEXTURE2D(_MainAlbedoTex);
			SAMPLER(sampler_MainAlbedoTex);
			TEXTURE2D(_SecondAlbedoTex);
			TEXTURE2D(_SecondMaskTex);
			SAMPLER(sampler_SecondMaskTex);
			TEXTURE2D(_MainMaskTex);
			half4 TVE_OverlayColor;
			TEXTURE2D(_MainNormalTex);
			half4 TVE_ExtrasParams;
			TEXTURE2D_ARRAY(TVE_ExtrasTex);
			half4 TVE_ExtrasCoord;
			SAMPLER(samplerTVE_ExtrasTex);
			float TVE_ExtrasUsage[9];
			TEXTURE2D(_SecondNormalTex);
			TEXTURE2D(_EmissiveTex);
			SAMPLER(sampler_EmissiveTex);
			half TVE_OverlaySmoothness;
			half TVE_CameraFadeStart;
			half TVE_CameraFadeEnd;
			TEXTURE3D(TVE_ScreenTex3D);
			half TVE_ScreenTexCoord;
			SAMPLER(samplerTVE_ScreenTex3D);


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 PositionOS3588_g51941 = v.vertex.xyz;
				half3 _Vector1 = half3(0,0,0);
				half3 Mesh_PivotsOS2291_g51941 = _Vector1;
				float3 temp_output_2283_0_g51941 = ( PositionOS3588_g51941 - Mesh_PivotsOS2291_g51941 );
				half3 VertexPos40_g52293 = temp_output_2283_0_g51941;
				float3 appendResult74_g52293 = (float3(0.0 , VertexPos40_g52293.y , 0.0));
				float3 VertexPosRotationAxis50_g52293 = appendResult74_g52293;
				float3 break84_g52293 = VertexPos40_g52293;
				float3 appendResult81_g52293 = (float3(break84_g52293.x , 0.0 , break84_g52293.z));
				float3 VertexPosOtherAxis82_g52293 = appendResult81_g52293;
				float ObjectData20_g52239 = 3.14;
				float Bounds_Radius121_g51941 = _MaxBoundsInfo.x;
				float WorldData19_g52239 = Bounds_Radius121_g51941;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52239 = WorldData19_g52239;
				#else
				float staticSwitch14_g52239 = ObjectData20_g52239;
				#endif
				float Motion_Max_Rolling1137_g51941 = staticSwitch14_g52239;
				float4x4 break19_g52279 = GetObjectToWorldMatrix();
				float3 appendResult20_g52279 = (float3(break19_g52279[ 0 ][ 3 ] , break19_g52279[ 1 ][ 3 ] , break19_g52279[ 2 ][ 3 ]));
				half3 Off19_g52282 = appendResult20_g52279;
				float3 appendResult93_g52279 = (float3(v.texcoord.z , v.ase_texcoord3.w , v.texcoord.w));
				float3 temp_output_91_0_g52279 = ( appendResult93_g52279 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52279 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52279 , 0.0 ) ).xyz).xyz;
				half3 On20_g52282 = ( appendResult20_g52279 + PivotsOnly105_g52279 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52282 = On20_g52282;
				#else
				float3 staticSwitch14_g52282 = Off19_g52282;
				#endif
				half3 ObjectData20_g52283 = staticSwitch14_g52282;
				half3 WorldData19_g52283 = Off19_g52282;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52283 = WorldData19_g52283;
				#else
				float3 staticSwitch14_g52283 = ObjectData20_g52283;
				#endif
				float3 temp_output_42_0_g52279 = staticSwitch14_g52283;
				half3 ObjectData20_g52278 = temp_output_42_0_g52279;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				half3 WorldData19_g52278 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52278 = WorldData19_g52278;
				#else
				float3 staticSwitch14_g52278 = ObjectData20_g52278;
				#endif
				float3 Position83_g52277 = staticSwitch14_g52278;
				float temp_output_84_0_g52277 = _LayerMotionValue;
				float4 lerpResult87_g52277 = lerp( TVE_MotionParams , SAMPLE_TEXTURE2D_ARRAY_LOD( TVE_MotionTex, samplerTVE_MotionTex, ( (TVE_MotionCoord).zw + ( (TVE_MotionCoord).xy * (Position83_g52277).xz ) ),temp_output_84_0_g52277, 0.0 ) , TVE_MotionUsage[(int)temp_output_84_0_g52277]);
				half4 Global_Motion_Params3909_g51941 = lerpResult87_g52277;
				float4 break322_g52303 = Global_Motion_Params3909_g51941;
				half Wind_Power369_g52303 = break322_g52303.z;
				float lerpResult410_g52303 = lerp( 0.2 , 1.0 , Wind_Power369_g52303);
				half Wind_Power_203109_g51941 = lerpResult410_g52303;
				half Mesh_Motion_260_g51941 = v.ase_texcoord3.y;
				#ifdef TVE_IS_GRASS_SHADER
				float2 staticSwitch160_g52296 = TVE_NoiseSpeed_Grass;
				#else
				float2 staticSwitch160_g52296 = TVE_NoiseSpeed_Vegetation;
				#endif
				float4x4 break19_g52298 = GetObjectToWorldMatrix();
				float3 appendResult20_g52298 = (float3(break19_g52298[ 0 ][ 3 ] , break19_g52298[ 1 ][ 3 ] , break19_g52298[ 2 ][ 3 ]));
				half3 Off19_g52301 = appendResult20_g52298;
				float3 appendResult93_g52298 = (float3(v.texcoord.z , v.ase_texcoord3.w , v.texcoord.w));
				float3 temp_output_91_0_g52298 = ( appendResult93_g52298 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52298 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52298 , 0.0 ) ).xyz).xyz;
				half3 On20_g52301 = ( appendResult20_g52298 + PivotsOnly105_g52298 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52301 = On20_g52301;
				#else
				float3 staticSwitch14_g52301 = Off19_g52301;
				#endif
				half3 ObjectData20_g52302 = staticSwitch14_g52301;
				half3 WorldData19_g52302 = Off19_g52301;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52302 = WorldData19_g52302;
				#else
				float3 staticSwitch14_g52302 = ObjectData20_g52302;
				#endif
				float3 temp_output_42_0_g52298 = staticSwitch14_g52302;
				half3 ObjectData20_g52297 = temp_output_42_0_g52298;
				half3 WorldData19_g52297 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52297 = WorldData19_g52297;
				#else
				float3 staticSwitch14_g52297 = ObjectData20_g52297;
				#endif
				#ifdef TVE_IS_GRASS_SHADER
				float2 staticSwitch164_g52296 = (ase_worldPos).xz;
				#else
				float2 staticSwitch164_g52296 = (staticSwitch14_g52297).xz;
				#endif
				#ifdef TVE_IS_GRASS_SHADER
				float staticSwitch161_g52296 = TVE_NoiseSize_Grass;
				#else
				float staticSwitch161_g52296 = TVE_NoiseSize_Vegetation;
				#endif
				float2 panner73_g52296 = ( _TimeParameters.x * staticSwitch160_g52296 + ( staticSwitch164_g52296 * staticSwitch161_g52296 ));
				float4 tex2DNode75_g52296 = SAMPLE_TEXTURE2D_LOD( TVE_NoiseTex, samplerTVE_NoiseTex, panner73_g52296, 0.0 );
				float4 saferPower77_g52296 = max( abs( tex2DNode75_g52296 ) , 0.0001 );
				half Wind_Power2223_g51941 = Wind_Power369_g52303;
				float temp_output_167_0_g52296 = Wind_Power2223_g51941;
				float lerpResult168_g52296 = lerp( 1.5 , 0.25 , temp_output_167_0_g52296);
				float4 temp_cast_7 = (lerpResult168_g52296).xxxx;
				float4 break142_g52296 = pow( saferPower77_g52296 , temp_cast_7 );
				half Global_NoiseTex_R34_g51941 = break142_g52296.r;
				half Input_Speed62_g52276 = _MotionSpeed_20;
				float mulTime354_g52276 = _TimeParameters.x * Input_Speed62_g52276;
				float4x4 break19_g52214 = GetObjectToWorldMatrix();
				float3 appendResult20_g52214 = (float3(break19_g52214[ 0 ][ 3 ] , break19_g52214[ 1 ][ 3 ] , break19_g52214[ 2 ][ 3 ]));
				half3 Off19_g52217 = appendResult20_g52214;
				float3 appendResult93_g52214 = (float3(v.texcoord.z , v.ase_texcoord3.w , v.texcoord.w));
				float3 temp_output_91_0_g52214 = ( appendResult93_g52214 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52214 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52214 , 0.0 ) ).xyz).xyz;
				half3 On20_g52217 = ( appendResult20_g52214 + PivotsOnly105_g52214 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52217 = On20_g52217;
				#else
				float3 staticSwitch14_g52217 = Off19_g52217;
				#endif
				half3 ObjectData20_g52218 = staticSwitch14_g52217;
				half3 WorldData19_g52218 = Off19_g52217;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52218 = WorldData19_g52218;
				#else
				float3 staticSwitch14_g52218 = ObjectData20_g52218;
				#endif
				float3 temp_output_42_0_g52214 = staticSwitch14_g52218;
				float3 break9_g52214 = temp_output_42_0_g52214;
				half Variation_Complex102_g52212 = frac( ( v.ase_color.r + ( break9_g52214.x + break9_g52214.z ) ) );
				float ObjectData20_g52213 = Variation_Complex102_g52212;
				half Variation_Simple105_g52212 = v.ase_color.r;
				float WorldData19_g52213 = Variation_Simple105_g52212;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52213 = WorldData19_g52213;
				#else
				float staticSwitch14_g52213 = ObjectData20_g52213;
				#endif
				half Motion_Variation3073_g51941 = staticSwitch14_g52213;
				float temp_output_3154_0_g51941 = ( _MotionVariation_20 * Motion_Variation3073_g51941 );
				float Motion_Variation284_g52276 = temp_output_3154_0_g51941;
				float Motion_Scale287_g52276 = ( _MotionScale_20 * ase_worldPos.x );
				half Variation127_g52292 = temp_output_3154_0_g51941;
				float lerpResult110_g52292 = lerp( ceil( saturate( ( frac( ( Variation127_g52292 + 0.3576 ) ) - 0.6 ) ) ) , ceil( saturate( ( frac( ( Variation127_g52292 + 0.1715 ) ) - 0.4 ) ) ) , (sin( _TimeParameters.x )*0.5 + 0.5));
				float temp_output_112_0_g52292 = Wind_Power2223_g51941;
				float lerpResult111_g52292 = lerp( lerpResult110_g52292 , 1.0 , ( temp_output_112_0_g52292 * temp_output_112_0_g52292 * temp_output_112_0_g52292 * temp_output_112_0_g52292 ));
				float lerpResult126_g52292 = lerp( lerpResult111_g52292 , 1.0 , ( 1.0 - saturate( Variation127_g52292 ) ));
				half Motion_Rolling138_g51941 = ( ( _MotionAmplitude_20 * Motion_Max_Rolling1137_g51941 ) * ( Wind_Power_203109_g51941 * Mesh_Motion_260_g51941 * Global_NoiseTex_R34_g51941 * _VertexRollingMode ) * sin( ( mulTime354_g52276 + Motion_Variation284_g52276 + Motion_Scale287_g52276 ) ) * lerpResult126_g52292 );
				half Angle44_g52293 = Motion_Rolling138_g51941;
				half3 VertexPos40_g52260 = ( VertexPosRotationAxis50_g52293 + ( VertexPosOtherAxis82_g52293 * cos( Angle44_g52293 ) ) + ( cross( float3(0,1,0) , VertexPosOtherAxis82_g52293 ) * sin( Angle44_g52293 ) ) );
				float3 appendResult74_g52260 = (float3(VertexPos40_g52260.x , 0.0 , 0.0));
				half3 VertexPosRotationAxis50_g52260 = appendResult74_g52260;
				float3 break84_g52260 = VertexPos40_g52260;
				float3 appendResult81_g52260 = (float3(0.0 , break84_g52260.y , break84_g52260.z));
				half3 VertexPosOtherAxis82_g52260 = appendResult81_g52260;
				float ObjectData20_g52309 = 3.14;
				float Bounds_Height374_g51941 = _MaxBoundsInfo.y;
				float WorldData19_g52309 = ( Bounds_Height374_g51941 * 3.14 );
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52309 = WorldData19_g52309;
				#else
				float staticSwitch14_g52309 = ObjectData20_g52309;
				#endif
				float Motion_Max_Bending1133_g51941 = staticSwitch14_g52309;
				float lerpResult376_g52303 = lerp( 0.1 , 1.0 , Wind_Power369_g52303);
				half Wind_Power_103106_g51941 = lerpResult376_g52303;
				float3 appendResult397_g52303 = (float3(break322_g52303.x , 0.0 , break322_g52303.y));
				float3 temp_output_398_0_g52303 = (appendResult397_g52303*2.0 + -1.0);
				float3 ase_parentObjectScale = ( 1.0 / float3( length( GetWorldToObjectMatrix()[ 0 ].xyz ), length( GetWorldToObjectMatrix()[ 1 ].xyz ), length( GetWorldToObjectMatrix()[ 2 ].xyz ) ) );
				float3 temp_output_339_0_g52303 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_398_0_g52303 , 0.0 ) ).xyz * ase_parentObjectScale );
				half2 Wind_DirectionOS39_g51941 = (temp_output_339_0_g52303).xz;
				half Input_Speed62_g52219 = _MotionSpeed_10;
				float mulTime373_g52219 = _TimeParameters.x * Input_Speed62_g52219;
				half Motion_Variation284_g52219 = ( _MotionVariation_10 * Motion_Variation3073_g51941 );
				float2 appendResult344_g52219 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 Motion_Scale287_g52219 = ( _MotionScale_10 * appendResult344_g52219 );
				half2 Sine_MinusOneToOne281_g52219 = sin( ( mulTime373_g52219 + Motion_Variation284_g52219 + Motion_Scale287_g52219 ) );
				float2 temp_cast_12 = (1.0).xx;
				half Input_Turbulence327_g52219 = Global_NoiseTex_R34_g51941;
				float2 lerpResult321_g52219 = lerp( Sine_MinusOneToOne281_g52219 , temp_cast_12 , Input_Turbulence327_g52219);
				half2 Motion_Bending2258_g51941 = ( ( _MotionAmplitude_10 * Motion_Max_Bending1133_g51941 ) * Wind_Power_103106_g51941 * Wind_DirectionOS39_g51941 * Global_NoiseTex_R34_g51941 * lerpResult321_g52219 );
				half Interaction_Amplitude4137_g51941 = _InteractionAmplitude;
				float4x4 break19_g52271 = GetObjectToWorldMatrix();
				float3 appendResult20_g52271 = (float3(break19_g52271[ 0 ][ 3 ] , break19_g52271[ 1 ][ 3 ] , break19_g52271[ 2 ][ 3 ]));
				half3 Off19_g52274 = appendResult20_g52271;
				float3 appendResult93_g52271 = (float3(v.texcoord.z , v.ase_texcoord3.w , v.texcoord.w));
				float3 temp_output_91_0_g52271 = ( appendResult93_g52271 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52271 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52271 , 0.0 ) ).xyz).xyz;
				half3 On20_g52274 = ( appendResult20_g52271 + PivotsOnly105_g52271 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52274 = On20_g52274;
				#else
				float3 staticSwitch14_g52274 = Off19_g52274;
				#endif
				half3 ObjectData20_g52275 = staticSwitch14_g52274;
				half3 WorldData19_g52275 = Off19_g52274;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52275 = WorldData19_g52275;
				#else
				float3 staticSwitch14_g52275 = ObjectData20_g52275;
				#endif
				float3 temp_output_42_0_g52271 = staticSwitch14_g52275;
				half3 ObjectData20_g52270 = temp_output_42_0_g52271;
				half3 WorldData19_g52270 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52270 = WorldData19_g52270;
				#else
				float3 staticSwitch14_g52270 = ObjectData20_g52270;
				#endif
				float3 Position83_g52269 = staticSwitch14_g52270;
				float temp_output_84_0_g52269 = _LayerReactValue;
				float4 lerpResult87_g52269 = lerp( TVE_ReactParams , SAMPLE_TEXTURE2D_ARRAY_LOD( TVE_ReactTex, samplerTVE_ReactTex, ( (TVE_ReactCoord).zw + ( (TVE_ReactCoord).xy * (Position83_g52269).xz ) ),temp_output_84_0_g52269, 0.0 ) , TVE_ReactUsage[(int)temp_output_84_0_g52269]);
				half4 Global_React_Params4173_g51941 = lerpResult87_g52269;
				float4 break322_g52256 = Global_React_Params4173_g51941;
				half Interaction_Mask66_g51941 = break322_g52256.z;
				float3 appendResult397_g52256 = (float3(break322_g52256.x , 0.0 , break322_g52256.y));
				float3 temp_output_398_0_g52256 = (appendResult397_g52256*2.0 + -1.0);
				float3 temp_output_339_0_g52256 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_398_0_g52256 , 0.0 ) ).xyz * ase_parentObjectScale );
				half2 Interaction_DirectionOS4158_g51941 = (temp_output_339_0_g52256).xz;
				float lerpResult3307_g51941 = lerp( 1.0 , Motion_Variation3073_g51941 , _InteractionVariation);
				half2 Motion_Interaction53_g51941 = ( Interaction_Amplitude4137_g51941 * Motion_Max_Bending1133_g51941 * Interaction_Mask66_g51941 * Interaction_Mask66_g51941 * Interaction_DirectionOS4158_g51941 * lerpResult3307_g51941 );
				float2 lerpResult109_g51941 = lerp( Motion_Bending2258_g51941 , Motion_Interaction53_g51941 , ( Interaction_Mask66_g51941 * saturate( Interaction_Amplitude4137_g51941 ) ));
				half Mesh_Motion_182_g51941 = v.ase_texcoord3.x;
				float2 break143_g51941 = ( lerpResult109_g51941 * Mesh_Motion_182_g51941 );
				half Motion_Z190_g51941 = break143_g51941.y;
				half Angle44_g52260 = Motion_Z190_g51941;
				half3 VertexPos40_g52259 = ( VertexPosRotationAxis50_g52260 + ( VertexPosOtherAxis82_g52260 * cos( Angle44_g52260 ) ) + ( cross( float3(1,0,0) , VertexPosOtherAxis82_g52260 ) * sin( Angle44_g52260 ) ) );
				float3 appendResult74_g52259 = (float3(0.0 , 0.0 , VertexPos40_g52259.z));
				half3 VertexPosRotationAxis50_g52259 = appendResult74_g52259;
				float3 break84_g52259 = VertexPos40_g52259;
				float3 appendResult81_g52259 = (float3(break84_g52259.x , break84_g52259.y , 0.0));
				half3 VertexPosOtherAxis82_g52259 = appendResult81_g52259;
				half Motion_X216_g51941 = break143_g51941.x;
				half Angle44_g52259 = -Motion_X216_g51941;
				float3 Vertex_Motion_Object833_g51941 = ( VertexPosRotationAxis50_g52259 + ( VertexPosOtherAxis82_g52259 * cos( Angle44_g52259 ) ) + ( cross( float3(0,0,1) , VertexPosOtherAxis82_g52259 ) * sin( Angle44_g52259 ) ) );
				float3 temp_output_3474_0_g51941 = ( PositionOS3588_g51941 - Mesh_PivotsOS2291_g51941 );
				float3 appendResult2047_g51941 = (float3(Motion_Rolling138_g51941 , 0.0 , -Motion_Rolling138_g51941));
				float3 appendResult2043_g51941 = (float3(Motion_X216_g51941 , 0.0 , Motion_Z190_g51941));
				float3 Vertex_Motion_World1118_g51941 = ( ( temp_output_3474_0_g51941 + appendResult2047_g51941 ) + appendResult2043_g51941 );
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch3312_g51941 = Vertex_Motion_World1118_g51941;
				#else
				float3 staticSwitch3312_g51941 = ( Vertex_Motion_Object833_g51941 + ( 0.0 * _VertexDataMode ) );
				#endif
				half Global_Vertex_Size174_g51941 = break322_g52256.w;
				float lerpResult346_g51941 = lerp( 1.0 , Global_Vertex_Size174_g51941 , _GlobalSize);
				float3 appendResult3480_g51941 = (float3(lerpResult346_g51941 , lerpResult346_g51941 , lerpResult346_g51941));
				half3 ObjectData20_g52294 = appendResult3480_g51941;
				half3 _Vector11 = half3(1,1,1);
				half3 WorldData19_g52294 = _Vector11;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52294 = WorldData19_g52294;
				#else
				float3 staticSwitch14_g52294 = ObjectData20_g52294;
				#endif
				half3 Vertex_Size1741_g51941 = staticSwitch14_g52294;
				half3 _Vector5 = half3(1,1,1);
				float3 Vertex_SizeFade1740_g51941 = _Vector5;
				half3 Grass_Coverage2661_g51941 = half3(0,0,0);
				float3 Final_VertexPosition890_g51941 = ( ( staticSwitch3312_g51941 * Vertex_Size1741_g51941 * Vertex_SizeFade1740_g51941 ) + Mesh_PivotsOS2291_g51941 + Grass_Coverage2661_g51941 );
				
				float2 vertexToFrag11_g52308 = ( ( v.texcoord.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				o.ase_texcoord7.xy = vertexToFrag11_g52308;
				float2 appendResult21_g52242 = (float2(v.texcoord.z , v.texcoord.w));
				float2 Mesh_DetailCoord3_g51941 = appendResult21_g52242;
				float2 vertexToFrag11_g52243 = ( ( Mesh_DetailCoord3_g51941 * (_SecondUVs).xy ) + (_SecondUVs).zw );
				o.ase_texcoord7.zw = vertexToFrag11_g52243;
				half Mesh_DetailMask90_g51941 = v.ase_color.b;
				float vertexToFrag11_g52208 = ( ( Mesh_DetailMask90_g51941 - 0.5 ) + _DetailMeshValue );
				o.ase_texcoord8.x = vertexToFrag11_g52208;
				float3 vertexToFrag3890_g51941 = ase_worldPos;
				o.ase_texcoord8.yzw = vertexToFrag3890_g51941;
				
				float2 vertexToFrag11_g52248 = ( ( v.texcoord.xy * (_EmissiveUVs).xy ) + (_EmissiveUVs).zw );
				o.ase_texcoord9.xy = vertexToFrag11_g52248;
				
				float temp_output_7_0_g52252 = TVE_CameraFadeStart;
				float saferPower3976_g51941 = max( saturate( ( ( distance( ase_worldPos , _WorldSpaceCameraPos ) - temp_output_7_0_g52252 ) / ( TVE_CameraFadeEnd - temp_output_7_0_g52252 ) ) ) , 0.0001 );
				float temp_output_3976_0_g51941 = pow( saferPower3976_g51941 , _FadeCameraValue );
				float vertexToFrag11_g52251 = temp_output_3976_0_g51941;
				o.ase_texcoord9.z = vertexToFrag11_g52251;
				
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord9.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = Final_VertexPosition890_g51941;
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
				float4 ase_texcoord3 : TEXCOORD3;
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
				o.texcoord = v.texcoord;
				o.ase_texcoord3 = v.ase_texcoord3;
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
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.ase_texcoord3 = patch[0].ase_texcoord3 * bary.x + patch[1].ase_texcoord3 * bary.y + patch[2].ase_texcoord3 * bary.z;
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
				half2 Main_UVs15_g51941 = vertexToFrag11_g52308;
				float4 tex2DNode29_g51941 = SAMPLE_TEXTURE2D( _MainAlbedoTex, sampler_MainAlbedoTex, Main_UVs15_g51941 );
				float3 temp_output_51_0_g51941 = ( (_MainColor).rgb * (tex2DNode29_g51941).rgb );
				half3 Main_Albedo99_g51941 = temp_output_51_0_g51941;
				float2 vertexToFrag11_g52243 = IN.ase_texcoord7.zw;
				half2 Second_UVs17_g51941 = vertexToFrag11_g52243;
				half3 Second_Albedo153_g51941 = (( _SecondColor * SAMPLE_TEXTURE2D( _SecondAlbedoTex, sampler_SecondMaskTex, Second_UVs17_g51941 ) )).rgb;
				#ifdef UNITY_COLORSPACE_GAMMA
				float staticSwitch1_g52209 = 2.0;
				#else
				float staticSwitch1_g52209 = 4.594794;
				#endif
				float vertexToFrag11_g52208 = IN.ase_texcoord8.x;
				float temp_output_3919_0_g51941 = vertexToFrag11_g52208;
				half Blend_Source1540_g51941 = temp_output_3919_0_g51941;
				float4 tex2DNode35_g51941 = SAMPLE_TEXTURE2D( _MainMaskTex, sampler_MainAlbedoTex, Main_UVs15_g51941 );
				half Main_Mask57_g51941 = tex2DNode35_g51941.b;
				float4 tex2DNode33_g51941 = SAMPLE_TEXTURE2D( _SecondMaskTex, sampler_SecondMaskTex, Second_UVs17_g51941 );
				half Second_Mask81_g51941 = tex2DNode33_g51941.b;
				float lerpResult1327_g51941 = lerp( Main_Mask57_g51941 , Second_Mask81_g51941 , _DetailMaskMode);
				float lerpResult4058_g51941 = lerp( lerpResult1327_g51941 , ( 1.0 - lerpResult1327_g51941 ) , _DetailMaskInvertMode);
				float temp_output_7_0_g52238 = _DetailBlendMinValue;
				half Mask_Detail147_g51941 = saturate( ( ( saturate( ( Blend_Source1540_g51941 + ( Blend_Source1540_g51941 * lerpResult4058_g51941 ) ) ) - temp_output_7_0_g52238 ) / ( _DetailBlendMaxValue - temp_output_7_0_g52238 ) ) );
				float3 lerpResult235_g51941 = lerp( Main_Albedo99_g51941 , ( Main_Albedo99_g51941 * Second_Albedo153_g51941 * staticSwitch1_g52209 ) , Mask_Detail147_g51941);
				float3 lerpResult208_g51941 = lerp( Main_Albedo99_g51941 , Second_Albedo153_g51941 , Mask_Detail147_g51941);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float3 staticSwitch4062_g51941 = lerpResult235_g51941;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float3 staticSwitch4062_g51941 = lerpResult208_g51941;
				#else
				float3 staticSwitch4062_g51941 = lerpResult235_g51941;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float3 staticSwitch255_g51941 = Main_Albedo99_g51941;
				#elif defined(TVE_DETAIL_MODE_ON)
				float3 staticSwitch255_g51941 = staticSwitch4062_g51941;
				#else
				float3 staticSwitch255_g51941 = Main_Albedo99_g51941;
				#endif
				half3 Blend_Albedo265_g51941 = staticSwitch255_g51941;
				half3 Blend_AlbedoTinted2808_g51941 = ( float3(1,1,1) * float3(1,1,1) * float3(1,1,1) * Blend_Albedo265_g51941 );
				half3 Blend_AlbedoColored863_g51941 = Blend_AlbedoTinted2808_g51941;
				half3 Blend_AlbedoAndSubsurface149_g51941 = Blend_AlbedoColored863_g51941;
				half3 Global_OverlayColor1758_g51941 = (TVE_OverlayColor).rgb;
				float3 unpack4112_g51941 = UnpackNormalScale( SAMPLE_TEXTURE2D( _MainNormalTex, sampler_MainAlbedoTex, Main_UVs15_g51941 ), _MainNormalValue );
				unpack4112_g51941.z = lerp( 1, unpack4112_g51941.z, saturate(_MainNormalValue) );
				half3 Main_Normal137_g51941 = unpack4112_g51941;
				float3 tanToWorld0 = float3( WorldTangent.x, WorldBiTangent.x, WorldNormal.x );
				float3 tanToWorld1 = float3( WorldTangent.y, WorldBiTangent.y, WorldNormal.y );
				float3 tanToWorld2 = float3( WorldTangent.z, WorldBiTangent.z, WorldNormal.z );
				float3 tanNormal4099_g51941 = Main_Normal137_g51941;
				float3 worldNormal4099_g51941 = float3(dot(tanToWorld0,tanNormal4099_g51941), dot(tanToWorld1,tanNormal4099_g51941), dot(tanToWorld2,tanNormal4099_g51941));
				float3 Main_Normal_WS4101_g51941 = worldNormal4099_g51941;
				float lerpResult3567_g51941 = lerp( _OverlayBottomValue , 1.0 , Main_Normal_WS4101_g51941.y);
				half Main_AlbedoTex_G3526_g51941 = tex2DNode29_g51941.g;
				half Second_AlbedoTex_G3581_g51941 = (SAMPLE_TEXTURE2D( _SecondAlbedoTex, sampler_SecondMaskTex, Second_UVs17_g51941 )).g;
				float lerpResult3579_g51941 = lerp( Main_AlbedoTex_G3526_g51941 , Second_AlbedoTex_G3581_g51941 , Mask_Detail147_g51941);
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch3574_g51941 = Main_AlbedoTex_G3526_g51941;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch3574_g51941 = lerpResult3579_g51941;
				#else
				float staticSwitch3574_g51941 = Main_AlbedoTex_G3526_g51941;
				#endif
				float3 vertexToFrag3890_g51941 = IN.ase_texcoord8.yzw;
				float3 PositionWS_PerVertex3905_g51941 = vertexToFrag3890_g51941;
				float3 Position82_g52261 = PositionWS_PerVertex3905_g51941;
				float temp_output_84_0_g52261 = _LayerExtrasValue;
				float4 lerpResult88_g52261 = lerp( TVE_ExtrasParams , SAMPLE_TEXTURE2D_ARRAY( TVE_ExtrasTex, samplerTVE_ExtrasTex, ( (TVE_ExtrasCoord).zw + ( (TVE_ExtrasCoord).xy * (Position82_g52261).xz ) ),temp_output_84_0_g52261 ) , TVE_ExtrasUsage[(int)temp_output_84_0_g52261]);
				float4 break89_g52261 = lerpResult88_g52261;
				half Global_Extras_Overlay156_g51941 = break89_g52261.b;
				float temp_output_1025_0_g51941 = ( _GlobalOverlay * Global_Extras_Overlay156_g51941 );
				half Overlay_Commons1365_g51941 = temp_output_1025_0_g51941;
				float temp_output_7_0_g52234 = _OverlayMaskMinValue;
				half Overlay_Mask269_g51941 = saturate( ( ( ( ( ( lerpResult3567_g51941 * 0.5 ) + staticSwitch3574_g51941 ) * Overlay_Commons1365_g51941 ) - temp_output_7_0_g52234 ) / ( _OverlayMaskMaxValue - temp_output_7_0_g52234 ) ) );
				float3 lerpResult336_g51941 = lerp( Blend_AlbedoAndSubsurface149_g51941 , Global_OverlayColor1758_g51941 , Overlay_Mask269_g51941);
				half3 Final_Albedo359_g51941 = lerpResult336_g51941;
				float3 temp_cast_3 = (1.0).xxx;
				float Mesh_Occlusion318_g51941 = IN.ase_color.g;
				float temp_output_7_0_g52232 = _VertexOcclusionMinValue;
				float3 lerpResult2945_g51941 = lerp( (_VertexOcclusionColor).rgb , temp_cast_3 , saturate( ( ( Mesh_Occlusion318_g51941 - temp_output_7_0_g52232 ) / ( _VertexOcclusionMaxValue - temp_output_7_0_g52232 ) ) ));
				float3 Vertex_Occlusion648_g51941 = lerpResult2945_g51941;
				
				float3 unpack4114_g51941 = UnpackNormalScale( SAMPLE_TEXTURE2D( _SecondNormalTex, sampler_SecondMaskTex, Second_UVs17_g51941 ), _SecondNormalValue );
				unpack4114_g51941.z = lerp( 1, unpack4114_g51941.z, saturate(_SecondNormalValue) );
				half3 Second_Normal179_g51941 = unpack4114_g51941;
				float3 lerpResult230_g51941 = lerp( float3( 0,0,1 ) , Second_Normal179_g51941 , Mask_Detail147_g51941);
				float3 lerpResult3372_g51941 = lerp( float3( 0,0,1 ) , Main_Normal137_g51941 , _DetailNormalValue);
				float3 lerpResult3376_g51941 = lerp( Main_Normal137_g51941 , BlendNormal( lerpResult3372_g51941 , Second_Normal179_g51941 ) , Mask_Detail147_g51941);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float3 staticSwitch4063_g51941 = BlendNormal( Main_Normal137_g51941 , lerpResult230_g51941 );
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float3 staticSwitch4063_g51941 = lerpResult3376_g51941;
				#else
				float3 staticSwitch4063_g51941 = BlendNormal( Main_Normal137_g51941 , lerpResult230_g51941 );
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float3 staticSwitch267_g51941 = Main_Normal137_g51941;
				#elif defined(TVE_DETAIL_MODE_ON)
				float3 staticSwitch267_g51941 = staticSwitch4063_g51941;
				#else
				float3 staticSwitch267_g51941 = Main_Normal137_g51941;
				#endif
				float3 temp_output_13_0_g52210 = staticSwitch267_g51941;
				float3 switchResult12_g52210 = (((ase_vface>0)?(temp_output_13_0_g52210):(( temp_output_13_0_g52210 * _render_normals_options ))));
				half3 Blend_Normal312_g51941 = switchResult12_g52210;
				half3 Final_Normal366_g51941 = Blend_Normal312_g51941;
				
				float2 vertexToFrag11_g52248 = IN.ase_texcoord9.xy;
				half2 Emissive_UVs2468_g51941 = vertexToFrag11_g52248;
				half Global_Extras_Emissive4203_g51941 = break89_g52261.r;
				float lerpResult4206_g51941 = lerp( 1.0 , Global_Extras_Emissive4203_g51941 , _GlobalEmissive);
				half3 Final_Emissive2476_g51941 = ( (( _EmissiveColor * SAMPLE_TEXTURE2D( _EmissiveTex, sampler_EmissiveTex, Emissive_UVs2468_g51941 ) )).rgb * lerpResult4206_g51941 );
				
				float3 temp_cast_5 = (( 0.04 * _RenderSpecular )).xxx;
				
				half Main_Smoothness227_g51941 = ( tex2DNode35_g51941.a * _MainSmoothnessValue );
				half Second_Smoothness236_g51941 = ( tex2DNode33_g51941.a * _SecondSmoothnessValue );
				float lerpResult266_g51941 = lerp( Main_Smoothness227_g51941 , Second_Smoothness236_g51941 , Mask_Detail147_g51941);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float staticSwitch4065_g51941 = Main_Smoothness227_g51941;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float staticSwitch4065_g51941 = lerpResult266_g51941;
				#else
				float staticSwitch4065_g51941 = Main_Smoothness227_g51941;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch297_g51941 = Main_Smoothness227_g51941;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch297_g51941 = staticSwitch4065_g51941;
				#else
				float staticSwitch297_g51941 = Main_Smoothness227_g51941;
				#endif
				half Blend_Smoothness314_g51941 = staticSwitch297_g51941;
				half Global_OverlaySmoothness311_g51941 = TVE_OverlaySmoothness;
				float lerpResult343_g51941 = lerp( Blend_Smoothness314_g51941 , Global_OverlaySmoothness311_g51941 , Overlay_Mask269_g51941);
				half Final_Smoothness371_g51941 = lerpResult343_g51941;
				half Global_Extras_Wetness305_g51941 = break89_g52261.g;
				float lerpResult3673_g51941 = lerp( 0.0 , Global_Extras_Wetness305_g51941 , _GlobalWetness);
				half Final_SmoothnessAndWetness4130_g51941 = saturate( ( Final_Smoothness371_g51941 + lerpResult3673_g51941 ) );
				
				float lerpResult240_g51941 = lerp( 1.0 , tex2DNode35_g51941.g , _MainOcclusionValue);
				half Main_Occlusion247_g51941 = lerpResult240_g51941;
				float lerpResult239_g51941 = lerp( 1.0 , tex2DNode33_g51941.g , _SecondOcclusionValue);
				half Second_Occlusion251_g51941 = lerpResult239_g51941;
				float lerpResult294_g51941 = lerp( Main_Occlusion247_g51941 , Second_Occlusion251_g51941 , Mask_Detail147_g51941);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float staticSwitch4066_g51941 = Main_Occlusion247_g51941;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float staticSwitch4066_g51941 = lerpResult294_g51941;
				#else
				float staticSwitch4066_g51941 = Main_Occlusion247_g51941;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch310_g51941 = Main_Occlusion247_g51941;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch310_g51941 = staticSwitch4066_g51941;
				#else
				float staticSwitch310_g51941 = Main_Occlusion247_g51941;
				#endif
				half Blend_Occlusion323_g51941 = staticSwitch310_g51941;
				
				float localCustomAlphaClip3735_g51941 = ( 0.0 );
				float vertexToFrag11_g52251 = IN.ase_texcoord9.z;
				half Fade_Camera3743_g51941 = vertexToFrag11_g52251;
				half Final_AlphaFade3727_g51941 = ( 1.0 * Fade_Camera3743_g51941 );
				float temp_output_41_0_g52255 = Final_AlphaFade3727_g51941;
				float Main_Alpha316_g51941 = ( _MainColor.a * tex2DNode29_g51941.a );
				half AlphaTreshold2132_g51941 = _Cutoff;
				#ifdef TVE_ALPHA_CLIP
				float staticSwitch3792_g51941 = ( Main_Alpha316_g51941 - ( AlphaTreshold2132_g51941 - 0.5 ) );
				#else
				float staticSwitch3792_g51941 = Main_Alpha316_g51941;
				#endif
				half Final_Alpha3754_g51941 = staticSwitch3792_g51941;
				float temp_output_661_0_g51941 = ( saturate( ( temp_output_41_0_g52255 + ( temp_output_41_0_g52255 * SAMPLE_TEXTURE3D( TVE_ScreenTex3D, samplerTVE_ScreenTex3D, ( TVE_ScreenTexCoord * PositionWS_PerVertex3905_g51941 ) ).r ) ) ) * Final_Alpha3754_g51941 );
				float Alpha3735_g51941 = temp_output_661_0_g51941;
				float Treshold3735_g51941 = 0.5;
				{
				#if TVE_ALPHA_CLIP
				clip(Alpha3735_g51941 - Treshold3735_g51941);
				#endif
				}
				half Final_Clip914_g51941 = saturate( Alpha3735_g51941 );
				
				float3 Albedo = ( Final_Albedo359_g51941 * Vertex_Occlusion648_g51941 );
				float3 Normal = Final_Normal366_g51941;
				float3 Emission = Final_Emissive2476_g51941;
				float3 Specular = temp_cast_5;
				float Metallic = 0;
				float Smoothness = Final_SmoothnessAndWetness4130_g51941;
				float Occlusion = Blend_Occlusion323_g51941;
				float Alpha = Final_Clip914_g51941;
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
			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define ASE_ABSOLUTE_VERTEX_POS 1
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

			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local TVE_ALPHA_CLIP
			#pragma shader_feature_local TVE_VERTEX_DATA_BATCHED
			//TVE Pipeline Defines
			#define THE_VEGETATION_ENGINE
			#define IS_UNIVERSAL_PIPELINE
			//TVE Shader Type Defines
			#define TVE_IS_VEGETATION_SHADER
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
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			half4 _SecondUVs;
			half4 _VertexOcclusionColor;
			float4 _SubsurfaceDiffusion_Asset;
			half4 _SecondColor;
			half4 _EmissiveColor;
			float4 _NoiseMaskRemap;
			half4 _ColorsMaskRemap;
			half4 _SubsurfaceMaskRemap;
			half4 _OverlayMaskRemap;
			float4 _GradientMaskRemap;
			half4 _VertexOcclusionRemap;
			half4 _DetailBlendRemap;
			float4 _Color;
			half4 _MainColor;
			half4 _MainUVs;
			float4 _MaxBoundsInfo;
			half4 _EmissiveUVs;
			float4 _SubsurfaceDiffusion_asset;
			half3 _render_normals_options;
			half _VertexDataMode;
			half _InteractionAmplitude;
			half _GlobalSize;
			half _InteractionVariation;
			half _LayerReactValue;
			half _MotionVariation_20;
			half _MotionVariation_10;
			float _MotionSpeed_10;
			half _MotionAmplitude_10;
			half _MotionScale_20;
			half _MotionSpeed_20;
			half _VertexRollingMode;
			half _LayerMotionValue;
			half _vertex_pivot_mode;
			half _MotionAmplitude_20;
			float _MotionScale_10;
			half _render_dst;
			half _OverlayBottomValue;
			half _DetailMaskMode;
			half _MainOcclusionValue;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half _RenderSpecular;
			half _GlobalEmissive;
			half _DetailNormalValue;
			half _SecondNormalValue;
			half _VertexOcclusionMaxValue;
			half _VertexOcclusionMinValue;
			half _OverlayMaskMaxValue;
			half _OverlayMaskMinValue;
			half _LayerExtrasValue;
			half _GlobalOverlay;
			half _MainNormalValue;
			half _EmissiveFlagMode;
			half _DetailBlendMaxValue;
			half _DetailBlendMinValue;
			half _DetailMaskInvertMode;
			half _DetailMeshValue;
			half _RenderMode;
			float _SubsurfaceDiffusion;
			half _RenderDecals;
			half _RenderPriority;
			half _TranslucencyIntensityValue;
			half _EmissiveCat;
			half _ReceiveSpace;
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
			half _IsBarkShader;
			half _IsStandardShader;
			half _render_src;
			half _render_cull;
			half _render_zw;
			half _NoiseCat;
			half _SizeFadeCat;
			half _TranslucencyAmbientValue;
			half _VertexMasksMode;
			half _RenderZWrite;
			half _TranslucencyShadowValue;
			half _RenderSSR;
			half _SecondOcclusionValue;
			half _MotionSpace;
			half _RenderCull;
			half _PerspectiveCat;
			half _VertexVariationMode;
			half _GradientCat;
			half _TranslucencyDirectValue;
			half _FadeSpace;
			half _GlobalCat;
			half _IsTVEShader;
			half _DetailSpace;
			half _DetailTypeMode;
			half _DetailCat;
			half _TranslucencyScatteringValue;
			half _TranslucencyNormalValue;
			half _RenderClip;
			half _IsVersion;
			half _RenderingCat;
			half _VariationMotionMessage;
			half _FadeCameraValue;
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
			half4 TVE_MotionParams;
			TEXTURE2D_ARRAY(TVE_MotionTex);
			half4 TVE_MotionCoord;
			SAMPLER(samplerTVE_MotionTex);
			float TVE_MotionUsage[9];
			TEXTURE2D(TVE_NoiseTex);
			float2 TVE_NoiseSpeed_Vegetation;
			float2 TVE_NoiseSpeed_Grass;
			half TVE_NoiseSize_Vegetation;
			half TVE_NoiseSize_Grass;
			SAMPLER(samplerTVE_NoiseTex);
			half4 TVE_ReactParams;
			TEXTURE2D_ARRAY(TVE_ReactTex);
			half4 TVE_ReactCoord;
			SAMPLER(samplerTVE_ReactTex);
			float TVE_ReactUsage[9];
			half TVE_CameraFadeStart;
			half TVE_CameraFadeEnd;
			TEXTURE3D(TVE_ScreenTex3D);
			half TVE_ScreenTexCoord;
			SAMPLER(samplerTVE_ScreenTex3D);
			TEXTURE2D(_MainAlbedoTex);
			SAMPLER(sampler_MainAlbedoTex);


			
			float3 _LightDirection;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float3 PositionOS3588_g51941 = v.vertex.xyz;
				half3 _Vector1 = half3(0,0,0);
				half3 Mesh_PivotsOS2291_g51941 = _Vector1;
				float3 temp_output_2283_0_g51941 = ( PositionOS3588_g51941 - Mesh_PivotsOS2291_g51941 );
				half3 VertexPos40_g52293 = temp_output_2283_0_g51941;
				float3 appendResult74_g52293 = (float3(0.0 , VertexPos40_g52293.y , 0.0));
				float3 VertexPosRotationAxis50_g52293 = appendResult74_g52293;
				float3 break84_g52293 = VertexPos40_g52293;
				float3 appendResult81_g52293 = (float3(break84_g52293.x , 0.0 , break84_g52293.z));
				float3 VertexPosOtherAxis82_g52293 = appendResult81_g52293;
				float ObjectData20_g52239 = 3.14;
				float Bounds_Radius121_g51941 = _MaxBoundsInfo.x;
				float WorldData19_g52239 = Bounds_Radius121_g51941;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52239 = WorldData19_g52239;
				#else
				float staticSwitch14_g52239 = ObjectData20_g52239;
				#endif
				float Motion_Max_Rolling1137_g51941 = staticSwitch14_g52239;
				float4x4 break19_g52279 = GetObjectToWorldMatrix();
				float3 appendResult20_g52279 = (float3(break19_g52279[ 0 ][ 3 ] , break19_g52279[ 1 ][ 3 ] , break19_g52279[ 2 ][ 3 ]));
				half3 Off19_g52282 = appendResult20_g52279;
				float3 appendResult93_g52279 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52279 = ( appendResult93_g52279 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52279 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52279 , 0.0 ) ).xyz).xyz;
				half3 On20_g52282 = ( appendResult20_g52279 + PivotsOnly105_g52279 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52282 = On20_g52282;
				#else
				float3 staticSwitch14_g52282 = Off19_g52282;
				#endif
				half3 ObjectData20_g52283 = staticSwitch14_g52282;
				half3 WorldData19_g52283 = Off19_g52282;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52283 = WorldData19_g52283;
				#else
				float3 staticSwitch14_g52283 = ObjectData20_g52283;
				#endif
				float3 temp_output_42_0_g52279 = staticSwitch14_g52283;
				half3 ObjectData20_g52278 = temp_output_42_0_g52279;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				half3 WorldData19_g52278 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52278 = WorldData19_g52278;
				#else
				float3 staticSwitch14_g52278 = ObjectData20_g52278;
				#endif
				float3 Position83_g52277 = staticSwitch14_g52278;
				float temp_output_84_0_g52277 = _LayerMotionValue;
				float4 lerpResult87_g52277 = lerp( TVE_MotionParams , SAMPLE_TEXTURE2D_ARRAY_LOD( TVE_MotionTex, samplerTVE_MotionTex, ( (TVE_MotionCoord).zw + ( (TVE_MotionCoord).xy * (Position83_g52277).xz ) ),temp_output_84_0_g52277, 0.0 ) , TVE_MotionUsage[(int)temp_output_84_0_g52277]);
				half4 Global_Motion_Params3909_g51941 = lerpResult87_g52277;
				float4 break322_g52303 = Global_Motion_Params3909_g51941;
				half Wind_Power369_g52303 = break322_g52303.z;
				float lerpResult410_g52303 = lerp( 0.2 , 1.0 , Wind_Power369_g52303);
				half Wind_Power_203109_g51941 = lerpResult410_g52303;
				half Mesh_Motion_260_g51941 = v.ase_texcoord3.y;
				#ifdef TVE_IS_GRASS_SHADER
				float2 staticSwitch160_g52296 = TVE_NoiseSpeed_Grass;
				#else
				float2 staticSwitch160_g52296 = TVE_NoiseSpeed_Vegetation;
				#endif
				float4x4 break19_g52298 = GetObjectToWorldMatrix();
				float3 appendResult20_g52298 = (float3(break19_g52298[ 0 ][ 3 ] , break19_g52298[ 1 ][ 3 ] , break19_g52298[ 2 ][ 3 ]));
				half3 Off19_g52301 = appendResult20_g52298;
				float3 appendResult93_g52298 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52298 = ( appendResult93_g52298 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52298 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52298 , 0.0 ) ).xyz).xyz;
				half3 On20_g52301 = ( appendResult20_g52298 + PivotsOnly105_g52298 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52301 = On20_g52301;
				#else
				float3 staticSwitch14_g52301 = Off19_g52301;
				#endif
				half3 ObjectData20_g52302 = staticSwitch14_g52301;
				half3 WorldData19_g52302 = Off19_g52301;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52302 = WorldData19_g52302;
				#else
				float3 staticSwitch14_g52302 = ObjectData20_g52302;
				#endif
				float3 temp_output_42_0_g52298 = staticSwitch14_g52302;
				half3 ObjectData20_g52297 = temp_output_42_0_g52298;
				half3 WorldData19_g52297 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52297 = WorldData19_g52297;
				#else
				float3 staticSwitch14_g52297 = ObjectData20_g52297;
				#endif
				#ifdef TVE_IS_GRASS_SHADER
				float2 staticSwitch164_g52296 = (ase_worldPos).xz;
				#else
				float2 staticSwitch164_g52296 = (staticSwitch14_g52297).xz;
				#endif
				#ifdef TVE_IS_GRASS_SHADER
				float staticSwitch161_g52296 = TVE_NoiseSize_Grass;
				#else
				float staticSwitch161_g52296 = TVE_NoiseSize_Vegetation;
				#endif
				float2 panner73_g52296 = ( _TimeParameters.x * staticSwitch160_g52296 + ( staticSwitch164_g52296 * staticSwitch161_g52296 ));
				float4 tex2DNode75_g52296 = SAMPLE_TEXTURE2D_LOD( TVE_NoiseTex, samplerTVE_NoiseTex, panner73_g52296, 0.0 );
				float4 saferPower77_g52296 = max( abs( tex2DNode75_g52296 ) , 0.0001 );
				half Wind_Power2223_g51941 = Wind_Power369_g52303;
				float temp_output_167_0_g52296 = Wind_Power2223_g51941;
				float lerpResult168_g52296 = lerp( 1.5 , 0.25 , temp_output_167_0_g52296);
				float4 temp_cast_7 = (lerpResult168_g52296).xxxx;
				float4 break142_g52296 = pow( saferPower77_g52296 , temp_cast_7 );
				half Global_NoiseTex_R34_g51941 = break142_g52296.r;
				half Input_Speed62_g52276 = _MotionSpeed_20;
				float mulTime354_g52276 = _TimeParameters.x * Input_Speed62_g52276;
				float4x4 break19_g52214 = GetObjectToWorldMatrix();
				float3 appendResult20_g52214 = (float3(break19_g52214[ 0 ][ 3 ] , break19_g52214[ 1 ][ 3 ] , break19_g52214[ 2 ][ 3 ]));
				half3 Off19_g52217 = appendResult20_g52214;
				float3 appendResult93_g52214 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52214 = ( appendResult93_g52214 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52214 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52214 , 0.0 ) ).xyz).xyz;
				half3 On20_g52217 = ( appendResult20_g52214 + PivotsOnly105_g52214 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52217 = On20_g52217;
				#else
				float3 staticSwitch14_g52217 = Off19_g52217;
				#endif
				half3 ObjectData20_g52218 = staticSwitch14_g52217;
				half3 WorldData19_g52218 = Off19_g52217;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52218 = WorldData19_g52218;
				#else
				float3 staticSwitch14_g52218 = ObjectData20_g52218;
				#endif
				float3 temp_output_42_0_g52214 = staticSwitch14_g52218;
				float3 break9_g52214 = temp_output_42_0_g52214;
				half Variation_Complex102_g52212 = frac( ( v.ase_color.r + ( break9_g52214.x + break9_g52214.z ) ) );
				float ObjectData20_g52213 = Variation_Complex102_g52212;
				half Variation_Simple105_g52212 = v.ase_color.r;
				float WorldData19_g52213 = Variation_Simple105_g52212;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52213 = WorldData19_g52213;
				#else
				float staticSwitch14_g52213 = ObjectData20_g52213;
				#endif
				half Motion_Variation3073_g51941 = staticSwitch14_g52213;
				float temp_output_3154_0_g51941 = ( _MotionVariation_20 * Motion_Variation3073_g51941 );
				float Motion_Variation284_g52276 = temp_output_3154_0_g51941;
				float Motion_Scale287_g52276 = ( _MotionScale_20 * ase_worldPos.x );
				half Variation127_g52292 = temp_output_3154_0_g51941;
				float lerpResult110_g52292 = lerp( ceil( saturate( ( frac( ( Variation127_g52292 + 0.3576 ) ) - 0.6 ) ) ) , ceil( saturate( ( frac( ( Variation127_g52292 + 0.1715 ) ) - 0.4 ) ) ) , (sin( _TimeParameters.x )*0.5 + 0.5));
				float temp_output_112_0_g52292 = Wind_Power2223_g51941;
				float lerpResult111_g52292 = lerp( lerpResult110_g52292 , 1.0 , ( temp_output_112_0_g52292 * temp_output_112_0_g52292 * temp_output_112_0_g52292 * temp_output_112_0_g52292 ));
				float lerpResult126_g52292 = lerp( lerpResult111_g52292 , 1.0 , ( 1.0 - saturate( Variation127_g52292 ) ));
				half Motion_Rolling138_g51941 = ( ( _MotionAmplitude_20 * Motion_Max_Rolling1137_g51941 ) * ( Wind_Power_203109_g51941 * Mesh_Motion_260_g51941 * Global_NoiseTex_R34_g51941 * _VertexRollingMode ) * sin( ( mulTime354_g52276 + Motion_Variation284_g52276 + Motion_Scale287_g52276 ) ) * lerpResult126_g52292 );
				half Angle44_g52293 = Motion_Rolling138_g51941;
				half3 VertexPos40_g52260 = ( VertexPosRotationAxis50_g52293 + ( VertexPosOtherAxis82_g52293 * cos( Angle44_g52293 ) ) + ( cross( float3(0,1,0) , VertexPosOtherAxis82_g52293 ) * sin( Angle44_g52293 ) ) );
				float3 appendResult74_g52260 = (float3(VertexPos40_g52260.x , 0.0 , 0.0));
				half3 VertexPosRotationAxis50_g52260 = appendResult74_g52260;
				float3 break84_g52260 = VertexPos40_g52260;
				float3 appendResult81_g52260 = (float3(0.0 , break84_g52260.y , break84_g52260.z));
				half3 VertexPosOtherAxis82_g52260 = appendResult81_g52260;
				float ObjectData20_g52309 = 3.14;
				float Bounds_Height374_g51941 = _MaxBoundsInfo.y;
				float WorldData19_g52309 = ( Bounds_Height374_g51941 * 3.14 );
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52309 = WorldData19_g52309;
				#else
				float staticSwitch14_g52309 = ObjectData20_g52309;
				#endif
				float Motion_Max_Bending1133_g51941 = staticSwitch14_g52309;
				float lerpResult376_g52303 = lerp( 0.1 , 1.0 , Wind_Power369_g52303);
				half Wind_Power_103106_g51941 = lerpResult376_g52303;
				float3 appendResult397_g52303 = (float3(break322_g52303.x , 0.0 , break322_g52303.y));
				float3 temp_output_398_0_g52303 = (appendResult397_g52303*2.0 + -1.0);
				float3 ase_parentObjectScale = ( 1.0 / float3( length( GetWorldToObjectMatrix()[ 0 ].xyz ), length( GetWorldToObjectMatrix()[ 1 ].xyz ), length( GetWorldToObjectMatrix()[ 2 ].xyz ) ) );
				float3 temp_output_339_0_g52303 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_398_0_g52303 , 0.0 ) ).xyz * ase_parentObjectScale );
				half2 Wind_DirectionOS39_g51941 = (temp_output_339_0_g52303).xz;
				half Input_Speed62_g52219 = _MotionSpeed_10;
				float mulTime373_g52219 = _TimeParameters.x * Input_Speed62_g52219;
				half Motion_Variation284_g52219 = ( _MotionVariation_10 * Motion_Variation3073_g51941 );
				float2 appendResult344_g52219 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 Motion_Scale287_g52219 = ( _MotionScale_10 * appendResult344_g52219 );
				half2 Sine_MinusOneToOne281_g52219 = sin( ( mulTime373_g52219 + Motion_Variation284_g52219 + Motion_Scale287_g52219 ) );
				float2 temp_cast_12 = (1.0).xx;
				half Input_Turbulence327_g52219 = Global_NoiseTex_R34_g51941;
				float2 lerpResult321_g52219 = lerp( Sine_MinusOneToOne281_g52219 , temp_cast_12 , Input_Turbulence327_g52219);
				half2 Motion_Bending2258_g51941 = ( ( _MotionAmplitude_10 * Motion_Max_Bending1133_g51941 ) * Wind_Power_103106_g51941 * Wind_DirectionOS39_g51941 * Global_NoiseTex_R34_g51941 * lerpResult321_g52219 );
				half Interaction_Amplitude4137_g51941 = _InteractionAmplitude;
				float4x4 break19_g52271 = GetObjectToWorldMatrix();
				float3 appendResult20_g52271 = (float3(break19_g52271[ 0 ][ 3 ] , break19_g52271[ 1 ][ 3 ] , break19_g52271[ 2 ][ 3 ]));
				half3 Off19_g52274 = appendResult20_g52271;
				float3 appendResult93_g52271 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52271 = ( appendResult93_g52271 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52271 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52271 , 0.0 ) ).xyz).xyz;
				half3 On20_g52274 = ( appendResult20_g52271 + PivotsOnly105_g52271 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52274 = On20_g52274;
				#else
				float3 staticSwitch14_g52274 = Off19_g52274;
				#endif
				half3 ObjectData20_g52275 = staticSwitch14_g52274;
				half3 WorldData19_g52275 = Off19_g52274;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52275 = WorldData19_g52275;
				#else
				float3 staticSwitch14_g52275 = ObjectData20_g52275;
				#endif
				float3 temp_output_42_0_g52271 = staticSwitch14_g52275;
				half3 ObjectData20_g52270 = temp_output_42_0_g52271;
				half3 WorldData19_g52270 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52270 = WorldData19_g52270;
				#else
				float3 staticSwitch14_g52270 = ObjectData20_g52270;
				#endif
				float3 Position83_g52269 = staticSwitch14_g52270;
				float temp_output_84_0_g52269 = _LayerReactValue;
				float4 lerpResult87_g52269 = lerp( TVE_ReactParams , SAMPLE_TEXTURE2D_ARRAY_LOD( TVE_ReactTex, samplerTVE_ReactTex, ( (TVE_ReactCoord).zw + ( (TVE_ReactCoord).xy * (Position83_g52269).xz ) ),temp_output_84_0_g52269, 0.0 ) , TVE_ReactUsage[(int)temp_output_84_0_g52269]);
				half4 Global_React_Params4173_g51941 = lerpResult87_g52269;
				float4 break322_g52256 = Global_React_Params4173_g51941;
				half Interaction_Mask66_g51941 = break322_g52256.z;
				float3 appendResult397_g52256 = (float3(break322_g52256.x , 0.0 , break322_g52256.y));
				float3 temp_output_398_0_g52256 = (appendResult397_g52256*2.0 + -1.0);
				float3 temp_output_339_0_g52256 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_398_0_g52256 , 0.0 ) ).xyz * ase_parentObjectScale );
				half2 Interaction_DirectionOS4158_g51941 = (temp_output_339_0_g52256).xz;
				float lerpResult3307_g51941 = lerp( 1.0 , Motion_Variation3073_g51941 , _InteractionVariation);
				half2 Motion_Interaction53_g51941 = ( Interaction_Amplitude4137_g51941 * Motion_Max_Bending1133_g51941 * Interaction_Mask66_g51941 * Interaction_Mask66_g51941 * Interaction_DirectionOS4158_g51941 * lerpResult3307_g51941 );
				float2 lerpResult109_g51941 = lerp( Motion_Bending2258_g51941 , Motion_Interaction53_g51941 , ( Interaction_Mask66_g51941 * saturate( Interaction_Amplitude4137_g51941 ) ));
				half Mesh_Motion_182_g51941 = v.ase_texcoord3.x;
				float2 break143_g51941 = ( lerpResult109_g51941 * Mesh_Motion_182_g51941 );
				half Motion_Z190_g51941 = break143_g51941.y;
				half Angle44_g52260 = Motion_Z190_g51941;
				half3 VertexPos40_g52259 = ( VertexPosRotationAxis50_g52260 + ( VertexPosOtherAxis82_g52260 * cos( Angle44_g52260 ) ) + ( cross( float3(1,0,0) , VertexPosOtherAxis82_g52260 ) * sin( Angle44_g52260 ) ) );
				float3 appendResult74_g52259 = (float3(0.0 , 0.0 , VertexPos40_g52259.z));
				half3 VertexPosRotationAxis50_g52259 = appendResult74_g52259;
				float3 break84_g52259 = VertexPos40_g52259;
				float3 appendResult81_g52259 = (float3(break84_g52259.x , break84_g52259.y , 0.0));
				half3 VertexPosOtherAxis82_g52259 = appendResult81_g52259;
				half Motion_X216_g51941 = break143_g51941.x;
				half Angle44_g52259 = -Motion_X216_g51941;
				float3 Vertex_Motion_Object833_g51941 = ( VertexPosRotationAxis50_g52259 + ( VertexPosOtherAxis82_g52259 * cos( Angle44_g52259 ) ) + ( cross( float3(0,0,1) , VertexPosOtherAxis82_g52259 ) * sin( Angle44_g52259 ) ) );
				float3 temp_output_3474_0_g51941 = ( PositionOS3588_g51941 - Mesh_PivotsOS2291_g51941 );
				float3 appendResult2047_g51941 = (float3(Motion_Rolling138_g51941 , 0.0 , -Motion_Rolling138_g51941));
				float3 appendResult2043_g51941 = (float3(Motion_X216_g51941 , 0.0 , Motion_Z190_g51941));
				float3 Vertex_Motion_World1118_g51941 = ( ( temp_output_3474_0_g51941 + appendResult2047_g51941 ) + appendResult2043_g51941 );
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch3312_g51941 = Vertex_Motion_World1118_g51941;
				#else
				float3 staticSwitch3312_g51941 = ( Vertex_Motion_Object833_g51941 + ( 0.0 * _VertexDataMode ) );
				#endif
				half Global_Vertex_Size174_g51941 = break322_g52256.w;
				float lerpResult346_g51941 = lerp( 1.0 , Global_Vertex_Size174_g51941 , _GlobalSize);
				float3 appendResult3480_g51941 = (float3(lerpResult346_g51941 , lerpResult346_g51941 , lerpResult346_g51941));
				half3 ObjectData20_g52294 = appendResult3480_g51941;
				half3 _Vector11 = half3(1,1,1);
				half3 WorldData19_g52294 = _Vector11;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52294 = WorldData19_g52294;
				#else
				float3 staticSwitch14_g52294 = ObjectData20_g52294;
				#endif
				half3 Vertex_Size1741_g51941 = staticSwitch14_g52294;
				half3 _Vector5 = half3(1,1,1);
				float3 Vertex_SizeFade1740_g51941 = _Vector5;
				half3 Grass_Coverage2661_g51941 = half3(0,0,0);
				float3 Final_VertexPosition890_g51941 = ( ( staticSwitch3312_g51941 * Vertex_Size1741_g51941 * Vertex_SizeFade1740_g51941 ) + Mesh_PivotsOS2291_g51941 + Grass_Coverage2661_g51941 );
				
				float temp_output_7_0_g52252 = TVE_CameraFadeStart;
				float saferPower3976_g51941 = max( saturate( ( ( distance( ase_worldPos , _WorldSpaceCameraPos ) - temp_output_7_0_g52252 ) / ( TVE_CameraFadeEnd - temp_output_7_0_g52252 ) ) ) , 0.0001 );
				float temp_output_3976_0_g51941 = pow( saferPower3976_g51941 , _FadeCameraValue );
				float vertexToFrag11_g52251 = temp_output_3976_0_g51941;
				o.ase_texcoord2.x = vertexToFrag11_g52251;
				float3 vertexToFrag3890_g51941 = ase_worldPos;
				o.ase_texcoord2.yzw = vertexToFrag3890_g51941;
				float2 vertexToFrag11_g52308 = ( ( v.ase_texcoord.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				o.ase_texcoord3.xy = vertexToFrag11_g52308;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = Final_VertexPosition890_g51941;
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
				float4 ase_texcoord3 : TEXCOORD3;
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
				o.ase_texcoord = v.ase_texcoord;
				o.ase_texcoord3 = v.ase_texcoord3;
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
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_texcoord3 = patch[0].ase_texcoord3 * bary.x + patch[1].ase_texcoord3 * bary.y + patch[2].ase_texcoord3 * bary.z;
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

				float localCustomAlphaClip3735_g51941 = ( 0.0 );
				float vertexToFrag11_g52251 = IN.ase_texcoord2.x;
				half Fade_Camera3743_g51941 = vertexToFrag11_g52251;
				half Final_AlphaFade3727_g51941 = ( 1.0 * Fade_Camera3743_g51941 );
				float temp_output_41_0_g52255 = Final_AlphaFade3727_g51941;
				float3 vertexToFrag3890_g51941 = IN.ase_texcoord2.yzw;
				float3 PositionWS_PerVertex3905_g51941 = vertexToFrag3890_g51941;
				float2 vertexToFrag11_g52308 = IN.ase_texcoord3.xy;
				half2 Main_UVs15_g51941 = vertexToFrag11_g52308;
				float4 tex2DNode29_g51941 = SAMPLE_TEXTURE2D( _MainAlbedoTex, sampler_MainAlbedoTex, Main_UVs15_g51941 );
				float Main_Alpha316_g51941 = ( _MainColor.a * tex2DNode29_g51941.a );
				half AlphaTreshold2132_g51941 = _Cutoff;
				#ifdef TVE_ALPHA_CLIP
				float staticSwitch3792_g51941 = ( Main_Alpha316_g51941 - ( AlphaTreshold2132_g51941 - 0.5 ) );
				#else
				float staticSwitch3792_g51941 = Main_Alpha316_g51941;
				#endif
				half Final_Alpha3754_g51941 = staticSwitch3792_g51941;
				float temp_output_661_0_g51941 = ( saturate( ( temp_output_41_0_g52255 + ( temp_output_41_0_g52255 * SAMPLE_TEXTURE3D( TVE_ScreenTex3D, samplerTVE_ScreenTex3D, ( TVE_ScreenTexCoord * PositionWS_PerVertex3905_g51941 ) ).r ) ) ) * Final_Alpha3754_g51941 );
				float Alpha3735_g51941 = temp_output_661_0_g51941;
				float Treshold3735_g51941 = 0.5;
				{
				#if TVE_ALPHA_CLIP
				clip(Alpha3735_g51941 - Treshold3735_g51941);
				#endif
				}
				half Final_Clip914_g51941 = saturate( Alpha3735_g51941 );
				
				float Alpha = Final_Clip914_g51941;
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
			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define ASE_ABSOLUTE_VERTEX_POS 1
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

			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local TVE_ALPHA_CLIP
			#pragma shader_feature_local TVE_VERTEX_DATA_BATCHED
			//TVE Pipeline Defines
			#define THE_VEGETATION_ENGINE
			#define IS_UNIVERSAL_PIPELINE
			//TVE Shader Type Defines
			#define TVE_IS_VEGETATION_SHADER
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
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			half4 _SecondUVs;
			half4 _VertexOcclusionColor;
			float4 _SubsurfaceDiffusion_Asset;
			half4 _SecondColor;
			half4 _EmissiveColor;
			float4 _NoiseMaskRemap;
			half4 _ColorsMaskRemap;
			half4 _SubsurfaceMaskRemap;
			half4 _OverlayMaskRemap;
			float4 _GradientMaskRemap;
			half4 _VertexOcclusionRemap;
			half4 _DetailBlendRemap;
			float4 _Color;
			half4 _MainColor;
			half4 _MainUVs;
			float4 _MaxBoundsInfo;
			half4 _EmissiveUVs;
			float4 _SubsurfaceDiffusion_asset;
			half3 _render_normals_options;
			half _VertexDataMode;
			half _InteractionAmplitude;
			half _GlobalSize;
			half _InteractionVariation;
			half _LayerReactValue;
			half _MotionVariation_20;
			half _MotionVariation_10;
			float _MotionSpeed_10;
			half _MotionAmplitude_10;
			half _MotionScale_20;
			half _MotionSpeed_20;
			half _VertexRollingMode;
			half _LayerMotionValue;
			half _vertex_pivot_mode;
			half _MotionAmplitude_20;
			float _MotionScale_10;
			half _render_dst;
			half _OverlayBottomValue;
			half _DetailMaskMode;
			half _MainOcclusionValue;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half _RenderSpecular;
			half _GlobalEmissive;
			half _DetailNormalValue;
			half _SecondNormalValue;
			half _VertexOcclusionMaxValue;
			half _VertexOcclusionMinValue;
			half _OverlayMaskMaxValue;
			half _OverlayMaskMinValue;
			half _LayerExtrasValue;
			half _GlobalOverlay;
			half _MainNormalValue;
			half _EmissiveFlagMode;
			half _DetailBlendMaxValue;
			half _DetailBlendMinValue;
			half _DetailMaskInvertMode;
			half _DetailMeshValue;
			half _RenderMode;
			float _SubsurfaceDiffusion;
			half _RenderDecals;
			half _RenderPriority;
			half _TranslucencyIntensityValue;
			half _EmissiveCat;
			half _ReceiveSpace;
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
			half _IsBarkShader;
			half _IsStandardShader;
			half _render_src;
			half _render_cull;
			half _render_zw;
			half _NoiseCat;
			half _SizeFadeCat;
			half _TranslucencyAmbientValue;
			half _VertexMasksMode;
			half _RenderZWrite;
			half _TranslucencyShadowValue;
			half _RenderSSR;
			half _SecondOcclusionValue;
			half _MotionSpace;
			half _RenderCull;
			half _PerspectiveCat;
			half _VertexVariationMode;
			half _GradientCat;
			half _TranslucencyDirectValue;
			half _FadeSpace;
			half _GlobalCat;
			half _IsTVEShader;
			half _DetailSpace;
			half _DetailTypeMode;
			half _DetailCat;
			half _TranslucencyScatteringValue;
			half _TranslucencyNormalValue;
			half _RenderClip;
			half _IsVersion;
			half _RenderingCat;
			half _VariationMotionMessage;
			half _FadeCameraValue;
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
			half4 TVE_MotionParams;
			TEXTURE2D_ARRAY(TVE_MotionTex);
			half4 TVE_MotionCoord;
			SAMPLER(samplerTVE_MotionTex);
			float TVE_MotionUsage[9];
			TEXTURE2D(TVE_NoiseTex);
			float2 TVE_NoiseSpeed_Vegetation;
			float2 TVE_NoiseSpeed_Grass;
			half TVE_NoiseSize_Vegetation;
			half TVE_NoiseSize_Grass;
			SAMPLER(samplerTVE_NoiseTex);
			half4 TVE_ReactParams;
			TEXTURE2D_ARRAY(TVE_ReactTex);
			half4 TVE_ReactCoord;
			SAMPLER(samplerTVE_ReactTex);
			float TVE_ReactUsage[9];
			half TVE_CameraFadeStart;
			half TVE_CameraFadeEnd;
			TEXTURE3D(TVE_ScreenTex3D);
			half TVE_ScreenTexCoord;
			SAMPLER(samplerTVE_ScreenTex3D);
			TEXTURE2D(_MainAlbedoTex);
			SAMPLER(sampler_MainAlbedoTex);


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 PositionOS3588_g51941 = v.vertex.xyz;
				half3 _Vector1 = half3(0,0,0);
				half3 Mesh_PivotsOS2291_g51941 = _Vector1;
				float3 temp_output_2283_0_g51941 = ( PositionOS3588_g51941 - Mesh_PivotsOS2291_g51941 );
				half3 VertexPos40_g52293 = temp_output_2283_0_g51941;
				float3 appendResult74_g52293 = (float3(0.0 , VertexPos40_g52293.y , 0.0));
				float3 VertexPosRotationAxis50_g52293 = appendResult74_g52293;
				float3 break84_g52293 = VertexPos40_g52293;
				float3 appendResult81_g52293 = (float3(break84_g52293.x , 0.0 , break84_g52293.z));
				float3 VertexPosOtherAxis82_g52293 = appendResult81_g52293;
				float ObjectData20_g52239 = 3.14;
				float Bounds_Radius121_g51941 = _MaxBoundsInfo.x;
				float WorldData19_g52239 = Bounds_Radius121_g51941;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52239 = WorldData19_g52239;
				#else
				float staticSwitch14_g52239 = ObjectData20_g52239;
				#endif
				float Motion_Max_Rolling1137_g51941 = staticSwitch14_g52239;
				float4x4 break19_g52279 = GetObjectToWorldMatrix();
				float3 appendResult20_g52279 = (float3(break19_g52279[ 0 ][ 3 ] , break19_g52279[ 1 ][ 3 ] , break19_g52279[ 2 ][ 3 ]));
				half3 Off19_g52282 = appendResult20_g52279;
				float3 appendResult93_g52279 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52279 = ( appendResult93_g52279 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52279 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52279 , 0.0 ) ).xyz).xyz;
				half3 On20_g52282 = ( appendResult20_g52279 + PivotsOnly105_g52279 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52282 = On20_g52282;
				#else
				float3 staticSwitch14_g52282 = Off19_g52282;
				#endif
				half3 ObjectData20_g52283 = staticSwitch14_g52282;
				half3 WorldData19_g52283 = Off19_g52282;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52283 = WorldData19_g52283;
				#else
				float3 staticSwitch14_g52283 = ObjectData20_g52283;
				#endif
				float3 temp_output_42_0_g52279 = staticSwitch14_g52283;
				half3 ObjectData20_g52278 = temp_output_42_0_g52279;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				half3 WorldData19_g52278 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52278 = WorldData19_g52278;
				#else
				float3 staticSwitch14_g52278 = ObjectData20_g52278;
				#endif
				float3 Position83_g52277 = staticSwitch14_g52278;
				float temp_output_84_0_g52277 = _LayerMotionValue;
				float4 lerpResult87_g52277 = lerp( TVE_MotionParams , SAMPLE_TEXTURE2D_ARRAY_LOD( TVE_MotionTex, samplerTVE_MotionTex, ( (TVE_MotionCoord).zw + ( (TVE_MotionCoord).xy * (Position83_g52277).xz ) ),temp_output_84_0_g52277, 0.0 ) , TVE_MotionUsage[(int)temp_output_84_0_g52277]);
				half4 Global_Motion_Params3909_g51941 = lerpResult87_g52277;
				float4 break322_g52303 = Global_Motion_Params3909_g51941;
				half Wind_Power369_g52303 = break322_g52303.z;
				float lerpResult410_g52303 = lerp( 0.2 , 1.0 , Wind_Power369_g52303);
				half Wind_Power_203109_g51941 = lerpResult410_g52303;
				half Mesh_Motion_260_g51941 = v.ase_texcoord3.y;
				#ifdef TVE_IS_GRASS_SHADER
				float2 staticSwitch160_g52296 = TVE_NoiseSpeed_Grass;
				#else
				float2 staticSwitch160_g52296 = TVE_NoiseSpeed_Vegetation;
				#endif
				float4x4 break19_g52298 = GetObjectToWorldMatrix();
				float3 appendResult20_g52298 = (float3(break19_g52298[ 0 ][ 3 ] , break19_g52298[ 1 ][ 3 ] , break19_g52298[ 2 ][ 3 ]));
				half3 Off19_g52301 = appendResult20_g52298;
				float3 appendResult93_g52298 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52298 = ( appendResult93_g52298 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52298 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52298 , 0.0 ) ).xyz).xyz;
				half3 On20_g52301 = ( appendResult20_g52298 + PivotsOnly105_g52298 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52301 = On20_g52301;
				#else
				float3 staticSwitch14_g52301 = Off19_g52301;
				#endif
				half3 ObjectData20_g52302 = staticSwitch14_g52301;
				half3 WorldData19_g52302 = Off19_g52301;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52302 = WorldData19_g52302;
				#else
				float3 staticSwitch14_g52302 = ObjectData20_g52302;
				#endif
				float3 temp_output_42_0_g52298 = staticSwitch14_g52302;
				half3 ObjectData20_g52297 = temp_output_42_0_g52298;
				half3 WorldData19_g52297 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52297 = WorldData19_g52297;
				#else
				float3 staticSwitch14_g52297 = ObjectData20_g52297;
				#endif
				#ifdef TVE_IS_GRASS_SHADER
				float2 staticSwitch164_g52296 = (ase_worldPos).xz;
				#else
				float2 staticSwitch164_g52296 = (staticSwitch14_g52297).xz;
				#endif
				#ifdef TVE_IS_GRASS_SHADER
				float staticSwitch161_g52296 = TVE_NoiseSize_Grass;
				#else
				float staticSwitch161_g52296 = TVE_NoiseSize_Vegetation;
				#endif
				float2 panner73_g52296 = ( _TimeParameters.x * staticSwitch160_g52296 + ( staticSwitch164_g52296 * staticSwitch161_g52296 ));
				float4 tex2DNode75_g52296 = SAMPLE_TEXTURE2D_LOD( TVE_NoiseTex, samplerTVE_NoiseTex, panner73_g52296, 0.0 );
				float4 saferPower77_g52296 = max( abs( tex2DNode75_g52296 ) , 0.0001 );
				half Wind_Power2223_g51941 = Wind_Power369_g52303;
				float temp_output_167_0_g52296 = Wind_Power2223_g51941;
				float lerpResult168_g52296 = lerp( 1.5 , 0.25 , temp_output_167_0_g52296);
				float4 temp_cast_7 = (lerpResult168_g52296).xxxx;
				float4 break142_g52296 = pow( saferPower77_g52296 , temp_cast_7 );
				half Global_NoiseTex_R34_g51941 = break142_g52296.r;
				half Input_Speed62_g52276 = _MotionSpeed_20;
				float mulTime354_g52276 = _TimeParameters.x * Input_Speed62_g52276;
				float4x4 break19_g52214 = GetObjectToWorldMatrix();
				float3 appendResult20_g52214 = (float3(break19_g52214[ 0 ][ 3 ] , break19_g52214[ 1 ][ 3 ] , break19_g52214[ 2 ][ 3 ]));
				half3 Off19_g52217 = appendResult20_g52214;
				float3 appendResult93_g52214 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52214 = ( appendResult93_g52214 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52214 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52214 , 0.0 ) ).xyz).xyz;
				half3 On20_g52217 = ( appendResult20_g52214 + PivotsOnly105_g52214 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52217 = On20_g52217;
				#else
				float3 staticSwitch14_g52217 = Off19_g52217;
				#endif
				half3 ObjectData20_g52218 = staticSwitch14_g52217;
				half3 WorldData19_g52218 = Off19_g52217;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52218 = WorldData19_g52218;
				#else
				float3 staticSwitch14_g52218 = ObjectData20_g52218;
				#endif
				float3 temp_output_42_0_g52214 = staticSwitch14_g52218;
				float3 break9_g52214 = temp_output_42_0_g52214;
				half Variation_Complex102_g52212 = frac( ( v.ase_color.r + ( break9_g52214.x + break9_g52214.z ) ) );
				float ObjectData20_g52213 = Variation_Complex102_g52212;
				half Variation_Simple105_g52212 = v.ase_color.r;
				float WorldData19_g52213 = Variation_Simple105_g52212;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52213 = WorldData19_g52213;
				#else
				float staticSwitch14_g52213 = ObjectData20_g52213;
				#endif
				half Motion_Variation3073_g51941 = staticSwitch14_g52213;
				float temp_output_3154_0_g51941 = ( _MotionVariation_20 * Motion_Variation3073_g51941 );
				float Motion_Variation284_g52276 = temp_output_3154_0_g51941;
				float Motion_Scale287_g52276 = ( _MotionScale_20 * ase_worldPos.x );
				half Variation127_g52292 = temp_output_3154_0_g51941;
				float lerpResult110_g52292 = lerp( ceil( saturate( ( frac( ( Variation127_g52292 + 0.3576 ) ) - 0.6 ) ) ) , ceil( saturate( ( frac( ( Variation127_g52292 + 0.1715 ) ) - 0.4 ) ) ) , (sin( _TimeParameters.x )*0.5 + 0.5));
				float temp_output_112_0_g52292 = Wind_Power2223_g51941;
				float lerpResult111_g52292 = lerp( lerpResult110_g52292 , 1.0 , ( temp_output_112_0_g52292 * temp_output_112_0_g52292 * temp_output_112_0_g52292 * temp_output_112_0_g52292 ));
				float lerpResult126_g52292 = lerp( lerpResult111_g52292 , 1.0 , ( 1.0 - saturate( Variation127_g52292 ) ));
				half Motion_Rolling138_g51941 = ( ( _MotionAmplitude_20 * Motion_Max_Rolling1137_g51941 ) * ( Wind_Power_203109_g51941 * Mesh_Motion_260_g51941 * Global_NoiseTex_R34_g51941 * _VertexRollingMode ) * sin( ( mulTime354_g52276 + Motion_Variation284_g52276 + Motion_Scale287_g52276 ) ) * lerpResult126_g52292 );
				half Angle44_g52293 = Motion_Rolling138_g51941;
				half3 VertexPos40_g52260 = ( VertexPosRotationAxis50_g52293 + ( VertexPosOtherAxis82_g52293 * cos( Angle44_g52293 ) ) + ( cross( float3(0,1,0) , VertexPosOtherAxis82_g52293 ) * sin( Angle44_g52293 ) ) );
				float3 appendResult74_g52260 = (float3(VertexPos40_g52260.x , 0.0 , 0.0));
				half3 VertexPosRotationAxis50_g52260 = appendResult74_g52260;
				float3 break84_g52260 = VertexPos40_g52260;
				float3 appendResult81_g52260 = (float3(0.0 , break84_g52260.y , break84_g52260.z));
				half3 VertexPosOtherAxis82_g52260 = appendResult81_g52260;
				float ObjectData20_g52309 = 3.14;
				float Bounds_Height374_g51941 = _MaxBoundsInfo.y;
				float WorldData19_g52309 = ( Bounds_Height374_g51941 * 3.14 );
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52309 = WorldData19_g52309;
				#else
				float staticSwitch14_g52309 = ObjectData20_g52309;
				#endif
				float Motion_Max_Bending1133_g51941 = staticSwitch14_g52309;
				float lerpResult376_g52303 = lerp( 0.1 , 1.0 , Wind_Power369_g52303);
				half Wind_Power_103106_g51941 = lerpResult376_g52303;
				float3 appendResult397_g52303 = (float3(break322_g52303.x , 0.0 , break322_g52303.y));
				float3 temp_output_398_0_g52303 = (appendResult397_g52303*2.0 + -1.0);
				float3 ase_parentObjectScale = ( 1.0 / float3( length( GetWorldToObjectMatrix()[ 0 ].xyz ), length( GetWorldToObjectMatrix()[ 1 ].xyz ), length( GetWorldToObjectMatrix()[ 2 ].xyz ) ) );
				float3 temp_output_339_0_g52303 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_398_0_g52303 , 0.0 ) ).xyz * ase_parentObjectScale );
				half2 Wind_DirectionOS39_g51941 = (temp_output_339_0_g52303).xz;
				half Input_Speed62_g52219 = _MotionSpeed_10;
				float mulTime373_g52219 = _TimeParameters.x * Input_Speed62_g52219;
				half Motion_Variation284_g52219 = ( _MotionVariation_10 * Motion_Variation3073_g51941 );
				float2 appendResult344_g52219 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 Motion_Scale287_g52219 = ( _MotionScale_10 * appendResult344_g52219 );
				half2 Sine_MinusOneToOne281_g52219 = sin( ( mulTime373_g52219 + Motion_Variation284_g52219 + Motion_Scale287_g52219 ) );
				float2 temp_cast_12 = (1.0).xx;
				half Input_Turbulence327_g52219 = Global_NoiseTex_R34_g51941;
				float2 lerpResult321_g52219 = lerp( Sine_MinusOneToOne281_g52219 , temp_cast_12 , Input_Turbulence327_g52219);
				half2 Motion_Bending2258_g51941 = ( ( _MotionAmplitude_10 * Motion_Max_Bending1133_g51941 ) * Wind_Power_103106_g51941 * Wind_DirectionOS39_g51941 * Global_NoiseTex_R34_g51941 * lerpResult321_g52219 );
				half Interaction_Amplitude4137_g51941 = _InteractionAmplitude;
				float4x4 break19_g52271 = GetObjectToWorldMatrix();
				float3 appendResult20_g52271 = (float3(break19_g52271[ 0 ][ 3 ] , break19_g52271[ 1 ][ 3 ] , break19_g52271[ 2 ][ 3 ]));
				half3 Off19_g52274 = appendResult20_g52271;
				float3 appendResult93_g52271 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52271 = ( appendResult93_g52271 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52271 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52271 , 0.0 ) ).xyz).xyz;
				half3 On20_g52274 = ( appendResult20_g52271 + PivotsOnly105_g52271 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52274 = On20_g52274;
				#else
				float3 staticSwitch14_g52274 = Off19_g52274;
				#endif
				half3 ObjectData20_g52275 = staticSwitch14_g52274;
				half3 WorldData19_g52275 = Off19_g52274;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52275 = WorldData19_g52275;
				#else
				float3 staticSwitch14_g52275 = ObjectData20_g52275;
				#endif
				float3 temp_output_42_0_g52271 = staticSwitch14_g52275;
				half3 ObjectData20_g52270 = temp_output_42_0_g52271;
				half3 WorldData19_g52270 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52270 = WorldData19_g52270;
				#else
				float3 staticSwitch14_g52270 = ObjectData20_g52270;
				#endif
				float3 Position83_g52269 = staticSwitch14_g52270;
				float temp_output_84_0_g52269 = _LayerReactValue;
				float4 lerpResult87_g52269 = lerp( TVE_ReactParams , SAMPLE_TEXTURE2D_ARRAY_LOD( TVE_ReactTex, samplerTVE_ReactTex, ( (TVE_ReactCoord).zw + ( (TVE_ReactCoord).xy * (Position83_g52269).xz ) ),temp_output_84_0_g52269, 0.0 ) , TVE_ReactUsage[(int)temp_output_84_0_g52269]);
				half4 Global_React_Params4173_g51941 = lerpResult87_g52269;
				float4 break322_g52256 = Global_React_Params4173_g51941;
				half Interaction_Mask66_g51941 = break322_g52256.z;
				float3 appendResult397_g52256 = (float3(break322_g52256.x , 0.0 , break322_g52256.y));
				float3 temp_output_398_0_g52256 = (appendResult397_g52256*2.0 + -1.0);
				float3 temp_output_339_0_g52256 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_398_0_g52256 , 0.0 ) ).xyz * ase_parentObjectScale );
				half2 Interaction_DirectionOS4158_g51941 = (temp_output_339_0_g52256).xz;
				float lerpResult3307_g51941 = lerp( 1.0 , Motion_Variation3073_g51941 , _InteractionVariation);
				half2 Motion_Interaction53_g51941 = ( Interaction_Amplitude4137_g51941 * Motion_Max_Bending1133_g51941 * Interaction_Mask66_g51941 * Interaction_Mask66_g51941 * Interaction_DirectionOS4158_g51941 * lerpResult3307_g51941 );
				float2 lerpResult109_g51941 = lerp( Motion_Bending2258_g51941 , Motion_Interaction53_g51941 , ( Interaction_Mask66_g51941 * saturate( Interaction_Amplitude4137_g51941 ) ));
				half Mesh_Motion_182_g51941 = v.ase_texcoord3.x;
				float2 break143_g51941 = ( lerpResult109_g51941 * Mesh_Motion_182_g51941 );
				half Motion_Z190_g51941 = break143_g51941.y;
				half Angle44_g52260 = Motion_Z190_g51941;
				half3 VertexPos40_g52259 = ( VertexPosRotationAxis50_g52260 + ( VertexPosOtherAxis82_g52260 * cos( Angle44_g52260 ) ) + ( cross( float3(1,0,0) , VertexPosOtherAxis82_g52260 ) * sin( Angle44_g52260 ) ) );
				float3 appendResult74_g52259 = (float3(0.0 , 0.0 , VertexPos40_g52259.z));
				half3 VertexPosRotationAxis50_g52259 = appendResult74_g52259;
				float3 break84_g52259 = VertexPos40_g52259;
				float3 appendResult81_g52259 = (float3(break84_g52259.x , break84_g52259.y , 0.0));
				half3 VertexPosOtherAxis82_g52259 = appendResult81_g52259;
				half Motion_X216_g51941 = break143_g51941.x;
				half Angle44_g52259 = -Motion_X216_g51941;
				float3 Vertex_Motion_Object833_g51941 = ( VertexPosRotationAxis50_g52259 + ( VertexPosOtherAxis82_g52259 * cos( Angle44_g52259 ) ) + ( cross( float3(0,0,1) , VertexPosOtherAxis82_g52259 ) * sin( Angle44_g52259 ) ) );
				float3 temp_output_3474_0_g51941 = ( PositionOS3588_g51941 - Mesh_PivotsOS2291_g51941 );
				float3 appendResult2047_g51941 = (float3(Motion_Rolling138_g51941 , 0.0 , -Motion_Rolling138_g51941));
				float3 appendResult2043_g51941 = (float3(Motion_X216_g51941 , 0.0 , Motion_Z190_g51941));
				float3 Vertex_Motion_World1118_g51941 = ( ( temp_output_3474_0_g51941 + appendResult2047_g51941 ) + appendResult2043_g51941 );
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch3312_g51941 = Vertex_Motion_World1118_g51941;
				#else
				float3 staticSwitch3312_g51941 = ( Vertex_Motion_Object833_g51941 + ( 0.0 * _VertexDataMode ) );
				#endif
				half Global_Vertex_Size174_g51941 = break322_g52256.w;
				float lerpResult346_g51941 = lerp( 1.0 , Global_Vertex_Size174_g51941 , _GlobalSize);
				float3 appendResult3480_g51941 = (float3(lerpResult346_g51941 , lerpResult346_g51941 , lerpResult346_g51941));
				half3 ObjectData20_g52294 = appendResult3480_g51941;
				half3 _Vector11 = half3(1,1,1);
				half3 WorldData19_g52294 = _Vector11;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52294 = WorldData19_g52294;
				#else
				float3 staticSwitch14_g52294 = ObjectData20_g52294;
				#endif
				half3 Vertex_Size1741_g51941 = staticSwitch14_g52294;
				half3 _Vector5 = half3(1,1,1);
				float3 Vertex_SizeFade1740_g51941 = _Vector5;
				half3 Grass_Coverage2661_g51941 = half3(0,0,0);
				float3 Final_VertexPosition890_g51941 = ( ( staticSwitch3312_g51941 * Vertex_Size1741_g51941 * Vertex_SizeFade1740_g51941 ) + Mesh_PivotsOS2291_g51941 + Grass_Coverage2661_g51941 );
				
				float temp_output_7_0_g52252 = TVE_CameraFadeStart;
				float saferPower3976_g51941 = max( saturate( ( ( distance( ase_worldPos , _WorldSpaceCameraPos ) - temp_output_7_0_g52252 ) / ( TVE_CameraFadeEnd - temp_output_7_0_g52252 ) ) ) , 0.0001 );
				float temp_output_3976_0_g51941 = pow( saferPower3976_g51941 , _FadeCameraValue );
				float vertexToFrag11_g52251 = temp_output_3976_0_g51941;
				o.ase_texcoord2.x = vertexToFrag11_g52251;
				float3 vertexToFrag3890_g51941 = ase_worldPos;
				o.ase_texcoord2.yzw = vertexToFrag3890_g51941;
				float2 vertexToFrag11_g52308 = ( ( v.ase_texcoord.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				o.ase_texcoord3.xy = vertexToFrag11_g52308;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = Final_VertexPosition890_g51941;
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
				float4 ase_texcoord3 : TEXCOORD3;
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
				o.ase_texcoord = v.ase_texcoord;
				o.ase_texcoord3 = v.ase_texcoord3;
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
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_texcoord3 = patch[0].ase_texcoord3 * bary.x + patch[1].ase_texcoord3 * bary.y + patch[2].ase_texcoord3 * bary.z;
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

				float localCustomAlphaClip3735_g51941 = ( 0.0 );
				float vertexToFrag11_g52251 = IN.ase_texcoord2.x;
				half Fade_Camera3743_g51941 = vertexToFrag11_g52251;
				half Final_AlphaFade3727_g51941 = ( 1.0 * Fade_Camera3743_g51941 );
				float temp_output_41_0_g52255 = Final_AlphaFade3727_g51941;
				float3 vertexToFrag3890_g51941 = IN.ase_texcoord2.yzw;
				float3 PositionWS_PerVertex3905_g51941 = vertexToFrag3890_g51941;
				float2 vertexToFrag11_g52308 = IN.ase_texcoord3.xy;
				half2 Main_UVs15_g51941 = vertexToFrag11_g52308;
				float4 tex2DNode29_g51941 = SAMPLE_TEXTURE2D( _MainAlbedoTex, sampler_MainAlbedoTex, Main_UVs15_g51941 );
				float Main_Alpha316_g51941 = ( _MainColor.a * tex2DNode29_g51941.a );
				half AlphaTreshold2132_g51941 = _Cutoff;
				#ifdef TVE_ALPHA_CLIP
				float staticSwitch3792_g51941 = ( Main_Alpha316_g51941 - ( AlphaTreshold2132_g51941 - 0.5 ) );
				#else
				float staticSwitch3792_g51941 = Main_Alpha316_g51941;
				#endif
				half Final_Alpha3754_g51941 = staticSwitch3792_g51941;
				float temp_output_661_0_g51941 = ( saturate( ( temp_output_41_0_g52255 + ( temp_output_41_0_g52255 * SAMPLE_TEXTURE3D( TVE_ScreenTex3D, samplerTVE_ScreenTex3D, ( TVE_ScreenTexCoord * PositionWS_PerVertex3905_g51941 ) ).r ) ) ) * Final_Alpha3754_g51941 );
				float Alpha3735_g51941 = temp_output_661_0_g51941;
				float Treshold3735_g51941 = 0.5;
				{
				#if TVE_ALPHA_CLIP
				clip(Alpha3735_g51941 - Treshold3735_g51941);
				#endif
				}
				half Final_Clip914_g51941 = saturate( Alpha3735_g51941 );
				
				float Alpha = Final_Clip914_g51941;
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
			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define ASE_ABSOLUTE_VERTEX_POS 1
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

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#pragma shader_feature_local TVE_ALPHA_CLIP
			#pragma shader_feature_local TVE_VERTEX_DATA_BATCHED
			#pragma shader_feature_local TVE_DETAIL_MODE_OFF TVE_DETAIL_MODE_ON
			#pragma shader_feature_local TVE_DETAIL_BLEND_OVERLAY TVE_DETAIL_BLEND_REPLACE
			//TVE Pipeline Defines
			#define THE_VEGETATION_ENGINE
			#define IS_UNIVERSAL_PIPELINE
			//TVE Shader Type Defines
			#define TVE_IS_VEGETATION_SHADER
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
				float4 ase_texcoord3 : TEXCOORD3;
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
				float4 ase_color : COLOR;
				float4 ase_texcoord7 : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			half4 _SecondUVs;
			half4 _VertexOcclusionColor;
			float4 _SubsurfaceDiffusion_Asset;
			half4 _SecondColor;
			half4 _EmissiveColor;
			float4 _NoiseMaskRemap;
			half4 _ColorsMaskRemap;
			half4 _SubsurfaceMaskRemap;
			half4 _OverlayMaskRemap;
			float4 _GradientMaskRemap;
			half4 _VertexOcclusionRemap;
			half4 _DetailBlendRemap;
			float4 _Color;
			half4 _MainColor;
			half4 _MainUVs;
			float4 _MaxBoundsInfo;
			half4 _EmissiveUVs;
			float4 _SubsurfaceDiffusion_asset;
			half3 _render_normals_options;
			half _VertexDataMode;
			half _InteractionAmplitude;
			half _GlobalSize;
			half _InteractionVariation;
			half _LayerReactValue;
			half _MotionVariation_20;
			half _MotionVariation_10;
			float _MotionSpeed_10;
			half _MotionAmplitude_10;
			half _MotionScale_20;
			half _MotionSpeed_20;
			half _VertexRollingMode;
			half _LayerMotionValue;
			half _vertex_pivot_mode;
			half _MotionAmplitude_20;
			float _MotionScale_10;
			half _render_dst;
			half _OverlayBottomValue;
			half _DetailMaskMode;
			half _MainOcclusionValue;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half _RenderSpecular;
			half _GlobalEmissive;
			half _DetailNormalValue;
			half _SecondNormalValue;
			half _VertexOcclusionMaxValue;
			half _VertexOcclusionMinValue;
			half _OverlayMaskMaxValue;
			half _OverlayMaskMinValue;
			half _LayerExtrasValue;
			half _GlobalOverlay;
			half _MainNormalValue;
			half _EmissiveFlagMode;
			half _DetailBlendMaxValue;
			half _DetailBlendMinValue;
			half _DetailMaskInvertMode;
			half _DetailMeshValue;
			half _RenderMode;
			float _SubsurfaceDiffusion;
			half _RenderDecals;
			half _RenderPriority;
			half _TranslucencyIntensityValue;
			half _EmissiveCat;
			half _ReceiveSpace;
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
			half _IsBarkShader;
			half _IsStandardShader;
			half _render_src;
			half _render_cull;
			half _render_zw;
			half _NoiseCat;
			half _SizeFadeCat;
			half _TranslucencyAmbientValue;
			half _VertexMasksMode;
			half _RenderZWrite;
			half _TranslucencyShadowValue;
			half _RenderSSR;
			half _SecondOcclusionValue;
			half _MotionSpace;
			half _RenderCull;
			half _PerspectiveCat;
			half _VertexVariationMode;
			half _GradientCat;
			half _TranslucencyDirectValue;
			half _FadeSpace;
			half _GlobalCat;
			half _IsTVEShader;
			half _DetailSpace;
			half _DetailTypeMode;
			half _DetailCat;
			half _TranslucencyScatteringValue;
			half _TranslucencyNormalValue;
			half _RenderClip;
			half _IsVersion;
			half _RenderingCat;
			half _VariationMotionMessage;
			half _FadeCameraValue;
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
			half4 TVE_MotionParams;
			TEXTURE2D_ARRAY(TVE_MotionTex);
			half4 TVE_MotionCoord;
			SAMPLER(samplerTVE_MotionTex);
			float TVE_MotionUsage[9];
			TEXTURE2D(TVE_NoiseTex);
			float2 TVE_NoiseSpeed_Vegetation;
			float2 TVE_NoiseSpeed_Grass;
			half TVE_NoiseSize_Vegetation;
			half TVE_NoiseSize_Grass;
			SAMPLER(samplerTVE_NoiseTex);
			half4 TVE_ReactParams;
			TEXTURE2D_ARRAY(TVE_ReactTex);
			half4 TVE_ReactCoord;
			SAMPLER(samplerTVE_ReactTex);
			float TVE_ReactUsage[9];
			TEXTURE2D(_MainAlbedoTex);
			SAMPLER(sampler_MainAlbedoTex);
			TEXTURE2D(_SecondAlbedoTex);
			TEXTURE2D(_SecondMaskTex);
			SAMPLER(sampler_SecondMaskTex);
			TEXTURE2D(_MainMaskTex);
			half4 TVE_OverlayColor;
			TEXTURE2D(_MainNormalTex);
			half4 TVE_ExtrasParams;
			TEXTURE2D_ARRAY(TVE_ExtrasTex);
			half4 TVE_ExtrasCoord;
			SAMPLER(samplerTVE_ExtrasTex);
			float TVE_ExtrasUsage[9];
			TEXTURE2D(_EmissiveTex);
			SAMPLER(sampler_EmissiveTex);
			half TVE_CameraFadeStart;
			half TVE_CameraFadeEnd;
			TEXTURE3D(TVE_ScreenTex3D);
			half TVE_ScreenTexCoord;
			SAMPLER(samplerTVE_ScreenTex3D);


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 PositionOS3588_g51941 = v.vertex.xyz;
				half3 _Vector1 = half3(0,0,0);
				half3 Mesh_PivotsOS2291_g51941 = _Vector1;
				float3 temp_output_2283_0_g51941 = ( PositionOS3588_g51941 - Mesh_PivotsOS2291_g51941 );
				half3 VertexPos40_g52293 = temp_output_2283_0_g51941;
				float3 appendResult74_g52293 = (float3(0.0 , VertexPos40_g52293.y , 0.0));
				float3 VertexPosRotationAxis50_g52293 = appendResult74_g52293;
				float3 break84_g52293 = VertexPos40_g52293;
				float3 appendResult81_g52293 = (float3(break84_g52293.x , 0.0 , break84_g52293.z));
				float3 VertexPosOtherAxis82_g52293 = appendResult81_g52293;
				float ObjectData20_g52239 = 3.14;
				float Bounds_Radius121_g51941 = _MaxBoundsInfo.x;
				float WorldData19_g52239 = Bounds_Radius121_g51941;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52239 = WorldData19_g52239;
				#else
				float staticSwitch14_g52239 = ObjectData20_g52239;
				#endif
				float Motion_Max_Rolling1137_g51941 = staticSwitch14_g52239;
				float4x4 break19_g52279 = GetObjectToWorldMatrix();
				float3 appendResult20_g52279 = (float3(break19_g52279[ 0 ][ 3 ] , break19_g52279[ 1 ][ 3 ] , break19_g52279[ 2 ][ 3 ]));
				half3 Off19_g52282 = appendResult20_g52279;
				float3 appendResult93_g52279 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52279 = ( appendResult93_g52279 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52279 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52279 , 0.0 ) ).xyz).xyz;
				half3 On20_g52282 = ( appendResult20_g52279 + PivotsOnly105_g52279 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52282 = On20_g52282;
				#else
				float3 staticSwitch14_g52282 = Off19_g52282;
				#endif
				half3 ObjectData20_g52283 = staticSwitch14_g52282;
				half3 WorldData19_g52283 = Off19_g52282;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52283 = WorldData19_g52283;
				#else
				float3 staticSwitch14_g52283 = ObjectData20_g52283;
				#endif
				float3 temp_output_42_0_g52279 = staticSwitch14_g52283;
				half3 ObjectData20_g52278 = temp_output_42_0_g52279;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				half3 WorldData19_g52278 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52278 = WorldData19_g52278;
				#else
				float3 staticSwitch14_g52278 = ObjectData20_g52278;
				#endif
				float3 Position83_g52277 = staticSwitch14_g52278;
				float temp_output_84_0_g52277 = _LayerMotionValue;
				float4 lerpResult87_g52277 = lerp( TVE_MotionParams , SAMPLE_TEXTURE2D_ARRAY_LOD( TVE_MotionTex, samplerTVE_MotionTex, ( (TVE_MotionCoord).zw + ( (TVE_MotionCoord).xy * (Position83_g52277).xz ) ),temp_output_84_0_g52277, 0.0 ) , TVE_MotionUsage[(int)temp_output_84_0_g52277]);
				half4 Global_Motion_Params3909_g51941 = lerpResult87_g52277;
				float4 break322_g52303 = Global_Motion_Params3909_g51941;
				half Wind_Power369_g52303 = break322_g52303.z;
				float lerpResult410_g52303 = lerp( 0.2 , 1.0 , Wind_Power369_g52303);
				half Wind_Power_203109_g51941 = lerpResult410_g52303;
				half Mesh_Motion_260_g51941 = v.ase_texcoord3.y;
				#ifdef TVE_IS_GRASS_SHADER
				float2 staticSwitch160_g52296 = TVE_NoiseSpeed_Grass;
				#else
				float2 staticSwitch160_g52296 = TVE_NoiseSpeed_Vegetation;
				#endif
				float4x4 break19_g52298 = GetObjectToWorldMatrix();
				float3 appendResult20_g52298 = (float3(break19_g52298[ 0 ][ 3 ] , break19_g52298[ 1 ][ 3 ] , break19_g52298[ 2 ][ 3 ]));
				half3 Off19_g52301 = appendResult20_g52298;
				float3 appendResult93_g52298 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52298 = ( appendResult93_g52298 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52298 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52298 , 0.0 ) ).xyz).xyz;
				half3 On20_g52301 = ( appendResult20_g52298 + PivotsOnly105_g52298 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52301 = On20_g52301;
				#else
				float3 staticSwitch14_g52301 = Off19_g52301;
				#endif
				half3 ObjectData20_g52302 = staticSwitch14_g52301;
				half3 WorldData19_g52302 = Off19_g52301;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52302 = WorldData19_g52302;
				#else
				float3 staticSwitch14_g52302 = ObjectData20_g52302;
				#endif
				float3 temp_output_42_0_g52298 = staticSwitch14_g52302;
				half3 ObjectData20_g52297 = temp_output_42_0_g52298;
				half3 WorldData19_g52297 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52297 = WorldData19_g52297;
				#else
				float3 staticSwitch14_g52297 = ObjectData20_g52297;
				#endif
				#ifdef TVE_IS_GRASS_SHADER
				float2 staticSwitch164_g52296 = (ase_worldPos).xz;
				#else
				float2 staticSwitch164_g52296 = (staticSwitch14_g52297).xz;
				#endif
				#ifdef TVE_IS_GRASS_SHADER
				float staticSwitch161_g52296 = TVE_NoiseSize_Grass;
				#else
				float staticSwitch161_g52296 = TVE_NoiseSize_Vegetation;
				#endif
				float2 panner73_g52296 = ( _TimeParameters.x * staticSwitch160_g52296 + ( staticSwitch164_g52296 * staticSwitch161_g52296 ));
				float4 tex2DNode75_g52296 = SAMPLE_TEXTURE2D_LOD( TVE_NoiseTex, samplerTVE_NoiseTex, panner73_g52296, 0.0 );
				float4 saferPower77_g52296 = max( abs( tex2DNode75_g52296 ) , 0.0001 );
				half Wind_Power2223_g51941 = Wind_Power369_g52303;
				float temp_output_167_0_g52296 = Wind_Power2223_g51941;
				float lerpResult168_g52296 = lerp( 1.5 , 0.25 , temp_output_167_0_g52296);
				float4 temp_cast_7 = (lerpResult168_g52296).xxxx;
				float4 break142_g52296 = pow( saferPower77_g52296 , temp_cast_7 );
				half Global_NoiseTex_R34_g51941 = break142_g52296.r;
				half Input_Speed62_g52276 = _MotionSpeed_20;
				float mulTime354_g52276 = _TimeParameters.x * Input_Speed62_g52276;
				float4x4 break19_g52214 = GetObjectToWorldMatrix();
				float3 appendResult20_g52214 = (float3(break19_g52214[ 0 ][ 3 ] , break19_g52214[ 1 ][ 3 ] , break19_g52214[ 2 ][ 3 ]));
				half3 Off19_g52217 = appendResult20_g52214;
				float3 appendResult93_g52214 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52214 = ( appendResult93_g52214 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52214 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52214 , 0.0 ) ).xyz).xyz;
				half3 On20_g52217 = ( appendResult20_g52214 + PivotsOnly105_g52214 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52217 = On20_g52217;
				#else
				float3 staticSwitch14_g52217 = Off19_g52217;
				#endif
				half3 ObjectData20_g52218 = staticSwitch14_g52217;
				half3 WorldData19_g52218 = Off19_g52217;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52218 = WorldData19_g52218;
				#else
				float3 staticSwitch14_g52218 = ObjectData20_g52218;
				#endif
				float3 temp_output_42_0_g52214 = staticSwitch14_g52218;
				float3 break9_g52214 = temp_output_42_0_g52214;
				half Variation_Complex102_g52212 = frac( ( v.ase_color.r + ( break9_g52214.x + break9_g52214.z ) ) );
				float ObjectData20_g52213 = Variation_Complex102_g52212;
				half Variation_Simple105_g52212 = v.ase_color.r;
				float WorldData19_g52213 = Variation_Simple105_g52212;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52213 = WorldData19_g52213;
				#else
				float staticSwitch14_g52213 = ObjectData20_g52213;
				#endif
				half Motion_Variation3073_g51941 = staticSwitch14_g52213;
				float temp_output_3154_0_g51941 = ( _MotionVariation_20 * Motion_Variation3073_g51941 );
				float Motion_Variation284_g52276 = temp_output_3154_0_g51941;
				float Motion_Scale287_g52276 = ( _MotionScale_20 * ase_worldPos.x );
				half Variation127_g52292 = temp_output_3154_0_g51941;
				float lerpResult110_g52292 = lerp( ceil( saturate( ( frac( ( Variation127_g52292 + 0.3576 ) ) - 0.6 ) ) ) , ceil( saturate( ( frac( ( Variation127_g52292 + 0.1715 ) ) - 0.4 ) ) ) , (sin( _TimeParameters.x )*0.5 + 0.5));
				float temp_output_112_0_g52292 = Wind_Power2223_g51941;
				float lerpResult111_g52292 = lerp( lerpResult110_g52292 , 1.0 , ( temp_output_112_0_g52292 * temp_output_112_0_g52292 * temp_output_112_0_g52292 * temp_output_112_0_g52292 ));
				float lerpResult126_g52292 = lerp( lerpResult111_g52292 , 1.0 , ( 1.0 - saturate( Variation127_g52292 ) ));
				half Motion_Rolling138_g51941 = ( ( _MotionAmplitude_20 * Motion_Max_Rolling1137_g51941 ) * ( Wind_Power_203109_g51941 * Mesh_Motion_260_g51941 * Global_NoiseTex_R34_g51941 * _VertexRollingMode ) * sin( ( mulTime354_g52276 + Motion_Variation284_g52276 + Motion_Scale287_g52276 ) ) * lerpResult126_g52292 );
				half Angle44_g52293 = Motion_Rolling138_g51941;
				half3 VertexPos40_g52260 = ( VertexPosRotationAxis50_g52293 + ( VertexPosOtherAxis82_g52293 * cos( Angle44_g52293 ) ) + ( cross( float3(0,1,0) , VertexPosOtherAxis82_g52293 ) * sin( Angle44_g52293 ) ) );
				float3 appendResult74_g52260 = (float3(VertexPos40_g52260.x , 0.0 , 0.0));
				half3 VertexPosRotationAxis50_g52260 = appendResult74_g52260;
				float3 break84_g52260 = VertexPos40_g52260;
				float3 appendResult81_g52260 = (float3(0.0 , break84_g52260.y , break84_g52260.z));
				half3 VertexPosOtherAxis82_g52260 = appendResult81_g52260;
				float ObjectData20_g52309 = 3.14;
				float Bounds_Height374_g51941 = _MaxBoundsInfo.y;
				float WorldData19_g52309 = ( Bounds_Height374_g51941 * 3.14 );
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52309 = WorldData19_g52309;
				#else
				float staticSwitch14_g52309 = ObjectData20_g52309;
				#endif
				float Motion_Max_Bending1133_g51941 = staticSwitch14_g52309;
				float lerpResult376_g52303 = lerp( 0.1 , 1.0 , Wind_Power369_g52303);
				half Wind_Power_103106_g51941 = lerpResult376_g52303;
				float3 appendResult397_g52303 = (float3(break322_g52303.x , 0.0 , break322_g52303.y));
				float3 temp_output_398_0_g52303 = (appendResult397_g52303*2.0 + -1.0);
				float3 ase_parentObjectScale = ( 1.0 / float3( length( GetWorldToObjectMatrix()[ 0 ].xyz ), length( GetWorldToObjectMatrix()[ 1 ].xyz ), length( GetWorldToObjectMatrix()[ 2 ].xyz ) ) );
				float3 temp_output_339_0_g52303 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_398_0_g52303 , 0.0 ) ).xyz * ase_parentObjectScale );
				half2 Wind_DirectionOS39_g51941 = (temp_output_339_0_g52303).xz;
				half Input_Speed62_g52219 = _MotionSpeed_10;
				float mulTime373_g52219 = _TimeParameters.x * Input_Speed62_g52219;
				half Motion_Variation284_g52219 = ( _MotionVariation_10 * Motion_Variation3073_g51941 );
				float2 appendResult344_g52219 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 Motion_Scale287_g52219 = ( _MotionScale_10 * appendResult344_g52219 );
				half2 Sine_MinusOneToOne281_g52219 = sin( ( mulTime373_g52219 + Motion_Variation284_g52219 + Motion_Scale287_g52219 ) );
				float2 temp_cast_12 = (1.0).xx;
				half Input_Turbulence327_g52219 = Global_NoiseTex_R34_g51941;
				float2 lerpResult321_g52219 = lerp( Sine_MinusOneToOne281_g52219 , temp_cast_12 , Input_Turbulence327_g52219);
				half2 Motion_Bending2258_g51941 = ( ( _MotionAmplitude_10 * Motion_Max_Bending1133_g51941 ) * Wind_Power_103106_g51941 * Wind_DirectionOS39_g51941 * Global_NoiseTex_R34_g51941 * lerpResult321_g52219 );
				half Interaction_Amplitude4137_g51941 = _InteractionAmplitude;
				float4x4 break19_g52271 = GetObjectToWorldMatrix();
				float3 appendResult20_g52271 = (float3(break19_g52271[ 0 ][ 3 ] , break19_g52271[ 1 ][ 3 ] , break19_g52271[ 2 ][ 3 ]));
				half3 Off19_g52274 = appendResult20_g52271;
				float3 appendResult93_g52271 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52271 = ( appendResult93_g52271 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52271 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52271 , 0.0 ) ).xyz).xyz;
				half3 On20_g52274 = ( appendResult20_g52271 + PivotsOnly105_g52271 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52274 = On20_g52274;
				#else
				float3 staticSwitch14_g52274 = Off19_g52274;
				#endif
				half3 ObjectData20_g52275 = staticSwitch14_g52274;
				half3 WorldData19_g52275 = Off19_g52274;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52275 = WorldData19_g52275;
				#else
				float3 staticSwitch14_g52275 = ObjectData20_g52275;
				#endif
				float3 temp_output_42_0_g52271 = staticSwitch14_g52275;
				half3 ObjectData20_g52270 = temp_output_42_0_g52271;
				half3 WorldData19_g52270 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52270 = WorldData19_g52270;
				#else
				float3 staticSwitch14_g52270 = ObjectData20_g52270;
				#endif
				float3 Position83_g52269 = staticSwitch14_g52270;
				float temp_output_84_0_g52269 = _LayerReactValue;
				float4 lerpResult87_g52269 = lerp( TVE_ReactParams , SAMPLE_TEXTURE2D_ARRAY_LOD( TVE_ReactTex, samplerTVE_ReactTex, ( (TVE_ReactCoord).zw + ( (TVE_ReactCoord).xy * (Position83_g52269).xz ) ),temp_output_84_0_g52269, 0.0 ) , TVE_ReactUsage[(int)temp_output_84_0_g52269]);
				half4 Global_React_Params4173_g51941 = lerpResult87_g52269;
				float4 break322_g52256 = Global_React_Params4173_g51941;
				half Interaction_Mask66_g51941 = break322_g52256.z;
				float3 appendResult397_g52256 = (float3(break322_g52256.x , 0.0 , break322_g52256.y));
				float3 temp_output_398_0_g52256 = (appendResult397_g52256*2.0 + -1.0);
				float3 temp_output_339_0_g52256 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_398_0_g52256 , 0.0 ) ).xyz * ase_parentObjectScale );
				half2 Interaction_DirectionOS4158_g51941 = (temp_output_339_0_g52256).xz;
				float lerpResult3307_g51941 = lerp( 1.0 , Motion_Variation3073_g51941 , _InteractionVariation);
				half2 Motion_Interaction53_g51941 = ( Interaction_Amplitude4137_g51941 * Motion_Max_Bending1133_g51941 * Interaction_Mask66_g51941 * Interaction_Mask66_g51941 * Interaction_DirectionOS4158_g51941 * lerpResult3307_g51941 );
				float2 lerpResult109_g51941 = lerp( Motion_Bending2258_g51941 , Motion_Interaction53_g51941 , ( Interaction_Mask66_g51941 * saturate( Interaction_Amplitude4137_g51941 ) ));
				half Mesh_Motion_182_g51941 = v.ase_texcoord3.x;
				float2 break143_g51941 = ( lerpResult109_g51941 * Mesh_Motion_182_g51941 );
				half Motion_Z190_g51941 = break143_g51941.y;
				half Angle44_g52260 = Motion_Z190_g51941;
				half3 VertexPos40_g52259 = ( VertexPosRotationAxis50_g52260 + ( VertexPosOtherAxis82_g52260 * cos( Angle44_g52260 ) ) + ( cross( float3(1,0,0) , VertexPosOtherAxis82_g52260 ) * sin( Angle44_g52260 ) ) );
				float3 appendResult74_g52259 = (float3(0.0 , 0.0 , VertexPos40_g52259.z));
				half3 VertexPosRotationAxis50_g52259 = appendResult74_g52259;
				float3 break84_g52259 = VertexPos40_g52259;
				float3 appendResult81_g52259 = (float3(break84_g52259.x , break84_g52259.y , 0.0));
				half3 VertexPosOtherAxis82_g52259 = appendResult81_g52259;
				half Motion_X216_g51941 = break143_g51941.x;
				half Angle44_g52259 = -Motion_X216_g51941;
				float3 Vertex_Motion_Object833_g51941 = ( VertexPosRotationAxis50_g52259 + ( VertexPosOtherAxis82_g52259 * cos( Angle44_g52259 ) ) + ( cross( float3(0,0,1) , VertexPosOtherAxis82_g52259 ) * sin( Angle44_g52259 ) ) );
				float3 temp_output_3474_0_g51941 = ( PositionOS3588_g51941 - Mesh_PivotsOS2291_g51941 );
				float3 appendResult2047_g51941 = (float3(Motion_Rolling138_g51941 , 0.0 , -Motion_Rolling138_g51941));
				float3 appendResult2043_g51941 = (float3(Motion_X216_g51941 , 0.0 , Motion_Z190_g51941));
				float3 Vertex_Motion_World1118_g51941 = ( ( temp_output_3474_0_g51941 + appendResult2047_g51941 ) + appendResult2043_g51941 );
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch3312_g51941 = Vertex_Motion_World1118_g51941;
				#else
				float3 staticSwitch3312_g51941 = ( Vertex_Motion_Object833_g51941 + ( 0.0 * _VertexDataMode ) );
				#endif
				half Global_Vertex_Size174_g51941 = break322_g52256.w;
				float lerpResult346_g51941 = lerp( 1.0 , Global_Vertex_Size174_g51941 , _GlobalSize);
				float3 appendResult3480_g51941 = (float3(lerpResult346_g51941 , lerpResult346_g51941 , lerpResult346_g51941));
				half3 ObjectData20_g52294 = appendResult3480_g51941;
				half3 _Vector11 = half3(1,1,1);
				half3 WorldData19_g52294 = _Vector11;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52294 = WorldData19_g52294;
				#else
				float3 staticSwitch14_g52294 = ObjectData20_g52294;
				#endif
				half3 Vertex_Size1741_g51941 = staticSwitch14_g52294;
				half3 _Vector5 = half3(1,1,1);
				float3 Vertex_SizeFade1740_g51941 = _Vector5;
				half3 Grass_Coverage2661_g51941 = half3(0,0,0);
				float3 Final_VertexPosition890_g51941 = ( ( staticSwitch3312_g51941 * Vertex_Size1741_g51941 * Vertex_SizeFade1740_g51941 ) + Mesh_PivotsOS2291_g51941 + Grass_Coverage2661_g51941 );
				
				float2 vertexToFrag11_g52308 = ( ( v.ase_texcoord.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				o.ase_texcoord2.xy = vertexToFrag11_g52308;
				float2 appendResult21_g52242 = (float2(v.ase_texcoord.z , v.ase_texcoord.w));
				float2 Mesh_DetailCoord3_g51941 = appendResult21_g52242;
				float2 vertexToFrag11_g52243 = ( ( Mesh_DetailCoord3_g51941 * (_SecondUVs).xy ) + (_SecondUVs).zw );
				o.ase_texcoord2.zw = vertexToFrag11_g52243;
				half Mesh_DetailMask90_g51941 = v.ase_color.b;
				float vertexToFrag11_g52208 = ( ( Mesh_DetailMask90_g51941 - 0.5 ) + _DetailMeshValue );
				o.ase_texcoord3.x = vertexToFrag11_g52208;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord3.yzw = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord4.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord5.xyz = ase_worldBitangent;
				float3 vertexToFrag3890_g51941 = ase_worldPos;
				o.ase_texcoord6.xyz = vertexToFrag3890_g51941;
				
				float2 vertexToFrag11_g52248 = ( ( v.ase_texcoord.xy * (_EmissiveUVs).xy ) + (_EmissiveUVs).zw );
				o.ase_texcoord7.xy = vertexToFrag11_g52248;
				
				float temp_output_7_0_g52252 = TVE_CameraFadeStart;
				float saferPower3976_g51941 = max( saturate( ( ( distance( ase_worldPos , _WorldSpaceCameraPos ) - temp_output_7_0_g52252 ) / ( TVE_CameraFadeEnd - temp_output_7_0_g52252 ) ) ) , 0.0001 );
				float temp_output_3976_0_g51941 = pow( saferPower3976_g51941 , _FadeCameraValue );
				float vertexToFrag11_g52251 = temp_output_3976_0_g51941;
				o.ase_texcoord4.w = vertexToFrag11_g52251;
				
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord5.w = 0;
				o.ase_texcoord6.w = 0;
				o.ase_texcoord7.zw = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = Final_VertexPosition890_g51941;
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
				float4 ase_texcoord3 : TEXCOORD3;
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
				o.ase_texcoord3 = v.ase_texcoord3;
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
				o.ase_texcoord3 = patch[0].ase_texcoord3 * bary.x + patch[1].ase_texcoord3 * bary.y + patch[2].ase_texcoord3 * bary.z;
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
				half2 Main_UVs15_g51941 = vertexToFrag11_g52308;
				float4 tex2DNode29_g51941 = SAMPLE_TEXTURE2D( _MainAlbedoTex, sampler_MainAlbedoTex, Main_UVs15_g51941 );
				float3 temp_output_51_0_g51941 = ( (_MainColor).rgb * (tex2DNode29_g51941).rgb );
				half3 Main_Albedo99_g51941 = temp_output_51_0_g51941;
				float2 vertexToFrag11_g52243 = IN.ase_texcoord2.zw;
				half2 Second_UVs17_g51941 = vertexToFrag11_g52243;
				half3 Second_Albedo153_g51941 = (( _SecondColor * SAMPLE_TEXTURE2D( _SecondAlbedoTex, sampler_SecondMaskTex, Second_UVs17_g51941 ) )).rgb;
				#ifdef UNITY_COLORSPACE_GAMMA
				float staticSwitch1_g52209 = 2.0;
				#else
				float staticSwitch1_g52209 = 4.594794;
				#endif
				float vertexToFrag11_g52208 = IN.ase_texcoord3.x;
				float temp_output_3919_0_g51941 = vertexToFrag11_g52208;
				half Blend_Source1540_g51941 = temp_output_3919_0_g51941;
				float4 tex2DNode35_g51941 = SAMPLE_TEXTURE2D( _MainMaskTex, sampler_MainAlbedoTex, Main_UVs15_g51941 );
				half Main_Mask57_g51941 = tex2DNode35_g51941.b;
				float4 tex2DNode33_g51941 = SAMPLE_TEXTURE2D( _SecondMaskTex, sampler_SecondMaskTex, Second_UVs17_g51941 );
				half Second_Mask81_g51941 = tex2DNode33_g51941.b;
				float lerpResult1327_g51941 = lerp( Main_Mask57_g51941 , Second_Mask81_g51941 , _DetailMaskMode);
				float lerpResult4058_g51941 = lerp( lerpResult1327_g51941 , ( 1.0 - lerpResult1327_g51941 ) , _DetailMaskInvertMode);
				float temp_output_7_0_g52238 = _DetailBlendMinValue;
				half Mask_Detail147_g51941 = saturate( ( ( saturate( ( Blend_Source1540_g51941 + ( Blend_Source1540_g51941 * lerpResult4058_g51941 ) ) ) - temp_output_7_0_g52238 ) / ( _DetailBlendMaxValue - temp_output_7_0_g52238 ) ) );
				float3 lerpResult235_g51941 = lerp( Main_Albedo99_g51941 , ( Main_Albedo99_g51941 * Second_Albedo153_g51941 * staticSwitch1_g52209 ) , Mask_Detail147_g51941);
				float3 lerpResult208_g51941 = lerp( Main_Albedo99_g51941 , Second_Albedo153_g51941 , Mask_Detail147_g51941);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float3 staticSwitch4062_g51941 = lerpResult235_g51941;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float3 staticSwitch4062_g51941 = lerpResult208_g51941;
				#else
				float3 staticSwitch4062_g51941 = lerpResult235_g51941;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float3 staticSwitch255_g51941 = Main_Albedo99_g51941;
				#elif defined(TVE_DETAIL_MODE_ON)
				float3 staticSwitch255_g51941 = staticSwitch4062_g51941;
				#else
				float3 staticSwitch255_g51941 = Main_Albedo99_g51941;
				#endif
				half3 Blend_Albedo265_g51941 = staticSwitch255_g51941;
				half3 Blend_AlbedoTinted2808_g51941 = ( float3(1,1,1) * float3(1,1,1) * float3(1,1,1) * Blend_Albedo265_g51941 );
				half3 Blend_AlbedoColored863_g51941 = Blend_AlbedoTinted2808_g51941;
				half3 Blend_AlbedoAndSubsurface149_g51941 = Blend_AlbedoColored863_g51941;
				half3 Global_OverlayColor1758_g51941 = (TVE_OverlayColor).rgb;
				float3 unpack4112_g51941 = UnpackNormalScale( SAMPLE_TEXTURE2D( _MainNormalTex, sampler_MainAlbedoTex, Main_UVs15_g51941 ), _MainNormalValue );
				unpack4112_g51941.z = lerp( 1, unpack4112_g51941.z, saturate(_MainNormalValue) );
				half3 Main_Normal137_g51941 = unpack4112_g51941;
				float3 ase_worldTangent = IN.ase_texcoord3.yzw;
				float3 ase_worldNormal = IN.ase_texcoord4.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord5.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal4099_g51941 = Main_Normal137_g51941;
				float3 worldNormal4099_g51941 = float3(dot(tanToWorld0,tanNormal4099_g51941), dot(tanToWorld1,tanNormal4099_g51941), dot(tanToWorld2,tanNormal4099_g51941));
				float3 Main_Normal_WS4101_g51941 = worldNormal4099_g51941;
				float lerpResult3567_g51941 = lerp( _OverlayBottomValue , 1.0 , Main_Normal_WS4101_g51941.y);
				half Main_AlbedoTex_G3526_g51941 = tex2DNode29_g51941.g;
				half Second_AlbedoTex_G3581_g51941 = (SAMPLE_TEXTURE2D( _SecondAlbedoTex, sampler_SecondMaskTex, Second_UVs17_g51941 )).g;
				float lerpResult3579_g51941 = lerp( Main_AlbedoTex_G3526_g51941 , Second_AlbedoTex_G3581_g51941 , Mask_Detail147_g51941);
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch3574_g51941 = Main_AlbedoTex_G3526_g51941;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch3574_g51941 = lerpResult3579_g51941;
				#else
				float staticSwitch3574_g51941 = Main_AlbedoTex_G3526_g51941;
				#endif
				float3 vertexToFrag3890_g51941 = IN.ase_texcoord6.xyz;
				float3 PositionWS_PerVertex3905_g51941 = vertexToFrag3890_g51941;
				float3 Position82_g52261 = PositionWS_PerVertex3905_g51941;
				float temp_output_84_0_g52261 = _LayerExtrasValue;
				float4 lerpResult88_g52261 = lerp( TVE_ExtrasParams , SAMPLE_TEXTURE2D_ARRAY( TVE_ExtrasTex, samplerTVE_ExtrasTex, ( (TVE_ExtrasCoord).zw + ( (TVE_ExtrasCoord).xy * (Position82_g52261).xz ) ),temp_output_84_0_g52261 ) , TVE_ExtrasUsage[(int)temp_output_84_0_g52261]);
				float4 break89_g52261 = lerpResult88_g52261;
				half Global_Extras_Overlay156_g51941 = break89_g52261.b;
				float temp_output_1025_0_g51941 = ( _GlobalOverlay * Global_Extras_Overlay156_g51941 );
				half Overlay_Commons1365_g51941 = temp_output_1025_0_g51941;
				float temp_output_7_0_g52234 = _OverlayMaskMinValue;
				half Overlay_Mask269_g51941 = saturate( ( ( ( ( ( lerpResult3567_g51941 * 0.5 ) + staticSwitch3574_g51941 ) * Overlay_Commons1365_g51941 ) - temp_output_7_0_g52234 ) / ( _OverlayMaskMaxValue - temp_output_7_0_g52234 ) ) );
				float3 lerpResult336_g51941 = lerp( Blend_AlbedoAndSubsurface149_g51941 , Global_OverlayColor1758_g51941 , Overlay_Mask269_g51941);
				half3 Final_Albedo359_g51941 = lerpResult336_g51941;
				float3 temp_cast_3 = (1.0).xxx;
				float Mesh_Occlusion318_g51941 = IN.ase_color.g;
				float temp_output_7_0_g52232 = _VertexOcclusionMinValue;
				float3 lerpResult2945_g51941 = lerp( (_VertexOcclusionColor).rgb , temp_cast_3 , saturate( ( ( Mesh_Occlusion318_g51941 - temp_output_7_0_g52232 ) / ( _VertexOcclusionMaxValue - temp_output_7_0_g52232 ) ) ));
				float3 Vertex_Occlusion648_g51941 = lerpResult2945_g51941;
				
				float2 vertexToFrag11_g52248 = IN.ase_texcoord7.xy;
				half2 Emissive_UVs2468_g51941 = vertexToFrag11_g52248;
				half Global_Extras_Emissive4203_g51941 = break89_g52261.r;
				float lerpResult4206_g51941 = lerp( 1.0 , Global_Extras_Emissive4203_g51941 , _GlobalEmissive);
				half3 Final_Emissive2476_g51941 = ( (( _EmissiveColor * SAMPLE_TEXTURE2D( _EmissiveTex, sampler_EmissiveTex, Emissive_UVs2468_g51941 ) )).rgb * lerpResult4206_g51941 );
				
				float localCustomAlphaClip3735_g51941 = ( 0.0 );
				float vertexToFrag11_g52251 = IN.ase_texcoord4.w;
				half Fade_Camera3743_g51941 = vertexToFrag11_g52251;
				half Final_AlphaFade3727_g51941 = ( 1.0 * Fade_Camera3743_g51941 );
				float temp_output_41_0_g52255 = Final_AlphaFade3727_g51941;
				float Main_Alpha316_g51941 = ( _MainColor.a * tex2DNode29_g51941.a );
				half AlphaTreshold2132_g51941 = _Cutoff;
				#ifdef TVE_ALPHA_CLIP
				float staticSwitch3792_g51941 = ( Main_Alpha316_g51941 - ( AlphaTreshold2132_g51941 - 0.5 ) );
				#else
				float staticSwitch3792_g51941 = Main_Alpha316_g51941;
				#endif
				half Final_Alpha3754_g51941 = staticSwitch3792_g51941;
				float temp_output_661_0_g51941 = ( saturate( ( temp_output_41_0_g52255 + ( temp_output_41_0_g52255 * SAMPLE_TEXTURE3D( TVE_ScreenTex3D, samplerTVE_ScreenTex3D, ( TVE_ScreenTexCoord * PositionWS_PerVertex3905_g51941 ) ).r ) ) ) * Final_Alpha3754_g51941 );
				float Alpha3735_g51941 = temp_output_661_0_g51941;
				float Treshold3735_g51941 = 0.5;
				{
				#if TVE_ALPHA_CLIP
				clip(Alpha3735_g51941 - Treshold3735_g51941);
				#endif
				}
				half Final_Clip914_g51941 = saturate( Alpha3735_g51941 );
				
				
				float3 Albedo = ( Final_Albedo359_g51941 * Vertex_Occlusion648_g51941 );
				float3 Emission = Final_Emissive2476_g51941;
				float Alpha = Final_Clip914_g51941;
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
			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define ASE_ABSOLUTE_VERTEX_POS 1
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
			
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#pragma shader_feature_local TVE_ALPHA_CLIP
			#pragma shader_feature_local TVE_VERTEX_DATA_BATCHED
			#pragma shader_feature_local TVE_DETAIL_MODE_OFF TVE_DETAIL_MODE_ON
			#pragma shader_feature_local TVE_DETAIL_BLEND_OVERLAY TVE_DETAIL_BLEND_REPLACE
			//TVE Pipeline Defines
			#define THE_VEGETATION_ENGINE
			#define IS_UNIVERSAL_PIPELINE
			//TVE Shader Type Defines
			#define TVE_IS_VEGETATION_SHADER
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
				float4 ase_texcoord3 : TEXCOORD3;
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
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			half4 _SecondUVs;
			half4 _VertexOcclusionColor;
			float4 _SubsurfaceDiffusion_Asset;
			half4 _SecondColor;
			half4 _EmissiveColor;
			float4 _NoiseMaskRemap;
			half4 _ColorsMaskRemap;
			half4 _SubsurfaceMaskRemap;
			half4 _OverlayMaskRemap;
			float4 _GradientMaskRemap;
			half4 _VertexOcclusionRemap;
			half4 _DetailBlendRemap;
			float4 _Color;
			half4 _MainColor;
			half4 _MainUVs;
			float4 _MaxBoundsInfo;
			half4 _EmissiveUVs;
			float4 _SubsurfaceDiffusion_asset;
			half3 _render_normals_options;
			half _VertexDataMode;
			half _InteractionAmplitude;
			half _GlobalSize;
			half _InteractionVariation;
			half _LayerReactValue;
			half _MotionVariation_20;
			half _MotionVariation_10;
			float _MotionSpeed_10;
			half _MotionAmplitude_10;
			half _MotionScale_20;
			half _MotionSpeed_20;
			half _VertexRollingMode;
			half _LayerMotionValue;
			half _vertex_pivot_mode;
			half _MotionAmplitude_20;
			float _MotionScale_10;
			half _render_dst;
			half _OverlayBottomValue;
			half _DetailMaskMode;
			half _MainOcclusionValue;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half _RenderSpecular;
			half _GlobalEmissive;
			half _DetailNormalValue;
			half _SecondNormalValue;
			half _VertexOcclusionMaxValue;
			half _VertexOcclusionMinValue;
			half _OverlayMaskMaxValue;
			half _OverlayMaskMinValue;
			half _LayerExtrasValue;
			half _GlobalOverlay;
			half _MainNormalValue;
			half _EmissiveFlagMode;
			half _DetailBlendMaxValue;
			half _DetailBlendMinValue;
			half _DetailMaskInvertMode;
			half _DetailMeshValue;
			half _RenderMode;
			float _SubsurfaceDiffusion;
			half _RenderDecals;
			half _RenderPriority;
			half _TranslucencyIntensityValue;
			half _EmissiveCat;
			half _ReceiveSpace;
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
			half _IsBarkShader;
			half _IsStandardShader;
			half _render_src;
			half _render_cull;
			half _render_zw;
			half _NoiseCat;
			half _SizeFadeCat;
			half _TranslucencyAmbientValue;
			half _VertexMasksMode;
			half _RenderZWrite;
			half _TranslucencyShadowValue;
			half _RenderSSR;
			half _SecondOcclusionValue;
			half _MotionSpace;
			half _RenderCull;
			half _PerspectiveCat;
			half _VertexVariationMode;
			half _GradientCat;
			half _TranslucencyDirectValue;
			half _FadeSpace;
			half _GlobalCat;
			half _IsTVEShader;
			half _DetailSpace;
			half _DetailTypeMode;
			half _DetailCat;
			half _TranslucencyScatteringValue;
			half _TranslucencyNormalValue;
			half _RenderClip;
			half _IsVersion;
			half _RenderingCat;
			half _VariationMotionMessage;
			half _FadeCameraValue;
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
			half4 TVE_MotionParams;
			TEXTURE2D_ARRAY(TVE_MotionTex);
			half4 TVE_MotionCoord;
			SAMPLER(samplerTVE_MotionTex);
			float TVE_MotionUsage[9];
			TEXTURE2D(TVE_NoiseTex);
			float2 TVE_NoiseSpeed_Vegetation;
			float2 TVE_NoiseSpeed_Grass;
			half TVE_NoiseSize_Vegetation;
			half TVE_NoiseSize_Grass;
			SAMPLER(samplerTVE_NoiseTex);
			half4 TVE_ReactParams;
			TEXTURE2D_ARRAY(TVE_ReactTex);
			half4 TVE_ReactCoord;
			SAMPLER(samplerTVE_ReactTex);
			float TVE_ReactUsage[9];
			TEXTURE2D(_MainAlbedoTex);
			SAMPLER(sampler_MainAlbedoTex);
			TEXTURE2D(_SecondAlbedoTex);
			TEXTURE2D(_SecondMaskTex);
			SAMPLER(sampler_SecondMaskTex);
			TEXTURE2D(_MainMaskTex);
			half4 TVE_OverlayColor;
			TEXTURE2D(_MainNormalTex);
			half4 TVE_ExtrasParams;
			TEXTURE2D_ARRAY(TVE_ExtrasTex);
			half4 TVE_ExtrasCoord;
			SAMPLER(samplerTVE_ExtrasTex);
			float TVE_ExtrasUsage[9];
			half TVE_CameraFadeStart;
			half TVE_CameraFadeEnd;
			TEXTURE3D(TVE_ScreenTex3D);
			half TVE_ScreenTexCoord;
			SAMPLER(samplerTVE_ScreenTex3D);


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float3 PositionOS3588_g51941 = v.vertex.xyz;
				half3 _Vector1 = half3(0,0,0);
				half3 Mesh_PivotsOS2291_g51941 = _Vector1;
				float3 temp_output_2283_0_g51941 = ( PositionOS3588_g51941 - Mesh_PivotsOS2291_g51941 );
				half3 VertexPos40_g52293 = temp_output_2283_0_g51941;
				float3 appendResult74_g52293 = (float3(0.0 , VertexPos40_g52293.y , 0.0));
				float3 VertexPosRotationAxis50_g52293 = appendResult74_g52293;
				float3 break84_g52293 = VertexPos40_g52293;
				float3 appendResult81_g52293 = (float3(break84_g52293.x , 0.0 , break84_g52293.z));
				float3 VertexPosOtherAxis82_g52293 = appendResult81_g52293;
				float ObjectData20_g52239 = 3.14;
				float Bounds_Radius121_g51941 = _MaxBoundsInfo.x;
				float WorldData19_g52239 = Bounds_Radius121_g51941;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52239 = WorldData19_g52239;
				#else
				float staticSwitch14_g52239 = ObjectData20_g52239;
				#endif
				float Motion_Max_Rolling1137_g51941 = staticSwitch14_g52239;
				float4x4 break19_g52279 = GetObjectToWorldMatrix();
				float3 appendResult20_g52279 = (float3(break19_g52279[ 0 ][ 3 ] , break19_g52279[ 1 ][ 3 ] , break19_g52279[ 2 ][ 3 ]));
				half3 Off19_g52282 = appendResult20_g52279;
				float3 appendResult93_g52279 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52279 = ( appendResult93_g52279 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52279 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52279 , 0.0 ) ).xyz).xyz;
				half3 On20_g52282 = ( appendResult20_g52279 + PivotsOnly105_g52279 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52282 = On20_g52282;
				#else
				float3 staticSwitch14_g52282 = Off19_g52282;
				#endif
				half3 ObjectData20_g52283 = staticSwitch14_g52282;
				half3 WorldData19_g52283 = Off19_g52282;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52283 = WorldData19_g52283;
				#else
				float3 staticSwitch14_g52283 = ObjectData20_g52283;
				#endif
				float3 temp_output_42_0_g52279 = staticSwitch14_g52283;
				half3 ObjectData20_g52278 = temp_output_42_0_g52279;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				half3 WorldData19_g52278 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52278 = WorldData19_g52278;
				#else
				float3 staticSwitch14_g52278 = ObjectData20_g52278;
				#endif
				float3 Position83_g52277 = staticSwitch14_g52278;
				float temp_output_84_0_g52277 = _LayerMotionValue;
				float4 lerpResult87_g52277 = lerp( TVE_MotionParams , SAMPLE_TEXTURE2D_ARRAY_LOD( TVE_MotionTex, samplerTVE_MotionTex, ( (TVE_MotionCoord).zw + ( (TVE_MotionCoord).xy * (Position83_g52277).xz ) ),temp_output_84_0_g52277, 0.0 ) , TVE_MotionUsage[(int)temp_output_84_0_g52277]);
				half4 Global_Motion_Params3909_g51941 = lerpResult87_g52277;
				float4 break322_g52303 = Global_Motion_Params3909_g51941;
				half Wind_Power369_g52303 = break322_g52303.z;
				float lerpResult410_g52303 = lerp( 0.2 , 1.0 , Wind_Power369_g52303);
				half Wind_Power_203109_g51941 = lerpResult410_g52303;
				half Mesh_Motion_260_g51941 = v.ase_texcoord3.y;
				#ifdef TVE_IS_GRASS_SHADER
				float2 staticSwitch160_g52296 = TVE_NoiseSpeed_Grass;
				#else
				float2 staticSwitch160_g52296 = TVE_NoiseSpeed_Vegetation;
				#endif
				float4x4 break19_g52298 = GetObjectToWorldMatrix();
				float3 appendResult20_g52298 = (float3(break19_g52298[ 0 ][ 3 ] , break19_g52298[ 1 ][ 3 ] , break19_g52298[ 2 ][ 3 ]));
				half3 Off19_g52301 = appendResult20_g52298;
				float3 appendResult93_g52298 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52298 = ( appendResult93_g52298 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52298 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52298 , 0.0 ) ).xyz).xyz;
				half3 On20_g52301 = ( appendResult20_g52298 + PivotsOnly105_g52298 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52301 = On20_g52301;
				#else
				float3 staticSwitch14_g52301 = Off19_g52301;
				#endif
				half3 ObjectData20_g52302 = staticSwitch14_g52301;
				half3 WorldData19_g52302 = Off19_g52301;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52302 = WorldData19_g52302;
				#else
				float3 staticSwitch14_g52302 = ObjectData20_g52302;
				#endif
				float3 temp_output_42_0_g52298 = staticSwitch14_g52302;
				half3 ObjectData20_g52297 = temp_output_42_0_g52298;
				half3 WorldData19_g52297 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52297 = WorldData19_g52297;
				#else
				float3 staticSwitch14_g52297 = ObjectData20_g52297;
				#endif
				#ifdef TVE_IS_GRASS_SHADER
				float2 staticSwitch164_g52296 = (ase_worldPos).xz;
				#else
				float2 staticSwitch164_g52296 = (staticSwitch14_g52297).xz;
				#endif
				#ifdef TVE_IS_GRASS_SHADER
				float staticSwitch161_g52296 = TVE_NoiseSize_Grass;
				#else
				float staticSwitch161_g52296 = TVE_NoiseSize_Vegetation;
				#endif
				float2 panner73_g52296 = ( _TimeParameters.x * staticSwitch160_g52296 + ( staticSwitch164_g52296 * staticSwitch161_g52296 ));
				float4 tex2DNode75_g52296 = SAMPLE_TEXTURE2D_LOD( TVE_NoiseTex, samplerTVE_NoiseTex, panner73_g52296, 0.0 );
				float4 saferPower77_g52296 = max( abs( tex2DNode75_g52296 ) , 0.0001 );
				half Wind_Power2223_g51941 = Wind_Power369_g52303;
				float temp_output_167_0_g52296 = Wind_Power2223_g51941;
				float lerpResult168_g52296 = lerp( 1.5 , 0.25 , temp_output_167_0_g52296);
				float4 temp_cast_7 = (lerpResult168_g52296).xxxx;
				float4 break142_g52296 = pow( saferPower77_g52296 , temp_cast_7 );
				half Global_NoiseTex_R34_g51941 = break142_g52296.r;
				half Input_Speed62_g52276 = _MotionSpeed_20;
				float mulTime354_g52276 = _TimeParameters.x * Input_Speed62_g52276;
				float4x4 break19_g52214 = GetObjectToWorldMatrix();
				float3 appendResult20_g52214 = (float3(break19_g52214[ 0 ][ 3 ] , break19_g52214[ 1 ][ 3 ] , break19_g52214[ 2 ][ 3 ]));
				half3 Off19_g52217 = appendResult20_g52214;
				float3 appendResult93_g52214 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52214 = ( appendResult93_g52214 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52214 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52214 , 0.0 ) ).xyz).xyz;
				half3 On20_g52217 = ( appendResult20_g52214 + PivotsOnly105_g52214 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52217 = On20_g52217;
				#else
				float3 staticSwitch14_g52217 = Off19_g52217;
				#endif
				half3 ObjectData20_g52218 = staticSwitch14_g52217;
				half3 WorldData19_g52218 = Off19_g52217;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52218 = WorldData19_g52218;
				#else
				float3 staticSwitch14_g52218 = ObjectData20_g52218;
				#endif
				float3 temp_output_42_0_g52214 = staticSwitch14_g52218;
				float3 break9_g52214 = temp_output_42_0_g52214;
				half Variation_Complex102_g52212 = frac( ( v.ase_color.r + ( break9_g52214.x + break9_g52214.z ) ) );
				float ObjectData20_g52213 = Variation_Complex102_g52212;
				half Variation_Simple105_g52212 = v.ase_color.r;
				float WorldData19_g52213 = Variation_Simple105_g52212;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52213 = WorldData19_g52213;
				#else
				float staticSwitch14_g52213 = ObjectData20_g52213;
				#endif
				half Motion_Variation3073_g51941 = staticSwitch14_g52213;
				float temp_output_3154_0_g51941 = ( _MotionVariation_20 * Motion_Variation3073_g51941 );
				float Motion_Variation284_g52276 = temp_output_3154_0_g51941;
				float Motion_Scale287_g52276 = ( _MotionScale_20 * ase_worldPos.x );
				half Variation127_g52292 = temp_output_3154_0_g51941;
				float lerpResult110_g52292 = lerp( ceil( saturate( ( frac( ( Variation127_g52292 + 0.3576 ) ) - 0.6 ) ) ) , ceil( saturate( ( frac( ( Variation127_g52292 + 0.1715 ) ) - 0.4 ) ) ) , (sin( _TimeParameters.x )*0.5 + 0.5));
				float temp_output_112_0_g52292 = Wind_Power2223_g51941;
				float lerpResult111_g52292 = lerp( lerpResult110_g52292 , 1.0 , ( temp_output_112_0_g52292 * temp_output_112_0_g52292 * temp_output_112_0_g52292 * temp_output_112_0_g52292 ));
				float lerpResult126_g52292 = lerp( lerpResult111_g52292 , 1.0 , ( 1.0 - saturate( Variation127_g52292 ) ));
				half Motion_Rolling138_g51941 = ( ( _MotionAmplitude_20 * Motion_Max_Rolling1137_g51941 ) * ( Wind_Power_203109_g51941 * Mesh_Motion_260_g51941 * Global_NoiseTex_R34_g51941 * _VertexRollingMode ) * sin( ( mulTime354_g52276 + Motion_Variation284_g52276 + Motion_Scale287_g52276 ) ) * lerpResult126_g52292 );
				half Angle44_g52293 = Motion_Rolling138_g51941;
				half3 VertexPos40_g52260 = ( VertexPosRotationAxis50_g52293 + ( VertexPosOtherAxis82_g52293 * cos( Angle44_g52293 ) ) + ( cross( float3(0,1,0) , VertexPosOtherAxis82_g52293 ) * sin( Angle44_g52293 ) ) );
				float3 appendResult74_g52260 = (float3(VertexPos40_g52260.x , 0.0 , 0.0));
				half3 VertexPosRotationAxis50_g52260 = appendResult74_g52260;
				float3 break84_g52260 = VertexPos40_g52260;
				float3 appendResult81_g52260 = (float3(0.0 , break84_g52260.y , break84_g52260.z));
				half3 VertexPosOtherAxis82_g52260 = appendResult81_g52260;
				float ObjectData20_g52309 = 3.14;
				float Bounds_Height374_g51941 = _MaxBoundsInfo.y;
				float WorldData19_g52309 = ( Bounds_Height374_g51941 * 3.14 );
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52309 = WorldData19_g52309;
				#else
				float staticSwitch14_g52309 = ObjectData20_g52309;
				#endif
				float Motion_Max_Bending1133_g51941 = staticSwitch14_g52309;
				float lerpResult376_g52303 = lerp( 0.1 , 1.0 , Wind_Power369_g52303);
				half Wind_Power_103106_g51941 = lerpResult376_g52303;
				float3 appendResult397_g52303 = (float3(break322_g52303.x , 0.0 , break322_g52303.y));
				float3 temp_output_398_0_g52303 = (appendResult397_g52303*2.0 + -1.0);
				float3 ase_parentObjectScale = ( 1.0 / float3( length( GetWorldToObjectMatrix()[ 0 ].xyz ), length( GetWorldToObjectMatrix()[ 1 ].xyz ), length( GetWorldToObjectMatrix()[ 2 ].xyz ) ) );
				float3 temp_output_339_0_g52303 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_398_0_g52303 , 0.0 ) ).xyz * ase_parentObjectScale );
				half2 Wind_DirectionOS39_g51941 = (temp_output_339_0_g52303).xz;
				half Input_Speed62_g52219 = _MotionSpeed_10;
				float mulTime373_g52219 = _TimeParameters.x * Input_Speed62_g52219;
				half Motion_Variation284_g52219 = ( _MotionVariation_10 * Motion_Variation3073_g51941 );
				float2 appendResult344_g52219 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 Motion_Scale287_g52219 = ( _MotionScale_10 * appendResult344_g52219 );
				half2 Sine_MinusOneToOne281_g52219 = sin( ( mulTime373_g52219 + Motion_Variation284_g52219 + Motion_Scale287_g52219 ) );
				float2 temp_cast_12 = (1.0).xx;
				half Input_Turbulence327_g52219 = Global_NoiseTex_R34_g51941;
				float2 lerpResult321_g52219 = lerp( Sine_MinusOneToOne281_g52219 , temp_cast_12 , Input_Turbulence327_g52219);
				half2 Motion_Bending2258_g51941 = ( ( _MotionAmplitude_10 * Motion_Max_Bending1133_g51941 ) * Wind_Power_103106_g51941 * Wind_DirectionOS39_g51941 * Global_NoiseTex_R34_g51941 * lerpResult321_g52219 );
				half Interaction_Amplitude4137_g51941 = _InteractionAmplitude;
				float4x4 break19_g52271 = GetObjectToWorldMatrix();
				float3 appendResult20_g52271 = (float3(break19_g52271[ 0 ][ 3 ] , break19_g52271[ 1 ][ 3 ] , break19_g52271[ 2 ][ 3 ]));
				half3 Off19_g52274 = appendResult20_g52271;
				float3 appendResult93_g52271 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52271 = ( appendResult93_g52271 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52271 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52271 , 0.0 ) ).xyz).xyz;
				half3 On20_g52274 = ( appendResult20_g52271 + PivotsOnly105_g52271 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52274 = On20_g52274;
				#else
				float3 staticSwitch14_g52274 = Off19_g52274;
				#endif
				half3 ObjectData20_g52275 = staticSwitch14_g52274;
				half3 WorldData19_g52275 = Off19_g52274;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52275 = WorldData19_g52275;
				#else
				float3 staticSwitch14_g52275 = ObjectData20_g52275;
				#endif
				float3 temp_output_42_0_g52271 = staticSwitch14_g52275;
				half3 ObjectData20_g52270 = temp_output_42_0_g52271;
				half3 WorldData19_g52270 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52270 = WorldData19_g52270;
				#else
				float3 staticSwitch14_g52270 = ObjectData20_g52270;
				#endif
				float3 Position83_g52269 = staticSwitch14_g52270;
				float temp_output_84_0_g52269 = _LayerReactValue;
				float4 lerpResult87_g52269 = lerp( TVE_ReactParams , SAMPLE_TEXTURE2D_ARRAY_LOD( TVE_ReactTex, samplerTVE_ReactTex, ( (TVE_ReactCoord).zw + ( (TVE_ReactCoord).xy * (Position83_g52269).xz ) ),temp_output_84_0_g52269, 0.0 ) , TVE_ReactUsage[(int)temp_output_84_0_g52269]);
				half4 Global_React_Params4173_g51941 = lerpResult87_g52269;
				float4 break322_g52256 = Global_React_Params4173_g51941;
				half Interaction_Mask66_g51941 = break322_g52256.z;
				float3 appendResult397_g52256 = (float3(break322_g52256.x , 0.0 , break322_g52256.y));
				float3 temp_output_398_0_g52256 = (appendResult397_g52256*2.0 + -1.0);
				float3 temp_output_339_0_g52256 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_398_0_g52256 , 0.0 ) ).xyz * ase_parentObjectScale );
				half2 Interaction_DirectionOS4158_g51941 = (temp_output_339_0_g52256).xz;
				float lerpResult3307_g51941 = lerp( 1.0 , Motion_Variation3073_g51941 , _InteractionVariation);
				half2 Motion_Interaction53_g51941 = ( Interaction_Amplitude4137_g51941 * Motion_Max_Bending1133_g51941 * Interaction_Mask66_g51941 * Interaction_Mask66_g51941 * Interaction_DirectionOS4158_g51941 * lerpResult3307_g51941 );
				float2 lerpResult109_g51941 = lerp( Motion_Bending2258_g51941 , Motion_Interaction53_g51941 , ( Interaction_Mask66_g51941 * saturate( Interaction_Amplitude4137_g51941 ) ));
				half Mesh_Motion_182_g51941 = v.ase_texcoord3.x;
				float2 break143_g51941 = ( lerpResult109_g51941 * Mesh_Motion_182_g51941 );
				half Motion_Z190_g51941 = break143_g51941.y;
				half Angle44_g52260 = Motion_Z190_g51941;
				half3 VertexPos40_g52259 = ( VertexPosRotationAxis50_g52260 + ( VertexPosOtherAxis82_g52260 * cos( Angle44_g52260 ) ) + ( cross( float3(1,0,0) , VertexPosOtherAxis82_g52260 ) * sin( Angle44_g52260 ) ) );
				float3 appendResult74_g52259 = (float3(0.0 , 0.0 , VertexPos40_g52259.z));
				half3 VertexPosRotationAxis50_g52259 = appendResult74_g52259;
				float3 break84_g52259 = VertexPos40_g52259;
				float3 appendResult81_g52259 = (float3(break84_g52259.x , break84_g52259.y , 0.0));
				half3 VertexPosOtherAxis82_g52259 = appendResult81_g52259;
				half Motion_X216_g51941 = break143_g51941.x;
				half Angle44_g52259 = -Motion_X216_g51941;
				float3 Vertex_Motion_Object833_g51941 = ( VertexPosRotationAxis50_g52259 + ( VertexPosOtherAxis82_g52259 * cos( Angle44_g52259 ) ) + ( cross( float3(0,0,1) , VertexPosOtherAxis82_g52259 ) * sin( Angle44_g52259 ) ) );
				float3 temp_output_3474_0_g51941 = ( PositionOS3588_g51941 - Mesh_PivotsOS2291_g51941 );
				float3 appendResult2047_g51941 = (float3(Motion_Rolling138_g51941 , 0.0 , -Motion_Rolling138_g51941));
				float3 appendResult2043_g51941 = (float3(Motion_X216_g51941 , 0.0 , Motion_Z190_g51941));
				float3 Vertex_Motion_World1118_g51941 = ( ( temp_output_3474_0_g51941 + appendResult2047_g51941 ) + appendResult2043_g51941 );
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch3312_g51941 = Vertex_Motion_World1118_g51941;
				#else
				float3 staticSwitch3312_g51941 = ( Vertex_Motion_Object833_g51941 + ( 0.0 * _VertexDataMode ) );
				#endif
				half Global_Vertex_Size174_g51941 = break322_g52256.w;
				float lerpResult346_g51941 = lerp( 1.0 , Global_Vertex_Size174_g51941 , _GlobalSize);
				float3 appendResult3480_g51941 = (float3(lerpResult346_g51941 , lerpResult346_g51941 , lerpResult346_g51941));
				half3 ObjectData20_g52294 = appendResult3480_g51941;
				half3 _Vector11 = half3(1,1,1);
				half3 WorldData19_g52294 = _Vector11;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52294 = WorldData19_g52294;
				#else
				float3 staticSwitch14_g52294 = ObjectData20_g52294;
				#endif
				half3 Vertex_Size1741_g51941 = staticSwitch14_g52294;
				half3 _Vector5 = half3(1,1,1);
				float3 Vertex_SizeFade1740_g51941 = _Vector5;
				half3 Grass_Coverage2661_g51941 = half3(0,0,0);
				float3 Final_VertexPosition890_g51941 = ( ( staticSwitch3312_g51941 * Vertex_Size1741_g51941 * Vertex_SizeFade1740_g51941 ) + Mesh_PivotsOS2291_g51941 + Grass_Coverage2661_g51941 );
				
				float2 vertexToFrag11_g52308 = ( ( v.ase_texcoord.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				o.ase_texcoord2.xy = vertexToFrag11_g52308;
				float2 appendResult21_g52242 = (float2(v.ase_texcoord.z , v.ase_texcoord.w));
				float2 Mesh_DetailCoord3_g51941 = appendResult21_g52242;
				float2 vertexToFrag11_g52243 = ( ( Mesh_DetailCoord3_g51941 * (_SecondUVs).xy ) + (_SecondUVs).zw );
				o.ase_texcoord2.zw = vertexToFrag11_g52243;
				half Mesh_DetailMask90_g51941 = v.ase_color.b;
				float vertexToFrag11_g52208 = ( ( Mesh_DetailMask90_g51941 - 0.5 ) + _DetailMeshValue );
				o.ase_texcoord3.x = vertexToFrag11_g52208;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord3.yzw = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord4.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord5.xyz = ase_worldBitangent;
				float3 vertexToFrag3890_g51941 = ase_worldPos;
				o.ase_texcoord6.xyz = vertexToFrag3890_g51941;
				
				float temp_output_7_0_g52252 = TVE_CameraFadeStart;
				float saferPower3976_g51941 = max( saturate( ( ( distance( ase_worldPos , _WorldSpaceCameraPos ) - temp_output_7_0_g52252 ) / ( TVE_CameraFadeEnd - temp_output_7_0_g52252 ) ) ) , 0.0001 );
				float temp_output_3976_0_g51941 = pow( saferPower3976_g51941 , _FadeCameraValue );
				float vertexToFrag11_g52251 = temp_output_3976_0_g51941;
				o.ase_texcoord4.w = vertexToFrag11_g52251;
				
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord5.w = 0;
				o.ase_texcoord6.w = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = Final_VertexPosition890_g51941;
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
				float4 ase_texcoord3 : TEXCOORD3;
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
				o.ase_texcoord3 = v.ase_texcoord3;
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
				o.ase_texcoord3 = patch[0].ase_texcoord3 * bary.x + patch[1].ase_texcoord3 * bary.y + patch[2].ase_texcoord3 * bary.z;
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
				half2 Main_UVs15_g51941 = vertexToFrag11_g52308;
				float4 tex2DNode29_g51941 = SAMPLE_TEXTURE2D( _MainAlbedoTex, sampler_MainAlbedoTex, Main_UVs15_g51941 );
				float3 temp_output_51_0_g51941 = ( (_MainColor).rgb * (tex2DNode29_g51941).rgb );
				half3 Main_Albedo99_g51941 = temp_output_51_0_g51941;
				float2 vertexToFrag11_g52243 = IN.ase_texcoord2.zw;
				half2 Second_UVs17_g51941 = vertexToFrag11_g52243;
				half3 Second_Albedo153_g51941 = (( _SecondColor * SAMPLE_TEXTURE2D( _SecondAlbedoTex, sampler_SecondMaskTex, Second_UVs17_g51941 ) )).rgb;
				#ifdef UNITY_COLORSPACE_GAMMA
				float staticSwitch1_g52209 = 2.0;
				#else
				float staticSwitch1_g52209 = 4.594794;
				#endif
				float vertexToFrag11_g52208 = IN.ase_texcoord3.x;
				float temp_output_3919_0_g51941 = vertexToFrag11_g52208;
				half Blend_Source1540_g51941 = temp_output_3919_0_g51941;
				float4 tex2DNode35_g51941 = SAMPLE_TEXTURE2D( _MainMaskTex, sampler_MainAlbedoTex, Main_UVs15_g51941 );
				half Main_Mask57_g51941 = tex2DNode35_g51941.b;
				float4 tex2DNode33_g51941 = SAMPLE_TEXTURE2D( _SecondMaskTex, sampler_SecondMaskTex, Second_UVs17_g51941 );
				half Second_Mask81_g51941 = tex2DNode33_g51941.b;
				float lerpResult1327_g51941 = lerp( Main_Mask57_g51941 , Second_Mask81_g51941 , _DetailMaskMode);
				float lerpResult4058_g51941 = lerp( lerpResult1327_g51941 , ( 1.0 - lerpResult1327_g51941 ) , _DetailMaskInvertMode);
				float temp_output_7_0_g52238 = _DetailBlendMinValue;
				half Mask_Detail147_g51941 = saturate( ( ( saturate( ( Blend_Source1540_g51941 + ( Blend_Source1540_g51941 * lerpResult4058_g51941 ) ) ) - temp_output_7_0_g52238 ) / ( _DetailBlendMaxValue - temp_output_7_0_g52238 ) ) );
				float3 lerpResult235_g51941 = lerp( Main_Albedo99_g51941 , ( Main_Albedo99_g51941 * Second_Albedo153_g51941 * staticSwitch1_g52209 ) , Mask_Detail147_g51941);
				float3 lerpResult208_g51941 = lerp( Main_Albedo99_g51941 , Second_Albedo153_g51941 , Mask_Detail147_g51941);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float3 staticSwitch4062_g51941 = lerpResult235_g51941;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float3 staticSwitch4062_g51941 = lerpResult208_g51941;
				#else
				float3 staticSwitch4062_g51941 = lerpResult235_g51941;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float3 staticSwitch255_g51941 = Main_Albedo99_g51941;
				#elif defined(TVE_DETAIL_MODE_ON)
				float3 staticSwitch255_g51941 = staticSwitch4062_g51941;
				#else
				float3 staticSwitch255_g51941 = Main_Albedo99_g51941;
				#endif
				half3 Blend_Albedo265_g51941 = staticSwitch255_g51941;
				half3 Blend_AlbedoTinted2808_g51941 = ( float3(1,1,1) * float3(1,1,1) * float3(1,1,1) * Blend_Albedo265_g51941 );
				half3 Blend_AlbedoColored863_g51941 = Blend_AlbedoTinted2808_g51941;
				half3 Blend_AlbedoAndSubsurface149_g51941 = Blend_AlbedoColored863_g51941;
				half3 Global_OverlayColor1758_g51941 = (TVE_OverlayColor).rgb;
				float3 unpack4112_g51941 = UnpackNormalScale( SAMPLE_TEXTURE2D( _MainNormalTex, sampler_MainAlbedoTex, Main_UVs15_g51941 ), _MainNormalValue );
				unpack4112_g51941.z = lerp( 1, unpack4112_g51941.z, saturate(_MainNormalValue) );
				half3 Main_Normal137_g51941 = unpack4112_g51941;
				float3 ase_worldTangent = IN.ase_texcoord3.yzw;
				float3 ase_worldNormal = IN.ase_texcoord4.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord5.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal4099_g51941 = Main_Normal137_g51941;
				float3 worldNormal4099_g51941 = float3(dot(tanToWorld0,tanNormal4099_g51941), dot(tanToWorld1,tanNormal4099_g51941), dot(tanToWorld2,tanNormal4099_g51941));
				float3 Main_Normal_WS4101_g51941 = worldNormal4099_g51941;
				float lerpResult3567_g51941 = lerp( _OverlayBottomValue , 1.0 , Main_Normal_WS4101_g51941.y);
				half Main_AlbedoTex_G3526_g51941 = tex2DNode29_g51941.g;
				half Second_AlbedoTex_G3581_g51941 = (SAMPLE_TEXTURE2D( _SecondAlbedoTex, sampler_SecondMaskTex, Second_UVs17_g51941 )).g;
				float lerpResult3579_g51941 = lerp( Main_AlbedoTex_G3526_g51941 , Second_AlbedoTex_G3581_g51941 , Mask_Detail147_g51941);
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch3574_g51941 = Main_AlbedoTex_G3526_g51941;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch3574_g51941 = lerpResult3579_g51941;
				#else
				float staticSwitch3574_g51941 = Main_AlbedoTex_G3526_g51941;
				#endif
				float3 vertexToFrag3890_g51941 = IN.ase_texcoord6.xyz;
				float3 PositionWS_PerVertex3905_g51941 = vertexToFrag3890_g51941;
				float3 Position82_g52261 = PositionWS_PerVertex3905_g51941;
				float temp_output_84_0_g52261 = _LayerExtrasValue;
				float4 lerpResult88_g52261 = lerp( TVE_ExtrasParams , SAMPLE_TEXTURE2D_ARRAY( TVE_ExtrasTex, samplerTVE_ExtrasTex, ( (TVE_ExtrasCoord).zw + ( (TVE_ExtrasCoord).xy * (Position82_g52261).xz ) ),temp_output_84_0_g52261 ) , TVE_ExtrasUsage[(int)temp_output_84_0_g52261]);
				float4 break89_g52261 = lerpResult88_g52261;
				half Global_Extras_Overlay156_g51941 = break89_g52261.b;
				float temp_output_1025_0_g51941 = ( _GlobalOverlay * Global_Extras_Overlay156_g51941 );
				half Overlay_Commons1365_g51941 = temp_output_1025_0_g51941;
				float temp_output_7_0_g52234 = _OverlayMaskMinValue;
				half Overlay_Mask269_g51941 = saturate( ( ( ( ( ( lerpResult3567_g51941 * 0.5 ) + staticSwitch3574_g51941 ) * Overlay_Commons1365_g51941 ) - temp_output_7_0_g52234 ) / ( _OverlayMaskMaxValue - temp_output_7_0_g52234 ) ) );
				float3 lerpResult336_g51941 = lerp( Blend_AlbedoAndSubsurface149_g51941 , Global_OverlayColor1758_g51941 , Overlay_Mask269_g51941);
				half3 Final_Albedo359_g51941 = lerpResult336_g51941;
				float3 temp_cast_3 = (1.0).xxx;
				float Mesh_Occlusion318_g51941 = IN.ase_color.g;
				float temp_output_7_0_g52232 = _VertexOcclusionMinValue;
				float3 lerpResult2945_g51941 = lerp( (_VertexOcclusionColor).rgb , temp_cast_3 , saturate( ( ( Mesh_Occlusion318_g51941 - temp_output_7_0_g52232 ) / ( _VertexOcclusionMaxValue - temp_output_7_0_g52232 ) ) ));
				float3 Vertex_Occlusion648_g51941 = lerpResult2945_g51941;
				
				float localCustomAlphaClip3735_g51941 = ( 0.0 );
				float vertexToFrag11_g52251 = IN.ase_texcoord4.w;
				half Fade_Camera3743_g51941 = vertexToFrag11_g52251;
				half Final_AlphaFade3727_g51941 = ( 1.0 * Fade_Camera3743_g51941 );
				float temp_output_41_0_g52255 = Final_AlphaFade3727_g51941;
				float Main_Alpha316_g51941 = ( _MainColor.a * tex2DNode29_g51941.a );
				half AlphaTreshold2132_g51941 = _Cutoff;
				#ifdef TVE_ALPHA_CLIP
				float staticSwitch3792_g51941 = ( Main_Alpha316_g51941 - ( AlphaTreshold2132_g51941 - 0.5 ) );
				#else
				float staticSwitch3792_g51941 = Main_Alpha316_g51941;
				#endif
				half Final_Alpha3754_g51941 = staticSwitch3792_g51941;
				float temp_output_661_0_g51941 = ( saturate( ( temp_output_41_0_g52255 + ( temp_output_41_0_g52255 * SAMPLE_TEXTURE3D( TVE_ScreenTex3D, samplerTVE_ScreenTex3D, ( TVE_ScreenTexCoord * PositionWS_PerVertex3905_g51941 ) ).r ) ) ) * Final_Alpha3754_g51941 );
				float Alpha3735_g51941 = temp_output_661_0_g51941;
				float Treshold3735_g51941 = 0.5;
				{
				#if TVE_ALPHA_CLIP
				clip(Alpha3735_g51941 - Treshold3735_g51941);
				#endif
				}
				half Final_Clip914_g51941 = saturate( Alpha3735_g51941 );
				
				
				float3 Albedo = ( Final_Albedo359_g51941 * Vertex_Occlusion648_g51941 );
				float Alpha = Final_Clip914_g51941;
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
			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define ASE_ABSOLUTE_VERTEX_POS 1
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

			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local TVE_ALPHA_CLIP
			#pragma shader_feature_local TVE_VERTEX_DATA_BATCHED
			//TVE Pipeline Defines
			#define THE_VEGETATION_ENGINE
			#define IS_UNIVERSAL_PIPELINE
			//TVE Shader Type Defines
			#define TVE_IS_VEGETATION_SHADER
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
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
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
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			half4 _SecondUVs;
			half4 _VertexOcclusionColor;
			float4 _SubsurfaceDiffusion_Asset;
			half4 _SecondColor;
			half4 _EmissiveColor;
			float4 _NoiseMaskRemap;
			half4 _ColorsMaskRemap;
			half4 _SubsurfaceMaskRemap;
			half4 _OverlayMaskRemap;
			float4 _GradientMaskRemap;
			half4 _VertexOcclusionRemap;
			half4 _DetailBlendRemap;
			float4 _Color;
			half4 _MainColor;
			half4 _MainUVs;
			float4 _MaxBoundsInfo;
			half4 _EmissiveUVs;
			float4 _SubsurfaceDiffusion_asset;
			half3 _render_normals_options;
			half _VertexDataMode;
			half _InteractionAmplitude;
			half _GlobalSize;
			half _InteractionVariation;
			half _LayerReactValue;
			half _MotionVariation_20;
			half _MotionVariation_10;
			float _MotionSpeed_10;
			half _MotionAmplitude_10;
			half _MotionScale_20;
			half _MotionSpeed_20;
			half _VertexRollingMode;
			half _LayerMotionValue;
			half _vertex_pivot_mode;
			half _MotionAmplitude_20;
			float _MotionScale_10;
			half _render_dst;
			half _OverlayBottomValue;
			half _DetailMaskMode;
			half _MainOcclusionValue;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half _RenderSpecular;
			half _GlobalEmissive;
			half _DetailNormalValue;
			half _SecondNormalValue;
			half _VertexOcclusionMaxValue;
			half _VertexOcclusionMinValue;
			half _OverlayMaskMaxValue;
			half _OverlayMaskMinValue;
			half _LayerExtrasValue;
			half _GlobalOverlay;
			half _MainNormalValue;
			half _EmissiveFlagMode;
			half _DetailBlendMaxValue;
			half _DetailBlendMinValue;
			half _DetailMaskInvertMode;
			half _DetailMeshValue;
			half _RenderMode;
			float _SubsurfaceDiffusion;
			half _RenderDecals;
			half _RenderPriority;
			half _TranslucencyIntensityValue;
			half _EmissiveCat;
			half _ReceiveSpace;
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
			half _IsBarkShader;
			half _IsStandardShader;
			half _render_src;
			half _render_cull;
			half _render_zw;
			half _NoiseCat;
			half _SizeFadeCat;
			half _TranslucencyAmbientValue;
			half _VertexMasksMode;
			half _RenderZWrite;
			half _TranslucencyShadowValue;
			half _RenderSSR;
			half _SecondOcclusionValue;
			half _MotionSpace;
			half _RenderCull;
			half _PerspectiveCat;
			half _VertexVariationMode;
			half _GradientCat;
			half _TranslucencyDirectValue;
			half _FadeSpace;
			half _GlobalCat;
			half _IsTVEShader;
			half _DetailSpace;
			half _DetailTypeMode;
			half _DetailCat;
			half _TranslucencyScatteringValue;
			half _TranslucencyNormalValue;
			half _RenderClip;
			half _IsVersion;
			half _RenderingCat;
			half _VariationMotionMessage;
			half _FadeCameraValue;
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
			half4 TVE_MotionParams;
			TEXTURE2D_ARRAY(TVE_MotionTex);
			half4 TVE_MotionCoord;
			SAMPLER(samplerTVE_MotionTex);
			float TVE_MotionUsage[9];
			TEXTURE2D(TVE_NoiseTex);
			float2 TVE_NoiseSpeed_Vegetation;
			float2 TVE_NoiseSpeed_Grass;
			half TVE_NoiseSize_Vegetation;
			half TVE_NoiseSize_Grass;
			SAMPLER(samplerTVE_NoiseTex);
			half4 TVE_ReactParams;
			TEXTURE2D_ARRAY(TVE_ReactTex);
			half4 TVE_ReactCoord;
			SAMPLER(samplerTVE_ReactTex);
			float TVE_ReactUsage[9];
			half TVE_CameraFadeStart;
			half TVE_CameraFadeEnd;
			TEXTURE3D(TVE_ScreenTex3D);
			half TVE_ScreenTexCoord;
			SAMPLER(samplerTVE_ScreenTex3D);
			TEXTURE2D(_MainAlbedoTex);
			SAMPLER(sampler_MainAlbedoTex);


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 PositionOS3588_g51941 = v.vertex.xyz;
				half3 _Vector1 = half3(0,0,0);
				half3 Mesh_PivotsOS2291_g51941 = _Vector1;
				float3 temp_output_2283_0_g51941 = ( PositionOS3588_g51941 - Mesh_PivotsOS2291_g51941 );
				half3 VertexPos40_g52293 = temp_output_2283_0_g51941;
				float3 appendResult74_g52293 = (float3(0.0 , VertexPos40_g52293.y , 0.0));
				float3 VertexPosRotationAxis50_g52293 = appendResult74_g52293;
				float3 break84_g52293 = VertexPos40_g52293;
				float3 appendResult81_g52293 = (float3(break84_g52293.x , 0.0 , break84_g52293.z));
				float3 VertexPosOtherAxis82_g52293 = appendResult81_g52293;
				float ObjectData20_g52239 = 3.14;
				float Bounds_Radius121_g51941 = _MaxBoundsInfo.x;
				float WorldData19_g52239 = Bounds_Radius121_g51941;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52239 = WorldData19_g52239;
				#else
				float staticSwitch14_g52239 = ObjectData20_g52239;
				#endif
				float Motion_Max_Rolling1137_g51941 = staticSwitch14_g52239;
				float4x4 break19_g52279 = GetObjectToWorldMatrix();
				float3 appendResult20_g52279 = (float3(break19_g52279[ 0 ][ 3 ] , break19_g52279[ 1 ][ 3 ] , break19_g52279[ 2 ][ 3 ]));
				half3 Off19_g52282 = appendResult20_g52279;
				float3 appendResult93_g52279 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52279 = ( appendResult93_g52279 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52279 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52279 , 0.0 ) ).xyz).xyz;
				half3 On20_g52282 = ( appendResult20_g52279 + PivotsOnly105_g52279 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52282 = On20_g52282;
				#else
				float3 staticSwitch14_g52282 = Off19_g52282;
				#endif
				half3 ObjectData20_g52283 = staticSwitch14_g52282;
				half3 WorldData19_g52283 = Off19_g52282;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52283 = WorldData19_g52283;
				#else
				float3 staticSwitch14_g52283 = ObjectData20_g52283;
				#endif
				float3 temp_output_42_0_g52279 = staticSwitch14_g52283;
				half3 ObjectData20_g52278 = temp_output_42_0_g52279;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				half3 WorldData19_g52278 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52278 = WorldData19_g52278;
				#else
				float3 staticSwitch14_g52278 = ObjectData20_g52278;
				#endif
				float3 Position83_g52277 = staticSwitch14_g52278;
				float temp_output_84_0_g52277 = _LayerMotionValue;
				float4 lerpResult87_g52277 = lerp( TVE_MotionParams , SAMPLE_TEXTURE2D_ARRAY_LOD( TVE_MotionTex, samplerTVE_MotionTex, ( (TVE_MotionCoord).zw + ( (TVE_MotionCoord).xy * (Position83_g52277).xz ) ),temp_output_84_0_g52277, 0.0 ) , TVE_MotionUsage[(int)temp_output_84_0_g52277]);
				half4 Global_Motion_Params3909_g51941 = lerpResult87_g52277;
				float4 break322_g52303 = Global_Motion_Params3909_g51941;
				half Wind_Power369_g52303 = break322_g52303.z;
				float lerpResult410_g52303 = lerp( 0.2 , 1.0 , Wind_Power369_g52303);
				half Wind_Power_203109_g51941 = lerpResult410_g52303;
				half Mesh_Motion_260_g51941 = v.ase_texcoord3.y;
				#ifdef TVE_IS_GRASS_SHADER
				float2 staticSwitch160_g52296 = TVE_NoiseSpeed_Grass;
				#else
				float2 staticSwitch160_g52296 = TVE_NoiseSpeed_Vegetation;
				#endif
				float4x4 break19_g52298 = GetObjectToWorldMatrix();
				float3 appendResult20_g52298 = (float3(break19_g52298[ 0 ][ 3 ] , break19_g52298[ 1 ][ 3 ] , break19_g52298[ 2 ][ 3 ]));
				half3 Off19_g52301 = appendResult20_g52298;
				float3 appendResult93_g52298 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52298 = ( appendResult93_g52298 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52298 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52298 , 0.0 ) ).xyz).xyz;
				half3 On20_g52301 = ( appendResult20_g52298 + PivotsOnly105_g52298 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52301 = On20_g52301;
				#else
				float3 staticSwitch14_g52301 = Off19_g52301;
				#endif
				half3 ObjectData20_g52302 = staticSwitch14_g52301;
				half3 WorldData19_g52302 = Off19_g52301;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52302 = WorldData19_g52302;
				#else
				float3 staticSwitch14_g52302 = ObjectData20_g52302;
				#endif
				float3 temp_output_42_0_g52298 = staticSwitch14_g52302;
				half3 ObjectData20_g52297 = temp_output_42_0_g52298;
				half3 WorldData19_g52297 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52297 = WorldData19_g52297;
				#else
				float3 staticSwitch14_g52297 = ObjectData20_g52297;
				#endif
				#ifdef TVE_IS_GRASS_SHADER
				float2 staticSwitch164_g52296 = (ase_worldPos).xz;
				#else
				float2 staticSwitch164_g52296 = (staticSwitch14_g52297).xz;
				#endif
				#ifdef TVE_IS_GRASS_SHADER
				float staticSwitch161_g52296 = TVE_NoiseSize_Grass;
				#else
				float staticSwitch161_g52296 = TVE_NoiseSize_Vegetation;
				#endif
				float2 panner73_g52296 = ( _TimeParameters.x * staticSwitch160_g52296 + ( staticSwitch164_g52296 * staticSwitch161_g52296 ));
				float4 tex2DNode75_g52296 = SAMPLE_TEXTURE2D_LOD( TVE_NoiseTex, samplerTVE_NoiseTex, panner73_g52296, 0.0 );
				float4 saferPower77_g52296 = max( abs( tex2DNode75_g52296 ) , 0.0001 );
				half Wind_Power2223_g51941 = Wind_Power369_g52303;
				float temp_output_167_0_g52296 = Wind_Power2223_g51941;
				float lerpResult168_g52296 = lerp( 1.5 , 0.25 , temp_output_167_0_g52296);
				float4 temp_cast_7 = (lerpResult168_g52296).xxxx;
				float4 break142_g52296 = pow( saferPower77_g52296 , temp_cast_7 );
				half Global_NoiseTex_R34_g51941 = break142_g52296.r;
				half Input_Speed62_g52276 = _MotionSpeed_20;
				float mulTime354_g52276 = _TimeParameters.x * Input_Speed62_g52276;
				float4x4 break19_g52214 = GetObjectToWorldMatrix();
				float3 appendResult20_g52214 = (float3(break19_g52214[ 0 ][ 3 ] , break19_g52214[ 1 ][ 3 ] , break19_g52214[ 2 ][ 3 ]));
				half3 Off19_g52217 = appendResult20_g52214;
				float3 appendResult93_g52214 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52214 = ( appendResult93_g52214 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52214 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52214 , 0.0 ) ).xyz).xyz;
				half3 On20_g52217 = ( appendResult20_g52214 + PivotsOnly105_g52214 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52217 = On20_g52217;
				#else
				float3 staticSwitch14_g52217 = Off19_g52217;
				#endif
				half3 ObjectData20_g52218 = staticSwitch14_g52217;
				half3 WorldData19_g52218 = Off19_g52217;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52218 = WorldData19_g52218;
				#else
				float3 staticSwitch14_g52218 = ObjectData20_g52218;
				#endif
				float3 temp_output_42_0_g52214 = staticSwitch14_g52218;
				float3 break9_g52214 = temp_output_42_0_g52214;
				half Variation_Complex102_g52212 = frac( ( v.ase_color.r + ( break9_g52214.x + break9_g52214.z ) ) );
				float ObjectData20_g52213 = Variation_Complex102_g52212;
				half Variation_Simple105_g52212 = v.ase_color.r;
				float WorldData19_g52213 = Variation_Simple105_g52212;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52213 = WorldData19_g52213;
				#else
				float staticSwitch14_g52213 = ObjectData20_g52213;
				#endif
				half Motion_Variation3073_g51941 = staticSwitch14_g52213;
				float temp_output_3154_0_g51941 = ( _MotionVariation_20 * Motion_Variation3073_g51941 );
				float Motion_Variation284_g52276 = temp_output_3154_0_g51941;
				float Motion_Scale287_g52276 = ( _MotionScale_20 * ase_worldPos.x );
				half Variation127_g52292 = temp_output_3154_0_g51941;
				float lerpResult110_g52292 = lerp( ceil( saturate( ( frac( ( Variation127_g52292 + 0.3576 ) ) - 0.6 ) ) ) , ceil( saturate( ( frac( ( Variation127_g52292 + 0.1715 ) ) - 0.4 ) ) ) , (sin( _TimeParameters.x )*0.5 + 0.5));
				float temp_output_112_0_g52292 = Wind_Power2223_g51941;
				float lerpResult111_g52292 = lerp( lerpResult110_g52292 , 1.0 , ( temp_output_112_0_g52292 * temp_output_112_0_g52292 * temp_output_112_0_g52292 * temp_output_112_0_g52292 ));
				float lerpResult126_g52292 = lerp( lerpResult111_g52292 , 1.0 , ( 1.0 - saturate( Variation127_g52292 ) ));
				half Motion_Rolling138_g51941 = ( ( _MotionAmplitude_20 * Motion_Max_Rolling1137_g51941 ) * ( Wind_Power_203109_g51941 * Mesh_Motion_260_g51941 * Global_NoiseTex_R34_g51941 * _VertexRollingMode ) * sin( ( mulTime354_g52276 + Motion_Variation284_g52276 + Motion_Scale287_g52276 ) ) * lerpResult126_g52292 );
				half Angle44_g52293 = Motion_Rolling138_g51941;
				half3 VertexPos40_g52260 = ( VertexPosRotationAxis50_g52293 + ( VertexPosOtherAxis82_g52293 * cos( Angle44_g52293 ) ) + ( cross( float3(0,1,0) , VertexPosOtherAxis82_g52293 ) * sin( Angle44_g52293 ) ) );
				float3 appendResult74_g52260 = (float3(VertexPos40_g52260.x , 0.0 , 0.0));
				half3 VertexPosRotationAxis50_g52260 = appendResult74_g52260;
				float3 break84_g52260 = VertexPos40_g52260;
				float3 appendResult81_g52260 = (float3(0.0 , break84_g52260.y , break84_g52260.z));
				half3 VertexPosOtherAxis82_g52260 = appendResult81_g52260;
				float ObjectData20_g52309 = 3.14;
				float Bounds_Height374_g51941 = _MaxBoundsInfo.y;
				float WorldData19_g52309 = ( Bounds_Height374_g51941 * 3.14 );
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52309 = WorldData19_g52309;
				#else
				float staticSwitch14_g52309 = ObjectData20_g52309;
				#endif
				float Motion_Max_Bending1133_g51941 = staticSwitch14_g52309;
				float lerpResult376_g52303 = lerp( 0.1 , 1.0 , Wind_Power369_g52303);
				half Wind_Power_103106_g51941 = lerpResult376_g52303;
				float3 appendResult397_g52303 = (float3(break322_g52303.x , 0.0 , break322_g52303.y));
				float3 temp_output_398_0_g52303 = (appendResult397_g52303*2.0 + -1.0);
				float3 ase_parentObjectScale = ( 1.0 / float3( length( GetWorldToObjectMatrix()[ 0 ].xyz ), length( GetWorldToObjectMatrix()[ 1 ].xyz ), length( GetWorldToObjectMatrix()[ 2 ].xyz ) ) );
				float3 temp_output_339_0_g52303 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_398_0_g52303 , 0.0 ) ).xyz * ase_parentObjectScale );
				half2 Wind_DirectionOS39_g51941 = (temp_output_339_0_g52303).xz;
				half Input_Speed62_g52219 = _MotionSpeed_10;
				float mulTime373_g52219 = _TimeParameters.x * Input_Speed62_g52219;
				half Motion_Variation284_g52219 = ( _MotionVariation_10 * Motion_Variation3073_g51941 );
				float2 appendResult344_g52219 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 Motion_Scale287_g52219 = ( _MotionScale_10 * appendResult344_g52219 );
				half2 Sine_MinusOneToOne281_g52219 = sin( ( mulTime373_g52219 + Motion_Variation284_g52219 + Motion_Scale287_g52219 ) );
				float2 temp_cast_12 = (1.0).xx;
				half Input_Turbulence327_g52219 = Global_NoiseTex_R34_g51941;
				float2 lerpResult321_g52219 = lerp( Sine_MinusOneToOne281_g52219 , temp_cast_12 , Input_Turbulence327_g52219);
				half2 Motion_Bending2258_g51941 = ( ( _MotionAmplitude_10 * Motion_Max_Bending1133_g51941 ) * Wind_Power_103106_g51941 * Wind_DirectionOS39_g51941 * Global_NoiseTex_R34_g51941 * lerpResult321_g52219 );
				half Interaction_Amplitude4137_g51941 = _InteractionAmplitude;
				float4x4 break19_g52271 = GetObjectToWorldMatrix();
				float3 appendResult20_g52271 = (float3(break19_g52271[ 0 ][ 3 ] , break19_g52271[ 1 ][ 3 ] , break19_g52271[ 2 ][ 3 ]));
				half3 Off19_g52274 = appendResult20_g52271;
				float3 appendResult93_g52271 = (float3(v.ase_texcoord.z , v.ase_texcoord3.w , v.ase_texcoord.w));
				float3 temp_output_91_0_g52271 = ( appendResult93_g52271 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52271 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52271 , 0.0 ) ).xyz).xyz;
				half3 On20_g52274 = ( appendResult20_g52271 + PivotsOnly105_g52271 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52274 = On20_g52274;
				#else
				float3 staticSwitch14_g52274 = Off19_g52274;
				#endif
				half3 ObjectData20_g52275 = staticSwitch14_g52274;
				half3 WorldData19_g52275 = Off19_g52274;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52275 = WorldData19_g52275;
				#else
				float3 staticSwitch14_g52275 = ObjectData20_g52275;
				#endif
				float3 temp_output_42_0_g52271 = staticSwitch14_g52275;
				half3 ObjectData20_g52270 = temp_output_42_0_g52271;
				half3 WorldData19_g52270 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52270 = WorldData19_g52270;
				#else
				float3 staticSwitch14_g52270 = ObjectData20_g52270;
				#endif
				float3 Position83_g52269 = staticSwitch14_g52270;
				float temp_output_84_0_g52269 = _LayerReactValue;
				float4 lerpResult87_g52269 = lerp( TVE_ReactParams , SAMPLE_TEXTURE2D_ARRAY_LOD( TVE_ReactTex, samplerTVE_ReactTex, ( (TVE_ReactCoord).zw + ( (TVE_ReactCoord).xy * (Position83_g52269).xz ) ),temp_output_84_0_g52269, 0.0 ) , TVE_ReactUsage[(int)temp_output_84_0_g52269]);
				half4 Global_React_Params4173_g51941 = lerpResult87_g52269;
				float4 break322_g52256 = Global_React_Params4173_g51941;
				half Interaction_Mask66_g51941 = break322_g52256.z;
				float3 appendResult397_g52256 = (float3(break322_g52256.x , 0.0 , break322_g52256.y));
				float3 temp_output_398_0_g52256 = (appendResult397_g52256*2.0 + -1.0);
				float3 temp_output_339_0_g52256 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_398_0_g52256 , 0.0 ) ).xyz * ase_parentObjectScale );
				half2 Interaction_DirectionOS4158_g51941 = (temp_output_339_0_g52256).xz;
				float lerpResult3307_g51941 = lerp( 1.0 , Motion_Variation3073_g51941 , _InteractionVariation);
				half2 Motion_Interaction53_g51941 = ( Interaction_Amplitude4137_g51941 * Motion_Max_Bending1133_g51941 * Interaction_Mask66_g51941 * Interaction_Mask66_g51941 * Interaction_DirectionOS4158_g51941 * lerpResult3307_g51941 );
				float2 lerpResult109_g51941 = lerp( Motion_Bending2258_g51941 , Motion_Interaction53_g51941 , ( Interaction_Mask66_g51941 * saturate( Interaction_Amplitude4137_g51941 ) ));
				half Mesh_Motion_182_g51941 = v.ase_texcoord3.x;
				float2 break143_g51941 = ( lerpResult109_g51941 * Mesh_Motion_182_g51941 );
				half Motion_Z190_g51941 = break143_g51941.y;
				half Angle44_g52260 = Motion_Z190_g51941;
				half3 VertexPos40_g52259 = ( VertexPosRotationAxis50_g52260 + ( VertexPosOtherAxis82_g52260 * cos( Angle44_g52260 ) ) + ( cross( float3(1,0,0) , VertexPosOtherAxis82_g52260 ) * sin( Angle44_g52260 ) ) );
				float3 appendResult74_g52259 = (float3(0.0 , 0.0 , VertexPos40_g52259.z));
				half3 VertexPosRotationAxis50_g52259 = appendResult74_g52259;
				float3 break84_g52259 = VertexPos40_g52259;
				float3 appendResult81_g52259 = (float3(break84_g52259.x , break84_g52259.y , 0.0));
				half3 VertexPosOtherAxis82_g52259 = appendResult81_g52259;
				half Motion_X216_g51941 = break143_g51941.x;
				half Angle44_g52259 = -Motion_X216_g51941;
				float3 Vertex_Motion_Object833_g51941 = ( VertexPosRotationAxis50_g52259 + ( VertexPosOtherAxis82_g52259 * cos( Angle44_g52259 ) ) + ( cross( float3(0,0,1) , VertexPosOtherAxis82_g52259 ) * sin( Angle44_g52259 ) ) );
				float3 temp_output_3474_0_g51941 = ( PositionOS3588_g51941 - Mesh_PivotsOS2291_g51941 );
				float3 appendResult2047_g51941 = (float3(Motion_Rolling138_g51941 , 0.0 , -Motion_Rolling138_g51941));
				float3 appendResult2043_g51941 = (float3(Motion_X216_g51941 , 0.0 , Motion_Z190_g51941));
				float3 Vertex_Motion_World1118_g51941 = ( ( temp_output_3474_0_g51941 + appendResult2047_g51941 ) + appendResult2043_g51941 );
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch3312_g51941 = Vertex_Motion_World1118_g51941;
				#else
				float3 staticSwitch3312_g51941 = ( Vertex_Motion_Object833_g51941 + ( 0.0 * _VertexDataMode ) );
				#endif
				half Global_Vertex_Size174_g51941 = break322_g52256.w;
				float lerpResult346_g51941 = lerp( 1.0 , Global_Vertex_Size174_g51941 , _GlobalSize);
				float3 appendResult3480_g51941 = (float3(lerpResult346_g51941 , lerpResult346_g51941 , lerpResult346_g51941));
				half3 ObjectData20_g52294 = appendResult3480_g51941;
				half3 _Vector11 = half3(1,1,1);
				half3 WorldData19_g52294 = _Vector11;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52294 = WorldData19_g52294;
				#else
				float3 staticSwitch14_g52294 = ObjectData20_g52294;
				#endif
				half3 Vertex_Size1741_g51941 = staticSwitch14_g52294;
				half3 _Vector5 = half3(1,1,1);
				float3 Vertex_SizeFade1740_g51941 = _Vector5;
				half3 Grass_Coverage2661_g51941 = half3(0,0,0);
				float3 Final_VertexPosition890_g51941 = ( ( staticSwitch3312_g51941 * Vertex_Size1741_g51941 * Vertex_SizeFade1740_g51941 ) + Mesh_PivotsOS2291_g51941 + Grass_Coverage2661_g51941 );
				
				float temp_output_7_0_g52252 = TVE_CameraFadeStart;
				float saferPower3976_g51941 = max( saturate( ( ( distance( ase_worldPos , _WorldSpaceCameraPos ) - temp_output_7_0_g52252 ) / ( TVE_CameraFadeEnd - temp_output_7_0_g52252 ) ) ) , 0.0001 );
				float temp_output_3976_0_g51941 = pow( saferPower3976_g51941 , _FadeCameraValue );
				float vertexToFrag11_g52251 = temp_output_3976_0_g51941;
				o.ase_texcoord3.x = vertexToFrag11_g52251;
				float3 vertexToFrag3890_g51941 = ase_worldPos;
				o.ase_texcoord3.yzw = vertexToFrag3890_g51941;
				float2 vertexToFrag11_g52308 = ( ( v.ase_texcoord.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				o.ase_texcoord4.xy = vertexToFrag11_g52308;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = Final_VertexPosition890_g51941;
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
				float4 ase_texcoord3 : TEXCOORD3;
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
				o.ase_texcoord = v.ase_texcoord;
				o.ase_texcoord3 = v.ase_texcoord3;
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
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_texcoord3 = patch[0].ase_texcoord3 * bary.x + patch[1].ase_texcoord3 * bary.y + patch[2].ase_texcoord3 * bary.z;
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

				float localCustomAlphaClip3735_g51941 = ( 0.0 );
				float vertexToFrag11_g52251 = IN.ase_texcoord3.x;
				half Fade_Camera3743_g51941 = vertexToFrag11_g52251;
				half Final_AlphaFade3727_g51941 = ( 1.0 * Fade_Camera3743_g51941 );
				float temp_output_41_0_g52255 = Final_AlphaFade3727_g51941;
				float3 vertexToFrag3890_g51941 = IN.ase_texcoord3.yzw;
				float3 PositionWS_PerVertex3905_g51941 = vertexToFrag3890_g51941;
				float2 vertexToFrag11_g52308 = IN.ase_texcoord4.xy;
				half2 Main_UVs15_g51941 = vertexToFrag11_g52308;
				float4 tex2DNode29_g51941 = SAMPLE_TEXTURE2D( _MainAlbedoTex, sampler_MainAlbedoTex, Main_UVs15_g51941 );
				float Main_Alpha316_g51941 = ( _MainColor.a * tex2DNode29_g51941.a );
				half AlphaTreshold2132_g51941 = _Cutoff;
				#ifdef TVE_ALPHA_CLIP
				float staticSwitch3792_g51941 = ( Main_Alpha316_g51941 - ( AlphaTreshold2132_g51941 - 0.5 ) );
				#else
				float staticSwitch3792_g51941 = Main_Alpha316_g51941;
				#endif
				half Final_Alpha3754_g51941 = staticSwitch3792_g51941;
				float temp_output_661_0_g51941 = ( saturate( ( temp_output_41_0_g52255 + ( temp_output_41_0_g52255 * SAMPLE_TEXTURE3D( TVE_ScreenTex3D, samplerTVE_ScreenTex3D, ( TVE_ScreenTexCoord * PositionWS_PerVertex3905_g51941 ) ).r ) ) ) * Final_Alpha3754_g51941 );
				float Alpha3735_g51941 = temp_output_661_0_g51941;
				float Treshold3735_g51941 = 0.5;
				{
				#if TVE_ALPHA_CLIP
				clip(Alpha3735_g51941 - Treshold3735_g51941);
				#endif
				}
				half Final_Clip914_g51941 = saturate( Alpha3735_g51941 );
				
				float Alpha = Final_Clip914_g51941;
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
			#define _SPECULAR_SETUP 1
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define ASE_ABSOLUTE_VERTEX_POS 1
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

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#pragma shader_feature_local TVE_ALPHA_CLIP
			#pragma shader_feature_local TVE_VERTEX_DATA_BATCHED
			#pragma shader_feature_local TVE_DETAIL_MODE_OFF TVE_DETAIL_MODE_ON
			#pragma shader_feature_local TVE_DETAIL_BLEND_OVERLAY TVE_DETAIL_BLEND_REPLACE
			//TVE Pipeline Defines
			#define THE_VEGETATION_ENGINE
			#define IS_UNIVERSAL_PIPELINE
			//TVE Shader Type Defines
			#define TVE_IS_VEGETATION_SHADER
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
				float4 ase_texcoord3 : TEXCOORD3;
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
				float4 ase_color : COLOR;
				float4 ase_texcoord9 : TEXCOORD9;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			half4 _SecondUVs;
			half4 _VertexOcclusionColor;
			float4 _SubsurfaceDiffusion_Asset;
			half4 _SecondColor;
			half4 _EmissiveColor;
			float4 _NoiseMaskRemap;
			half4 _ColorsMaskRemap;
			half4 _SubsurfaceMaskRemap;
			half4 _OverlayMaskRemap;
			float4 _GradientMaskRemap;
			half4 _VertexOcclusionRemap;
			half4 _DetailBlendRemap;
			float4 _Color;
			half4 _MainColor;
			half4 _MainUVs;
			float4 _MaxBoundsInfo;
			half4 _EmissiveUVs;
			float4 _SubsurfaceDiffusion_asset;
			half3 _render_normals_options;
			half _VertexDataMode;
			half _InteractionAmplitude;
			half _GlobalSize;
			half _InteractionVariation;
			half _LayerReactValue;
			half _MotionVariation_20;
			half _MotionVariation_10;
			float _MotionSpeed_10;
			half _MotionAmplitude_10;
			half _MotionScale_20;
			half _MotionSpeed_20;
			half _VertexRollingMode;
			half _LayerMotionValue;
			half _vertex_pivot_mode;
			half _MotionAmplitude_20;
			float _MotionScale_10;
			half _render_dst;
			half _OverlayBottomValue;
			half _DetailMaskMode;
			half _MainOcclusionValue;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half _RenderSpecular;
			half _GlobalEmissive;
			half _DetailNormalValue;
			half _SecondNormalValue;
			half _VertexOcclusionMaxValue;
			half _VertexOcclusionMinValue;
			half _OverlayMaskMaxValue;
			half _OverlayMaskMinValue;
			half _LayerExtrasValue;
			half _GlobalOverlay;
			half _MainNormalValue;
			half _EmissiveFlagMode;
			half _DetailBlendMaxValue;
			half _DetailBlendMinValue;
			half _DetailMaskInvertMode;
			half _DetailMeshValue;
			half _RenderMode;
			float _SubsurfaceDiffusion;
			half _RenderDecals;
			half _RenderPriority;
			half _TranslucencyIntensityValue;
			half _EmissiveCat;
			half _ReceiveSpace;
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
			half _IsBarkShader;
			half _IsStandardShader;
			half _render_src;
			half _render_cull;
			half _render_zw;
			half _NoiseCat;
			half _SizeFadeCat;
			half _TranslucencyAmbientValue;
			half _VertexMasksMode;
			half _RenderZWrite;
			half _TranslucencyShadowValue;
			half _RenderSSR;
			half _SecondOcclusionValue;
			half _MotionSpace;
			half _RenderCull;
			half _PerspectiveCat;
			half _VertexVariationMode;
			half _GradientCat;
			half _TranslucencyDirectValue;
			half _FadeSpace;
			half _GlobalCat;
			half _IsTVEShader;
			half _DetailSpace;
			half _DetailTypeMode;
			half _DetailCat;
			half _TranslucencyScatteringValue;
			half _TranslucencyNormalValue;
			half _RenderClip;
			half _IsVersion;
			half _RenderingCat;
			half _VariationMotionMessage;
			half _FadeCameraValue;
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
			half4 TVE_MotionParams;
			TEXTURE2D_ARRAY(TVE_MotionTex);
			half4 TVE_MotionCoord;
			SAMPLER(samplerTVE_MotionTex);
			float TVE_MotionUsage[9];
			TEXTURE2D(TVE_NoiseTex);
			float2 TVE_NoiseSpeed_Vegetation;
			float2 TVE_NoiseSpeed_Grass;
			half TVE_NoiseSize_Vegetation;
			half TVE_NoiseSize_Grass;
			SAMPLER(samplerTVE_NoiseTex);
			half4 TVE_ReactParams;
			TEXTURE2D_ARRAY(TVE_ReactTex);
			half4 TVE_ReactCoord;
			SAMPLER(samplerTVE_ReactTex);
			float TVE_ReactUsage[9];
			TEXTURE2D(_MainAlbedoTex);
			SAMPLER(sampler_MainAlbedoTex);
			TEXTURE2D(_SecondAlbedoTex);
			TEXTURE2D(_SecondMaskTex);
			SAMPLER(sampler_SecondMaskTex);
			TEXTURE2D(_MainMaskTex);
			half4 TVE_OverlayColor;
			TEXTURE2D(_MainNormalTex);
			half4 TVE_ExtrasParams;
			TEXTURE2D_ARRAY(TVE_ExtrasTex);
			half4 TVE_ExtrasCoord;
			SAMPLER(samplerTVE_ExtrasTex);
			float TVE_ExtrasUsage[9];
			TEXTURE2D(_EmissiveTex);
			SAMPLER(sampler_EmissiveTex);
			half TVE_OverlaySmoothness;
			half TVE_CameraFadeStart;
			half TVE_CameraFadeEnd;
			TEXTURE3D(TVE_ScreenTex3D);
			half TVE_ScreenTexCoord;
			SAMPLER(samplerTVE_ScreenTex3D);


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 PositionOS3588_g51941 = v.vertex.xyz;
				half3 _Vector1 = half3(0,0,0);
				half3 Mesh_PivotsOS2291_g51941 = _Vector1;
				float3 temp_output_2283_0_g51941 = ( PositionOS3588_g51941 - Mesh_PivotsOS2291_g51941 );
				half3 VertexPos40_g52293 = temp_output_2283_0_g51941;
				float3 appendResult74_g52293 = (float3(0.0 , VertexPos40_g52293.y , 0.0));
				float3 VertexPosRotationAxis50_g52293 = appendResult74_g52293;
				float3 break84_g52293 = VertexPos40_g52293;
				float3 appendResult81_g52293 = (float3(break84_g52293.x , 0.0 , break84_g52293.z));
				float3 VertexPosOtherAxis82_g52293 = appendResult81_g52293;
				float ObjectData20_g52239 = 3.14;
				float Bounds_Radius121_g51941 = _MaxBoundsInfo.x;
				float WorldData19_g52239 = Bounds_Radius121_g51941;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52239 = WorldData19_g52239;
				#else
				float staticSwitch14_g52239 = ObjectData20_g52239;
				#endif
				float Motion_Max_Rolling1137_g51941 = staticSwitch14_g52239;
				float4x4 break19_g52279 = GetObjectToWorldMatrix();
				float3 appendResult20_g52279 = (float3(break19_g52279[ 0 ][ 3 ] , break19_g52279[ 1 ][ 3 ] , break19_g52279[ 2 ][ 3 ]));
				half3 Off19_g52282 = appendResult20_g52279;
				float3 appendResult93_g52279 = (float3(v.texcoord.z , v.ase_texcoord3.w , v.texcoord.w));
				float3 temp_output_91_0_g52279 = ( appendResult93_g52279 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52279 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52279 , 0.0 ) ).xyz).xyz;
				half3 On20_g52282 = ( appendResult20_g52279 + PivotsOnly105_g52279 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52282 = On20_g52282;
				#else
				float3 staticSwitch14_g52282 = Off19_g52282;
				#endif
				half3 ObjectData20_g52283 = staticSwitch14_g52282;
				half3 WorldData19_g52283 = Off19_g52282;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52283 = WorldData19_g52283;
				#else
				float3 staticSwitch14_g52283 = ObjectData20_g52283;
				#endif
				float3 temp_output_42_0_g52279 = staticSwitch14_g52283;
				half3 ObjectData20_g52278 = temp_output_42_0_g52279;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				half3 WorldData19_g52278 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52278 = WorldData19_g52278;
				#else
				float3 staticSwitch14_g52278 = ObjectData20_g52278;
				#endif
				float3 Position83_g52277 = staticSwitch14_g52278;
				float temp_output_84_0_g52277 = _LayerMotionValue;
				float4 lerpResult87_g52277 = lerp( TVE_MotionParams , SAMPLE_TEXTURE2D_ARRAY_LOD( TVE_MotionTex, samplerTVE_MotionTex, ( (TVE_MotionCoord).zw + ( (TVE_MotionCoord).xy * (Position83_g52277).xz ) ),temp_output_84_0_g52277, 0.0 ) , TVE_MotionUsage[(int)temp_output_84_0_g52277]);
				half4 Global_Motion_Params3909_g51941 = lerpResult87_g52277;
				float4 break322_g52303 = Global_Motion_Params3909_g51941;
				half Wind_Power369_g52303 = break322_g52303.z;
				float lerpResult410_g52303 = lerp( 0.2 , 1.0 , Wind_Power369_g52303);
				half Wind_Power_203109_g51941 = lerpResult410_g52303;
				half Mesh_Motion_260_g51941 = v.ase_texcoord3.y;
				#ifdef TVE_IS_GRASS_SHADER
				float2 staticSwitch160_g52296 = TVE_NoiseSpeed_Grass;
				#else
				float2 staticSwitch160_g52296 = TVE_NoiseSpeed_Vegetation;
				#endif
				float4x4 break19_g52298 = GetObjectToWorldMatrix();
				float3 appendResult20_g52298 = (float3(break19_g52298[ 0 ][ 3 ] , break19_g52298[ 1 ][ 3 ] , break19_g52298[ 2 ][ 3 ]));
				half3 Off19_g52301 = appendResult20_g52298;
				float3 appendResult93_g52298 = (float3(v.texcoord.z , v.ase_texcoord3.w , v.texcoord.w));
				float3 temp_output_91_0_g52298 = ( appendResult93_g52298 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52298 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52298 , 0.0 ) ).xyz).xyz;
				half3 On20_g52301 = ( appendResult20_g52298 + PivotsOnly105_g52298 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52301 = On20_g52301;
				#else
				float3 staticSwitch14_g52301 = Off19_g52301;
				#endif
				half3 ObjectData20_g52302 = staticSwitch14_g52301;
				half3 WorldData19_g52302 = Off19_g52301;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52302 = WorldData19_g52302;
				#else
				float3 staticSwitch14_g52302 = ObjectData20_g52302;
				#endif
				float3 temp_output_42_0_g52298 = staticSwitch14_g52302;
				half3 ObjectData20_g52297 = temp_output_42_0_g52298;
				half3 WorldData19_g52297 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52297 = WorldData19_g52297;
				#else
				float3 staticSwitch14_g52297 = ObjectData20_g52297;
				#endif
				#ifdef TVE_IS_GRASS_SHADER
				float2 staticSwitch164_g52296 = (ase_worldPos).xz;
				#else
				float2 staticSwitch164_g52296 = (staticSwitch14_g52297).xz;
				#endif
				#ifdef TVE_IS_GRASS_SHADER
				float staticSwitch161_g52296 = TVE_NoiseSize_Grass;
				#else
				float staticSwitch161_g52296 = TVE_NoiseSize_Vegetation;
				#endif
				float2 panner73_g52296 = ( _TimeParameters.x * staticSwitch160_g52296 + ( staticSwitch164_g52296 * staticSwitch161_g52296 ));
				float4 tex2DNode75_g52296 = SAMPLE_TEXTURE2D_LOD( TVE_NoiseTex, samplerTVE_NoiseTex, panner73_g52296, 0.0 );
				float4 saferPower77_g52296 = max( abs( tex2DNode75_g52296 ) , 0.0001 );
				half Wind_Power2223_g51941 = Wind_Power369_g52303;
				float temp_output_167_0_g52296 = Wind_Power2223_g51941;
				float lerpResult168_g52296 = lerp( 1.5 , 0.25 , temp_output_167_0_g52296);
				float4 temp_cast_7 = (lerpResult168_g52296).xxxx;
				float4 break142_g52296 = pow( saferPower77_g52296 , temp_cast_7 );
				half Global_NoiseTex_R34_g51941 = break142_g52296.r;
				half Input_Speed62_g52276 = _MotionSpeed_20;
				float mulTime354_g52276 = _TimeParameters.x * Input_Speed62_g52276;
				float4x4 break19_g52214 = GetObjectToWorldMatrix();
				float3 appendResult20_g52214 = (float3(break19_g52214[ 0 ][ 3 ] , break19_g52214[ 1 ][ 3 ] , break19_g52214[ 2 ][ 3 ]));
				half3 Off19_g52217 = appendResult20_g52214;
				float3 appendResult93_g52214 = (float3(v.texcoord.z , v.ase_texcoord3.w , v.texcoord.w));
				float3 temp_output_91_0_g52214 = ( appendResult93_g52214 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52214 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52214 , 0.0 ) ).xyz).xyz;
				half3 On20_g52217 = ( appendResult20_g52214 + PivotsOnly105_g52214 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52217 = On20_g52217;
				#else
				float3 staticSwitch14_g52217 = Off19_g52217;
				#endif
				half3 ObjectData20_g52218 = staticSwitch14_g52217;
				half3 WorldData19_g52218 = Off19_g52217;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52218 = WorldData19_g52218;
				#else
				float3 staticSwitch14_g52218 = ObjectData20_g52218;
				#endif
				float3 temp_output_42_0_g52214 = staticSwitch14_g52218;
				float3 break9_g52214 = temp_output_42_0_g52214;
				half Variation_Complex102_g52212 = frac( ( v.ase_color.r + ( break9_g52214.x + break9_g52214.z ) ) );
				float ObjectData20_g52213 = Variation_Complex102_g52212;
				half Variation_Simple105_g52212 = v.ase_color.r;
				float WorldData19_g52213 = Variation_Simple105_g52212;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52213 = WorldData19_g52213;
				#else
				float staticSwitch14_g52213 = ObjectData20_g52213;
				#endif
				half Motion_Variation3073_g51941 = staticSwitch14_g52213;
				float temp_output_3154_0_g51941 = ( _MotionVariation_20 * Motion_Variation3073_g51941 );
				float Motion_Variation284_g52276 = temp_output_3154_0_g51941;
				float Motion_Scale287_g52276 = ( _MotionScale_20 * ase_worldPos.x );
				half Variation127_g52292 = temp_output_3154_0_g51941;
				float lerpResult110_g52292 = lerp( ceil( saturate( ( frac( ( Variation127_g52292 + 0.3576 ) ) - 0.6 ) ) ) , ceil( saturate( ( frac( ( Variation127_g52292 + 0.1715 ) ) - 0.4 ) ) ) , (sin( _TimeParameters.x )*0.5 + 0.5));
				float temp_output_112_0_g52292 = Wind_Power2223_g51941;
				float lerpResult111_g52292 = lerp( lerpResult110_g52292 , 1.0 , ( temp_output_112_0_g52292 * temp_output_112_0_g52292 * temp_output_112_0_g52292 * temp_output_112_0_g52292 ));
				float lerpResult126_g52292 = lerp( lerpResult111_g52292 , 1.0 , ( 1.0 - saturate( Variation127_g52292 ) ));
				half Motion_Rolling138_g51941 = ( ( _MotionAmplitude_20 * Motion_Max_Rolling1137_g51941 ) * ( Wind_Power_203109_g51941 * Mesh_Motion_260_g51941 * Global_NoiseTex_R34_g51941 * _VertexRollingMode ) * sin( ( mulTime354_g52276 + Motion_Variation284_g52276 + Motion_Scale287_g52276 ) ) * lerpResult126_g52292 );
				half Angle44_g52293 = Motion_Rolling138_g51941;
				half3 VertexPos40_g52260 = ( VertexPosRotationAxis50_g52293 + ( VertexPosOtherAxis82_g52293 * cos( Angle44_g52293 ) ) + ( cross( float3(0,1,0) , VertexPosOtherAxis82_g52293 ) * sin( Angle44_g52293 ) ) );
				float3 appendResult74_g52260 = (float3(VertexPos40_g52260.x , 0.0 , 0.0));
				half3 VertexPosRotationAxis50_g52260 = appendResult74_g52260;
				float3 break84_g52260 = VertexPos40_g52260;
				float3 appendResult81_g52260 = (float3(0.0 , break84_g52260.y , break84_g52260.z));
				half3 VertexPosOtherAxis82_g52260 = appendResult81_g52260;
				float ObjectData20_g52309 = 3.14;
				float Bounds_Height374_g51941 = _MaxBoundsInfo.y;
				float WorldData19_g52309 = ( Bounds_Height374_g51941 * 3.14 );
				#ifdef TVE_VERTEX_DATA_BATCHED
				float staticSwitch14_g52309 = WorldData19_g52309;
				#else
				float staticSwitch14_g52309 = ObjectData20_g52309;
				#endif
				float Motion_Max_Bending1133_g51941 = staticSwitch14_g52309;
				float lerpResult376_g52303 = lerp( 0.1 , 1.0 , Wind_Power369_g52303);
				half Wind_Power_103106_g51941 = lerpResult376_g52303;
				float3 appendResult397_g52303 = (float3(break322_g52303.x , 0.0 , break322_g52303.y));
				float3 temp_output_398_0_g52303 = (appendResult397_g52303*2.0 + -1.0);
				float3 ase_parentObjectScale = ( 1.0 / float3( length( GetWorldToObjectMatrix()[ 0 ].xyz ), length( GetWorldToObjectMatrix()[ 1 ].xyz ), length( GetWorldToObjectMatrix()[ 2 ].xyz ) ) );
				float3 temp_output_339_0_g52303 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_398_0_g52303 , 0.0 ) ).xyz * ase_parentObjectScale );
				half2 Wind_DirectionOS39_g51941 = (temp_output_339_0_g52303).xz;
				half Input_Speed62_g52219 = _MotionSpeed_10;
				float mulTime373_g52219 = _TimeParameters.x * Input_Speed62_g52219;
				half Motion_Variation284_g52219 = ( _MotionVariation_10 * Motion_Variation3073_g51941 );
				float2 appendResult344_g52219 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 Motion_Scale287_g52219 = ( _MotionScale_10 * appendResult344_g52219 );
				half2 Sine_MinusOneToOne281_g52219 = sin( ( mulTime373_g52219 + Motion_Variation284_g52219 + Motion_Scale287_g52219 ) );
				float2 temp_cast_12 = (1.0).xx;
				half Input_Turbulence327_g52219 = Global_NoiseTex_R34_g51941;
				float2 lerpResult321_g52219 = lerp( Sine_MinusOneToOne281_g52219 , temp_cast_12 , Input_Turbulence327_g52219);
				half2 Motion_Bending2258_g51941 = ( ( _MotionAmplitude_10 * Motion_Max_Bending1133_g51941 ) * Wind_Power_103106_g51941 * Wind_DirectionOS39_g51941 * Global_NoiseTex_R34_g51941 * lerpResult321_g52219 );
				half Interaction_Amplitude4137_g51941 = _InteractionAmplitude;
				float4x4 break19_g52271 = GetObjectToWorldMatrix();
				float3 appendResult20_g52271 = (float3(break19_g52271[ 0 ][ 3 ] , break19_g52271[ 1 ][ 3 ] , break19_g52271[ 2 ][ 3 ]));
				half3 Off19_g52274 = appendResult20_g52271;
				float3 appendResult93_g52271 = (float3(v.texcoord.z , v.ase_texcoord3.w , v.texcoord.w));
				float3 temp_output_91_0_g52271 = ( appendResult93_g52271 * _vertex_pivot_mode );
				float3 PivotsOnly105_g52271 = (mul( GetObjectToWorldMatrix(), float4( temp_output_91_0_g52271 , 0.0 ) ).xyz).xyz;
				half3 On20_g52274 = ( appendResult20_g52271 + PivotsOnly105_g52271 );
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g52274 = On20_g52274;
				#else
				float3 staticSwitch14_g52274 = Off19_g52274;
				#endif
				half3 ObjectData20_g52275 = staticSwitch14_g52274;
				half3 WorldData19_g52275 = Off19_g52274;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52275 = WorldData19_g52275;
				#else
				float3 staticSwitch14_g52275 = ObjectData20_g52275;
				#endif
				float3 temp_output_42_0_g52271 = staticSwitch14_g52275;
				half3 ObjectData20_g52270 = temp_output_42_0_g52271;
				half3 WorldData19_g52270 = ase_worldPos;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52270 = WorldData19_g52270;
				#else
				float3 staticSwitch14_g52270 = ObjectData20_g52270;
				#endif
				float3 Position83_g52269 = staticSwitch14_g52270;
				float temp_output_84_0_g52269 = _LayerReactValue;
				float4 lerpResult87_g52269 = lerp( TVE_ReactParams , SAMPLE_TEXTURE2D_ARRAY_LOD( TVE_ReactTex, samplerTVE_ReactTex, ( (TVE_ReactCoord).zw + ( (TVE_ReactCoord).xy * (Position83_g52269).xz ) ),temp_output_84_0_g52269, 0.0 ) , TVE_ReactUsage[(int)temp_output_84_0_g52269]);
				half4 Global_React_Params4173_g51941 = lerpResult87_g52269;
				float4 break322_g52256 = Global_React_Params4173_g51941;
				half Interaction_Mask66_g51941 = break322_g52256.z;
				float3 appendResult397_g52256 = (float3(break322_g52256.x , 0.0 , break322_g52256.y));
				float3 temp_output_398_0_g52256 = (appendResult397_g52256*2.0 + -1.0);
				float3 temp_output_339_0_g52256 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_398_0_g52256 , 0.0 ) ).xyz * ase_parentObjectScale );
				half2 Interaction_DirectionOS4158_g51941 = (temp_output_339_0_g52256).xz;
				float lerpResult3307_g51941 = lerp( 1.0 , Motion_Variation3073_g51941 , _InteractionVariation);
				half2 Motion_Interaction53_g51941 = ( Interaction_Amplitude4137_g51941 * Motion_Max_Bending1133_g51941 * Interaction_Mask66_g51941 * Interaction_Mask66_g51941 * Interaction_DirectionOS4158_g51941 * lerpResult3307_g51941 );
				float2 lerpResult109_g51941 = lerp( Motion_Bending2258_g51941 , Motion_Interaction53_g51941 , ( Interaction_Mask66_g51941 * saturate( Interaction_Amplitude4137_g51941 ) ));
				half Mesh_Motion_182_g51941 = v.ase_texcoord3.x;
				float2 break143_g51941 = ( lerpResult109_g51941 * Mesh_Motion_182_g51941 );
				half Motion_Z190_g51941 = break143_g51941.y;
				half Angle44_g52260 = Motion_Z190_g51941;
				half3 VertexPos40_g52259 = ( VertexPosRotationAxis50_g52260 + ( VertexPosOtherAxis82_g52260 * cos( Angle44_g52260 ) ) + ( cross( float3(1,0,0) , VertexPosOtherAxis82_g52260 ) * sin( Angle44_g52260 ) ) );
				float3 appendResult74_g52259 = (float3(0.0 , 0.0 , VertexPos40_g52259.z));
				half3 VertexPosRotationAxis50_g52259 = appendResult74_g52259;
				float3 break84_g52259 = VertexPos40_g52259;
				float3 appendResult81_g52259 = (float3(break84_g52259.x , break84_g52259.y , 0.0));
				half3 VertexPosOtherAxis82_g52259 = appendResult81_g52259;
				half Motion_X216_g51941 = break143_g51941.x;
				half Angle44_g52259 = -Motion_X216_g51941;
				float3 Vertex_Motion_Object833_g51941 = ( VertexPosRotationAxis50_g52259 + ( VertexPosOtherAxis82_g52259 * cos( Angle44_g52259 ) ) + ( cross( float3(0,0,1) , VertexPosOtherAxis82_g52259 ) * sin( Angle44_g52259 ) ) );
				float3 temp_output_3474_0_g51941 = ( PositionOS3588_g51941 - Mesh_PivotsOS2291_g51941 );
				float3 appendResult2047_g51941 = (float3(Motion_Rolling138_g51941 , 0.0 , -Motion_Rolling138_g51941));
				float3 appendResult2043_g51941 = (float3(Motion_X216_g51941 , 0.0 , Motion_Z190_g51941));
				float3 Vertex_Motion_World1118_g51941 = ( ( temp_output_3474_0_g51941 + appendResult2047_g51941 ) + appendResult2043_g51941 );
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch3312_g51941 = Vertex_Motion_World1118_g51941;
				#else
				float3 staticSwitch3312_g51941 = ( Vertex_Motion_Object833_g51941 + ( 0.0 * _VertexDataMode ) );
				#endif
				half Global_Vertex_Size174_g51941 = break322_g52256.w;
				float lerpResult346_g51941 = lerp( 1.0 , Global_Vertex_Size174_g51941 , _GlobalSize);
				float3 appendResult3480_g51941 = (float3(lerpResult346_g51941 , lerpResult346_g51941 , lerpResult346_g51941));
				half3 ObjectData20_g52294 = appendResult3480_g51941;
				half3 _Vector11 = half3(1,1,1);
				half3 WorldData19_g52294 = _Vector11;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g52294 = WorldData19_g52294;
				#else
				float3 staticSwitch14_g52294 = ObjectData20_g52294;
				#endif
				half3 Vertex_Size1741_g51941 = staticSwitch14_g52294;
				half3 _Vector5 = half3(1,1,1);
				float3 Vertex_SizeFade1740_g51941 = _Vector5;
				half3 Grass_Coverage2661_g51941 = half3(0,0,0);
				float3 Final_VertexPosition890_g51941 = ( ( staticSwitch3312_g51941 * Vertex_Size1741_g51941 * Vertex_SizeFade1740_g51941 ) + Mesh_PivotsOS2291_g51941 + Grass_Coverage2661_g51941 );
				
				float2 vertexToFrag11_g52308 = ( ( v.texcoord.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				o.ase_texcoord7.xy = vertexToFrag11_g52308;
				float2 appendResult21_g52242 = (float2(v.texcoord.z , v.texcoord.w));
				float2 Mesh_DetailCoord3_g51941 = appendResult21_g52242;
				float2 vertexToFrag11_g52243 = ( ( Mesh_DetailCoord3_g51941 * (_SecondUVs).xy ) + (_SecondUVs).zw );
				o.ase_texcoord7.zw = vertexToFrag11_g52243;
				half Mesh_DetailMask90_g51941 = v.ase_color.b;
				float vertexToFrag11_g52208 = ( ( Mesh_DetailMask90_g51941 - 0.5 ) + _DetailMeshValue );
				o.ase_texcoord8.x = vertexToFrag11_g52208;
				float3 vertexToFrag3890_g51941 = ase_worldPos;
				o.ase_texcoord8.yzw = vertexToFrag3890_g51941;
				
				float2 vertexToFrag11_g52248 = ( ( v.texcoord.xy * (_EmissiveUVs).xy ) + (_EmissiveUVs).zw );
				o.ase_texcoord9.xy = vertexToFrag11_g52248;
				
				float temp_output_7_0_g52252 = TVE_CameraFadeStart;
				float saferPower3976_g51941 = max( saturate( ( ( distance( ase_worldPos , _WorldSpaceCameraPos ) - temp_output_7_0_g52252 ) / ( TVE_CameraFadeEnd - temp_output_7_0_g52252 ) ) ) , 0.0001 );
				float temp_output_3976_0_g51941 = pow( saferPower3976_g51941 , _FadeCameraValue );
				float vertexToFrag11_g52251 = temp_output_3976_0_g51941;
				o.ase_texcoord9.z = vertexToFrag11_g52251;
				
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord9.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = Final_VertexPosition890_g51941;
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
				float4 ase_texcoord3 : TEXCOORD3;
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
				o.texcoord = v.texcoord;
				o.ase_texcoord3 = v.ase_texcoord3;
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
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.ase_texcoord3 = patch[0].ase_texcoord3 * bary.x + patch[1].ase_texcoord3 * bary.y + patch[2].ase_texcoord3 * bary.z;
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
				half2 Main_UVs15_g51941 = vertexToFrag11_g52308;
				float4 tex2DNode29_g51941 = SAMPLE_TEXTURE2D( _MainAlbedoTex, sampler_MainAlbedoTex, Main_UVs15_g51941 );
				float3 temp_output_51_0_g51941 = ( (_MainColor).rgb * (tex2DNode29_g51941).rgb );
				half3 Main_Albedo99_g51941 = temp_output_51_0_g51941;
				float2 vertexToFrag11_g52243 = IN.ase_texcoord7.zw;
				half2 Second_UVs17_g51941 = vertexToFrag11_g52243;
				half3 Second_Albedo153_g51941 = (( _SecondColor * SAMPLE_TEXTURE2D( _SecondAlbedoTex, sampler_SecondMaskTex, Second_UVs17_g51941 ) )).rgb;
				#ifdef UNITY_COLORSPACE_GAMMA
				float staticSwitch1_g52209 = 2.0;
				#else
				float staticSwitch1_g52209 = 4.594794;
				#endif
				float vertexToFrag11_g52208 = IN.ase_texcoord8.x;
				float temp_output_3919_0_g51941 = vertexToFrag11_g52208;
				half Blend_Source1540_g51941 = temp_output_3919_0_g51941;
				float4 tex2DNode35_g51941 = SAMPLE_TEXTURE2D( _MainMaskTex, sampler_MainAlbedoTex, Main_UVs15_g51941 );
				half Main_Mask57_g51941 = tex2DNode35_g51941.b;
				float4 tex2DNode33_g51941 = SAMPLE_TEXTURE2D( _SecondMaskTex, sampler_SecondMaskTex, Second_UVs17_g51941 );
				half Second_Mask81_g51941 = tex2DNode33_g51941.b;
				float lerpResult1327_g51941 = lerp( Main_Mask57_g51941 , Second_Mask81_g51941 , _DetailMaskMode);
				float lerpResult4058_g51941 = lerp( lerpResult1327_g51941 , ( 1.0 - lerpResult1327_g51941 ) , _DetailMaskInvertMode);
				float temp_output_7_0_g52238 = _DetailBlendMinValue;
				half Mask_Detail147_g51941 = saturate( ( ( saturate( ( Blend_Source1540_g51941 + ( Blend_Source1540_g51941 * lerpResult4058_g51941 ) ) ) - temp_output_7_0_g52238 ) / ( _DetailBlendMaxValue - temp_output_7_0_g52238 ) ) );
				float3 lerpResult235_g51941 = lerp( Main_Albedo99_g51941 , ( Main_Albedo99_g51941 * Second_Albedo153_g51941 * staticSwitch1_g52209 ) , Mask_Detail147_g51941);
				float3 lerpResult208_g51941 = lerp( Main_Albedo99_g51941 , Second_Albedo153_g51941 , Mask_Detail147_g51941);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float3 staticSwitch4062_g51941 = lerpResult235_g51941;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float3 staticSwitch4062_g51941 = lerpResult208_g51941;
				#else
				float3 staticSwitch4062_g51941 = lerpResult235_g51941;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float3 staticSwitch255_g51941 = Main_Albedo99_g51941;
				#elif defined(TVE_DETAIL_MODE_ON)
				float3 staticSwitch255_g51941 = staticSwitch4062_g51941;
				#else
				float3 staticSwitch255_g51941 = Main_Albedo99_g51941;
				#endif
				half3 Blend_Albedo265_g51941 = staticSwitch255_g51941;
				half3 Blend_AlbedoTinted2808_g51941 = ( float3(1,1,1) * float3(1,1,1) * float3(1,1,1) * Blend_Albedo265_g51941 );
				half3 Blend_AlbedoColored863_g51941 = Blend_AlbedoTinted2808_g51941;
				half3 Blend_AlbedoAndSubsurface149_g51941 = Blend_AlbedoColored863_g51941;
				half3 Global_OverlayColor1758_g51941 = (TVE_OverlayColor).rgb;
				float3 unpack4112_g51941 = UnpackNormalScale( SAMPLE_TEXTURE2D( _MainNormalTex, sampler_MainAlbedoTex, Main_UVs15_g51941 ), _MainNormalValue );
				unpack4112_g51941.z = lerp( 1, unpack4112_g51941.z, saturate(_MainNormalValue) );
				half3 Main_Normal137_g51941 = unpack4112_g51941;
				float3 tanToWorld0 = float3( WorldTangent.x, WorldBiTangent.x, WorldNormal.x );
				float3 tanToWorld1 = float3( WorldTangent.y, WorldBiTangent.y, WorldNormal.y );
				float3 tanToWorld2 = float3( WorldTangent.z, WorldBiTangent.z, WorldNormal.z );
				float3 tanNormal4099_g51941 = Main_Normal137_g51941;
				float3 worldNormal4099_g51941 = float3(dot(tanToWorld0,tanNormal4099_g51941), dot(tanToWorld1,tanNormal4099_g51941), dot(tanToWorld2,tanNormal4099_g51941));
				float3 Main_Normal_WS4101_g51941 = worldNormal4099_g51941;
				float lerpResult3567_g51941 = lerp( _OverlayBottomValue , 1.0 , Main_Normal_WS4101_g51941.y);
				half Main_AlbedoTex_G3526_g51941 = tex2DNode29_g51941.g;
				half Second_AlbedoTex_G3581_g51941 = (SAMPLE_TEXTURE2D( _SecondAlbedoTex, sampler_SecondMaskTex, Second_UVs17_g51941 )).g;
				float lerpResult3579_g51941 = lerp( Main_AlbedoTex_G3526_g51941 , Second_AlbedoTex_G3581_g51941 , Mask_Detail147_g51941);
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch3574_g51941 = Main_AlbedoTex_G3526_g51941;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch3574_g51941 = lerpResult3579_g51941;
				#else
				float staticSwitch3574_g51941 = Main_AlbedoTex_G3526_g51941;
				#endif
				float3 vertexToFrag3890_g51941 = IN.ase_texcoord8.yzw;
				float3 PositionWS_PerVertex3905_g51941 = vertexToFrag3890_g51941;
				float3 Position82_g52261 = PositionWS_PerVertex3905_g51941;
				float temp_output_84_0_g52261 = _LayerExtrasValue;
				float4 lerpResult88_g52261 = lerp( TVE_ExtrasParams , SAMPLE_TEXTURE2D_ARRAY( TVE_ExtrasTex, samplerTVE_ExtrasTex, ( (TVE_ExtrasCoord).zw + ( (TVE_ExtrasCoord).xy * (Position82_g52261).xz ) ),temp_output_84_0_g52261 ) , TVE_ExtrasUsage[(int)temp_output_84_0_g52261]);
				float4 break89_g52261 = lerpResult88_g52261;
				half Global_Extras_Overlay156_g51941 = break89_g52261.b;
				float temp_output_1025_0_g51941 = ( _GlobalOverlay * Global_Extras_Overlay156_g51941 );
				half Overlay_Commons1365_g51941 = temp_output_1025_0_g51941;
				float temp_output_7_0_g52234 = _OverlayMaskMinValue;
				half Overlay_Mask269_g51941 = saturate( ( ( ( ( ( lerpResult3567_g51941 * 0.5 ) + staticSwitch3574_g51941 ) * Overlay_Commons1365_g51941 ) - temp_output_7_0_g52234 ) / ( _OverlayMaskMaxValue - temp_output_7_0_g52234 ) ) );
				float3 lerpResult336_g51941 = lerp( Blend_AlbedoAndSubsurface149_g51941 , Global_OverlayColor1758_g51941 , Overlay_Mask269_g51941);
				half3 Final_Albedo359_g51941 = lerpResult336_g51941;
				float3 temp_cast_3 = (1.0).xxx;
				float Mesh_Occlusion318_g51941 = IN.ase_color.g;
				float temp_output_7_0_g52232 = _VertexOcclusionMinValue;
				float3 lerpResult2945_g51941 = lerp( (_VertexOcclusionColor).rgb , temp_cast_3 , saturate( ( ( Mesh_Occlusion318_g51941 - temp_output_7_0_g52232 ) / ( _VertexOcclusionMaxValue - temp_output_7_0_g52232 ) ) ));
				float3 Vertex_Occlusion648_g51941 = lerpResult2945_g51941;
				
				float2 vertexToFrag11_g52248 = IN.ase_texcoord9.xy;
				half2 Emissive_UVs2468_g51941 = vertexToFrag11_g52248;
				half Global_Extras_Emissive4203_g51941 = break89_g52261.r;
				float lerpResult4206_g51941 = lerp( 1.0 , Global_Extras_Emissive4203_g51941 , _GlobalEmissive);
				half3 Final_Emissive2476_g51941 = ( (( _EmissiveColor * SAMPLE_TEXTURE2D( _EmissiveTex, sampler_EmissiveTex, Emissive_UVs2468_g51941 ) )).rgb * lerpResult4206_g51941 );
				
				float3 temp_cast_4 = (( 0.04 * _RenderSpecular )).xxx;
				
				half Main_Smoothness227_g51941 = ( tex2DNode35_g51941.a * _MainSmoothnessValue );
				half Second_Smoothness236_g51941 = ( tex2DNode33_g51941.a * _SecondSmoothnessValue );
				float lerpResult266_g51941 = lerp( Main_Smoothness227_g51941 , Second_Smoothness236_g51941 , Mask_Detail147_g51941);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float staticSwitch4065_g51941 = Main_Smoothness227_g51941;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float staticSwitch4065_g51941 = lerpResult266_g51941;
				#else
				float staticSwitch4065_g51941 = Main_Smoothness227_g51941;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch297_g51941 = Main_Smoothness227_g51941;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch297_g51941 = staticSwitch4065_g51941;
				#else
				float staticSwitch297_g51941 = Main_Smoothness227_g51941;
				#endif
				half Blend_Smoothness314_g51941 = staticSwitch297_g51941;
				half Global_OverlaySmoothness311_g51941 = TVE_OverlaySmoothness;
				float lerpResult343_g51941 = lerp( Blend_Smoothness314_g51941 , Global_OverlaySmoothness311_g51941 , Overlay_Mask269_g51941);
				half Final_Smoothness371_g51941 = lerpResult343_g51941;
				half Global_Extras_Wetness305_g51941 = break89_g52261.g;
				float lerpResult3673_g51941 = lerp( 0.0 , Global_Extras_Wetness305_g51941 , _GlobalWetness);
				half Final_SmoothnessAndWetness4130_g51941 = saturate( ( Final_Smoothness371_g51941 + lerpResult3673_g51941 ) );
				
				float lerpResult240_g51941 = lerp( 1.0 , tex2DNode35_g51941.g , _MainOcclusionValue);
				half Main_Occlusion247_g51941 = lerpResult240_g51941;
				float lerpResult239_g51941 = lerp( 1.0 , tex2DNode33_g51941.g , _SecondOcclusionValue);
				half Second_Occlusion251_g51941 = lerpResult239_g51941;
				float lerpResult294_g51941 = lerp( Main_Occlusion247_g51941 , Second_Occlusion251_g51941 , Mask_Detail147_g51941);
				#if defined(TVE_DETAIL_BLEND_OVERLAY)
				float staticSwitch4066_g51941 = Main_Occlusion247_g51941;
				#elif defined(TVE_DETAIL_BLEND_REPLACE)
				float staticSwitch4066_g51941 = lerpResult294_g51941;
				#else
				float staticSwitch4066_g51941 = Main_Occlusion247_g51941;
				#endif
				#if defined(TVE_DETAIL_MODE_OFF)
				float staticSwitch310_g51941 = Main_Occlusion247_g51941;
				#elif defined(TVE_DETAIL_MODE_ON)
				float staticSwitch310_g51941 = staticSwitch4066_g51941;
				#else
				float staticSwitch310_g51941 = Main_Occlusion247_g51941;
				#endif
				half Blend_Occlusion323_g51941 = staticSwitch310_g51941;
				
				float localCustomAlphaClip3735_g51941 = ( 0.0 );
				float vertexToFrag11_g52251 = IN.ase_texcoord9.z;
				half Fade_Camera3743_g51941 = vertexToFrag11_g52251;
				half Final_AlphaFade3727_g51941 = ( 1.0 * Fade_Camera3743_g51941 );
				float temp_output_41_0_g52255 = Final_AlphaFade3727_g51941;
				float Main_Alpha316_g51941 = ( _MainColor.a * tex2DNode29_g51941.a );
				half AlphaTreshold2132_g51941 = _Cutoff;
				#ifdef TVE_ALPHA_CLIP
				float staticSwitch3792_g51941 = ( Main_Alpha316_g51941 - ( AlphaTreshold2132_g51941 - 0.5 ) );
				#else
				float staticSwitch3792_g51941 = Main_Alpha316_g51941;
				#endif
				half Final_Alpha3754_g51941 = staticSwitch3792_g51941;
				float temp_output_661_0_g51941 = ( saturate( ( temp_output_41_0_g52255 + ( temp_output_41_0_g52255 * SAMPLE_TEXTURE3D( TVE_ScreenTex3D, samplerTVE_ScreenTex3D, ( TVE_ScreenTexCoord * PositionWS_PerVertex3905_g51941 ) ).r ) ) ) * Final_Alpha3754_g51941 );
				float Alpha3735_g51941 = temp_output_661_0_g51941;
				float Treshold3735_g51941 = 0.5;
				{
				#if TVE_ALPHA_CLIP
				clip(Alpha3735_g51941 - Treshold3735_g51941);
				#endif
				}
				half Final_Clip914_g51941 = saturate( Alpha3735_g51941 );
				
				float3 Albedo = ( Final_Albedo359_g51941 * Vertex_Occlusion648_g51941 );
				float3 Normal = float3(0, 0, 1);
				float3 Emission = Final_Emissive2476_g51941;
				float3 Specular = temp_cast_4;
				float Metallic = 0;
				float Smoothness = Final_SmoothnessAndWetness4130_g51941;
				float Occlusion = Blend_Occlusion323_g51941;
				float Alpha = Final_Clip914_g51941;
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
1920;0;1920;1029;2833.496;727.968;1;True;False
Node;AmplifyShaderEditor.FunctionNode;374;-1856,384;Inherit;False;Define PIPELINE UNIVERSAL;-1;;46753;71dc7add32e5f6247b1fb74ecceddd3e;0;0;1;FLOAT;529
Node;AmplifyShaderEditor.FunctionNode;376;-1536,-896;Inherit;False;Compile Core;-1;;51940;634b02fd1f32e6a4c875d8fc2c450956;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;375;-1344,-896;Inherit;False;Compile All Shaders;-1;;51939;e67c8238031dbf04ab79a5d4d63d1b4f;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-2176,-896;Half;False;Property;_IsBarkShader;_IsBarkShader;211;1;[HideInInspector];Create;True;0;0;0;True;0;False;1;1;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-1984,-896;Half;False;Property;_IsStandardShader;_IsStandardShader;212;1;[HideInInspector];Create;True;0;0;0;True;0;False;1;1;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;350;-2176,-384;Inherit;False;Base Shader;0;;51941;856f7164d1c579d43a5cf4968a75ca43;80,3882,1,3880,1,3957,1,4028,1,4029,1,3900,1,3903,1,3904,1,4204,1,3908,1,4172,1,1300,1,1298,1,4179,1,3586,0,1271,1,3889,1,3658,0,1708,0,3509,1,1712,1,3873,1,1715,1,1714,1,1717,1,1718,1,916,1,1763,0,1762,0,3568,1,1949,1,1776,0,3475,1,4210,1,893,0,1745,1,3479,0,3501,1,3221,2,1646,0,1757,0,2807,0,3886,0,2953,0,3887,0,3243,0,3888,0,3728,1,3949,0,2172,0,3883,0,2658,0,1742,0,3484,0,1735,1,1736,1,1733,1,1737,1,1734,1,3575,1,878,0,1550,0,4067,0,4068,0,4072,0,4070,0,4069,0,860,1,3544,1,2261,1,2260,1,2032,1,2054,1,2060,0,2036,0,2062,0,2039,0,4177,1,3592,1,2750,0;0;19;FLOAT3;0;FLOAT3;528;FLOAT3;2489;FLOAT;531;FLOAT;4135;FLOAT;529;FLOAT;3678;FLOAT;530;FLOAT;4127;FLOAT;4122;FLOAT;4134;FLOAT;1235;FLOAT3;1230;FLOAT;1461;FLOAT;1290;FLOAT;721;FLOAT;532;FLOAT;629;FLOAT3;534
Node;AmplifyShaderEditor.RangedFloatNode;20;-1984,-768;Half;False;Property;_render_src;_render_src;214;1;[HideInInspector];Create;True;0;0;0;True;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2176,-768;Half;False;Property;_render_cull;_render_cull;213;1;[HideInInspector];Create;True;0;3;Both;0;Back;1;Front;2;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1600,-768;Half;False;Property;_render_zw;_render_zw;216;1;[HideInInspector];Create;True;0;2;Opaque;0;Transparent;1;0;True;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1792,-768;Half;False;Property;_render_dst;_render_dst;215;1;[HideInInspector];Create;True;0;2;Opaque;0;Transparent;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;307;-2176,384;Inherit;False;Define TVE IS VEGETATION SHADER;-1;;51938;b458122dd75182d488380bd0f592b9e6;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;369;-1376,-384;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;14;New Amplify Shader;28cd5599e02859647ae1798e4fcaef6c;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;True;False;False;False;False;0;False;-1;False;False;False;False;False;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;370;-1376,-384;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;14;New Amplify Shader;28cd5599e02859647ae1798e4fcaef6c;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;367;-1376,-384;Float;False;True;-1;2;TVEShaderCoreGUI;0;18;BOXOPHOBIC/The Vegetation Engine/Vegetation/Bark Standard Lit;28cd5599e02859647ae1798e4fcaef6c;True;Forward;0;1;Forward;18;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;2;True;10;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;4;0;True;True;1;1;True;20;0;True;7;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;1;True;17;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/BOXOPHOBIC/The Vegetation Engine/Fallback;0;0;Standard;38;Workflow;0;Surface;0;  Refraction Model;0;  Blend;0;Two Sided;0;Fragment Normal Space,InvertActionOnDeselection;0;Transmission;0;  Transmission Shadow;0.5,True,1013;Translucency;0;  Translucency Strength;1,False,-1;  Normal Distortion;0.5,False,-1;  Scattering;2,False,-1;  Direct;0.9,False,-1;  Ambient;0.1,False,-1;  Shadow;0.5,False,-1;Cast Shadows;1;  Use Shadow Threshold;0;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;1;Built-in Fog;1;_FinalColorxAlpha;0;Meta Pass;1;Override Baked GI;0;Extra Pre Pass;0;DOTS Instancing;1;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;0;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Write Depth;0;  Early Z;0;Vertex Position,InvertActionOnDeselection;0;0;8;False;True;True;True;True;True;True;True;False;;True;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;368;-1376,-384;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;14;New Amplify Shader;28cd5599e02859647ae1798e4fcaef6c;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;366;-1376,-384;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;14;New Amplify Shader;28cd5599e02859647ae1798e4fcaef6c;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;378;-1376,-384;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;14;New Amplify Shader;28cd5599e02859647ae1798e4fcaef6c;True;GBuffer;0;7;GBuffer;1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;True;1;1;True;20;0;True;7;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;True;17;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;1;LightMode=UniversalGBuffer;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;377;-1376,-47;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;14;New Amplify Shader;28cd5599e02859647ae1798e4fcaef6c;True;DepthNormals;0;6;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=DepthNormals;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;371;-1376,-384;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;14;New Amplify Shader;28cd5599e02859647ae1798e4fcaef6c;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;True;1;1;True;20;0;True;7;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;False;False;True;1;True;17;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;1;LightMode=Universal2D;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.CommentaryNode;37;-2176,-1024;Inherit;False;1026.438;100;Internal;0;;1,0.252,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;33;-2176,-512;Inherit;False;1022.896;100;Final;0;;0,1,0.5,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;285;-2176,256;Inherit;False;1026.438;100;Features;0;;0,1,0.5,1;0;0
WireConnection;367;0;350;0
WireConnection;367;1;350;528
WireConnection;367;2;350;2489
WireConnection;367;9;350;3678
WireConnection;367;4;350;530
WireConnection;367;5;350;531
WireConnection;367;6;350;532
WireConnection;367;8;350;534
ASEEND*/
//CHKSM=31291789FBA4696EF77737E0FC8A53C366E431ED
