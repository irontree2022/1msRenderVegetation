// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using Boxophobic.StyledGUI;

#if UNITY_EDITOR
using UnityEditor.SceneManagement;
#endif

namespace TheVegetationEngine
{
    [ExecuteInEditMode]
    public class TVEManager : StyledMonoBehaviour
    {
        public static TVEManager Instance;

        [StyledBanner(0.890f, 0.745f, 0.309f, "The Vegetation Engine", "", "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.hbq3w8ae720x")]
        public bool styledBanner;

        int assetVersion = 400;
        [HideInInspector]
        public int userVersion;

        [HideInInspector]
        public bool isInitialized = false;

        [HideInInspector]
        public TVEGlobalMotion globalMotion;
        [HideInInspector]
        public TVEGlobalSeasons globalSeasons;
        [HideInInspector]
        public TVEGlobalOverlay globalOverlay;
        [HideInInspector]
        public TVEGlobalWetness globalWetness;
        [HideInInspector]
        public TVEGlobalLighting globalLighting;
        [HideInInspector]
        public TVEGlobalDetails globalDetails;
        [HideInInspector]
        public TVEGlobalSettings globalSettings;
        [HideInInspector]
        public TVEGlobalVolume globalVolume;

        void OnEnable()
        {
            Instance = this;

            if (globalMotion == null)
            {
                GameObject go = new GameObject();

                go.AddComponent<MeshFilter>();
                go.GetComponent<MeshFilter>().mesh = Resources.Load<Mesh>("ArrowMesh");

                go.AddComponent<MeshRenderer>();
                go.GetComponent<MeshRenderer>().sharedMaterial = Resources.Load<Material>("ArrowMotion");

                go.AddComponent<TVEGlobalMotion>();

                SetParent(go);

                go.transform.localPosition = new Vector3(0, 2f, 0);

                globalMotion = go.GetComponent<TVEGlobalMotion>();
            }
            else
            {
                globalMotion.enabled = true;
            }

            if (globalSeasons == null)
            {
                GameObject go = new GameObject();
                go.AddComponent<TVEGlobalSeasons>();
                SetParent(go);

                globalSeasons = go.GetComponent<TVEGlobalSeasons>();
            }
            else
            {
                globalSeasons.enabled = true;
            }

            if (globalOverlay == null)
            {
                GameObject go = new GameObject();
                go.AddComponent<TVEGlobalOverlay>();

                SetParent(go);

                globalOverlay = go.GetComponent<TVEGlobalOverlay>();
            }
            else
            {
                globalOverlay.enabled = true;
            }

            if (globalWetness == null)
            {
                GameObject go = new GameObject();
                go.AddComponent<TVEGlobalWetness>();
                SetParent(go);

                globalWetness = go.GetComponent<TVEGlobalWetness>();
            }
            else
            {
                globalWetness.enabled = true;
            }

            if (globalLighting == null)
            {
                GameObject go = new GameObject();
                go.AddComponent<TVEGlobalLighting>();
                SetParent(go);

                globalLighting = go.GetComponent<TVEGlobalLighting>();
            }
            else
            {
                globalLighting.enabled = true;
            }

            if (globalSettings == null)
            {
                GameObject go = new GameObject();
                go.AddComponent<TVEGlobalSettings>();
                SetParent(go);

                globalSettings = go.GetComponent<TVEGlobalSettings>();
            }
            else
            {
                globalSettings.enabled = true;
            }

            if (globalDetails == null)
            {
                GameObject go = new GameObject();
                go.AddComponent<TVEGlobalDetails>();
                SetParent(go);

                globalDetails = go.GetComponent<TVEGlobalDetails>();
            }
            else
            {
                globalDetails.enabled = true;
            }

            if (globalVolume == null)
            {
                GameObject go = new GameObject();
                go.AddComponent<TVEGlobalVolume>();
                SetParent(go);

                go.transform.localScale = new Vector3(400, 200, 400);

                globalVolume = go.GetComponent<TVEGlobalVolume>();
            }
            else
            {
                globalVolume.enabled = true;
            }

            if (isInitialized == false)
            {
                Debug.Log("[The Vegetation Engine] " + "The Vegetation Engine is set in the current scene! Check the Documentation for the next steps!");
                userVersion = assetVersion;
                isInitialized = true;
            }

            //if (userVersion < 150)
            //{
            //    UpgradeTo150();
            //}
        }

        //void Start()
        //{
//            if (userVersion < 150)
//            {
//                userVersion = 150;
//#if UNITY_EDITOR
//                Debug.Log("[The Vegetation Engine] The Scene Manager has been ugraded to 1.5.0!");

//                if (Application.isPlaying == false)
//                {
//                    EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
//                }
//#endif
//            }
        //}

        void SetParent(GameObject go)
        {
            go.transform.parent = gameObject.transform;
            go.transform.localPosition = Vector3.zero;
            go.transform.eulerAngles = Vector3.zero;
            go.transform.localScale = Vector3.one;
        }
    }
}