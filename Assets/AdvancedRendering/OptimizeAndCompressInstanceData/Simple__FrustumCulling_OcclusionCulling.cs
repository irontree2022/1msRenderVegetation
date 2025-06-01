using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class Simple__FrustumCulling_OcclusionCulling : MonoBehaviour
{
    [Header("生成实例的范围")]
    public Vector3Int GeneratedRange = Vector3Int.one * 100;
    public int GeneratedInterval = 4;
    public bool usePackedDatas;
    public int instanceGeneratedCount;

    [Header("实例模型预制体")]
    public GameObject InstancePrefab;
    public ComputeShader cs;
    public Shader depthConversionShader;

    [Header("开启遮挡剔除")]
    public bool enableOcclusionCulling;
    public GameObject OcclusionObject;


    [Space(10)]
    [Header("显示生成的实例包围盒")]
    public bool IsShowGeneratedInstanceBounds;
    [Header("可见实例数量")]
    public uint visibleCount;
    [Header("显示生成的实例包围盒")]
    public bool IsShowVisibleInstanceBounds;

    private Mesh mesh;
    private Material material;
    private Bounds localBounds;
    private Vector4[] localBoundsVerts = new Vector4[8];
    private Matrix4x4[] instances;
    private uint[] packedInstances;
    private CompressedInfo info;
    private int kernel;
    private Matrix4x4 vpMatrix;
    private ComputeBuffer instancesBuffer;
    private ComputeBuffer packedInstancesBuffer;
    private ComputeBuffer cullResultAppendBuffer;
    private MaterialPropertyBlock mpb;
    private uint[] args = new uint[5] { 0, 0, 0, 0, 0 };
    private ComputeBuffer argsBuffer;
    private ComputeBuffer cullResultCountComputeBuffer;
    private uint[] cullResultCountArr = new uint[1] { 0 };
    private Matrix4x4[] visibleInstances;
    private Bounds drawBounds;
    private bool isDestroyed;
    void Start()
    {
        isDestroyed = false;
        GenerateInstanceData();
        mesh = InstancePrefab.GetComponent<MeshFilter>().sharedMesh;
        material = InstancePrefab.GetComponent<MeshRenderer>().sharedMaterial;
        localBounds = mesh.bounds;
        GetLocalBoundsVerts();
        kernel = cs.FindKernel("Hi_z_Main");
        vpMatrix = GL.GetGPUProjectionMatrix(Camera.main.projectionMatrix, false) * Camera.main.worldToCameraMatrix;

        instancesBuffer = new ComputeBuffer(instanceGeneratedCount, sizeof(float) * 16, ComputeBufferType.Structured);
        packedInstancesBuffer = new ComputeBuffer(instanceGeneratedCount * CompressedMatrix.packedCount, sizeof(uint), ComputeBufferType.Structured);
        cullResultAppendBuffer = new ComputeBuffer(instanceGeneratedCount, sizeof(float) * 16, ComputeBufferType.Append);
        instancesBuffer.SetData(instances);
        packedInstancesBuffer.SetData(packedInstances);

        mpb = new MaterialPropertyBlock();
        mpb.SetBuffer("IndirectShaderDataBuffer", cullResultAppendBuffer);

        argsBuffer = new ComputeBuffer(1, sizeof(uint) * 5, ComputeBufferType.IndirectArguments);
        args[0] = mesh.GetIndexCount(0);
        args[1] = 0;
        args[2] = mesh.GetIndexStart(0);
        args[3] = mesh.GetBaseVertex(0);
        args[4] = 0;
        argsBuffer.SetData(args);
        cullResultCountArr[0] = 0;
        cullResultCountComputeBuffer = new ComputeBuffer(1, sizeof(uint), ComputeBufferType.IndirectArguments);
        drawBounds.center = Camera.main.transform.position;
        drawBounds.size = Vector3.one * Camera.main.farClipPlane;
    }
    void GenerateInstanceData()
    {                        // position各分量的最小最大值和范围
        float posMinX = float.MaxValue, posMaxX = float.MinValue, posRangeX;
        float posMinY = float.MaxValue, posMaxY = float.MinValue, posRangeY;
        float posMinZ = float.MaxValue, posMaxZ = float.MinValue, posRangeZ;
        // rotation各分量[-1,1]，直接乘以32767.0f
        // scale最小最大值和范围
        float scaleMin = float.MaxValue, scaleMax = float.MinValue, scaleRange;

        var tempList = new List<Matrix4x4>();
        for(var i = 0; i < GeneratedRange.x; i+= GeneratedInterval)
        {
            for(var j = 0; j < GeneratedRange.y; j+= GeneratedInterval)
            {
                for(var k = 0; k < GeneratedRange.z; k += GeneratedInterval)
                {
                    var pos = new Vector3(i,j,k) - new Vector3(GeneratedRange.x / 2f, GeneratedRange.y/ 2f, GeneratedRange.z/2f);
                    var r = Quaternion.Euler(Random.Range(0, 360), Random.Range(0, 360), Random.Range(0, 360));
                    var s = new Vector3(Random.Range(0.5f,2f), Random.Range(0.5f, 2f), Random.Range(0.5f, 2f));
                    tempList.Add(Matrix4x4.TRS(pos, r, s));
                    ++instanceGeneratedCount;

                    if (usePackedDatas)
                    {
                        if (pos.x > posMaxX) posMaxX = pos.x;
                        if (pos.x < posMinX) posMinX = pos.x;
                        if (pos.y > posMaxY) posMaxY = pos.y;
                        if (pos.y < posMinY) posMinY = pos.y;
                        if (pos.z > posMaxZ) posMaxZ = pos.z;
                        if (pos.z < posMinZ) posMinZ = pos.z;

                        if (s.x > scaleMax) scaleMax = s.x;
                        if (s.y > scaleMax) scaleMax = s.y;
                        if (s.z > scaleMax) scaleMax = s.z;
                        if (s.x < scaleMin) scaleMin = s.x;
                        if (s.y < scaleMin) scaleMin = s.y;
                        if (s.z < scaleMin) scaleMin = s.z;
                    }
                }
            }
        }

        packedInstances = new uint[instanceGeneratedCount * CompressedMatrix.packedCount];
        posRangeX = posMaxX - posMinX;
        posRangeY = posMaxY - posMinY;
        posRangeZ = posMaxZ - posMinZ;
        scaleRange = scaleMax - scaleMin;
        info = new CompressedInfo()
        {
            posMinX = posMinX,
            posMaxX = posMaxX,
            posRangeX = posRangeX,
            posMinY = posMinY,
            posMaxY = posMaxY,
            posRangeY = posRangeY,
            posMinZ = posMinZ,
            posMaxZ = posMaxZ,
            posRangeZ = posRangeZ,

            scaleMin = scaleMin,
            scaleMax = scaleMax,
            scaleRange = scaleRange,
        };
        var tempPacked = new uint[CompressedMatrix.packedCount];
        var compressedMatrix = new CompressedMatrix();
        for (var i = 0; i < instanceGeneratedCount; ++i)
        {
            var instance = tempList[i];
            compressedMatrix.Compress(info, instance.GetPosition(), instance.rotation, instance.lossyScale);
            tempPacked = compressedMatrix.pack(tempPacked);
            packedInstances[i * CompressedMatrix.packedCount + 0] = tempPacked[0];
            packedInstances[i * CompressedMatrix.packedCount + 1] = tempPacked[1];
            packedInstances[i * CompressedMatrix.packedCount + 2] = tempPacked[2];
            packedInstances[i * CompressedMatrix.packedCount + 3] = tempPacked[3];
            packedInstances[i * CompressedMatrix.packedCount + 4] = tempPacked[4];
        }
        instances = tempList.ToArray();

    }
    void GetLocalBoundsVerts()
    {
        var localBoundsCenter = localBounds.center;
        var localBoundsExtents = localBounds.extents;
        // 模型空间8个顶点
        localBoundsVerts[0] = new Vector4(
            localBoundsCenter.x - localBoundsExtents.x,
            localBoundsCenter.y - localBoundsExtents.y,
            localBoundsCenter.z - localBoundsExtents.z,
            1f);
        localBoundsVerts[1] = new Vector4(
            localBoundsCenter.x + localBoundsExtents.x,
            localBoundsCenter.y - localBoundsExtents.y,
            localBoundsCenter.z - localBoundsExtents.z,
            1f);
        localBoundsVerts[2] = new Vector4(
            localBoundsCenter.x + localBoundsExtents.x,
            localBoundsCenter.y - localBoundsExtents.y,
            localBoundsCenter.z + localBoundsExtents.z,
            1f);
        localBoundsVerts[3] = new Vector4(
            localBoundsCenter.x - localBoundsExtents.x,
            localBoundsCenter.y - localBoundsExtents.y,
            localBoundsCenter.z + localBoundsExtents.z,
            1f);
        localBoundsVerts[4] = new Vector4(
            localBoundsCenter.x - localBoundsExtents.x,
            localBoundsCenter.y + localBoundsExtents.y,
            localBoundsCenter.z - localBoundsExtents.z,
            1f);
        localBoundsVerts[5] = new Vector4(
            localBoundsCenter.x + localBoundsExtents.x,
            localBoundsCenter.y + localBoundsExtents.y,
            localBoundsCenter.z - localBoundsExtents.z,
            1f);
        localBoundsVerts[6] = new Vector4(
            localBoundsCenter.x + localBoundsExtents.x,
            localBoundsCenter.y + localBoundsExtents.y,
            localBoundsCenter.z + localBoundsExtents.z,
            1f);
        localBoundsVerts[7] = new Vector4(
            localBoundsCenter.x - localBoundsExtents.x,
            localBoundsCenter.y + localBoundsExtents.y,
            localBoundsCenter.z + localBoundsExtents.z,
            1f);
    }



    void Update()
    {
        if (OcclusionObject)
            OcclusionObject.SetActive(enableOcclusionCulling);
        drawBounds.center = Camera.main.transform.position;
        Graphics.DrawMeshInstancedIndirect(mesh, 0, material, drawBounds, argsBuffer, 0, mpb,
                 ShadowCastingMode.On, true);

    }

    public void AfterDepthMapGenerated(CommandBuffer cmd, RenderTargetIdentifier targetIdentifier)
    {
        vpMatrix = GL.GetGPUProjectionMatrix(Camera.main.projectionMatrix, false) * Camera.main.worldToCameraMatrix;
        cmd.SetComputeVectorParam(cs, "localBoundsCenter", localBounds.center);
        cmd.SetComputeVectorParam(cs, "localBoundsExtents", localBounds.extents);
        cmd.SetComputeMatrixParam(cs, "vpMatrix", vpMatrix);

        cmd.SetComputeIntParam(cs, "InstancesCount", instanceGeneratedCount);
        cmd.SetComputeBufferParam(cs, kernel, "InstancesStructuredBuffer", instancesBuffer);
        cmd.SetComputeBufferParam(cs, kernel, "cullResultAppendBuffer", cullResultAppendBuffer);

        cmd.SetComputeIntParam(cs, "enableOcclusionCulling", enableOcclusionCulling ? 1 : 0);
        cmd.SetComputeTextureParam(cs, kernel, "_HiZMap", targetIdentifier);
        cmd.SetComputeIntParam(cs, "isOpenGL", Camera.main.projectionMatrix.Equals(GL.GetGPUProjectionMatrix(Camera.main.projectionMatrix, false)) ? 1 : 0);
        cmd.SetComputeIntParam(cs, "usesReversedZBuffer", SystemInfo.usesReversedZBuffer ? 1 : 0);
        cmd.SetComputeFloatParam(cs, "farClipPlane", Camera.main.farClipPlane);
        cmd.SetComputeFloatParam(cs, "nearClipPlane", Camera.main.nearClipPlane);
        cmd.SetComputeIntParam(cs, "ScreenWidth", Screen.width);
        cmd.SetComputeIntParam(cs, "ScreenHeight", Screen.height);


        
        cmd.SetComputeIntParam(cs, "usePackedDatas", usePackedDatas ? 1 : 0);
        cmd.SetComputeBufferParam(cs, kernel, "PackedInstancesStructuredBuffer", packedInstancesBuffer);
        cmd.SetComputeFloatParam(cs, "posMinX", info.posMinX);
        cmd.SetComputeFloatParam(cs, "posMaxX", info.posMaxX);
        cmd.SetComputeFloatParam(cs, "posRangeX", info.posRangeX);

        cmd.SetComputeFloatParam(cs, "posMinY", info.posMinY);
        cmd.SetComputeFloatParam(cs, "posMaxY", info.posMaxY);
        cmd.SetComputeFloatParam(cs, "posRangeY", info.posRangeY);

        cmd.SetComputeFloatParam(cs, "posMinZ", info.posMinZ);
        cmd.SetComputeFloatParam(cs, "posMaxZ", info.posMaxZ);
        cmd.SetComputeFloatParam(cs, "posRangeZ", info.posRangeZ);

        cmd.SetComputeFloatParam(cs, "scaleMin", info.scaleMin);
        cmd.SetComputeFloatParam(cs, "scaleMax", info.scaleMax);
        cmd.SetComputeFloatParam(cs, "scaleRange", info.scaleRange);



        cmd.SetBufferCounterValue(cullResultAppendBuffer, 0);
        int threadGroupsX = instanceGeneratedCount / 64;
        if (instanceGeneratedCount % 64 != 0) ++threadGroupsX;
        cmd.DispatchCompute(cs, kernel, threadGroupsX, 1, 1);

        ComputeBuffer.CopyCount(cullResultAppendBuffer, argsBuffer, sizeof(uint));
        ComputeBuffer.CopyCount(cullResultAppendBuffer, cullResultCountComputeBuffer, 0);
        AsyncGPUReadback.Request(cullResultCountComputeBuffer, request =>
        {
            if (request.hasError || isDestroyed) return;
            uint validCount = request.GetData<uint>()[0];
            visibleCount = validCount;
            if(IsShowVisibleInstanceBounds)
            {
                if (visibleInstances == null || visibleCount > visibleInstances.Length)
                    visibleInstances = new Matrix4x4[visibleCount];
                cullResultAppendBuffer.GetData(visibleInstances, 0, 0, (int)visibleCount);
            }
        });
    }

    private void OnDrawGizmos()
    {
        if (IsShowGeneratedInstanceBounds || IsShowVisibleInstanceBounds)
        {
            Gizmos.color = Color.red;
            var instanceCount = IsShowGeneratedInstanceBounds ? instanceGeneratedCount : (int)visibleCount;
            var _instances = IsShowGeneratedInstanceBounds ? instances : visibleInstances;

            for (var i = 0; i < instanceCount; i++)
            {
                var m = _instances[i];
                var min = Vector3.zero;
                var max = min;
                for (var j = 0; j < localBoundsVerts.Length; j++)
                {
                    var boundsVert = localBoundsVerts[j];
                    Vector3 obbBoundsVert = m * boundsVert;

                    if (j == 0)
                    {
                        min = obbBoundsVert;
                        max = obbBoundsVert;
                    }
                    else
                    {
                        min = Vector3.Min(min, obbBoundsVert);
                        max = Vector3.Max(max, obbBoundsVert);
                    }
                }

                var calculatedBounds = new Bounds();
                calculatedBounds.min = min;
                calculatedBounds.max = max;
                Gizmos.DrawWireCube(calculatedBounds.center, calculatedBounds.size);
            }
        }


    }



    private void OnDestroy()
    {
        isDestroyed = true;
        instances = null;
        packedInstances = null;
        instancesBuffer?.Release();
        packedInstancesBuffer?.Release();
        cullResultAppendBuffer?.Release();
        argsBuffer?.Release();
        cullResultCountComputeBuffer?.Release();
        mpb = null;

    }
}
