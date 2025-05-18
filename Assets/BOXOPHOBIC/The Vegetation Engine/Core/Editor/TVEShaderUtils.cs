//Cristian Pop - https://boxophobic.com/

using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

namespace TheVegetationEngine
{
    public class TVEShaderUtils
    {
        public static string[] RenderEngineOptions =
        {
        "Unity Default Renderer",
        "Vegetation Studio (Instanced Indirect)",
        "Vegetation Studio 1.4.5+ (Instanced Indirect)",
        "Mega World Quadro Renderer (Instanced Indirect)",
        "Nature Renderer (Procedural Instancing)",
        "GPU Instancer (Instanced Indirect)",
        "1msRenderVegetation (Instanced Indirect)",
        "1msRenderVegetation (Instanced Indirect float4x4)",
        };

        public static void SetMaterialSettings(Material material)
        {
            var shaderName = material.shader.name;

            if (!material.HasProperty("_IsTVEShader"))
            {
                return;
            }

            // Set Internal Render Values
            if (material.HasProperty("_RenderMode"))
            {
                material.SetInt("_render_mode", material.GetInt("_RenderMode"));
            }

            if (material.HasProperty("_RenderCull"))
            {
                material.SetInt("_render_cull", material.GetInt("_RenderCull"));
            }

            if (material.HasProperty("_RenderNormals"))
            {
                material.SetInt("_render_normals", material.GetInt("_RenderNormals"));
            }

            if (material.HasProperty("_RenderZWrite"))
            {
                material.SetInt("_render_zw", material.GetInt("_RenderZWrite"));
            }

            if (material.HasProperty("_RenderClip"))
            {
                material.SetInt("_render_clip", material.GetInt("_RenderClip"));
            }

            // Set Render Mode
            if (material.HasProperty("_RenderMode") /* && material.HasProperty("_RenderBlend") */)
            {
                int mode = material.GetInt("_RenderMode");
                //int blend = material.GetInt("_RenderBlend");
                int zwrite = material.GetInt("_RenderZWrite");

                // Opaque
                if (mode == 0)
                {
                    material.SetOverrideTag("RenderType", "AlphaTest");
                    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.AlphaTest;

                    // Standard and Universal Render Pipeline
                    material.SetInt("_render_src", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_render_dst", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_render_zw", 1);
                    material.SetInt("_render_premul", 0);

                    // Set Main Color alpha to 1
                    if (material.HasProperty("_MainColor"))
                    {
                        var mainColor = material.GetColor("_MainColor");
                        material.SetColor("_MainColor", new Color(mainColor.r, mainColor.g, mainColor.b, 1.0f));
                    }

                    // HD Render Pipeline
                    material.DisableKeyword("_SURFACE_TYPE_TRANSPARENT");
                    material.DisableKeyword("_ENABLE_FOG_ON_TRANSPARENT");

                    material.DisableKeyword("_BLENDMODE_ALPHA");
                    material.DisableKeyword("_BLENDMODE_ADD");
                    material.DisableKeyword("_BLENDMODE_PRE_MULTIPLY");

                    material.SetInt("_RenderQueueType", 1);
                    material.SetInt("_SurfaceType", 0);
                    material.SetInt("_BlendMode", 0);
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_AlphaSrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_AlphaDstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_ZWrite", 1);
                    material.SetInt("_TransparentZWrite", 1);
                    material.SetInt("_ZTestDepthEqualForOpaque", 3);
                    material.SetInt("_ZTestGBuffer", 4);
                    material.SetInt("_ZTestTransparent", 4);
                }
                // Transparent
                else
                {
                    material.SetOverrideTag("RenderType", "Transparent");
                    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;

                    // Alpha Blend
                    //if (blend == 0)
                    {
                        // Standard and Universal Render Pipeline
                        material.SetInt("_render_src", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
                        material.SetInt("_render_dst", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                        material.SetInt("_render_premul", 0);

                        // HD Render Pipeline
                        material.EnableKeyword("_SURFACE_TYPE_TRANSPARENT");
                        material.EnableKeyword("_ENABLE_FOG_ON_TRANSPARENT");

                        material.EnableKeyword("_BLENDMODE_ALPHA");
                        material.DisableKeyword("_BLENDMODE_ADD");
                        material.DisableKeyword("_BLENDMODE_PRE_MULTIPLY");

                        material.SetInt("_RenderQueueType", 5);
                        material.SetInt("_SurfaceType", 1);
                        material.SetInt("_BlendMode", 0);
                        material.SetInt("_SrcBlend", 1);
                        material.SetInt("_DstBlend", 10);
                        material.SetInt("_AlphaSrcBlend", 1);
                        material.SetInt("_AlphaDstBlend", 10);
                        material.SetInt("_ZWrite", zwrite);
                        material.SetInt("_TransparentZWrite", zwrite);
                        material.SetInt("_ZTestDepthEqualForOpaque", 4);
                        material.SetInt("_ZTestGBuffer", 4);
                        material.SetInt("_ZTestTransparent", 4);
                    }
                    // Premultiply Blend
                    //else if (blend == 1)
                    //{
                    //    // Standard and Universal Render Pipeline
                    //    material.SetInt("_render_src", (int)UnityEngine.Rendering.BlendMode.One);
                    //    material.SetInt("_render_dst", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                    //    material.SetInt("_render_premul", 1);

                    //    // HD Render Pipeline
                    //    material.EnableKeyword("_SURFACE_TYPE_TRANSPARENT");
                    //    material.EnableKeyword("_ENABLE_FOG_ON_TRANSPARENT");

                    //    material.DisableKeyword("_BLENDMODE_ALPHA");
                    //    material.DisableKeyword("_BLENDMODE_ADD");
                    //    material.EnableKeyword("_BLENDMODE_PRE_MULTIPLY");

                    //    material.SetInt("_RenderQueueType", 5);
                    //    material.SetInt("_SurfaceType", 1);
                    //    material.SetInt("_BlendMode", 4);
                    //    material.SetInt("_SrcBlend", 1);
                    //    material.SetInt("_DstBlend", 10);
                    //    material.SetInt("_AlphaSrcBlend", 1);
                    //    material.SetInt("_AlphaDstBlend", 10);
                    //    material.SetInt("_ZWrite", zwrite);
                    //    material.SetInt("_TransparentZWrite", zwrite);
                    //    material.SetInt("_ZTestDepthEqualForOpaque", 4);
                    //    material.SetInt("_ZTestGBuffer", 4);
                    //    material.SetInt("_ZTestTransparent", 4);
                    //}
                }
            }

            // Set Receive Mode in HDRP
            if (material.GetTag("RenderPipeline", false) == "HDRenderPipeline")
            {
                if (material.HasProperty("_RenderDecals"))
                {
                    int decals = material.GetInt("_RenderDecals");

                    if (decals == 0)
                    {
                        material.EnableKeyword("_DISABLE_DECALS");
                    }
                    else
                    {
                        material.DisableKeyword("_DISABLE_DECALS");
                    }
                }

                if (material.HasProperty("_RenderSSR"))
                {
                    int ssr = material.GetInt("_RenderSSR");

                    if (ssr == 0)
                    {
                        material.EnableKeyword("_DISABLE_SSR");

                        material.SetInt("_StencilRef", 0);
                        material.SetInt("_StencilRefDepth", 0);
                        material.SetInt("_StencilRefDistortionVec", 4);
                        material.SetInt("_StencilRefGBuffer", 2);
                        material.SetInt("_StencilRefMV", 32);
                        material.SetInt("_StencilWriteMask", 6);
                        material.SetInt("_StencilWriteMaskDepth", 8);
                        material.SetInt("_StencilWriteMaskDistortionVec", 4);
                        material.SetInt("_StencilWriteMaskGBuffer", 14);
                        material.SetInt("_StencilWriteMaskMV", 40);
                    }
                    else
                    {
                        material.DisableKeyword("_DISABLE_SSR");

                        material.SetInt("_StencilRef", 0);
                        material.SetInt("_StencilRefDepth", 8);
                        material.SetInt("_StencilRefDistortionVec", 4);
                        material.SetInt("_StencilRefGBuffer", 10);
                        material.SetInt("_StencilRefMV", 40);
                        material.SetInt("_StencilWriteMask", 6);
                        material.SetInt("_StencilWriteMaskDepth", 8);
                        material.SetInt("_StencilWriteMaskDistortionVec", 4);
                        material.SetInt("_StencilWriteMaskGBuffer", 14);
                        material.SetInt("_StencilWriteMaskMV", 40);
                    }
                }
            }

            if (material.HasProperty("_RenderCull"))
            {
                int cull = material.GetInt("_RenderCull");

                material.SetInt("_CullMode", cull);
                material.SetInt("_TransparentCullMode", cull);
                material.SetInt("_CullModeForward", cull);

                // Needed for HD Render Pipeline
                material.DisableKeyword("_DOUBLESIDED_ON");
            }

            // Set Cull Mode
            if (material.HasProperty("_RenderCull"))
            {
                int cull = material.GetInt("_RenderCull");

                material.SetInt("_CullMode", cull);
                material.SetInt("_TransparentCullMode", cull);
                material.SetInt("_CullModeForward", cull);

                // Needed for HD Render Pipeline
                material.DisableKeyword("_DOUBLESIDED_ON");
            }

            // Set Clip Mode
            if (material.HasProperty("_RenderClip"))
            {
                int clip = material.GetInt("_RenderClip");
                float cutoff = material.GetFloat("_Cutoff");

                if (clip == 0)
                {
                    material.DisableKeyword("TVE_ALPHA_CLIP");

                    // HD Render Pipeline
                    material.SetInt("_AlphaCutoffEnable", 0);
                }
                else
                {
                    material.EnableKeyword("TVE_ALPHA_CLIP");

                    // HD Render Pipeline
                    material.SetInt("_AlphaCutoffEnable", 1);
                }

                material.SetFloat("_render_cutoff", cutoff);

                // HD Render Pipeline
                material.SetFloat("_AlphaCutoff", cutoff);
                material.SetFloat("_AlphaCutoffPostpass", cutoff);
                material.SetFloat("_AlphaCutoffPrepass", cutoff);
                material.SetFloat("_AlphaCutoffShadow", cutoff);
            }

            // Set Normals Mode
            if (material.HasProperty("_RenderNormals"))
            {
                int normals = material.GetInt("_RenderNormals");

                // Standard, Universal, HD Render Pipeline
                // Flip 0
                if (normals == 0)
                {
                    material.SetVector("_render_normals_options", new Vector4(-1, -1, -1, 0));
                    material.SetVector("_DoubleSidedConstants", new Vector4(-1, -1, -1, 0));
                }
                // Mirror 1
                else if (normals == 1)
                {
                    material.SetVector("_render_normals_options", new Vector4(1, 1, -1, 0));
                    material.SetVector("_DoubleSidedConstants", new Vector4(1, 1, -1, 0));
                }
                // None 2
                else if (normals == 2)
                {
                    material.SetVector("_render_normals_options", new Vector4(1, 1, 1, 0));
                    material.SetVector("_DoubleSidedConstants", new Vector4(1, 1, 1, 0));
                }
            }

            // Set Normals to 0 if no texture is used
            if (material.HasProperty("_MainNormalTex"))
            {
                if (material.GetTexture("_MainNormalTex") == null)
                {
                    material.SetFloat("_MainNormalValue", 0);
                }
            }

            // Set Normals to 0 if no texture is used
            if (material.HasProperty("_SecondNormalTex"))
            {
                if (material.GetTexture("_SecondNormalTex") == null)
                {
                    material.SetFloat("_SecondNormalValue", 0);
                }
            }

            // Assign Default HD Foliage profile
            if (material.HasProperty("_SubsurfaceDiffusion"))
            {
                if (material.GetFloat("_SubsurfaceDiffusion") == 0)
                {
                    material.SetFloat("_SubsurfaceDiffusion", 3.5648174285888672f);
                    material.SetVector("_SubsurfaceDiffusion_asset", new Vector4(228889264007084710000000000000000000000f, 0.000000000000000000000000012389357880079404f, 0.00000000000000000000000000000000000076932702684439582f, 0.00018220426863990724f));
                    material.SetVector("_SubsurfaceDiffusion_Asset", new Vector4(228889264007084710000000000000000000000f, 0.000000000000000000000000012389357880079404f, 0.00000000000000000000000000000000000076932702684439582f, 0.00018220426863990724f));
                }
            }

            // Set Detail Mode
            if (material.HasProperty("_DetailMode") && material.HasProperty("_SecondColor"))
            {
                if (material.GetInt("_DetailMode") == 0)
                {
                    material.EnableKeyword("TVE_DETAIL_MODE_OFF");
                    material.DisableKeyword("TVE_DETAIL_MODE_ON");
                }
                else
                {
                    material.DisableKeyword("TVE_DETAIL_MODE_OFF");
                    material.EnableKeyword("TVE_DETAIL_MODE_ON");
                }
            }

            if (material.HasProperty("_DetailBlendMode") && material.HasProperty("_SecondColor"))
            {
                if (material.GetInt("_DetailBlendMode") == 0)
                {
                    material.EnableKeyword("TVE_DETAIL_BLEND_OVERLAY");
                    material.DisableKeyword("TVE_DETAIL_BLEND_REPLACE");
                }
                else
                {
                    material.DisableKeyword("TVE_DETAIL_BLEND_OVERLAY");
                    material.EnableKeyword("TVE_DETAIL_BLEND_REPLACE");
                }
            }

            // Set Detail Type
            if (material.HasProperty("_DetailTypeMode") && material.HasProperty("_SecondColor"))
            {
                if (material.GetInt("_DetailTypeMode") == 0)
                {
                    material.EnableKeyword("TVE_DETAIL_TYPE_VERTEX_BLUE");
                    material.DisableKeyword("TVE_DETAIL_TYPE_PROJECTION");
                }
                else
                {
                    material.DisableKeyword("TVE_DETAIL_TYPE_VERTEX_BLUE");
                    material.EnableKeyword("TVE_DETAIL_TYPE_PROJECTION");
                }
            }

            // Set GI Mode
            if (material.HasProperty("_EmissiveFlagMode"))
            {
                int flag = material.GetInt("_EmissiveFlagMode");

                if (flag == 0)
                {
                    material.globalIlluminationFlags = MaterialGlobalIlluminationFlags.None;
                }
                else if (flag == 10)
                {
                    material.globalIlluminationFlags = MaterialGlobalIlluminationFlags.AnyEmissive;
                }
                else if (flag == 20)
                {
                    material.globalIlluminationFlags = MaterialGlobalIlluminationFlags.BakedEmissive;
                }
                else if (flag == 30)
                {
                    material.globalIlluminationFlags = MaterialGlobalIlluminationFlags.RealtimeEmissive;
                }
            }

            // Set Batching Mode
            if (material.HasProperty("_VertexDataMode"))
            {
                int batching = material.GetInt("_VertexDataMode");

                if (batching == 0)
                {
                    material.DisableKeyword("TVE_VERTEX_DATA_BATCHED");
                }
                else
                {
                    material.EnableKeyword("TVE_VERTEX_DATA_BATCHED");
                }
            }

            //Set Pivots Mode
            if (material.HasProperty("_VertexPivotMode"))
            {
                material.SetInt("_vertex_pivot_mode", material.GetInt("_VertexPivotMode"));
            }

            // Enable Nature Rendered support
            material.SetOverrideTag("NatureRendererInstancing", "True");

            // Set Legacy props for external bakers
            if (material.HasProperty("_MainColor"))
            {
                material.SetColor("_Color", material.GetColor("_MainColor"));
            }

            // Set BlinnPhong Spec Color
            if (material.HasProperty("_SpecColor"))
            {
                material.SetColor("_SpecColor", Color.white);
            }

            if (material.HasProperty("_MainAlbedoTex"))
            {
                material.SetTexture("_MainTex", material.GetTexture("_MainAlbedoTex"));
                material.SetTextureScale("_MainTex", new Vector2(material.GetVector("_MainUVs").x, material.GetVector("_MainUVs").y));
                material.SetTextureOffset("_MainTex", new Vector2(material.GetVector("_MainUVs").z, material.GetVector("_MainUVs").w));
            }

            if (material.HasProperty("_MainNormalTex"))
            {
                material.SetTexture("_BumpMap", material.GetTexture("_MainNormalTex"));
                material.SetTextureScale("_BumpMap", new Vector2(material.GetVector("_MainUVs").x, material.GetVector("_MainUVs").y));
                material.SetTextureOffset("_BumpMap", new Vector2(material.GetVector("_MainUVs").z, material.GetVector("_MainUVs").w));
            }

            // Set Internal properties
            if (shaderName.Contains("Simple Lit"))
            {
                material.SetInt("_IsSimpleShader", 1);
                material.SetInt("_IsStandardShader", 0);
                material.SetInt("_IsSubsurfaceShader", 0);
            }
            else
            {
                material.SetInt("_IsSimpleShader", 0);
                material.SetInt("_IsStandardShader", 1);
                material.SetInt("_IsSubsurfaceShader", 1);
            }

            // Set Catergories for impostor baking 
            if (material.HasProperty("_VertexOcclusionColor"))
            {
                material.SetInt("_OcclusionCat", 1);
            }
            else
            {
                material.SetInt("_OcclusionCat", 0);
            }

            if (material.HasProperty("_SubsurfaceValue"))
            {
                material.SetInt("_SubsurfaceCat", 1);
            }
            else
            {
                material.SetInt("_SubsurfaceCat", 0);
            }

            if (material.HasProperty("_GradientColorOne"))
            {
                material.SetInt("_GradientCat", 1);
            }
            else
            {
                material.SetInt("_GradientCat", 0);
            }

            if (material.HasProperty("_NoiseColorOne"))
            {
                material.SetInt("_NoiseCat", 1);
            }
            else
            {
                material.SetInt("_NoiseCat", 0);
            }

            if (material.HasProperty("_PerspectivePushValue"))
            {
                material.SetInt("_PerspectiveCat", 1);
            }
            else
            {
                material.SetInt("_PerspectiveCat", 0);
            }

            if (material.HasProperty("_EmissiveColor"))
            {
                material.SetInt("_EmissiveCat", 1);
            }
            else
            {
                material.SetInt("_EmissiveCat", 0);
            }
        }

        public static void SetElementSettings(Material material)
        {
            if (material.HasProperty("_ElementLayerValue"))
            {
                var layer = material.GetInt("_ElementLayerValue");

                if (layer == 0)
                {
                    material.SetInt("_ElementLayerMessage", 0);
                }
                else
                {
                    material.SetInt("_ElementLayerMessage", 1);
                }
            }

            if (material.HasProperty("_ElementEffect"))
            {
                var effect = material.GetInt("_ElementEffect");

                if (effect == 0)
                {
                    material.SetInt("_render_colormask", 14);
                }
                else
                {
                    material.SetInt("_render_colormask", 15);
                }
            }
        }

        public static void UpgradeMaterialTo300(Material material)
        {
            if (material.HasProperty("_IsVersion"))
            {
                if (material.GetInt("_IsVersion") < 300)
                {
                    //if (material.HasProperty("_BillboardFadeHValue"))
                    //{
                    //    material.SetFloat("_FadeHorizontalValue", Mathf.Clamp01(material.GetFloat("_BillboardFadeHValue")));
                    //}

                    //if (material.HasProperty("_BillboardFadeVValue"))
                    //{
                    //    material.SetFloat("_FadeVerticalValue", Mathf.Clamp01(material.GetFloat("_BillboardFadeVValue")));
                    //}

                    if (material.HasProperty("_Cutoff"))
                    {
                        if (material.GetFloat("_Cutoff") > 0.9f)
                        {
                            material.SetFloat("_Cutoff", 0.5f);
                        }
                    }

                    material.SetInt("_IsVersion", 300);
                }
            }
        }

        public static void UpgradeMaterialTo320(Material material)
        {
            if (material.HasProperty("_IsVersion"))
            {
                if (material.GetInt("_IsVersion") < 320)
                {
                    material.DisableKeyword("TVE_DETAIL_MODE_OVERLAY");
                    material.DisableKeyword("TVE_DETAIL_MODE_REPLACE");
                    material.DisableKeyword("TVE_DETAIL_MAPS_STANDARD");
                    material.DisableKeyword("TVE_DETAIL_MAPS_PACKED");

                    if (material.HasProperty("_DetailMode"))
                    {
                        if (material.GetInt("_DetailMode") == 1)
                        {
                            material.SetInt("_DetailBlendMode", 0);
                        }

                        if (material.GetInt("_DetailMode") == 2)
                        {
                            material.SetInt("_DetailMode", 1);
                            material.SetInt("_DetailBlendMode", 1);
                        }
                    }

                    material.SetInt("_IsVersion", 320);
                }
            }
        }

        public static void CopyMaterialProperties(Material oldMaterial, Material newMaterial)
        {
            var oldShader = oldMaterial.shader;
            var newShader = newMaterial.shader;

            for (int i = 0; i < ShaderUtil.GetPropertyCount(oldShader); i++)
            {
                for (int j = 0; j < ShaderUtil.GetPropertyCount(newShader); j++)
                {
                    var propertyName = ShaderUtil.GetPropertyName(oldShader, i);
                    var propertyType = ShaderUtil.GetPropertyType(oldShader, i);

                    if (propertyName == ShaderUtil.GetPropertyName(newShader, j))
                    {
                        if (propertyType == ShaderUtil.ShaderPropertyType.Color || propertyType == ShaderUtil.ShaderPropertyType.Vector)
                        {
                            newMaterial.SetVector(propertyName, oldMaterial.GetVector(propertyName));
                        }

                        if (propertyType == ShaderUtil.ShaderPropertyType.Float || propertyType == ShaderUtil.ShaderPropertyType.Range)
                        {
                            if (propertyName != "_IsVersion")
                            {
                                newMaterial.SetFloat(propertyName, oldMaterial.GetFloat(propertyName));
                            }
                        }

                        if (propertyType == ShaderUtil.ShaderPropertyType.TexEnv)
                        {
                            newMaterial.SetTexture(propertyName, oldMaterial.GetTexture(propertyName));
                        }
                    }
                }
            }
        }

        public static void DrawPivotModeSupport(Material material)
        {
            if (material.HasProperty("_VertexPivotMode"))
            {
                var pivot = material.GetInt("_VertexPivotMode");

                bool toggle = false;

                if (pivot > 0.5f)
                {
                    toggle = true;

                    EditorGUILayout.HelpBox("The Baked Pivots feature allows for using per mesh element interaction and elements influence. This feature requires pre baked pivots on prefab conversion. Useful for large grass mesh wind and interaction.", MessageType.Info);

                    GUILayout.Space(10);
                }

                toggle = EditorGUILayout.Toggle("Enable Pre Baked Pivots", toggle);

                if (toggle)
                {
                    material.SetInt("_VertexPivotMode", 1);
                }
                else
                {
                    material.SetInt("_VertexPivotMode", 0);
                }
            }
        }

        public static void DrawBatchingSupport(Material material)
        {
            if (material.HasProperty("_VertexDataMode"))
            {
                var batching = material.GetInt("_VertexDataMode");

                bool toggle = false;

                if (batching > 0.5f)
                {
                    toggle = true;

                    EditorGUILayout.HelpBox("Use the Batching Support option when the object is statically batched. All vertex calculations are done in world space and features like Baked Pivots and Size options are not supported because the object pivot data is missing with static batching.", MessageType.Info);

                    GUILayout.Space(10);
                }

                toggle = EditorGUILayout.Toggle("Enable Batching Support", toggle);

                if (toggle)
                {
                    material.SetInt("_VertexDataMode", 1);
                }
                else
                {
                    material.SetInt("_VertexDataMode", 0);
                }
            }
        }

        public static void DrawTechnicalDetails(Material material)
        {
            var shaderName = material.shader.name;

            var styleLabel = new GUIStyle(EditorStyles.label)
            {
                richText = true,
                alignment = TextAnchor.MiddleLeft,
                wordWrap = true,
            };

            if (shaderName.Contains("Standard Lit") || shaderName.Contains("Subsurface Lit") || shaderName.Contains("Translucency Lit"))
            {
                DrawTechincalLabel("Shader Complexity: Balanced", styleLabel);
            }

            if (shaderName.Contains("Simple Lit"))
            {
                DrawTechincalLabel("Shader Complexity: Optimized", styleLabel);
            }

            if (!material.HasProperty("_IsElementShader"))
            {
                if (material.GetTag("RenderPipeline", false) == "HDRenderPipeline")
                {
                    DrawTechincalLabel("Render Pipeline: High Definition Render Pipeline", styleLabel);
                }
                else if (material.GetTag("RenderPipeline", false) == "UniversalPipeline")
                {
                    DrawTechincalLabel("Render Pipeline: Universal Render Pipeline", styleLabel);
                }
                else
                {
                    DrawTechincalLabel("Render Pipeline: Standard Render Pipeline", styleLabel);
                }
            }
            else
            {
                DrawTechincalLabel("Render Pipeline: Any Render Pipeline", styleLabel);
            }

            if (material.GetTag("RenderPipeline", false) == "HDRenderPipeline")
            {
                DrawTechincalLabel("Render Target: Shader Model 4.5 or higher", styleLabel);
            }
            else
            {
                DrawTechincalLabel("Render Target: Shader Model 4.0 or higher", styleLabel);
            }

            if (material.renderQueue < 3000)
            {
                DrawTechincalLabel("Render Queue: Alpha Test " + material.renderQueue.ToString(), styleLabel);
            }
            else
            {
                DrawTechincalLabel("Render Queue: Transparent" + material.renderQueue.ToString(), styleLabel);
            }

            if (shaderName.Contains("Standard Lit") || shaderName.Contains("Simple Lit"))
            {
                DrawTechincalLabel("Render Path: Rendered in both Forward and Deferred path", styleLabel);
            }

            if (shaderName.Contains("Subsurface Lit") || shaderName.Contains("Translucency Lit"))
            {
                DrawTechincalLabel("Render Path: Always rendered in Forward path", styleLabel);
            }

            if (shaderName.Contains("Standard Lit") || shaderName.Contains("Subsurface Lit") || shaderName.Contains("Translucency Lit"))
            {
                DrawTechincalLabel("Lighting Model: Physicaly Based Shading", styleLabel);
            }

            if (shaderName.Contains("Simple Lit"))
            {
                DrawTechincalLabel("Lighting Model: Blinn Phong Shading", styleLabel);
            }

            if (shaderName.Contains("Standard Lit") && (shaderName.Contains("Cross") || shaderName.Contains("Grass") || shaderName.Contains("Leaf")))
            {
                DrawTechincalLabel("Subsurface Model: Transmission Approximation + View Based Light Scattering", styleLabel);
            }

            if (shaderName.Contains("Subsurface Lit") && (shaderName.Contains("Cross") || shaderName.Contains("Grass") || shaderName.Contains("Leaf")))
            {
                DrawTechincalLabel("Subsurface Model: Transmission + View Based Light Scattering", styleLabel);
            }

            if (shaderName.Contains("Simple Lit") && (shaderName.Contains("Cross") || shaderName.Contains("Grass") || shaderName.Contains("Leaf")))
            {
                DrawTechincalLabel("Subsurface Model: Transmission Approximation + View Based Light Scattering", styleLabel);
            }

            if (material.HasProperty("_IsColorsShader"))
            {
                DrawTechincalLabel("Render Buffer: Rendered by the Colors Volume", styleLabel);
            }

            if (material.HasProperty("_IsExtrasShader"))
            {
                DrawTechincalLabel("Render Buffer: Rendered by the Extras Volume", styleLabel);
            }

            if (material.HasProperty("_IsVertexShader"))
            {
                DrawTechincalLabel("Render Buffer: Rendered by the Vertex Volume", styleLabel);
            }

            if (material.HasProperty("_IsCustomShader"))
            {
                DrawTechincalLabel("Render Buffer: Rendered by the Custom Volumes", styleLabel);
            }

            if (material.HasProperty("_IsPropShader"))
            {
                DrawTechincalLabel("Batching Support: Yes", styleLabel);
            }
            else if (material.HasProperty("_IsTVEAIShader") || material.HasProperty("_IsElementShader"))
            {
                DrawTechincalLabel("Batching Support: No", styleLabel);
            }
            else
            {
                DrawTechincalLabel("Batching Support: Yes, with limited features", styleLabel);
            }
        }

        public static void DrawTechincalLabel(string label, GUIStyle style)
        {
            GUILayout.Label("<color=#7f7f7f><size=10>" + label + "</size></color>", style);
        }

        public static void DrawCopySettingsFromGameObject(Material material)
        {
            GameObject go = null;
            go = (GameObject)EditorGUILayout.ObjectField("Copy From GameObject", go, typeof(GameObject), true);

            if (go != null)
            {
                var oldMaterials = go.GetComponent<MeshRenderer>().sharedMaterials;

                for (int i = 0; i < oldMaterials.Length; i++)
                {
                    var oldMaterial = oldMaterials[i];

                    if (oldMaterial != null)
                    {
                        CopyMaterialProperties(oldMaterial, material);
                        material.SetFloat("_IsInitialized", 1);
                        go = null;
                    }
                }
            }
        }

        public static void DrawPoweredByTheVegetationEngine()
        {
            var styleLabelCentered = new GUIStyle(EditorStyles.label)
            {
                richText = true,
                alignment = TextAnchor.MiddleCenter,
            };

            Rect lastRect = GUILayoutUtility.GetLastRect();
            EditorGUI.DrawRect(new Rect(0, lastRect.yMax, 1000, 1), new Color(0, 0, 0, 0.4f));

            GUILayout.Space(15);

            DrawTechincalLabel("Powered by The Vegetation Engine", styleLabelCentered);

            Rect labelRect = GUILayoutUtility.GetLastRect();

            if (GUI.Button(labelRect, "", new GUIStyle()))
            {
                Application.OpenURL("http://u3d.as/1H9u");
            }

            GUILayout.Space(10);
        }

        public static List<string> GetCoreShaderPaths()
        {
            var coreShaderPaths = new List<string>();

            var allShaderPaths = Directory.GetFiles("Assets/", "*.shader", SearchOption.AllDirectories);

            for (int i = 0; i < allShaderPaths.Length; i++)
            {
                if (IsValidTVEShader(allShaderPaths[i]))
                {
                    coreShaderPaths.Add(allShaderPaths[i]);
                }
            }

            return coreShaderPaths;
        }

        public static bool IsValidTVEShader(string shaderPath)
        {
            bool valid = false;

            if (shaderPath.Contains("GPUI") == false)
            {
                var material = new Material(AssetDatabase.LoadAssetAtPath<Shader>(shaderPath));

                if (material.HasProperty("_IsTVEShader") || material.HasProperty("_IsTVEAIShader"))
                {
                    valid = true;
                }
            }

            return valid;
        }

        public static int GetRenderEngineIndexFromShader(string shaderPath)
        {
            int index = 0;

            StreamReader reader = new StreamReader(shaderPath);

            string lines = reader.ReadToEnd();

            for (int e = 0; e < TVEShaderUtils.RenderEngineOptions.Length; e++)
            {
                if (lines.Contains(TVEShaderUtils.RenderEngineOptions[e]))
                {
                    index = e;
                    break;
                }
            }

            reader.Close();

            return index;
        }

        public static void InjectShaderFeatures(string shaderAssetPath, string renderEngine)
        {
            string[] engineVegetationStudio = new string[]
            {
            "           //Vegetation Studio (Instanced Indirect)",
            "           #include \"XXX/Core/Includes/VS_Indirect.cginc\"",
            "           #pragma instancing_options procedural:setup forwardadd",
            "           #pragma multi_compile GPU_FRUSTUM_ON __",
            };

            string[] engineVegetationStudioHD = new string[]
            {
            "           //Vegetation Studio (Instanced Indirect)",
            "           #include \"XXX/Core/Includes/VS_IndirectHD.cginc\"",
            "           #pragma instancing_options procedural:setupVSPro forwardadd",
            "           #pragma multi_compile GPU_FRUSTUM_ON __",
            };

            string[] engineVegetationStudio145 = new string[]
            {
            "           //Vegetation Studio 1.4.5+ (Instanced Indirect)",
            "           #include \"XXX/Core/Includes/VS_Indirect145.cginc\"",
            "           #pragma instancing_options procedural:setupVSPro forwardadd",
            "           #pragma multi_compile GPU_FRUSTUM_ON __",
            };

            string[] engineQuadroRenderer = new string[]
            {
            "           //Mega World Quadro Renderer (Instanced Indirect)",
            "           #include \"XXX\"",
            "           #pragma instancing_options procedural:setupQuadroRenderer",
            "           #pragma multi_compile_instancing",
            };

            string[] engineGPUInstancer = new string[]
            {
            "           //GPU Instancer (Instanced Indirect)",
            "           #include \"XXX\"",
            "           #pragma instancing_options procedural:setupGPUI",
            "           #pragma multi_compile_instancing",
            };

            string[] engineNatureRenderer = new string[]
            {
            "           //Nature Renderer (Procedural Instancing)",
            "           #include \"XXX\"",
            "           #pragma instancing_options procedural:SetupNatureRenderer",
            };
            string[] engine1msRenderVegetation = new string[]
            {
            "           //1msRenderVegetation (Instanced Indirect)",
            "           #include \"XXX\"",
            "           #pragma instancing_options procedural:setup forwardadd",
            "           #pragma multi_compile GPU_FRUSTUM_ON __",
            };
            string[] engine1msRenderVegetationFloat4x4 = new string[]
{
            "           //1msRenderVegetation (Instanced Indirect float4x4)",
            "           #include \"XXX\"",
            "           #pragma instancing_options procedural:setup forwardadd",
            "           #pragma multi_compile GPU_FRUSTUM_ON __",
};
            string assetFolder = "Assets/BOXOPHOBIC/The Vegetation Engine";

            //Safer search, there might be many user folders
            string[] searchFolders;

            searchFolders = AssetDatabase.FindAssets("The Vegetation Engine");

            for (int i = 0; i < searchFolders.Length; i++)
            {
                if (AssetDatabase.GUIDToAssetPath(searchFolders[i]).EndsWith("The Vegetation Engine.pdf"))
                {
                    assetFolder = AssetDatabase.GUIDToAssetPath(searchFolders[i]);
                    assetFolder = assetFolder.Replace("/The Vegetation Engine.pdf", "");
                }
            }

            var cgincQR = "Assets/Mega World/Quadro Renderer/Shaders/Include/QuadroRendererInclude.cginc";
            searchFolders = AssetDatabase.FindAssets("QuadroRendererInclude");

            for (int i = 0; i < searchFolders.Length; i++)
            {
                if (AssetDatabase.GUIDToAssetPath(searchFolders[i]).EndsWith("QuadroRendererInclude.cginc"))
                {
                    cgincQR = AssetDatabase.GUIDToAssetPath(searchFolders[i]);
                }
            }

            var cgincNR = "Assets/Visual Design Cafe/Nature Shaders/Common/Nodes/Integrations/Nature Renderer.cginc";
            searchFolders = AssetDatabase.FindAssets("Nature Renderer");

            for (int i = 0; i < searchFolders.Length; i++)
            {
                if (AssetDatabase.GUIDToAssetPath(searchFolders[i]).EndsWith("Nature Renderer.cginc"))
                {
                    cgincNR = AssetDatabase.GUIDToAssetPath(searchFolders[i]);
                }
            }

            var cgincGPUI = "Assets/GPUInstancer/Shaders/Include/GPUInstancerInclude.cginc";
            searchFolders = AssetDatabase.FindAssets("GPUInstancerInclude");

            for (int i = 0; i < searchFolders.Length; i++)
            {
                if (AssetDatabase.GUIDToAssetPath(searchFolders[i]).EndsWith("GPUInstancerInclude.cginc"))
                {
                    cgincGPUI = AssetDatabase.GUIDToAssetPath(searchFolders[i]);
                }
            }

            var cginc1msRV = "Assets/BasicRenderingFramework/Shaders/1msRenderVegetation_Include.cginc";
            searchFolders = AssetDatabase.FindAssets("1msRenderVegetation_Include");

            for (int i = 0; i < searchFolders.Length; i++)
            {
                if (AssetDatabase.GUIDToAssetPath(searchFolders[i]).EndsWith("1msRenderVegetation_Include.cginc"))
                {
                    cginc1msRV = AssetDatabase.GUIDToAssetPath(searchFolders[i]);
                }
            }

            var cginc1msRVFloat4x4 = "Assets/AdvancedRendering/OcclusionCulling_Hi-z/OcclusionCulling_Hi-z_GPUInstancing_indirect.cginc";
            searchFolders = AssetDatabase.FindAssets("OcclusionCulling_Hi-z_GPUInstancing_indirect");

            for (int i = 0; i < searchFolders.Length; i++)
            {
                if (AssetDatabase.GUIDToAssetPath(searchFolders[i]).EndsWith("OcclusionCulling_Hi-z_GPUInstancing_indirect.cginc"))
                {
                    cginc1msRVFloat4x4 = AssetDatabase.GUIDToAssetPath(searchFolders[i]);
                }
            }

            // Add correct paths for VSP and GPUI
            engineNatureRenderer[1] = engineNatureRenderer[1].Replace("XXX", cgincNR);
            engineVegetationStudio[1] = engineVegetationStudio[1].Replace("XXX", assetFolder);
            engineVegetationStudioHD[1] = engineVegetationStudioHD[1].Replace("XXX", assetFolder);
            engineVegetationStudio145[1] = engineVegetationStudio145[1].Replace("XXX", assetFolder);
            engineGPUInstancer[1] = engineGPUInstancer[1].Replace("XXX", cgincGPUI);
            engineQuadroRenderer[1] = engineQuadroRenderer[1].Replace("XXX", cgincQR);
            engine1msRenderVegetation[1] = engine1msRenderVegetation[1].Replace("XXX", cginc1msRV);
            engine1msRenderVegetationFloat4x4[1] = engine1msRenderVegetationFloat4x4[1].Replace("XXX", cginc1msRVFloat4x4);

            var pipeline = "IS_STANDARD_PIPELINE";

            StreamReader reader = new StreamReader(shaderAssetPath);

            List<string> lines = new List<string>();

            while (!reader.EndOfStream)
            {
                lines.Add(reader.ReadLine());
            }

            reader.Close();

            int count = lines.Count;

            for (int i = 0; i < count; i++)
            {
                if (lines[i].Contains("SHADER INJECTION POINT BEGIN"))
                {
                    int c = 0;
                    int j = i + 1;

                    while (lines[j].Contains("SHADER INJECTION POINT END") == false)
                    {
                        j++;
                        c++;
                    }

                    lines.RemoveRange(i + 1, c);
                    count = count - c;
                }

                if (lines[i].Contains("IS_HD_PIPELINE"))
                {
                    pipeline = "IS_HD_PIPELINE";
                }
            }

            // Delete GPUI added lines    
            count = lines.Count;

            //Inject 3rd Party Support
            if (renderEngine.Contains("Vegetation Studio (Instanced Indirect)"))
            {
                for (int i = 0; i < lines.Count; i++)
                {
                    if (lines[i].Contains("SHADER INJECTION POINT BEGIN"))
                    {
                        if (pipeline == "IS_HD_PIPELINE")
                        {
                            lines.InsertRange(i + 1, engineVegetationStudioHD);
                        }
                        else
                        {
                            lines.InsertRange(i + 1, engineVegetationStudio);
                        }
                    }
                }
            }

            if (renderEngine.Contains("Vegetation Studio 1.4.5+ (Instanced Indirect)"))
            {
                for (int i = 0; i < lines.Count; i++)
                {
                    if (lines[i].Contains("SHADER INJECTION POINT BEGIN"))
                    {
                        lines.InsertRange(i + 1, engineVegetationStudio145);
                    }
                }
            }

            if (renderEngine.Contains("Mega World Quadro Renderer (Instanced Indirect)"))
            {
                for (int i = 0; i < lines.Count; i++)
                {
                    if (lines[i].Contains("SHADER INJECTION POINT BEGIN"))
                    {
                        lines.InsertRange(i + 1, engineQuadroRenderer);
                    }
                }
            }

            if (renderEngine.Contains("Nature Renderer (Procedural Instancing)"))
            {
                for (int i = 0; i < lines.Count; i++)
                {
                    if (lines[i].Contains("SHADER INJECTION POINT BEGIN"))
                    {
                        lines.InsertRange(i + 1, engineNatureRenderer);
                    }
                }
            }

            if (renderEngine.Contains("GPU Instancer (Instanced Indirect)"))
            {
                for (int i = 0; i < lines.Count; i++)
                {
                    if (lines[i].Contains("SHADER INJECTION POINT BEGIN"))
                    {
                        lines.InsertRange(i + 1, engineGPUInstancer);
                    }
                }
            }
            if (renderEngine.Contains("1msRenderVegetation (Instanced Indirect)"))
            {
                for (int i = 0; i < lines.Count; i++)
                {
                    if (lines[i].Contains("SHADER INJECTION POINT BEGIN"))
                    {
                        lines.InsertRange(i + 1, engine1msRenderVegetation);
                    }
                }
            }
            if (renderEngine.Contains("1msRenderVegetation (Instanced Indirect float4x4)"))
            {
                for (int i = 0; i < lines.Count; i++)
                {
                    if (lines[i].Contains("SHADER INJECTION POINT BEGIN"))
                    {
                        lines.InsertRange(i + 1, engine1msRenderVegetationFloat4x4);
                    }
                }
            }
            for (int i = 0; i < lines.Count; i++)
            {
                // Disable ASE Drawers
                if (lines[i].Contains("[ASEBegin]"))
                {
                    lines[i] = lines[i].Replace("[ASEBegin]", "");
                }

                if (lines[i].Contains("[ASEnd]"))
                {
                    lines[i] = lines[i].Replace("[ASEnd]", "");
                }
            }

#if !AMPLIFY_SHADER_EDITOR && !UNITY_2020_2_OR_NEWER

            // Add diffusion profile support for HDRP 10
            if (pipeline.Contains("High"))
            {
                if (shaderAssetPath.Contains("Subsurface Lit"))
                {
                    for (int i = 0; i < lines.Count; i++)
                    {
                        if (lines[i].Contains("DiffusionProfile"))
                        {
                            lines[i] = lines[i].Replace("[DiffusionProfile]", "[StyledDiffusionMaterial(_SubsurfaceDiffusion)]");
                        }
                    }
                }
            }

#elif AMPLIFY_SHADER_EDITOR && !UNITY_2020_2_OR_NEWER

            // Add diffusion profile support
            if (pipeline.Contains("High"))
            {
                if (shaderAssetPath.Contains("Subsurface Lit"))
                {
                    for (int i = 0; i < lines.Count; i++)
                    {
                        if (lines[i].Contains("ASEDiffusionProfile"))
                        {
                            lines[i] = lines[i].Replace("[HideInInspector][Space(10)][ASEDiffusionProfile(_SubsurfaceDiffusion)]", "[Space(10)][ASEDiffusionProfile(_SubsurfaceDiffusion)]");
                        }

                        if (lines[i].Contains("DiffusionProfile"))
                        {
                            lines[i] = lines[i].Replace("[DiffusionProfile]", "[HideInInspector][DiffusionProfile]");
                        }

                        if (lines[i].Contains("StyledDiffusionMaterial"))
                        {
                            lines[i] = lines[i].Replace("[StyledDiffusionMaterial(_SubsurfaceDiffusion)]", "[HideInInspector][StyledDiffusionMaterial(_SubsurfaceDiffusion)]");
                        }
                    }
                }
            }
#endif

            StreamWriter writer = new StreamWriter(shaderAssetPath);

            for (int i = 0; i < lines.Count; i++)
            {
                writer.WriteLine(lines[i]);
            }

            writer.Close();

            lines = new List<string>();

            //AssetDatabase.ImportAsset(shaderAssetPath);
        }
    }
}
