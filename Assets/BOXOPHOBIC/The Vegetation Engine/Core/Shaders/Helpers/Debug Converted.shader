// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BOXOPHOBIC/The Vegetation Engine/Helpers/Debug Converted"
{
	Properties
	{
		[StyledBanner(Debug Converted)]_Banner("Banner", Float) = 0
		[StyledMessage(Info, Use this shader to debug the converted mesh attributes., 0,0)]_Message("Message", Float) = 0
		[StyledCategory(Debug Mode)]_DebugCategory("[ Debug Category ]", Float) = 0
		[Enum(Motion Masks,100,Extra Masks,200,Texture Coords,300)]_DebugMode("Debug Mode", Float) = 100
		[Enum(Motion 1,0,Motion 2,1,Motion 3,2,Variation,3)][Space(10)]_MotionMasks("Motion Masks", Float) = 0
		[Enum(Occlusion,0,Detail Mask,1,Height Mask,2)]_ExtraMasks("Extra Masks", Float) = 0
		[Enum(Main UVs,0,Detail UVs,1,Lightmap UVs,2)]_TextureCoords("Texture Coords", Float) = 0
		[StyledCategory(Advanced)]_AdvancedCategory("[ Advanced Category ]", Float) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			//Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#define ASE_NEEDS_FRAG_COLOR


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform half _Banner;
			uniform half _AdvancedCategory;
			uniform half _DebugCategory;
			uniform half _Message;
			uniform half _DebugMode;
			uniform half _MotionMasks;
			uniform half _ExtraMasks;
			uniform half _TextureCoords;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1 = v.ase_texcoord3;
				o.ase_color = v.color;
				o.ase_texcoord2 = v.ase_texcoord;
				o.ase_texcoord3 = v.ase_texcoord1;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float Debug_Mode1865 = _DebugMode;
				float ifLocalVar1857 = 0;
				UNITY_BRANCH 
				if( Debug_Mode1865 == 100.0 )
				ifLocalVar1857 = ( Debug_Mode1865 + _MotionMasks );
				float ifLocalVar1872 = 0;
				UNITY_BRANCH 
				if( Debug_Mode1865 == 200.0 )
				ifLocalVar1872 = ( Debug_Mode1865 + _ExtraMasks );
				float ifLocalVar1884 = 0;
				UNITY_BRANCH 
				if( Debug_Mode1865 == 300.0 )
				ifLocalVar1884 = ( Debug_Mode1865 + _TextureCoords );
				half Debug_Out1487 = ( ifLocalVar1857 + ifLocalVar1872 + ifLocalVar1884 );
				half4 color1892 = IsGammaSpace() ? half4(0.3450981,0.9254902,0.5081975,0) : half4(0.0975874,0.8387991,0.2217072,0);
				float4 ifLocalVar1374 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 100.0 )
				ifLocalVar1374 = ( color1892 * i.ase_texcoord1.x );
				half4 color1896 = IsGammaSpace() ? half4(0.5390097,1,0.3632075,0) : half4(0.2519409,1,0.1085262,0);
				float4 ifLocalVar1355 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 101.0 )
				ifLocalVar1355 = ( color1896 * i.ase_texcoord1.y );
				half4 color1899 = IsGammaSpace() ? half4(0.8353143,1,0.345098,0) : half4(0.6654236,1,0.09758732,0);
				float4 ifLocalVar1407 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 102.0 )
				ifLocalVar1407 = ( color1899 * i.ase_texcoord1.z );
				half4 color1902 = IsGammaSpace() ? half4(1,0.4164298,0.3254902,0) : half4(1,0.1446755,0.08650047,0);
				float4 ifLocalVar1363 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 103.0 )
				ifLocalVar1363 = ( color1902 * i.ase_color.r );
				float4 Debug_Motion1842 = ( ifLocalVar1374 + ifLocalVar1355 + ifLocalVar1407 + ifLocalVar1363 );
				float ifLocalVar1911 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 200.0 )
				ifLocalVar1911 = i.ase_color.g;
				float ifLocalVar1912 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 201.0 )
				ifLocalVar1912 = i.ase_color.b;
				float ifLocalVar1918 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 202.0 )
				ifLocalVar1918 = i.ase_color.a;
				float Debug_Extras1922 = ( ifLocalVar1911 + ifLocalVar1912 + ifLocalVar1918 );
				float4 appendResult1844 = (float4(i.ase_texcoord2.x , i.ase_texcoord2.y , 0.0 , 0.0));
				float4 ifLocalVar1657 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 300.0 )
				ifLocalVar1657 = appendResult1844;
				float4 appendResult1845 = (float4(i.ase_texcoord2.z , i.ase_texcoord2.w , 0.0 , 0.0));
				float4 ifLocalVar1656 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 301.0 )
				ifLocalVar1656 = appendResult1845;
				float4 appendResult1846 = (float4(i.ase_texcoord3.x , i.ase_texcoord3.y , 0.0 , 0.0));
				float4 ifLocalVar1655 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 302.0 )
				ifLocalVar1655 = appendResult1846;
				float4 Debug_Coords1368 = ( ifLocalVar1657 + ifLocalVar1656 + ifLocalVar1655 );
				
				
				finalColor = ( Debug_Motion1842 + Debug_Extras1922 + Debug_Coords1368 );
				return finalColor;
			}
			ENDCG
		}
	}
	
	
	
}
/*ASEBEGIN
Version=18600
1927;1;1906;1020;2694.558;6065.115;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;1480;-1792,-5504;Half;False;Property;_DebugMode;Debug Mode;3;1;[Enum];Create;True;3;Motion Masks;100;Extra Masks;200;Texture Coords;300;0;True;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1865;-1536,-5504;Inherit;False;Debug_Mode;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1881;-1792,-4160;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1874;-1792,-4416;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1873;-1792,-4353.056;Half;False;Property;_ExtraMasks;Extra Masks;5;1;[Enum];Create;True;3;Occlusion;0;Detail Mask;1;Height Mask;2;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1886;-1792,-4096;Half;False;Property;_TextureCoords;Texture Coords;6;1;[Enum];Create;True;3;Main UVs;0;Detail UVs;1;Lightmap UVs;2;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1854;-1792,-4608;Half;False;Property;_MotionMasks;Motion Masks;4;1;[Enum];Create;True;4;Motion 1;0;Motion 2;1;Motion 3;2;Variation;3;0;True;1;Space(10);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1868;-1792,-4672;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1875;-1536,-4416;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1871;-1792,-4480;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1883;-1536,-4160;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1866;-1792,-4736;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1869;-1536,-4672;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1885;-1792,-4224;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1872;-1280,-4480;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;200;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1857;-1280,-4736;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;100;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1884;-1280,-4224;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;300;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1877;-896,-4736;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1897;-1792,-3200;Inherit;False;3;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1902;-1536,-2944;Half;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;False;0;False;1,0.4164298,0.3254902,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1892;-1536,-3712;Half;False;Constant;_Color2;Color 2;3;0;Create;True;0;0;False;0;False;0.3450981,0.9254902,0.5081975,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1888;-1792,-3712;Inherit;False;3;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1896;-1536,-3456;Half;False;Constant;_Color1;Color 1;3;0;Create;True;0;0;False;0;False;0.5390097,1,0.3632075,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1894;-1792,-3456;Inherit;False;3;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;1915;-1792,-2944;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1487;-640,-4736;Half;False;Debug_Out;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1899;-1536,-3200;Half;False;Constant;_Color3;Color 3;3;0;Create;True;0;0;False;0;False;0.8353143,1,0.345098,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1662;-1792,-896;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1660;-1792,-1408;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1661;-1792,-1152;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1645;-1088,-896;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1846;-1536,-896;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;1844;-1536,-1408;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;1858;-1088,-3584;Float;False;Constant;_Float3;Float 3;31;0;Create;True;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1647;-1088,-1408;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1370;-1088,-2800;Float;False;Constant;_Float22;Float 22;31;0;Create;True;0;0;False;0;False;103;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1898;-1280,-3136;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1329;-1088,-3328;Float;False;Constant;_Float9;Float 9;31;0;Create;True;0;0;False;0;False;101;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1895;-1280,-3392;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1650;-1088,-768;Float;False;Constant;_Float5;Float 5;31;0;Create;True;0;0;False;0;False;302;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1283;-1088,-3712;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1845;-1536,-1152;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;1653;-1088,-1280;Float;False;Constant;_Float7;Float 7;31;0;Create;True;0;0;False;0;False;300;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1339;-1088,-3200;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1386;-1088,-3456;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1891;-1280,-3648;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;1921;-1792,-1920;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1648;-1088,-1152;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1307;-1088,-2944;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1920;-1088,-1792;Float;False;Constant;_Float0;Float 0;31;0;Create;True;0;0;False;0;False;202;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1907;-1088,-2304;Float;False;Constant;_Float2;Float 2;31;0;Create;True;0;0;False;0;False;200;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;1916;-1792,-2432;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1910;-1088,-2432;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1919;-1088,-1920;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1909;-1088,-2048;Float;False;Constant;_Float1;Float 1;31;0;Create;True;0;0;False;0;False;201;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1646;-1088,-1024;Float;False;Constant;_Float4;Float 4;31;0;Create;True;0;0;False;0;False;301;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1359;-1088,-3072;Float;False;Constant;_Float21;Float 21;31;0;Create;True;0;0;False;0;False;102;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1908;-1088,-2176;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;1917;-1792,-2176;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1901;-1280,-2880;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;1407;-880,-3200;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;3;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;1656;-880,-1152;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;0;False;3;FLOAT4;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ConditionalIfNode;1363;-880,-2944;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;4;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;1918;-880,-1920;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1655;-880,-896;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;3;False;2;FLOAT;0;False;3;FLOAT4;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ConditionalIfNode;1657;-880,-1408;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT4;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ConditionalIfNode;1911;-880,-2432;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1912;-880,-2176;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1355;-880,-3456;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;1374;-880,-3712;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1311;-512,-3328;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1659;-512,-1152;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1913;-512,-2176;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1368;-256,-1152;Float;False;Debug_Coords;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1922;-256,-2176;Inherit;False;Debug_Extras;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1842;-256,-3328;Inherit;False;Debug_Motion;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1849;-1792,-5120;Inherit;False;1842;Debug_Motion;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1923;-1792,-5056;Inherit;False;1922;Debug_Extras;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1848;-1792,-4992;Inherit;False;1368;Debug_Coords;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1850;-1152,-5120;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1924;-1600,-5760;Half;False;Property;_Message;Message;1;0;Create;True;0;0;True;1;StyledMessage(Info, Use this shader to debug the converted mesh attributes., 0,0);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1880;-1408,-5760;Half;False;Property;_DebugCategory;[ Debug Category ];2;0;Create;True;0;0;True;1;StyledCategory(Debug Mode);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1878;-1792,-5760;Half;False;Property;_Banner;Banner;0;0;Create;True;0;0;True;1;StyledBanner(Debug Converted);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1879;-1184,-5760;Half;False;Property;_AdvancedCategory;[ Advanced Category ];7;0;Create;True;0;0;True;1;StyledCategory(Advanced);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1853;-640,-5120;Float;False;True;-1;2;;100;1;BOXOPHOBIC/The Vegetation Engine/Helpers/Debug Converted;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;2;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;1865;0;1480;0
WireConnection;1875;0;1874;0
WireConnection;1875;1;1873;0
WireConnection;1883;0;1881;0
WireConnection;1883;1;1886;0
WireConnection;1869;0;1868;0
WireConnection;1869;1;1854;0
WireConnection;1872;0;1871;0
WireConnection;1872;3;1875;0
WireConnection;1857;0;1866;0
WireConnection;1857;3;1869;0
WireConnection;1884;0;1885;0
WireConnection;1884;3;1883;0
WireConnection;1877;0;1857;0
WireConnection;1877;1;1872;0
WireConnection;1877;2;1884;0
WireConnection;1487;0;1877;0
WireConnection;1846;0;1662;1
WireConnection;1846;1;1662;2
WireConnection;1844;0;1660;1
WireConnection;1844;1;1660;2
WireConnection;1898;0;1899;0
WireConnection;1898;1;1897;3
WireConnection;1895;0;1896;0
WireConnection;1895;1;1894;2
WireConnection;1845;0;1661;3
WireConnection;1845;1;1661;4
WireConnection;1891;0;1892;0
WireConnection;1891;1;1888;1
WireConnection;1901;0;1902;0
WireConnection;1901;1;1915;1
WireConnection;1407;0;1339;0
WireConnection;1407;1;1359;0
WireConnection;1407;3;1898;0
WireConnection;1656;0;1648;0
WireConnection;1656;1;1646;0
WireConnection;1656;3;1845;0
WireConnection;1363;0;1307;0
WireConnection;1363;1;1370;0
WireConnection;1363;3;1901;0
WireConnection;1918;0;1919;0
WireConnection;1918;1;1920;0
WireConnection;1918;3;1921;4
WireConnection;1655;0;1645;0
WireConnection;1655;1;1650;0
WireConnection;1655;3;1846;0
WireConnection;1657;0;1647;0
WireConnection;1657;1;1653;0
WireConnection;1657;3;1844;0
WireConnection;1911;0;1910;0
WireConnection;1911;1;1907;0
WireConnection;1911;3;1916;2
WireConnection;1912;0;1908;0
WireConnection;1912;1;1909;0
WireConnection;1912;3;1917;3
WireConnection;1355;0;1386;0
WireConnection;1355;1;1329;0
WireConnection;1355;3;1895;0
WireConnection;1374;0;1283;0
WireConnection;1374;1;1858;0
WireConnection;1374;3;1891;0
WireConnection;1311;0;1374;0
WireConnection;1311;1;1355;0
WireConnection;1311;2;1407;0
WireConnection;1311;3;1363;0
WireConnection;1659;0;1657;0
WireConnection;1659;1;1656;0
WireConnection;1659;2;1655;0
WireConnection;1913;0;1911;0
WireConnection;1913;1;1912;0
WireConnection;1913;2;1918;0
WireConnection;1368;0;1659;0
WireConnection;1922;0;1913;0
WireConnection;1842;0;1311;0
WireConnection;1850;0;1849;0
WireConnection;1850;1;1923;0
WireConnection;1850;2;1848;0
WireConnection;1853;0;1850;0
ASEEND*/
//CHKSM=C9EB6CE053BE0AD145639859C03DB1F571998583