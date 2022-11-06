//Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using TheVegetationEngine;
using Boxophobic.Constants;
using Boxophobic.StyledGUI;

public class TVEShaderCoreGUI : ShaderGUI
{
    bool multiSelection = false;
    bool showInternalProperties = false;
    bool showHiddenProperties = false;
    bool showAdditionalInfo = false;

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        var material0 = materialEditor.target as Material;
        var materials = materialEditor.targets;

        if (materials.Length > 1)
            multiSelection = true;

        DrawDynamicInspector(material0, materialEditor, props);

        foreach (Material material in materials)
        {
            TVEShaderUtils.UpgradeMaterialTo300(material);
            TVEShaderUtils.UpgradeMaterialTo320(material);

            TVEShaderUtils.SetMaterialSettings(material);
        }
    }

    void DrawDynamicInspector(Material material, MaterialEditor materialEditor, MaterialProperty[] props)
    {
        var customPropsList = new List<MaterialProperty>();

        var shaderName = material.shader.name;

        //var bannerColor = CONSTANT.ColorDarkGray;
        var bannerText = Path.GetFileNameWithoutExtension(shaderName);
        //var bannerURL = "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.hvenbcgzqfd3";

        StyledGUI.DrawInspectorBanner(bannerText);

        if (multiSelection)
        {
            for (int i = 0; i < props.Length; i++)
            {
                var prop = props[i];

                if (prop.flags == MaterialProperty.PropFlags.HideInInspector)
                    continue;

                if (material.HasProperty("_LocalColors"))
                {
                    if (prop.name == "_LocalColors")
                        continue;
                }

                customPropsList.Add(prop);
            }
        }
        else
        {
            for (int i = 0; i < props.Length; i++)
            {
                var prop = props[i];

                if (prop.flags == MaterialProperty.PropFlags.HideInInspector && !showHiddenProperties)
                {
                    continue;
                }

                if (prop.name.Contains("_Banner"))
                    continue;

                if (prop.name == "_SpecColor")
                    continue;

                if (material.HasProperty("_RenderMode"))
                {
                    //if (material.GetInt("_RenderMode") == 0 && prop.name == "_RenderBlend")
                    //    continue;

                    if (material.GetInt("_RenderMode") == 0 && prop.name == "_RenderZWrite")
                        continue;

                    if (material.GetInt("_RenderMode") == 0 && prop.name == "_RenderPriority")
                        continue;
                }

                if (!material.HasProperty("_render_normals_options"))
                {
                    if (prop.name == "_RenderNormals")
                        continue;
                }

                if (material.HasProperty("_RenderCull"))
                {
                    if (material.GetInt("_RenderCull") == 2 && prop.name == "_RenderNormals")
                        continue;
                }

                if (material.HasProperty("_RenderClip"))
                {
                    if (material.GetInt("_RenderClip") == 0 && prop.name == "_Cutoff")
                        continue;
                    if (material.GetInt("_RenderClip") == 0 && prop.name == "_FadeCameraValue")
                        continue;
                    if (material.GetInt("_RenderClip") == 0 && prop.name == "_FadeGlancingValue")
                        continue;
                    if (material.GetInt("_RenderClip") == 0 && prop.name == "_FadeHorizontalValue")
                        continue;
                    if (material.GetInt("_RenderClip") == 0 && prop.name == "_FadeVerticalValue")
                        continue;
                    if (material.GetInt("_RenderClip") == 0 && prop.name == "_FadeSpace")
                        continue;
                }

                if (!material.HasProperty("_RenderSpecular") && material.GetTag("RenderPipeline", false) != "HDRenderPipeline")
                {
                    if (prop.name == "_ReceiveSpace")
                        continue;
                }

                if (material.GetTag("RenderPipeline", false) != "HDRenderPipeline")
                {
                    if (prop.name == "_RenderDecals")
                        continue;
                    if (prop.name == "_RenderSSR")
                        continue;
                }

                bool showFadeSpace = false;

                if (material.HasProperty("_FadeCameraValue") || material.HasProperty("_FadeGlancingValue") || material.HasProperty("_FadeHorizontalValue"))
                {
                    showFadeSpace = true;
                }

                if (!showFadeSpace)
                {
                    if (prop.name == "_FadeSpace")
                        continue;
                }

                bool showGlobalsCat = false;

                if (material.HasProperty("_LayerColorsValue") || material.HasProperty("_LayerExtrasValue") || material.HasProperty("_LayerMotionValue") || material.HasProperty("_LayerReactValue"))
                {
                    showGlobalsCat = true;
                }

                if (!showGlobalsCat)
                {
                    if (prop.name == "_GlobalsCat")
                        continue;
                }

                if (material.HasProperty("_GlobalColors"))
                {
                    if (material.GetFloat("_GlobalColors") == 0 && prop.name == "_ColorsMaskRemap")
                        continue;

                    if (material.GetFloat("_GlobalColors") == 0 && prop.name == "_ColorsVariationValue")
                        continue;
                }

                if (material.HasProperty("_GlobalOverlay"))
                {
                    if (material.GetFloat("_GlobalOverlay") == 0 && prop.name == "_OverlayMaskRemap")
                        continue;

                    if (material.GetFloat("_GlobalOverlay") == 0 && prop.name == "_OverlayBottomValue")
                        continue;

                    if (material.GetFloat("_GlobalOverlay") == 0 && prop.name == "_OverlayVariationValue")
                        continue;
                }

                if (material.HasProperty("_GlobalAlpha"))
                {
                    if (material.GetFloat("_GlobalAlpha") == 0 && prop.name == "_AlphaVariationValue")
                        continue;
                }

                if (material.HasProperty("_LocalColors"))
                {
                    if (prop.name == "_LocalColors")
                        continue;
                }

                if (!material.HasProperty("_SecondColor"))
                {
                    if (prop.name == "_DetailCat")
                        continue;

                    if (prop.name == "_DetailMode")
                        continue;

                    if (prop.name == "_DetailBlendMode")
                        continue;

                    if (prop.name == "_DetailTypeMode")
                        continue;

                    if (prop.name == "_DetailSpace")
                        continue;
                }

                if (!material.HasProperty("_VertexOcclusionColor"))
                {
                    if (prop.name == "_OcclusionCat")
                        continue;
                }

                if (material.GetTag("RenderPipeline", false) != "HDRenderPipeline" || shaderName.Contains("Standard"))
                {
                    if (prop.name == "_SubsurfaceDiffusion")
                        continue;
                }

                if (!material.HasProperty("_SubsurfaceValue"))
                {
                    if (prop.name == "_SubsurfaceCat")
                        continue;
                }

                if (shaderName.Contains("Translucency"))
                {
                    if (prop.name == "_Translucency")
                        continue;
                    if (prop.name == "_TransNormalDistortion")
                        continue;
                    if (prop.name == "_TransScattering")
                        continue;
                    if (prop.name == "_TransDirect")
                        continue;
                    if (prop.name == "_TransAmbient")
                        continue;
                    if (prop.name == "_TransShadow")
                        continue;

                    if (material.GetTag("RenderPipeline", false) != "HDRenderPipeline")
                    {
                        if (prop.name == "_TranslucencyHDMessage")
                            continue;
                    }
                }
                else
                {
                    if (prop.name == "_TranslucencyIntensityValue")
                        continue;
                    if (prop.name == "_TranslucencyNormalValue")
                        continue;
                    if (prop.name == "_TranslucencyScatteringValue")
                        continue;
                    if (prop.name == "_TranslucencyDirectValue")
                        continue;
                    if (prop.name == "_TranslucencyAmbientValue")
                        continue;
                    if (prop.name == "_TranslucencyShadowValue")
                        continue;
                    if (prop.name == "_TranslucencyHDMessage")
                        continue;
                }

                if (!material.HasProperty("_GradientColorOne"))
                {
                    if (prop.name == "_GradientCat")
                        continue;
                }

                if (!material.HasProperty("_NoiseColorOne"))
                {
                    if (prop.name == "_NoiseCat")
                        continue;
                }

                if (!material.HasProperty("_PerspectivePushValue"))
                {
                    if (prop.name == "_PerspectiveCat")
                        continue;
                }

                if (!material.HasProperty("_MotionAmplitude_10"))
                {
                    if (prop.name == "_MotionCat")
                        continue;
                }

                if (!material.HasProperty("_MotionHighlightColor"))
                {
                    if (prop.name == "_MotionSpace")
                        continue;
                }

                if (!material.HasProperty("_SizeFadeMode"))
                {
                    if (prop.name == "_SizeFadeCat")
                        continue;
                }

                if (!material.HasProperty("_EmissiveColor"))
                {
                    if (prop.name == "_EmissiveCat")
                        continue;
                    if (prop.name == "_EmissiveFlagMode")
                        continue;
                }

                if (!material.HasProperty("_IsPropShader"))
                {
                    if (prop.name == "_DetailTypeMode")
                        continue;
                }

                if (material.HasProperty("_DetailTypeMode"))
                {
                    if (material.GetInt("_DetailTypeMode") == 0 && prop.name == "_DetailProjectionMode")
                        continue;

                    if (material.GetInt("_DetailTypeMode") == 1 && prop.name == "_DetailCoordMode")
                        continue;
                }

                if (material.HasProperty("_VertexDataMode"))
                {
                    if (material.GetInt("_VertexDataMode") == 1 && prop.name == "_GlobalSize")
                        continue;

                    if (material.GetInt("_VertexDataMode") == 1 && prop.name == "_SizeFadeCat")
                        continue;

                    if (material.GetInt("_VertexDataMode") == 1 && prop.name == "_SizeFadeMode")
                        continue;

                    if (material.GetInt("_VertexDataMode") == 1 && prop.name == "_SizeFadeStartValue")
                        continue;

                    if (material.GetInt("_VertexDataMode") == 1 && prop.name == "_SizeFadeEndValue")
                        continue;

                    if (material.GetInt("_VertexDataMode") == 1 && prop.name == "_VertexPivotMode")
                        continue;

                    if (material.GetInt("_VertexDataMode") == 1 && prop.name == "_MotionSpace")
                        continue;

                    if (material.GetInt("_VertexDataMode") == 1 && prop.name == "_PivotsMessage")
                        continue;
                }

                customPropsList.Add(prop);
            }
        }

        //Draw Custom GUI
        for (int i = 0; i < customPropsList.Count; i++)
        {
            var displayName = customPropsList[i].displayName;

            if (EditorGUIUtility.currentViewWidth > 500)
            {
                if (displayName.Contains("Colors Mask") && shaderName.Contains("Standard") && !shaderName.Contains("Simple Lit"))
                {
                    displayName = "Colors Mask (Bottom Mask)";
                }

                if (displayName.Contains("Colors Mask") && shaderName.Contains("Leaf") && !shaderName.Contains("Simple Lit"))
                {
                    displayName = "Colors Mask (Mask Blue)";
                }

                if (displayName.Contains("Colors Mask") && shaderName.Contains("Cross") && !shaderName.Contains("Simple Lit"))
                {
                    displayName = "Colors Mask (Mask Blue)";
                }

                if (displayName.Contains("Overlay Mask"))
                {
                    displayName = "Overlay Mask (Albedo Green)";
                }

                if (displayName == "Main Metallic")
                {
                    displayName = "Main Metallic (Mask Red)";
                }

                if (displayName == "Main Occlusion")
                {
                    displayName = "Main Occlusion (Mask Green)";
                }

                if (displayName == "Main Smoothness" && !shaderName.Contains("Simple Lit"))
                {
                    displayName = "Main Smoothness (Mask Alpha)";
                }

                if (displayName == "Vertex Occlusion Mask")
                {
                    displayName = "Vertex Occlusion Mask (Vertex Green)";
                }

                if (displayName == "Gradient Mask")
                {
                    displayName = "Gradient Mask (Vertex Alpha)";
                }

                if (displayName == "Noise Mask")
                {
                    displayName = "Noise Mask (World Noise)";
                }

                if (displayName == "Subsurface Mask" && material.shader.name.Contains("Grass"))
                {
                    displayName = "Subsurface Mask (Top Mask)";
                }

                if (displayName == "Subsurface Mask" && material.shader.name.Contains("Leaf"))
                {
                    displayName = "Subsurface Mask (Mask Blue)";
                }

                if (displayName == "Subsurface Mask" && material.shader.name.Contains("Cross"))
                {
                    displayName = "Subsurface Mask (Mask Blue)";
                }

                if (material.HasProperty("_DetailMapsMode"))
                {
                    if (material.GetInt("_DetailMapsMode") == 0)
                    {
                        if (displayName == "Detail Metallic")
                        {
                            displayName = "Detail Metallic (Mask Red)";
                        }

                        if (displayName == "Detail Occlusion")
                        {
                            displayName = "Detail Occlusion (Mask Green)";
                        }

                        if (displayName == "Detail Smoothness")
                        {
                            displayName = "Detail Smoothness (Mask Alpha)";
                        }
                    }
                    else
                    {
                        if (displayName == "Detail Smoothness")
                        {
                            displayName = "Detail Smoothness (Mask Blue)";
                        }
                    }
                }

                if (displayName == "Detail Mask Source")
                {
                    displayName = "Detail Mask Source (Mask Blue)";
                }

                if (displayName == "Detail Mask Invert")
                {
                    displayName = "Detail Mask Invert (Detail Mask)";
                }

                if (material.HasProperty("_DetailTypeMode"))
                {
                    if (material.GetInt("_DetailTypeMode") == 0)
                    {
                        if (displayName == "Detail Mask Offset")
                        {
                            displayName = "Detail Mask Offset (Vertex Blue)";
                        }
                    }
                    else
                    {
                        if (displayName == "Detail Mask Offset")
                        {
                            displayName = "Detail Mask Offset (Projection Mask)";
                        }
                    }
                }
                else
                {
                    if (displayName == "Detail Mask Offset")
                    {
                        displayName = "Detail Mask Offset (Vertex Blue)";
                    }
                }
            }

            var debug = "";

            if (showInternalProperties)
            {
                debug = "  (" + customPropsList[i].name + ")";
            }

            materialEditor.ShaderProperty(customPropsList[i], displayName + debug);

        }

        GUILayout.Space(10);

        StyledGUI.DrawInspectorCategory("Advanced Settings");

        GUILayout.Space(10);

        if (!material.IsKeywordEnabled("TVE_VERTEX_DATA_BATCHED"))
        {
            TVEShaderUtils.DrawPivotModeSupport(material);
        }

        TVEShaderUtils.DrawBatchingSupport(material);
        materialEditor.EnableInstancingField();

        //GUILayout.Space(10);

        //materialEditor.DoubleSidedGIField();
        //materialEditor.LightmapEmissionProperty(0);
        //materialEditor.RenderQueueField();

        GUILayout.Space(10);

        TVEShaderUtils.DrawCopySettingsFromGameObject(material);

        GUILayout.Space(10);

        showInternalProperties = EditorGUILayout.Toggle("Show Internal Properties", showInternalProperties);
        showHiddenProperties = EditorGUILayout.Toggle("Show Hidden Properties", showHiddenProperties);
        showAdditionalInfo = EditorGUILayout.Toggle("Show Additional Info", showAdditionalInfo);

        if (showAdditionalInfo)
        {
            GUILayout.Space(10);

            TVEShaderUtils.DrawTechnicalDetails(material);
        }

        GUILayout.Space(20);

        TVEShaderUtils.DrawPoweredByTheVegetationEngine();
    }
}

