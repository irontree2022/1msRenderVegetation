using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using TreeEditor;
using Unity.Collections;
using Unity.Jobs;
using UnityEngine;
using UnityEngine.UI;

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// 渲染逻辑
    /// <para>所有植被实例化渲染和渲染参数控制都在这里进行</para>
    /// </summary>
    public static class RenderingLogic
    {
        private static RenderVegetationIn1ms _RenderParams;
        private static RenderingSharedVars _RenderVars;


        #region Unity 事件消息
        public static void OnEnable() { }
        public static void OnDisable() { }
        public static void Awake(RenderVegetationIn1ms renderParam) => _RenderParams = renderParam;
        public static void Start()
        {
            RenderingAPI.Init(_RenderParams);
            _RenderVars = RenderingAPI.RenderVars;
            _RenderVars.Init(_RenderParams);
            RenderingDataProcessing.Init();
            _RenderVars.Initialized = true;
        }
        public static void OnDestroy()
        {
            _RenderVars.OnDestroy();
            RenderingAPI.OnDestroy();
            RenderingDataProcessing.OnDestroy();
            _RenderParams = null;
            _RenderVars = null;
            Resources.UnloadUnusedAssets();
            GC.Collect();
        }
        public static void Update()
        {
            if(!_RenderVars.Initialized || !_RenderParams.AllowRendering) return;
            UpdateRendering();
        }
        public static void OnDrawGizmos()
        {
            if (_RenderParams == null || _RenderVars == null) return;

            if (_RenderParams.ShowVisibleVegetationBounds)
            {
                for (var i = 0; i < _RenderVars.ModelRenderingDatas.Length; i++)
                {
                    var modelRenderingData = _RenderVars.ModelRenderingDatas[i];
                    for (var j = 0; j < modelRenderingData.VegetationBoundsCount; j++)
                    {
                        Bounds bounds = default;
                        if(_RenderParams.DrawsWithProcedural)
                        {
                            if (!modelRenderingData.VegetationBoundsNativeArray.IsCreated || j >= modelRenderingData.VegetationBoundsNativeArray.Length)
                                break;
                            bounds = modelRenderingData.VegetationBoundsNativeArray[j];
                        }
                        else
                        {
                            if (modelRenderingData.VegetationBoundsDatas == null || j >= modelRenderingData.VegetationBoundsDatas.Length)
                                break;
                            bounds = modelRenderingData.VegetationBoundsDatas[j];
                        }
                        
                        GizmosDrawWireCube(bounds);
                    }
                }
            }

            if(_RenderParams.ShowLocalBlockTree && _RenderParams.BlockTreeDepths != null)
            {
                if (_RenderVars.BlockNodesDepths == null)
                    GetBlockNodesDepths(_RenderVars.BlockTree.RootBlockNode);
                if (_RenderVars.BlockNodesDepths != null)
                {
                    Gizmos.color = Color.yellow;
                    for (var i = 0; i < _RenderParams.BlockTreeDepths.Length; i++)
                        if (_RenderParams.BlockTreeDepths[i])
                            for (var j = 0; _RenderVars.BlockNodesDepths[i] != null && j < _RenderVars.BlockNodesDepths[i].Count; j++)
                                GizmosDrawWireCube(_RenderVars.BlockNodesDepths[i][j].Block);
                }
            }

            if (_RenderParams.ShowAllModelBounds)
            {
                Gizmos.color = Color.yellow;
                var showCount = 0;
                for(var i = 0; i < _RenderVars.Database.AllBlockVegetationDatas.Length; i++)
                {
                    var blockVegetationDatas = _RenderVars.Database.AllBlockVegetationDatas[i];
                    if(blockVegetationDatas != null && blockVegetationDatas.Datas != null)
                    {
                        for(var j = 0; j < blockVegetationDatas.Datas.Length; j++)
                        {
                            var datas = blockVegetationDatas.Datas[j];
                            for(var k = 0; k < datas.Count; k++)
                            {
                                var vid = datas[k];
                                ++showCount;
                                GizmosDrawWireCube(vid);
                            }
                        }
                    }
                }
            }

            if (_RenderParams.ShowVisibleBlock)
            {
                Gizmos.color = Color.green;
                for (var i = 0; i < _RenderVars.CoreBlocksLength; i++)
                    GizmosDrawWireCube(_RenderVars.CoreBlocks[i]);
                Gizmos.color = Color.black;
                for (var i = 0; i < _RenderVars.ImpostorBlocksLength; i++)
                    GizmosDrawWireCube(_RenderVars.ImpostorBlocks[i]);
            }
        }
        private static void GetBlockNodesDepths(BlockNode blockNode)
        {
            if (_RenderVars.BlockNodesDepths == null)
                _RenderVars.BlockNodesDepths = new List<BlockNode>[_RenderVars.BlockTree.Depth];
            var depth = blockNode.Depth;
            if (depth - 1 < 0 || depth - 1 >= _RenderVars.BlockNodesDepths.Length) return;

            if (_RenderVars.BlockNodesDepths[depth - 1] == null)
                _RenderVars.BlockNodesDepths[depth - 1] = new List<BlockNode>();
            _RenderVars.BlockNodesDepths[depth - 1].Add(blockNode);
            if (blockNode.Childs != null)
                for (var i = 0; i < blockNode.Childs.Length; i++)
                    GetBlockNodesDepths(blockNode.Childs[i]);
        }
        private static void GizmosDrawWireCube(Block block)
        {
            var canDraw = true;
            if (_RenderParams.OnlyShowBlockIDs != null && _RenderParams.OnlyShowBlockIDs.Count > 0)
                canDraw = _RenderParams.OnlyShowBlockIDs.Contains(block.ID);
            if (!canDraw) return;

            if (_RenderParams.ShowBlockTrueBounds) Gizmos.DrawWireCube(block.TrueBounds.center, block.TrueBounds.size);
            else Gizmos.DrawWireCube(block.Bounds.center, block.Bounds.size);
        }
        private static void GizmosDrawWireCube(VegetationInstanceData vid) =>
             Gizmos.DrawWireCube(vid.center, vid.extents * 2);
        private static void GizmosDrawWireCube(Bounds bounds) =>
             Gizmos.DrawWireCube(bounds.center, bounds.size);
        #endregion
        /// <summary>
        /// 更新渲染
        /// </summary>
        private static void UpdateRendering()
        {
            if(!_RenderVars.LocalVegetationDataLoaded && !_RenderVars.IsLoadingLocalVegetationData)
                RenderingDataProcessing.LoadVegetationDataAsync(System.DateTime.Now);
            if (_RenderVars.LocalVegetationDataLoaded && !_RenderVars.BlockDatasInitialized)
                RenderingDataProcessing.InitBlockDatas();


            if (!_RenderVars.LocalVegetationDataLoaded || !_RenderVars.BlockDatasInitialized || !_RenderParams.AllowRendering) return;


            if (_RenderVars.CameraChanged)
            {
                _RenderVars.UpdateCameraDatas();
                UnityEngine.Profiling.Profiler.BeginSample("CullBlocks");
                ResetBlockDatas();
                CullBlocks();
                UnityEngine.Profiling.Profiler.EndSample();
                UnityEngine.Profiling.Profiler.BeginSample("CollectBlockDatas");
                _RenderVars.ResetModelRenderingDatas();
                CollectBlockDatas();
                UnityEngine.Profiling.Profiler.EndSample();
                UnityEngine.Profiling.Profiler.BeginSample("CullVegetationDatas");
                CullVegetationDatas();
                UnityEngine.Profiling.Profiler.EndSample();
            }

            UnityEngine.Profiling.Profiler.BeginSample("Draw");
            Draw();
            UnityEngine.Profiling.Profiler.EndSample();
        }
        private static void ResetBlockDatas()
        {
            _RenderVars.CollectedBlocksLength = 1;
            _RenderVars.CollectedBlocksNativeArray[0] = _RenderVars.BlockTree.RootBlockNode.Block;
            _RenderVars.CoreBlocksLength = 0;
            _RenderVars.ImpostorBlocksLength = 0;
        }
        /// <summary>
        /// 剔除区块
        /// </summary>
        private static void CullBlocks()
        {
            var jobhandle = new CullBlocksJob()
            {
                CollectedBlocksNativeArray = _RenderVars.CollectedBlocksNativeArray,
                MaxRenderingDistance = _RenderParams.MaxRenderingDistance,
                MaxCoreRenderingDistance = _RenderParams.MaxCoreRenderingDistance,
                ImpostorBlockMaxSize = _RenderParams.ImpostorBlockMaxSize,
                ImpostorBlockMinSize = _RenderParams.ImpostorBlockMinSize,
                CameraPosition = _RenderVars.CameraPosition,
                FrustumPlanes = _RenderVars.FrustumPlanesNativeArray,

                AfterCullingBlocksNativeArray = _RenderVars.AfterCullingBlocksNativeArray,

            }.Schedule(_RenderVars.CollectedBlocksLength, _RenderVars.CollectedBlocksLength);
            JobHandle.ScheduleBatchedJobs();
            jobhandle.Complete();


            NativeArray<Block>.Copy(_RenderVars.AfterCullingBlocksNativeArray, 
                _RenderVars.AfterCullingBlocks, _RenderVars.CollectedBlocksLength);
            var collectedBlocksLength = _RenderVars.CollectedBlocksLength;
            _RenderVars.CollectedBlocksLength = 0;
            for (var i = 0; i < collectedBlocksLength; i++)
            {
                var block = _RenderVars.AfterCullingBlocks[i];
                if (!block.available) continue;
                CollectBlock(block);
            }
            if (_RenderVars.CollectedBlocksLength > 0)
            {
                if (_RenderVars.CollectedBlocksNativeArray.Length < _RenderVars.CollectedBlocksLength)
                {
                    _RenderVars.CollectedBlocksNativeArray.Dispose();
                    _RenderVars.AfterCullingBlocksNativeArray.Dispose();
                    _RenderVars.CollectedBlocksNativeArray = new NativeArray<Block>(_RenderVars.CollectedBlocksLength, Allocator.Persistent);
                    _RenderVars.AfterCullingBlocksNativeArray = new NativeArray<Block>(_RenderVars.CollectedBlocksLength, Allocator.Persistent);
                    _RenderVars.AfterCullingBlocks = new Block[_RenderVars.CollectedBlocksLength];
                }
                NativeArray<Block>.Copy(_RenderVars.CollectedBlocks, _RenderVars.CollectedBlocksNativeArray, _RenderVars.CollectedBlocksLength);
                CullBlocks();
            }
        }
        private static void CollectBlock(Block block)
        {
            var canCollect = true;
            if (block.IsCore && (block.IsLeaf || block.IsCoreAllInPlanes))
            {
                if (_RenderVars.CoreBlocks == null)
                    _RenderVars.CoreBlocks = new Block[1];
                if(_RenderVars.CoreBlocksLength >= _RenderVars.CoreBlocks.Length)
                {
                    var blocks = new Block[_RenderVars.CoreBlocksLength * 2];
                    System.Array.Copy(_RenderVars.CoreBlocks, blocks, _RenderVars.CoreBlocks.Length);
                    _RenderVars.CoreBlocks = blocks;
                }
                _RenderVars.CoreBlocks[_RenderVars.CoreBlocksLength++] = block;
                canCollect = false;
            }
            if (block.IsImpostor && !block.IsImpostorNeedCollected)
            {
                if (_RenderVars.ImpostorBlocks == null)
                    _RenderVars.ImpostorBlocks = new Block[1];
                if (_RenderVars.ImpostorBlocksLength >= _RenderVars.ImpostorBlocks.Length)
                {
                    var blocks = new Block[_RenderVars.ImpostorBlocksLength * 2];
                    System.Array.Copy(_RenderVars.ImpostorBlocks, blocks, _RenderVars.ImpostorBlocks.Length);
                    _RenderVars.ImpostorBlocks = blocks;
                }
                _RenderVars.ImpostorBlocks[_RenderVars.ImpostorBlocksLength++] = block;
                canCollect = false;
            }
            if ((canCollect && block.IsCore) || (canCollect && block.IsImpostor))
            {
                var blockNode = _RenderVars.BlockTree.GetBlockNode(block.ID);
                if (blockNode.NoEmptyChilds == null) return;
                for (var i = 0; i < blockNode.NoEmptyChilds.Length; i++)
                {
                    if (_RenderVars.CollectedBlocks == null)
                        _RenderVars.CollectedBlocks = new Block[1];
                    if (_RenderVars.CollectedBlocksLength >= _RenderVars.CollectedBlocks.Length)
                    {
                        var blocks = new Block[_RenderVars.CollectedBlocksLength * 2];
                        System.Array.Copy(_RenderVars.CollectedBlocks, blocks, _RenderVars.CollectedBlocks.Length);
                        _RenderVars.CollectedBlocks = blocks;
                    }
                    _RenderVars.CollectedBlocks[_RenderVars.CollectedBlocksLength++] = blockNode.NoEmptyChilds[i].Block;
                }
            }
        }
        /// <summary>
        /// 收集区块中的植被数据
        /// </summary>
        private static void CollectBlockDatas()
        {
            UnityEngine.Profiling.Profiler.BeginSample("CollectImpostorBlockDatas");
            for (var i = 0; i < _RenderVars.ImpostorBlocksLength; i++)
                CollectBlockDatas(false, _RenderVars.ImpostorBlocks[i]);
            UnityEngine.Profiling.Profiler.EndSample();

            UnityEngine.Profiling.Profiler.BeginSample("CollectCoreBlockDatas");
            for (var i = 0; i < _RenderVars.CoreBlocksLength; i++)
                CollectBlockDatas(true, _RenderVars.CoreBlocks[i]);
            UnityEngine.Profiling.Profiler.EndSample();
        }
        private static void CollectBlockDatas(bool isCore, Block block)
        {
            var blockVegetationDatas = _RenderVars.Database.GetBlockVegetationDatas(block.ID);
            if(blockVegetationDatas.TooMuchData)
            {
                var blockNode = _RenderVars.BlockTree.GetBlockNode(block.ID);
                if (blockNode.NoEmptyChilds == null) return;
                for (var i = 0; i < blockNode.NoEmptyChilds.Length; i++)
                    CollectBlockDatas(isCore, blockNode.NoEmptyChilds[i].Block);
                return;
            }
            
            for(var i = 0; i < blockVegetationDatas.ModelPrototypeCount; i++)
            {
                var modelID = blockVegetationDatas.ModelPrototypeIDs[i];
                var modelDatas = blockVegetationDatas.DatasArray[i];
                _RenderVars.GetModelRenderingData(modelID).AddVegetationDatas(isCore, modelDatas);
            }
        }
        /// <summary>
        /// 剔除植被数据
        /// </summary>
        private static void CullVegetationDatas()
        {
            if (_RenderParams.DrawsWithProcedural) CullVegetationDatasWithJobSystem();
            else CullVegetationDatasWithComputeShader();
        }
        private static void CullVegetationDatasWithJobSystem()
        {
            UnityEngine.Profiling.Profiler.BeginSample("CullVegetations_Job");
            _RenderVars.TempJobHandlesLength = 0;
            if (_RenderVars.TempJobHandles == null)
                _RenderVars.TempJobHandles = new JobHandle[_RenderVars.ModelRenderingDatas.Length];
            for (var i = 0; i < _RenderVars.ModelRenderingDatas.Length; i++)
            {
                var modelRenderingsData = _RenderVars.ModelRenderingDatas[i];
                if (modelRenderingsData.InstanceCount == 0) continue;
                modelRenderingsData.PrepareCullVegetationDatas(true);
                var jobhandle = new CullVegetationsInitJob()
                {
                    VisibleLOD0CountNativeArray = modelRenderingsData.VisibleLOD0CountNativeArray,
                    VisibleLOD1CountNativeArray = modelRenderingsData.VisibleLOD1CountNativeArray,
                    VisibleLOD2CountNativeArray = modelRenderingsData.VisibleLOD2CountNativeArray,
                    VisibleLOD3CountNativeArray = modelRenderingsData.VisibleLOD3CountNativeArray,
                    VisibleLOD4CountNativeArray = modelRenderingsData.VisibleLOD4CountNativeArray,
                    VegetationBoundsCountNativeArray = modelRenderingsData.VegetationBoundsCountNativeArray,
                }.Schedule();
                jobhandle = new CullVegetationsJob()
                {
                    InstanceCount = modelRenderingsData.InstanceCount,
                    InstancesNativeArray = modelRenderingsData.InstancesNativeArray,

                    LODLevelsCount = modelRenderingsData.Model.lodCount,
                    LODLevels = modelRenderingsData.Model.LODLevels,
                    enableImpostor = modelRenderingsData.Model.enableRenderImpostor,
                    tanHalfAngle = _RenderVars.TanHalfAngle,
                    FrustumPlanes = _RenderVars.FrustumPlanesNativeArray,
                    CameraPosition = _RenderVars.CameraPosition,
                    MaxCoreRenderingDistance = _RenderParams.MaxCoreRenderingDistance,
                    MaxRenderingDistance = _RenderParams.MaxRenderingDistance,
                    ShowVisibleVegetationBounds = _RenderParams.ShowVisibleVegetationBounds,

                    VisibleLOD0CountNativeArray = modelRenderingsData.VisibleLOD0CountNativeArray,
                    VisibleLOD1CountNativeArray = modelRenderingsData.VisibleLOD1CountNativeArray,
                    VisibleLOD2CountNativeArray = modelRenderingsData.VisibleLOD2CountNativeArray,
                    VisibleLOD3CountNativeArray = modelRenderingsData.VisibleLOD3CountNativeArray,
                    VisibleLOD4CountNativeArray = modelRenderingsData.VisibleLOD4CountNativeArray,
                    VegetationBoundsCountNativeArray = modelRenderingsData.VegetationBoundsCountNativeArray,

                    VisibleLOD0NativeArray = modelRenderingsData.VisibleLOD0NativeArray,
                    VisibleLOD1NativeArray = modelRenderingsData.VisibleLOD1NativeArray,
                    VisibleLOD2NativeArray = modelRenderingsData.VisibleLOD2NativeArray,
                    VisibleLOD3NativeArray = modelRenderingsData.VisibleLOD3NativeArray,
                    VisibleLOD4NativeArray = modelRenderingsData.VisibleLOD4NativeArray,
                    VegetationBoundsNativeArray = modelRenderingsData.VegetationBoundsNativeArray,

                }.Schedule(modelRenderingsData.InstanceCount, modelRenderingsData.InstanceCount, jobhandle);
                _RenderVars.TempJobHandles[_RenderVars.TempJobHandlesLength++] = jobhandle;
            }
            if(_RenderVars.TempJobHandlesLength > 0)
            {
                JobHandle.ScheduleBatchedJobs();
                var temps = new Unity.Collections.NativeArray<JobHandle>(_RenderVars.TempJobHandlesLength, Allocator.Temp);
                NativeArray<JobHandle>.Copy(_RenderVars.TempJobHandles, temps, _RenderVars.TempJobHandlesLength);
                JobHandle.CompleteAll(temps);
                temps.Dispose();

                UnityEngine.Profiling.Profiler.BeginSample("SetVegetationDatas");
                for(var i = 0; i < _RenderVars.ModelRenderingDatas.Length; i++)
                {
                    var modelRenderingsData = _RenderVars.ModelRenderingDatas[i];
                    if (modelRenderingsData.InstanceCount + modelRenderingsData.impostorInstancesCount == 0) continue;
                    if (modelRenderingsData.LODs == null)
                        modelRenderingsData.InitLODs(true);
                    if (modelRenderingsData.InstanceCount > 0)
                    {
                        modelRenderingsData.VisibleLOD0Count = modelRenderingsData.VisibleLOD0CountNativeArray[0];
                        modelRenderingsData.VisibleLOD1Count = modelRenderingsData.VisibleLOD1CountNativeArray[0];
                        modelRenderingsData.VisibleLOD2Count = modelRenderingsData.VisibleLOD2CountNativeArray[0];
                        modelRenderingsData.VisibleLOD3Count = modelRenderingsData.VisibleLOD3CountNativeArray[0];
                        modelRenderingsData.VisibleLOD4Count = modelRenderingsData.VisibleLOD4CountNativeArray[0];
                        if (_RenderParams.ShowVisibleVegetationBounds)
                            modelRenderingsData.VegetationBoundsCount = modelRenderingsData.VegetationBoundsCountNativeArray[0];
                        if (modelRenderingsData.VisibleLOD0Count > 0)
                        {
                            if (modelRenderingsData.VisibleLOD0ComputeBuffer == null || modelRenderingsData.VisibleLOD0ComputeBuffer.count < modelRenderingsData.VisibleLOD0Count)
                            {
                                modelRenderingsData.VisibleLOD0ComputeBuffer?.Release();
                                modelRenderingsData.VisibleLOD0ComputeBuffer = new ComputeBuffer(modelRenderingsData.VisibleLOD0Count * 2, VegetationInstanceData.stride, ComputeBufferType.Append);
                                modelRenderingsData.ResetLODsMPB(0);
                            }
                            modelRenderingsData.VisibleLOD0ComputeBuffer.SetData(modelRenderingsData.VisibleLOD0NativeArray, 0, 0, modelRenderingsData.VisibleLOD0Count);
                        }
                        if (modelRenderingsData.VisibleLOD1Count > 0)
                        {
                            if (modelRenderingsData.VisibleLOD1ComputeBuffer == null || modelRenderingsData.VisibleLOD1ComputeBuffer.count < modelRenderingsData.VisibleLOD1Count)
                            {
                                modelRenderingsData.VisibleLOD1ComputeBuffer?.Release();
                                modelRenderingsData.VisibleLOD1ComputeBuffer = new ComputeBuffer(modelRenderingsData.VisibleLOD1Count * 2, VegetationInstanceData.stride, ComputeBufferType.Append);
                                modelRenderingsData.ResetLODsMPB(1);
                            }
                            modelRenderingsData.VisibleLOD1ComputeBuffer.SetData(modelRenderingsData.VisibleLOD1NativeArray, 0, 0, modelRenderingsData.VisibleLOD1Count);
                        }
                        if (modelRenderingsData.VisibleLOD2Count > 0)
                        {
                            if (modelRenderingsData.VisibleLOD2ComputeBuffer == null || modelRenderingsData.VisibleLOD2ComputeBuffer.count < modelRenderingsData.VisibleLOD2Count)
                            {
                                modelRenderingsData.VisibleLOD2ComputeBuffer?.Release();
                                modelRenderingsData.VisibleLOD2ComputeBuffer = new ComputeBuffer(modelRenderingsData.VisibleLOD2Count * 2, VegetationInstanceData.stride, ComputeBufferType.Append);
                                modelRenderingsData.ResetLODsMPB(2);
                            }
                            modelRenderingsData.VisibleLOD2ComputeBuffer.SetData(modelRenderingsData.VisibleLOD2NativeArray, 0, 0, modelRenderingsData.VisibleLOD2Count);
                        }
                        if (modelRenderingsData.VisibleLOD3Count > 0)
                        {
                            if (modelRenderingsData.VisibleLOD3ComputeBuffer == null || modelRenderingsData.VisibleLOD3ComputeBuffer.count < modelRenderingsData.VisibleLOD3Count)
                            {
                                modelRenderingsData.VisibleLOD3ComputeBuffer?.Release();
                                modelRenderingsData.VisibleLOD3ComputeBuffer = new ComputeBuffer(modelRenderingsData.VisibleLOD3Count * 2, VegetationInstanceData.stride, ComputeBufferType.Append);
                                modelRenderingsData.ResetLODsMPB(3);
                            }
                            modelRenderingsData.VisibleLOD3ComputeBuffer.SetData(modelRenderingsData.VisibleLOD3NativeArray, 0, 0, modelRenderingsData.VisibleLOD3Count);
                        }
                        if (modelRenderingsData.VisibleLOD4Count > 0)
                        {
                            var impostorCount = modelRenderingsData.VisibleLOD4Count + modelRenderingsData.impostorInstancesCount;
                            if (modelRenderingsData.VisibleLOD4ComputeBuffer == null || modelRenderingsData.VisibleLOD4ComputeBuffer.count < impostorCount)
                            {
                                modelRenderingsData.VisibleLOD4ComputeBuffer?.Release();
                                modelRenderingsData.VisibleLOD4ComputeBuffer = new ComputeBuffer(impostorCount * 2, VegetationInstanceData.stride, ComputeBufferType.Append);
                                modelRenderingsData.ResetLODsMPB(4);
                            }
                            modelRenderingsData.VisibleLOD4ComputeBuffer.SetData(modelRenderingsData.VisibleLOD4NativeArray, 0, 0, modelRenderingsData.VisibleLOD4Count);
                        }
                    }
                    if (modelRenderingsData.impostorInstancesCount > 0)
                    {
                        var impostorCount = modelRenderingsData.VisibleLOD4Count + modelRenderingsData.impostorInstancesCount;
                        if (modelRenderingsData.VisibleLOD4ComputeBuffer == null || modelRenderingsData.VisibleLOD4ComputeBuffer.count < impostorCount)
                        {
                            modelRenderingsData.VisibleLOD4ComputeBuffer?.Release();
                            modelRenderingsData.VisibleLOD4ComputeBuffer = new ComputeBuffer(impostorCount * 2, VegetationInstanceData.stride, ComputeBufferType.Append);
                            modelRenderingsData.ResetLODsMPB(4);
                        }
                        modelRenderingsData.VisibleLOD4ComputeBuffer.SetData(modelRenderingsData.impostorInstances, 0, modelRenderingsData.VisibleLOD4Count, modelRenderingsData.impostorInstancesCount);
                    }
                }
                UnityEngine.Profiling.Profiler.EndSample();
            }
            UnityEngine.Profiling.Profiler.EndSample();
        }
        private static void CullVegetationDatasWithComputeShader()
        {
            UnityEngine.Profiling.Profiler.BeginSample("CullVegetations_ComputeShader");
            for (var i = 0; i < _RenderVars.ModelRenderingDatas.Length; i++)
            {
                var modelRenderingsData = _RenderVars.ModelRenderingDatas[i];
                modelRenderingsData.PrepareCullVegetationDatas(false);
                if (modelRenderingsData.InstanceCount == 0) continue;

                var cs = _RenderParams.CullVegetationsComputeShader;
                var kernel = _RenderVars.CullVegetationsComputeShaderKernel;

                cs.SetInt(_RenderVars.ShaderName_InstancesCount_ID, modelRenderingsData.InstanceCount);
                cs.SetBuffer(kernel, _RenderVars.ShaderName_InstancesStructuredBuffer_ID, modelRenderingsData.InstancesComputeBuffer);

                cs.SetInt(_RenderVars.ShaderName_LODLevelsCount_ID, modelRenderingsData.Model.lodCount);
                cs.SetVector(_RenderVars.ShaderName_LODLevels_ID, modelRenderingsData.Model.LODLevels);
                cs.SetBool(_RenderVars.ShaderName_enableImpostor_ID, modelRenderingsData.Model.enableRenderImpostor);
                cs.SetFloat(_RenderVars.ShaderName_tanHalfAngle_ID, _RenderVars.TanHalfAngle);
                cs.SetVectorArray(_RenderVars.ShaderName_FrustumPlanes_ID, _RenderVars.FrustumPlanes);
                cs.SetVector(_RenderVars.ShaderName_CameraPosition_ID, _RenderVars.CameraPosition);
                cs.SetFloat(_RenderVars.ShaderName_MaxCoreRenderingDistance_ID, modelRenderingsData.Model.enableRenderImpostor ? _RenderParams.MaxCoreRenderingDistance : _RenderParams.MaxGrassRenderingDistance);
                cs.SetFloat(_RenderVars.ShaderName_MaxRenderingDistance_ID, _RenderParams.MaxRenderingDistance);
                cs.SetBool(_RenderVars.ShaderName_ShowVisibleVegetationBounds_ID, _RenderParams.ShowVisibleVegetationBounds);

                cs.SetBuffer(kernel, _RenderVars.ShaderName_VisibleLOD0AppendStructuredBuffer_ID, modelRenderingsData.VisibleLOD0ComputeBuffer);
                cs.SetBuffer(kernel, _RenderVars.ShaderName_VisibleLOD1AppendStructuredBuffer_ID, modelRenderingsData.VisibleLOD1ComputeBuffer);
                cs.SetBuffer(kernel, _RenderVars.ShaderName_VisibleLOD2AppendStructuredBuffer_ID, modelRenderingsData.VisibleLOD2ComputeBuffer);
                cs.SetBuffer(kernel, _RenderVars.ShaderName_VisibleLOD3AppendStructuredBuffer_ID, modelRenderingsData.VisibleLOD3ComputeBuffer);
                cs.SetBuffer(kernel, _RenderVars.ShaderName_VisibleLOD4AppendStructuredBuffer_ID, modelRenderingsData.VisibleLOD4ComputeBuffer);
                cs.SetBuffer(kernel, _RenderVars.ShaderName_VegetationBoundsAppendStructuredBuffer_ID, modelRenderingsData.VegetationBoundsComputeBuffer);

                int threadGroupsX = modelRenderingsData.InstanceCount / 64;
                if (modelRenderingsData.InstanceCount % 64 != 0) ++threadGroupsX;
                cs.Dispatch(kernel, threadGroupsX, 1, 1);

                if (modelRenderingsData.Model.enableRenderImpostor)
                    ComputeBuffer.CopyCount(modelRenderingsData.VisibleLOD4ComputeBuffer, modelRenderingsData.impostorArgsBuffer, sizeof(uint));
                for (var lod = 0; lod < modelRenderingsData.LODs.Count; lod++)
                {
                    var _lod = modelRenderingsData.LODs[lod];
                    for (var r = 0; r < _lod.renderers.Count; r++)
                    {
                        var renderer = _lod.renderers[r];
                        int submeshesToRender = Mathf.Min(renderer.subMeshCount, renderer.materials.Count);
                        for (var submeshIndex = 0; submeshIndex < submeshesToRender; submeshIndex++)
                        {
                            if (lod == 0)
                                ComputeBuffer.CopyCount(modelRenderingsData.VisibleLOD0ComputeBuffer, renderer.argsBufferList[submeshIndex], sizeof(uint));
                            else if (lod == 1)
                                ComputeBuffer.CopyCount(modelRenderingsData.VisibleLOD1ComputeBuffer, renderer.argsBufferList[submeshIndex], sizeof(uint));
                            else if (lod == 2)
                                ComputeBuffer.CopyCount(modelRenderingsData.VisibleLOD2ComputeBuffer, renderer.argsBufferList[submeshIndex], sizeof(uint));
                            else if (lod == 3)
                                ComputeBuffer.CopyCount(modelRenderingsData.VisibleLOD3ComputeBuffer, renderer.argsBufferList[submeshIndex], sizeof(uint));
                        }
                    }
                }
                if (_RenderParams.ShowVisibleVegetationBounds)
                {
                    ComputeBuffer.CopyCount(modelRenderingsData.VegetationBoundsComputeBuffer, modelRenderingsData.VegetationBoundsCountComputeBuffer, 0);
                    modelRenderingsData.VegetationBoundsCountComputeBuffer.GetData(modelRenderingsData.VegetationBoundsCountArr);
                    modelRenderingsData.VegetationBoundsCount = (int)modelRenderingsData.VegetationBoundsCountArr[0];
                    if(modelRenderingsData.VegetationBoundsCount > 0)
                    {
                        if (modelRenderingsData.VegetationBoundsDatas == null || modelRenderingsData.VegetationBoundsDatas.Length < modelRenderingsData.VegetationBoundsCount)
                            modelRenderingsData.VegetationBoundsDatas = new Bounds[modelRenderingsData.VegetationBoundsCount * 2];
                        modelRenderingsData.VegetationBoundsComputeBuffer.GetData(modelRenderingsData.VegetationBoundsDatas, 0, 0, modelRenderingsData.VegetationBoundsCount);
                    }
                }
            }
            UnityEngine.Profiling.Profiler.EndSample();
        }
        /// <summary>
        /// 绘制植被
        /// </summary>
        private static void Draw()
        {
            for(var i = 0; i < _RenderVars.ModelRenderingDatas.Length; i++)
            {
                var modelRenderingData = _RenderVars.ModelRenderingDatas[i];
                if (modelRenderingData.InstanceCount + modelRenderingData.impostorInstancesCount == 0) continue;
                if (_RenderParams.DrawsWithProcedural) DrawWithProcedural(modelRenderingData);
                else DrawWithIndirect(modelRenderingData);
            }
        }
        private static void DrawWithProcedural(ModelRenderingData modelRenderingData)
        {
            UnityEngine.Profiling.Profiler.BeginSample("DrawWithProcedural");
            // 面片
            if (!_RenderParams.OnlyRenderingCore && 
                modelRenderingData.Model.enableRenderImpostor && 
                modelRenderingData.impostorInstancesCount + modelRenderingData.VisibleLOD4Count > 0 &&
                modelRenderingData.impostorMesh &&
                modelRenderingData.impostorMaterial)
            {
                Graphics.DrawMeshInstancedProcedural(
                          modelRenderingData.impostorMesh,
                          0,
                          modelRenderingData.impostorMaterial,
                          _RenderVars.DrawBounds,
                          modelRenderingData.impostorInstancesCount + modelRenderingData.VisibleLOD4Count,
                          modelRenderingData.impostorMPB,
                          UnityEngine.Rendering.ShadowCastingMode.Off,
                          false,
                          modelRenderingData.Model.layer);
            }
            if (_RenderParams.OnlyRenderingImpostor) return;
            // lod
            for (var lod = 0; lod < modelRenderingData.LODs.Count; lod++)
            {
                var count = 0;
                switch (lod)
                {
                    case 0:
                        count = modelRenderingData.VisibleLOD0Count;
                        break;
                    case 1:
                        count = modelRenderingData.VisibleLOD1Count;
                        break;
                    case 2:
                        count = modelRenderingData.VisibleLOD2Count;
                        break;
                    case 3:
                        count = modelRenderingData.VisibleLOD3Count;
                        break;
                }
                if (count == 0) continue;
                var _lod = modelRenderingData.LODs[lod];
                var _lodRenderersCount = _lod.renderers.Count;
                for (var j = 0; j < _lodRenderersCount; j++)
                {
                    var renderer = _lod.renderers[j];
                    var rendererMaterialsCount = renderer.materials.Count;
                    for (var r = 0; r < rendererMaterialsCount; r++)
                    {
                        var mesh = renderer.mesh;
                        var material = renderer.materials[r];
                        var submeshIndex = System.Math.Min(r, renderer.subMeshCount - 1);
                        Graphics.DrawMeshInstancedProcedural(
                            mesh,
                            submeshIndex,
                            material,
                            _RenderVars.DrawBounds,
                            count,
                            renderer.mpb,
                            modelRenderingData.Model.shadowCastingMode,
                            modelRenderingData.Model.receiveShadows,
                            modelRenderingData.Model.layer);
                    }
                }
            }

            UnityEngine.Profiling.Profiler.EndSample();
        }
        private static void DrawWithIndirect(ModelRenderingData modelRenderingData)
        {
            UnityEngine.Profiling.Profiler.BeginSample("DrawWithIndirect");
            // 面片
            if (!_RenderParams.OnlyRenderingCore && 
                modelRenderingData.Model.enableRenderImpostor &&
                modelRenderingData.InstanceCount == 0 && modelRenderingData.impostorInstancesCount > 0 &&
                modelRenderingData.impostorMesh &&
                modelRenderingData.impostorMaterial)
            {
                Graphics.DrawMeshInstancedProcedural(
                          modelRenderingData.impostorMesh,
                          0,
                          modelRenderingData.impostorMaterial,
                          _RenderVars.DrawBounds,
                          modelRenderingData.impostorInstancesCount,
                          modelRenderingData.impostorMPB,
                          UnityEngine.Rendering.ShadowCastingMode.Off,
                          false,
                          modelRenderingData.Model.layer);
                return;
            }
            // 面片
            if (!_RenderParams.OnlyRenderingCore && 
                modelRenderingData.Model.enableRenderImpostor &&
                modelRenderingData.InstanceCount > 0 &&
                modelRenderingData.impostorMesh &&
                modelRenderingData.impostorMaterial)
            {
                Graphics.DrawMeshInstancedIndirect(
                          modelRenderingData.impostorMesh,
                          0,
                          modelRenderingData.impostorMaterial,
                          _RenderVars.DrawBounds,
                          modelRenderingData.impostorArgsBuffer,
                          0,
                          modelRenderingData.impostorMPB,
                          UnityEngine.Rendering.ShadowCastingMode.Off,
                          false,
                          modelRenderingData.Model.layer);
            }
            if (!_RenderParams.OnlyRenderingImpostor && modelRenderingData.InstanceCount > 0)
            {
                // lod
                for (var lod = 0; lod < modelRenderingData.LODs.Count; lod++)
                {
                    var _lod = modelRenderingData.LODs[lod];
                    for (var j = 0; j < _lod.renderers.Count; j++)
                    {
                        var renderer = _lod.renderers[j];
                        int submeshesToRender = Mathf.Min(renderer.subMeshCount, renderer.materials.Count);
                        for (var r = 0; r < submeshesToRender; r++)
                        {
                            var mesh = renderer.mesh;
                            var material = renderer.materials[r];
                            Graphics.DrawMeshInstancedIndirect(
                                mesh,
                                r,
                                material,
                                _RenderVars.DrawBounds,
                                renderer.argsBufferList[r],
                                0,
                                renderer.mpb,
                                modelRenderingData.Model.shadowCastingMode,
                                modelRenderingData.Model.receiveShadows,
                                modelRenderingData.Model.layer);
                        }
                    }
                }
            }
            UnityEngine.Profiling.Profiler.EndSample();
        }
    }
}
