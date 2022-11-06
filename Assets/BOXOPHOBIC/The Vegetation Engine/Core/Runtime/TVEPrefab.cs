// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using System.Collections.Generic;
using Boxophobic.StyledGUI;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace TheVegetationEngine
{
#if UNITY_EDITOR
    [ExecuteInEditMode]
    [AddComponentMenu("BOXOPHOBIC/The Vegetation Engine/TVE Prefab")]
#endif
    public class TVEPrefab : StyledMonoBehaviour
    {
#if UNITY_EDITOR
        [StyledBanner(0.890f, 0.745f, 0.309f, "Prefab", "", "")]
        public bool styledBanner;

        [HideInInspector]
        public GameObject storedPrefabBackup;
        [HideInInspector]
        public string storedPrefabBackupGUID;
        [HideInInspector]
        public Vector4 storedMaxBoundsInfo;
        [HideInInspector]
        public string storedPreset;
        [HideInInspector]
        public List<string> storedOverrides;
#endif
    }
}


