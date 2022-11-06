// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using Boxophobic.StyledGUI;

namespace TheVegetationEngine
{
    [ExecuteInEditMode]
    [AddComponentMenu("BOXOPHOBIC/The Vegetation Engine/TVE Global Motion")]
    public class TVEGlobalMotion : StyledMonoBehaviour
    {
        [StyledBanner(0.890f, 0.745f, 0.309f, "Global Motion", "", "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.czf8ud5bmaq2")]
        public bool styledBanner;

        [StyledCategory("Wind Settings", 5, 10)]
        public bool windCat;

        [Tooltip("Controls the global wind power.")]
        [StyledRangeOptions(0,1, "Wind Power", new string[] { "Calm", "Windy", "Strong" })]
        public float windPower = 0.5f;

        [StyledCategory("Noise Settings")]
        public bool noiseCat;

        [Tooltip("Sets the texture used for wind gust and motion highlight.")]
        public Texture2D noiseTexture;
        [Tooltip("Controls the scale of the noise texture.")]
        public float noiseSize = 50;
        [Tooltip("Controls the speed of the noise texture.")]
        public float noiseSpeed = 1;

        [StyledMessage("Info", "When the Noise is linked with the Motion Direction, smooth direction animation is not supported!", 10, 0)]
        public bool styledLinkMessage = false;

        [Space(10)]
        [Tooltip("Moves the noise texture in the wind direction.")]
        public bool syncNoiseWithMotionDirection = true;

        [StyledSpace(10)]
        public bool styledSpace0;

        float noiseDirectionX;
        float noiseDirectionZ;

        void Start()
        {

#if UNITY_EDITOR
            gameObject.GetComponent<MeshRenderer>().hideFlags = HideFlags.HideInInspector;
            gameObject.GetComponent<MeshFilter>().hideFlags = HideFlags.HideInInspector;
#endif

            // Disable Arrow in play mode
            if (Application.isPlaying == true)
            {
                gameObject.GetComponent<MeshRenderer>().enabled = false;
            }
            else
            {
                gameObject.GetComponent<MeshRenderer>().enabled = true;
            }

            gameObject.name = "Global Motion";
            gameObject.transform.SetSiblingIndex(0);

            if (noiseTexture == null)
            {
                noiseTexture = Resources.Load<Texture2D>("Internal NoiseTex");
            }

            SetGlobalShaderProperties();
        }

        void Update()
        {
            gameObject.transform.eulerAngles = new Vector3(0, gameObject.transform.eulerAngles.y, 0);

            SetGlobalShaderProperties();
        }

        void SetGlobalShaderProperties()
        {
            //Shader.SetGlobalFloat("TVE_WindPower", windPower);

            var windDirection = transform.forward;

            //float windPacked = (Mathf.Atan2(windDirection.x, windDirection.z) / Mathf.PI) * 0.5f + 0.5f;            
            //Vector3 decode = new Vector3( Mathf.Sin( (windPacked * 2 - 1) * Mathf.PI) , 0, Mathf.Cos((windPacked * 2 - 1) * Mathf.PI));
            //Debug.Log(windPacked + "   " + decode);

            //Shader.SetGlobalVector("TVE_VertexParams", new Vector4(windDirection.x * 0.5f + 0.5f, windDirection.z * 0.5f + 0.5f, windPower * 0.5f + 0.5f, 1.0f));
            Shader.SetGlobalVector("TVE_MotionParams", new Vector4(windDirection.x * 0.5f + 0.5f, windDirection.z * 0.5f + 0.5f, windPower, 1.0f));

            if (syncNoiseWithMotionDirection)
            {
                noiseDirectionX = -gameObject.transform.forward.x;
                noiseDirectionZ = -gameObject.transform.forward.z;

                styledLinkMessage = true;
            }
            else
            {
                noiseDirectionX = -1;
                noiseDirectionZ = -1;

                styledLinkMessage = false;
            }

            Shader.SetGlobalTexture("TVE_NoiseTex", noiseTexture);
            Shader.SetGlobalVector("TVE_NoiseSpeed_Vegetation", new Vector2 (noiseSpeed * noiseDirectionX * 0.1f, noiseSpeed * noiseDirectionZ * 0.1f));
            Shader.SetGlobalVector("TVE_NoiseSpeed_Grass", new Vector2(noiseSpeed * 2 * noiseDirectionX * 0.1f, noiseSpeed * 2 * noiseDirectionZ * 0.1f));
            Shader.SetGlobalFloat("TVE_NoiseSize_Vegetation", 1.0f / noiseSize);
            Shader.SetGlobalFloat("TVE_NoiseSize_Grass", 1.0f / (noiseSize / 2));
        }
    }
}
