using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    [CreateAssetMenu(fileName = "Settings", menuName = "RenderVegetationIn1ms/Settings")]
    public class Settings : ScriptableObject
    {
        [Header("�����������������(M)")]
        [Tooltip("��Ҫ����1G")]
        public int MaxBytesInSingleBlock = 10;
        [Header("�洢ֲ�����ݵ��ļ�������")]
        public string StorageFoldername = "1msSerializedDatas";
        [Header("�������ļ���")]
        public string BlockTreeFilename = "BlockTree.1ms.blocktree";
        [Header("ֲ�����ݿ��ļ���")]
        public string VegetationDatabaseFilename = "VegetationDatabase.1ms.vdatabase";
        [Header("����ֲ�������ļ���")]
        public string BlockVegetationDatasDatabaseFilename = "BlockDatabase.1ms.blockDatabase";
        [Header("����ֲ��������Ϣ�ļ���")]
        public string BlockVegetationDatasDatabaseInfoFilename = "BlockDatabaseInfo.1ms.blockDatabaseInfo";
    }
}
