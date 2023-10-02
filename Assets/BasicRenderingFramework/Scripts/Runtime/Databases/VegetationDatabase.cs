using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;

namespace RenderVegetationIn1ms
{
    public class VegetationDatabase
    {
        /// <summary>
        /// 下一个实例ID
        /// </summary>
        public int NextInstanceID;
        /// <summary>
        /// 植被数据总量
        /// </summary>
        public int TotalDataCount;
        /// <summary>
        /// 区块植被数据库存放文件路径
        /// </summary>
        public string BlockVegetationDatasDatabaseFilepath;
        /// <summary>
        /// 区块植被数据库信息存放文件路径
        /// </summary>
        public string BlockVegetationDatasDatabaseInfoFilepath;
        /// <summary>
        /// 所有植被实例数据
        /// </summary>
        public BlockVegetationDatas[] AllBlockVegetationDatas;
        /// <summary>
        /// 区块植被数据库
        /// </summary>
        public BlockVegetationDatasDatabaseInfo BlockVegetationDatasDatabaseInfo;


        /// <summary>
        /// 获取区块植被数据状态
        /// </summary>
        /// <param name="blockID">区块编号</param>
        /// <returns>区块植被数据对象</returns>
        public BlockVegetationDatas GetBlockVegetationDatas(int blockID)
        {
            if (AllBlockVegetationDatas == null) return null;
            return AllBlockVegetationDatas[blockID];
        }
        /// <summary>
        /// 数据写入文件中
        /// </summary>
        /// <param name="filepath">文件路径</param>
        public void Write(string filepath, System.Action<bool,float> progressAction = null)
        {
            if (progressAction != null)
                progressAction(false, 0);

            var dir = System.IO.Path.GetDirectoryName(filepath);
            System.IO.Directory.CreateDirectory(dir);

            // 写入植被数据库
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

            
            // 写入所有区块的植被数据
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



            // 写入所有区块的索引数据
            if (progressAction != null)
                progressAction(false, 0);
            var blockVegetationDatasDatabaseInfoFilepath = System.IO.Path.Combine(dir, BlockVegetationDatasDatabaseInfoFilepath);
            BlockVegetationDatasDatabaseInfo.Write(blockVegetationDatasDatabaseInfoFilepath, progressAction);

        }
        /// <summary>
        /// 从文件中读取数据
        /// </summary>
        /// <param name="filepath">文件路径</param>
        /// <param name="progressAction">进度回调</param>
        public void ReadFromFile(string filepath, System.Action<bool, float> progressAction = null)
        {
            if (progressAction != null) progressAction(false, 0);

            // 注意，经过测试植被总数太高，比如800万，单个文件占用将达到4G以上的时候，
            // 此时这个读取函数将会出问题，并不能顺利通过拼接buffer来完成植被数据反序列化，
            // 因此，该函数不适用于大文件读取，对于基础渲染框架这个Demo来说，这个函数已经足够使用了。
            // 但商业项目中，仍需要对植被数据存储结构和文件存储方式进行优化。
            
            
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

            // 解析区块植被数据库信息数据
            var infoDone = false;
            System.Threading.Tasks.Task.Run(() => {
                BlockVegetationDatasDatabaseInfo.ReadFromFile(System.IO.Path.Combine(dir, BlockVegetationDatasDatabaseInfoFilepath));
                infoDone = true;
            });
 
            // 读取区块植被数据库
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

            // 等待区块植被数据库信息和区块植被数据库文件数据读取完成
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
                throw new Exception("[RenderVegetationIn1ms] 解析植被数据库出错！记录的存在植被数据的区块数量不一致。");
            if(fileStreamLength != BlockVegetationDatasDatabaseInfo.BytesCount)
                throw new Exception("[RenderVegetationIn1ms] 解析植被数据库出错！记录的植被数据所占字节数不一致。");
            
            // 解析每一个区块植被数据数据
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
                                var count1 = prebufferBytesCount + buffer.Length - idIndex.StartIndex;
                                var count2 = idIndex.BytesCount - count1;
                                System.Array.Copy(buffer, bufferStartIndex, mybuffer, 0, count1);
                                System.Array.Copy(buffers[j + 1], 0, mybuffer, count1, count2);
                                buffer = mybuffer;
                                bufferStartIndex = 0;
                            }
                            break;
                        }
                        prebufferBytesCount += buffer.Length;
                    }
                    if (!ok)
                    {
                        error = $"区块植被数据库索引数据无效！id: {id}, idIndex: {idIndex}";
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

            // 等待区块植被数据解析全部完毕
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
