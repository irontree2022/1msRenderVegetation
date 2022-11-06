// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using Boxophobic.StyledGUI;

namespace TheVegetationEngine
{
    [ExecuteInEditMode]
    [AddComponentMenu("BOXOPHOBIC/The Vegetation Engine/TVE Global Settings")]
    public class TVEGlobalSettings : StyledMonoBehaviour
    {
        [StyledBanner(0.890f, 0.745f, 0.309f, "Global Settings", "", "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.q3sme6mi00gy")]
        public bool styledBanner;

        [StyledCategory("Noise Settings", 5, 10)]
        public bool noiseCat;

        [Tooltip("Sets the global world space 3D noise texture used for gradient and noise  settings.")]
        public Texture3D worldNoiseTexture;
        
        [Tooltip("Sets the global screen space 3D noise texture used for camera distance and glancing angle fade.")]
        public Texture3D screenNoiseTexture;
        [Tooltip("Controls the global screen space 3D noise texture scale used for camera distance and glancing angle fade.")]
        [Range(0.0f, 20.0f)]
        public float screenNoiseScale = 5.0f;

        [StyledCategory("Fade Settings")]
        public bool fadeCat;

        [Tooltip("Controls the Size Fade paramters on the materials. With higher values, the fade will happen at a greater distance.")]
        public float distanceFadeBias = 1.0f;
        [Tooltip("Controls the Camera fade distance in world units.")]
        public float cameraFadeBias = 1.0f;
        [Tooltip("Controls the Detail Motion (Flutter) fade out distance in world units.")]
        public float motionFadeBias = 60.0f;

        [StyledSpace(10)]
        public bool styledSpace0;

        void Start()
        {
            gameObject.name = "Global Settings";
            gameObject.transform.SetSiblingIndex(5);

            if (worldNoiseTexture == null)
            {
                worldNoiseTexture = CreateNoiseTexture("Internal WorldTex3D");
            }

            if (screenNoiseTexture == null)
            {
                screenNoiseTexture = CreateNoiseTexture("Internal ScreenTex3D");
            }

            SetGlobalShaderProperties();
        }

        void Update()
        {
            SetGlobalShaderProperties();
        }

        void SetGlobalShaderProperties()
        {
            Shader.SetGlobalTexture("TVE_WorldTex3D", worldNoiseTexture);
            Shader.SetGlobalTexture("TVE_ScreenTex3D", screenNoiseTexture);
            Shader.SetGlobalFloat("TVE_ScreenTexCoord", screenNoiseScale);

            Shader.SetGlobalFloat("TVE_DistanceFadeBias", distanceFadeBias);
            Shader.SetGlobalFloat("TVE_CameraFadeStart", cameraFadeBias * 0.5f);
            Shader.SetGlobalFloat("TVE_CameraFadeEnd", cameraFadeBias);
            Shader.SetGlobalFloat("TVE_MotionFadeStart", motionFadeBias * 0.5f);
            Shader.SetGlobalFloat("TVE_MotionFadeEnd", motionFadeBias);
        }

        Texture3D CreateNoiseTexture(string name)
        {
            int size = 16;

            Texture3D texture = new Texture3D(size, size, size, TextureFormat.R8, false);
            texture.wrapMode = TextureWrapMode.Repeat;
            texture.name = name;

            Color[] colors = new Color[size * size * size];

            for (int z = 0; z < size; z++)
            {
                int zOffset = z * size * size;
                for (int y = 0; y < size; y++)
                {
                    int yOffset = y * size;
                    for (int x = 0; x < size; x++)
                    {
                        colors[x + yOffset + zOffset] = new Color(Random.Range(0f, 1f), 0, 0);
                    }
                }
            }

            texture.SetPixels(colors);
            texture.Apply();

            return texture;
        }
    }
}
