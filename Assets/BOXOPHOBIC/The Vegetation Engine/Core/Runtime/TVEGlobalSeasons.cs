// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using Boxophobic.StyledGUI;

namespace TheVegetationEngine
{
    [ExecuteInEditMode]
    [AddComponentMenu("BOXOPHOBIC/The Vegetation Engine/TVE Global Seasons")]
    public class TVEGlobalSeasons : StyledMonoBehaviour
    {
        [StyledBanner(0.890f, 0.745f, 0.309f, "Global Seasons", "", "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.969g8bl1p3qo")]
        public bool styledBanner;

        [StyledCategory("Control Settings", 5, 10)]
        public bool controlCat;

        [Tooltip("Use the Seasons slider to control the element properties when the element is set to Seasons mode.")]
        [StyledRangeOptions(0, 4, "Season", new string[] { "Winter", "Spring", "Summer", "Autumn", "Winter"})]
        public float season = 2f;

        [StyledSpace(10)]
        public bool styledSpace0;

        void Start()
        {
            gameObject.name = "Global Seasons";
            gameObject.transform.SetSiblingIndex(1);

            SetGlobalShaderProperties();
        }

        void Update()
        {
            SetGlobalShaderProperties();
        }

        void SetGlobalShaderProperties()
        {
            var seasonLerp = 0.0f;

            if (season >= 0 && season < 1)
            {
                seasonLerp = season;
                Shader.SetGlobalVector("TVE_SeasonOptions", new Vector4(1, 0, 0, 0));
                Shader.SetGlobalFloat("TVE_SeasonLerp", Mathf.SmoothStep(0, 1, seasonLerp));
            }
            else if (season >= 1 && season < 2)
            {
                seasonLerp = season - 1.0f;
                Shader.SetGlobalVector("TVE_SeasonOptions", new Vector4(0, 1, 0, 0));
                Shader.SetGlobalFloat("TVE_SeasonLerp", Mathf.SmoothStep(0, 1, seasonLerp));
            }
            else if (season >= 2 && season < 3)
            {
                seasonLerp = season - 2.0f;
                Shader.SetGlobalVector("TVE_SeasonOptions", new Vector4(0, 0, 1, 0));
                Shader.SetGlobalFloat("TVE_SeasonLerp", Mathf.SmoothStep(0, 1, seasonLerp));
            }
            else if (season >= 3 && season <= 4)
            {
                seasonLerp = season - 3.0f;
                Shader.SetGlobalVector("TVE_SeasonOptions", new Vector4(0, 0, 0, 1));
                Shader.SetGlobalFloat("TVE_SeasonLerp", Mathf.SmoothStep(0, 1, seasonLerp));
            }
        }
    }
}
