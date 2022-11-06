using UnityEditor;
using UnityEngine;

namespace TheVegetationEngine
{

    public static class TVEMenuWindows
    {
        [MenuItem("Window/BOXOPHOBIC/The Vegetation Engine/Discord Server", false, 8000)]
        public static void Discord()
        {
            Application.OpenURL("https://discord.com/invite/znxuXET");
        }

        [MenuItem("Window/BOXOPHOBIC/The Vegetation Engine/Publisher Page", false, 8001)]
        public static void AssetStore()
        {
            Application.OpenURL("https://assetstore.unity.com/publishers/20529");
        }

        [MenuItem("Window/BOXOPHOBIC/The Vegetation Engine/Documentation", false, 8002)]
        public static void Documentation()
        {
            Application.OpenURL("https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#");
        }

        [MenuItem("Window/BOXOPHOBIC/The Vegetation Engine/Changelog", false, 8003)]
        public static void Chnagelog()
        {
            Application.OpenURL("https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.1rbujejuzjce");
        }

        [MenuItem("Window/BOXOPHOBIC/The Vegetation Engine/Write A Review", false, 9999)]
        public static void WriteAReview()
        {
            Application.OpenURL("https://assetstore.unity.com/packages/tools/utilities/the-vegetation-engine-159647#reviews");
        }
    }
}

