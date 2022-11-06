// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using Boxophobic.StyledGUI;

namespace TheVegetationEngine
{
    [ExecuteInEditMode]
    [AddComponentMenu("BOXOPHOBIC/The Vegetation Engine/TVE Global Details")]
    public class TVEGlobalDetails : StyledMonoBehaviour
    {
        [StyledBanner(0.890f, 0.745f, 0.309f, "Global Details", "", "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.pq49kopnu8z2")]
        public bool styledBanner;

        [StyledMessage("Info", "The Detail settings are used to control the terrain grass and details for the Terrain Detail Add-on!")]
        public bool styledMessage = true;

        [StyledCategory("Global Settings")]
        public bool globalCat;

        [StyledEnum("Default _Layer 1 _Layer 2 _Layer 3 _Layer 4 _Layer 5 _Layer 6 _Layer 7 _Layer 8")]
        public int layerColors = 0;
        [StyledEnum("Default _Layer 1 _Layer 2 _Layer 3 _Layer 4 _Layer 5 _Layer 6 _Layer 7 _Layer 8")]
        public int layerExtras = 0;
        [StyledEnum("Default _Layer 1 _Layer 2 _Layer 3 _Layer 4 _Layer 5 _Layer 6 _Layer 7 _Layer 8")]
        public int layerMotion = 0;
        [StyledEnum("Default _Layer 1 _Layer 2 _Layer 3 _Layer 4 _Layer 5 _Layer 6 _Layer 7 _Layer 8")]
        public int layerReact = 0;

        [Space(10)]
        [Range(0, 1)]
        public float globalColors = 1;
        [Range(0, 1)]
        public float globalOverlay = 1;
        [Range(0, 1)]
        public float globalWetness = 1;
        [Range(0, 1)]
        public float globalAlpha = 1;

        [Space(10)]
        [Range(0, 1)]
        public float colorsMaskMin = 0.4f;
        [Range(0, 1)]
        public float colorsMaskMax = 0.6f;
        [Range(0, 1)]
        public float overlayMaskMin = 0.4f;
        [Range(0, 1)]
        public float overlayMaskMax = 0.6f;

        [Space(10)]
        [Range(0, 1)]
        public float alphaTreshold = 0.5f;

        [StyledCategory("Perspective Settings")]
        public bool perspectiveCat;

        [Range(0, 4)]
        public float perspectivePush = 0;
        [Range(0, 4)]
        public float perspectiveNoise = 0;
        [Range(0, 8)]
        public float perspectiveAngle = 1;

        [StyledCategory("Motion Settings")]
        public bool motionCat;

        [ColorUsage(false, true)]
        public Color motionHighlight = new Color(1, 1, 1, 1);

        [Space(10)]
        [Range(0, 2)]
        public float motionAmplitude = 1f;
        [Range(0, 30)]
        public int motionSpeed = 8;
        [Range(0, 10)]
        public float motionScale = 1;

        [Space(10)]
        [Range(0, 2)]
        public float flutterAmplitude = 0.1f;
        [Range(0, 30)]
        public int flutterSpeed = 20;
        [Range(0, 10)]
        public float flutterScale = 2;

        [Space(10)]
        [Range(0, 10)]
        public float iteractionAmplitude = 1;

        [StyledSpace(5)]
        public bool styledSpace0;

        void Start()
        {
            gameObject.name = "Global Details";
            gameObject.transform.SetSiblingIndex(6);

            SetGlobalShaderProperties();
        }

#if UNITY_EDITOR
        void Update()
        {
            SetGlobalShaderProperties();
        }
#endif

        void SetGlobalShaderProperties()
        {
            Shader.SetGlobalFloat("TVE_DetailLayerColors", layerColors);
            Shader.SetGlobalFloat("TVE_DetailLayerExtras", layerExtras);
            Shader.SetGlobalFloat("TVE_DetailLayerMotion", layerMotion);
            Shader.SetGlobalFloat("TVE_DetailLayerReaact", layerReact);

            Shader.SetGlobalFloat("TVE_DetailGlobalColors", globalColors);
            Shader.SetGlobalFloat("TVE_DetailGlobalOverlay", globalOverlay);
            Shader.SetGlobalFloat("TVE_DetailGlobalWetness", globalWetness);
            Shader.SetGlobalFloat("TVE_DetailGlobalAlpha", globalAlpha);

            Shader.SetGlobalFloat("TVE_DetailColorsMaskMin", colorsMaskMin);
            Shader.SetGlobalFloat("TVE_DetailColorsMaskMax", colorsMaskMax);
            Shader.SetGlobalFloat("TVE_DetailOverlayMaskMin", overlayMaskMin);
            Shader.SetGlobalFloat("TVE_DetailOverlayMaskMax", overlayMaskMax);

            Shader.SetGlobalFloat("TVE_DetailCutoff", alphaTreshold - 0.5f);

            Shader.SetGlobalFloat("TVE_DetailPerspectivePush", perspectivePush);
            Shader.SetGlobalFloat("TVE_DetailPerspectiveNoise", perspectiveNoise);
            Shader.SetGlobalFloat("TVE_DetailPerspectiveAngle", perspectiveAngle);

            Shader.SetGlobalColor("TVE_DetailMotionHighlightColor", motionHighlight);
            Shader.SetGlobalFloat("TVE_DetailMotionAmplitude_10", motionAmplitude);
            Shader.SetGlobalFloat("TVE_DetailMotionSpeed_10", motionSpeed);
            Shader.SetGlobalFloat("TVE_DetailMotionScale_10", motionScale);
            Shader.SetGlobalFloat("TVE_DetailMotionAmplitude_32", flutterAmplitude);
            Shader.SetGlobalFloat("TVE_DetailMotionSpeed_32", flutterSpeed);
            Shader.SetGlobalFloat("TVE_DetailMotionScale_32", flutterScale);
            Shader.SetGlobalFloat("TVE_DetailInteractionAmplitude", iteractionAmplitude);
        }
    }
}
