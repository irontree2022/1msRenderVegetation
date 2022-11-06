using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    [CreateAssetMenu(fileName = "RawVegetationDatabase", menuName = "RenderVegetationIn1ms/RawVegetationDatabase")]
    public class RawVegetationDatabase : ScriptableObject
    {
        [Header("原始总植被数量")]
        public int RawTotal;
        [Header("原始总植被数量_树")]
        public int RawTreeTotal;
        [Header("原始总植被数量_石头")]
        public int RawStoneTotal;
        [Header("原始总植被数量_草")]
        public int RawGrassTotal;
        [Header("所有原始植被实例数据库")]
        public List<RawInstances> rawVegetationInstanceDatabases;


        /// <summary>
        /// 遍历数据库中每个植被数据
        /// </summary>
        /// <param name="elementAction">每找的一个植被数据，则会回调该Action，将找到的植被数据作为参数传递进去</param>
        public void Each(System.Action<int, int, VegetationInstanceData> elementAction)
        {
            if (elementAction == null) return;
            if(rawVegetationInstanceDatabases != null)
            {
                var index = 0;
                for(var i = 0; i < rawVegetationInstanceDatabases.Count; i++)
                {
                    var ri = rawVegetationInstanceDatabases[i];
                    if(ri != null && ri.database != null)
                        for (var j = 0; j < ri.database.Count; j++)
                            elementAction(index++, RawTotal, ri.database[j]);
                }
            }
        }
    }
}
