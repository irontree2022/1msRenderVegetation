// Amplify Impostors
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

#ifndef AMPLIFYIMPOSTORS_INCLUDED
#define AMPLIFYIMPOSTORS_INCLUDED

#include "AmplifyImpostorsConfig.cginc"

#if (defined(AI_HD_RENDERPIPELINE) || defined(AI_LW_RENDERPIPELINE)) && !defined(AI_RENDERPIPELINE)
	#define AI_RENDERPIPELINE
#endif

float2 VectortoOctahedron( float3 N )
{
	N /= dot( 1.0, abs(N) );
	if( N.z <= 0 )
	{
		N.xy = ( 1 - abs(N.yx) ) * ( N.xy >= 0 ? 1.0 : -1.0 );
	}
	return N.xy;
}

float2 VectortoHemiOctahedron( float3 N )
{
	N.xy /= dot( 1.0, abs(N) );
	return float2( N.x + N.y, N.x - N.y );
}

float3 OctahedronToVector( float2 Oct )
{
	float3 N = float3( Oct, 1.0 - dot( 1.0, abs(Oct) ) );
	if( N.z < 0 )
	{
		N.xy = ( 1 - abs(N.yx) ) * ( N.xy >= 0 ? 1.0 : -1.0 );
	}
	return normalize(N);
}

float3 HemiOctahedronToVector( float2 Oct )
{
	Oct = float2( Oct.x + Oct.y, Oct.x - Oct.y ) *0.5;
	float3 N = float3( Oct, 1 - dot( 1.0, abs(Oct) ) );
	return normalize(N);
}

sampler2D _Albedo;
sampler2D _Normals;
sampler2D _Emission;

#ifdef AI_RENDERPIPELINE
	TEXTURE2D(_Specular);
	SAMPLER(sampler_Specular);
	SAMPLER(SamplerState_Point_Repeat);
#else
	sampler2D _Specular;
#endif

#if defined(AI_HD_RENDERPIPELINE) && ( AI_HDRP_VERSION >= 50702 )
	TEXTURE2D(_Features);
#endif

#if defined(AI_RENDERPIPELINE) && ( AI_HDRP_VERSION >= 50702 || AI_LWRP_VERSION >= 50702 ) 
CBUFFER_START(UnityPerMaterial)
#endif
float _FramesX;
float _FramesY;
float _Frames;
float _ImpostorSize;
float _Parallax;
float _TextureBias;
float _ClipMask;
float _DepthSize;
float _AI_ShadowBias;
float _AI_ShadowView;
float4 _Offset;
float4 _AI_SizeOffset;
float _EnergyConservingSpecularColor;

#ifdef EFFECT_HUE_VARIATION
	half4 _HueVariation;
#endif
#if defined(AI_RENDERPIPELINE) && ( AI_HDRP_VERSION >= 50702 || AI_LWRP_VERSION >= 50702 ) 
CBUFFER_END
#endif


#ifdef AI_RENDERPIPELINE
	#define AI_SAMPLEBIAS(textureName, samplerName, coord2, bias) SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)
	#define ai_ObjectToWorld GetObjectToWorldMatrix()
	#define ai_WorldToObject GetWorldToObjectMatrix()

	#define AI_INV_TWO_PI  INV_TWO_PI
	#define AI_PI          PI
	#define AI_INV_PI      INV_PI
#else
	#define AI_SAMPLEBIAS(textureName, samplerName, coord2, bias) tex2Dbias( textureName, float4( coord2, 0, bias) )
	#define ai_ObjectToWorld unity_ObjectToWorld
	#define ai_WorldToObject unity_WorldToObject

	#define AI_INV_TWO_PI  UNITY_INV_TWO_PI
	#define AI_PI          UNITY_PI
	#define AI_INV_PI      UNITY_INV_PI
#endif

inline void RayPlaneIntersectionUV( float3 normal, float3 rayPosition, float3 rayDirection, inout float2 uvs, inout float3 localNormal )
{
	// n = normal
	// p0 = (0, 0, 0) assuming center as zero
	// l0 = ray position
	// l = ray direction
	// solving to:
	// t = distance along ray that intersects the plane = ((p0 - l0) . n) / (l . n)
	// p = intersection point

	float lDotN = dot( rayDirection, normal ); // l . n
	float p0l0DotN = dot( -rayPosition, normal ); // (p0 - l0) . n

	float t = p0l0DotN / lDotN; // if > 0 then it's intersecting
	float3 p = rayDirection * t + rayPosition;

	// create frame UVs
	float3 upVector = float3( 0, 1, 0 );
	float3 tangent = normalize( cross( upVector, normal ) + float3( -0.001, 0, 0 ) );
	float3 bitangent = cross( tangent, normal );

	float frameX = dot( p, tangent );
	float frameZ = dot( p, bitangent );

	uvs = -float2( frameX, frameZ ); // why negative???

	if( t <= 0.0 ) // not intersecting
		uvs = 0;
	
	float3x3 worldToLocal = float3x3( tangent, bitangent, normal ); // TBN (same as doing separate dots?, assembly looks the same)
	localNormal = normalize( mul( worldToLocal, rayDirection ) );
}

inline void OctaImpostorVertex( inout float4 vertex, inout float3 normal, inout float4 uvsFrame1, inout float4 uvsFrame2, inout float4 uvsFrame3, inout float4 octaFrame, inout float4 viewPos )
{
	// Inputs
	float2 uvOffset = _AI_SizeOffset.zw;
	float parallax = -_Parallax; // check sign later
	float UVscale = _ImpostorSize;
	float framesXY = _Frames;
	float prevFrame = framesXY - 1;
	float3 fractions = 1.0 / float3( framesXY, prevFrame, UVscale );
	float fractionsFrame = fractions.x;
	float fractionsPrevFrame = fractions.y;
	float fractionsUVscale = fractions.z;

	// Basic data
	float3 worldOrigin = 0;
	float4 perspective = float4( 0, 0, 0, 1 );
	// if there is no perspective we offset world origin with a 5000 view dir vector, otherwise we use the original world position
	if( UNITY_MATRIX_P[ 3 ][ 3 ] == 1 ) 
	{
		perspective = float4( 0, 0, 5000, 0 );
		worldOrigin = ai_ObjectToWorld._m03_m13_m23;
	}
	float3 worldCameraPos = worldOrigin + mul( UNITY_MATRIX_I_V, perspective ).xyz;

	float3 objectCameraPosition = mul( ai_WorldToObject, float4( worldCameraPos, 1 ) ).xyz - _Offset.xyz; //ray origin
	float3 objectCameraDirection = normalize( objectCameraPosition );

	// Create orthogonal vectors to define the billboard
	float3 upVector = float3( 0,1,0 );
	float3 objectHorizontalVector = normalize( cross( objectCameraDirection, upVector ) );
	float3 objectVerticalVector = cross( objectHorizontalVector, objectCameraDirection );

	// Billboard
	float2 uvExpansion = vertex.xy;
	float3 billboard = objectHorizontalVector * uvExpansion.x + objectVerticalVector * uvExpansion.y;

	float3 localDir = billboard - objectCameraPosition; // ray direction

	// Octahedron Frame
	#ifdef _HEMI_ON
		objectCameraDirection.y = max(0.001, objectCameraDirection.y);
		float2 frameOcta = VectortoHemiOctahedron( objectCameraDirection.xzy ) * 0.5 + 0.5;
	#else
		float2 frameOcta = VectortoOctahedron( objectCameraDirection.xzy ) * 0.5 + 0.5;
	#endif

	// Setup for octahedron
	float2 prevOctaFrame = frameOcta * prevFrame;
	float2 baseOctaFrame = floor( prevOctaFrame );
	float2 fractionOctaFrame = ( baseOctaFrame * fractionsFrame );

	// Octa 1
	float2 octaFrame1 = ( baseOctaFrame * fractionsPrevFrame ) * 2.0 - 1.0;
	#ifdef _HEMI_ON
		float3 octa1WorldY = HemiOctahedronToVector( octaFrame1 ).xzy;
	#else
		float3 octa1WorldY = OctahedronToVector( octaFrame1 ).xzy;
	#endif

	float3 octa1LocalY;
	float2 uvFrame1;
	RayPlaneIntersectionUV( octa1WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame1, /*inout*/ octa1LocalY );

	float2 uvParallax1 = octa1LocalY.xy * fractionsFrame * parallax;
	uvFrame1 = ( uvFrame1 * fractionsUVscale + 0.5 ) * fractionsFrame + fractionOctaFrame;
	uvsFrame1 = float4( uvParallax1, uvFrame1) - float4( 0, 0, uvOffset );

	// Octa 2
	float2 fractPrevOctaFrame = frac( prevOctaFrame );
	float2 cornerDifference = lerp( float2( 0,1 ) , float2( 1,0 ) , saturate( ceil( ( fractPrevOctaFrame.x - fractPrevOctaFrame.y ) ) ));
	float2 octaFrame2 = ( ( baseOctaFrame + cornerDifference ) * fractionsPrevFrame ) * 2.0 - 1.0;
	#ifdef _HEMI_ON
		float3 octa2WorldY = HemiOctahedronToVector( octaFrame2 ).xzy;
	#else
		float3 octa2WorldY = OctahedronToVector( octaFrame2 ).xzy;
	#endif

	float3 octa2LocalY;
	float2 uvFrame2;
	RayPlaneIntersectionUV( octa2WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame2, /*inout*/ octa2LocalY );

	float2 uvParallax2 = octa2LocalY.xy * fractionsFrame * parallax;
	uvFrame2 = ( uvFrame2 * fractionsUVscale + 0.5 ) * fractionsFrame + ( ( cornerDifference * fractionsFrame ) + fractionOctaFrame );
	uvsFrame2 = float4( uvParallax2, uvFrame2) - float4( 0, 0, uvOffset );

	// Octa 3
	float2 octaFrame3 = ( ( baseOctaFrame + 1 ) * fractionsPrevFrame  ) * 2.0 - 1.0;
	#ifdef _HEMI_ON
		float3 octa3WorldY = HemiOctahedronToVector( octaFrame3 ).xzy;
	#else
		float3 octa3WorldY = OctahedronToVector( octaFrame3 ).xzy;
	#endif

	float3 octa3LocalY;
	float2 uvFrame3;
	RayPlaneIntersectionUV( octa3WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame3, /*inout*/ octa3LocalY );

	float2 uvParallax3 = octa3LocalY.xy * fractionsFrame * parallax;
	uvFrame3 = ( uvFrame3 * fractionsUVscale + 0.5 ) * fractionsFrame + ( fractionOctaFrame + fractionsFrame );
	uvsFrame3 = float4( uvParallax3, uvFrame3) - float4( 0, 0, uvOffset );

	// maybe remove this?
	octaFrame = 0;
	octaFrame.xy = prevOctaFrame;
	#if AI_CLIP_NEIGHBOURS_FRAMES
		octaFrame.zw = fractionOctaFrame;
	#endif

	vertex.xyz = billboard + _Offset.xyz;
	normal.xyz = objectCameraDirection;

	// view pos
	viewPos = 0;
	#ifdef AI_RENDERPIPELINE
		viewPos.xyz = TransformWorldToView( TransformObjectToWorld( vertex.xyz ) );
	#else
		viewPos.xyz = UnityObjectToViewPos( vertex.xyz );
	#endif

	#ifdef EFFECT_HUE_VARIATION
		float hueVariationAmount = frac( ai_ObjectToWorld[0].w + ai_ObjectToWorld[1].w + ai_ObjectToWorld[2].w);
		viewPos.w = saturate(hueVariationAmount * _HueVariation.a);
	#endif
}

inline void OctaImpostorFragment( inout SurfaceOutputStandardSpecular o, out float4 clipPos, out float3 worldPos, float4 uvsFrame1, float4 uvsFrame2, float4 uvsFrame3, float4 octaFrame, float4 interpViewPos )
{
	float depthBias = -1.0;
	float textureBias = _TextureBias;

	// Weights
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

	// albedo alpha
	float4 albedo1 = tex2Dbias( _Albedo, float4( parallax1, 0, textureBias) );
	float4 albedo2 = tex2Dbias( _Albedo, float4( parallax2, 0, textureBias) );
	float4 albedo3 = tex2Dbias( _Albedo, float4( parallax3, 0, textureBias) );
	float4 blendedAlbedo = albedo1 * weights.x + albedo2 * weights.y + albedo3 * weights.z;

	// early clip
	o.Alpha = ( blendedAlbedo.a - _ClipMask );
	clip( o.Alpha );

	#if AI_CLIP_NEIGHBOURS_FRAMES
		float t = ceil( fraction.x - fraction.y );
		float4 cornerDifference = float4( t, 1 - t, 1, 1 );

		float2 step_1 = ( parallax1 - octaFrame.zw ) * _Frames;
		float4 step23 = ( float4( parallax2, parallax3 ) -  octaFrame.zwzw ) * _Frames - cornerDifference;

		step_1 = step_1 * (1-step_1);
		step23 = step23 * (1-step23);

		float3 steps;
		steps.x = step_1.x * step_1.y;
		steps.y = step23.x * step23.y;
		steps.z = step23.z * step23.w;
		steps = step(-steps, 0);
	
		float final = dot( steps, weights );

		clip( final - 0.5 );
	#endif

	#ifdef EFFECT_HUE_VARIATION
		half3 shiftedColor = lerp(blendedAlbedo.rgb, _HueVariation.rgb, interpViewPos.w);
		half maxBase = max(blendedAlbedo.r, max(blendedAlbedo.g, blendedAlbedo.b));
		half newMaxBase = max(shiftedColor.r, max(shiftedColor.g, shiftedColor.b));
		maxBase /= newMaxBase;
		maxBase = maxBase * 0.5f + 0.5f;
		shiftedColor.rgb *= maxBase;
		blendedAlbedo.rgb = saturate(shiftedColor);
	#endif
	o.Albedo = blendedAlbedo.rgb;

	// Emission Occlusion
	float4 mask1 = tex2Dbias( _Emission, float4( parallax1, 0, textureBias) );
	float4 mask2 = tex2Dbias( _Emission, float4( parallax2, 0, textureBias) );
	float4 mask3 = tex2Dbias( _Emission, float4( parallax3, 0, textureBias) );
	float4 blendedMask = mask1 * weights.x  + mask2 * weights.y + mask3 * weights.z;
	o.Emission = blendedMask.rgb;
	o.Occlusion = blendedMask.a;

	// Specular Smoothness
	float4 spec1 = AI_SAMPLEBIAS( _Specular, sampler_Specular, parallax1, textureBias);
	float4 spec2 = AI_SAMPLEBIAS( _Specular, sampler_Specular, parallax2, textureBias);
	float4 spec3 = AI_SAMPLEBIAS( _Specular, sampler_Specular, parallax3, textureBias);
	float4 blendedSpec = spec1 * weights.x  + spec2 * weights.y + spec3 * weights.z;
	o.Specular = blendedSpec.rgb;
	o.Smoothness = blendedSpec.a;

	// Diffusion Features
	#if defined(AI_HD_RENDERPIPELINE) && ( AI_HDRP_VERSION >= 50702 )
	float4 feat1 = _Features.SampleLevel( SamplerState_Point_Repeat, parallax1, 0);
	o.Diffusion = feat1.rgb;
	o.Features = feat1.a;
	float4 test1 = _Specular.SampleLevel( SamplerState_Point_Repeat, parallax1, 0);
	o.MetalTangent = test1.b;
	#endif
	
	// normal depth
	float4 normals1 = tex2Dbias( _Normals, float4( parallax1, 0, textureBias) );
	float4 normals2 = tex2Dbias( _Normals, float4( parallax2, 0, textureBias) );
	float4 normals3 = tex2Dbias( _Normals, float4( parallax3, 0, textureBias) );
	float4 blendedNormal = normals1 * weights.x  + normals2 * weights.y + normals3 * weights.z;

	float3 localNormal = blendedNormal.rgb * 2.0 - 1.0;
	float3 worldNormal = normalize( mul( (float3x3)ai_ObjectToWorld, localNormal ) );
	o.Normal = worldNormal;

	float3 viewPos = interpViewPos.xyz;
	float depthOffset = ( ( parallaxSample1.a * weights.x + parallaxSample2.a * weights.y + parallaxSample3.a * weights.z ) - 0.5 /** 2.0 - 1.0*/ ) /** 0.5*/ * _DepthSize * length( ai_ObjectToWorld[ 2 ].xyz );
	
	#if !defined(AI_RENDERPIPELINE) // no SRP
		#if defined(SHADOWS_DEPTH)
			if( unity_LightShadowBias.y == 1.0 ) // get only the shadowcaster, this is a hack
			{
				viewPos.z += depthOffset * _AI_ShadowView;
				viewPos.z += -_AI_ShadowBias;
			}
			else // else add offset normally
			{
				viewPos.z += depthOffset;
			}
		#else // else add offset normally
			viewPos.z += depthOffset;
		#endif
	#elif defined(AI_RENDERPIPELINE) // SRP
		#if ( defined(SHADERPASS) && (SHADERPASS == SHADERPASS_SHADOWS) ) || defined(UNITY_PASS_SHADOWCASTER)
			viewPos.z += depthOffset * _AI_ShadowView;
			viewPos.z += -_AI_ShadowBias;
		#else // else add offset normally
			viewPos.z += depthOffset;
		#endif
	#endif

	worldPos = mul( UNITY_MATRIX_I_V, float4( viewPos.xyz, 1 ) ).xyz;
	clipPos = mul( UNITY_MATRIX_P, float4( viewPos, 1 ) );
	
	#if !defined(AI_RENDERPIPELINE) // no SRP
		#if defined(SHADOWS_DEPTH)
			clipPos = UnityApplyLinearShadowBias( clipPos );
		#endif
	#elif defined(AI_RENDERPIPELINE) // SRP
		#if defined(UNITY_PASS_SHADOWCASTER) && !defined(SHADERPASS)
			#if UNITY_REVERSED_Z
				clipPos.z = min( clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE );
			#else
				clipPos.z = max( clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE );
			#endif
		#endif
	#endif
	
	clipPos.xyz /= clipPos.w;
	
	if( UNITY_NEAR_CLIP_VALUE < 0 )
		clipPos = clipPos * 0.5 + 0.5;
}

inline void SphereImpostorVertex( inout float4 vertex, inout float3 normal, inout float4 frameUVs, inout float4 viewPos )
{
	// INPUTS
	float2 uvOffset = _AI_SizeOffset.zw;
	float sizeX = _FramesX;
	float sizeY = _FramesY - 1; // adjusted
	float UVscale = _ImpostorSize;
	float4 fractions = 1 / float4( sizeX, _FramesY, sizeY, UVscale );
	float2 sizeFraction = fractions.xy;
	float axisSizeFraction = fractions.z;
	float fractionsUVscale = fractions.w;

	// Basic data
	float3 worldOrigin = 0;
	float4 perspective = float4( 0, 0, 0, 1 );
	// if there is no perspective we offset world origin with a 5000 view dir vector, otherwise we use the original world position
	if( UNITY_MATRIX_P[ 3 ][ 3 ] == 1 )
	{
		perspective = float4( 0, 0, 5000, 0 );
		worldOrigin = ai_ObjectToWorld._m03_m13_m23;
	}
	float3 worldCameraPos = worldOrigin + mul( UNITY_MATRIX_I_V, perspective ).xyz;

	float3 objectCameraPosition = mul( ai_WorldToObject, float4( worldCameraPos, 1 ) ).xyz - _Offset.xyz; //ray origin
	float3 objectCameraDirection = normalize( objectCameraPosition );

	// Create orthogonal vectors to define the billboard
	float3 upVector = float3( 0,1,0 );
	float3 objectHorizontalVector = normalize( cross( objectCameraDirection, upVector ) );
	float3 objectVerticalVector = cross( objectHorizontalVector, objectCameraDirection );

	// Create vertical radial angle
	float verticalAngle = frac( atan2( -objectCameraDirection.z, -objectCameraDirection.x ) * AI_INV_TWO_PI ) * sizeX + 0.5;

	// Create horizontal radial angle
	float verticalDot = dot( objectCameraDirection, upVector );
	float upAngle = ( acos( -verticalDot ) * AI_INV_PI ) + axisSizeFraction * 0.5f;
	float yRot = sizeFraction.x * AI_PI * verticalDot * ( 2 * frac( verticalAngle ) - 1 );

	// Billboard rotation
	float2 uvExpansion = vertex.xy;
	float cosY = cos( yRot );
	float sinY = sin( yRot );
	float2 uvRotator = mul( uvExpansion, float2x2( cosY, -sinY, sinY, cosY ) );

	// Billboard
	float3 billboard = objectHorizontalVector * uvRotator.x + objectVerticalVector * uvRotator.y + _Offset.xyz;

	// Frame coords
	float2 relativeCoords = float2( floor( verticalAngle ), min( floor( upAngle * sizeY ), sizeY ) );
	float2 frameUV = ( ( uvExpansion * fractionsUVscale + 0.5 ) + relativeCoords ) * sizeFraction;

	frameUVs.xy = frameUV - uvOffset;
	
	// Parallax
	#if _USE_PARALLAX_ON
		float3 objectNormalVector = cross( objectHorizontalVector, -objectVerticalVector );
		float3x3 worldToLocal = float3x3( objectHorizontalVector, objectVerticalVector, objectNormalVector );
		float3 sphereLocal = normalize( mul( worldToLocal, billboard - objectCameraPosition ) );
		frameUVs.zw = sphereLocal.xy * sizeFraction * _Parallax;
	#else
		frameUVs.zw = 0;
	#endif
	
	viewPos.w = 0;
	#ifdef AI_RENDERPIPELINE
		viewPos.xyz = TransformWorldToView( TransformObjectToWorld( billboard ) );
	#else
		viewPos.xyz = UnityObjectToViewPos( billboard );
	#endif

	#ifdef EFFECT_HUE_VARIATION
		float hueVariationAmount = frac( ai_ObjectToWorld[0].w + ai_ObjectToWorld[1].w + ai_ObjectToWorld[2].w );
		viewPos.w = saturate(hueVariationAmount * _HueVariation.a);
	#endif

	vertex.xyz = billboard;
	normal.xyz = objectCameraDirection;
}

inline void SphereImpostorFragment( inout SurfaceOutputStandardSpecular o, out float4 clipPos, out float3 worldPos, float4 frameUV, float4 viewPos )
{
	#if _USE_PARALLAX_ON
		float4 parallaxSample = tex2Dbias( _Normals, float4( frameUV.xy, 0, -1 ) );
		frameUV.xy = ( ( 0.5 - parallaxSample.a ) * frameUV.zw ) + frameUV.xy;
	#endif

	// albedo alpha
	float4 albedoSample = tex2Dbias( _Albedo, float4( frameUV.xy, 0, _TextureBias) );

	// early clip
	o.Alpha = ( albedoSample.a - _ClipMask );
	clip( o.Alpha );

	#ifdef EFFECT_HUE_VARIATION
		half3 shiftedColor = lerp(albedoSample.rgb, _HueVariation.rgb, viewPos.w);
		half maxBase = max(albedoSample.r, max(albedoSample.g, albedoSample.b));
		half newMaxBase = max(shiftedColor.r, max(shiftedColor.g, shiftedColor.b));
		maxBase /= newMaxBase;
		maxBase = maxBase * 0.5f + 0.5f;
		shiftedColor.rgb *= maxBase;
		albedoSample.rgb = saturate(shiftedColor);
	#endif
	o.Albedo = albedoSample.rgb;
	
	// Specular Smoothness
	float4 specularSample = AI_SAMPLEBIAS( _Specular, sampler_Specular, frameUV.xy, _TextureBias );
	o.Specular = specularSample.rgb;
	o.Smoothness = specularSample.a;

	// Emission Occlusion
	float4 emissionSample = tex2Dbias( _Emission, float4( frameUV.xy, 0, _TextureBias) );
	o.Emission = emissionSample.rgb;
	o.Occlusion = emissionSample.a;

	// Diffusion Features
	#if defined(AI_HD_RENDERPIPELINE) && ( AI_HDRP_VERSION >= 50702 )
	float4 feat1 = _Features.SampleLevel( SamplerState_Point_Repeat, frameUV.xy, 0);
	o.Diffusion = feat1.rgb;
	o.Features = feat1.a;
	float4 test1 = _Specular.SampleLevel( SamplerState_Point_Repeat, frameUV.xy, 0);
	o.MetalTangent = test1.b;
	#endif

	// Normal
	float4 normalSample = tex2Dbias( _Normals, float4( frameUV.xy, 0, _TextureBias) );
	float4 remapNormal = normalSample * 2 - 1; // object normal is remapNormal.rgb
	float3 worldNormal = normalize( mul( (float3x3)ai_ObjectToWorld, remapNormal.xyz ) );
	o.Normal = worldNormal;

	// Depth
	float depth = remapNormal.a * _DepthSize * 0.5 * length( ai_ObjectToWorld[ 2 ].xyz );

	#if !defined(AI_RENDERPIPELINE) // no SRP
		#if defined(SHADOWS_DEPTH)
			if( unity_LightShadowBias.y == 1.0 ) // get only the shadowcaster, this is a hack
			{
				viewPos.z += depth * _AI_ShadowView;
				viewPos.z += -_AI_ShadowBias;
			}
			else // else add offset normally
			{
				viewPos.z += depth;
			}
		#else // else add offset normally
			viewPos.z += depth;
		#endif
	#elif defined(AI_RENDERPIPELINE) // SRP
		#if ( defined(SHADERPASS) && (SHADERPASS == SHADERPASS_SHADOWS) ) || defined(UNITY_PASS_SHADOWCASTER)
			viewPos.z += depth * _AI_ShadowView;
			viewPos.z += -_AI_ShadowBias;
		#else // else add offset normally
			viewPos.z += depth;
		#endif
	#endif

	worldPos = mul( UNITY_MATRIX_I_V, float4( viewPos.xyz, 1 ) ).xyz;
	clipPos = mul( UNITY_MATRIX_P, float4( viewPos.xyz, 1 ) );
	
	#if !defined(AI_RENDERPIPELINE) // no SRP
		#if defined(SHADOWS_DEPTH)
			clipPos = UnityApplyLinearShadowBias( clipPos );
		#endif
	#elif defined(AI_RENDERPIPELINE) // SRP
		#if defined(UNITY_PASS_SHADOWCASTER) && !defined(SHADERPASS)
			#if UNITY_REVERSED_Z
				clipPos.z = min( clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE );
			#else
				clipPos.z = max( clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE );
			#endif
		#endif
	#endif
	
	clipPos.xyz /= clipPos.w;
	
	if( UNITY_NEAR_CLIP_VALUE < 0 )
		clipPos = clipPos * 0.5 + 0.5;
}
#endif //AMPLIFYIMPOSTORS_INCLUDED
