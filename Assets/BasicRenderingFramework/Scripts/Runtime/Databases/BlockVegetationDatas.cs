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
    /// ����ֲ������״̬
    /// </summary>
    public class BlockVegetationDatas
    {
        /// <summary>
        /// ������
        /// </summary>
        public int ID;
        /// <summary>
        /// ֲ����������
        /// </summary>
        public int TotalDataCount;
        /// <summary>
        /// ������̫����
        /// <para>���������� Settings.MaxBytesInSingleBlock ʱ��TooMuchData�ͻ�����Ϊture����ʶ�����齫���ڷ�������</para>
        /// </summary>
        public bool TooMuchData;
        /// <summary>
        /// ģ��ԭ������
        /// </summary>
        public int ModelPrototypeCount;
        /// <summary>
        /// ģ��ԭ�Ͷ�Ӧ���
        /// </summary>
        public int[] ModelPrototypeIDs;
        /// <summary>
        /// ��ǰ�����ڰ�����ֲ������
        /// <para>�༭��Ԥ����ֲ����ʱ��ʹ�ø��ֶ�</para>
        /// </summary>
        public List<VegetationInstanceData>[] Datas;
        /// <summary>
        /// ��ǰ�����ڰ�����ֲ������
        /// <para>����ʱ��ʹ�ø��ֶ�</para>
        /// </summary>
        public VegetationInstanceData[][] DatasArray;

        public override string ToString() => $"(ID: {ID}, ֲ����������: {TotalDataCount}, TooMuchData: {TooMuchData}, ģ��ԭ������: {ModelPrototypeCount})";

        /// <summary>
        /// ����д���ļ���
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
        /// �ӻ����ж�ȡ����
        /// </summary>
        /// <param name="buffer">����</param>
        /// <param name="startIndex">��ʼλ��</param>
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
