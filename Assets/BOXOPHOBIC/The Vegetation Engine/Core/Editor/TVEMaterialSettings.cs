// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using Boxophobic.StyledGUI;
using Boxophobic.Utils;
using System.Globalization;
using System.IO;
using System;

namespace TheVegetationEngine
{
    public class TVEMaterialSettings : EditorWindow
    {
        const int GUI_SMALL_WIDTH = 50;
        const int GUI_HEIGHT = 18;
        const int GUI_MESH = 24;

        float GUI_HALF_EDITOR_WIDTH = 200;

        string[] materialOptions = new string[]
        {
        "All", "Render Settings", "Global Settings", "Main Settings", "Detail Settings", "Occlusion Settings", "Subsurface Settings", "Gradient and Noise Settings", "Perspective Settings", "Fade Settings", "Motion Settings",
        };

        string[] savingOptions = new string[]
        {
        "Save All Settings", "Save Current Settings",
        };

        List<TVEMaterialData> materialData = new List<TVEMaterialData>
        {

        };

        List<TVEMaterialData> saveData = new List<TVEMaterialData>
        {

        };

        List<TVEMaterialData> renderSettings = new List<TVEMaterialData>
        {
            new TVEMaterialData("_Cutoff", "Alpha Treshold", -9999, 0, 1, false, true),
            new TVEMaterialData("_FadeCameraValue", "Fade by Camera Distance", -9999, 0, 1, false, false),
            new TVEMaterialData("_FadeGlancingValue", "Fade by Glancing Angle", -9999, 0, 1, false, false),
            new TVEMaterialData("_FadeHorizontalValue", "Fade by Horizontal Angle", -9999, 0, 1, false, false),
            new TVEMaterialData("_FadeVerticalValue", "Fade by Vertical Angle", -9999, 0, 1, false, false),
        };

        List<TVEMaterialData> globalData = new List<TVEMaterialData>
        {
            new TVEMaterialData("_LayerColorsValue", "Layer Colors", -9999, 0, 8, true, true),
            new TVEMaterialData("_LayerExtrasValue", "Layer Extras", -9999, 0, 8, true, false),
            new TVEMaterialData("_LayerMotionValue", "Layer Motion", -9999, 0, 8, true, false),
            new TVEMaterialData("_LayerReactValue", "Layer React", -9999, 0, 8, true, false),

            new TVEMaterialData("_GlobalColors", "Global Colors", -9999, 0, 1, false, true),
            new TVEMaterialData("_GlobalOverlay", "Global Overlay", -9999, 0, 1, false, false),
            new TVEMaterialData("_GlobalWetness", "Global Wetness", -9999, 0, 1, false, false),
            new TVEMaterialData("_GlobalAlpha", "Global Alpha", -9999, 0, 1, false, false),
            new TVEMaterialData("_GlobalSize", "Global Size", -9999, 0, 1, false, false),

            new TVEMaterialData("_ColorsMaskMinValue", "Colors Mask Min", -9999, 0, 1, false, true),
            new TVEMaterialData("_ColorsMaskMaxValue", "Colors Mask Max", -9999, 0, 1, false, false),

            new TVEMaterialData("_OverlayMaskMinValue", "Overlay Mask Min", -9999, 0, 1, false, true),
            new TVEMaterialData("_OverlayMaskMaxValue", "Overlay Mask Max", -9999, 0, 1, false, false),
            new TVEMaterialData("_OverlayBottomValue", "Overlay Bottom", -9999, 0, 1, false, false),
            new TVEMaterialData("_OverlayVariationValue", "Overlay Variation", -9999, 0, 1, false, false),

            new TVEMaterialData("_AlphaVariationValue", "Alpha Variation", -9999, 0, 1, false, true),
        };

        List<TVEMaterialData> mainData = new List<TVEMaterialData>
        {
            new TVEMaterialData("_MainColor", "Main Color", new Color(-9999, 0,0,0), true, true),
            new TVEMaterialData("_MainNormalValue", "Main Normal", -9999, -8, 8, false, false),
            new TVEMaterialData("_MainMetallicValue", "Main Metallic", -9999, 0, 1, false, false),
            new TVEMaterialData("_MainOcclusionValue", "Main Occlusion", -9999, 0, 1, false, false),
            new TVEMaterialData("_MainSmoothnessValue", "Main Smoothness", -9999, 0, 1, false, false),
        };

        List<TVEMaterialData> secondData = new List<TVEMaterialData>
        {
            new TVEMaterialData("_SecondColor", "Detail Color", new Color(-9999, 0,0,0), true, true),
            new TVEMaterialData("_SecondNormalValue", "Detail Normal", -9999, -8, 8, false, false),
            new TVEMaterialData("_SecondMetallicValue", "Detail Metallic", -9999, 0, 1, false, false),
            new TVEMaterialData("_SecondOcclusionValue", "Detail Occlusion", -9999, 0, 1, false, false),
            new TVEMaterialData("_SecondSmoothnessValue", "Detail Smoothness", -9999, 0, 1, false, false),

            new TVEMaterialData("_DetailNormalValue", "Detail Use Main Normal", -9999, 0, 1, false, true),

            new TVEMaterialData("_DetailMeshValue", "Detail Mask Offset", -9999, -1, 1, false, true),
            new TVEMaterialData("_DetailBlendMinValue", "Detail Blending Min", -9999, 0, 1, false, false),
            new TVEMaterialData("_DetailBlendMaxValue", "Detail Blending Max", -9999, 0, 1, false, false),
        };

        List<TVEMaterialData> occlusionData = new List<TVEMaterialData>
        {
            new TVEMaterialData("_VertexOcclusionColor", "Vertex Occlusion Color", new Color(-9999, 0,0,0), true, true),
            new TVEMaterialData("_VertexOcclusionMinValue", "Vertex Occlusion Min", -9999, 0, 1, false, false),
            new TVEMaterialData("_VertexOcclusionMaxValue", "Vertex Occlusion max", -9999, 0, 1, false, false),
        };

        List<TVEMaterialData> subsurfaceData = new List<TVEMaterialData>
        {
            new TVEMaterialData("_SubsurfaceValue", "Subsurface Intensity", -9999, 0, 1, false, true),
            new TVEMaterialData("_SubsurfaceColor", "Subsurface Color", new Color(-9999, 0,0,0), true, false),
            new TVEMaterialData("_SubsurfaceMaskMinValue", "Subsurface Mask Min", -9999, 0, 1, false, false),
            new TVEMaterialData("_SubsurfaceMaskMaxValue", "Subsurface Mask Max", -9999, 0, 1, false, false),

            new TVEMaterialData("_MainLightScatteringValue", "Subsurface Scattering Intensity", -9999, 0, 16, false, true),
            new TVEMaterialData("_MainLightScatteringValue", "Subsurface Scattering Normal", -9999, 0, 1, false, false),
            new TVEMaterialData("_MainLightAngleValue", "Subsurface Scattering Angle", -9999, 0, 16, false, false),
        };

        List<TVEMaterialData> gradientAndNoiseData = new List<TVEMaterialData>
        {
            new TVEMaterialData("_GradientColorOne", "Gradient Color One", new Color(-9999, 0,0,0), true, true),
            new TVEMaterialData("_GradientColorTwo", "Gradient Color Two", new Color(-9999, 0,0,0), true, false),
            new TVEMaterialData("_GradientMinValue", "Gradient Mask Min", -9999, 0, 1, false, false),
            new TVEMaterialData("_GradientMaxValue", "Gradient Mask Max", -9999, 0, 1, false, false),

            new TVEMaterialData("_NoiseColorOne", "Noise Color One", new Color(-9999, 0,0,0), true, true),
            new TVEMaterialData("_NoiseColorTwo", "Noise Color Two", new Color(-9999, 0,0,0), true, false),
            new TVEMaterialData("_NoiseMinValue", "Noise Min", -9999, 0, 1, false, false),
            new TVEMaterialData("_NoiseMaxValue", "Noise Max", -9999, 0, 1, false, false),
            new TVEMaterialData("_NoiseScaleValue", "Noise Scale", -9999, 0, 10, false, false),
        };

        List<TVEMaterialData> perspectiveSettings = new List<TVEMaterialData>
        {
            new TVEMaterialData("_PerspectivePushValue", "Perspective Push", -9999, 0, 4, false, true),
            new TVEMaterialData("_PerspectiveNoiseValue", "Perspective Noise", -9999, 0, 4, false, false),
            new TVEMaterialData("_PerspectiveAngleValue", "Perspective Angle", -9999, 0, 8, false, false),
        };

        List<TVEMaterialData> distanceFadeData = new List<TVEMaterialData>
        {
            new TVEMaterialData("_SizeFadeStartValue", "Size Fade Start", -9999, 0, 2000, false, true),
            new TVEMaterialData("_SizeFadeEndValue", "Size Fade End", -9999, 0, 2000, false, false),
        };

        List<TVEMaterialData> motionData = new List<TVEMaterialData>
        {
            new TVEMaterialData("_MotionHighlightColor", "Motion Highlight", new Color(-9999, 0,0,0), true, true),

            new TVEMaterialData("_MotionAmplitude_10", "Bending Amplitude", -9999, 0, 2, false, true),
            new TVEMaterialData("_MotionSpeed_10", "Bending Speed", -9999, 0, 60, true, false),
            new TVEMaterialData("_MotionScale_10", "Bending Scale", -9999, 0, 20, false, false),
            new TVEMaterialData("_MotionVariation_10", "Bending Variation", -9999, 0, 20, false, false),

            new TVEMaterialData("_MotionAmplitude_20", "Rolling Amplitude", -9999, 0, 2, false, true),
            new TVEMaterialData("_MotionSpeed_20", "Rolling Speed", -9999, 0, 60, true, false),
            new TVEMaterialData("_MotionScale_20", "Rolling Scale", -9999, 0, 20, false, false),
            new TVEMaterialData("_MotionVariation_20", "Rolling Variation", -9999, 0, 20, false, false),

            new TVEMaterialData("_MotionAmplitude_32", "Flutter Amplitude", -9999, 0, 2, false, true),
            new TVEMaterialData("_MotionSpeed_32", "Flutter Speed", -9999, 0, 60, true, false),
            new TVEMaterialData("_MotionScale_32", "Flutter Scale", -9999, 0, 20, false, false),
            new TVEMaterialData("_MotionVariation_32", "Flutter Variation", -9999, 0, 20, false, false),

            new TVEMaterialData("_InteractionAmplitude", "Interaction Amplitude", -9999, 0, 10, false, true),
            new TVEMaterialData("_InteractionVariation", "Interaction Variation", -9999, 0, 1, false, false),
        };

        List<GameObject> selectedObjects = new List<GameObject>();
        List<Material> selectedMaterials = new List<Material>();

        string[] allPresetPaths;
        List<string> presetPaths;
        List<string> presetLines;
        string[] presetOptions;

        int presetIndex;
        int settingsIndex = 10;
        int settingsIndexOld = -1;
        int savingIndex = 1;
        string savePath = "";

        bool isValid = true;
        bool useProceduralVariation = false;
        bool showSelectedPrefabs = true;

        bool useLine;
        List<bool> useLines;

        float windPower = 0.5f;
        TVEGlobalMotion globalMotion;
        Material dummyMaterial;

        string userFolder = "Assets/BOXOPHOBIC/User";

        GUIStyle stylePopup;
        GUIStyle styleCenteredHelpBox;

        Color bannerColor;
        string bannerText;
        string helpURL;
        static TVEMaterialSettings window;
        Vector2 scrollPosition = Vector2.zero;

        [MenuItem("Window/BOXOPHOBIC/The Vegetation Engine/Material Settings", false, 1002)]
        public static void ShowWindow()
        {
            window = GetWindow<TVEMaterialSettings>(false, "Material Settings", true);
            window.minSize = new Vector2(389, 300);
        }

        void OnEnable()
        {
            bannerColor = new Color(0.890f, 0.745f, 0.309f);
            bannerText = "Material Settings";
            helpURL = "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.161s3m1jg4ul";

            if (GameObject.Find("The Vegetation Engine") == null)
            {
                isValid = false;
                Debug.Log("[Warning][The Vegetation Engine] " + "The Vegetation Engine manager is missing from your scene. Make sure setup it up first and the reopen the Prefab Settings!");
            }

            OverrideWind();

            materialData = new List<TVEMaterialData>();
            materialData.AddRange(renderSettings);
            materialData.AddRange(globalData);
            materialData.AddRange(mainData);
            materialData.AddRange(secondData);
            materialData.AddRange(occlusionData);
            materialData.AddRange(subsurfaceData);
            materialData.AddRange(gradientAndNoiseData);
            materialData.AddRange(perspectiveSettings);
            materialData.AddRange(distanceFadeData);
            materialData.AddRange(motionData);

            GetPresets();
            GetPresetOptions();

            string[] searchFolders = AssetDatabase.FindAssets("User");

            for (int i = 0; i < searchFolders.Length; i++)
            {
                if (AssetDatabase.GUIDToAssetPath(searchFolders[i]).EndsWith("User.pdf"))
                {
                    userFolder = AssetDatabase.GUIDToAssetPath(searchFolders[i]);
                    userFolder = userFolder.Replace("/User.pdf", "");
                    userFolder += "/The Vegetation Engine/";
                }
            }

            settingsIndex = Convert.ToInt16(SettingsUtils.LoadSettingsData(userFolder + "Material Settings.asset", "10"));
        }

        void OnSelectionChange()
        {
            Initialize();
            Repaint();
        }

        void OnFocus()
        {
            Initialize();
            Repaint();
            OverrideWind();
        }

        void OnLostFocus()
        {
            ResetWind();
        }

        void OnDisable()
        {
            ResetWind();
        }

        void OnDestroy()
        {
            ResetWind();
        }

        void OnGUI()
        {
            SetGUIStyles();

            GUI_HALF_EDITOR_WIDTH = this.position.width / 2.0f - 24;

            StyledGUI.DrawWindowBanner(bannerColor, bannerText, helpURL);

            GUILayout.BeginHorizontal();
            GUILayout.Space(15);

            GUILayout.BeginVertical();

            GUILayout.Space(-2);

            if (isValid && selectedObjects.Count > 0)
            {
                EditorGUILayout.HelpBox("The Material Settings tool allows to set the same values to all selected material. Please note that Undo is not supported for the Material Settings window!", MessageType.Info, true);
            }
            else
            {
                if (isValid == false)
                {
                    EditorGUILayout.HelpBox("The Vegetation Engine manager is missing from your scene. Make sure setup it up first and the reopen the Material Settings window!", MessageType.Warning, true);
                }
                else if (selectedObjects.Count == 0)
                {
                    GUILayout.Button("\n<size=14>Select one or multiple gameobjects to get started!</size>\n", styleCenteredHelpBox);
                }
            }

            scrollPosition = GUILayout.BeginScrollView(scrollPosition, false, false, GUILayout.Width(this.position.width - 28), GUILayout.Height(this.position.height - 160));

            if (isValid == false || selectedObjects.Count == 0)
            {
                GUI.enabled = false;
            }

            DrawWindPower();
            SetGlobalShaderProperties();

            if (selectedObjects.Count > 0)
            {
                GUILayout.Space(5);
            }

            DrawMaterials();

            GUILayout.Space(10);

            presetIndex = StyledPopup("Material Preset", presetIndex, presetOptions);

            if (presetIndex > 0)
            {
                GetPresetLines();

                for (int i = 0; i < selectedMaterials.Count; i++)
                {
                    var material = selectedMaterials[i];

                    GetMaterialConversionFromPreset(material);
                    TVEShaderUtils.SetMaterialSettings(material);
                }

                materialData = new List<TVEMaterialData>();
                materialData.AddRange(renderSettings);
                materialData.AddRange(globalData);
                materialData.AddRange(mainData);
                materialData.AddRange(secondData);
                materialData.AddRange(occlusionData);
                materialData.AddRange(subsurfaceData);
                materialData.AddRange(gradientAndNoiseData);
                materialData.AddRange(perspectiveSettings);
                materialData.AddRange(distanceFadeData);
                materialData.AddRange(motionData);

                GetInitMaterialProperties();
                GetMaterialProperties();

                presetIndex = 0;
                settingsIndexOld = -1;
            }

            EditorGUI.BeginChangeCheck();

            settingsIndex = StyledPopup("Material Settings", settingsIndex, materialOptions);

            if (EditorGUI.EndChangeCheck())
            {
                SettingsUtils.SaveSettingsData(userFolder + "Material Settings.asset", settingsIndex);
            }

            GUILayout.Space(10);

            if (settingsIndex == 0)
            {
                StyledGUI.DrawWindowCategory("All Settings");
            }
            else if (settingsIndex == 10)
            {
                StyledGUI.DrawWindowCategory("Motion Settings");

                if (useProceduralVariation)
                {
                    GUILayout.Space(10);
                    EditorGUILayout.HelpBox("Procedural variation in use! Use the Scale settings if the Variation is breaking the bending and rolling animation!", MessageType.Info, true);
                }
            }
            else
            {
                StyledGUI.DrawWindowCategory("Material Settings");
            }

            if (settingsIndexOld != settingsIndex)
            {
                materialData = new List<TVEMaterialData>();

                if (settingsIndex == 0)
                {
                    materialData.AddRange(renderSettings);
                    materialData.AddRange(globalData);
                    materialData.AddRange(mainData);
                    materialData.AddRange(secondData);
                    materialData.AddRange(occlusionData);
                    materialData.AddRange(subsurfaceData);
                    materialData.AddRange(gradientAndNoiseData);
                    materialData.AddRange(perspectiveSettings);
                    materialData.AddRange(distanceFadeData);
                    materialData.AddRange(motionData);
                }
                else if (settingsIndex == 1)
                {
                    materialData = renderSettings;
                }
                else if (settingsIndex == 2)
                {
                    materialData = globalData;
                }
                else if (settingsIndex == 3)
                {
                    materialData = mainData;
                }
                else if (settingsIndex == 4)
                {
                    materialData = secondData;
                }
                else if (settingsIndex == 5)
                {
                    materialData = occlusionData;
                }
                else if (settingsIndex == 6)
                {
                    materialData = subsurfaceData;
                }
                else if (settingsIndex == 7)
                {
                    materialData = gradientAndNoiseData;
                }
                else if (settingsIndex == 8)
                {
                    materialData = perspectiveSettings;
                }
                else if (settingsIndex == 9)
                {
                    materialData = distanceFadeData;
                }
                else if (settingsIndex == 10)
                {
                    materialData = motionData;
                }

                settingsIndexOld = settingsIndex;
            }

            for (int i = 0; i < materialData.Count; i++)
            {
                if (materialData[i].type == TVEMaterialData.PropertyType.Range)
                {
                    materialData[i].value = StyledSlider(materialData[i].name, materialData[i].value, materialData[i].min, materialData[i].max, materialData[i].snap, materialData[i].space);
                }
                else if (materialData[i].type == TVEMaterialData.PropertyType.Color)
                {
                    materialData[i].color = StyledColor(materialData[i].name, materialData[i].color, materialData[i].hdr, materialData[i].space);
                }
            }

            GUILayout.Space(10);

            SavePreset();

            SetMaterialProperties();

            GUILayout.EndScrollView();

            GUILayout.EndVertical();

            GUILayout.Space(13);
            GUILayout.EndHorizontal();
        }

        void SetGUIStyles()
        {
            stylePopup = new GUIStyle(EditorStyles.popup)
            {
                alignment = TextAnchor.MiddleCenter
            };

            styleCenteredHelpBox = new GUIStyle(GUI.skin.GetStyle("HelpBox"))
            {
                richText = true,
                alignment = TextAnchor.MiddleCenter,
            };
        }

        void DrawWindPower()
        {
            GUIStyle styleMid = new GUIStyle();
            styleMid.alignment = TextAnchor.MiddleCenter;
            styleMid.normal.textColor = Color.gray;
            styleMid.fontSize = 7;

            GUILayout.Space(10);

            //GUILayout.Label("Wind Power (for testing only)");

            GUILayout.BeginHorizontal();
            GUILayout.Space(8);
            windPower = GUILayout.HorizontalSlider(windPower, 0.0f, 1.0f);

            GUILayout.Space(8);
            GUILayout.EndHorizontal();

            int maxWidth = 20;

#if UNITY_2019_3_OR_NEWER
            GUILayout.Space(15);
#endif

            GUILayout.BeginHorizontal();
            GUILayout.Space(2);
            GUILayout.Label("Calm", styleMid, GUILayout.Width(maxWidth));
            GUILayout.Label("", styleMid);
            GUILayout.Label("Windy", styleMid, GUILayout.Width(maxWidth));
            GUILayout.Label("", styleMid);
            GUILayout.Label("Strong", styleMid, GUILayout.Width(maxWidth));
            GUILayout.Space(7);
            GUILayout.EndHorizontal();
        }

        void DrawMaterials()
        {
            if (selectedObjects.Count > 0)
            {
                GUILayout.Space(10);
            }

            if (showSelectedPrefabs)
            {
                if (StyledButton("Hide Material Selection"))
                    showSelectedPrefabs = !showSelectedPrefabs;
            }
            else
            {
                if (StyledButton("Show Material Selection"))
                    showSelectedPrefabs = !showSelectedPrefabs;
            }
            if (showSelectedPrefabs)
            {
                for (int i = 0; i < selectedMaterials.Count; i++)
                {
                    if (selectedMaterials[i] != null)
                    {
                        StyledMaterial(i, selectedMaterials);
                    }
                }
            }
        }

        void StyledMaterial(int index, List<Material> materials)
        {
            if (materials.Count > index)
            {

                var material = materials[index];
                var color = "<color=#87b8ff>";
                bool useExternalSettings = true;

                if (!EditorGUIUtility.isProSkin)
                {
                    color = "<color=#0b448b>";
                }

                GUILayout.Label("<size=11><b>" + color + material.name.Replace(" (TVE Material)", "") + "</color></b></size>", styleCenteredHelpBox, GUILayout.Height(GUI_MESH));

                var lastRect = GUILayoutUtility.GetLastRect();

                var buttonRect = new Rect(lastRect.x, lastRect.y, lastRect.width - 24, lastRect.height);

                if (GUI.Button(buttonRect, "", GUIStyle.none))
                {
                    EditorGUIUtility.PingObject(material);
                }

#if UNITY_2019_3_OR_NEWER
                var toogleRect = new Rect(lastRect.width - 16, lastRect.y + 6, 12, 12);
#else
                var toogleRect = new Rect(lastRect.width - 16, lastRect.y + 4, 12, 12);
#endif

                if (material.GetTag("UseExternalSettings", false) == "False")
                {
                    useExternalSettings = false;
                }

                useExternalSettings = EditorGUI.Toggle(toogleRect, useExternalSettings);
                GUI.Label(toogleRect, new GUIContent("", "Should the Prefab Settings tool affect the material?"));

                if (useExternalSettings)
                {
                    material.SetOverrideTag("UseExternalSettings", "True");
                }
                else
                {
                    material.SetOverrideTag("UseExternalSettings", "False");
                }
            }
        }

        int StyledPopup(string name, int index, string[] options)
        {
            if (index > options.Length)
            {
                index = 0;
            }

            GUILayout.BeginHorizontal();
            GUILayout.Label(name, GUILayout.Width(GUI_HALF_EDITOR_WIDTH - 5));
            index = EditorGUILayout.Popup(index, options, stylePopup);
            GUILayout.EndHorizontal();

            return index;
        }

        float StyledSlider(string name, float val, float min, float max, bool snap, bool space)
        {
            if (val == -9999)
            {
                return val;
            }
            else
            {
                if (space)
                {
                    GUILayout.Space(10);
                }

                GUILayout.BeginHorizontal();

                float equalValue = val;
                float mixedValue = 0;

                //if (val == -9999)
                //{
                //    GUI.enabled = false;

                //    GUILayout.Label(name, GUILayout.MaxWidth(GUI_HALF_EDITOR_WIDTH));
                //    GUILayout.HorizontalSlider(0, 0, 1);
                //    GUILayout.Label("none", styleCenteredLabel, GUILayout.MaxWidth(GUI_SMALL_WIDTH), GUILayout.Height(GUI_HEIGHT));

                //    GUI.enabled = true;
                //}
                if (val == -8888)
                {
                    GUILayout.Label(name, GUILayout.MaxWidth(GUI_HALF_EDITOR_WIDTH));

                    EditorGUI.showMixedValue = true;

                    mixedValue = GUILayout.HorizontalSlider(mixedValue, min, max);

                    if (mixedValue != 0)
                    {
                        val = mixedValue;
                    }

                    float floatVal = EditorGUILayout.FloatField(val, GUILayout.MaxWidth(GUI_SMALL_WIDTH));

                    if (val != floatVal)
                    {
                        val = Mathf.Clamp(floatVal, min, max);
                    }

                    EditorGUI.showMixedValue = false;
                }
                else
                {
                    GUILayout.Label(name, GUILayout.MaxWidth(GUI_HALF_EDITOR_WIDTH));

                    equalValue = GUILayout.HorizontalSlider(equalValue, min, max);

                    val = equalValue;

                    float floatVal = EditorGUILayout.FloatField(val, GUILayout.MaxWidth(GUI_SMALL_WIDTH));

                    if (val != floatVal)
                    {
                        val = Mathf.Clamp(floatVal, min, max);
                    }
                }

                GUILayout.EndHorizontal();

                if (snap)
                {
                    val = Mathf.Round(val);
                }
                else
                {
                    val = Mathf.Round(val * 1000f) / 1000f;
                }

                return val;
            }
        }

        Color StyledColor(string name, Color color, bool HDR, bool space)
        {
            if (color.r == -9999)
            {
                return color;
            }
            else
            {
                if (space)
                {
                    GUILayout.Space(10);
                }

                GUILayout.BeginHorizontal();

                //if (color.r == -9999)
                //{
                //    GUI.enabled = false;
                //    GUILayout.Label(name, GUILayout.MaxWidth(GUI_HALF_EDITOR_WIDTH));
                //    GUILayout.Label("");
                //    GUILayout.Label("none", styleCenteredLabel, GUILayout.MaxWidth(GUI_SMALL_WIDTH), GUILayout.Height(GUI_HEIGHT));
                //    GUI.enabled = true;
                //}
                if (color.r == -8888)
                {
                    GUILayout.Label(name, GUILayout.MaxWidth(GUI_HALF_EDITOR_WIDTH));

                    EditorGUI.showMixedValue = true;
                    color = EditorGUILayout.ColorField(new GUIContent(""), color, true, true, true);
                    EditorGUI.showMixedValue = false;
                }
                else
                {
                    GUILayout.Label(name, GUILayout.MaxWidth(GUI_HALF_EDITOR_WIDTH));

                    color = EditorGUILayout.ColorField(new GUIContent(""), color, true, true, true);
                }

                GUILayout.EndHorizontal();

                return color;
            }
        }

        bool StyledButton(string text)
        {
            bool value = GUILayout.Button("<b>" + text + "</b>", styleCenteredHelpBox, GUILayout.Height(GUI_MESH));

            return value;
        }

        void Initialize()
        {
            ResetMaterialData();
            GetSelectedObjects();
            GetPrefabMaterials();
            InitCustomMaterials();
            GetInitMaterialProperties();
            GetMaterialProperties();
        }

        void ResetMaterialData()
        {
            for (int d = 0; d < materialData.Count; d++)
            {
                if (materialData[d].type == TVEMaterialData.PropertyType.Range)
                {
                    materialData[d].value = -9999;
                }
                else if (materialData[d].type == TVEMaterialData.PropertyType.Color)
                {
                    materialData[d].color.r = -9999;
                }
            }
        }

        void GetSelectedObjects()
        {
            selectedObjects = new List<GameObject>();

            for (int i = 0; i < Selection.gameObjects.Length; i++)
            {
                selectedObjects.Add(Selection.gameObjects[i]);
            }
        }

        void GetPrefabMaterials()
        {
            // Get Materials on demand
            selectedMaterials = new List<Material>();
            var allMaterial = new List<Material>();

            var gameObjects = new List<GameObject>();
            var meshRenderers = new List<MeshRenderer>();

            for (int i = 0; i < selectedObjects.Count; i++)
            {
                gameObjects.Add(selectedObjects[i]);
                GetChildRecursive(selectedObjects[i], gameObjects);
            }

            for (int i = 0; i < gameObjects.Count; i++)
            {
                if (gameObjects[i].GetComponent<MeshRenderer>() != null)
                {
                    meshRenderers.Add(gameObjects[i].GetComponent<MeshRenderer>());
                }
            }

            for (int i = 0; i < meshRenderers.Count; i++)
            {
                if (meshRenderers[i].sharedMaterials != null)
                {
                    for (int j = 0; j < meshRenderers[i].sharedMaterials.Length; j++)
                    {
                        var material = meshRenderers[i].sharedMaterials[j];

                        if (material != null)
                        {
                            if (!selectedMaterials.Contains(material))
                            {
                                selectedMaterials.Add(material);
                            }
                        }
                    }
                }
            }
        }

        void GetChildRecursive(GameObject go, List<GameObject> gameObjects)
        {
            foreach (Transform child in go.transform)
            {
                if (child == null)
                    continue;

                gameObjects.Add(child.gameObject);
                GetChildRecursive(child.gameObject, gameObjects);
            }
        }

        void InitCustomMaterials()
        {
            Material TVEMaterial = null;

            for (int i = 0; i < selectedMaterials.Count; i++)
            {
                var material = selectedMaterials[i];

                if (material.HasProperty("_IsTVEShader"))
                {
                    TVEMaterial = material;
                    break;
                }
            }

            if (TVEMaterial != null)
            {
                for (int i = 0; i < selectedMaterials.Count; i++)
                {
                    var material = selectedMaterials[i];

                    if (material.HasProperty("_IsInitialized"))
                    {
                        if (material.GetInt("_IsInitialized") == 0)
                        {
                            TheVegetationEngine.TVEShaderUtils.CopyMaterialProperties(TVEMaterial, material);
                            material.SetInt("_IsInitialized", 1);
                        }
                    }
                }
            }
        }

        void GetInitMaterialProperties()
        {
            if (selectedMaterials.Count > 0)
            {
                var material = selectedMaterials[0];

                for (int d = 0; d < materialData.Count; d++)
                {
                    if (materialData[d].type == TVEMaterialData.PropertyType.Range)
                    {
                        if (material.HasProperty(materialData[d].prop))
                        {
                            var value = material.GetFloat(materialData[d].prop);

                            materialData[d].value = value;
                        }
                    }
                    else if (materialData[d].type == TVEMaterialData.PropertyType.Color)
                    {
                        if (material.HasProperty(materialData[d].prop))
                        {
                            var color = material.GetColor(materialData[d].prop);

                            materialData[d].color = color;
                        }
                    }
                }

                if (material.HasProperty("_VertexVariationMode") && material.GetInt("_VertexVariationMode") == 1)
                {
                    useProceduralVariation = true;
                }
                else
                {
                    useProceduralVariation = false;
                }

                if (material.GetTag("UseExternalSettings", false) == "")
                {
                    material.SetOverrideTag("UseExternalSettings", "True");
                }
            }
            else
            {
                for (int d = 0; d < materialData.Count; d++)
                {
                    if (materialData[d].type == TVEMaterialData.PropertyType.Range)
                    {
                        materialData[d].value = -9999;
                    }
                    else if (materialData[d].type == TVEMaterialData.PropertyType.Color)
                    {
                        materialData[d].color = new Color(-9999, 0, 0, 0);
                    }
                }
            }
        }

        void GetMaterialProperties()
        {
            for (int i = 0; i < selectedMaterials.Count; i++)
            {
                var material = selectedMaterials[i];

                for (int d = 0; d < materialData.Count; d++)
                {
                    if (material.HasProperty(materialData[d].prop))
                    {
                        if (materialData[d].type == TVEMaterialData.PropertyType.Range)
                        {
                            var value = material.GetFloat(materialData[d].prop);

                            if (materialData[d].value != -9999 && materialData[d].value != value)
                            {
                                materialData[d].value = -8888;
                            }
                            else
                            {
                                materialData[d].value = value;
                            }
                        }
                        else if (materialData[d].type == TVEMaterialData.PropertyType.Color)
                        {
                            if (material.HasProperty(materialData[d].prop))
                            {
                                var color = material.GetColor(materialData[d].prop);

                                if (materialData[d].color.r != -9999 && materialData[d].color != color)
                                {
                                    materialData[d].color = new Color(-8888f, 0, 0, 0);
                                }
                                else
                                {
                                    materialData[d].color = color;
                                }
                            }
                        }
                    }
                }
            }
        }

        void SetMaterialProperties()
        {
            for (int i = 0; i < selectedMaterials.Count; i++)
            {
                var material = selectedMaterials[i];

                // Maybe a better check for unfocus on Converter Convert button pressed
                if (material != null)
                {
                    bool UseExternalSettings = true;

                    if (material.GetTag("UseExternalSettings", false) == "False")
                    {
                        UseExternalSettings = false;
                    }

                    if (UseExternalSettings == false)
                    {
                        continue;
                    }

                    for (int d = 0; d < materialData.Count; d++)
                    {
                        if (materialData[d].type == TVEMaterialData.PropertyType.Range)
                        {
                            if (material.HasProperty(materialData[d].prop) && materialData[d].value > -99)
                            {
                                material.SetFloat(materialData[d].prop, materialData[d].value);
                            }
                        }

                        else if (materialData[d].type == TVEMaterialData.PropertyType.Color)
                        {
                            if (material.HasProperty(materialData[d].prop) && materialData[d].color.r > -99)
                            {
                                material.SetColor(materialData[d].prop, materialData[d].color);
                            }
                        }
                    }
                }
            }
        }

        void GetPresets()
        {
            presetPaths = new List<string>();
            presetPaths.Add(null);

            // FindObjectsOfTypeAll not working properly for unloaded assets
            allPresetPaths = Directory.GetFiles(Application.dataPath, "*.tvesettings", SearchOption.AllDirectories);

            for (int i = 0; i < allPresetPaths.Length; i++)
            {
                string assetPath = "Assets" + allPresetPaths[i].Replace(Application.dataPath, "").Replace('\\', '/');
                presetPaths.Add(assetPath);
            }

            //for (int i = 0; i < presetTreePaths.Count; i++)
            //{
            //    Debug.Log(presetTreePaths[i]);
            //}
        }

        void GetPresetOptions()
        {
            presetOptions = new string[presetPaths.Count];
            presetOptions[0] = "Choose a preset";

            for (int i = 1; i < presetPaths.Count; i++)
            {
                presetOptions[i] = AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(presetPaths[i]).name;
                presetOptions[i] = presetOptions[i].Replace(" - ", "/");
            }

            //for (int i = 0; i < presetOptions.Length; i++)
            //{
            //    Debug.Log(presetOptions[i]);
            //}
        }

        void GetPresetLines()
        {
            StreamReader reader = new StreamReader(presetPaths[presetIndex]);

            presetLines = new List<string>();

            while (!reader.EndOfStream)
            {
                var line = reader.ReadLine();

                presetLines.Add(line);
            }

            reader.Close();

            //for (int i = 0; i < presetLines.Count; i++)
            //{
            //    Debug.Log(presetLines[i]);
            //}
        }

        void GetMaterialConversionFromPreset(Material material)
        {
            InitConditionFromLine();

            for (int i = 0; i < presetLines.Count; i++)
            {
                useLine = GetConditionFromLine(presetLines[i], material);

                if (useLine)
                {
                    if (presetLines[i].StartsWith("Material"))
                    {
                        string[] splitLine = presetLines[i].Split(char.Parse(" "));

                        var type = "";
                        var src = "";
                        var set = "";

                        var x = "0";
                        var y = "0";
                        var z = "0";
                        var w = "0";

                        if (splitLine.Length > 1)
                        {
                            type = splitLine[1];
                        }

                        if (splitLine.Length > 2)
                        {
                            src = splitLine[2];
                            set = splitLine[2];
                        }

                        if (splitLine.Length > 3)
                        {
                            x = splitLine[3];
                        }

                        if (splitLine.Length > 4)
                        {
                            y = splitLine[4];
                        }

                        if (splitLine.Length > 5)
                        {
                            z = splitLine[5];
                        }

                        if (splitLine.Length > 6)
                        {
                            w = splitLine[6];
                        }

                        if (type == "SET_FLOAT")
                        {
                            material.SetFloat(set, float.Parse(x, CultureInfo.InvariantCulture));
                        }

                        else if (type == "SET_COLOR")
                        {
                            material.SetColor(set, new Color(float.Parse(x, CultureInfo.InvariantCulture), float.Parse(y, CultureInfo.InvariantCulture), float.Parse(z, CultureInfo.InvariantCulture), float.Parse(w, CultureInfo.InvariantCulture)));
                        }

                        else if (type == "SET_VECTOR")
                        {
                            material.SetVector(set, new Vector4(float.Parse(x, CultureInfo.InvariantCulture), float.Parse(y, CultureInfo.InvariantCulture), float.Parse(z, CultureInfo.InvariantCulture), float.Parse(w, CultureInfo.InvariantCulture)));
                        }

                        else if (type == "ENABLE_INSTANCING")
                        {
                            material.enableInstancing = true;
                        }

                        else if (type == "DISABLE_INSTANCING")
                        {
                            material.enableInstancing = false;
                        }

                        else if (type == "SET_SHADER_BY_NAME")
                        {
                            var shader = presetLines[i].Replace("Material SET_SHADER_BY_NAME ", "");

                            if (Shader.Find(shader) != null)
                            {
                                material.shader = Shader.Find(shader);
                            }
                        }
                    }
                }
            }
        }

         void InitConditionFromLine()
        {
            useLines = new List<bool>();
            useLines.Add(true);
        }

        bool GetConditionFromLine(string line, Material material)
        {
            var valid = true;

            if (line.StartsWith("if"))
            {
                valid = false;

                string[] splitLine = line.Split(char.Parse(" "));

                var type = "";
                var check = "";
                var val = splitLine[splitLine.Length - 1];

                if (splitLine.Length > 1)
                {
                    type = splitLine[1];
                }

                if (splitLine.Length > 2)
                {
                    for (int i = 2; i < splitLine.Length; i++)
                    {
                        if (!float.TryParse(splitLine[i], out _))
                        {
                            check = check + splitLine[i] + " ";
                        }
                    }

                    check = check.TrimEnd();
                }

                if (type.Contains("MATERIAL_NAME_CONTAINS"))
                {
                    if (material.name.Contains(check))
                    {
                        valid = true;
                    }
                }
                else if (type.Contains("SHADER_NAME_CONTAINS"))
                {
                    if (material.shader.name.Contains(check))
                    {
                        valid = true;
                    }
                }
                else if (type.Contains("MATERIAL_NAME_CONTAINS"))
                {
                    if (material.name.Contains(check))
                    {
                        valid = true;
                    }
                }
                else if (type.Contains("MATERIAL_PIPELINE_IS_STANDARD"))
                {
                    if (material.GetTag("RenderPipeline", false) == "")
                    {
                        valid = true;
                    }
                }
                else if (type.Contains("MATERIAL_PIPELINE_IS_UNIVERSAL"))
                {
                    if (material.GetTag("RenderPipeline", false) == "UniversalPipeline")
                    {
                        valid = true;
                    }
                }
                else if (type.Contains("MATERIAL_PIPELINE_IS_HD"))
                {
                    if (material.GetTag("RenderPipeline", false) == "HDRenderPipeline")
                    {
                        valid = true;
                    }
                }
                else if (type.Contains("MATERIAL_RENDERTYPE_TAG_CONTAINS"))
                {
                    if (material.GetTag("RenderType", false).Contains(check))
                    {
                        valid = true;
                    }
                }
                else if (type.Contains("MATERIAL_HAS_PROP"))
                {
                    if (material.HasProperty(check))
                    {
                        valid = true;
                    }
                }
                else if (type.Contains("MATERIAL_FLOAT_EQUALS"))
                {
                    var min = float.Parse(val, CultureInfo.InvariantCulture) - 0.1f;
                    var max = float.Parse(val, CultureInfo.InvariantCulture) + 0.1f;

                    if (material.HasProperty(check) && material.GetFloat(check) > min && material.GetFloat(check) < max)
                    {
                        valid = true;
                    }
                }
                else if (type.Contains("MATERIAL_KEYWORD_ENABLED"))
                {
                    if (material.IsKeywordEnabled(check))
                    {
                        valid = true;
                    }
                }

                useLines.Add(valid);
            }

            if (line.StartsWith("if") && line.Contains("!"))
            {
                valid = !valid;
                useLines[useLines.Count - 1] = valid;
            }

            if (line.StartsWith("endif") || line.StartsWith("}"))
            {
                useLines.RemoveAt(useLines.Count - 1);
            }

            var useLine = true;

            for (int i = 1; i < useLines.Count; i++)
            {
                if (useLines[i] == false)
                {
                    useLine = false;
                    break;
                }
            }

            return useLine;
        }

        void SavePreset()
        {
            GUILayout.BeginHorizontal();

            savingIndex = EditorGUILayout.Popup(savingIndex, savingOptions, stylePopup, GUILayout.Width(GUI_HALF_EDITOR_WIDTH - 2), GUILayout.Height(GUI_HEIGHT));

            if (GUILayout.Button("Save Preset", GUILayout.Height(GUI_HEIGHT)))
            {
                savePath = EditorUtility.SaveFilePanelInProject("Save Preset", "Custom - My Preset", "tvesettings", "Use the ' - ' simbol to create categories!");

                if (savePath != "")
                {
                    StreamWriter writer = new StreamWriter(savePath);
                    saveData = new List<TVEMaterialData>();

                    if (savingIndex == 0)
                    {
                        saveData.AddRange(renderSettings);
                        saveData.AddRange(globalData);
                        saveData.AddRange(mainData);
                        saveData.AddRange(secondData);
                        saveData.AddRange(occlusionData);
                        saveData.AddRange(subsurfaceData);
                        saveData.AddRange(gradientAndNoiseData);
                        saveData.AddRange(perspectiveSettings);
                        saveData.AddRange(distanceFadeData);
                        saveData.AddRange(motionData);
                    }
                    else if (savingIndex == 1)
                    {
                        saveData = materialData;
                    }

                    for (int i = 0; i < saveData.Count; i++)
                    {
                        if (saveData[i].space == true)
                        {
                            writer.WriteLine("");
                        }

                        if (saveData[i].type == TVEMaterialData.PropertyType.Range)
                        {
                            if (saveData[i].value > -99)
                            {
                                writer.WriteLine("Material SET_FLOAT " + saveData[i].prop + " " + saveData[i].value.ToString(CultureInfo.InvariantCulture));
                            }
                            else
                            {
                                writer.WriteLine("//Material SET_FLOAT " + saveData[i].prop + " " + saveData[i].value.ToString(CultureInfo.InvariantCulture));
                            }
                        }

                        if (saveData[i].type == TVEMaterialData.PropertyType.Color)
                        {
                            if (saveData[i].color.r > -99)
                            {
                                writer.WriteLine("Material SET_VECTOR " + saveData[i].prop + " " + saveData[i].color.r.ToString(CultureInfo.InvariantCulture) + " " + saveData[i].color.g.ToString(CultureInfo.InvariantCulture) + " " + saveData[i].color.b.ToString(CultureInfo.InvariantCulture) + " " + saveData[i].color.a.ToString(CultureInfo.InvariantCulture));
                            }
                            else
                            {
                                writer.WriteLine("//Material SET_VECTOR " + saveData[i].prop + " " + saveData[i].color.r.ToString(CultureInfo.InvariantCulture) + " " + saveData[i].color.g.ToString(CultureInfo.InvariantCulture) + " " + saveData[i].color.b.ToString(CultureInfo.InvariantCulture) + " " + saveData[i].color.a.ToString(CultureInfo.InvariantCulture));
                            }
                        }
                    }

                    writer.Close();

                    AssetDatabase.Refresh();

                    GetPresets();
                    GetPresetOptions();

                    // Reset materialData
                    settingsIndexOld = -1;

                    GUIUtility.ExitGUI();
                }
            }

            GUILayout.EndHorizontal();
        }

        void OverrideWind()
        {
            if (TVEManager.Instance != null)
            {
                globalMotion = TVEManager.Instance.globalMotion;
            }

            if (globalMotion != null)
            {
                windPower = globalMotion.windPower;
                globalMotion.enabled = false;
            }

            dummyMaterial = Resources.Load<Material>("Internal Dummy");
        }

        void ResetWind()
        {
            if (globalMotion != null)
            {
                windPower = globalMotion.windPower;
                globalMotion.enabled = true;

                SetGlobalShaderProperties();
            }
        }

        void SetGlobalShaderProperties()
        {
            Vector4 windParams = Shader.GetGlobalVector("TVE_MotionParams");
            Shader.SetGlobalVector("TVE_MotionParams", new Vector4(windParams.x, windParams.y, windPower, 1.0f));

            dummyMaterial.SetFloat("_DummyValue", windPower);
        }
    }
}
