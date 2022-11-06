// Amplify Impostors
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

Shader "Hidden/ImpostorDilate"
{
	Properties
	{
		_MainTex( "", 2D ) = "white" {}
		_MaskTex( "", 2D ) = "black" {}
	}

	CGINCLUDE
		#include "UnityCG.cginc"

		sampler2D _MainTex;
		sampler2D _MaskTex;
		float4 _MainTex_TexelSize;

		float4 frag_dilate( v2f_img i, bool alpha )
		{
			float2 offsets[ 8 ] =
			{
				float2( -1, -1 ),
				float2(  0, -1 ),
				float2( +1, -1 ),
				float2( -1,  0 ),
				float2( +1,  0 ),
				float2( -1, +1 ),
				float2(  0, +1 ),
				float2( +1, +1 )
			};

			float4 ref_main = tex2D( _MainTex, i.uv.xy );
			float ref_mask = tex2D( _MaskTex, i.uv.xy ).a;
			float4 result = 0;

			if ( ref_mask == 0 )
			{
				float hits = 0;

				for ( int tap = 0; tap < 8; tap++ )
				{
					float2 uv = i.uv.xy + offsets[ tap ] * _MainTex_TexelSize.xy;
					float4 main = tex2Dlod( _MainTex, float4( uv, 0, 0 ) );
					float mask = tex2Dlod( _MaskTex, float4( uv, 0, 0 ) ).a;

					if ( mask != ref_mask )
					{
						result += main;
						hits++;
					}
				}

				if ( hits > 0 )
				{
					if ( alpha )
					{
						result /= hits;
					}
					else
					{
						result = float4( result.rgb / hits, ref_main.a );
					}
				}
				else
				{
					result = ref_main;
				}
			}
			else
			{
				result = ref_main;
			}

			return result;
		}
	ENDCG

	SubShader
	{
		ZTest Always Cull Off ZWrite Off Fog{ Mode off }

		// Dilate RGB
		Pass
		{
			CGPROGRAM
				#pragma vertex vert_img
				#pragma fragment frag

				float4 frag( v2f_img i ) : SV_target
				{
					return frag_dilate( i, false );
				}
			ENDCG
		}

		// Dilate RGBA
		Pass
		{
			CGPROGRAM
				#pragma vertex vert_img
				#pragma fragment frag

				float4 frag( v2f_img i ) : SV_target
				{
					return frag_dilate( i, true );
				}
			ENDCG
		}
	}

	FallBack Off
}
