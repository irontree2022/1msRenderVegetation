// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using Boxophobic.StyledGUI;

namespace TheVegetationEngine
{
    [ExecuteInEditMode]
    [AddComponentMenu("BOXOPHOBIC/The Vegetation Engine/TVE Global Wetness")]
    public class TVEGlobalWetness : StyledMonoBehaviour
    {
        [StyledBanner(0.890f, 0.745f, 0.309f, "Global Wetness", "", "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.oaihoayshutd")]
        public bool styledBanner;

        [StyledCategory("Wetness Settings", 5, 10)]
        public bool wetnessCat;

        [Tooltip("Use the Wetness slider to control the smoothness on vegetation and props for a wet look. The wetness can be controlled locally with Wetness elements.")]
        [StyledRangeOptions(0f, 1f, "Wetness", new string[] { "Default", "Wet"})]
        public float wetness = 0f;

        [StyledSpace(10)]
        public bool styledSpace0;

        void Start()
        {
            gameObject.name = "Global Wetness";
            gameObject.transform.SetSiblingIndex(3);

            SetGlobalShaderProperties();
        }

        void Update()
        {
            SetGlobalShaderProperties();
        }
        void SetGlobalShaderProperties()
        {
            Shader.SetGlobalFloat("TVE_WetnessValue", Mathf.Clamp01(wetness));
        }
    }
}
