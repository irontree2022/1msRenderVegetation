using UnityEditor;
using UnityEngine;

namespace TheVegetationEngineImpostors
{
    public static class TVEAIMenuWindows
    {
        [MenuItem("Window/BOXOPHOBIC/The Vegetation Engine | Amplify Impostors/Discord Server", false, 8000)]
        public static void Discord()
        {
            Application.OpenURL("https://discord.com/invite/znxuXET");
        }

        [MenuItem("Window/BOXOPHOBIC/The Vegetation Engine | Amplify Impostors/Publisher Page", false, 8001)]
        public static void AssetStore()
        {
            Application.OpenURL("https://assetstore.unity.com/publishers/20529");
        }

        [MenuItem("Window/BOXOPHOBIC/The Vegetation Engine | Amplify Impostors/Documentation", false, 8002)]
        public static void Documentation()
        {
            Application.OpenURL("https://docs.google.com/document/d/1otI7lGjXNL9FYmvvogNUG4ymG8tUrlUmwbrTj9hFMN8/edit#heading=h.u2ox035i3s3h");
        }

        [MenuItem("Window/BOXOPHOBIC/The Vegetation Engine | Amplify Impostors/Changelog", false, 8003)]
        public static void Changelog()
        {
            Application.OpenURL("https://docs.google.com/document/d/1otI7lGjXNL9FYmvvogNUG4ymG8tUrlUmwbrTj9hFMN8/edit#heading=h.1rbujejuzjce");
        }

        [MenuItem("Window/BOXOPHOBIC/The Vegetation Engine | Amplify Impostors/Write A Review", false, 9999)]
        public static void WriteAReview()
        {
            Application.OpenURL("https://assetstore.unity.com/packages/vfx/shaders/the-vegetation-engine-amplify-impostors-module-189099#reviews");
        }
    }
}


