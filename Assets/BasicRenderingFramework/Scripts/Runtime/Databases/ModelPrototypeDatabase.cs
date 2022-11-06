using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace RenderVegetationIn1ms
{
    /// <summary>
    /// 模型原型数据库
    /// </summary>
    [CreateAssetMenu(fileName = "ModelPrototypeDatabase", menuName = "RenderVegetationIn1ms/ModelPrototypeDatabase")]
    public class ModelPrototypeDatabase : ScriptableObject
    {
        public List<ModelPrototype> ModelPrototypeList = new List<ModelPrototype>();
    }

}
