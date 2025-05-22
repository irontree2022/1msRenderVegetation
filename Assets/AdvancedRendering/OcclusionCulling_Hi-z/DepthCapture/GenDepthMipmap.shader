Shader "Hidden/GenDepthMipmap"
{
    Properties{
        [HideInInspector] _MainTex("Previous Mipmap", 2D) = "black" {}
    }
        SubShader{
            Pass {
                Cull Off
                ZWrite Off
                ZTest Always

                CGPROGRAM
                #pragma target 3.0
                #pragma vertex vert
                #pragma fragment frag

                sampler2D _MainTex;
                float4 _MainTex_TexelSize;

                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };
                struct v2f
                {
                    float4 vertex : SV_POSITION;
                    float2 uv : TEXCOORD0;
                };

                inline float CalculatorMipmapDepth(float2 uv)
                {
                    float4 depth;
                    // ���������ĸ����ص� UV ƫ��
                    float2 offset = _MainTex_TexelSize.xy * 0.5;
                    depth.x = tex2D(_MainTex, uv); 
                    depth.y = tex2D(_MainTex, uv + float2( 0, offset.y));
                    depth.z = tex2D(_MainTex, uv + float2(offset.x,  0));
                    depth.w = tex2D(_MainTex, uv + offset);
                    // ��ѡ����������Ǹ�
                    // ��Ϊ�������ȡ���ʱ���Ѿ�����ȴ����ƽ̨���첢��������Դ�������������ֱ��ȡ�����Ϊ������
                    return max(max(depth.x, depth.y), max(depth.z, depth.w));
                }
                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex.xyz);
                    o.uv = v.uv;
                    return o;
                }
                float4 frag(v2f input) : Color
                {
                    float depth = CalculatorMipmapDepth(input.uv);
                    return float4(depth, depth, depth, 1.0f);
                }
                ENDCG
            }
        }
}