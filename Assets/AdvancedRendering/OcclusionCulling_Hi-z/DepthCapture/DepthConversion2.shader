Shader "Hidden/DepthConversion2"
{
	Properties
	{
		_Color("������ͼ��Ƭ���׵���ɫ", Color) = (1,1,1,1)
		_MainTex("����ͼ", 2D) = "white" {}
		_DepthFactor("��Ȳ���",Range(0,100)) = 1
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" "Queue" = "Geometry+100" }
			Pass
			{
				Tags
				{
					"LightMode" = "UniversalForward"
				}
				HLSLPROGRAM
				#pragma vertex vert
				#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;

			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 scrPos : TEXCOORD3;
			};


			CBUFFER_START(UnityPerMaterial)
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float _DepthFactor;
			CBUFFER_END
			TEXTURE2D_X_FLOAT(_CameraDepthTexture);
			SAMPLER(sampler_CameraDepthTexture);

			v2f vert(appdata v)
			{
				v2f o;
				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);
				o.pos = vertexInput.positionCS;

				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.scrPos = ComputeScreenPos(vertexInput.positionCS);

				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				float4 sampleTex = tex2D(_MainTex, i.uv);
				half2 screenPos = i.scrPos.xy / i.scrPos.w;
				// ������Ȳ�����ƽ̨���죬�����ֵת��Ϊ������ȣ�0-1��Χ��
				float depth = SAMPLE_TEXTURE2D_X(_CameraDepthTexture, sampler_CameraDepthTexture, screenPos).r;
				float depthValue = Linear01Depth(depth, _ZBufferParams);
				 // ���������ɫ����ȣ�
				return float4(depthValue, depthValue, depthValue, 1);
			}
			ENDHLSL
		}
		}
}