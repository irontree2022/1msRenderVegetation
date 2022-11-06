// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using Boxophobic.StyledGUI;

namespace TheVegetationEngine
{
    [ExecuteInEditMode]
    [AddComponentMenu("BOXOPHOBIC/The Vegetation Engine/TVE Global Lighting")]
    public class TVEGlobalLighting: StyledMonoBehaviour
    {
        [StyledBanner(0.890f, 0.745f, 0.309f, "Global Lighting", "", "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.q3sme6mi00gy")]
        public bool styledBanner;

        [StyledCategory("Light Settings", 5, 10)]
        public bool lightCat;

        [Tooltip("Sets the main light used as the sun in the scene.")]
        public Light mainLight;
        [Tooltip("Use the subsurface value to remap the light intensity used for Subsurface. This is useful in HDRP where the light intensity can reach high values.")]

        [StyledCategory("Global Settings")]
        public bool subsurfaceCat;

        [Range(0.0f, 1.0f)]
        public float subsurfaceIntensity = 1;
        [Range(0.0f, 1.0f)]
        public float emissiveIntensity = 1;

        [StyledSpace(10)]
        public bool styledSpace0;

        void Start()
        {
            gameObject.name = "Global Lighting";
            gameObject.transform.SetSiblingIndex(4);

            if (mainLight == null)
            {
                SetGlobalLightingMainLight();
            }

            SetGlobalShaderProperties();
        }

        void Update()
        {
            SetGlobalShaderProperties();
        }

        void SetGlobalShaderProperties()
        {
            if (mainLight != null)
            {
                //var intensity = Mathf.Clamp01(mainLight.intensity * mainLightSubsurface);
                var mainLightParams = new Vector4(mainLight.color.r, mainLight.color.g, mainLight.color.b, subsurfaceIntensity);

                Shader.SetGlobalVector("TVE_MainLightParams", mainLightParams);
                Shader.SetGlobalVector("TVE_MainLightDirection", Vector4.Normalize(-mainLight.transform.forward));
            }
            else
            {
                var mainLightParams = new Vector4(1, 1, 1, subsurfaceIntensity);

                Shader.SetGlobalVector("TVE_MainLightParams", mainLightParams);
                Shader.SetGlobalVector("TVE_MainLightDirection", new Vector4(0, 1, 0, 0));
            }

            Shader.SetGlobalFloat("TVE_EmissiveValue", emissiveIntensity);
        }

        void SetGlobalLightingMainLight()
        {
            var allLights = FindObjectsOfType<Light>();
            var intensity = 0.0f;

            for (int i = 0; i < allLights.Length; i++)
            {
                if (allLights[i].type == LightType.Directional)
                {
                    if (allLights[i].intensity > intensity)
                    {
                        mainLight = allLights[i];
                    }
                }
            }
        }
    }
}
