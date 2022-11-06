using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    [CreateAssetMenu(fileName = "RawVegetationDatabase", menuName = "RenderVegetationIn1ms/RawVegetationDatabase")]
    public class RawVegetationDatabase : ScriptableObject
    {
        [Header("ԭʼ��ֲ������")]
        public int RawTotal;
        [Header("ԭʼ��ֲ������_��")]
        public int RawTreeTotal;
        [Header("ԭʼ��ֲ������_ʯͷ")]
        public int RawStoneTotal;
        [Header("ԭʼ��ֲ������_��")]
        public int RawGrassTotal;
        [Header("����ԭʼֲ��ʵ�����ݿ�")]
        public List<RawInstances> rawVegetationInstanceDatabases;


        /// <summary>
        /// �������ݿ���ÿ��ֲ������
        /// </summary>
        /// <param name="elementAction">ÿ�ҵ�һ��ֲ�����ݣ����ص���Action�����ҵ���ֲ��������Ϊ�������ݽ�ȥ</param>
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
