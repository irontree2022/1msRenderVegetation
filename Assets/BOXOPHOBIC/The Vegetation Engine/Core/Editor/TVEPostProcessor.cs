#if !THE_VEGETATION_ENGINE_DEVELOPMENT

using Boxophobic.Utils;
using UnityEditor;
using UnityEngine;

namespace TheVegetationEngine
{
    class TVEPostProcessor : AssetPostprocessor
    {
        static void OnPostprocessAllAssets(string[] importedAssets, string[] deletedAssets, string[] movedAssets, string[] movedFromAssetPaths)
        {
            foreach (var asset in importedAssets)
            {
                if (asset.EndsWith(".shader"))
                {
                    if (TVEShaderUtils.IsValidTVEShader(asset))
                    {
                        string userFolder = "Assets/BOXOPHOBIC/User";

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

                        var shader = AssetDatabase.LoadAssetAtPath<Shader>(asset);
                        var engine = SettingsUtils.LoadSettingsData(userFolder + "/Shaders/Engine " + shader.name.Replace("/", "__") + ".asset", "Unity Default Renderer");

                        TVEShaderUtils.InjectShaderFeatures(asset, engine);

                        AssetDatabase.SaveAssets();
                        AssetDatabase.Refresh();
                    }
                }
            }
        }
    }
}

#endif