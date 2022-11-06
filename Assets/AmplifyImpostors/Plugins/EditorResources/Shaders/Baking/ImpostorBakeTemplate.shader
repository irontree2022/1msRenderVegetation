Shader /*ase_name*/ "Hidden/Impostors/Bake/Legacy"/*end*/
{
	Properties
	{
		/*ase_props*/
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 100
		CGINCLUDE
		#pragma target 4.0
		ENDCG
		Cull Back
		/*ase_pass*/

		Pass
		{
			Name "Unlit"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma multi_compile_fwdbase
			/*ase_pragma*/

			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				/*ase_vdata:p=p*/
			};

			struct v2f
			{
				UNITY_POSITION(pos);
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				/*ase_interp(0,):sp=sp.xyzw*/
			};

			/*ase_globals*/

			v2f vert(appdata v /*ase_vert_input*/)
			{
				v2f o = (v2f)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				/*ase_vert_code:v=appdata;o=v2f*/

				v.vertex.xyz += /*ase_vert_out:Local Vertex;Float3*/ float3(0,0,0) /*end*/;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}


			void frag(v2f i /*ase_frag_input*/,
				out half4 outGBuffer0 : SV_Target0, 
				out half4 outGBuffer1 : SV_Target1, 
				out half4 outGBuffer2 : SV_Target2, 
				out half4 outGBuffer3 : SV_Target3,
				out half4 outGBuffer4 : SV_Target4,
				out half4 outGBuffer5 : SV_Target5,
				out half4 outGBuffer6 : SV_Target6,
				out half4 outGBuffer7 : SV_Target7,
				out float outDepth : SV_Depth
			) 
			{
				UNITY_SETUP_INSTANCE_ID( i );
				/*ase_frag_code:i=v2f*/

				outGBuffer0 = /*ase_frag_out:Output RT 0;Float4*/0/*end*/;
				outGBuffer1 = /*ase_frag_out:Output RT 1;Float4*/0/*end*/;
				outGBuffer2 = /*ase_frag_out:Output RT 2;Float4*/0/*end*/;
				outGBuffer3 = /*ase_frag_out:Output RT 3;Float4*/0/*end*/;
				outGBuffer4 = /*ase_frag_out:Output RT 4;Float4*/0/*end*/;
				outGBuffer5 = /*ase_frag_out:Output RT 5;Float4*/0/*end*/;
				outGBuffer6 = /*ase_frag_out:Output RT 6;Float4*/0/*end*/;
				outGBuffer7 = /*ase_frag_out:Output RT 7;Float4*/0/*end*/;
				float alpha = /*ase_frag_out:Clip;Float*/1/*end*/;
				clip( alpha );
				outDepth = i.pos.z;
			}
			ENDCG
		}
	}
}
