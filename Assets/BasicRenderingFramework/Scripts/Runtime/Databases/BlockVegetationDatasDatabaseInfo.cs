using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using Unity.Collections;
using UnityEngine;
using UnityEngine.UIElements;
using UnityEngine.XR;

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// ����ֲ�����ݿ���Ϣ
    /// </summary>
    public class BlockVegetationDatasDatabaseInfo
    {
        /// <summary>
        /// ����ֲ�����ݶ�������
        /// </summary>
        public int BlockCount;
        /// <summary>
        /// ����ֲ�����ݿ���ռ�ֽ���
        /// </summary>
        public long BytesCount;
        /// <summary>
        /// ���д���ֲ�����ݵ�������
        /// </summary>
        public int[] IDs;
        /// <summary>
        /// ��Ӧ����ֲ�����������ݿ��е�����
        /// </summary>
        public BlockVegetationDatasDatabaseIndex[] IDIndexs;


        /// <summary>
        /// ������д���ļ�
        /// </summary>
        /// <param name="filepath">�ļ�·��</param>
        public void Write(string filepath, System.Action<bool, float> progressAction = null)
        {
            if (progressAction != null) progressAction(false, 0);
            var dir = System.IO.Path.GetDirectoryName(filepath);
            System.IO.Directory.CreateDirectory(dir);
            using (FileStream fs = new FileStream(filepath, FileMode.Create))
            {
                var binaryWriter = new BinaryWriter(fs, System.Text.Encoding.UTF8);
                binaryWriter.Write(BlockCount);
                binaryWriter.Write(BytesCount);
                var length = IDs == null ? 0 : IDs.Length;
                binaryWriter.Write(length);
                for (var i = 0; i < length; i++)
                {
                    if (progressAction != null) progressAction(false, (i + 1) / (float)length);
                    binaryWriter.Write(IDs[i]);
                    IDIndexs[i].Write(binaryWriter);
                }
                if (progressAction != null)
                    progressAction(true, 1);
                binaryWriter.Close();
                binaryWriter.Dispose();
            }
        }
        /// <summary>
        /// ���ļ��ж�ȡ����
        /// </summary>
        /// <param name="filepath">�ļ�·��</param>
        /// <param name="progressAction">���Ȼص�</param>
        public void ReadFromFile(string filepath, System.Action<bool, float> progressAction = null)
        {
            if (progressAction != null) progressAction(false, 0);
            var buffer = System.IO.File.ReadAllBytes(filepath);
            var startIndex = 0;
            BlockCount = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            BytesCount = BitConverter.ToInt64(buffer, startIndex); startIndex += sizeof(long);
            var length = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            IDs = new int[length];
            IDIndexs = new BlockVegetationDatasDatabaseIndex[length];
            for(var i = 0; i < length; i++)
            {
                if (progressAction != null) progressAction(false, (i + 1) / (float)length);
                IDs[i] = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
                var idIndex = new BlockVegetationDatasDatabaseIndex();
                idIndex.ReadFromBuffer(buffer, startIndex); startIndex += BlockVegetationDatasDatabaseIndex.stride;
                IDIndexs[i] = idIndex;
            }
        }
    }
    /// <summary>
    /// ����ֲ�����������ݿ��е�����
    /// </summary>
    public class BlockVegetationDatasDatabaseIndex
    {
        public long StartIndex;
        public long BytesCount;

        public static int stride => sizeof(long) * 2;
        public BlockVegetationDatasDatabaseIndex() { }
        public BlockVegetationDatasDatabaseIndex(long startIndex, long bytesCount)
        {
            StartIndex = startIndex;
            BytesCount = bytesCount;
        }
        public override string ToString() => $"(StartIndex: {StartIndex}, BytesCount: {BytesCount})";
        public void Write(BinaryWriter binaryWriter)
        {
            binaryWriter.Write(StartIndex);
            binaryWriter.Write(BytesCount);
        }
        public void ReadFromBuffer(byte[] buffer, int startIndex)
        {
            StartIndex = BitConverter.ToInt64(buffer, startIndex); startIndex += sizeof(long);
            BytesCount = BitConverter.ToInt64(buffer, startIndex); 
        }
    }
}
