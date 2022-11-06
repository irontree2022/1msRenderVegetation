using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using UnityEditor;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// ��Ⱦ���ݴ�����
    /// </summary>
    public static class RenderingDataProcessing
    {
        private static RenderVegetationIn1ms _RenderParams;
        private static RenderingSharedVars _RenderVars;

        public static void Init()
        {
            _RenderParams = RenderingAPI.RenderParams;
            _RenderVars = RenderingAPI.RenderVars;
        }
        public static void OnDestroy()
        {
            _RenderParams = null;
            _RenderVars = null;
        }
        /// <summary>
        /// �첽����ֲ������
        /// </summary>
        /// <param name="datetime">���ؿ�ʼʱ��</param>
        public static void LoadVegetationDataAsync(System.DateTime datetime = default)
        {
            _RenderVars.LocalVegetationDataLoaded = false;
            _RenderVars.IsLoadingLocalVegetationData = true;

            var dir = System.IO.Path.Combine(Application.streamingAssetsPath, _RenderParams.Settings.StorageFoldername);
            var blockTreeDone = false;
            var vegetationDatabseDone = false;
            var blockTreeProgress = 0f;
            var vegetationDatabseProgress = 0f;
            string blockTreeDetails = string.Empty;
            string vegetationDatabseDetails = string.Empty;
            var doneSync = new object();
            System.Threading.Tasks.Task.Run(() => {
                try
                {
                    var blockTreeFilepath = System.IO.Path.Combine(dir, _RenderParams.Settings.BlockTreeFilename);
                    _RenderVars.BlockTree.ReadFromFile(blockTreeFilepath, (isDone, progress) => {
                        string detail = null;
                        var _progress = 0f;
                        lock (doneSync)
                        {
                            blockTreeProgress = progress;
                            _progress = (blockTreeProgress + vegetationDatabseProgress) * 0.5f;
                            if (isDone) blockTreeDetails = "������������ɣ�";
                            else blockTreeDetails = $"����������... {(progress * 100).ToString("f2")}%";
                            detail = $"{blockTreeDetails}\n{vegetationDatabseDetails}";
                        }
                        RenderingAPI.TriggerEvent_E_LocalVegetationDataLoadingSituation(
                                _RenderVars.identity,
                                false, _progress, "���ڼ��ر���ֲ������...", detail);
                        if (isDone)
                            lock (doneSync)
                            {
                                blockTreeDone = true;
                                if (vegetationDatabseDone)
                                    LocalVegetationDataLoaded("����ֲ�����ݼ�����ɣ�", detail, datetime);
                            }
                    });
                }
                catch(System.Exception e)
                {
                    Debug.LogError($"[RenderVegetationIn1ms] {e.Message}\n{e.StackTrace}");
                }
            });
            System.Threading.Tasks.Task.Run(() => {
                var databaseFilepath = System.IO.Path.Combine(dir, _RenderParams.Settings.VegetationDatabaseFilename);
                _RenderVars.Database.ReadFromFile(databaseFilepath, (isDone, progress) => {
                    try
                    {
                        string detail = null;
                        var _progress = 0f;
                        lock (doneSync)
                        {
                            vegetationDatabseProgress = progress;
                            _progress = (blockTreeProgress + vegetationDatabseProgress) * 0.5f;
                            if (isDone) vegetationDatabseDetails = "ֲ�����ݿ������ɣ�";
                            else vegetationDatabseDetails = $"����ֲ�����ݿ�... {(progress * 100).ToString("f2")}%";
                            detail = $"{blockTreeDetails}\n{vegetationDatabseDetails}";
                        }
                        RenderingAPI.TriggerEvent_E_LocalVegetationDataLoadingSituation(
                           _RenderVars.identity,
                           false, _progress, "���ڼ��ر���ֲ������...", detail);

                        if (isDone)
                            lock (doneSync)
                            {
                                vegetationDatabseDone = true;
                                if (blockTreeDone)
                                    LocalVegetationDataLoaded("����ֲ�����ݼ�����ɣ�", detail, datetime);
                            }
                    }
                    catch(System.Exception e)
                    {
                        Debug.LogError($"[RenderVegetationIn1ms] {e.Message}\n{e.StackTrace}");
                    }
                });
            });
        }
        private static void LocalVegetationDataLoaded(string info = null, string details = null, DateTime dateTime = default)
        {
            var dtime = System.DateTime.Now - dateTime;
            Debug.Log($"[RenderVegetationIn1ms] ����ֲ�����ݼ�����ɣ���ʱ��{dtime.TotalSeconds}s/{dtime.TotalMinutes}m");
            _RenderVars.LocalVegetationDataLoaded = true;
            _RenderVars.IsLoadingLocalVegetationData = false;
            RenderingAPI.TriggerEvent_E_LocalVegetationDataLoadingSituation(
                            _RenderVars.identity,
                            true, 1, info, details);
        }
        /// <summary>
        /// ��ʼ����������
        /// </summary>
        public static void InitBlockDatas()
        {
            _RenderVars.BlockDatasInitialized = true;
            _RenderVars.CollectedBlocksLength = 0;
            _RenderVars.CollectedBlocksNativeArray = new Unity.Collections.NativeArray<Block>(1, Unity.Collections.Allocator.Persistent);
            _RenderVars.AfterCullingBlocksNativeArray = new Unity.Collections.NativeArray<Block>(1, Unity.Collections.Allocator.Persistent);
            _RenderVars.AfterCullingBlocks = new Block[1];
        }
    }
}
