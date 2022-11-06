// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using Boxophobic.StyledGUI;
#if UNITY_EDITOR
using System.IO;
using UnityEditor;
#endif

namespace TheVegetationEngine
{
    [ExecuteInEditMode]
    [AddComponentMenu("BOXOPHOBIC/The Vegetation Engine/TVE Global Overlay")]
    public class TVEGlobalOverlay : StyledMonoBehaviour
    {
        [StyledBanner(0.890f, 0.745f, 0.309f, "Global Overlay", "", "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.g40aci2udwrg")]
        public bool styledBanner;

        [StyledCategory("Overlay Settings", 5, 10)]
        public bool overlayCat;

        [Tooltip("Controls the global overlay intensity.")]
        [Range(0.0f, 1.0f)]
        public float overlayIntensity = 0.0f;

        [Tooltip("Controls the global overlay color.")]
        [ColorUsage(false, true)]
        public Color overlayColor = Color.white;
        [Tooltip("Controls the global overlay smoothness.")]
        [Range(0.0f, 1.0f)]
        public float overlaySmoothness = 0.5f;

        [StyledCategory("Advanced Settings")]
        public bool advancedCat;

        [StyledMessage("Info", "The overlay texures are disabled for the built-in shaders. They will only be used for shaders compiled with the Overlay Quality option set to Standard on the Amplify Base function!", 0, 10)]
        public bool styledMessage = true;

        [Tooltip("Sets the global overlay albedo texture.")]
        public Texture2D overlayAlbedo;
        [Tooltip("Sets the global overlay normal texture.")]
        public Texture2D overlayNormal;
        [Tooltip("Controls the global overlay albedo and normal texture tilling.")]
        [Range(0.0f, 10.0f)]
        public float overlayTilling = 1.0f;
        [Tooltip("Controls the global overlay normal texture intensity.")]
        [Range(-8.0f, 8.0f)]
        public float overlayNormalScale = 1.0f;

        [StyledSpace(10)]
        public bool styledSpace0;

        Texture2D dummyNormalTex;

        void Start()
        {
            gameObject.name = "Global Overlay";
            gameObject.transform.SetSiblingIndex(2);

            dummyNormalTex = Resources.Load<Texture2D>("Internal NormalTex");

            SetGlobalShaderProperties();
        }

        void Update()
        {
            SetGlobalShaderProperties();
        }

        void SetGlobalShaderProperties()
        {
            Shader.SetGlobalFloat("TVE_OverlayValue", overlayIntensity);
            Shader.SetGlobalColor("TVE_OverlayColor", overlayColor);

            if (overlayAlbedo != null)
            {
                Shader.SetGlobalTexture("TVE_OverlayAlbedoTex", overlayAlbedo);
            }
            else
            {
                Shader.SetGlobalTexture("TVE_OverlayAlbedoTex", Texture2D.whiteTexture);
            }

            if (overlayNormal != null)
            {
                Shader.SetGlobalTexture("TVE_OverlayNormalTex", overlayNormal);
            }
            else
            {
                Shader.SetGlobalTexture("TVE_OverlayNormalTex", dummyNormalTex);
            }

            Shader.SetGlobalFloat("TVE_OverlayUVTilling", overlayTilling);
            Shader.SetGlobalFloat("TVE_OverlayNormalValue", overlayNormalScale);
            Shader.SetGlobalFloat("TVE_OverlaySmoothness", overlaySmoothness);
        }
    }
}
