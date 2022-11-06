// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BOXOPHOBIC/The Vegetation Engine/Helpers/Debug Globals"
{
	Properties
	{
		[StyledBanner(Debug Globals)]_Banner("Banner", Float) = 0
		[StyledMessage(Info, Use this shader on a big plane to debug the element and noise textures used in the scene., 0,0)]_Message("Message", Float) = 0
		[HideInInspector]_vertex_pivot_mode("_vertex_pivot_mode", Float) = 0
		[StyledCategory(Debug Mode)]_DebugCategory("[ Debug Category ]", Float) = 0
		[Enum(Motion Texture,100,Colors Texture,200,Extras Texture,300,Noise Texture,400)]_DebugMode("Debug Mode", Float) = 100
		[Enum(Direction XZ,0,Wind Power,1,Interaction Mask,2)][Space(10)]_MotionTexture("Motion Texture", Float) = 0
		[Enum(Color Tinting,0,Healthiness,1)]_ColorsTexture("Colors Texture", Float) = 0
		[Enum(Leaves,0,Size,1,Overlay,2,Wetness,3)]_ExtrasTexture("Extras Texture", Float) = 0
		[Enum(Red,0,Green,1,Blue,2,Alpha,3)]_NoiseTexture("Noise Texture", Float) = 0
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
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define TVE_VERTEX_DATA_BATCHED


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
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
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform half _AdvancedCategory;
			uniform half _Message;
			uniform half _DebugCategory;
			uniform half _Banner;
			uniform half _DebugMode;
			uniform half _MotionTexture;
			uniform half _ColorsTexture;
			uniform half _ExtrasTexture;
			uniform half _NoiseTexture;
			uniform sampler2D TVE_MotionTex;
			uniform half4 TVE_VolumeCoord;
			uniform half _vertex_pivot_mode;
			uniform sampler2D TVE_MotionTex_Vegetation;
			uniform sampler2D TVE_MotionTex_Grass;
			uniform sampler2D TVE_MotionTex_Objects;
			uniform sampler2D TVE_MotionTex_User;
			uniform sampler2D TVE_ColorsTex;
			uniform sampler2D TVE_ColorsTex_Vegetation;
			uniform sampler2D TVE_ColorsTex_Grass;
			uniform sampler2D TVE_ColorsTex_Objects;
			uniform sampler2D TVE_ColorsTex_User;
			uniform sampler2D TVE_ExtrasTex;
			uniform sampler2D TVE_ExtrasTex_Vegetation;
			uniform sampler2D TVE_ExtrasTex_Grass;
			uniform sampler2D TVE_ExtrasTex_Objects;
			uniform sampler2D TVE_ExtrasTex_User;
			uniform sampler2D TVE_NoiseTex;
			uniform float2 TVE_NoiseSpeed_Vegetation;
			uniform float2 TVE_NoiseSpeed_Grass;
			uniform half TVE_NoiseSize_Vegetation;
			uniform half TVE_NoiseSize_Grass;
			uniform half TVE_NoiseContrast;
			half4 USE_BUFFERS( half4 Legacy, half4 Vegetation, half4 Grass, half4 Objects, half4 Custom )
			{
				#if defined (TVE_IS_VEGETATION_SHADER)
				return Vegetation;
				#elif defined (TVE_IS_GRASS_SHADER)
				return Grass;
				#elif defined (TVE_IS_OBJECT_SHADER)
				return Objects;
				#elif defined (TVE_IS_CUSTOM_SHADER)
				return Custom;
				#else
				return Legacy;
				#endif
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1 = v.vertex;
				o.ase_texcoord2 = v.ase_texcoord;
				o.ase_texcoord3 = v.ase_texcoord3;
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
				ifLocalVar1857 = ( Debug_Mode1865 + _MotionTexture );
				float ifLocalVar1872 = 0;
				UNITY_BRANCH 
				if( Debug_Mode1865 == 200.0 )
				ifLocalVar1872 = ( Debug_Mode1865 + _ColorsTexture );
				float ifLocalVar1884 = 0;
				UNITY_BRANCH 
				if( Debug_Mode1865 == 300.0 )
				ifLocalVar1884 = ( Debug_Mode1865 + _ExtrasTexture );
				float ifLocalVar1936 = 0;
				UNITY_BRANCH 
				if( Debug_Mode1865 == 400.0 )
				ifLocalVar1936 = ( Debug_Mode1865 + _NoiseTexture );
				half Debug_Out1487 = ( ifLocalVar1857 + ifLocalVar1872 + ifLocalVar1884 + ifLocalVar1936 );
				float4x4 break19_g1767 = unity_ObjectToWorld;
				float3 appendResult20_g1767 = (float3(break19_g1767[ 0 ][ 3 ] , break19_g1767[ 1 ][ 3 ] , break19_g1767[ 2 ][ 3 ]));
				half3 Off19_g1768 = appendResult20_g1767;
				float4 transform68_g1767 = mul(unity_ObjectToWorld,i.ase_texcoord1);
				float3 appendResult93_g1767 = (float3(i.ase_texcoord2.z , i.ase_texcoord3.w , i.ase_texcoord2.w));
				float4 transform62_g1767 = mul(unity_ObjectToWorld,float4( ( i.ase_texcoord1.xyz - ( appendResult93_g1767 * _vertex_pivot_mode ) ) , 0.0 ));
				float3 ObjectPositionWithPivots28_g1767 = ( (transform68_g1767).xyz - (transform62_g1767).xyz );
				half3 On20_g1768 = ObjectPositionWithPivots28_g1767;
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g1768 = On20_g1768;
				#else
				float3 staticSwitch14_g1768 = Off19_g1768;
				#endif
				half3 ObjectData20_g1769 = staticSwitch14_g1768;
				half3 WorldData19_g1769 = Off19_g1768;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g1769 = WorldData19_g1769;
				#else
				float3 staticSwitch14_g1769 = ObjectData20_g1769;
				#endif
				float3 temp_output_42_0_g1767 = staticSwitch14_g1769;
				half3 ObjectData20_g1772 = temp_output_42_0_g1767;
				half3 WorldData19_g1772 = WorldPosition;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g1772 = WorldData19_g1772;
				#else
				float3 staticSwitch14_g1772 = ObjectData20_g1772;
				#endif
				float2 temp_output_39_38_g1 = ( (TVE_VolumeCoord).zw + ( (TVE_VolumeCoord).xy * (staticSwitch14_g1772).xz ) );
				half4 Legacy33_g1773 = tex2D( TVE_MotionTex, temp_output_39_38_g1 );
				half4 Vegetation33_g1773 = tex2D( TVE_MotionTex_Vegetation, temp_output_39_38_g1 );
				half4 Grass33_g1773 = tex2D( TVE_MotionTex_Grass, temp_output_39_38_g1 );
				half4 Objects33_g1773 = tex2D( TVE_MotionTex_Objects, temp_output_39_38_g1 );
				half4 Custom33_g1773 = tex2D( TVE_MotionTex_User, temp_output_39_38_g1 );
				half4 localUSE_BUFFERS33_g1773 = USE_BUFFERS( Legacy33_g1773 , Vegetation33_g1773 , Grass33_g1773 , Objects33_g1773 , Custom33_g1773 );
				float4 break1927 = localUSE_BUFFERS33_g1773;
				float3 appendResult1956 = (float3(break1927.x , break1927.y , 0.0));
				float3 ifLocalVar1374 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 100.0 )
				ifLocalVar1374 = appendResult1956;
				float3 appendResult1957 = (float3(0.0 , 0.0 , break1927.z));
				float3 ifLocalVar1355 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 101.0 )
				ifLocalVar1355 = appendResult1957;
				float3 appendResult1958 = (float3(break1927.w , break1927.w , break1927.w));
				float3 ifLocalVar1407 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 102.0 )
				ifLocalVar1407 = appendResult1958;
				float3 Debug_Motion1842 = ( ifLocalVar1374 + ifLocalVar1355 + ifLocalVar1407 );
				float4x4 break19_g1840 = unity_ObjectToWorld;
				float3 appendResult20_g1840 = (float3(break19_g1840[ 0 ][ 3 ] , break19_g1840[ 1 ][ 3 ] , break19_g1840[ 2 ][ 3 ]));
				half3 Off19_g1841 = appendResult20_g1840;
				float4 transform68_g1840 = mul(unity_ObjectToWorld,i.ase_texcoord1);
				float3 appendResult95_g1840 = (float3(i.ase_texcoord2.z , 0.0 , i.ase_texcoord2.w));
				float4 transform62_g1840 = mul(unity_ObjectToWorld,float4( ( i.ase_texcoord1.xyz - ( appendResult95_g1840 * _vertex_pivot_mode ) ) , 0.0 ));
				float3 ObjectPositionWithPivots28_g1840 = ( (transform68_g1840).xyz - (transform62_g1840).xyz );
				half3 On20_g1841 = ObjectPositionWithPivots28_g1840;
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g1841 = On20_g1841;
				#else
				float3 staticSwitch14_g1841 = Off19_g1841;
				#endif
				half3 ObjectData20_g1842 = staticSwitch14_g1841;
				half3 WorldData19_g1842 = Off19_g1841;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g1842 = WorldData19_g1842;
				#else
				float3 staticSwitch14_g1842 = ObjectData20_g1842;
				#endif
				float3 temp_output_42_0_g1840 = staticSwitch14_g1842;
				half3 ObjectData20_g1846 = temp_output_42_0_g1840;
				half3 WorldData19_g1846 = WorldPosition;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g1846 = WorldData19_g1846;
				#else
				float3 staticSwitch14_g1846 = ObjectData20_g1846;
				#endif
				float2 temp_output_35_38_g1839 = ( (TVE_VolumeCoord).zw + ( (TVE_VolumeCoord).xy * (staticSwitch14_g1846).xz ) );
				half4 Legacy33_g1845 = tex2D( TVE_ColorsTex, temp_output_35_38_g1839 );
				half4 Vegetation33_g1845 = tex2D( TVE_ColorsTex_Vegetation, temp_output_35_38_g1839 );
				half4 Grass33_g1845 = tex2D( TVE_ColorsTex_Grass, temp_output_35_38_g1839 );
				half4 Objects33_g1845 = tex2D( TVE_ColorsTex_Objects, temp_output_35_38_g1839 );
				half4 Custom33_g1845 = tex2D( TVE_ColorsTex_User, temp_output_35_38_g1839 );
				half4 localUSE_BUFFERS33_g1845 = USE_BUFFERS( Legacy33_g1845 , Vegetation33_g1845 , Grass33_g1845 , Objects33_g1845 , Custom33_g1845 );
				float4 temp_output_45_0_g1839 = localUSE_BUFFERS33_g1845;
				float3 ifLocalVar1911 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 200.0 )
				ifLocalVar1911 = (temp_output_45_0_g1839).xyz;
				float ifLocalVar1912 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 201.0 )
				ifLocalVar1912 = (temp_output_45_0_g1839).w;
				float3 Debug_Colors1922 = ( ifLocalVar1911 + ifLocalVar1912 );
				float4x4 break19_g1833 = unity_ObjectToWorld;
				float3 appendResult20_g1833 = (float3(break19_g1833[ 0 ][ 3 ] , break19_g1833[ 1 ][ 3 ] , break19_g1833[ 2 ][ 3 ]));
				half3 Off19_g1834 = appendResult20_g1833;
				float4 transform68_g1833 = mul(unity_ObjectToWorld,i.ase_texcoord1);
				float3 appendResult95_g1833 = (float3(i.ase_texcoord2.z , 0.0 , i.ase_texcoord2.w));
				float4 transform62_g1833 = mul(unity_ObjectToWorld,float4( ( i.ase_texcoord1.xyz - ( appendResult95_g1833 * _vertex_pivot_mode ) ) , 0.0 ));
				float3 ObjectPositionWithPivots28_g1833 = ( (transform68_g1833).xyz - (transform62_g1833).xyz );
				half3 On20_g1834 = ObjectPositionWithPivots28_g1833;
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g1834 = On20_g1834;
				#else
				float3 staticSwitch14_g1834 = Off19_g1834;
				#endif
				half3 ObjectData20_g1835 = staticSwitch14_g1834;
				half3 WorldData19_g1835 = Off19_g1834;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g1835 = WorldData19_g1835;
				#else
				float3 staticSwitch14_g1835 = ObjectData20_g1835;
				#endif
				float3 temp_output_42_0_g1833 = staticSwitch14_g1835;
				half3 ObjectData20_g1832 = temp_output_42_0_g1833;
				half3 WorldData19_g1832 = WorldPosition;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g1832 = WorldData19_g1832;
				#else
				float3 staticSwitch14_g1832 = ObjectData20_g1832;
				#endif
				float2 temp_output_43_38_g1830 = ( (TVE_VolumeCoord).zw + ( (TVE_VolumeCoord).xy * (staticSwitch14_g1832).xz ) );
				half4 Legacy33_g1831 = tex2D( TVE_ExtrasTex, temp_output_43_38_g1830 );
				half4 Vegetation33_g1831 = tex2D( TVE_ExtrasTex_Vegetation, temp_output_43_38_g1830 );
				half4 Grass33_g1831 = tex2D( TVE_ExtrasTex_Grass, temp_output_43_38_g1830 );
				half4 Objects33_g1831 = tex2D( TVE_ExtrasTex_Objects, temp_output_43_38_g1830 );
				half4 Custom33_g1831 = tex2D( TVE_ExtrasTex_User, temp_output_43_38_g1830 );
				half4 localUSE_BUFFERS33_g1831 = USE_BUFFERS( Legacy33_g1831 , Vegetation33_g1831 , Grass33_g1831 , Objects33_g1831 , Custom33_g1831 );
				float4 break49_g1830 = localUSE_BUFFERS33_g1831;
				float ifLocalVar1657 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 300.0 )
				ifLocalVar1657 = break49_g1830.x;
				float ifLocalVar1656 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 301.0 )
				ifLocalVar1656 = break49_g1830.y;
				float ifLocalVar1655 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 302.0 )
				ifLocalVar1655 = break49_g1830.z;
				float ifLocalVar1931 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 303.0 )
				ifLocalVar1931 = break49_g1830.w;
				float Debug_Extras1368 = ( ifLocalVar1657 + ifLocalVar1656 + ifLocalVar1655 + ifLocalVar1931 );
				#ifdef TVE_IS_GRASS_SHADER
				float2 staticSwitch160_g1848 = TVE_NoiseSpeed_Grass;
				#else
				float2 staticSwitch160_g1848 = TVE_NoiseSpeed_Vegetation;
				#endif
				float4x4 break19_g1850 = unity_ObjectToWorld;
				float3 appendResult20_g1850 = (float3(break19_g1850[ 0 ][ 3 ] , break19_g1850[ 1 ][ 3 ] , break19_g1850[ 2 ][ 3 ]));
				half3 Off19_g1851 = appendResult20_g1850;
				float4 transform68_g1850 = mul(unity_ObjectToWorld,i.ase_texcoord1);
				float3 appendResult95_g1850 = (float3(i.ase_texcoord2.z , 0.0 , i.ase_texcoord2.w));
				float4 transform62_g1850 = mul(unity_ObjectToWorld,float4( ( i.ase_texcoord1.xyz - ( appendResult95_g1850 * _vertex_pivot_mode ) ) , 0.0 ));
				float3 ObjectPositionWithPivots28_g1850 = ( (transform68_g1850).xyz - (transform62_g1850).xyz );
				half3 On20_g1851 = ObjectPositionWithPivots28_g1850;
				#ifdef TVE_PIVOT_DATA_BAKED
				float3 staticSwitch14_g1851 = On20_g1851;
				#else
				float3 staticSwitch14_g1851 = Off19_g1851;
				#endif
				half3 ObjectData20_g1852 = staticSwitch14_g1851;
				half3 WorldData19_g1852 = Off19_g1851;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g1852 = WorldData19_g1852;
				#else
				float3 staticSwitch14_g1852 = ObjectData20_g1852;
				#endif
				float3 temp_output_42_0_g1850 = staticSwitch14_g1852;
				half3 ObjectData20_g1849 = temp_output_42_0_g1850;
				half3 WorldData19_g1849 = WorldPosition;
				#ifdef TVE_VERTEX_DATA_BATCHED
				float3 staticSwitch14_g1849 = WorldData19_g1849;
				#else
				float3 staticSwitch14_g1849 = ObjectData20_g1849;
				#endif
				#ifdef TVE_IS_GRASS_SHADER
				float2 staticSwitch164_g1848 = (WorldPosition).xz;
				#else
				float2 staticSwitch164_g1848 = (staticSwitch14_g1849).xz;
				#endif
				#ifdef TVE_IS_GRASS_SHADER
				float staticSwitch161_g1848 = TVE_NoiseSize_Grass;
				#else
				float staticSwitch161_g1848 = TVE_NoiseSize_Vegetation;
				#endif
				float2 panner73_g1848 = ( _Time.y * staticSwitch160_g1848 + ( staticSwitch164_g1848 * staticSwitch161_g1848 ));
				float4 tex2DNode75_g1848 = tex2D( TVE_NoiseTex, panner73_g1848 );
				float4 saferPower77_g1848 = max( abs( tex2DNode75_g1848 ) , 0.0001 );
				float4 temp_cast_19 = (TVE_NoiseContrast).xxxx;
				float4 break142_g1848 = pow( saferPower77_g1848 , temp_cast_19 );
				float ifLocalVar1948 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 400.0 )
				ifLocalVar1948 = break142_g1848.r;
				float ifLocalVar1949 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 401.0 )
				ifLocalVar1949 = break142_g1848.g;
				float ifLocalVar1947 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 402.0 )
				ifLocalVar1947 = break142_g1848.b;
				float ifLocalVar1950 = 0;
				UNITY_BRANCH 
				if( Debug_Out1487 == 403.0 )
				ifLocalVar1950 = break142_g1848.a;
				float Debug_Noise1952 = ( ifLocalVar1948 + ifLocalVar1949 + ifLocalVar1947 + ifLocalVar1950 );
				
				
				finalColor = float4( ( Debug_Motion1842 + Debug_Colors1922 + Debug_Extras1368 + Debug_Noise1952 ) , 0.0 );
				return finalColor;
			}
			ENDCG
		}
	}
	
	
	
}
/*ASEBEGIN
Version=18600
1927;1;1906;1020;2376.6;5111.742;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;1480;-1792,-5888;Half;False;Property;_DebugMode;Debug Mode;27;1;[Enum];Create;True;4;Motion Texture;100;Colors Texture;200;Extras Texture;300;Noise Texture;400;0;True;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1865;-1536,-5888;Inherit;False;Debug_Mode;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1886;-1792,-4480;Half;False;Property;_ExtrasTexture;Extras Texture;34;1;[Enum];Create;True;4;Leaves;0;Size;1;Overlay;2;Wetness;3;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1874;-1792,-4800;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1881;-1792,-4544;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1937;-1792,-4224;Half;False;Property;_NoiseTexture;Noise Texture;35;1;[Enum];Create;True;4;Red;0;Green;1;Blue;2;Alpha;3;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1933;-1792,-4288;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1873;-1792,-4736;Half;False;Property;_ColorsTexture;Colors Texture;33;1;[Enum];Create;True;2;Color Tinting;0;Healthiness;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1854;-1792,-4992;Half;False;Property;_MotionTexture;Motion Texture;32;1;[Enum];Create;True;3;Direction XZ;0;Wind Power;1;Interaction Mask;2;0;True;1;Space(10);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1868;-1792,-5056;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1885;-1792,-4608;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1871;-1792,-4864;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1935;-1536,-4288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1875;-1536,-4800;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1934;-1792,-4352;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1883;-1536,-4544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1869;-1536,-5056;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1866;-1792,-5120;Inherit;False;1865;Debug_Mode;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1936;-1280,-4352;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;400;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1857;-1280,-5120;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;100;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1872;-1280,-4864;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;200;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1884;-1280,-4608;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;300;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1877;-896,-5120;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1926;-1792,-3712;Inherit;False;Get Global Tex Motion;18;;1;bf9f22898fbdc044d83d042fd0f99232;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1487;-640,-5120;Half;False;Debug_Out;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1927;-1536,-3712;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;1646;-1088,-1152;Float;False;Constant;_Float4;Float 4;31;0;Create;True;0;0;False;0;False;301;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1910;-1088,-2432;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1929;-1088,-768;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1941;-1088,384;Float;False;Constant;_Float10;Float 5;31;0;Create;True;0;0;False;0;False;402;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1928;-1792,-2432;Inherit;False;Get Global Tex Colors;2;;1839;2c21b5ce1449c5a47981c1b0527685e0;0;0;2;FLOAT3;0;FLOAT;34
Node;AmplifyShaderEditor.GetLocalVarNode;1386;-1088,-3456;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1339;-1088,-3200;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1908;-1088,-2176;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1956;-1280,-3712;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1943;-1088,-256;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1958;-1280,-3392;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;1957;-1280,-3552;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1944;-1088,-128;Float;False;Constant;_Float11;Float 7;31;0;Create;True;0;0;False;0;False;400;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1953;-1792,-256;Inherit;False;Get Global Tex Noise;28;;1848;04d4237c6f1a31e419b48d242465f453;0;0;5;FLOAT;85;FLOAT;140;FLOAT;141;FLOAT;147;FLOAT;153
Node;AmplifyShaderEditor.GetLocalVarNode;1938;-1088,256;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1942;-1088,512;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1930;-1088,-640;Float;False;Constant;_Float6;Float 5;31;0;Create;True;0;0;False;0;False;303;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1653;-1088,-1408;Float;False;Constant;_Float7;Float 7;31;0;Create;True;0;0;False;0;False;300;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1945;-1088,0;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1359;-1088,-3072;Float;False;Constant;_Float21;Float 21;31;0;Create;True;0;0;False;0;False;102;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1329;-1088,-3328;Float;False;Constant;_Float9;Float 9;31;0;Create;True;0;0;False;0;False;101;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1648;-1088,-1280;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1283;-1088,-3712;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1939;-1088,640;Float;False;Constant;_Float8;Float 5;31;0;Create;True;0;0;False;0;False;403;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1907;-1088,-2304;Float;False;Constant;_Float2;Float 2;31;0;Create;True;0;0;False;0;False;200;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1647;-1088,-1536;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1946;-1088,128;Float;False;Constant;_Float12;Float 4;31;0;Create;True;0;0;False;0;False;401;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1858;-1088,-3584;Float;False;Constant;_Float3;Float 3;31;0;Create;True;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1645;-1088,-1024;Inherit;False;1487;Debug_Out;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1650;-1088,-896;Float;False;Constant;_Float5;Float 5;31;0;Create;True;0;0;False;0;False;302;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1932;-1792,-1536;Inherit;False;Get Global Tex Extras;10;;1830;35728de760029a6459b976c78935d00f;0;0;4;FLOAT;19;FLOAT;21;FLOAT;22;FLOAT;33
Node;AmplifyShaderEditor.RangedFloatNode;1909;-1088,-2048;Float;False;Constant;_Float1;Float 1;31;0;Create;True;0;0;False;0;False;201;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1948;-880,-256;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1656;-880,-1280;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1950;-880,512;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;3;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1949;-880,0;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1657;-880,-1536;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1374;-880,-3712;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ConditionalIfNode;1355;-880,-3456;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ConditionalIfNode;1931;-880,-768;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;3;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1407;-880,-3200;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;3;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ConditionalIfNode;1947;-880,256;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;3;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1912;-880,-2176;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1655;-880,-1024;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;3;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1911;-880,-2432;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1311;-512,-3328;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1913;-512,-2176;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1951;-512,0;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1659;-512,-1280;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1368;-256,-1280;Float;False;Debug_Extras;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1842;-256,-3328;Inherit;False;Debug_Motion;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1922;-256,-2176;Inherit;False;Debug_Colors;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1952;-256,0;Float;False;Debug_Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1849;-1792,-5504;Inherit;False;1842;Debug_Motion;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1923;-1792,-5440;Inherit;False;1922;Debug_Colors;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1848;-1792,-5376;Inherit;False;1368;Debug_Extras;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1954;-1792,-5312;Inherit;False;1952;Debug_Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1880;-1408,-6144;Half;False;Property;_DebugCategory;[ Debug Category ];26;0;Create;True;0;0;True;1;StyledCategory(Debug Mode);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1878;-1792,-6144;Half;False;Property;_Banner;Banner;0;0;Create;True;0;0;True;1;StyledBanner(Debug Globals);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1955;-896,-6144;Inherit;False;Use TVE_VERTEX_DATA_BATCHED;-1;;1855;749c61e1189c7f8408d9e6db94560d1d;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1850;-1152,-5504;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1879;-1184,-6144;Half;False;Property;_AdvancedCategory;[ Advanced Category ];36;0;Create;True;0;0;True;1;StyledCategory(Advanced);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1925;-1600,-6144;Half;False;Property;_Message;Message;1;0;Create;True;0;0;True;1;StyledMessage(Info, Use this shader on a big plane to debug the element and noise textures used in the scene., 0,0);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1853;-640,-5504;Float;False;True;-1;2;;100;1;BOXOPHOBIC/The Vegetation Engine/Helpers/Debug Globals;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;2;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;1865;0;1480;0
WireConnection;1935;0;1933;0
WireConnection;1935;1;1937;0
WireConnection;1875;0;1874;0
WireConnection;1875;1;1873;0
WireConnection;1883;0;1881;0
WireConnection;1883;1;1886;0
WireConnection;1869;0;1868;0
WireConnection;1869;1;1854;0
WireConnection;1936;0;1934;0
WireConnection;1936;3;1935;0
WireConnection;1857;0;1866;0
WireConnection;1857;3;1869;0
WireConnection;1872;0;1871;0
WireConnection;1872;3;1875;0
WireConnection;1884;0;1885;0
WireConnection;1884;3;1883;0
WireConnection;1877;0;1857;0
WireConnection;1877;1;1872;0
WireConnection;1877;2;1884;0
WireConnection;1877;3;1936;0
WireConnection;1487;0;1877;0
WireConnection;1927;0;1926;0
WireConnection;1956;0;1927;0
WireConnection;1956;1;1927;1
WireConnection;1958;0;1927;3
WireConnection;1958;1;1927;3
WireConnection;1958;2;1927;3
WireConnection;1957;2;1927;2
WireConnection;1948;0;1943;0
WireConnection;1948;1;1944;0
WireConnection;1948;3;1953;85
WireConnection;1656;0;1648;0
WireConnection;1656;1;1646;0
WireConnection;1656;3;1932;21
WireConnection;1950;0;1942;0
WireConnection;1950;1;1939;0
WireConnection;1950;3;1953;147
WireConnection;1949;0;1945;0
WireConnection;1949;1;1946;0
WireConnection;1949;3;1953;140
WireConnection;1657;0;1647;0
WireConnection;1657;1;1653;0
WireConnection;1657;3;1932;19
WireConnection;1374;0;1283;0
WireConnection;1374;1;1858;0
WireConnection;1374;3;1956;0
WireConnection;1355;0;1386;0
WireConnection;1355;1;1329;0
WireConnection;1355;3;1957;0
WireConnection;1931;0;1929;0
WireConnection;1931;1;1930;0
WireConnection;1931;3;1932;33
WireConnection;1407;0;1339;0
WireConnection;1407;1;1359;0
WireConnection;1407;3;1958;0
WireConnection;1947;0;1938;0
WireConnection;1947;1;1941;0
WireConnection;1947;3;1953;141
WireConnection;1912;0;1908;0
WireConnection;1912;1;1909;0
WireConnection;1912;3;1928;34
WireConnection;1655;0;1645;0
WireConnection;1655;1;1650;0
WireConnection;1655;3;1932;22
WireConnection;1911;0;1910;0
WireConnection;1911;1;1907;0
WireConnection;1911;3;1928;0
WireConnection;1311;0;1374;0
WireConnection;1311;1;1355;0
WireConnection;1311;2;1407;0
WireConnection;1913;0;1911;0
WireConnection;1913;1;1912;0
WireConnection;1951;0;1948;0
WireConnection;1951;1;1949;0
WireConnection;1951;2;1947;0
WireConnection;1951;3;1950;0
WireConnection;1659;0;1657;0
WireConnection;1659;1;1656;0
WireConnection;1659;2;1655;0
WireConnection;1659;3;1931;0
WireConnection;1368;0;1659;0
WireConnection;1842;0;1311;0
WireConnection;1922;0;1913;0
WireConnection;1952;0;1951;0
WireConnection;1850;0;1849;0
WireConnection;1850;1;1923;0
WireConnection;1850;2;1848;0
WireConnection;1850;3;1954;0
WireConnection;1853;0;1850;0
ASEEND*/
//CHKSM=A158F07DFCB47B6E13473FC986D5FB323BEFCF9D