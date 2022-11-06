using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    public class RawInstances : ScriptableObject
    {
        [Header("单个原始植被实例数据库")]
        public List<VegetationInstanceData> database;
    }
}
