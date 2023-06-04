using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Xml;
using Unity.VisualScripting;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// 区块植被数据状态
    /// </summary>
    public class BlockVegetationDatas
    {
        /// <summary>
        /// 区块编号
        /// </summary>
        public int ID;
        /// <summary>
        /// 植被数据总量
        /// </summary>
        public int TotalDataCount;
        /// <summary>
        /// 数据量太多了
        /// <para>数据量超过 Settings.MaxBytesInSingleBlock 时，TooMuchData就会设置为ture，标识该区块将不在分配数据</para>
        /// </summary>
        public bool TooMuchData;
        /// <summary>
        /// 模型原型数量
        /// </summary>
        public int ModelPrototypeCount;
        /// <summary>
        /// 模型原型对应编号
        /// </summary>
        public int[] ModelPrototypeIDs;
        /// <summary>
        /// 当前区块内包含的植被数据
        /// <para>编辑器预处理植被的时候使用该字段</para>
        /// </summary>
        public List<VegetationInstanceData>[] Datas;
        /// <summary>
        /// 当前区块内包含的植被数据
        /// <para>运行时，使用该字段</para>
        /// </summary>
        public VegetationInstanceData[][] DatasArray;

        public override string ToString() => $"(ID: {ID}, 植被数据总量: {TotalDataCount}, TooMuchData: {TooMuchData}, 模型原型数量: {ModelPrototypeCount})";

        /// <summary>
        /// 数据写入文件中
        /// </summary>
        public long Write(BinaryWriter binaryWriter)
        {
            long bytesCount = 0;
            binaryWriter.Write(ID);
            binaryWriter.Write(TotalDataCount);
            binaryWriter.Write(TooMuchData);
            binaryWriter.Write(ModelPrototypeCount);
            bytesCount = sizeof(int) * 3 + sizeof(bool);

            for (var i = 0; i < ModelPrototypeCount; i++)
            {
                binaryWriter.Write(ModelPrototypeIDs[i]);
                bytesCount += sizeof(int);
                if (TooMuchData) continue;
                var list = Datas[i];
                var _length = list == null ? 0 : list.Count;
                binaryWriter.Write(_length);
                bytesCount += sizeof(int);
                for (var j = 0; j < _length; j++)
                    list[j].Write(binaryWriter);
                bytesCount += VegetationInstanceData.stride * _length;
            }

            return bytesCount;
        }
        /// <summary>
        /// 从缓冲中读取数据
        /// </summary>
        /// <param name="buffer">缓冲</param>
        /// <param name="startIndex">开始位置</param>
        public void ReadFromBuffer(byte[] buffer, int startIndex)
        {
            ID = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            TotalDataCount = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            TooMuchData = BitConverter.ToBoolean(buffer, startIndex); startIndex += sizeof(bool);
            ModelPrototypeCount = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            if(ModelPrototypeCount > 0)
            {
                ModelPrototypeIDs = new int[ModelPrototypeCount];
                for (var i = 0; i < ModelPrototypeCount; i++)
                {
                    ModelPrototypeIDs[i] = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
                    if (TooMuchData) continue;
                    var length = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
                    if (length == 0) continue;
                    if (DatasArray == null) DatasArray = new VegetationInstanceData[ModelPrototypeCount][];
                    DatasArray[i] = new VegetationInstanceData[length];
                    for (var j = 0; j < length; j++)
                    {
                        var vid = new VegetationInstanceData();
                        vid.ReadFromBuffer(buffer, startIndex);
                        DatasArray[i][j] = vid;
                        startIndex += VegetationInstanceData.stride;
                    }
                }
            }
        }          
    }

}
