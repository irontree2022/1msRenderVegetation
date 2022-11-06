using Mono.Cecil.Cil;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using static UnityEngine.Rendering.DebugUI;

namespace RenderVegetationIn1ms
{
    public class VegetationDatabase
    {
        /// <summary>
        /// ��һ��ʵ��ID
        /// </summary>
        public int NextInstanceID;
        /// <summary>
        /// ֲ����������
        /// </summary>
        public int TotalDataCount;
        /// <summary>
        /// ����ֲ�����ݿ����ļ�·��
        /// </summary>
        public string BlockVegetationDatasDatabaseFilepath;
        /// <summary>
        /// ����ֲ�����ݿ���Ϣ����ļ�·��
        /// </summary>
        public string BlockVegetationDatasDatabaseInfoFilepath;
        /// <summary>
        /// ����ֲ��ʵ������
        /// </summary>
        public BlockVegetationDatas[] AllBlockVegetationDatas;
        /// <summary>
        /// ����ֲ�����ݿ�
        /// </summary>
        public BlockVegetationDatasDatabaseInfo BlockVegetationDatasDatabaseInfo;


        /// <summary>
        /// ��ȡ����ֲ������״̬
        /// </summary>
        /// <param name="blockID">������</param>
        /// <returns>����ֲ�����ݶ���</returns>
        public BlockVegetationDatas GetBlockVegetationDatas(int blockID)
        {
            if (AllBlockVegetationDatas == null) return null;
            return AllBlockVegetationDatas[blockID];
        }
        /// <summary>
        /// ����д���ļ���
        /// </summary>
        /// <param name="filepath">�ļ�·��</param>
        public void Write(string filepath, System.Action<bool,float> progressAction = null)
        {
            if (progressAction != null)
                progressAction(false, 0);

            var dir = System.IO.Path.GetDirectoryName(filepath);
            System.IO.Directory.CreateDirectory(dir);
            var length = AllBlockVegetationDatas == null ? 0 : AllBlockVegetationDatas.Length;
            using (FileStream fs = new FileStream(filepath, FileMode.Create))
            {
                var binaryWriter = new BinaryWriter(fs, System.Text.Encoding.UTF8);
                binaryWriter.Write(NextInstanceID);
                binaryWriter.Write(TotalDataCount);
                var bytes = System.Text.Encoding.UTF8.GetBytes(BlockVegetationDatasDatabaseFilepath);
                binaryWriter.Write(bytes.Length);
                binaryWriter.Write(bytes);
                bytes = System.Text.Encoding.UTF8.GetBytes(BlockVegetationDatasDatabaseInfoFilepath);
                binaryWriter.Write(bytes.Length);
                binaryWriter.Write(bytes);
                binaryWriter.Write(length);
                if (progressAction != null)
                    progressAction(true, 1);
                binaryWriter.Close();
                binaryWriter.Dispose();
            }


            if (progressAction != null)
                progressAction(false, 0);
            var count = 0;
            for (var i = 0; i < length; i++)
                if (AllBlockVegetationDatas[i] != null)
                    ++count;
            BlockVegetationDatasDatabaseInfo = new BlockVegetationDatasDatabaseInfo();
            BlockVegetationDatasDatabaseInfo.BlockCount = count;
            BlockVegetationDatasDatabaseInfo.IDs = new int[count];
            BlockVegetationDatasDatabaseInfo.IDIndexs = new BlockVegetationDatasDatabaseIndex[count];

            
            
            var blockVegetationDatasFilepath = System.IO.Path.Combine(dir, BlockVegetationDatasDatabaseFilepath);
            dir = System.IO.Path.GetDirectoryName(blockVegetationDatasFilepath);
            System.IO.Directory.CreateDirectory(dir);
            var infoIDsIndex = 0;
            long bytesStartIndex = 0;
            using (FileStream fs = new FileStream(blockVegetationDatasFilepath, FileMode.Create))
            {
                var binaryWriter = new BinaryWriter(fs, System.Text.Encoding.UTF8);
                binaryWriter.Write(count);
                bytesStartIndex += sizeof(int);
                for (var i = 0; i < length; i++)
                {
                    var blockVegetationDatas = AllBlockVegetationDatas[i];
                    if(blockVegetationDatas != null)
                    {
                        var bytesCount = blockVegetationDatas.Write(binaryWriter);
                        BlockVegetationDatasDatabaseInfo.IDs[infoIDsIndex] = blockVegetationDatas.ID;
                        BlockVegetationDatasDatabaseInfo.IDIndexs[infoIDsIndex++] = new BlockVegetationDatasDatabaseIndex(bytesStartIndex, bytesCount);
                        bytesStartIndex += bytesCount;
                        if (progressAction != null)
                            progressAction(false, (i + 1) / (float)length);
                    }
                }
                if (progressAction != null)
                    progressAction(true, 1);
                binaryWriter.Close();
                binaryWriter.Dispose();
            }
            BlockVegetationDatasDatabaseInfo.BytesCount = bytesStartIndex;




            if (progressAction != null)
                progressAction(false, 0);
            var blockVegetationDatasDatabaseInfoFilepath = System.IO.Path.Combine(dir, BlockVegetationDatasDatabaseInfoFilepath);
            BlockVegetationDatasDatabaseInfo.Write(blockVegetationDatasDatabaseInfoFilepath, progressAction);

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
            var dir = System.IO.Path.GetDirectoryName(filepath);
            var startIndex = 0;
            NextInstanceID = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            TotalDataCount = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            var bytesLength = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            BlockVegetationDatasDatabaseFilepath = System.Text.Encoding.UTF8.GetString(buffer, startIndex, bytesLength); startIndex += bytesLength;
            bytesLength = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            BlockVegetationDatasDatabaseInfoFilepath = System.Text.Encoding.UTF8.GetString(buffer, startIndex, bytesLength); startIndex += bytesLength;
            var length = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            AllBlockVegetationDatas = new BlockVegetationDatas[length];
            BlockVegetationDatasDatabaseInfo = new BlockVegetationDatasDatabaseInfo();
            if (progressAction != null) progressAction(false, 0.1f);

            // ��������ֲ�����ݿ���Ϣ����
            var infoDone = false;
            System.Threading.Tasks.Task.Run(() => {
                BlockVegetationDatasDatabaseInfo.ReadFromFile(System.IO.Path.Combine(dir, BlockVegetationDatasDatabaseInfoFilepath));
                infoDone = true;
            });
 
            // ��ȡ����ֲ�����ݿ�
            var fileStream = new System.IO.FileStream(System.IO.Path.Combine(dir, BlockVegetationDatasDatabaseFilepath), FileMode.Open);
            var blockVegetationDatabaseDone = false;
            var bufferCount = 1;
            var fileStreamLength = fileStream.Length;
            if (fileStreamLength > int.MaxValue)
            {
                long fileLength = int.MaxValue;
                while (fileLength < fileStreamLength)
                {
                    fileLength += int.MaxValue;
                    ++bufferCount;
                }
            }
            var buffers = new byte[bufferCount][];
            System.Threading.Tasks.Task.Run(() => {
                long bufferBytesStartIndex = 0;
                for (int i = 0; i < bufferCount; i++)
                {
                    if (i != bufferCount - 1)
                    {
                        buffers[i] = new byte[int.MaxValue];
                        bufferBytesStartIndex += fileStream.Read(buffers[i], 0, int.MaxValue);
                    }
                    else
                    {
                        buffers[i] = new byte[fileStreamLength - bufferBytesStartIndex];
                        fileStream.Read(buffers[i], 0, buffers[i].Length);
                    }
                }
                blockVegetationDatabaseDone = true;
            });

            // �ȴ�����ֲ�����ݿ���Ϣ������ֲ�����ݿ��ļ����ݶ�ȡ���
            while (!infoDone || !blockVegetationDatabaseDone)
            {
                if (infoDone || blockVegetationDatabaseDone)
                    if (progressAction != null)
                        progressAction(false, 0.2f);
            }
            fileStream.Close();
            if (progressAction != null)
                progressAction(false, 0.3f);

            startIndex = 0;
            var count = BitConverter.ToInt32(buffers[0], startIndex); startIndex += sizeof(int);
            if (count != BlockVegetationDatasDatabaseInfo.BlockCount)
                throw new Exception("[RenderVegetationIn1ms] ����ֲ�����ݿ������¼�Ĵ���ֲ�����ݵ�����������һ�¡�");
            if(fileStreamLength != BlockVegetationDatasDatabaseInfo.BytesCount)
                throw new Exception("[RenderVegetationIn1ms] ����ֲ�����ݿ������¼��ֲ��������ռ�ֽ�����һ�¡�");
            
            // ����ÿһ������ֲ����������
            var doneCount = 0;
            object donesync = new object();
            var error = string.Empty;
            for (var i = 0; i < count; i++)
            {
                if (progressAction != null) progressAction(false, 0.3f + 0.5f * (i + 1) / (float)count);

                var id = BlockVegetationDatasDatabaseInfo.IDs[i];
                var idIndex = BlockVegetationDatasDatabaseInfo.IDIndexs[i];
                var blockVegetationDatas = new BlockVegetationDatas();
                AllBlockVegetationDatas[id] = blockVegetationDatas;

                System.Threading.Tasks.Task.Run(() =>
                {
                    byte[] buffer = null;
                    int bufferStartIndex = 0;
                    long prebufferBytesCount = 0;
                    var ok = false;
                    for(var j = 0; j < buffers.Length; j++)
                    {
                        buffer = buffers[j];
                        if (idIndex.StartIndex < prebufferBytesCount + buffer.Length)
                        {
                            ok = true;
                            bufferStartIndex = (int)(idIndex.StartIndex - prebufferBytesCount);
                            if (idIndex.StartIndex + idIndex.BytesCount > prebufferBytesCount + buffer.Length)
                            {
                                var mybuffer = new byte[idIndex.BytesCount];
                                var count1 = buffer.Length - idIndex.StartIndex;
                                var count2 = idIndex.BytesCount - count1;
                                System.Array.Copy(buffer, bufferStartIndex, mybuffer, 0, count1);
                                System.Array.Copy(buffers[j + 1], 0, mybuffer, 0, count2);
                                buffer = mybuffer;
                                bufferStartIndex = 0;
                            }
                            break;
                        }
                        prebufferBytesCount += buffer.Length;
                    }
                    if (!ok)
                    {
                        error = $"����ֲ�����ݿ�����������Ч��id: {id}, idIndex: {idIndex}";
                        return;
                    }
                    else
                    {
                        blockVegetationDatas.ReadFromBuffer(buffer, bufferStartIndex);
                        lock (donesync)
                            ++doneCount;
                    }
                });
            }

            // �ȴ�����ֲ�����ݽ���ȫ�����
            while (true)
            {
                if (!string.IsNullOrEmpty(error))
                {
                    Debug.LogError($"[RenderVegetationIn1ms] {error}");
                    return;
                }

                if (doneCount == count)
                {
                    donesync = null;
                    if (progressAction != null) progressAction(true, 1);
                    return;
                }
                else
                {
                    if (progressAction != null) progressAction(false, 0.8f + 0.2f * doneCount / (float)count);
                }
            }
        }
    }

}