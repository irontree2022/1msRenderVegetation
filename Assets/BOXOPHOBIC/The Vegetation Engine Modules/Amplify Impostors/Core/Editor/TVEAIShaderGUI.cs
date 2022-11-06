//Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using TheVegetationEngine;
using TheVegetationEngineImpostors;
using Boxophobic.Constants;
using Boxophobic.StyledGUI;

public class TVEAIShaderGUI : ShaderGUI
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

        if (material0.HasProperty("_IsInitialized"))
        {
            if (material0.GetFloat("_IsInitialized") > 0)
            {
                DrawDynamicInspector(material0, materialEditor, props);
            }
            else
            {
                DrawInitInspector(material0);
            }
        }

        foreach (Material material in materials)
        {
            TVEAIShaderUtils.SetMaterialSettings(material);
        }
    }

    void DrawDynamicInspector(Material material, MaterialEditor materialEditor, MaterialProperty[] props)
    {
        var customPropsList = new List<MaterialProperty>();

        var shaderName = material.shader.name;

        //var bannerColor = CONSTANT.ColorDarkGray;
        var bannerText = Path.GetFileNameWithoutExtension(shaderName);
        //var bannerURL = "https://docs.google.com/document/d/1otI7lGjXNL9FYmvvogNUG4ymG8tUrlUmwbrTj9hFMN8/edit#heading=h.f9eq5srfrwz2";

        StyledGUI.DrawInspectorBanner(bannerText);

        if (multiSelection)
        {
            for (int i = 0; i < props.Length; i++)
            {
                var prop = props[i];

                if (prop.flags == MaterialProperty.PropFlags.HideInInspector)
                    continue;

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

                if (material.shader.name.Contains("Objects"))
                {
                    if (prop.name == "_MaterialType")
                        continue;
                    if (prop.name == "_PivotsMessage")
                        continue;
                    if (prop.name == "_MotionSpace")
                        continue;
                }

                if (material.HasProperty("_MaterialType") && material.shader.name.Contains("Vegetation"))
                {
                    // Shader is Vegetation
                    if (material.GetInt("_MaterialType") == 10)
                    {
                        if (prop.name == "_ImpostorGrassColor")
                            continue;
                        if (prop.name == "_ImpostorGrassSaturationValue")
                            continue;
                        if (prop.name == "_MotionHighlightColor")
                            continue;
                        if (prop.name == "_MotionSpace")
                            continue;
                    }
                    // Shader is Grass
                    else if (material.GetInt("_MaterialType") == 20)
                    {
                        if (prop.name == "_ImpostorBarkColor")
                            continue;
                        if (prop.name == "_ImpostorBarkSaturationValue")
                            continue;
                        if (prop.name == "_ImpostorLeafColor")
                            continue;
                        if (prop.name == "_ImpostorLeafSaturationValue")
                            continue;
                        if (prop.name == "_MainLightNormalValue")
                            continue;
                    }
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

                if (!material.HasProperty("_NoiseColorOne"))
                {
                    if (prop.name == "_NoiseCat")
                        continue;
                }

                if (!material.HasProperty("_SizeFadeMode"))
                {
                    if (prop.name == "_SizeFadeCat")
                        continue;
                }

                if (!material.HasProperty("_MotionAmplitude_10"))
                {
                    if (prop.name == "_MotionCat")
                        continue;
                }

                if (!material.HasProperty("_EmissiveColor"))
                {
                    if (prop.name == "_EmissiveCat")
                        continue;
                    if (prop.name == "_EmissiveFlagMode")
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

                customPropsList.Add(prop);
            }
        }

        //Draw Custom GUI
        for (int i = 0; i < customPropsList.Count; i++)
        {
            var prop = customPropsList[i];

            if (prop.type == MaterialProperty.PropType.Texture)
            {
                var label = customPropsList[i].displayName;

                if (label == "Detail Albedo")
                {
                    GUILayout.Space(10);
                }

                var debug = "";

                if (showInternalProperties)
                {
                    debug = "  (" + customPropsList[i].name + ")";
                }

                materialEditor.TexturePropertySingleLine(new GUIContent(label + debug, ""), customPropsList[i]);
            }
            else
            {
                var label = customPropsList[i].displayName;

                if (label == "Impostor Parallax")
                {
                    GUILayout.Space(10);
                }

                if (label == "Impostor Clip")
                {
                    label = "Impostor Alpha Treshold";
                }

                if (EditorGUIUtility.currentViewWidth > 500)
                {
                    if (label == "Colors Mask" && material.shader.name.Contains("Grass"))
                    {
                        label = "Colors Mask (Bottom Mask)";
                    }

                    if (label == "Colors Mask" && material.shader.name.Contains("Vegetation"))
                    {
                        label = "Colors Mask (Mask Blue)";
                    }

                    if (label == "Overlay Mask")
                    {
                        label = "Overlay Mask (Albedo Green)";
                    }

                    if (label == "Main Metallic")
                    {
                        label = "Main Metallic (Mask Red)";
                    }

                    if (label == "Main Smoothness")
                    {
                        label = "Main Smoothness (Mask Alpha)";
                    }

                    if (label == "Noise Mask")
                    {
                        label = "Noise Mask (World Noise)";
                    }

                    if (label == "Subsurface Mask" && material.shader.name.Contains("Grass"))
                    {
                        label = "Subsurface Mask (Top Mask)";
                    }

                    if (label == "Subsurface Mask" && material.shader.name.Contains("Vegetation"))
                    {
                        label = "Subsurface Mask (Mask Blue)";
                    }

                    if (label == "Detail Mask Offset")
                    {
                        label = "Detail Mask Offset (Projection Mask)";
                    }
                }

                var debug = "";

                if (showInternalProperties)
                {
                    debug = "  (" + customPropsList[i].name + ")";
                }

                materialEditor.ShaderProperty(customPropsList[i], label + debug);
            }
        }

        GUILayout.Space(10);

        StyledGUI.DrawInspectorCategory("Advanced Settings");

        GUILayout.Space(10);

        materialEditor.EnableInstancingField();

        //GUILayout.Space(10);

        //materialEditor.DoubleSidedGIField();
        //materialEditor.LightmapEmissionProperty(0);
        //materialEditor.RenderQueueField();

        GUILayout.Space(10);

        TVEAIShaderUtils.DrawCopySettingsFromGameObject(material);

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

    void DrawInitInspector(Material material)
    {
        var shaderName = material.shader.name;

        //var bannerColor = CONSTANT.ColorDarkGray;
        var bannerText = Path.GetFileNameWithoutExtension(shaderName);
        //var bannerURL = "https://docs.google.com/document/d/1otI7lGjXNL9FYmvvogNUG4ymG8tUrlUmwbrTj9hFMN8/edit#heading=h.vv5o65fdfsbj";

        StyledGUI.DrawInspectorBanner(bannerText);

        GUILayout.Space(5);

        EditorGUILayout.HelpBox("The original material properties are not copied to the Impostor material. Drag the game object the impostor is baked from to the field below to copy the properties!", MessageType.Error, true);

        GUILayout.Space(10);

        TVEAIShaderUtils.DrawCopySettingsFromGameObject(material);

        GUILayout.Space(10);
    }
}

