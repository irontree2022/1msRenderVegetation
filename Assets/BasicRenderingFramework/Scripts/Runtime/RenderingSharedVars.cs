using System.Collections;
using System.Collections.Generic;
using System.Transactions;
using Unity.Collections;
using Unity.Jobs;
using Unity.Mathematics;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// 共享的渲染变量
    /// <para>可以在渲染系统内部各个子系统内共享此变量</para>
    /// </summary>
    public class RenderingSharedVars
    {
        private static RenderVegetationIn1ms _RenderParams;
        


        /// <summary>
        /// 渲染系统初始化完成？
        /// </summary>
        public bool Initialized;

        #region 植被数据加载
        /// <summary>
        /// 本地植被数据是否正在加载中？
        /// </summary>
        public bool IsLoadingLocalVegetationData;
        /// <summary>
        /// 本地植被数据已加载完成？
        /// </summary>
        public bool LocalVegetationDataLoaded;
        /// <summary>
        /// 区块树对象
        /// </summary>
        public BlockTree BlockTree;
        /// <summary>
        /// 根据区块深度排列的数组
        /// </summary>
        public List<BlockNode>[] BlockNodesDepths;
        /// <summary>
        /// 植被数据库对象
        /// </summary>
        public VegetationDatabase Database;
        #endregion

        #region 区块剔除
        public bool BlockDatasInitialized;
        public int CollectedBlocksLength;
        public Block[] CollectedBlocks;
        public NativeArray<Block> CollectedBlocksNativeArray;
        public NativeArray<Block> AfterCullingBlocksNativeArray;
        public Block[] AfterCullingBlocks;
        public int CoreBlocksLength;
        public int ImpostorBlocksLength;
        public Block[] CoreBlocks;
        public Block[] ImpostorBlocks;
        #endregion

        #region 摄像机数据
        private Transform _cameraTransform;
        private Quaternion _cameraRotation;
        public float CameraFOV;
        public float CameraNear;
        public float CameraFar;
        public Vector3 CameraPosition;
        public float QualitySettingsLodBias;
        public bool CameraOrthographic;
        public float CameraOrthographicSize;

        public float TanHalfAngle;
        public Vector4[] FrustumPlanes;
        public NativeArray<float4> FrustumPlanesNativeArray;
        public Bounds DrawBounds;
        /// <summary>
        /// 检查摄像机是否已经发生变化
        /// </summary>
        public bool CameraChanged => _cameraTransform.position != CameraPosition ||
               _cameraTransform.rotation != _cameraRotation ||
               _RenderParams.Camera.fieldOfView != CameraFOV ||
               _RenderParams.Camera.nearClipPlane != CameraNear ||
               _RenderParams.Camera.farClipPlane != CameraFar;
        #endregion



        #region 植被剔除和渲染
        public ModelRenderingData[] ModelRenderingDatas;
        public ModelRenderingData GetModelRenderingData(int modelID) => ModelRenderingDatas[modelID];
        public int TempJobHandlesLength;
        public JobHandle[] TempJobHandles;

        public int CullVegetationsComputeShaderKernel;

        public const string ShaderName_IndirectShaderDataBuffer = "IndirectShaderDataBuffer";
        public int ShaderName_IndirectShaderDataBuffer_ID = -1;

        public const string ShaderName_InstancesCount = "InstancesCount";
        public const string ShaderName_InstancesStructuredBuffer = "InstancesStructuredBuffer";
        public const string ShaderName_LODLevelsCount = "LODLevelsCount";
        public const string ShaderName_LODLevels = "LODLevels";
        public const string ShaderName_enableImpostor = "enableImpostor";
        public const string ShaderName_tanHalfAngle = "tanHalfAngle";
        public const string ShaderName_FrustumPlanes = "FrustumPlanes";
        public const string ShaderName_CameraPosition = "CameraPosition";
        public const string ShaderName_MaxCoreRenderingDistance = "MaxCoreRenderingDistance";
        public const string ShaderName_MaxRenderingDistance = "MaxRenderingDistance";
        public const string ShaderName_ShowVisibleVegetationBounds = "ShowVisibleVegetationBounds";
        public const string ShaderName_VisibleLOD0AppendStructuredBuffer = "VisibleLOD0AppendStructuredBuffer";
        public const string ShaderName_VisibleLOD1AppendStructuredBuffer = "VisibleLOD1AppendStructuredBuffer";
        public const string ShaderName_VisibleLOD2AppendStructuredBuffer = "VisibleLOD2AppendStructuredBuffer";
        public const string ShaderName_VisibleLOD3AppendStructuredBuffer = "VisibleLOD3AppendStructuredBuffer";
        public const string ShaderName_VisibleLOD4AppendStructuredBuffer = "VisibleLOD4AppendStructuredBuffer";
        public const string ShaderName_VegetationBoundsAppendStructuredBuffer = "VegetationBoundsAppendStructuredBuffer";
        // 添加四个参与LOD计算的参数
        public const string ShaderName_QualitySettingsLodBias = "QualitySettingsLodBias";
        public const string ShaderName_CameraOrthographic = "CameraOrthographic";
        public const string ShaderName_CameraOrthographicSize = "CameraOrthographicSize";
        public const string ShaderName_CameraFieldOfView = "CameraFieldOfView";
        public const string ShaderName_LODGroupSize = "LODGroupSize";

        public int ShaderName_InstancesCount_ID = -1;
        public int ShaderName_InstancesStructuredBuffer_ID = -1;
        public int ShaderName_LODLevelsCount_ID = -1;
        public int ShaderName_LODLevels_ID = -1;
        public int ShaderName_enableImpostor_ID = -1;
        public int ShaderName_tanHalfAngle_ID = -1;
        public int ShaderName_FrustumPlanes_ID = -1;
        public int ShaderName_CameraPosition_ID = -1;

        public int ShaderName_QualitySettingsLodBias_ID = -1;
        public int ShaderName_CameraOrthographic_ID = -1;
        public int ShaderName_CameraOrthographicSize_ID = -1;
        public int ShaderName_CameraFieldOfView_ID = -1;
        public int ShaderName_LODGroupSize_ID = -1;

        public int ShaderName_MaxCoreRenderingDistance_ID = -1;
        public int ShaderName_MaxRenderingDistance_ID = -1;
        public int ShaderName_ShowVisibleVegetationBounds_ID = -1;
        public int ShaderName_VisibleLOD0AppendStructuredBuffer_ID = -1;
        public int ShaderName_VisibleLOD1AppendStructuredBuffer_ID = -1;
        public int ShaderName_VisibleLOD2AppendStructuredBuffer_ID = -1;
        public int ShaderName_VisibleLOD3AppendStructuredBuffer_ID = -1;
        public int ShaderName_VisibleLOD4AppendStructuredBuffer_ID = -1;
        public int ShaderName_VegetationBoundsAppendStructuredBuffer_ID = -1;
        #endregion


        /// <summary>
        /// 初始化所有共享的渲染变量
        /// </summary>
        /// <param name="renderParam">渲染控制参数对象</param>
        public void Init(RenderVegetationIn1ms renderParam)
        {
            Initialized = false;
            _RenderParams = renderParam;
            BlockTree = new BlockTree();
            Database = new VegetationDatabase();
            InitCameraDatas();
            ModelRenderingDatas = new ModelRenderingData[_RenderParams.ModelPrototypeDatabase.ModelPrototypeList.Count];
            for(var i = 0; i < ModelRenderingDatas.Length; i++)
            {
                var modelRenderingData = new ModelRenderingData();
                modelRenderingData.ID = i;
                modelRenderingData.Model = _RenderParams.ModelPrototypeDatabase.ModelPrototypeList[i];
                ModelRenderingDatas[i] = modelRenderingData;
            }
            InitShaderIDs();
        }
        public void OnDestroy()
        {
            BlockTree = null;
            BlockNodesDepths = null;
            Database = null;

            if (CollectedBlocksNativeArray.IsCreated)
                CollectedBlocksNativeArray.Dispose();
            if (AfterCullingBlocksNativeArray.IsCreated)
                AfterCullingBlocksNativeArray.Dispose();

            if (FrustumPlanesNativeArray.IsCreated)
                FrustumPlanesNativeArray.Dispose();

            for (var i = 0; i < ModelRenderingDatas.Length; i++)
            {
                if (ModelRenderingDatas[i] == null) continue;
                ModelRenderingDatas[i].Clear();
                ModelRenderingDatas[i] = null;
            }
            ModelRenderingDatas = null;

            _RenderParams = null;
        }

        /// <summary>
        /// 初始化摄像机数据
        /// </summary>
        private void InitCameraDatas()
        {
            if (_RenderParams.Camera == null)
                _RenderParams.Camera = Camera.main;
            _cameraTransform = _RenderParams.Camera.transform;
            FrustumPlanes = new Vector4[6];
            FrustumPlanesNativeArray = new NativeArray<float4>(6, Allocator.Persistent);
            UpdateCameraDatas();
            CameraFar -= 1;
        }
        /// <summary>
        /// 更新摄像机数据
        /// </summary>
        public void UpdateCameraDatas()
        {
            CameraPosition = _cameraTransform.position;
            _cameraRotation = _cameraTransform.rotation;
            CameraFOV = _RenderParams.Camera.fieldOfView;
            CameraNear = _RenderParams.Camera.nearClipPlane;
            CameraFar = _RenderParams.Camera.farClipPlane;
            CameraOrthographic = _RenderParams.Camera.orthographic;
            CameraOrthographicSize = _RenderParams.Camera.orthographicSize;
            QualitySettingsLodBias = QualitySettings.lodBias;

            TanHalfAngle = Mathf.Tan(Mathf.Deg2Rad * CameraFOV * 0.5f);
            FrustumPlanes = Tool.GetFrustumPlanes(_RenderParams.Camera, FrustumPlanes);
            for (var i = 0; i < FrustumPlanes.Length; i++)
                FrustumPlanesNativeArray[i] = new float4(
                        FrustumPlanes[i].x,
                        FrustumPlanes[i].y,
                        FrustumPlanes[i].z,
                        FrustumPlanes[i].w);
            DrawBounds.center = CameraPosition;
            DrawBounds.extents = Vector3.one * CameraFar;
        }
        /// <summary>
        /// 初始化shader属性ID值
        /// </summary>
        private void InitShaderIDs()
        {
            if (!_RenderParams.DrawsWithProcedural)
                CullVegetationsComputeShaderKernel = _RenderParams.CullVegetationsComputeShader.FindKernel("CullVegetations");

            ShaderName_IndirectShaderDataBuffer_ID = Shader.PropertyToID(ShaderName_IndirectShaderDataBuffer);

            ShaderName_InstancesCount_ID = Shader.PropertyToID(ShaderName_InstancesCount);
            ShaderName_InstancesStructuredBuffer_ID = Shader.PropertyToID(ShaderName_InstancesStructuredBuffer);
            ShaderName_LODLevelsCount_ID = Shader.PropertyToID(ShaderName_LODLevelsCount);
            ShaderName_LODLevels_ID = Shader.PropertyToID(ShaderName_LODLevels);
            ShaderName_enableImpostor_ID = Shader.PropertyToID(ShaderName_enableImpostor);
            ShaderName_tanHalfAngle_ID = Shader.PropertyToID(ShaderName_tanHalfAngle);
            ShaderName_FrustumPlanes_ID = Shader.PropertyToID(ShaderName_FrustumPlanes);
            ShaderName_CameraPosition_ID = Shader.PropertyToID(ShaderName_CameraPosition);

            ShaderName_QualitySettingsLodBias_ID = Shader.PropertyToID(ShaderName_QualitySettingsLodBias);
            ShaderName_CameraOrthographic_ID = Shader.PropertyToID(ShaderName_CameraOrthographic);
            ShaderName_CameraOrthographicSize_ID = Shader.PropertyToID(ShaderName_CameraOrthographicSize);
            ShaderName_CameraFieldOfView_ID = Shader.PropertyToID(ShaderName_CameraFieldOfView);
            ShaderName_LODGroupSize_ID = Shader.PropertyToID(ShaderName_LODGroupSize);

            ShaderName_MaxCoreRenderingDistance_ID = Shader.PropertyToID(ShaderName_MaxCoreRenderingDistance);
            ShaderName_MaxRenderingDistance_ID = Shader.PropertyToID(ShaderName_MaxRenderingDistance);
            ShaderName_ShowVisibleVegetationBounds_ID = Shader.PropertyToID(ShaderName_ShowVisibleVegetationBounds);
            ShaderName_VisibleLOD0AppendStructuredBuffer_ID = Shader.PropertyToID(ShaderName_VisibleLOD0AppendStructuredBuffer);
            ShaderName_VisibleLOD1AppendStructuredBuffer_ID = Shader.PropertyToID(ShaderName_VisibleLOD1AppendStructuredBuffer);
            ShaderName_VisibleLOD2AppendStructuredBuffer_ID = Shader.PropertyToID(ShaderName_VisibleLOD2AppendStructuredBuffer);
            ShaderName_VisibleLOD3AppendStructuredBuffer_ID = Shader.PropertyToID(ShaderName_VisibleLOD3AppendStructuredBuffer);
            ShaderName_VisibleLOD4AppendStructuredBuffer_ID = Shader.PropertyToID(ShaderName_VisibleLOD4AppendStructuredBuffer);
            ShaderName_VegetationBoundsAppendStructuredBuffer_ID = Shader.PropertyToID(ShaderName_VegetationBoundsAppendStructuredBuffer);

        }

        /// <summary>
        /// 重置模型渲染数据
        /// </summary>
        public void ResetModelRenderingDatas()
        {
            for (var i = 0; i < ModelRenderingDatas.Length; i++)
            {
                var modelRenderingsData = ModelRenderingDatas[i];
                modelRenderingsData.InstanceCount = 0;
                modelRenderingsData.impostorInstancesCount = 0;
                modelRenderingsData.VisibleLOD0Count = 0;
                modelRenderingsData.VisibleLOD1Count = 0;
                modelRenderingsData.VisibleLOD2Count = 0;
                modelRenderingsData.VisibleLOD3Count = 0;
                modelRenderingsData.VisibleLOD4Count = 0;
                modelRenderingsData.VegetationBoundsCount = 0;
            }
        }


    }
}
