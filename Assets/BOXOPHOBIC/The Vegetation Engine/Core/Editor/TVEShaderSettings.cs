// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;
using Boxophobic.StyledGUI;
using Boxophobic.Utils;
using System.IO;
using System.Collections.Generic;

namespace TheVegetationEngine
{
    public class TVEShaderSettings : EditorWindow
    {
        float GUI_HALF_EDITOR_WIDTH = 200;

        string userFolder = "Assets/BOXOPHOBIC/User";

        List<string> coreShaderPaths;
        List<int> engineOverridesIndices;

        int engineIndex = 0;
        bool showMixedValues = false;

        GUIStyle stylePopup;

        Color bannerColor;
        string bannerText;
        string helpURL;
        static TVEShaderSettings window;
        Vector2 scrollPosition = Vector2.zero;

        [MenuItem("Window/BOXOPHOBIC/The Vegetation Engine/Shader Settings", false, 1003)]
        public static void ShowWindow()
        {
            window = GetWindow<TVEShaderSettings>(false, "Shader Settings", true);
            window.minSize = new Vector2(389, 220);
        }

        void OnEnable()
        {
            string[] searchFolders;

            searchFolders = AssetDatabase.FindAssets("User");

            for (int i = 0; i < searchFolders.Length; i++)
            {
                if (AssetDatabase.GUIDToAssetPath(searchFolders[i]).EndsWith("User.pdf"))
                {
                    userFolder = AssetDatabase.GUIDToAssetPath(searchFolders[i]);
                    userFolder = userFolder.Replace("/User.pdf", "");
                    userFolder += "/The Vegetation Engine";
                }
            }

            coreShaderPaths = new List<string>();
            engineOverridesIndices = new List<int>();

            coreShaderPaths = TVEShaderUtils.GetCoreShaderPaths();

            for (int i = 0; i < coreShaderPaths.Count; i++)
            {
                engineOverridesIndices.Add(0);
            }

            GetRenderEngineFromShaders();
            GetRenderEngineMixedValues();

            bannerColor = new Color(0.890f, 0.745f, 0.309f);
            bannerText = "Shader Settings";
            helpURL = "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.x8fx57dtj0qi";
        }

        void OnGUI()
        {
            SetGUIStyles();

            GUI_HALF_EDITOR_WIDTH = this.position.width / 2.0f - 24;

            StyledGUI.DrawWindowBanner(bannerColor, bannerText, helpURL);

            GUILayout.BeginHorizontal();
            GUILayout.Space(15);

            GUILayout.BeginVertical();

            scrollPosition = GUILayout.BeginScrollView(scrollPosition, false, false, GUILayout.Width(this.position.width - 28), GUILayout.Height(this.position.height - 80));

            EditorGUILayout.HelpBox("Choose the shader render engine to enable instanced indirect support when working with 3rd party tools!", MessageType.Info, true);
            EditorGUILayout.HelpBox("GPU Instancer and Quadro Renderer create compatible shaders automatically and adding support is not required. You can still enable the support if you need the instanced indirect to be added to the original shaders specifically!", MessageType.Warning, true);

            GUILayout.Space(10);

            GUILayout.BeginHorizontal();

            EditorGUI.showMixedValue = showMixedValues;

            EditorGUI.BeginChangeCheck();

            GUILayout.Label("Render Engine Support (All)", GUILayout.Width(220));
            engineIndex = EditorGUILayout.Popup(engineIndex, TVEShaderUtils.RenderEngineOptions, stylePopup);

            if (EditorGUI.EndChangeCheck())
            {
                showMixedValues = false;
            }

            if (showMixedValues)
            {
                GUI.enabled = false;
            }

            if (GUILayout.Button("Install", GUILayout.Width(80)))
            {
                SettingsUtils.SaveSettingsData(userFolder + "/Engine.asset", TVEShaderUtils.RenderEngineOptions[engineIndex]);

                UpdateShaders();
                GetRenderEngineFromShaders();
                GetRenderEngineMixedValues();

                GUIUtility.ExitGUI();
            }

            GUI.enabled = true;
            EditorGUI.showMixedValue = false;

            GUILayout.EndHorizontal();

            GUILayout.Space(10);

            for (int i = 0; i < coreShaderPaths.Count; i++)
            {
                GUILayout.BeginHorizontal();

                var label = Path.GetFileNameWithoutExtension(coreShaderPaths[i].Replace("(TVE Shader)", "(user)"));

                GUILayout.Label(label, GUILayout.Width(220));
                engineOverridesIndices[i] = EditorGUILayout.Popup(engineOverridesIndices[i], TVEShaderUtils.RenderEngineOptions, stylePopup);

                if (GUILayout.Button("Install", GUILayout.Width(80)))
                {
                    var shader = AssetDatabase.LoadAssetAtPath<Shader>(coreShaderPaths[i]);
                    SettingsUtils.SaveSettingsData(userFolder + "/Shaders/Engine " + shader.name.Replace("/", "__") + ".asset", TVEShaderUtils.RenderEngineOptions[engineOverridesIndices[i]]);

                    TVEShaderUtils.InjectShaderFeatures(coreShaderPaths[i], TVEShaderUtils.RenderEngineOptions[engineOverridesIndices[i]]);

                    AssetDatabase.SaveAssets();
                    AssetDatabase.Refresh();

                    GetRenderEngineMixedValues();

                    GUIUtility.ExitGUI();
                }

                GUILayout.EndHorizontal();
            }

            GUILayout.FlexibleSpace();
            GUI.enabled = false;

            GUILayout.Space(20);

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
        }

        void UpdateShaders()
        {
            for (int i = 0; i < coreShaderPaths.Count; i++)
            {
                TVEShaderUtils.InjectShaderFeatures(coreShaderPaths[i], TVEShaderUtils.RenderEngineOptions[engineIndex]);

                var shader = AssetDatabase.LoadAssetAtPath<Shader>(coreShaderPaths[i]);
                SettingsUtils.SaveSettingsData(userFolder + "/Shaders/Engine " + shader.name.Replace("/", "__") + ".asset", TVEShaderUtils.RenderEngineOptions[engineIndex]);
            }

            Debug.Log("[The Vegetation Engine] " + "Shader features updated!");

            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
        }

        void GetRenderEngineFromShaders()
        {
            for (int i = 0; i < coreShaderPaths.Count; i++)
            {
                engineOverridesIndices[i] = TVEShaderUtils.GetRenderEngineIndexFromShader(coreShaderPaths[i]);
            }
        }

        void GetRenderEngineMixedValues()
        {
            showMixedValues = false;

            for (int e = 1; e < engineOverridesIndices.Count; e++)
            {
                if (engineOverridesIndices[e - 1] != engineOverridesIndices[e])
                {
                    showMixedValues = true;
                }
            }
        }
    }
}
