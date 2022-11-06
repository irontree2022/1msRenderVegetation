// Amplify Impostors
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

Shader "Hidden/ShaderPacker"
{
	Properties
	{
		_MainTex("_MainTex", 2D) = "white" {}
		_A("A", 2D) = "white" {}
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		ZWrite On
		ZTest LEqual
		ColorMask RGBA
		Blend Off
		Cull Off
		Offset 0,0


		Pass // Pack Depth 0
		{
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _A;

			float4 frag( v2f_img i ) : SV_Target
			{
				float depth = tex2D( _A, i.uv ).r;
				#if UNITY_REVERSED_Z != 1
					depth = 1-depth;
				#endif
				float4 finalColor = (float4(tex2D( _MainTex, i.uv ).rgb , depth));
				return finalColor;
			}
			ENDCG
		}

		Pass // Fix Emission 1
		{
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			float4 frag (v2f_img i ) : SV_Target
			{
				float4 finalColor = tex2D( _MainTex, i.uv );
				//#if !defined(UNITY_HDR_ON)
					finalColor.rgb = -log2(finalColor.rgb);
				//#endif
				return finalColor;
			}
			ENDCG
		}

		Pass // Render Only Alpha (for the inspector) 2
		{
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			float4 frag (v2f_img i ) : SV_Target
			{
				float4 finalColor = tex2D( _MainTex, i.uv );
				return float4(0,0,0,finalColor.a);
			}
			ENDCG
		}

		Pass // 3
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			uniform float4 _MainTex_ST;

			uniform float4x4 unity_GUIClipTextureMatrix;
			sampler2D _GUIClipTexture;

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 clipUV : TEXCOORD1;
			};

			v2f vert( appdata_t v )
			{
				v2f o;
				o.vertex = UnityObjectToClipPos( v.vertex );
				o.texcoord = TRANSFORM_TEX( v.texcoord.xy, _MainTex );
				float3 eyePos = UnityObjectToViewPos( v.vertex );
				o.clipUV = mul( unity_GUIClipTextureMatrix, float4( eyePos.xy, 0, 1.0 ) );
				return o;
			}

			float4 frag( v2f i ) : SV_Target
			{
				float2 fraction = sign(frac(i.texcoord * 5) * 2 - 1);
				float3 back = saturate(fraction.x*fraction.y) * 0.125 + 0.275 + 0.05;
				float4 c = tex2D( _MainTex, i.texcoord );
				c.rgb = lerp( back, c.rgb, c.a );

				c.a = tex2D( _GUIClipTexture, i.clipUV ).a;
				return c;
			}
			ENDCG
		}

		Pass // Copy Alpha 4
		{
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _A;

			fixed4 frag (v2f_img i ) : SV_Target
			{
				float alpha = tex2D( _A, i.uv ).a;
				fixed4 finalColor = (float4(tex2D( _MainTex, i.uv ).rgb , alpha));
				return finalColor;
			}
			ENDCG
		}

		Pass // Fix albedo 5
		{
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _A; //specular

			fixed4 frag (v2f_img i ) : SV_Target
			{
				float3 spec = tex2D( _A, i.uv ).rgb;
				float4 alb = tex2D( _MainTex, i.uv );
				alb.rgb = alb.rgb / (1-spec);
				return alb;
			}
			ENDCG
		}

		Pass // TGA BGR format 6
		{
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			fixed4 frag(v2f_img i) : SV_Target
			{
				return tex2D(_MainTex, i.uv).bgra;
			}
			ENDCG
		}

		Pass // point sampling 7
		{
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			fixed4 frag(v2f_img i) : SV_Target
			{
				return tex2Dlod(_MainTex, float4(i.uv, 0, 0));
			}
			ENDCG
		}

		Pass // point sampling alpha 8
		{
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			fixed4 frag(v2f_img i) : SV_Target
			{
				fixed4 finalColor = tex2Dlod(_MainTex, float4(i.uv, 0, 0));
				return float4(0, 0, 0, finalColor.a);
			}
			ENDCG
		}

		Pass // transform normal 9
		{
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform float4x4 _Matrix;

			fixed4 frag(v2f_img i) : SV_Target
			{
				fixed4 finalColor = tex2Dlod(_MainTex, float4(i.uv, 0, 0));
				finalColor.xyz = mul(_Matrix, float4(finalColor.xyz * 2 - 1,1)).xyz * 0.5 + 0.5;
				return finalColor;
			}
			ENDCG
		}

		Pass // deffered normal HD 10
		{
            ZTest Always Cull Off ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
            struct appdata_t {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD0;
            };

			float2 Unpack888ToFloat2( float3 x )
			{
				uint3 i = ( uint3 )( x * 255.0 );
				uint hi = i.z >> 4;
				uint lo = i.z & 15;
				uint2 cb = i.xy | uint2( lo << 8, hi << 8 );
				return cb / 4095.0;
			}

			float3 UnpackNormalOctQuadEncode( float2 f )
			{
				float3 n = float3( f.x, f.y, 1.0 - abs( f.x ) - abs( f.y ) );
				float t = max( -n.z, 0.0 );
				n.xy += n.xy >= 0.0 ? -t.xx : t.xx;
				return normalize( n );
			}

            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord.xy;
                return o;
            }

			float4 frag( v2f i ) : SV_Target
			{
				float4 normalBuffer = tex2D( _MainTex, i.texcoord );

				float alpha = 0;
				if( normalBuffer.a != 0 )
					alpha = 1;

				float2 octNormalWS = Unpack888ToFloat2( normalBuffer.xyz );
				float3 normalWS = UnpackNormalOctQuadEncode( octNormalWS * 2.0 - 1.0 );
				float perceptualRoughness = normalBuffer.a;

				return float4( ( normalWS * 0.5 + 0.5 ) * alpha, ( 1 - perceptualRoughness ) * alpha );
            }
            ENDCG

        }

				
		Pass // copy depth 11
		{
            ZTest Always Cull Off ZWrite Off

            CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _A;

			float4 frag( v2f_img i ) : SV_Target
			{
				float depth = SAMPLE_RAW_DEPTH_TEXTURE( _MainTex, i.uv ).r;
				float3 color = tex2D( _A, i.uv ).rgb;
				float alpha = 1 - step( depth, 0 );

				return float4( color, alpha );
            }
            ENDCG

        }

		Pass // copy 12
		{
			ZTest Always Cull Off ZWrite Off

			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			uint UnpackInt( float f, uint numBits )
			{
				uint maxInt = ( 1u << numBits ) - 1u;
				return ( uint )( f * maxInt + 0.5 ); // Round instead of truncating
			}

			uint PackFloatToUInt( float src, uint offset, uint numBits )
			{
				return UnpackInt( src, numBits ) << offset;
			}

			float3 UnpackFromR11G11B10f( uint rgb )
			{
				float r = f16tof32( ( rgb >> 17 ) & 0x7FF0 );
				float g = f16tof32( ( rgb >> 6 ) & 0x7FF0 );
				float b = f16tof32( ( rgb << 5 ) & 0x7FE0 );
				return float3( r, g, b );
			}

			float4 frag( v2f_img i ) : SV_Target
			{
				float4 col = tex2D( _MainTex, i.uv );
				uint3 s = 0;
				s.r = PackFloatToUInt( col.r, 0, 11 );
				s.g = PackFloatToUInt( col.r, 11, 11 );
				s.b = PackFloatToUInt( col.r, 22, 10 );
				float3 t = UnpackFromR11G11B10f( s );
				//col.rgb = UnpackFromR11G11B10f( col.rgb );
				return col;
				//return float4( t.x,0,0, 1 );
			}
			ENDCG
		}

		Pass // copy and decode features and diffusion 13
		{
            ZTest Always Cull Off ZWrite Off

            CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			
			float PackInt(uint i, uint numBits)
			{
				uint maxInt = (1u << numBits) - 1u;
				return saturate(i * rcp(maxInt));
			}

			uint UnpackInt(float f, uint numBits)
			{
				uint maxInt = (1u << numBits) - 1u;
				return (uint)(f * maxInt + 0.5);
			}

			void UnpackFloatInt(float val, float maxi, float precision, out float f, out uint i)
			{
				float precisionMinusOne = precision - 1.0;
				float t1 = ((precision / maxi) - 1.0) / precisionMinusOne;
				float t2 = (precision / maxi) / precisionMinusOne;

				i = int((val / t2) + rcp(precisionMinusOne));
				f = saturate((-t2 * float(i) + val) / t1);
			}

			void UnpackFloatInt8bit(float val, float maxi, out float f, out uint i)
			{
				UnpackFloatInt(val, maxi, 256.0, f, i);
			}

			#define MATERIALFEATUREFLAGS_LIT_STANDARD (1)
			#define MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR (2)
			#define MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING (4)
			#define MATERIALFEATUREFLAGS_LIT_TRANSMISSION (8)
			#define MATERIALFEATUREFLAGS_LIT_ANISOTROPY (16)
			#define MATERIALFEATUREFLAGS_LIT_IRIDESCENCE (32)
			#define MATERIALFEATUREFLAGS_LIT_CLEAR_COAT (64)

			#define GBUFFER_LIT_STANDARD         0
			#define GBUFFER_LIT_SSS              1
			#define GBUFFER_LIT_TRANSMISSION     2
			#define GBUFFER_LIT_TRANSMISSION_SSS 3
			#define GBUFFER_LIT_ANISOTROPIC      4
			#define GBUFFER_LIT_IRIDESCENCE      5
			
			#define UINT_MAX 0xFFFFFFFFu
			#define MATERIAL_FEATURE_MASK_FLAGS (4095)
			
			float _DiffusionProfileHashTable[16];

			uint FindDiffusionProfileHash(uint diffusionProfileIndex)
			{
				if (diffusionProfileIndex == 0)
					return 0;
    
				uint diffusionProfileHash = 0;
				uint i = 0;
				diffusionProfileHash = asuint(_DiffusionProfileHashTable[diffusionProfileIndex]);

				return diffusionProfileHash;
			}

			float4 frag( v2f_img i ) : SV_Target
			{
				float4 src = tex2D( _MainTex, i.uv );
				float coatMask;
				uint materialFeatureId;
				uint tileFeatureFlags = UINT_MAX;
				tileFeatureFlags &= MATERIAL_FEATURE_MASK_FLAGS;
				UnpackFloatInt8bit( src.a, 8, coatMask, materialFeatureId );
				
				uint pixelFeatureFlags    = MATERIALFEATUREFLAGS_LIT_STANDARD;
				bool pixelHasSubsurface   = materialFeatureId == GBUFFER_LIT_TRANSMISSION_SSS || materialFeatureId == GBUFFER_LIT_SSS;
				bool pixelHasTransmission = materialFeatureId == GBUFFER_LIT_TRANSMISSION_SSS || materialFeatureId == GBUFFER_LIT_TRANSMISSION;
				bool pixelHasAnisotropy   = materialFeatureId == GBUFFER_LIT_ANISOTROPIC;
				bool pixelHasIridescence  = materialFeatureId == GBUFFER_LIT_IRIDESCENCE;
				bool pixelHasClearCoat    = coatMask > 0.0;

				pixelFeatureFlags |= tileFeatureFlags & (pixelHasSubsurface   ? MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING : 0);
				pixelFeatureFlags |= tileFeatureFlags & (pixelHasTransmission ? MATERIALFEATUREFLAGS_LIT_TRANSMISSION          : 0);
				pixelFeatureFlags |= tileFeatureFlags & (pixelHasAnisotropy   ? MATERIALFEATUREFLAGS_LIT_ANISOTROPY            : 0);
				pixelFeatureFlags |= tileFeatureFlags & (pixelHasIridescence  ? MATERIALFEATUREFLAGS_LIT_IRIDESCENCE           : 0);
				pixelFeatureFlags |= tileFeatureFlags & (pixelHasClearCoat    ? MATERIALFEATUREFLAGS_LIT_CLEAR_COAT            : 0);
				
				float3 hash = 0;
				if( pixelHasSubsurface || pixelHasTransmission )
				{
					float subsurfaceMask;
					uint diffusionProfileIndex;
					UnpackFloatInt8bit( src.b, 16, subsurfaceMask, diffusionProfileIndex );
					uint diffusionProfileHash = FindDiffusionProfileHash( diffusionProfileIndex );
					
					hash.r = PackInt( ( diffusionProfileHash >> 16 ) & 0x000000FF, 8 );
					hash.g = PackInt( ( diffusionProfileHash >> 8 ) & 0x000000FF, 8 );
					hash.b = PackInt( ( diffusionProfileHash >> 0 ) & 0x000000FF, 8 );

					//uint r = UnpackInt(hash.r, 8) << 16;
					//uint g = UnpackInt(hash.g, 8) << 8;
					//uint b = UnpackInt(hash.b, 8);
					//uint Test = ( 0x40 << 24) | r | g | b; 
					//if( Test == diffusionProfileHash )
					//	hash = 1;
					//else
					//	hash = 0;
					//hash = asfloat(diffusionProfileHash);
				}
				
				return float4( hash, src.a );
				//return float4( 0,src.g ,src.b, src.a );
            }
            ENDCG
        }

		Pass // 14 point resize
		{
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			Texture2D _MainTex;
			SamplerState sampler_MainTex_Point_Repeat;
			//uniform sampler2D _MainTex;

			fixed4 frag(v2f_img i) : SV_Target
			{
				return UNITY_SAMPLE_TEX2D_SAMPLER(_MainTex,_MainTex_Point_Repeat,i.uv);
				//return tex2D(_MainTex, i.uv);
			}
			ENDCG
		}
	}
}
