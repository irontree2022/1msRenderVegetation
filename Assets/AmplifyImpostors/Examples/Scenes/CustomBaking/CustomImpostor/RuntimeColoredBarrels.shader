// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Impostors/Custom/Colored Barrels"
{
	Properties
	{
		[NoScaleOffset]_Albedo("Impostor Albedo & Alpha", 2D) = "white" {}
		[NoScaleOffset]_Normals("Impostor Normal & Depth", 2D) = "white" {}
		[NoScaleOffset]_Mask("Mask", 2D) = "white" {}
		_AI_Clip("Impostor Clip", Range( 0 , 1)) = 0.5
		[HideInInspector]_AI_DepthSize("Impostor Depth Size", Float) = 0
		_AI_ShadowBias("Impostor Shadow Bias", Range( 0 , 2)) = 0.25
		_AI_ShadowView("Impostor Shadow View", Range( 0 , 1)) = 1
		[HideInInspector]_AI_FramesY("Impostor Frames Y", Float) = 0
		[HideInInspector]_AI_FramesX("Impostor Frames X", Float) = 0
		[HideInInspector]_AI_Frames("Impostor Frames", Float) = 0
		[HideInInspector]_AI_ImpostorSize("Impostor Size", Float) = 0
		_AI_TextureBias("Impostor Texture Bias", Float) = -1
		[HideInInspector]_AI_Offset("Impostor Offset", Vector) = (0,0,0,0)
		[HideInInspector]_AI_SizeOffset("Impostor Size Offset", Vector) = (0,0,0,0)
		_AI_Parallax("Impostor Parallax", Range( 0 , 1)) = 1

	}

	SubShader
	{
		LOD 0

		
		CGINCLUDE
		#pragma target 3.0
		#define UNITY_SAMPLE_FULL_SH_PER_PIXEL 1
		ENDCG
		Tags { "RenderType"="Opaque" "Queue"="Geometry" "DisableBatching"="True" "ImpostorType"="Octahedron" }
		Cull Back
		AlphaToMask Off

		Pass
		{
			
			ZWrite On
			Name "ForwardBase"
			Tags { "LightMode"="ForwardBase" }

			CGPROGRAM
			#define _SPECULAR_SETUP 1

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
			#define ai_ObjectToWorld unity_ObjectToWorld
			#define ai_WorldToObject unity_WorldToObject
			#define AI_INV_TWO_PI  UNITY_INV_TWO_PI
			#define AI_PI          UNITY_PI
			#define AI_INV_PI      UNITY_INV_PI

			uniform float _AI_Frames;
			uniform float _AI_FramesX;
			uniform float _AI_FramesY;
			uniform float _AI_ImpostorSize;
			uniform float _AI_Parallax;
			uniform float3 _AI_Offset;
			uniform float4 _AI_SizeOffset;
			uniform float _AI_TextureBias;
			uniform sampler2D _Albedo;
			uniform sampler2D _Normals;
			uniform float _AI_DepthSize;
			uniform float _AI_ShadowBias;
			uniform float _AI_ShadowView;
			uniform float _AI_Clip;
			uniform sampler2D _Mask;
			float2 VectortoOctahedron( float3 N )
			{
				N /= dot( 1.0, abs( N ) );
				if( N.z <= 0 )
				{
				N.xy = ( 1 - abs( N.yx ) ) * ( N.xy >= 0 ? 1.0 : -1.0 );
				}
				return N.xy;
			}
			
			float3 OctahedronToVector( float2 Oct )
			{
				float3 N = float3( Oct, 1.0 - dot( 1.0, abs( Oct ) ) );
				if(N.z< 0 )
				{
				N.xy = ( 1 - abs( N.yx) ) * (N.xy >= 0 ? 1.0 : -1.0 );
				}
				return normalize( N);
			}
			
			inline void RayPlaneIntersectionUV( float3 normal, float3 rayPosition, float3 rayDirection, inout float2 uvs, inout float3 localNormal )
			{
				float lDotN = dot( rayDirection, normal ); 
				float p0l0DotN = dot( -rayPosition, normal );
				float t = p0l0DotN / lDotN;
				float3 p = rayDirection * t + rayPosition;
				float3 upVector = float3( 0, 1, 0 );
				float3 tangent = normalize( cross( upVector, normal ) + float3( -0.001, 0, 0 ) );
				float3 bitangent = cross( tangent, normal );
				float frameX = dot( p, tangent );
				float frameZ = dot( p, bitangent );
				uvs = -float2( frameX, frameZ );
				if( t <= 0.0 )
				uvs = 0;
				float3x3 worldToLocal = float3x3( tangent, bitangent, normal );
				localNormal = normalize( mul( worldToLocal, rayDirection ) );
			}
			
			inline void OctaImpostorVertex( inout float4 vertex, inout float3 normal, inout float4 uvsFrame1, inout float4 uvsFrame2, inout float4 uvsFrame3, inout float4 octaFrame, inout float4 viewPos )
			{
				float2 uvOffset = _AI_SizeOffset.zw;
				float parallax = -_AI_Parallax; 
				float UVscale = _AI_ImpostorSize;
				float framesXY = _AI_Frames;
				float prevFrame = framesXY - 1;
				float3 fractions = 1.0 / float3( framesXY, prevFrame, UVscale );
				float fractionsFrame = fractions.x;
				float fractionsPrevFrame = fractions.y;
				float fractionsUVscale = fractions.z;
				float3 worldOrigin = 0;
				float4 perspective = float4( 0, 0, 0, 1 );
				if( UNITY_MATRIX_P[ 3 ][ 3 ] == 1 ) 
				{
				perspective = float4( 0, 0, 5000, 0 );
				worldOrigin = ai_ObjectToWorld._m03_m13_m23;
				}
				float3 worldCameraPos = worldOrigin + mul( UNITY_MATRIX_I_V, perspective ).xyz;
				float3 objectCameraPosition = mul( ai_WorldToObject, float4( worldCameraPos, 1 ) ).xyz - _AI_Offset.xyz; 
				float3 objectCameraDirection = normalize( objectCameraPosition );
				float3 upVector = float3( 0,1,0 );
				float3 objectHorizontalVector = normalize( cross( objectCameraDirection, upVector ) );
				float3 objectVerticalVector = cross( objectHorizontalVector, objectCameraDirection );
				float2 uvExpansion = vertex.xy;
				float3 billboard = objectHorizontalVector * uvExpansion.x + objectVerticalVector * uvExpansion.y;
				float3 localDir = billboard - objectCameraPosition; 
				float2 frameOcta = VectortoOctahedron( objectCameraDirection.xzy ) * 0.5 + 0.5;
				float2 prevOctaFrame = frameOcta * prevFrame;
				float2 baseOctaFrame = floor( prevOctaFrame );
				float2 fractionOctaFrame = ( baseOctaFrame * fractionsFrame );
				float2 octaFrame1 = ( baseOctaFrame * fractionsPrevFrame ) * 2.0 - 1.0;
				float3 octa1WorldY = OctahedronToVector( octaFrame1 ).xzy;
				float3 octa1LocalY;
				float2 uvFrame1;
				RayPlaneIntersectionUV( octa1WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame1, /*inout*/ octa1LocalY );
				float2 uvParallax1 = octa1LocalY.xy * fractionsFrame * parallax;
				uvFrame1 = ( uvFrame1 * fractionsUVscale + 0.5 ) * fractionsFrame + fractionOctaFrame;
				uvsFrame1 = float4( uvParallax1, uvFrame1) - float4( 0, 0, uvOffset );
				float2 fractPrevOctaFrame = frac( prevOctaFrame );
				float2 cornerDifference = lerp( float2( 0,1 ) , float2( 1,0 ) , saturate( ceil( ( fractPrevOctaFrame.x - fractPrevOctaFrame.y ) ) ));
				float2 octaFrame2 = ( ( baseOctaFrame + cornerDifference ) * fractionsPrevFrame ) * 2.0 - 1.0;
				float3 octa2WorldY = OctahedronToVector( octaFrame2 ).xzy;
				float3 octa2LocalY;
				float2 uvFrame2;
				RayPlaneIntersectionUV( octa2WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame2, /*inout*/ octa2LocalY );
				float2 uvParallax2 = octa2LocalY.xy * fractionsFrame * parallax;
				uvFrame2 = ( uvFrame2 * fractionsUVscale + 0.5 ) * fractionsFrame + ( ( cornerDifference * fractionsFrame ) + fractionOctaFrame );
				uvsFrame2 = float4( uvParallax2, uvFrame2) - float4( 0, 0, uvOffset );
				float2 octaFrame3 = ( ( baseOctaFrame + 1 ) * fractionsPrevFrame  ) * 2.0 - 1.0;
				float3 octa3WorldY = OctahedronToVector( octaFrame3 ).xzy;
				float3 octa3LocalY;
				float2 uvFrame3;
				RayPlaneIntersectionUV( octa3WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame3, /*inout*/ octa3LocalY );
				float2 uvParallax3 = octa3LocalY.xy * fractionsFrame * parallax;
				uvFrame3 = ( uvFrame3 * fractionsUVscale + 0.5 ) * fractionsFrame + ( fractionOctaFrame + fractionsFrame );
				uvsFrame3 = float4( uvParallax3, uvFrame3) - float4( 0, 0, uvOffset );
				octaFrame = 0;
				octaFrame.xy = prevOctaFrame;
				vertex.xyz = billboard + _AI_Offset.xyz;
				normal.xyz = objectCameraDirection;
				viewPos = 0;
				viewPos.xyz = UnityObjectToViewPos( vertex.xyz );
			}
			
			inline void OctaImpostorFragment( inout SurfaceOutputStandardSpecular o, out float4 clipPos, out float3 worldPos, float4 uvsFrame1, float4 uvsFrame2, float4 uvsFrame3, float4 octaFrame, float4 interpViewPos, out float4 output0 )
			{
				float depthBias = -1.0;
				float textureBias = _AI_TextureBias;
				float2 fraction = frac( octaFrame.xy );
				float2 invFraction = 1 - fraction;
				float3 weights;
				weights.x = min( invFraction.x, invFraction.y );
				weights.y = abs( fraction.x - fraction.y );
				weights.z = min( fraction.x, fraction.y );
				float4 parallaxSample1 = tex2Dbias( _Normals, float4( uvsFrame1.zw, 0, depthBias) );
				float2 parallax1 = ( ( 0.5 - parallaxSample1.a ) * uvsFrame1.xy ) + uvsFrame1.zw;
				float4 parallaxSample2 = tex2Dbias( _Normals, float4( uvsFrame2.zw, 0, depthBias) );
				float2 parallax2 = ( ( 0.5 - parallaxSample2.a ) * uvsFrame2.xy ) + uvsFrame2.zw;
				float4 parallaxSample3 = tex2Dbias( _Normals, float4( uvsFrame3.zw, 0, depthBias) );
				float2 parallax3 = ( ( 0.5 - parallaxSample3.a ) * uvsFrame3.xy ) + uvsFrame3.zw;
				float4 albedo1 = tex2Dbias( _Albedo, float4( parallax1, 0, textureBias) );
				float4 albedo2 = tex2Dbias( _Albedo, float4( parallax2, 0, textureBias) );
				float4 albedo3 = tex2Dbias( _Albedo, float4( parallax3, 0, textureBias) );
				float4 blendedAlbedo = albedo1 * weights.x + albedo2 * weights.y + albedo3 * weights.z;
				o.Alpha = ( blendedAlbedo.a - _AI_Clip );
				clip( o.Alpha );
				o.Albedo = blendedAlbedo.rgb;
				float4 normals1 = tex2Dbias( _Normals, float4( parallax1, 0, textureBias) );
				float4 normals2 = tex2Dbias( _Normals, float4( parallax2, 0, textureBias) );
				float4 normals3 = tex2Dbias( _Normals, float4( parallax3, 0, textureBias) );
				float4 blendedNormal = normals1 * weights.x  + normals2 * weights.y + normals3 * weights.z;
				float4 output0a = tex2Dbias( _Mask, float4( parallax1, 0, textureBias) ); 
				float4 output0b = tex2Dbias( _Mask, float4( parallax2, 0, textureBias) ); 
				float4 output0c = tex2Dbias( _Mask, float4( parallax3, 0, textureBias) ); 
				output0 = output0a * weights.x  + output0b * weights.y + output0c * weights.z; 
				float3 localNormal = blendedNormal.rgb * 2.0 - 1.0;
				float3 worldNormal = normalize( mul( (float3x3)ai_ObjectToWorld, localNormal ) );
				o.Normal = worldNormal;
				float3 viewPos = interpViewPos.xyz;
				float depthOffset = ( ( parallaxSample1.a * weights.x + parallaxSample2.a * weights.y + parallaxSample3.a * weights.z ) - 0.5 /** 2.0 - 1.0*/ ) /** 0.5*/ * _AI_DepthSize * length( ai_ObjectToWorld[ 2 ].xyz );
				#if defined(SHADOWS_DEPTH)
				if( unity_LightShadowBias.y == 1.0 ) 
				{
				viewPos.z += depthOffset * _AI_ShadowView;
				viewPos.z += -_AI_ShadowBias;
				}
				else 
				{
				viewPos.z += depthOffset;
				}
				#else 
				viewPos.z += depthOffset;
				#endif
				worldPos = mul( UNITY_MATRIX_I_V, float4( viewPos.xyz, 1 ) ).xyz;
				clipPos = mul( UNITY_MATRIX_P, float4( viewPos, 1 ) );
				#if defined(SHADOWS_DEPTH)
				clipPos = UnityApplyLinearShadowBias( clipPos );
				#endif
				clipPos.xyz /= clipPos.w;
				if( UNITY_NEAR_CLIP_VALUE < 0 )
				clipPos = clipPos * 0.5 + 0.5;
			}
			
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			

			/*struct appdata_full {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				fixed4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID*/
			
			/*};*/

			struct v2f_surf {
				UNITY_POSITION(pos);
				#if defined(LIGHTMAP_ON) || (!defined(LIGHTMAP_ON) && SHADER_TARGET >= 30)
					float4 lmap : TEXCOORD0;
				#endif
				#if !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH
					half3 sh : TEXCOORD1;
				#endif
				#if UNITY_VERSION >= 201810
					UNITY_LIGHTING_COORDS(2,3)
				#else
					UNITY_SHADOW_COORDS(2)
				#endif
				UNITY_FOG_COORDS(4)
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 UVsFrame117 : TEXCOORD5;
				float4 UVsFrame217 : TEXCOORD6;
				float4 UVsFrame317 : TEXCOORD7;
				float4 octaframe17 : TEXCOORD8;
				float4 viewPos17 : TEXCOORD9;
			};

			v2f_surf vert_surf (appdata_full v ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				OctaImpostorVertex( v.vertex, v.normal, o.UVsFrame117, o.UVsFrame217, o.UVsFrame317, o.octaframe17, o.viewPos17 );
				

				v.vertex.xyz +=  float3(0,0,0) ;
				o.pos = UnityObjectToClipPos(v.vertex);

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				#ifdef DYNAMICLIGHTMAP_ON
				o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif
				#ifdef LIGHTMAP_ON
				o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				#ifndef LIGHTMAP_ON
					#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
						o.sh = 0;
						#ifdef VERTEXLIGHT_ON
						o.sh += Shade4PointLights (
							unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
							unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
							unity_4LightAtten0, worldPos, worldNormal);
						#endif
						o.sh = ShadeSHPerVertex (worldNormal, o.sh);
					#endif
				#endif

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
				#if defined(_SPECULAR_SETUP)
					SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
				#else
					SurfaceOutputStandard o = (SurfaceOutputStandard)0;
				#endif

				float4 clipPos = 0;
				float3 worldPos = 0;
				float4 output0 = 0;
				OctaImpostorFragment( o, clipPos, worldPos, IN.UVsFrame117, IN.UVsFrame217, IN.UVsFrame317, IN.octaframe17, IN.viewPos17, output0 );
				float4 break38 = output0;
				float3 objToWorld67 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
				float3 hsvTorgb33 = HSVToRGB( float3(abs( sin( ( objToWorld67.x + objToWorld67.z ) ) ),1.0,1.0) );
				float3 lerpResult36 = lerp( o.Albedo , ( break38.w * hsvTorgb33 ) , break38.w);
				
				float3 temp_cast_0 = (break38.x).xxx;
				
				fixed3 albedo = lerpResult36;
				fixed3 normal = o.Normal;
				half3 emission = half3( 0, 0, 0 );
				fixed3 specular = temp_cast_0;
				fixed metallic = 0;
				half smoothness = break38.y;
				half occlusion = break38.z;
				fixed alpha = o.Alpha;
				float4 bakedGI = float4( 0, 0, 0, 0 );
				
				o.Albedo = albedo;
				o.Normal = normal;
				o.Emission = emission;
				#if defined(_SPECULAR_SETUP)
					o.Specular = specular;
				#else
					o.Metallic = metallic;
				#endif
				o.Smoothness = smoothness;
				o.Occlusion = occlusion;
				o.Alpha = alpha;
				clip(o.Alpha);

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
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
					giInput.lightmapUV = IN.lmap;
				#else
					giInput.lightmapUV = 0.0;
				#endif
				#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
					giInput.ambient = IN.sh;
				#else
					giInput.ambient.rgb = 0.0;
				#endif
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

				#if defined(_SPECULAR_SETUP)
					LightingStandardSpecular_GI(o, giInput, gi);
					#if defined(CUSTOM_BAKED_GI)
						gi.indirect.diffuse = DecodeLightmapRGBM( bakedGI, 1 ) * EMISSIVE_RGBM_SCALE;
					#endif
					c += LightingStandardSpecular (o, worldViewDir, gi);
				#else
					LightingStandard_GI( o, giInput, gi );
					#if defined(CUSTOM_BAKED_GI)
						gi.indirect.diffuse = DecodeLightmapRGBM( bakedGI, 1) * EMISSIVE_RGBM_SCALE;
					#endif
					c += LightingStandard( o, worldViewDir, gi );
				#endif
				c.rgb += o.Emission;
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
			#define _SPECULAR_SETUP 1

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
			#define ai_ObjectToWorld unity_ObjectToWorld
			#define ai_WorldToObject unity_WorldToObject
			#define AI_INV_TWO_PI  UNITY_INV_TWO_PI
			#define AI_PI          UNITY_PI
			#define AI_INV_PI      UNITY_INV_PI

			uniform float _AI_Frames;
			uniform float _AI_FramesX;
			uniform float _AI_FramesY;
			uniform float _AI_ImpostorSize;
			uniform float _AI_Parallax;
			uniform float3 _AI_Offset;
			uniform float4 _AI_SizeOffset;
			uniform float _AI_TextureBias;
			uniform sampler2D _Albedo;
			uniform sampler2D _Normals;
			uniform float _AI_DepthSize;
			uniform float _AI_ShadowBias;
			uniform float _AI_ShadowView;
			uniform float _AI_Clip;
			uniform sampler2D _Mask;
			float2 VectortoOctahedron( float3 N )
			{
				N /= dot( 1.0, abs( N ) );
				if( N.z <= 0 )
				{
				N.xy = ( 1 - abs( N.yx ) ) * ( N.xy >= 0 ? 1.0 : -1.0 );
				}
				return N.xy;
			}
			
			float3 OctahedronToVector( float2 Oct )
			{
				float3 N = float3( Oct, 1.0 - dot( 1.0, abs( Oct ) ) );
				if(N.z< 0 )
				{
				N.xy = ( 1 - abs( N.yx) ) * (N.xy >= 0 ? 1.0 : -1.0 );
				}
				return normalize( N);
			}
			
			inline void RayPlaneIntersectionUV( float3 normal, float3 rayPosition, float3 rayDirection, inout float2 uvs, inout float3 localNormal )
			{
				float lDotN = dot( rayDirection, normal ); 
				float p0l0DotN = dot( -rayPosition, normal );
				float t = p0l0DotN / lDotN;
				float3 p = rayDirection * t + rayPosition;
				float3 upVector = float3( 0, 1, 0 );
				float3 tangent = normalize( cross( upVector, normal ) + float3( -0.001, 0, 0 ) );
				float3 bitangent = cross( tangent, normal );
				float frameX = dot( p, tangent );
				float frameZ = dot( p, bitangent );
				uvs = -float2( frameX, frameZ );
				if( t <= 0.0 )
				uvs = 0;
				float3x3 worldToLocal = float3x3( tangent, bitangent, normal );
				localNormal = normalize( mul( worldToLocal, rayDirection ) );
			}
			
			inline void OctaImpostorVertex( inout float4 vertex, inout float3 normal, inout float4 uvsFrame1, inout float4 uvsFrame2, inout float4 uvsFrame3, inout float4 octaFrame, inout float4 viewPos )
			{
				float2 uvOffset = _AI_SizeOffset.zw;
				float parallax = -_AI_Parallax; 
				float UVscale = _AI_ImpostorSize;
				float framesXY = _AI_Frames;
				float prevFrame = framesXY - 1;
				float3 fractions = 1.0 / float3( framesXY, prevFrame, UVscale );
				float fractionsFrame = fractions.x;
				float fractionsPrevFrame = fractions.y;
				float fractionsUVscale = fractions.z;
				float3 worldOrigin = 0;
				float4 perspective = float4( 0, 0, 0, 1 );
				if( UNITY_MATRIX_P[ 3 ][ 3 ] == 1 ) 
				{
				perspective = float4( 0, 0, 5000, 0 );
				worldOrigin = ai_ObjectToWorld._m03_m13_m23;
				}
				float3 worldCameraPos = worldOrigin + mul( UNITY_MATRIX_I_V, perspective ).xyz;
				float3 objectCameraPosition = mul( ai_WorldToObject, float4( worldCameraPos, 1 ) ).xyz - _AI_Offset.xyz; 
				float3 objectCameraDirection = normalize( objectCameraPosition );
				float3 upVector = float3( 0,1,0 );
				float3 objectHorizontalVector = normalize( cross( objectCameraDirection, upVector ) );
				float3 objectVerticalVector = cross( objectHorizontalVector, objectCameraDirection );
				float2 uvExpansion = vertex.xy;
				float3 billboard = objectHorizontalVector * uvExpansion.x + objectVerticalVector * uvExpansion.y;
				float3 localDir = billboard - objectCameraPosition; 
				float2 frameOcta = VectortoOctahedron( objectCameraDirection.xzy ) * 0.5 + 0.5;
				float2 prevOctaFrame = frameOcta * prevFrame;
				float2 baseOctaFrame = floor( prevOctaFrame );
				float2 fractionOctaFrame = ( baseOctaFrame * fractionsFrame );
				float2 octaFrame1 = ( baseOctaFrame * fractionsPrevFrame ) * 2.0 - 1.0;
				float3 octa1WorldY = OctahedronToVector( octaFrame1 ).xzy;
				float3 octa1LocalY;
				float2 uvFrame1;
				RayPlaneIntersectionUV( octa1WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame1, /*inout*/ octa1LocalY );
				float2 uvParallax1 = octa1LocalY.xy * fractionsFrame * parallax;
				uvFrame1 = ( uvFrame1 * fractionsUVscale + 0.5 ) * fractionsFrame + fractionOctaFrame;
				uvsFrame1 = float4( uvParallax1, uvFrame1) - float4( 0, 0, uvOffset );
				float2 fractPrevOctaFrame = frac( prevOctaFrame );
				float2 cornerDifference = lerp( float2( 0,1 ) , float2( 1,0 ) , saturate( ceil( ( fractPrevOctaFrame.x - fractPrevOctaFrame.y ) ) ));
				float2 octaFrame2 = ( ( baseOctaFrame + cornerDifference ) * fractionsPrevFrame ) * 2.0 - 1.0;
				float3 octa2WorldY = OctahedronToVector( octaFrame2 ).xzy;
				float3 octa2LocalY;
				float2 uvFrame2;
				RayPlaneIntersectionUV( octa2WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame2, /*inout*/ octa2LocalY );
				float2 uvParallax2 = octa2LocalY.xy * fractionsFrame * parallax;
				uvFrame2 = ( uvFrame2 * fractionsUVscale + 0.5 ) * fractionsFrame + ( ( cornerDifference * fractionsFrame ) + fractionOctaFrame );
				uvsFrame2 = float4( uvParallax2, uvFrame2) - float4( 0, 0, uvOffset );
				float2 octaFrame3 = ( ( baseOctaFrame + 1 ) * fractionsPrevFrame  ) * 2.0 - 1.0;
				float3 octa3WorldY = OctahedronToVector( octaFrame3 ).xzy;
				float3 octa3LocalY;
				float2 uvFrame3;
				RayPlaneIntersectionUV( octa3WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame3, /*inout*/ octa3LocalY );
				float2 uvParallax3 = octa3LocalY.xy * fractionsFrame * parallax;
				uvFrame3 = ( uvFrame3 * fractionsUVscale + 0.5 ) * fractionsFrame + ( fractionOctaFrame + fractionsFrame );
				uvsFrame3 = float4( uvParallax3, uvFrame3) - float4( 0, 0, uvOffset );
				octaFrame = 0;
				octaFrame.xy = prevOctaFrame;
				vertex.xyz = billboard + _AI_Offset.xyz;
				normal.xyz = objectCameraDirection;
				viewPos = 0;
				viewPos.xyz = UnityObjectToViewPos( vertex.xyz );
			}
			
			inline void OctaImpostorFragment( inout SurfaceOutputStandardSpecular o, out float4 clipPos, out float3 worldPos, float4 uvsFrame1, float4 uvsFrame2, float4 uvsFrame3, float4 octaFrame, float4 interpViewPos, out float4 output0 )
			{
				float depthBias = -1.0;
				float textureBias = _AI_TextureBias;
				float2 fraction = frac( octaFrame.xy );
				float2 invFraction = 1 - fraction;
				float3 weights;
				weights.x = min( invFraction.x, invFraction.y );
				weights.y = abs( fraction.x - fraction.y );
				weights.z = min( fraction.x, fraction.y );
				float4 parallaxSample1 = tex2Dbias( _Normals, float4( uvsFrame1.zw, 0, depthBias) );
				float2 parallax1 = ( ( 0.5 - parallaxSample1.a ) * uvsFrame1.xy ) + uvsFrame1.zw;
				float4 parallaxSample2 = tex2Dbias( _Normals, float4( uvsFrame2.zw, 0, depthBias) );
				float2 parallax2 = ( ( 0.5 - parallaxSample2.a ) * uvsFrame2.xy ) + uvsFrame2.zw;
				float4 parallaxSample3 = tex2Dbias( _Normals, float4( uvsFrame3.zw, 0, depthBias) );
				float2 parallax3 = ( ( 0.5 - parallaxSample3.a ) * uvsFrame3.xy ) + uvsFrame3.zw;
				float4 albedo1 = tex2Dbias( _Albedo, float4( parallax1, 0, textureBias) );
				float4 albedo2 = tex2Dbias( _Albedo, float4( parallax2, 0, textureBias) );
				float4 albedo3 = tex2Dbias( _Albedo, float4( parallax3, 0, textureBias) );
				float4 blendedAlbedo = albedo1 * weights.x + albedo2 * weights.y + albedo3 * weights.z;
				o.Alpha = ( blendedAlbedo.a - _AI_Clip );
				clip( o.Alpha );
				o.Albedo = blendedAlbedo.rgb;
				float4 normals1 = tex2Dbias( _Normals, float4( parallax1, 0, textureBias) );
				float4 normals2 = tex2Dbias( _Normals, float4( parallax2, 0, textureBias) );
				float4 normals3 = tex2Dbias( _Normals, float4( parallax3, 0, textureBias) );
				float4 blendedNormal = normals1 * weights.x  + normals2 * weights.y + normals3 * weights.z;
				float4 output0a = tex2Dbias( _Mask, float4( parallax1, 0, textureBias) ); 
				float4 output0b = tex2Dbias( _Mask, float4( parallax2, 0, textureBias) ); 
				float4 output0c = tex2Dbias( _Mask, float4( parallax3, 0, textureBias) ); 
				output0 = output0a * weights.x  + output0b * weights.y + output0c * weights.z; 
				float3 localNormal = blendedNormal.rgb * 2.0 - 1.0;
				float3 worldNormal = normalize( mul( (float3x3)ai_ObjectToWorld, localNormal ) );
				o.Normal = worldNormal;
				float3 viewPos = interpViewPos.xyz;
				float depthOffset = ( ( parallaxSample1.a * weights.x + parallaxSample2.a * weights.y + parallaxSample3.a * weights.z ) - 0.5 /** 2.0 - 1.0*/ ) /** 0.5*/ * _AI_DepthSize * length( ai_ObjectToWorld[ 2 ].xyz );
				#if defined(SHADOWS_DEPTH)
				if( unity_LightShadowBias.y == 1.0 ) 
				{
				viewPos.z += depthOffset * _AI_ShadowView;
				viewPos.z += -_AI_ShadowBias;
				}
				else 
				{
				viewPos.z += depthOffset;
				}
				#else 
				viewPos.z += depthOffset;
				#endif
				worldPos = mul( UNITY_MATRIX_I_V, float4( viewPos.xyz, 1 ) ).xyz;
				clipPos = mul( UNITY_MATRIX_P, float4( viewPos, 1 ) );
				#if defined(SHADOWS_DEPTH)
				clipPos = UnityApplyLinearShadowBias( clipPos );
				#endif
				clipPos.xyz /= clipPos.w;
				if( UNITY_NEAR_CLIP_VALUE < 0 )
				clipPos = clipPos * 0.5 + 0.5;
			}
			
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			

			/*struct appdata_full {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				fixed4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID*/
			
			/*};*/

			struct v2f_surf {
				UNITY_POSITION(pos);
				#if UNITY_VERSION >= 201810
					UNITY_LIGHTING_COORDS(1,2)
				#else
					UNITY_SHADOW_COORDS(1)
				#endif
				UNITY_FOG_COORDS(3)
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 UVsFrame117 : TEXCOORD5;
				float4 UVsFrame217 : TEXCOORD6;
				float4 UVsFrame317 : TEXCOORD7;
				float4 octaframe17 : TEXCOORD8;
				float4 viewPos17 : TEXCOORD9;
			};

			v2f_surf vert_surf ( appdata_full v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				OctaImpostorVertex( v.vertex, v.normal, o.UVsFrame117, o.UVsFrame217, o.UVsFrame317, o.octaframe17, o.viewPos17 );
				

				v.vertex.xyz +=  float3(0,0,0) ;
				o.pos = UnityObjectToClipPos(v.vertex);

				#if UNITY_VERSION >= 201810
					UNITY_TRANSFER_LIGHTING(o, v.texcoord1.xy);
				#else
					UNITY_TRANSFER_SHADOW(o, v.texcoord1.xy);
				#endif
				UNITY_TRANSFER_FOG(o,o.pos);
				return o;
			}

			fixed4 frag_surf ( v2f_surf IN, out float outDepth : SV_Depth  ) : SV_Target {
				UNITY_SETUP_INSTANCE_ID(IN);
				#if defined(_SPECULAR_SETUP)
					SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
				#else
					SurfaceOutputStandard o = (SurfaceOutputStandard)0;
				#endif
				float4 clipPos = 0;
				float3 worldPos = 0;
				float4 output0 = 0;
				OctaImpostorFragment( o, clipPos, worldPos, IN.UVsFrame117, IN.UVsFrame217, IN.UVsFrame317, IN.octaframe17, IN.viewPos17, output0 );
				float4 break38 = output0;
				float3 objToWorld67 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
				float3 hsvTorgb33 = HSVToRGB( float3(abs( sin( ( objToWorld67.x + objToWorld67.z ) ) ),1.0,1.0) );
				float3 lerpResult36 = lerp( o.Albedo , ( break38.w * hsvTorgb33 ) , break38.w);
				
				float3 temp_cast_0 = (break38.x).xxx;
				
				fixed3 albedo = lerpResult36;
				fixed3 normal = o.Normal;
				half3 emission = half3( 0, 0, 0 );
				fixed3 specular = temp_cast_0;
				fixed metallic = 0;
				half smoothness = break38.y;
				half occlusion = break38.z;
				fixed alpha = o.Alpha;

				o.Albedo = albedo;
				o.Normal = normal;
				o.Emission = emission;
				#if defined(_SPECULAR_SETUP)
					o.Specular = specular;
				#else
					o.Metallic = metallic;
				#endif
				o.Smoothness = smoothness;
				o.Occlusion = occlusion;
				o.Alpha = alpha;
				clip(o.Alpha);

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
				#if defined(_SPECULAR_SETUP)
					c += LightingStandardSpecular( o, worldViewDir, gi );
				#else
					c += LightingStandard( o, worldViewDir, gi );
				#endif
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
			#define _SPECULAR_SETUP 1

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

			#ifdef LIGHTMAP_ON
			float4 unity_LightmapFade;
			#endif
			fixed4 unity_Ambient;
			#define ai_ObjectToWorld unity_ObjectToWorld
			#define ai_WorldToObject unity_WorldToObject
			#define AI_INV_TWO_PI  UNITY_INV_TWO_PI
			#define AI_PI          UNITY_PI
			#define AI_INV_PI      UNITY_INV_PI

			uniform float _AI_Frames;
			uniform float _AI_FramesX;
			uniform float _AI_FramesY;
			uniform float _AI_ImpostorSize;
			uniform float _AI_Parallax;
			uniform float3 _AI_Offset;
			uniform float4 _AI_SizeOffset;
			uniform float _AI_TextureBias;
			uniform sampler2D _Albedo;
			uniform sampler2D _Normals;
			uniform float _AI_DepthSize;
			uniform float _AI_ShadowBias;
			uniform float _AI_ShadowView;
			uniform float _AI_Clip;
			uniform sampler2D _Mask;
			float2 VectortoOctahedron( float3 N )
			{
				N /= dot( 1.0, abs( N ) );
				if( N.z <= 0 )
				{
				N.xy = ( 1 - abs( N.yx ) ) * ( N.xy >= 0 ? 1.0 : -1.0 );
				}
				return N.xy;
			}
			
			float3 OctahedronToVector( float2 Oct )
			{
				float3 N = float3( Oct, 1.0 - dot( 1.0, abs( Oct ) ) );
				if(N.z< 0 )
				{
				N.xy = ( 1 - abs( N.yx) ) * (N.xy >= 0 ? 1.0 : -1.0 );
				}
				return normalize( N);
			}
			
			inline void RayPlaneIntersectionUV( float3 normal, float3 rayPosition, float3 rayDirection, inout float2 uvs, inout float3 localNormal )
			{
				float lDotN = dot( rayDirection, normal ); 
				float p0l0DotN = dot( -rayPosition, normal );
				float t = p0l0DotN / lDotN;
				float3 p = rayDirection * t + rayPosition;
				float3 upVector = float3( 0, 1, 0 );
				float3 tangent = normalize( cross( upVector, normal ) + float3( -0.001, 0, 0 ) );
				float3 bitangent = cross( tangent, normal );
				float frameX = dot( p, tangent );
				float frameZ = dot( p, bitangent );
				uvs = -float2( frameX, frameZ );
				if( t <= 0.0 )
				uvs = 0;
				float3x3 worldToLocal = float3x3( tangent, bitangent, normal );
				localNormal = normalize( mul( worldToLocal, rayDirection ) );
			}
			
			inline void OctaImpostorVertex( inout float4 vertex, inout float3 normal, inout float4 uvsFrame1, inout float4 uvsFrame2, inout float4 uvsFrame3, inout float4 octaFrame, inout float4 viewPos )
			{
				float2 uvOffset = _AI_SizeOffset.zw;
				float parallax = -_AI_Parallax; 
				float UVscale = _AI_ImpostorSize;
				float framesXY = _AI_Frames;
				float prevFrame = framesXY - 1;
				float3 fractions = 1.0 / float3( framesXY, prevFrame, UVscale );
				float fractionsFrame = fractions.x;
				float fractionsPrevFrame = fractions.y;
				float fractionsUVscale = fractions.z;
				float3 worldOrigin = 0;
				float4 perspective = float4( 0, 0, 0, 1 );
				if( UNITY_MATRIX_P[ 3 ][ 3 ] == 1 ) 
				{
				perspective = float4( 0, 0, 5000, 0 );
				worldOrigin = ai_ObjectToWorld._m03_m13_m23;
				}
				float3 worldCameraPos = worldOrigin + mul( UNITY_MATRIX_I_V, perspective ).xyz;
				float3 objectCameraPosition = mul( ai_WorldToObject, float4( worldCameraPos, 1 ) ).xyz - _AI_Offset.xyz; 
				float3 objectCameraDirection = normalize( objectCameraPosition );
				float3 upVector = float3( 0,1,0 );
				float3 objectHorizontalVector = normalize( cross( objectCameraDirection, upVector ) );
				float3 objectVerticalVector = cross( objectHorizontalVector, objectCameraDirection );
				float2 uvExpansion = vertex.xy;
				float3 billboard = objectHorizontalVector * uvExpansion.x + objectVerticalVector * uvExpansion.y;
				float3 localDir = billboard - objectCameraPosition; 
				float2 frameOcta = VectortoOctahedron( objectCameraDirection.xzy ) * 0.5 + 0.5;
				float2 prevOctaFrame = frameOcta * prevFrame;
				float2 baseOctaFrame = floor( prevOctaFrame );
				float2 fractionOctaFrame = ( baseOctaFrame * fractionsFrame );
				float2 octaFrame1 = ( baseOctaFrame * fractionsPrevFrame ) * 2.0 - 1.0;
				float3 octa1WorldY = OctahedronToVector( octaFrame1 ).xzy;
				float3 octa1LocalY;
				float2 uvFrame1;
				RayPlaneIntersectionUV( octa1WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame1, /*inout*/ octa1LocalY );
				float2 uvParallax1 = octa1LocalY.xy * fractionsFrame * parallax;
				uvFrame1 = ( uvFrame1 * fractionsUVscale + 0.5 ) * fractionsFrame + fractionOctaFrame;
				uvsFrame1 = float4( uvParallax1, uvFrame1) - float4( 0, 0, uvOffset );
				float2 fractPrevOctaFrame = frac( prevOctaFrame );
				float2 cornerDifference = lerp( float2( 0,1 ) , float2( 1,0 ) , saturate( ceil( ( fractPrevOctaFrame.x - fractPrevOctaFrame.y ) ) ));
				float2 octaFrame2 = ( ( baseOctaFrame + cornerDifference ) * fractionsPrevFrame ) * 2.0 - 1.0;
				float3 octa2WorldY = OctahedronToVector( octaFrame2 ).xzy;
				float3 octa2LocalY;
				float2 uvFrame2;
				RayPlaneIntersectionUV( octa2WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame2, /*inout*/ octa2LocalY );
				float2 uvParallax2 = octa2LocalY.xy * fractionsFrame * parallax;
				uvFrame2 = ( uvFrame2 * fractionsUVscale + 0.5 ) * fractionsFrame + ( ( cornerDifference * fractionsFrame ) + fractionOctaFrame );
				uvsFrame2 = float4( uvParallax2, uvFrame2) - float4( 0, 0, uvOffset );
				float2 octaFrame3 = ( ( baseOctaFrame + 1 ) * fractionsPrevFrame  ) * 2.0 - 1.0;
				float3 octa3WorldY = OctahedronToVector( octaFrame3 ).xzy;
				float3 octa3LocalY;
				float2 uvFrame3;
				RayPlaneIntersectionUV( octa3WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame3, /*inout*/ octa3LocalY );
				float2 uvParallax3 = octa3LocalY.xy * fractionsFrame * parallax;
				uvFrame3 = ( uvFrame3 * fractionsUVscale + 0.5 ) * fractionsFrame + ( fractionOctaFrame + fractionsFrame );
				uvsFrame3 = float4( uvParallax3, uvFrame3) - float4( 0, 0, uvOffset );
				octaFrame = 0;
				octaFrame.xy = prevOctaFrame;
				vertex.xyz = billboard + _AI_Offset.xyz;
				normal.xyz = objectCameraDirection;
				viewPos = 0;
				viewPos.xyz = UnityObjectToViewPos( vertex.xyz );
			}
			
			inline void OctaImpostorFragment( inout SurfaceOutputStandardSpecular o, out float4 clipPos, out float3 worldPos, float4 uvsFrame1, float4 uvsFrame2, float4 uvsFrame3, float4 octaFrame, float4 interpViewPos, out float4 output0 )
			{
				float depthBias = -1.0;
				float textureBias = _AI_TextureBias;
				float2 fraction = frac( octaFrame.xy );
				float2 invFraction = 1 - fraction;
				float3 weights;
				weights.x = min( invFraction.x, invFraction.y );
				weights.y = abs( fraction.x - fraction.y );
				weights.z = min( fraction.x, fraction.y );
				float4 parallaxSample1 = tex2Dbias( _Normals, float4( uvsFrame1.zw, 0, depthBias) );
				float2 parallax1 = ( ( 0.5 - parallaxSample1.a ) * uvsFrame1.xy ) + uvsFrame1.zw;
				float4 parallaxSample2 = tex2Dbias( _Normals, float4( uvsFrame2.zw, 0, depthBias) );
				float2 parallax2 = ( ( 0.5 - parallaxSample2.a ) * uvsFrame2.xy ) + uvsFrame2.zw;
				float4 parallaxSample3 = tex2Dbias( _Normals, float4( uvsFrame3.zw, 0, depthBias) );
				float2 parallax3 = ( ( 0.5 - parallaxSample3.a ) * uvsFrame3.xy ) + uvsFrame3.zw;
				float4 albedo1 = tex2Dbias( _Albedo, float4( parallax1, 0, textureBias) );
				float4 albedo2 = tex2Dbias( _Albedo, float4( parallax2, 0, textureBias) );
				float4 albedo3 = tex2Dbias( _Albedo, float4( parallax3, 0, textureBias) );
				float4 blendedAlbedo = albedo1 * weights.x + albedo2 * weights.y + albedo3 * weights.z;
				o.Alpha = ( blendedAlbedo.a - _AI_Clip );
				clip( o.Alpha );
				o.Albedo = blendedAlbedo.rgb;
				float4 normals1 = tex2Dbias( _Normals, float4( parallax1, 0, textureBias) );
				float4 normals2 = tex2Dbias( _Normals, float4( parallax2, 0, textureBias) );
				float4 normals3 = tex2Dbias( _Normals, float4( parallax3, 0, textureBias) );
				float4 blendedNormal = normals1 * weights.x  + normals2 * weights.y + normals3 * weights.z;
				float4 output0a = tex2Dbias( _Mask, float4( parallax1, 0, textureBias) ); 
				float4 output0b = tex2Dbias( _Mask, float4( parallax2, 0, textureBias) ); 
				float4 output0c = tex2Dbias( _Mask, float4( parallax3, 0, textureBias) ); 
				output0 = output0a * weights.x  + output0b * weights.y + output0c * weights.z; 
				float3 localNormal = blendedNormal.rgb * 2.0 - 1.0;
				float3 worldNormal = normalize( mul( (float3x3)ai_ObjectToWorld, localNormal ) );
				o.Normal = worldNormal;
				float3 viewPos = interpViewPos.xyz;
				float depthOffset = ( ( parallaxSample1.a * weights.x + parallaxSample2.a * weights.y + parallaxSample3.a * weights.z ) - 0.5 /** 2.0 - 1.0*/ ) /** 0.5*/ * _AI_DepthSize * length( ai_ObjectToWorld[ 2 ].xyz );
				#if defined(SHADOWS_DEPTH)
				if( unity_LightShadowBias.y == 1.0 ) 
				{
				viewPos.z += depthOffset * _AI_ShadowView;
				viewPos.z += -_AI_ShadowBias;
				}
				else 
				{
				viewPos.z += depthOffset;
				}
				#else 
				viewPos.z += depthOffset;
				#endif
				worldPos = mul( UNITY_MATRIX_I_V, float4( viewPos.xyz, 1 ) ).xyz;
				clipPos = mul( UNITY_MATRIX_P, float4( viewPos, 1 ) );
				#if defined(SHADOWS_DEPTH)
				clipPos = UnityApplyLinearShadowBias( clipPos );
				#endif
				clipPos.xyz /= clipPos.w;
				if( UNITY_NEAR_CLIP_VALUE < 0 )
				clipPos = clipPos * 0.5 + 0.5;
			}
			
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			

			/*struct appdata_full {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				fixed4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID*/
			
			/*};*/

			struct v2f_surf {
				UNITY_POSITION(pos);
				#ifndef DIRLIGHTMAP_OFF
					half3 viewDir : TEXCOORD1;
				#endif
				float4 lmap : TEXCOORD2;
				#ifndef LIGHTMAP_ON
					#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
						half3 sh : TEXCOORD3;
					#endif
				#else
					#ifdef DIRLIGHTMAP_OFF
						float4 lmapFadePos : TEXCOORD4;
					#endif
				#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 UVsFrame117 : TEXCOORD5;
				float4 UVsFrame217 : TEXCOORD6;
				float4 UVsFrame317 : TEXCOORD7;
				float4 octaframe17 : TEXCOORD8;
				float4 viewPos17 : TEXCOORD9;
			};

			v2f_surf vert_surf (appdata_full v ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				OctaImpostorVertex( v.vertex, v.normal, o.UVsFrame117, o.UVsFrame217, o.UVsFrame317, o.octaframe17, o.viewPos17 );
				

				v.vertex.xyz +=  float3(0,0,0) ;
				o.pos = UnityObjectToClipPos(v.vertex);

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 viewDirForLight = UnityWorldSpaceViewDir(worldPos);
				#ifndef DIRLIGHTMAP_OFF
					o.viewDir = viewDirForLight;
				#endif
				#ifdef DYNAMICLIGHTMAP_ON
					o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#else
					o.lmap.zw = 0;
				#endif
				#ifdef LIGHTMAP_ON
					o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					#ifdef DIRLIGHTMAP_OFF
						o.lmapFadePos.xyz = (mul(unity_ObjectToWorld, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;
						o.lmapFadePos.w = (-UnityObjectToViewPos(v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);
					#endif
				#else
					o.lmap.xy = 0;
					#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
						o.sh = 0;
						o.sh = ShadeSHPerVertex (worldNormal, o.sh);
					#endif
				#endif
				return o;
			}

			void frag_surf (v2f_surf IN , out half4 outGBuffer0 : SV_Target0, out half4 outGBuffer1 : SV_Target1, out half4 outGBuffer2 : SV_Target2, out half4 outEmission : SV_Target3
			#if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
				, out half4 outShadowMask : SV_Target4
			#endif
			, out float outDepth : SV_Depth
			) {
				UNITY_SETUP_INSTANCE_ID(IN);
				#if defined(_SPECULAR_SETUP)
					SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
				#else
					SurfaceOutputStandard o = (SurfaceOutputStandard)0;
				#endif

				float4 clipPos = 0;
				float3 worldPos = 0;
				float4 output0 = 0;
				OctaImpostorFragment( o, clipPos, worldPos, IN.UVsFrame117, IN.UVsFrame217, IN.UVsFrame317, IN.octaframe17, IN.viewPos17, output0 );
				float4 break38 = output0;
				float3 objToWorld67 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
				float3 hsvTorgb33 = HSVToRGB( float3(abs( sin( ( objToWorld67.x + objToWorld67.z ) ) ),1.0,1.0) );
				float3 lerpResult36 = lerp( o.Albedo , ( break38.w * hsvTorgb33 ) , break38.w);
				
				float3 temp_cast_0 = (break38.x).xxx;
				
				fixed3 albedo = lerpResult36;
				fixed3 normal = o.Normal;
				half3 emission = half3( 0, 0, 0 );
				fixed3 specular = temp_cast_0;
				fixed metallic = 0;
				half smoothness = break38.y;
				half occlusion = break38.z;
				fixed alpha = o.Alpha;
				float4 bakedGI = float4( 0, 0, 0, 0 );
				
				o.Albedo = albedo;
				o.Normal = normal;
				o.Emission = emission;
				#if defined(_SPECULAR_SETUP)
					o.Specular = specular;
				#else
					o.Metallic = metallic;
				#endif
				o.Smoothness = smoothness;
				o.Occlusion = occlusion;
				o.Alpha = alpha;
				clip( o.Alpha );

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
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
					giInput.lightmapUV = IN.lmap;
				#else
					giInput.lightmapUV = 0.0;
				#endif
				#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
					giInput.ambient = IN.sh;
				#else
					giInput.ambient.rgb = 0.0;
				#endif
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

				#if defined(_SPECULAR_SETUP)
					LightingStandardSpecular_GI( o, giInput, gi );
					#if defined(CUSTOM_BAKED_GI)
						gi.indirect.diffuse = DecodeLightmapRGBM( bakedGI, 1 ) * EMISSIVE_RGBM_SCALE;
					#endif
					outEmission = LightingStandardSpecular_Deferred( o, worldViewDir, gi, outGBuffer0, outGBuffer1, outGBuffer2 );
				#else
					LightingStandard_GI( o, giInput, gi );
					#if defined(CUSTOM_BAKED_GI)
						gi.indirect.diffuse = DecodeLightmapRGBM( bakedGI, 1 ) * EMISSIVE_RGBM_SCALE;
					#endif
					outEmission = LightingStandard_Deferred( o, worldViewDir, gi, outGBuffer0, outGBuffer1, outGBuffer2 );
				#endif

				#if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
					outShadowMask = UnityGetRawBakedOcclusions (IN.lmap.xy, float3(0, 0, 0));
				#endif
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
			#define _SPECULAR_SETUP 1

			#pragma vertex vert_surf
			#pragma fragment frag_surf
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#pragma skip_variants INSTANCING_ON
			#pragma shader_feature EDITOR_VISUALIZATION
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
			#define ai_ObjectToWorld unity_ObjectToWorld
			#define ai_WorldToObject unity_WorldToObject
			#define AI_INV_TWO_PI  UNITY_INV_TWO_PI
			#define AI_PI          UNITY_PI
			#define AI_INV_PI      UNITY_INV_PI

			uniform float _AI_Frames;
			uniform float _AI_FramesX;
			uniform float _AI_FramesY;
			uniform float _AI_ImpostorSize;
			uniform float _AI_Parallax;
			uniform float3 _AI_Offset;
			uniform float4 _AI_SizeOffset;
			uniform float _AI_TextureBias;
			uniform sampler2D _Albedo;
			uniform sampler2D _Normals;
			uniform float _AI_DepthSize;
			uniform float _AI_ShadowBias;
			uniform float _AI_ShadowView;
			uniform float _AI_Clip;
			uniform sampler2D _Mask;
			float2 VectortoOctahedron( float3 N )
			{
				N /= dot( 1.0, abs( N ) );
				if( N.z <= 0 )
				{
				N.xy = ( 1 - abs( N.yx ) ) * ( N.xy >= 0 ? 1.0 : -1.0 );
				}
				return N.xy;
			}
			
			float3 OctahedronToVector( float2 Oct )
			{
				float3 N = float3( Oct, 1.0 - dot( 1.0, abs( Oct ) ) );
				if(N.z< 0 )
				{
				N.xy = ( 1 - abs( N.yx) ) * (N.xy >= 0 ? 1.0 : -1.0 );
				}
				return normalize( N);
			}
			
			inline void RayPlaneIntersectionUV( float3 normal, float3 rayPosition, float3 rayDirection, inout float2 uvs, inout float3 localNormal )
			{
				float lDotN = dot( rayDirection, normal ); 
				float p0l0DotN = dot( -rayPosition, normal );
				float t = p0l0DotN / lDotN;
				float3 p = rayDirection * t + rayPosition;
				float3 upVector = float3( 0, 1, 0 );
				float3 tangent = normalize( cross( upVector, normal ) + float3( -0.001, 0, 0 ) );
				float3 bitangent = cross( tangent, normal );
				float frameX = dot( p, tangent );
				float frameZ = dot( p, bitangent );
				uvs = -float2( frameX, frameZ );
				if( t <= 0.0 )
				uvs = 0;
				float3x3 worldToLocal = float3x3( tangent, bitangent, normal );
				localNormal = normalize( mul( worldToLocal, rayDirection ) );
			}
			
			inline void OctaImpostorVertex( inout float4 vertex, inout float3 normal, inout float4 uvsFrame1, inout float4 uvsFrame2, inout float4 uvsFrame3, inout float4 octaFrame, inout float4 viewPos )
			{
				float2 uvOffset = _AI_SizeOffset.zw;
				float parallax = -_AI_Parallax; 
				float UVscale = _AI_ImpostorSize;
				float framesXY = _AI_Frames;
				float prevFrame = framesXY - 1;
				float3 fractions = 1.0 / float3( framesXY, prevFrame, UVscale );
				float fractionsFrame = fractions.x;
				float fractionsPrevFrame = fractions.y;
				float fractionsUVscale = fractions.z;
				float3 worldOrigin = 0;
				float4 perspective = float4( 0, 0, 0, 1 );
				if( UNITY_MATRIX_P[ 3 ][ 3 ] == 1 ) 
				{
				perspective = float4( 0, 0, 5000, 0 );
				worldOrigin = ai_ObjectToWorld._m03_m13_m23;
				}
				float3 worldCameraPos = worldOrigin + mul( UNITY_MATRIX_I_V, perspective ).xyz;
				float3 objectCameraPosition = mul( ai_WorldToObject, float4( worldCameraPos, 1 ) ).xyz - _AI_Offset.xyz; 
				float3 objectCameraDirection = normalize( objectCameraPosition );
				float3 upVector = float3( 0,1,0 );
				float3 objectHorizontalVector = normalize( cross( objectCameraDirection, upVector ) );
				float3 objectVerticalVector = cross( objectHorizontalVector, objectCameraDirection );
				float2 uvExpansion = vertex.xy;
				float3 billboard = objectHorizontalVector * uvExpansion.x + objectVerticalVector * uvExpansion.y;
				float3 localDir = billboard - objectCameraPosition; 
				float2 frameOcta = VectortoOctahedron( objectCameraDirection.xzy ) * 0.5 + 0.5;
				float2 prevOctaFrame = frameOcta * prevFrame;
				float2 baseOctaFrame = floor( prevOctaFrame );
				float2 fractionOctaFrame = ( baseOctaFrame * fractionsFrame );
				float2 octaFrame1 = ( baseOctaFrame * fractionsPrevFrame ) * 2.0 - 1.0;
				float3 octa1WorldY = OctahedronToVector( octaFrame1 ).xzy;
				float3 octa1LocalY;
				float2 uvFrame1;
				RayPlaneIntersectionUV( octa1WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame1, /*inout*/ octa1LocalY );
				float2 uvParallax1 = octa1LocalY.xy * fractionsFrame * parallax;
				uvFrame1 = ( uvFrame1 * fractionsUVscale + 0.5 ) * fractionsFrame + fractionOctaFrame;
				uvsFrame1 = float4( uvParallax1, uvFrame1) - float4( 0, 0, uvOffset );
				float2 fractPrevOctaFrame = frac( prevOctaFrame );
				float2 cornerDifference = lerp( float2( 0,1 ) , float2( 1,0 ) , saturate( ceil( ( fractPrevOctaFrame.x - fractPrevOctaFrame.y ) ) ));
				float2 octaFrame2 = ( ( baseOctaFrame + cornerDifference ) * fractionsPrevFrame ) * 2.0 - 1.0;
				float3 octa2WorldY = OctahedronToVector( octaFrame2 ).xzy;
				float3 octa2LocalY;
				float2 uvFrame2;
				RayPlaneIntersectionUV( octa2WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame2, /*inout*/ octa2LocalY );
				float2 uvParallax2 = octa2LocalY.xy * fractionsFrame * parallax;
				uvFrame2 = ( uvFrame2 * fractionsUVscale + 0.5 ) * fractionsFrame + ( ( cornerDifference * fractionsFrame ) + fractionOctaFrame );
				uvsFrame2 = float4( uvParallax2, uvFrame2) - float4( 0, 0, uvOffset );
				float2 octaFrame3 = ( ( baseOctaFrame + 1 ) * fractionsPrevFrame  ) * 2.0 - 1.0;
				float3 octa3WorldY = OctahedronToVector( octaFrame3 ).xzy;
				float3 octa3LocalY;
				float2 uvFrame3;
				RayPlaneIntersectionUV( octa3WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame3, /*inout*/ octa3LocalY );
				float2 uvParallax3 = octa3LocalY.xy * fractionsFrame * parallax;
				uvFrame3 = ( uvFrame3 * fractionsUVscale + 0.5 ) * fractionsFrame + ( fractionOctaFrame + fractionsFrame );
				uvsFrame3 = float4( uvParallax3, uvFrame3) - float4( 0, 0, uvOffset );
				octaFrame = 0;
				octaFrame.xy = prevOctaFrame;
				vertex.xyz = billboard + _AI_Offset.xyz;
				normal.xyz = objectCameraDirection;
				viewPos = 0;
				viewPos.xyz = UnityObjectToViewPos( vertex.xyz );
			}
			
			inline void OctaImpostorFragment( inout SurfaceOutputStandardSpecular o, out float4 clipPos, out float3 worldPos, float4 uvsFrame1, float4 uvsFrame2, float4 uvsFrame3, float4 octaFrame, float4 interpViewPos, out float4 output0 )
			{
				float depthBias = -1.0;
				float textureBias = _AI_TextureBias;
				float2 fraction = frac( octaFrame.xy );
				float2 invFraction = 1 - fraction;
				float3 weights;
				weights.x = min( invFraction.x, invFraction.y );
				weights.y = abs( fraction.x - fraction.y );
				weights.z = min( fraction.x, fraction.y );
				float4 parallaxSample1 = tex2Dbias( _Normals, float4( uvsFrame1.zw, 0, depthBias) );
				float2 parallax1 = ( ( 0.5 - parallaxSample1.a ) * uvsFrame1.xy ) + uvsFrame1.zw;
				float4 parallaxSample2 = tex2Dbias( _Normals, float4( uvsFrame2.zw, 0, depthBias) );
				float2 parallax2 = ( ( 0.5 - parallaxSample2.a ) * uvsFrame2.xy ) + uvsFrame2.zw;
				float4 parallaxSample3 = tex2Dbias( _Normals, float4( uvsFrame3.zw, 0, depthBias) );
				float2 parallax3 = ( ( 0.5 - parallaxSample3.a ) * uvsFrame3.xy ) + uvsFrame3.zw;
				float4 albedo1 = tex2Dbias( _Albedo, float4( parallax1, 0, textureBias) );
				float4 albedo2 = tex2Dbias( _Albedo, float4( parallax2, 0, textureBias) );
				float4 albedo3 = tex2Dbias( _Albedo, float4( parallax3, 0, textureBias) );
				float4 blendedAlbedo = albedo1 * weights.x + albedo2 * weights.y + albedo3 * weights.z;
				o.Alpha = ( blendedAlbedo.a - _AI_Clip );
				clip( o.Alpha );
				o.Albedo = blendedAlbedo.rgb;
				float4 normals1 = tex2Dbias( _Normals, float4( parallax1, 0, textureBias) );
				float4 normals2 = tex2Dbias( _Normals, float4( parallax2, 0, textureBias) );
				float4 normals3 = tex2Dbias( _Normals, float4( parallax3, 0, textureBias) );
				float4 blendedNormal = normals1 * weights.x  + normals2 * weights.y + normals3 * weights.z;
				float4 output0a = tex2Dbias( _Mask, float4( parallax1, 0, textureBias) ); 
				float4 output0b = tex2Dbias( _Mask, float4( parallax2, 0, textureBias) ); 
				float4 output0c = tex2Dbias( _Mask, float4( parallax3, 0, textureBias) ); 
				output0 = output0a * weights.x  + output0b * weights.y + output0c * weights.z; 
				float3 localNormal = blendedNormal.rgb * 2.0 - 1.0;
				float3 worldNormal = normalize( mul( (float3x3)ai_ObjectToWorld, localNormal ) );
				o.Normal = worldNormal;
				float3 viewPos = interpViewPos.xyz;
				float depthOffset = ( ( parallaxSample1.a * weights.x + parallaxSample2.a * weights.y + parallaxSample3.a * weights.z ) - 0.5 /** 2.0 - 1.0*/ ) /** 0.5*/ * _AI_DepthSize * length( ai_ObjectToWorld[ 2 ].xyz );
				#if defined(SHADOWS_DEPTH)
				if( unity_LightShadowBias.y == 1.0 ) 
				{
				viewPos.z += depthOffset * _AI_ShadowView;
				viewPos.z += -_AI_ShadowBias;
				}
				else 
				{
				viewPos.z += depthOffset;
				}
				#else 
				viewPos.z += depthOffset;
				#endif
				worldPos = mul( UNITY_MATRIX_I_V, float4( viewPos.xyz, 1 ) ).xyz;
				clipPos = mul( UNITY_MATRIX_P, float4( viewPos, 1 ) );
				#if defined(SHADOWS_DEPTH)
				clipPos = UnityApplyLinearShadowBias( clipPos );
				#endif
				clipPos.xyz /= clipPos.w;
				if( UNITY_NEAR_CLIP_VALUE < 0 )
				clipPos = clipPos * 0.5 + 0.5;
			}
			
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			

			/*struct appdata_full {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				fixed4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID*/
			
			/*};*/

			struct v2f_surf {
				UNITY_POSITION(pos);
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 UVsFrame117 : TEXCOORD5;
				float4 UVsFrame217 : TEXCOORD6;
				float4 UVsFrame317 : TEXCOORD7;
				float4 octaframe17 : TEXCOORD8;
				float4 viewPos17 : TEXCOORD9;
			};

			v2f_surf vert_surf (appdata_full v ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				OctaImpostorVertex( v.vertex, v.normal, o.UVsFrame117, o.UVsFrame217, o.UVsFrame317, o.octaframe17, o.viewPos17 );
				

				v.vertex.xyz +=  float3(0,0,0) ;
				o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST);

				return o;
			}

			fixed4 frag_surf (v2f_surf IN, out float outDepth : SV_Depth  ) : SV_Target {
				UNITY_SETUP_INSTANCE_ID(IN);
				#if defined(_SPECULAR_SETUP)
					SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
				#else
					SurfaceOutputStandard o = (SurfaceOutputStandard)0;
				#endif

				float4 clipPos = 0;
				float3 worldPos = 0;
				float4 output0 = 0;
				OctaImpostorFragment( o, clipPos, worldPos, IN.UVsFrame117, IN.UVsFrame217, IN.UVsFrame317, IN.octaframe17, IN.viewPos17, output0 );
				float4 break38 = output0;
				float3 objToWorld67 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
				float3 hsvTorgb33 = HSVToRGB( float3(abs( sin( ( objToWorld67.x + objToWorld67.z ) ) ),1.0,1.0) );
				float3 lerpResult36 = lerp( o.Albedo , ( break38.w * hsvTorgb33 ) , break38.w);
				
				float3 temp_cast_0 = (break38.x).xxx;
				
				fixed3 albedo = lerpResult36;
				fixed3 normal = o.Normal;
				half3 emission = half3( 0, 0, 0 );
				fixed3 specular = temp_cast_0;
				fixed metallic = 0;
				half smoothness = break38.y;
				half occlusion = break38.z;
				fixed alpha = o.Alpha;

				o.Albedo = albedo;
				o.Normal = normal;
				o.Emission = emission;
				#if defined(_SPECULAR_SETUP)
					o.Specular = specular;
				#else
					o.Metallic = metallic;
				#endif
				o.Smoothness = smoothness;
				o.Occlusion = occlusion;
				o.Alpha = alpha;
				clip(o.Alpha);

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
			#define _SPECULAR_SETUP 1

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
			#define ai_ObjectToWorld unity_ObjectToWorld
			#define ai_WorldToObject unity_WorldToObject
			#define AI_INV_TWO_PI  UNITY_INV_TWO_PI
			#define AI_PI          UNITY_PI
			#define AI_INV_PI      UNITY_INV_PI

			uniform float _AI_Frames;
			uniform float _AI_FramesX;
			uniform float _AI_FramesY;
			uniform float _AI_ImpostorSize;
			uniform float _AI_Parallax;
			uniform float3 _AI_Offset;
			uniform float4 _AI_SizeOffset;
			uniform float _AI_TextureBias;
			uniform sampler2D _Albedo;
			uniform sampler2D _Normals;
			uniform float _AI_DepthSize;
			uniform float _AI_ShadowBias;
			uniform float _AI_ShadowView;
			uniform float _AI_Clip;
			uniform sampler2D _Mask;
			float2 VectortoOctahedron( float3 N )
			{
				N /= dot( 1.0, abs( N ) );
				if( N.z <= 0 )
				{
				N.xy = ( 1 - abs( N.yx ) ) * ( N.xy >= 0 ? 1.0 : -1.0 );
				}
				return N.xy;
			}
			
			float3 OctahedronToVector( float2 Oct )
			{
				float3 N = float3( Oct, 1.0 - dot( 1.0, abs( Oct ) ) );
				if(N.z< 0 )
				{
				N.xy = ( 1 - abs( N.yx) ) * (N.xy >= 0 ? 1.0 : -1.0 );
				}
				return normalize( N);
			}
			
			inline void RayPlaneIntersectionUV( float3 normal, float3 rayPosition, float3 rayDirection, inout float2 uvs, inout float3 localNormal )
			{
				float lDotN = dot( rayDirection, normal ); 
				float p0l0DotN = dot( -rayPosition, normal );
				float t = p0l0DotN / lDotN;
				float3 p = rayDirection * t + rayPosition;
				float3 upVector = float3( 0, 1, 0 );
				float3 tangent = normalize( cross( upVector, normal ) + float3( -0.001, 0, 0 ) );
				float3 bitangent = cross( tangent, normal );
				float frameX = dot( p, tangent );
				float frameZ = dot( p, bitangent );
				uvs = -float2( frameX, frameZ );
				if( t <= 0.0 )
				uvs = 0;
				float3x3 worldToLocal = float3x3( tangent, bitangent, normal );
				localNormal = normalize( mul( worldToLocal, rayDirection ) );
			}
			
			inline void OctaImpostorVertex( inout float4 vertex, inout float3 normal, inout float4 uvsFrame1, inout float4 uvsFrame2, inout float4 uvsFrame3, inout float4 octaFrame, inout float4 viewPos )
			{
				float2 uvOffset = _AI_SizeOffset.zw;
				float parallax = -_AI_Parallax; 
				float UVscale = _AI_ImpostorSize;
				float framesXY = _AI_Frames;
				float prevFrame = framesXY - 1;
				float3 fractions = 1.0 / float3( framesXY, prevFrame, UVscale );
				float fractionsFrame = fractions.x;
				float fractionsPrevFrame = fractions.y;
				float fractionsUVscale = fractions.z;
				float3 worldOrigin = 0;
				float4 perspective = float4( 0, 0, 0, 1 );
				if( UNITY_MATRIX_P[ 3 ][ 3 ] == 1 ) 
				{
				perspective = float4( 0, 0, 5000, 0 );
				worldOrigin = ai_ObjectToWorld._m03_m13_m23;
				}
				float3 worldCameraPos = worldOrigin + mul( UNITY_MATRIX_I_V, perspective ).xyz;
				float3 objectCameraPosition = mul( ai_WorldToObject, float4( worldCameraPos, 1 ) ).xyz - _AI_Offset.xyz; 
				float3 objectCameraDirection = normalize( objectCameraPosition );
				float3 upVector = float3( 0,1,0 );
				float3 objectHorizontalVector = normalize( cross( objectCameraDirection, upVector ) );
				float3 objectVerticalVector = cross( objectHorizontalVector, objectCameraDirection );
				float2 uvExpansion = vertex.xy;
				float3 billboard = objectHorizontalVector * uvExpansion.x + objectVerticalVector * uvExpansion.y;
				float3 localDir = billboard - objectCameraPosition; 
				float2 frameOcta = VectortoOctahedron( objectCameraDirection.xzy ) * 0.5 + 0.5;
				float2 prevOctaFrame = frameOcta * prevFrame;
				float2 baseOctaFrame = floor( prevOctaFrame );
				float2 fractionOctaFrame = ( baseOctaFrame * fractionsFrame );
				float2 octaFrame1 = ( baseOctaFrame * fractionsPrevFrame ) * 2.0 - 1.0;
				float3 octa1WorldY = OctahedronToVector( octaFrame1 ).xzy;
				float3 octa1LocalY;
				float2 uvFrame1;
				RayPlaneIntersectionUV( octa1WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame1, /*inout*/ octa1LocalY );
				float2 uvParallax1 = octa1LocalY.xy * fractionsFrame * parallax;
				uvFrame1 = ( uvFrame1 * fractionsUVscale + 0.5 ) * fractionsFrame + fractionOctaFrame;
				uvsFrame1 = float4( uvParallax1, uvFrame1) - float4( 0, 0, uvOffset );
				float2 fractPrevOctaFrame = frac( prevOctaFrame );
				float2 cornerDifference = lerp( float2( 0,1 ) , float2( 1,0 ) , saturate( ceil( ( fractPrevOctaFrame.x - fractPrevOctaFrame.y ) ) ));
				float2 octaFrame2 = ( ( baseOctaFrame + cornerDifference ) * fractionsPrevFrame ) * 2.0 - 1.0;
				float3 octa2WorldY = OctahedronToVector( octaFrame2 ).xzy;
				float3 octa2LocalY;
				float2 uvFrame2;
				RayPlaneIntersectionUV( octa2WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame2, /*inout*/ octa2LocalY );
				float2 uvParallax2 = octa2LocalY.xy * fractionsFrame * parallax;
				uvFrame2 = ( uvFrame2 * fractionsUVscale + 0.5 ) * fractionsFrame + ( ( cornerDifference * fractionsFrame ) + fractionOctaFrame );
				uvsFrame2 = float4( uvParallax2, uvFrame2) - float4( 0, 0, uvOffset );
				float2 octaFrame3 = ( ( baseOctaFrame + 1 ) * fractionsPrevFrame  ) * 2.0 - 1.0;
				float3 octa3WorldY = OctahedronToVector( octaFrame3 ).xzy;
				float3 octa3LocalY;
				float2 uvFrame3;
				RayPlaneIntersectionUV( octa3WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame3, /*inout*/ octa3LocalY );
				float2 uvParallax3 = octa3LocalY.xy * fractionsFrame * parallax;
				uvFrame3 = ( uvFrame3 * fractionsUVscale + 0.5 ) * fractionsFrame + ( fractionOctaFrame + fractionsFrame );
				uvsFrame3 = float4( uvParallax3, uvFrame3) - float4( 0, 0, uvOffset );
				octaFrame = 0;
				octaFrame.xy = prevOctaFrame;
				vertex.xyz = billboard + _AI_Offset.xyz;
				normal.xyz = objectCameraDirection;
				viewPos = 0;
				viewPos.xyz = UnityObjectToViewPos( vertex.xyz );
			}
			
			inline void OctaImpostorFragment( inout SurfaceOutputStandardSpecular o, out float4 clipPos, out float3 worldPos, float4 uvsFrame1, float4 uvsFrame2, float4 uvsFrame3, float4 octaFrame, float4 interpViewPos, out float4 output0 )
			{
				float depthBias = -1.0;
				float textureBias = _AI_TextureBias;
				float2 fraction = frac( octaFrame.xy );
				float2 invFraction = 1 - fraction;
				float3 weights;
				weights.x = min( invFraction.x, invFraction.y );
				weights.y = abs( fraction.x - fraction.y );
				weights.z = min( fraction.x, fraction.y );
				float4 parallaxSample1 = tex2Dbias( _Normals, float4( uvsFrame1.zw, 0, depthBias) );
				float2 parallax1 = ( ( 0.5 - parallaxSample1.a ) * uvsFrame1.xy ) + uvsFrame1.zw;
				float4 parallaxSample2 = tex2Dbias( _Normals, float4( uvsFrame2.zw, 0, depthBias) );
				float2 parallax2 = ( ( 0.5 - parallaxSample2.a ) * uvsFrame2.xy ) + uvsFrame2.zw;
				float4 parallaxSample3 = tex2Dbias( _Normals, float4( uvsFrame3.zw, 0, depthBias) );
				float2 parallax3 = ( ( 0.5 - parallaxSample3.a ) * uvsFrame3.xy ) + uvsFrame3.zw;
				float4 albedo1 = tex2Dbias( _Albedo, float4( parallax1, 0, textureBias) );
				float4 albedo2 = tex2Dbias( _Albedo, float4( parallax2, 0, textureBias) );
				float4 albedo3 = tex2Dbias( _Albedo, float4( parallax3, 0, textureBias) );
				float4 blendedAlbedo = albedo1 * weights.x + albedo2 * weights.y + albedo3 * weights.z;
				o.Alpha = ( blendedAlbedo.a - _AI_Clip );
				clip( o.Alpha );
				o.Albedo = blendedAlbedo.rgb;
				float4 normals1 = tex2Dbias( _Normals, float4( parallax1, 0, textureBias) );
				float4 normals2 = tex2Dbias( _Normals, float4( parallax2, 0, textureBias) );
				float4 normals3 = tex2Dbias( _Normals, float4( parallax3, 0, textureBias) );
				float4 blendedNormal = normals1 * weights.x  + normals2 * weights.y + normals3 * weights.z;
				float4 output0a = tex2Dbias( _Mask, float4( parallax1, 0, textureBias) ); 
				float4 output0b = tex2Dbias( _Mask, float4( parallax2, 0, textureBias) ); 
				float4 output0c = tex2Dbias( _Mask, float4( parallax3, 0, textureBias) ); 
				output0 = output0a * weights.x  + output0b * weights.y + output0c * weights.z; 
				float3 localNormal = blendedNormal.rgb * 2.0 - 1.0;
				float3 worldNormal = normalize( mul( (float3x3)ai_ObjectToWorld, localNormal ) );
				o.Normal = worldNormal;
				float3 viewPos = interpViewPos.xyz;
				float depthOffset = ( ( parallaxSample1.a * weights.x + parallaxSample2.a * weights.y + parallaxSample3.a * weights.z ) - 0.5 /** 2.0 - 1.0*/ ) /** 0.5*/ * _AI_DepthSize * length( ai_ObjectToWorld[ 2 ].xyz );
				#if defined(SHADOWS_DEPTH)
				if( unity_LightShadowBias.y == 1.0 ) 
				{
				viewPos.z += depthOffset * _AI_ShadowView;
				viewPos.z += -_AI_ShadowBias;
				}
				else 
				{
				viewPos.z += depthOffset;
				}
				#else 
				viewPos.z += depthOffset;
				#endif
				worldPos = mul( UNITY_MATRIX_I_V, float4( viewPos.xyz, 1 ) ).xyz;
				clipPos = mul( UNITY_MATRIX_P, float4( viewPos, 1 ) );
				#if defined(SHADOWS_DEPTH)
				clipPos = UnityApplyLinearShadowBias( clipPos );
				#endif
				clipPos.xyz /= clipPos.w;
				if( UNITY_NEAR_CLIP_VALUE < 0 )
				clipPos = clipPos * 0.5 + 0.5;
			}
			
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			

			/*struct appdata_full {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				fixed4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID*/
			
			/*};*/

			struct v2f_surf {
				V2F_SHADOW_CASTER;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 UVsFrame117 : TEXCOORD5;
				float4 UVsFrame217 : TEXCOORD6;
				float4 UVsFrame317 : TEXCOORD7;
				float4 octaframe17 : TEXCOORD8;
				float4 viewPos17 : TEXCOORD9;
			};

			v2f_surf vert_surf (appdata_full v ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				OctaImpostorVertex( v.vertex, v.normal, o.UVsFrame117, o.UVsFrame217, o.UVsFrame317, o.octaframe17, o.viewPos17 );
				

				v.vertex.xyz +=  float3(0,0,0) ;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
			}

			fixed4 frag_surf (v2f_surf IN, out float outDepth : SV_Depth ) : SV_Target {
				UNITY_SETUP_INSTANCE_ID(IN);
				#if defined(_SPECULAR_SETUP)
					SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
				#else
					SurfaceOutputStandard o = (SurfaceOutputStandard)0;
				#endif

				float4 clipPos = 0;
				float3 worldPos = 0;
				float4 output0 = 0;
				OctaImpostorFragment( o, clipPos, worldPos, IN.UVsFrame117, IN.UVsFrame217, IN.UVsFrame317, IN.octaframe17, IN.viewPos17, output0 );
				float4 break38 = output0;
				float3 objToWorld67 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
				float3 hsvTorgb33 = HSVToRGB( float3(abs( sin( ( objToWorld67.x + objToWorld67.z ) ) ),1.0,1.0) );
				float3 lerpResult36 = lerp( o.Albedo , ( break38.w * hsvTorgb33 ) , break38.w);
				
				float3 temp_cast_0 = (break38.x).xxx;
				
				fixed3 albedo = lerpResult36;
				fixed3 normal = o.Normal;
				half3 emission = half3( 0, 0, 0 );
				fixed3 specular = temp_cast_0;
				fixed metallic = 0;
				half smoothness = break38.y;
				half occlusion = break38.z;
				fixed alpha = o.Alpha;

				o.Albedo = albedo;
				o.Normal = normal;
				o.Emission = emission;
				#if defined(_SPECULAR_SETUP)
					o.Specular = specular;
				#else
					o.Metallic = metallic;
				#endif
				o.Smoothness = smoothness;
				o.Occlusion = occlusion;
				o.Alpha = alpha;
				clip(o.Alpha);

				IN.pos.zw = clipPos.zw;
				outDepth = IN.pos.z;

				UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
				SHADOW_CASTER_FRAGMENT(IN)
			}
			ENDCG
		}
		
	}
	
	
	
}
/*ASEBEGIN
Version=17501
-1729;-397;1530;800;2723.372;633.1443;2.347889;False;False
Node;AmplifyShaderEditor.TransformPositionNode;67;-1424,448;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-1184,480;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;25;-1360,0;Float;True;Property;_Mask;Mask;4;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SinOpNode;28;-1040,480;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-944,560;Float;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AmplifyImpostorNode;17;-1120,0;Inherit;False;9700;Octahedron;False;False;False;12;11;10;13;17;15;16;14;0;1;2;3;7;8;9;5;6;1;Specular;8;0;SAMPLER2D;sampler017;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;SAMPLER2D;;False;4;SAMPLER2D;;False;5;SAMPLER2D;;False;6;SAMPLER2D;;False;7;SAMPLER2D;;False;17;FLOAT4;8;FLOAT4;9;FLOAT4;10;FLOAT4;11;FLOAT4;12;FLOAT4;13;FLOAT4;14;FLOAT4;15;FLOAT3;0;FLOAT3;1;FLOAT3;2;FLOAT3;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT3;7;FLOAT3;16
Node;AmplifyShaderEditor.AbsOpNode;31;-896,480;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-944,640;Float;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;33;-720,464;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;38;-816,240;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-448,432;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;36;-240,336;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;58;5,0;Float;False;True;-1;2;;0;10;Impostors/Custom/Colored Barrels;30a8e337ed84177439ca24b6a5c97cd1;True;ForwardBase;0;0;ForwardBase;10;False;False;True;False;True;0;False;-1;False;False;False;False;False;True;4;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=True;ImpostorType=Octahedron;True;2;0;False;False;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Material Type,InvertActionOnDeselection;1;0;5;True;True;True;True;True;False;;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;60;5,278;Float;False;False;-1;2;ASEMaterialInspector;0;10;Hidden/Amplify Impostors;30a8e337ed84177439ca24b6a5c97cd1;True;Deferred;0;2;Deferred;0;False;False;True;False;True;0;False;-1;False;False;False;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=True;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=Deferred;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;59;5,245;Float;False;False;-1;2;ASEMaterialInspector;0;10;Hidden/Amplify Impostors;30a8e337ed84177439ca24b6a5c97cd1;True;ForwardAdd;0;1;ForwardAdd;0;False;False;True;False;True;0;False;-1;False;False;False;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=True;True;2;0;True;4;1;False;-1;1;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;True;2;False;-1;False;False;True;1;LightMode=ForwardAdd;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;61;5,311;Float;False;False;-1;2;ASEMaterialInspector;0;10;Hidden/Amplify Impostors;30a8e337ed84177439ca24b6a5c97cd1;True;Meta;0;3;Meta;0;False;False;True;False;True;0;False;-1;False;False;False;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=True;True;2;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;LightMode=Meta;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;62;5,344;Float;False;False;-1;2;ASEMaterialInspector;0;10;Hidden/Amplify Impostors;30a8e337ed84177439ca24b6a5c97cd1;True;ShadowCaster;0;4;ShadowCaster;0;False;False;True;False;True;0;False;-1;False;False;False;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=True;True;2;0;False;False;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=ShadowCaster;False;0;;0;0;Standard;0;0
WireConnection;37;0;67;1
WireConnection;37;1;67;3
WireConnection;28;0;37;0
WireConnection;17;0;25;0
WireConnection;31;0;28;0
WireConnection;33;0;31;0
WireConnection;33;1;30;0
WireConnection;33;2;29;0
WireConnection;38;0;17;8
WireConnection;34;0;38;3
WireConnection;34;1;33;0
WireConnection;36;0;17;0
WireConnection;36;1;34;0
WireConnection;36;2;38;3
WireConnection;58;0;36;0
WireConnection;58;1;17;1
WireConnection;58;3;38;0
WireConnection;58;4;38;1
WireConnection;58;5;38;2
WireConnection;58;6;17;6
ASEEND*/
//CHKSM=B63D0D8A6C7241ECDDCCC7A977D1AFD6B60B01E2