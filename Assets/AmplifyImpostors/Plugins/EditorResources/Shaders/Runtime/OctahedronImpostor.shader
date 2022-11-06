// Amplify Impostors
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

Shader "Hidden/Amplify Impostors/Octahedron Impostor"
{
	Properties
	{
		[NoScaleOffset]_Albedo("Albedo & Alpha", 2D) = "white" {}
		[NoScaleOffset]_Normals("Normals & Depth", 2D) = "white" {}
		[NoScaleOffset]_Specular("Specular & Smoothness", 2D) = "black" {}
		[NoScaleOffset]_Emission("Emission & Occlusion", 2D) = "black" {}
		[HideInInspector]_Frames("Frames", Float) = 16
		[HideInInspector]_ImpostorSize("Impostor Size", Float) = 1
		[HideInInspector]_Offset("Offset", Vector) = (0,0,0,0)
		[HideInInspector]_AI_SizeOffset( "Size & Offset", Vector ) = ( 0,0,0,0 )
		_TextureBias("Texture Bias", Float) = -1
		_Parallax("Parallax", Range( -1 , 1)) = 1
		[HideInInspector]_DepthSize("DepthSize", Float) = 1
		_ClipMask("Clip", Range( 0 , 1)) = 0.5
		_AI_ShadowBias("Shadow Bias", Range( 0 , 2)) = 0.25
		_AI_ShadowView( "Shadow View", Range( 0 , 1 ) ) = 1
		[Toggle(_HEMI_ON)] _Hemi("Hemi", Float) = 0
		[Toggle(EFFECT_HUE_VARIATION)] _Hue("Use SpeedTree Hue", Float) = 0
		_HueVariation("Hue Variation", Color) = (0,0,0,0)
		[Toggle] _AI_AlphaToCoverage("Alpha To Coverage", Float) = 0
	}

	SubShader
	{
		CGINCLUDE
		#pragma target 3.0
		#define UNITY_SAMPLE_FULL_SH_PER_PIXEL 1

		#pragma shader_feature _HEMI_ON
		#pragma shader_feature EFFECT_HUE_VARIATION
		ENDCG

		Tags { "RenderType"="Opaque" "Queue"="Geometry" "DisableBatching"="True" }
		Cull Back
		AlphaToMask [_AI_AlphaToCoverage]

		Pass
		{
			ZWrite On
			Name "ForwardBase"
			Tags { "LightMode"="ForwardBase" }

			CGPROGRAM
			// compile directives
			#pragma vertex vert_surf
			#pragma fragment frag_surf
			#pragma multi_compile_fog
			#pragma multi_compile_fwdbase
			#pragma multi_compile_instancing
			#pragma multi_compile __ LOD_FADE_CROSSFADE
			#include "HLSLSupport.cginc"
			#if !defined( UNITY_INSTANCED_LOD_FADE )
				#define UNITY_INSTANCED_LOD_FADE
			#endif
			#if !defined( UNITY_INSTANCED_SH )
				#define UNITY_INSTANCED_SH
			#endif
			#if !defined( UNITY_INSTANCED_LIGHTMAPSTS )
				#define UNITY_INSTANCED_LIGHTMAPSTS
			#endif
			#include "UnityShaderVariables.cginc"
			#include "UnityShaderUtilities.cginc"
			#ifndef UNITY_PASS_FORWARDBASE
			#define UNITY_PASS_FORWARDBASE
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			#include "AutoLight.cginc"
			#include "UnityStandardUtils.cginc"

			#include "AmplifyImpostors.cginc"

			struct v2f_surf {
				UNITY_POSITION(pos);
				float4 uvsFrame1 : TEXCOORD1;
				float4 uvsFrame2 : TEXCOORD2;
				float4 uvsFrame3 : TEXCOORD3;
				float4 octaFrame : TEXCOORD4;
				float4 viewPos : TEXCOORD5;
				#if UNITY_VERSION >= 201810
					UNITY_LIGHTING_COORDS(6,7)
				#else
					UNITY_SHADOW_COORDS(6)
				#endif
				UNITY_FOG_COORDS(8)
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};


			v2f_surf vert_surf (appdata_full v ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				OctaImpostorVertex( v.vertex, v.normal, o.uvsFrame1, o.uvsFrame2, o.uvsFrame3, o.octaFrame, o.viewPos );

				o.pos = UnityObjectToClipPos(v.vertex);

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);

				#if UNITY_VERSION >= 201810
					UNITY_TRANSFER_LIGHTING(o, v.texcoord1.xy);
				#else
					UNITY_TRANSFER_SHADOW(o, v.texcoord1.xy);
				#endif
				UNITY_TRANSFER_FOG(o,o.pos);
				return o;
			}

			fixed4 frag_surf (v2f_surf IN, out float outDepth : SV_Depth ) : SV_Target {
				UNITY_SETUP_INSTANCE_ID(IN);
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o );

				float4 clipPos;
				float3 worldPos;
				OctaImpostorFragment( o, clipPos, worldPos, IN.uvsFrame1, IN.uvsFrame2, IN.uvsFrame3, IN.octaFrame, IN.viewPos );
				IN.pos.zw = clipPos.zw;

				outDepth = IN.pos.z;

				#ifndef USING_DIRECTIONAL_LIGHT
					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				#else
					fixed3 lightDir = _WorldSpaceLightPos0.xyz;
				#endif

				fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));

				UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
				UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
				fixed4 c = 0;

				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
				gi.indirect.diffuse = 0;
				gi.indirect.specular = 0;
				gi.light.color = _LightColor0.rgb;
				gi.light.dir = lightDir;

				UnityGIInput giInput;
				UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
				giInput.light = gi.light;
				giInput.worldPos = worldPos;
				giInput.worldViewDir = worldViewDir;
				giInput.atten = atten;
				
				giInput.probeHDR[0] = unity_SpecCube0_HDR;
				giInput.probeHDR[1] = unity_SpecCube1_HDR;
				#if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION
					giInput.boxMin[0] = unity_SpecCube0_BoxMin;
				#endif
				#if UNITY_SPECCUBE_BOX_PROJECTION
					giInput.boxMax[0] = unity_SpecCube0_BoxMax;
					giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
					giInput.boxMax[1] = unity_SpecCube1_BoxMax;
					giInput.boxMin[1] = unity_SpecCube1_BoxMin;
					giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
				#endif

				LightingStandardSpecular_GI(o, giInput, gi);

				c += LightingStandardSpecular (o, worldViewDir, gi);
				c.rgb += o.Emission;
				// revisit this later
				//UNITY_TRANSFER_FOG(IN,IN.pos);
				UNITY_APPLY_FOG(IN.fogCoord, c);
				return c;
			}

			ENDCG
		}

		Pass
		{
			Name "ForwardAdd"
			Tags { "LightMode"="ForwardAdd" }
			ZWrite Off
			Blend One One

			CGPROGRAM
			#pragma vertex vert_surf
			#pragma fragment frag_surf
			#pragma multi_compile_fog
			#pragma multi_compile_instancing
			#pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile __ LOD_FADE_CROSSFADE
			#pragma skip_variants INSTANCING_ON
			#include "HLSLSupport.cginc"
			#if !defined( UNITY_INSTANCED_LOD_FADE )
				#define UNITY_INSTANCED_LOD_FADE
			#endif
			#if !defined( UNITY_INSTANCED_SH )
				#define UNITY_INSTANCED_SH
			#endif
			#if !defined( UNITY_INSTANCED_LIGHTMAPSTS )
				#define UNITY_INSTANCED_LIGHTMAPSTS
			#endif
			#include "UnityShaderVariables.cginc"
			#include "UnityShaderUtilities.cginc"
			#ifndef UNITY_PASS_FORWARDADD
			#define UNITY_PASS_FORWARDADD
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			#include "AutoLight.cginc"
			#include "UnityStandardUtils.cginc"

			#include "AmplifyImpostors.cginc"

			struct v2f_surf {
				UNITY_POSITION(pos);
				float4 uvsFrame1 : TEXCOORD1;
				float4 uvsFrame2 : TEXCOORD2;
				float4 uvsFrame3 : TEXCOORD3;
				float4 octaFrame : TEXCOORD4;
				float4 viewPos : TEXCOORD5;
				#if UNITY_VERSION >= 201810
					UNITY_LIGHTING_COORDS(6,7)
				#else
					UNITY_SHADOW_COORDS(6)
				#endif
				UNITY_FOG_COORDS(8)
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			v2f_surf vert_surf (appdata_full v ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				OctaImpostorVertex( v.vertex, v.normal, o.uvsFrame1, o.uvsFrame2, o.uvsFrame3, o.octaFrame, o.viewPos );

				o.pos = UnityObjectToClipPos(v.vertex);

				#if UNITY_VERSION >= 201810
					UNITY_TRANSFER_LIGHTING(o, v.texcoord1.xy);
				#else
					UNITY_TRANSFER_SHADOW(o, v.texcoord1.xy);
				#endif
				UNITY_TRANSFER_FOG(o,o.pos);
				return o;
			}

			fixed4 frag_surf (v2f_surf IN, out float outDepth : SV_Depth ) : SV_Target {
				UNITY_SETUP_INSTANCE_ID(IN);
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o );

				float4 clipPos;
				float3 worldPos;
				OctaImpostorFragment( o, clipPos, worldPos, IN.uvsFrame1, IN.uvsFrame2, IN.uvsFrame3, IN.octaFrame, IN.viewPos );
				IN.pos.zw = clipPos.zw;

				outDepth = IN.pos.z;

				#ifndef USING_DIRECTIONAL_LIGHT
					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				#else
					fixed3 lightDir = _WorldSpaceLightPos0.xyz;
				#endif

				fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));

				UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
				UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
				fixed4 c = 0;

				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
				gi.indirect.diffuse = 0;
				gi.indirect.specular = 0;
				gi.light.color = _LightColor0.rgb;
				gi.light.dir = lightDir;
				gi.light.color *= atten;
				c += LightingStandardSpecular (o, worldViewDir, gi);
				// revisit this later
				//UNITY_TRANSFER_FOG(IN,IN.pos);
				UNITY_APPLY_FOG(IN.fogCoord, c);
				return c;
			}
			ENDCG
		}

		Pass
		{
			Name "Deferred"
			Tags { "LightMode"="Deferred" }

			CGPROGRAM
			#pragma vertex vert_surf
			#pragma fragment frag_surf
			#pragma multi_compile_instancing
			#pragma multi_compile __ LOD_FADE_CROSSFADE
			#pragma exclude_renderers nomrt
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#pragma multi_compile_prepassfinal
			#include "HLSLSupport.cginc"
			#if !defined( UNITY_INSTANCED_LOD_FADE )
				#define UNITY_INSTANCED_LOD_FADE
			#endif
			#if !defined( UNITY_INSTANCED_SH )
				#define UNITY_INSTANCED_SH
			#endif
			#if !defined( UNITY_INSTANCED_LIGHTMAPSTS )
				#define UNITY_INSTANCED_LIGHTMAPSTS
			#endif
			#include "UnityShaderVariables.cginc"
			#include "UnityShaderUtilities.cginc"
			#ifndef UNITY_PASS_DEFERRED
			#define UNITY_PASS_DEFERRED
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			#include "UnityStandardUtils.cginc"

			#include "AmplifyImpostors.cginc"

			fixed4 unity_Ambient;

			struct v2f_surf {
				UNITY_POSITION(pos);
				float4 uvsFrame1 : TEXCOORD1;
				float4 uvsFrame2 : TEXCOORD2;
				float4 uvsFrame3 : TEXCOORD3;
				float4 octaFrame : TEXCOORD4;
				float4 viewPos : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			v2f_surf vert_surf (appdata_full v ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				OctaImpostorVertex( v.vertex, v.normal, o.uvsFrame1, o.uvsFrame2, o.uvsFrame3, o.octaFrame, o.viewPos );

				o.pos = UnityObjectToClipPos(v.vertex);

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 viewDirForLight = UnityWorldSpaceViewDir(worldPos);
				
				return o;
			}

			void frag_surf (v2f_surf IN , out half4 outGBuffer0 : SV_Target0, out half4 outGBuffer1 : SV_Target1, out half4 outGBuffer2 : SV_Target2, out half4 outEmission : SV_Target3
			, out float outDepth : SV_Depth
			) {
				UNITY_SETUP_INSTANCE_ID(IN);
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o );

				float4 clipPos;
				float3 worldPos;
				OctaImpostorFragment( o, clipPos, worldPos, IN.uvsFrame1, IN.uvsFrame2, IN.uvsFrame3, IN.octaFrame, IN.viewPos );
				IN.pos.zw = clipPos.zw;

				outDepth = IN.pos.z;

				#ifndef USING_DIRECTIONAL_LIGHT
					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				#else
					fixed3 lightDir = _WorldSpaceLightPos0.xyz;
				#endif

				fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));

				UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
				half atten = 1;

				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
				gi.indirect.diffuse = 0;
				gi.indirect.specular = 0;
				gi.light.color = 0;
				gi.light.dir = half3(0,1,0);

				UnityGIInput giInput;
				UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
				giInput.light = gi.light;
				giInput.worldPos = worldPos;
				giInput.worldViewDir = worldViewDir;
				giInput.atten = atten;
				
				giInput.probeHDR[0] = unity_SpecCube0_HDR;
				giInput.probeHDR[1] = unity_SpecCube1_HDR;
				#if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
					giInput.boxMin[0] = unity_SpecCube0_BoxMin;
				#endif
				#ifdef UNITY_SPECCUBE_BOX_PROJECTION
					giInput.boxMax[0] = unity_SpecCube0_BoxMax;
					giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
					giInput.boxMax[1] = unity_SpecCube1_BoxMax;
					giInput.boxMin[1] = unity_SpecCube1_BoxMin;
					giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
				#endif
				LightingStandardSpecular_GI(o, giInput, gi);

				outEmission = LightingStandardSpecular_Deferred (o, worldViewDir, gi, outGBuffer0, outGBuffer1, outGBuffer2);
				
				#ifndef UNITY_HDR_ON
					outEmission.rgb = exp2(-outEmission.rgb);
				#endif
			}
			ENDCG
		}

		Pass
		{
			Name "Meta"
			Tags { "LightMode"="Meta" }
			Cull Off

			CGPROGRAM
			#pragma vertex vert_surf
			#pragma fragment frag_surf
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#pragma skip_variants INSTANCING_ON
			#pragma shader_feature EDITOR_VISUALIZATION
			#pragma multi_compile_instancing

			#include "HLSLSupport.cginc"
			#if !defined( UNITY_INSTANCED_LOD_FADE )
				#define UNITY_INSTANCED_LOD_FADE
			#endif
			#if !defined( UNITY_INSTANCED_SH )
				#define UNITY_INSTANCED_SH
			#endif
			#if !defined( UNITY_INSTANCED_LIGHTMAPSTS )
				#define UNITY_INSTANCED_LIGHTMAPSTS
			#endif
			#include "UnityShaderVariables.cginc"
			#include "UnityShaderUtilities.cginc"
			#ifndef UNITY_PASS_META
			#define UNITY_PASS_META
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			#include "UnityStandardUtils.cginc"
			#include "UnityMetaPass.cginc"

			#include "AmplifyImpostors.cginc"

			struct v2f_surf {
				UNITY_POSITION(pos);
				float4 uvsFrame1 : TEXCOORD1;
				float4 uvsFrame2 : TEXCOORD2;
				float4 uvsFrame3 : TEXCOORD3;
				float4 octaFrame : TEXCOORD4;
				float4 viewPos : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			v2f_surf vert_surf (appdata_full v ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				OctaImpostorVertex( v.vertex, v.normal, o.uvsFrame1, o.uvsFrame2, o.uvsFrame3, o.octaFrame, o.viewPos );

				o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST);
				return o;
			}

			fixed4 frag_surf (v2f_surf IN, out float outDepth : SV_Depth  ) : SV_Target {
				UNITY_SETUP_INSTANCE_ID(IN);
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o );

				float4 clipPos;
				float3 worldPos;
				OctaImpostorFragment( o, clipPos, worldPos, IN.uvsFrame1, IN.uvsFrame2, IN.uvsFrame3, IN.octaFrame, IN.viewPos );
				IN.pos.zw = clipPos.zw;

				outDepth = IN.pos.z;

				#ifndef USING_DIRECTIONAL_LIGHT
					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				#else
					fixed3 lightDir = _WorldSpaceLightPos0.xyz;
				#endif

				fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));

				UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);

				UnityMetaInput metaIN;
				UNITY_INITIALIZE_OUTPUT(UnityMetaInput, metaIN);
				metaIN.Albedo = o.Albedo;
				metaIN.Emission = o.Emission;
				return UnityMetaFragment(metaIN);
			}
			ENDCG
		}

		Pass
		{
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }
			ZWrite On

			CGPROGRAM
			#pragma vertex vert_surf
			#pragma fragment frag_surf
			#pragma multi_compile_shadowcaster
			#pragma multi_compile __ LOD_FADE_CROSSFADE
			#ifndef UNITY_PASS_SHADOWCASTER
			#define UNITY_PASS_SHADOWCASTER
			#endif
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#pragma multi_compile_instancing
			#include "HLSLSupport.cginc"
			#if !defined( UNITY_INSTANCED_LOD_FADE )
				#define UNITY_INSTANCED_LOD_FADE
			#endif
			#include "UnityShaderVariables.cginc"
			#include "UnityShaderUtilities.cginc"
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			#include "UnityStandardUtils.cginc"

			#include "AmplifyImpostors.cginc"

			struct v2f_surf {
				V2F_SHADOW_CASTER;
				float4 uvsFrame1 : TEXCOORD1;
				float4 uvsFrame2 : TEXCOORD2;
				float4 uvsFrame3 : TEXCOORD3;
				float4 octaFrame : TEXCOORD4;
				float4 viewPos : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			v2f_surf vert_surf (appdata_full v) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				OctaImpostorVertex( v.vertex, v.normal, o.uvsFrame1, o.uvsFrame2, o.uvsFrame3, o.octaFrame, o.viewPos );

				TRANSFER_SHADOW_CASTER(o)
				return o;
			}

			fixed4 frag_surf (v2f_surf IN, out float outDepth : SV_Depth ) : SV_Target {
				UNITY_SETUP_INSTANCE_ID(IN);
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o );

				float4 clipPos;
				float3 worldPos;
				OctaImpostorFragment( o, clipPos, worldPos, IN.uvsFrame1, IN.uvsFrame2, IN.uvsFrame3, IN.octaFrame, IN.viewPos );
				IN.pos.zw = clipPos.zw;

				outDepth = IN.pos.z;

				UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
				SHADOW_CASTER_FRAGMENT(IN)
			}
			ENDCG
		}

		Pass
		{
			Name "SceneSelectionPass"
			Tags{ "LightMode" = "SceneSelectionPass" }
			ZWrite On
			ColorMask 0

			CGPROGRAM
			#pragma vertex vert_surf
			#pragma fragment frag_surf
			#pragma multi_compile __ LOD_FADE_CROSSFADE
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#pragma multi_compile_instancing
			#include "HLSLSupport.cginc"
			#if !defined( UNITY_INSTANCED_LOD_FADE )
				#define UNITY_INSTANCED_LOD_FADE
			#endif
			#include "UnityShaderVariables.cginc"
			#include "UnityShaderUtilities.cginc"
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			#include "UnityStandardUtils.cginc"

			#include "AmplifyImpostors.cginc"

			int _ObjectId;
			int _PassValue;

			struct v2f_surf {
				UNITY_POSITION( pos );
				float4 uvsFrame1 : TEXCOORD1;
				float4 uvsFrame2 : TEXCOORD2;
				float4 uvsFrame3 : TEXCOORD3;
				float4 octaFrame : TEXCOORD4;
				float4 viewPos : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			v2f_surf vert_surf (appdata_full v) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				OctaImpostorVertex( v.vertex, v.normal, o.uvsFrame1, o.uvsFrame2, o.uvsFrame3, o.octaFrame, o.viewPos );

				o.pos = UnityObjectToClipPos( v.vertex );
				return o;
			}

			fixed4 frag_surf (v2f_surf IN, out float outDepth : SV_Depth ) : SV_Target {
				UNITY_SETUP_INSTANCE_ID(IN);
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o );

				float4 clipPos;
				float3 worldPos;
				OctaImpostorFragment( o, clipPos, worldPos, IN.uvsFrame1, IN.uvsFrame2, IN.uvsFrame3, IN.octaFrame, IN.viewPos );
				IN.pos.zw = clipPos.zw;

				outDepth = IN.pos.z;

				UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
				return float4( _ObjectId, _PassValue, 1.0, 1.0 );
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
