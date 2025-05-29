// DepthConversion.shader
Shader "Hidden/DepthConversion"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _CameraDepthTexture;
            float4 _CameraDepthTexture_ST;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _CameraDepthTexture);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                // 采样深度并处理平台差异，将深度值转换为线性深度（0-1范围）
                float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
                float linearDepth = Linear01Depth(depth);
                // 输出最终颜色（深度）
                return float4(linearDepth, linearDepth, linearDepth, 1.0);
            }
            ENDCG
        }
    }
}