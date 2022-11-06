Shader /*ase_name*/ "Hidden/BOXOPHOBIC/Amplify Impostors/Standard Lit" /*end*/
{
    Properties
    {
		/*ase_props*/
		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5
    }

    SubShader
    {
		/*ase_subshader_options:Name=Additional Options
			Option:Material Type,InvertActionOnDeselection:Standard,Specular Color:Specular Color
				Standard:ShowPort:Metallic
				Specular Color:ShowPort:Specular
			Option:Receive Shadows:false,true:true
				true:RemoveDefine:_RECEIVE_SHADOWS_OFF 1
				false:SetDefine:_RECEIVE_SHADOWS_OFF 1
			Port:Base:Alpha Clip Threshold
				On:SetDefine:_ALPHATEST_ON 1
				
			Option:Transmission:false,true:false
				false:RemoveDefine:_TRANSMISSION_ASE 1
				false:HidePort:Base:Transmission
				false:HideOption:  Transmission Shadow
				true:SetDefine:_TRANSMISSION_ASE 1
				true:ShowPort:Base:Transmission
				true:ShowOption:  Transmission Shadow
			Field:  Transmission Shadow:Float:0.5:0:1:_TransmissionShadow
				Change:SetMaterialProperty:_TransmissionShadow
				Change:SetShaderProperty:_TransmissionShadow,_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
				Inline,disable:SetShaderProperty:_TransmissionShadow,//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
				
			Option:Translucency:false,true:false
				false:RemoveDefine:_TRANSLUCENCY_ASE 1
				false:HidePort:Base:Translucency
				false:HideOption:  Translucency Strength
				false:HideOption:  Normal Distortion
				false:HideOption:  Scattering
				false:HideOption:  Direct
				false:HideOption:  Ambient
				false:HideOption:  Shadow
				true:SetDefine:_TRANSLUCENCY_ASE 1
				true:ShowPort:Base:Translucency
				true:ShowOption:  Translucency Strength
				true:ShowOption:  Normal Distortion
				true:ShowOption:  Scattering
				true:ShowOption:  Direct
				true:ShowOption:  Ambient
				true:ShowOption:  Shadow
			Field:  Translucency Strength:Float:1:0:50:_TransStrength
				Change:SetMaterialProperty:_TransStrength
				Change:SetShaderProperty:_TransStrength,_TransStrength( "Strength", Range( 0, 50 ) ) = 1
				Inline,disable:SetShaderProperty:_TransStrength,//_TransStrength( "Strength", Range( 0, 50 ) ) = 1
			Field:  Normal Distortion:Float:0.5:0:1:_TransNormal
				Change:SetMaterialProperty:_TransNormal
				Change:SetShaderProperty:_TransNormal,_TransNormal( "Normal Distortion", Range( 0, 1 ) ) = 0.5
				Inline,disable:SetShaderProperty:_TransNormal,//_TransNormal( "Normal Distortion", Range( 0, 1 ) ) = 0.5
			Field:  Scattering:Float:2:1:50:_TransScattering
				Change:SetMaterialProperty:_TransScattering
				Change:SetShaderProperty:_TransScattering,_TransScattering( "Scattering", Range( 1, 50 ) ) = 2
				Inline,disable:SetShaderProperty:_TransScattering,//_TransScattering( "Scattering", Range( 1, 50 ) ) = 2
			Field:  Direct:Float:0.9:0:1:_TransDirect
				Change:SetMaterialProperty:_TransDirect
				Change:SetShaderProperty:_TransDirect,_TransDirect( "Direct", Range( 0, 1 ) ) = 0.9
				Inline,disable:SetShaderProperty:_TransDirect,//_TransDirect( "Direct", Range( 0, 1 ) ) = 0.9
			Field:  Ambient:Float:0.1:0:1:_TransAmbient
				Change:SetMaterialProperty:_TransAmbient
				Change:SetShaderProperty:_TransAmbient,_TransAmbient( "Ambient", Range( 0, 1 ) ) = 0.1
				Inline,disable:SetShaderProperty:_TransAmbient,//_TransAmbient( "Ambient", Range( 0, 1 ) ) = 0.1
			Field:  Shadow:Float:0.5:0:1:_TransShadow
				Change:SetMaterialProperty:_TransShadow
				Change:SetShaderProperty:_TransShadow,_TransShadow( "Shadow", Range( 0, 1 ) ) = 0.5
				Inline,disable:SetShaderProperty:_TransShadow,//_TransShadow( "Shadow", Range( 0, 1 ) ) = 0.5
		*/
        Tags
		{
			"RenderPipeline" = "UniversalPipeline"
			"RenderType"="Opaque"
			"Queue"="Geometry" 
		}

		Cull Back
		HLSLINCLUDE
		#pragma target 3.0

		struct SurfaceOutput
		{
			half3 Albedo;
			half3 Specular;
			half Metallic;
			float3 Normal;
			half3 Emission;
			half Smoothness;
			half Occlusion;
			half Alpha;
		};

		#define AI_RENDERPIPELINE
		ENDHLSL
		/*ase_pass*/
        Pass
        {
			/*ase_pass_options:Name=Misc Options
				Option,_FinalColorxAlpha:Final Color x Alpha:true,false:false
				true:SetDefine:ASE_LW_FINAL_COLOR_ALPHA_MULTIPLY 1
			Port:Baked GI
				On:SetDefine:LIGHTMAP_ON 1
				On:SetDefine:DIRLIGHTMAP_COMBINED 1
				On:SetDefine:CUSTOM_BAKED_GI 1
			*/
			Name "Base"
        	Tags{"LightMode" = "UniversalForward"}

			Blend One Zero
			ZWrite On
			ZTest LEqual
			Offset 0,0
			ColorMask RGBA
            /*ase_stencil*/
        	HLSLPROGRAM
            
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x

        	// -------------------------------------
            // Lightweight Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
            
        	// -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile_fog

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex vert
        	#pragma fragment frag        	

        	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
        	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

			/*ase_pragma*/

            struct GraphVertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				/*ase_vdata:p=p;n=n;t=t;uv0=tc0.xyzw;uv1=tc1.xyzw*/
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

        	struct GraphVertexOutput
            {
                float4 clipPos                : SV_POSITION;
                float4 lightmapUVOrVertexSH	  : TEXCOORD0;
        		half4 fogFactorAndVertexLight : TEXCOORD1; // x: fogFactor, yzw: vertex light
				//#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            	//float4 shadowCoord            : TEXCOORD2;
				//#endif
				/*ase_interp(3,):sp=sp.xyzw;*/
                UNITY_VERTEX_INPUT_INSTANCE_ID
            	UNITY_VERTEX_OUTPUT_STEREO
            };

			CBUFFER_START(UnityPerMaterial)
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			CBUFFER_END
			/*ase_globals*/
			
			/*ase_funcs*/

            GraphVertexOutput vert (GraphVertexInput v/*ase_vert_input*/)
        	{
        		GraphVertexOutput o = (GraphVertexOutput)0;
                UNITY_SETUP_INSTANCE_ID(v);
            	UNITY_TRANSFER_INSTANCE_ID(v, o);
        		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				/*ase_vert_code:v=GraphVertexInput;o=GraphVertexOutput*/
				v.vertex.xyz += /*ase_vert_out:Vertex Offset;Float3;8;-1;_Vertex*/ float3( 0, 0, 0 ) /*end*/;

        		// Vertex shader outputs defined by graph
                float3 lwWNormal = TransformObjectToWorldNormal(v.normal );

                VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);
                
         		// We either sample GI from lightmap or SH.
        	    // Lightmap UV and vertex SH coefficients use the same interpolator ("float2 lightmapUV" for lightmap or "half3 vertexSH" for SH)
                // see DECLARE_LIGHTMAP_OR_SH macro.
        	    // The following funcions initialize the correct variable with correct data
        	    OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy);
        	    OUTPUT_SH(lwWNormal, o.lightmapUVOrVertexSH.xyz);

        	    half3 vertexLight = VertexLighting(vertexInput.positionWS, lwWNormal);
        	    half fogFactor = ComputeFogFactor(vertexInput.positionCS.z);
        	    o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
        	    o.clipPos = vertexInput.positionCS;

				//#if defined( REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR )
				//	o.shadowCoord = GetShadowCoord(vertexInput);
				//#endif
        		return o;
        	}

        	half4 frag (GraphVertexOutput IN, out float outDepth : SV_Depth /*ase_frag_input*/) : SV_Target
            {
            	UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
				
				SurfaceOutput o = (SurfaceOutput)0;
				float4 clipPos = 0;
				float3 worldPos = 0;

				/*ase_frag_code:IN=GraphVertexOutput*/
				
		        float3 Albedo = /*ase_frag_out:Albedo;Float3;0;-1;_Albedo*/float3(0.5, 0.5, 0.5)/*end*/;
				float3 Normal = /*ase_frag_out:World Normal;Float3;1*/float3(0, 0, 1)/*end*/;
				float3 Emission = /*ase_frag_out:Emission;Float3;2;-1;_Emission*/0/*end*/;
				float3 Specular = /*ase_frag_out:Specular;Float3;9*/float3(0.5, 0.5, 0.5)/*end*/;
				float Metallic = /*ase_frag_out:Metallic;Float;3*/0/*end*/;
				float Smoothness = /*ase_frag_out:Smoothness;Float;4*/0.5/*end*/;
				float Occlusion = /*ase_frag_out:Occlusion;Float;5*/1/*end*/;
				float3 Transmission = /*ase_frag_out:Transmission;Float3;14;-1;_Transmission*/1/*end*/;
				float3 Translucency = /*ase_frag_out:Translucency;Float3;15;-1;_Translucency*/1/*end*/;
				float Alpha = /*ase_frag_out:Alpha;Float;6;-1;_Alpha*/1/*end*/;
				float AlphaClipThreshold = /*ase_frag_out:Alpha Clip Threshold;Float;7;-1;_AlphaClip*/0/*end*/;
				float4 bakedGI = /*ase_frag_out:Baked GI;Float4;10;-1;_BakedGI*/float4(0,0,0,0)/*end*/;

				IN.clipPos.zw = clipPos.zw;

				float3 WorldSpaceViewDirection = SafeNormalize( _WorldSpaceCameraPos.xyz - worldPos );

        		InputData inputData;
        		inputData.positionWS = worldPos;

				inputData.normalWS = Normal;

				#if !SHADER_HINT_NICE_QUALITY
					// viewDirection should be normalized here, but we avoid doing it as it's close enough and we save some ALU.
					inputData.viewDirectionWS = WorldSpaceViewDirection;
				#else
					inputData.viewDirectionWS = normalize(WorldSpaceViewDirection);
				#endif

				float4 shadowCoord = 0;
				//#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				//	shadowCoord = IN.shadowCoord;
				//#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					shadowCoord = TransformWorldToShadowCoord( worldPos );
				#endif

        	    inputData.shadowCoord = shadowCoord;

        	    inputData.fogCoord = IN.fogFactorAndVertexLight.x;
        	    inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;

				#if defined(CUSTOM_BAKED_GI)
					half4 decodeInstructions = half4( LIGHTMAP_HDR_MULTIPLIER, LIGHTMAP_HDR_EXPONENT, 0.0h, 0.0h );
					inputData.bakedGI = UnpackLightmapRGBM( bakedGI, decodeInstructions ) * EMISSIVE_RGBM_SCALE;
				#else
                    OUTPUT_SH(inputData.normalWS, IN.lightmapUVOrVertexSH.xyz);
					inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, IN.lightmapUVOrVertexSH.xyz, inputData.normalWS);
				#endif

        		half4 color = UniversalFragmentPBR(
        			inputData, 
        			Albedo, 
        			Metallic, 
        			Specular, 
        			Smoothness, 
        			Occlusion, 
        			Emission, 
        			Alpha);

				// BOXOPHOBIC: Added Transmission and Translucency
				#ifdef _TRANSMISSION_ASE
				{
					float shadow = /*ase_inline_begin*/_TransmissionShadow/*ase_inline_end*/;

					Light mainLight = GetMainLight( inputData.shadowCoord );
					float3 mainAtten = mainLight.color * mainLight.distanceAttenuation;
					mainAtten = lerp( mainAtten, mainAtten * mainLight.shadowAttenuation, shadow );
					half3 mainTransmission = max(0 , -dot(inputData.normalWS, mainLight.direction)) * mainAtten * Transmission;
					color.rgb += Albedo * mainTransmission;

					#ifdef _ADDITIONAL_LIGHTS
						int transPixelLightCount = GetAdditionalLightsCount();
						for (int i = 0; i < transPixelLightCount; ++i)
						{
							Light light = GetAdditionalLight(i, inputData.positionWS);
							float3 atten = light.color * light.distanceAttenuation;
							atten = lerp( atten, atten * light.shadowAttenuation, shadow );

							half3 transmission = max(0 , -dot(inputData.normalWS, light.direction)) * atten * Transmission;
							color.rgb += Albedo * transmission;
						}
					#endif
				}
				#endif

				#ifdef _TRANSLUCENCY_ASE
				{
					float shadow = /*ase_inline_begin*/_TransShadow/*ase_inline_end*/;
					float normal = /*ase_inline_begin*/_TransNormal/*ase_inline_end*/;
					float scattering = /*ase_inline_begin*/_TransScattering/*ase_inline_end*/;
					float direct = /*ase_inline_begin*/_TransDirect/*ase_inline_end*/;
					float ambient = /*ase_inline_begin*/_TransAmbient/*ase_inline_end*/;
					float strength = /*ase_inline_begin*/_TransStrength/*ase_inline_end*/;

					Light mainLight = GetMainLight( inputData.shadowCoord );
					float3 mainAtten = mainLight.color * mainLight.distanceAttenuation;
					mainAtten = lerp( mainAtten, mainAtten * mainLight.shadowAttenuation, shadow );

					half3 mainLightDir = mainLight.direction + inputData.normalWS * normal;
					half mainVdotL = pow( saturate( dot( inputData.viewDirectionWS, -mainLightDir ) ), scattering );
					half3 mainTranslucency = mainAtten * ( mainVdotL * direct + inputData.bakedGI * ambient ) * Translucency;
					color.rgb += Albedo * mainTranslucency * strength;

					#ifdef _ADDITIONAL_LIGHTS
						int transPixelLightCount = GetAdditionalLightsCount();
						for (int i = 0; i < transPixelLightCount; ++i)
						{
							Light light = GetAdditionalLight(i, inputData.positionWS);
							float3 atten = light.color * light.distanceAttenuation;
							atten = lerp( atten, atten * light.shadowAttenuation, shadow );

							half3 lightDir = light.direction + inputData.normalWS * normal;
							half VdotL = pow( saturate( dot( inputData.viewDirectionWS, -lightDir ) ), scattering );
							half3 translucency = atten * ( VdotL * direct + inputData.bakedGI * ambient ) * Translucency;
							color.rgb += Albedo * translucency * strength;
						}
					#endif
				}
				#endif

				#ifdef TERRAIN_SPLAT_ADDPASS
					color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
				#else
					color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
				#endif

				#if _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#if ASE_LW_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif
				outDepth = IN.clipPos.z;
        		return color;
            }

        	ENDHLSL
        }

		/*ase_pass*/
        Pass
        {
			/*ase_hide_pass*/
        	Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}

			ZWrite On
			ZTest LEqual

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            
			#ifndef UNITY_PASS_SHADOWCASTER
			#define UNITY_PASS_SHADOWCASTER
			#endif

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			/*ase_pragma*/

            struct GraphVertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				/*ase_vdata:p=p;n=n;uv0=tc0.xyzw*/
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

        	struct VertexOutput
        	{
        	    float4 clipPos : SV_POSITION;
                /*ase_interp(7,):sp=sp.xyzw;*/
                UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
        	};

            float3 _LightDirection;
			CBUFFER_START(UnityPerMaterial)
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			CBUFFER_END
			/*ase_globals*/
			
			/*ase_funcs*/

            VertexOutput ShadowPassVertex(GraphVertexInput v/*ase_vert_input*/)
        	{
        	    VertexOutput o;
        	    UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				/*ase_vert_code:v=GraphVertexInput;o=GraphVertexOutput*/
				v.vertex.xyz += /*ase_vert_out:Vertex Offset;Float3;2;-1;_Vertex*/ float3(0,0,0) /*end*/;

        	    float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
                float3 normalWS = TransformObjectToWorldDir(v.normal );

                float invNdotL = 1.0 - saturate(dot(_LightDirection, normalWS));
                float scale = invNdotL * _ShadowBias.y;

                // normal bias is negative since we want to apply an inset normal offset
				positionWS = _LightDirection * _ShadowBias.xxx + positionWS;
				positionWS = normalWS * scale.xxx + positionWS;
				float4 clipPos = TransformWorldToHClip( positionWS );

				// no need for shadow bias alteration since we do it in fragment anyway
				o.clipPos = clipPos;

        	    return o;
        	}

            half4 ShadowPassFragment(VertexOutput IN, out float outDepth : SV_Depth /*ase_frag_input*/) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				SurfaceOutput o = (SurfaceOutput)0;
				float4 clipPos = 0;
				float3 worldPos = 0;
				/*ase_frag_code:IN=GraphVertexOutput*/
				IN.clipPos.zw = clipPos.zw;

				float Alpha = /*ase_frag_out:Alpha;Float;0;-1;_Alpha*/1/*end*/;
				float AlphaClipThreshold = /*ase_frag_out:Alpha Clip Threshold;Float;1;-1;_AlphaClip*/AlphaClipThreshold/*end*/;

				#if _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif
				outDepth = IN.clipPos.z;
                return 0;
            }

            ENDHLSL
        }

		/*ase_pass*/
        Pass
        {
			/*ase_hide_pass*/
        	Name "DepthOnly"
            Tags{"LightMode" = "DepthOnly"}

            ZWrite On
			ColorMask 0

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex vert
            #pragma fragment frag			          

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
           
			/*ase_pragma*/

            struct GraphVertexInput
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				/*ase_vdata:p=p;n=n;uv0=tc0.xyzw*/
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };


        	struct VertexOutput
        	{
        	    float4 clipPos      : SV_POSITION;
                /*ase_interp(0,):sp=sp.xyzw;*/
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
        	};

			CBUFFER_START(UnityPerMaterial)
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			CBUFFER_END
			/*ase_globals*/
			
			/*ase_funcs*/

            VertexOutput vert(GraphVertexInput v/*ase_vert_input*/)
            {
                VertexOutput o = (VertexOutput)0;
        	    UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				/*ase_vert_code:v=GraphVertexInput;o=GraphVertexOutput*/
				float3 vertexValue = /*ase_vert_out:Vertex Offset;Float3;2;-1;_Vertex*/ float3(0,0,0) /*end*/;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif

				v.normal = /*ase_vert_out:Vertex Normal;Float3;3;-1;_Normal*/ v.normal /*end*/;

        	    o.clipPos = TransformObjectToHClip(v.vertex.xyz);
        	    return o;
            }

            half4 frag(VertexOutput IN, out float outDepth : SV_Depth /*ase_frag_input*/) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				SurfaceOutput o = (SurfaceOutput)0;
				float4 clipPos = 0;
				float3 worldPos = 0;
				/*ase_frag_code:IN=GraphVertexOutput*/
				IN.clipPos.zw = clipPos.zw;
				float Alpha = /*ase_frag_out:Alpha;Float;0;-1;_Alpha*/1/*end*/;
				float AlphaClipThreshold = /*ase_frag_out:Alpha Clip Threshold;Float;1;-1;_AlphaClip*/AlphaClipThreshold/*end*/;

				#if _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif
				outDepth = IN.clipPos.z;
                return 0;
            }
            ENDHLSL
        }

		/*ase_pass*/
		Pass
		{
			/*ase_hide_pass*/
			Name "SceneSelectionPass"
			Tags{ "LightMode" = "SceneSelectionPass" }

			ZWrite On
			ColorMask 0

			HLSLPROGRAM
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma multi_compile_instancing

			#pragma vertex vert
			#pragma fragment frag				

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"			

			int _ObjectId;
			int _PassValue;

			/*ase_pragma*/

			struct GraphVertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				/*ase_vdata:p=p;n=n;uv0=tc0*/
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};


			struct VertexOutput
			{
				float4 clipPos      : SV_POSITION;
				/*ase_interp(0,):sp=sp.xyzw;*/
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			CBUFFER_END

			/*ase_globals*/

			/*ase_funcs*/

			VertexOutput vert(GraphVertexInput v/*ase_vert_input*/)
            {
                VertexOutput o = (VertexOutput)0;
        	    UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				/*ase_vert_code:v=GraphVertexInput;o=GraphVertexOutput*/
				float3 vertexValue = /*ase_vert_out:Vertex Offset;Float3;2;-1;_Vertex*/ float3(0,0,0) /*end*/;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif

				v.normal = /*ase_vert_out:Vertex Normal;Float3;3;-1;_Normal*/ v.normal /*end*/;

        	    o.clipPos = TransformObjectToHClip(v.vertex.xyz);
        	    return o;
            }

			half4 frag(VertexOutput IN, out float outDepth : SV_Depth /*ase_frag_input*/) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);
				SurfaceOutput o = (SurfaceOutput)0;
				float4 clipPos = 0;
				float3 worldPos = 0;
				/*ase_frag_code:IN=GraphVertexOutput*/
				IN.clipPos.zw = clipPos.zw;
				float Alpha = /*ase_frag_out:Alpha;Float;0;-1;_Alpha*/1/*end*/;
				float AlphaClipThreshold = /*ase_frag_out:Alpha Clip Threshold;Float;1;-1;_AlphaClip*/AlphaClipThreshold/*end*/;

				#if _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				outDepth = IN.clipPos.z;
				return float4( _ObjectId, _PassValue, 1.0, 1.0 );
            }
			ENDHLSL
		}

		/*ase_pass*/
        Pass
        {
			/*ase_hide_pass*/
        	Name "Meta"
            Tags{"LightMode" = "Meta"}

            Cull Off

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            

            #pragma vertex vert
            #pragma fragment frag            

			uniform float4 _MainTex_ST;

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature EDITOR_VISUALIZATION

			/*ase_pragma*/

            struct GraphVertexInput
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				/*ase_vdata:p=p;n=n;uv1=tc1;uv0=tc0.xyzw*/
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

        	struct VertexOutput
        	{
        	    float4 clipPos      : SV_POSITION;
                /*ase_interp(0,):sp=sp.xyzw;uv1=tc1*/
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
        	};

			CBUFFER_START(UnityPerMaterial)
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			CBUFFER_END

			/*ase_globals*/
			
			/*ase_funcs*/

            VertexOutput vert(GraphVertexInput v/*ase_vert_input*/)
            {
                VertexOutput o = (VertexOutput)0;
        	    UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				/*ase_vert_code:v=GraphVertexInput;o=GraphVertexOutput*/

				float3 vertexValue = /*ase_vert_out:Vertex Offset;Float3;4;-1;_Vertex*/ float3(0,0,0) /*end*/;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif

				v.normal = /*ase_vert_out:Vertex Normal;Float3;5;-1;_Normal*/ v.normal /*end*/;
				
#if !defined( ASE_SRP_VERSION ) || ASE_SRP_VERSION  > 51300                
				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );
#else
				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST );
#endif
        	    return o;
            }

            half4 frag(VertexOutput IN, out float outDepth : SV_Depth /*ase_frag_input*/) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);
				SurfaceOutput o = (SurfaceOutput)0;
				float4 clipPos = 0;
				float3 worldPos = 0;
           		/*ase_frag_code:IN=GraphVertexOutput*/
				IN.clipPos.zw = clipPos.zw;
		        float3 Albedo = /*ase_frag_out:Albedo;Float3;0;-1;_Albedo*/float3(0.5, 0.5, 0.5)/*end*/;
				float3 Emission = /*ase_frag_out:Emission;Float3;1;-1;_Emission*/0/*end*/;
				float Alpha = /*ase_frag_out:Alpha;Float;2;-1;_Alpha*/1/*end*/;
				float AlphaClipThreshold = /*ase_frag_out:Alpha Clip Threshold;Float;3;-1;_AlphaClip*/0/*end*/;

				#if _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif
				outDepth = IN.clipPos.z;
                MetaInput metaInput = (MetaInput)0;
                metaInput.Albedo = Albedo;
                metaInput.Emission = Emission;
                
                return MetaFragment(metaInput);
            }
            ENDHLSL
        }
		/*ase_pass_end*/
    }
    FallBack "Hidden/InternalErrorShader"
	CustomEditor "ASEMaterialInspector"
}
