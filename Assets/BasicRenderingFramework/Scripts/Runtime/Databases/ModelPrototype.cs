using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

namespace RenderVegetationIn1ms
{    
    /// <summary>
    /// ģ��ԭ��
    /// </summary>
    [Serializable]
    public class ModelPrototype
    {
        [Header("Ψһ��ʶID��")]
        public int ID;
        [Header("����")]
        public string PrefabName;
        [Header("����")]
        public VegetationType Type;

        [Header("ģ�ͱ�������")]
        [Header("Ԥ����")]
        public GameObject PrefabObject;
        [Header("��Ƭ")]
        public GameObject PrefabImpostor;
        [Header("PrefabObject��Χ��")]
        public Bounds Bounds;
        [Header("PrefabObject�Ƿ����LODGroup")]
        public bool isLODGroup;
        [Header("PrefabObject LOD����")]
        public int lodCount;
        [Header("PrefabObject LODֵ")]
        public Vector4 LODLevels;
        [Header("LODGroup size")]
        public float LODGroupSize;

        [Header("��Ⱦ����")]
        [Header("ֲ��ģ��ԭ��layer")]
        public int layer;
        [Header("�Ƿ������Ӱ��")]
        public bool receiveShadows = true;
        [Header("��Ӱģʽ")]
        public UnityEngine.Rendering.ShadowCastingMode shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
        [Header("��Ⱦ��Ƭ?")]
        public bool enableRenderImpostor;


        public ModelPrototype(int id) => Init(id, PrefabObject);
        public ModelPrototype(int id, GameObject prefab) => Init(id, prefab);
        public void Init(int id) => Init(id, PrefabObject);
        public void Init(int id, GameObject prefab)
        {
            ID = id;
            Bounds = new Bounds();
            PrefabObject = prefab;
            PrefabImpostor = null;
            layer = 0;
            receiveShadows = true;
            shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
            PrefabName = null;
            lodCount = 0;
            LODLevels = Vector4.zero;
            isLODGroup = false;
            if (PrefabObject != null)
            {
                PrefabName = PrefabObject.name;
                Bounds = Tool.GetBounds(PrefabObject);
                ResetLODLevels(PrefabObject.GetComponent<LODGroup>());
            }
        }
        /// <summary>
        /// ���¼���ģ�͸���LODֵ
        /// </summary>
        public void ResetLODLevels(LODGroup lodg = null)
        {
            LODGroupSize = 1f;
            if (PrefabObject != null)
            {
                if (lodg == null)
                    lodg = PrefabObject.GetComponent<LODGroup>();
                isLODGroup = lodg != null;
                if (isLODGroup)
                {
                    LODGroupSize = lodg.size;
                    var lods = lodg.GetLODs();
                    lodCount = lods.Length;
                    for (var i = 0; i < lodCount; i++)
                    {
                        if (i > 3) break;
                        var lod = lods[i].screenRelativeTransitionHeight;
                        if (i == 0) LODLevels.x = lod;
                        else if (i == 1) LODLevels.y = lod;
                        else if (i == 2) LODLevels.z = lod;
                        else if (i == 3) LODLevels.w = lod;
                    }
                }
            }
        }
    }
}
