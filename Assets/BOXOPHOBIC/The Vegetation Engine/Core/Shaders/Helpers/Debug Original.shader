// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BOXOPHOBIC/The Vegetation Engine/Helpers/Debug Original"
{
	Properties
	{
		[StyledBanner(Debug Original)]_Banner("Banner", Float) = 0
		[StyledMessage(Info, Use this shader to debug the original mesh attributes., 0,0)]_Message("Message", Float) = 0
		[StyledCategory(Debug Mode)]_DebugCategory("[ Debug Category ]", Float) = 0
		[Enum(Vertex Colors,100,Texture Coords,200)]_DebugMode("Debug Mode", Float) = 100
		[Enum(Red,0,Green,1,Blue,2,Alpha,3)][Space(10)]_VertexColors("Vertex Colors", Float) = 0
		[Enum(UV Coord 0,0,UV Coord 2,1,UV Coord 3,2,UV Coord 4,3)]_TextureCoords("Texture Coords", Float) = 0
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
		Cull Back
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
			#define ASE_NEEDS_VERT_COLOR


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform half _Banner;
			uniform half _AdvancedCategory;
			uniform half _DebugCategory;
			uniform half _Message;
			uniform half _DebugMode;
			uniform half _VertexColors;
			uniform half _TextureCoords;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float Debug_Mode1865 = _DebugMode;
				float ifLocalVar1857 = 0;
				UNITY_BRANCH 
				if( Debug_Mode1865 == 100.0 )
				ifLocalVar1857 = ( Debug_Mode1865 + _VertexColors );
				float ifLocalVar1872 = 0;
				UNITY_BRANCH 
				if( Debug_Mode1865 == 200.0 )
				ifLocalVar1872 = ( Debug_Mode1865 + _TextureCoords );
				half Debug_Out1487 = ( ifLocalVar1857 + ifLocalVar1872 );
				half4 color1314 = IsGammaSpace() ? half4(1,0.4926471,0.4926471,0) : half4(1,0.2072984,0.2072984,0);
				float4 ifLocalVar1374 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 100.0 )
				ifLocalVar1374 = ( color1314 * v.color.r );
				float4 ifLocalVar1355 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 101.0 )
				ifLocalVar1355 = ( half4(0.4926471,1,0.4926471,0) * v.color.g );
				float4 ifLocalVar1407 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 102.0 )
				ifLocalVar1407 = ( half4(0.5,0.5,1,0) * v.color.b );
				float ifLocalVar1363 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 103.0 )
				ifLocalVar1363 = v.color.a;
				float4 Debug_VertexColor1842 = ( ifLocalVar1374 + ifLocalVar1355 + ifLocalVar1407 + ifLocalVar1363 );
				float4 appendResult1844 = (float4(v.ase_texcoord.x , v.ase_texcoord.y , 0.0 , 0.0));
				float4 ifLocalVar1657 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 200.0 )
				ifLocalVar1657 = appendResult1844;
				float4 appendResult1845 = (float4(v.ase_texcoord1.x , v.ase_texcoord1.y , 0.0 , 0.0));
				float4 ifLocalVar1656 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 201.0 )
				ifLocalVar1656 = appendResult1845;
				float4 appendResult1846 = (float4(v.ase_texcoord2.x , v.ase_texcoord2.y , 0.0 , 0.0));
				float4 ifLocalVar1655 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 202.0 )
				ifLocalVar1655 = appendResult1846;
				float4 appendResult1847 = (float4(v.ase_texcoord3.x , v.ase_texcoord3.y , 0.0 , 0.0));
				float4 ifLocalVar1658 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 203.0 )
				ifLocalVar1658 = appendResult1847;
				float4 Debug_Coords1368 = ( ifLocalVar1657 + ifLocalVar1656 + ifLocalVar1655 + ifLocalVar1658 );
				float4 vertexToFrag1719 = ( Debug_VertexColor1842 + Debug_Coords1368 );
				o.ase_texcoord1 = vertexToFrag1719;
				
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
				float4 vertexToFrag1719 = i.ase_texcoord1;
				
				
				finalColor = vertexToFrag1719;
				return finalColor;
			}
			ENDCG
		}
	}
	
	
	
}
/*ASEBEGIN
Version=18600
1927;1;1906;1020;2418.945;5911.315;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;1480;-1792,-5376;Half;False;Property;_DebugMode;Debug Mode;3;1;[Enum];Create;True;2;Vertex Colors;100;Texture Coords;200;0;True;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1865;-1536,-5376;Inherit;False;Debug_Mode;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1874;-1792,-4288;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1854;-1792,-4480;Half;False;Property;_VertexColors;Vertex Colors;4;1;[Enum];Create;True;4;Red;0;Green;1;Blue;2;Alpha;3;0;True;1;Space(10);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1868;-1792,-4544;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1873;-1792,-4224;Half;False;Property;_TextureCoords;Texture Coords;5;1;[Enum];Create;True;4;UV Coord 0;0;UV Coord 2;1;UV Coord 3;2;UV Coord 4;3;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1869;-1536,-4544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1871;-1792,-4352;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1875;-1536,-4288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1866;-1792,-4608;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1872;-1280,-4352;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;200;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1857;-1280,-4608;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;100;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1877;-896,-4608;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1662;-1792,-1920;Inherit;False;2;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1389;-1600,-3456;Half;False;Constant;_Color4;Color 4;3;0;Create;True;0;0;False;0;False;0.4926471,1,0.4926471,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1661;-1792,-2176;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1663;-1792,-1664;Inherit;False;3;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1660;-1792,-2432;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1366;-1600,-3200;Half;False;Constant;_Color5;Color 5;3;0;Create;True;0;0;False;0;False;0.5,0.5,1,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;1384;-1792,-3712;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1487;-640,-4608;Half;False;Debug_Out;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;1292;-1792,-3200;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1314;-1600,-3712;Half;False;Constant;_Color3;Color 3;3;0;Create;True;0;0;False;0;False;1,0.4926471,0.4926471,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;1377;-1792,-3456;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1359;-1088,-3072;Float;False;Constant;_Float21;Float 21;31;0;Create;True;0;0;False;0;False;102;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1307;-1088,-2944;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1339;-1088,-3200;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1858;-1088,-3584;Float;False;Constant;_Float10;Float 9;31;0;Create;True;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1283;-1088,-3712;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1329;-1088,-3328;Float;False;Constant;_Float9;Float 9;31;0;Create;True;0;0;False;0;False;101;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1647;-1088,-2432;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1846;-1536,-1920;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;1653;-1088,-2304;Float;False;Constant;_Float7;Float 7;31;0;Create;True;0;0;False;0;False;200;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1651;-1088,-1520;Float;False;Constant;_Float6;Float 6;31;0;Create;True;0;0;False;0;False;203;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1847;-1536,-1664;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;1844;-1536,-2432;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;1845;-1536,-2176;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;1645;-1088,-1920;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1652;-1088,-1664;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;1388;-1792,-2944;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1370;-1088,-2800;Float;False;Constant;_Float22;Float 22;31;0;Create;True;0;0;False;0;False;103;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1386;-1088,-3456;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1318;-1344,-3136;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1286;-1344,-3648;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1650;-1088,-1792;Float;False;Constant;_Float5;Float 5;31;0;Create;True;0;0;False;0;False;202;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1648;-1088,-2176;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1367;-1344,-3392;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1646;-1088,-2048;Float;False;Constant;_Float4;Float 4;31;0;Create;True;0;0;False;0;False;201;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1407;-880,-3200;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;3;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;1355;-880,-3456;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;1374;-880,-3712;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;1363;-880,-2944;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;4;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1657;-880,-2432;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT4;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ConditionalIfNode;1658;-880,-1664;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;4;False;2;FLOAT;0;False;3;FLOAT4;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ConditionalIfNode;1655;-880,-1920;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;3;False;2;FLOAT;0;False;3;FLOAT4;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ConditionalIfNode;1656;-880,-2176;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;0;False;3;FLOAT4;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1311;-512,-3328;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1659;-512,-2048;Inherit;False;4;4;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1842;-256,-3328;Inherit;False;Debug_VertexColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1368;-256,-2048;Float;False;Debug_Coords;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;1848;-1792,-4928;Inherit;False;1368;Debug_Coords;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;1849;-1792,-4992;Inherit;False;1842;Debug_VertexColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1850;-1152,-4992;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1878;-1792,-5632;Half;False;Property;_Banner;Banner;0;0;Create;True;0;0;True;1;StyledBanner(Debug Original);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1803;-1344,2944;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.3;False;4;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1843;-1632,2944;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1881;-1600,-5632;Half;False;Property;_Message;Message;1;0;Create;True;0;0;True;1;StyledMessage(Info, Use this shader to debug the original mesh attributes., 0,0);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1880;-1408,-5632;Half;False;Property;_DebugCategory;[ Debug Category ];2;0;Create;True;0;0;True;1;StyledCategory(Debug Mode);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1879;-1184,-5632;Half;False;Property;_AdvancedCategory;[ Advanced Category ];6;0;Create;True;0;0;True;1;StyledCategory(Advanced);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1771;-1088,2944;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1774;-880,2944;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1804;-1792,2944;Inherit;False;Constant;_Float1;Float 1;0;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;1719;-1024,-4992;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SinOpNode;1800;-1472,2944;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1772;-1088,3072;Float;False;Constant;_Float3;Float 3;31;0;Create;True;0;0;False;0;False;24;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1853;-640,-4992;Float;False;True;-1;2;;100;1;BOXOPHOBIC/The Vegetation Engine/Helpers/Debug Original;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;1865;0;1480;0
WireConnection;1869;0;1868;0
WireConnection;1869;1;1854;0
WireConnection;1875;0;1874;0
WireConnection;1875;1;1873;0
WireConnection;1872;0;1871;0
WireConnection;1872;3;1875;0
WireConnection;1857;0;1866;0
WireConnection;1857;3;1869;0
WireConnection;1877;0;1857;0
WireConnection;1877;1;1872;0
WireConnection;1487;0;1877;0
WireConnection;1846;0;1662;1
WireConnection;1846;1;1662;2
WireConnection;1847;0;1663;1
WireConnection;1847;1;1663;2
WireConnection;1844;0;1660;1
WireConnection;1844;1;1660;2
WireConnection;1845;0;1661;1
WireConnection;1845;1;1661;2
WireConnection;1318;0;1366;0
WireConnection;1318;1;1292;3
WireConnection;1286;0;1314;0
WireConnection;1286;1;1384;1
WireConnection;1367;0;1389;0
WireConnection;1367;1;1377;2
WireConnection;1407;0;1339;0
WireConnection;1407;1;1359;0
WireConnection;1407;3;1318;0
WireConnection;1355;0;1386;0
WireConnection;1355;1;1329;0
WireConnection;1355;3;1367;0
WireConnection;1374;0;1283;0
WireConnection;1374;1;1858;0
WireConnection;1374;3;1286;0
WireConnection;1363;0;1307;0
WireConnection;1363;1;1370;0
WireConnection;1363;3;1388;4
WireConnection;1657;0;1647;0
WireConnection;1657;1;1653;0
WireConnection;1657;3;1844;0
WireConnection;1658;0;1652;0
WireConnection;1658;1;1651;0
WireConnection;1658;3;1847;0
WireConnection;1655;0;1645;0
WireConnection;1655;1;1650;0
WireConnection;1655;3;1846;0
WireConnection;1656;0;1648;0
WireConnection;1656;1;1646;0
WireConnection;1656;3;1845;0
WireConnection;1311;0;1374;0
WireConnection;1311;1;1355;0
WireConnection;1311;2;1407;0
WireConnection;1311;3;1363;0
WireConnection;1659;0;1657;0
WireConnection;1659;1;1656;0
WireConnection;1659;2;1655;0
WireConnection;1659;3;1658;0
WireConnection;1842;0;1311;0
WireConnection;1368;0;1659;0
WireConnection;1850;0;1849;0
WireConnection;1850;1;1848;0
WireConnection;1803;0;1800;0
WireConnection;1843;0;1804;0
WireConnection;1774;0;1771;0
WireConnection;1774;1;1772;0
WireConnection;1774;3;1803;0
WireConnection;1719;0;1850;0
WireConnection;1800;0;1843;0
WireConnection;1853;0;1719;0
ASEEND*/
//CHKSM=920A0939102927B9A1BCA5CEC1233076B00B2F00