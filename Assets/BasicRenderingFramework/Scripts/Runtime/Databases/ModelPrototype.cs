using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

namespace RenderVegetationIn1ms
{    
    /// <summary>
    /// 模型原型
    /// </summary>
    [Serializable]
    public class ModelPrototype
    {
        [Header("唯一标识ID号")]
        public int ID;
        [Header("名称")]
        public string PrefabName;
        [Header("类型")]
        public VegetationType Type;

        [Header("模型本身数据")]
        [Header("预制体")]
        public GameObject PrefabObject;
        [Header("面片")]
        public GameObject PrefabImpostor;
        [Header("PrefabObject包围盒")]
        public Bounds Bounds;
        [Header("PrefabObject是否存在LODGroup")]
        public bool isLODGroup;
        [Header("PrefabObject LOD数量")]
        public int lodCount;
        [Header("PrefabObject LOD值")]
        public Vector4 LODLevels;
        [Header("LODGroup size")]
        public float LODGroupSize;

        [Header("渲染数据")]
        [Header("植被模型原型layer")]
        public int layer;
        [Header("是否接收阴影？")]
        public bool receiveShadows = true;
        [Header("阴影模式")]
        public UnityEngine.Rendering.ShadowCastingMode shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
        [Header("渲染面片?")]
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
        /// 重新计算模型各级LOD值
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
