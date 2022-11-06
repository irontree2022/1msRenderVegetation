using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    [CreateAssetMenu(fileName = "Settings", menuName = "RenderVegetationIn1ms/Settings")]
    public class Settings : ScriptableObject
    {
        [Header("单个区块内最大容量(M)")]
        [Tooltip("不要超过1G")]
        public int MaxBytesInSingleBlock = 10;
        [Header("存储植被数据的文件夹名称")]
        public string StorageFoldername = "1msSerializedDatas";
        [Header("区块树文件名")]
        public string BlockTreeFilename = "BlockTree.1ms.blocktree";
        [Header("植被数据库文件名")]
        public string VegetationDatabaseFilename = "VegetationDatabase.1ms.vdatabase";
        [Header("区块植被数据文件名")]
        public string BlockVegetationDatasDatabaseFilename = "BlockDatabase.1ms.blockDatabase";
        [Header("区块植被数据信息文件名")]
        public string BlockVegetationDatasDatabaseInfoFilename = "BlockDatabaseInfo.1ms.blockDatabaseInfo";
    }
}
