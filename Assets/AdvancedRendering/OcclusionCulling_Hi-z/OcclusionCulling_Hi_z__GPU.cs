using Unity.Collections;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

public class OcclusionCulling_Hi_z__GPU : MonoBehaviour
{
    public bool EnableDraw;
    public bool useCommandBuffer = true;
    public bool drawWithGraphics = true;
    public bool EnableFrustumCulling = true;
    public bool UseFrustumPlanes;
    public bool EnabelHi_z_OcclusionCulling = true;
    public RenderTexture RT;
    public bool onlyGetVisibleBoundsNearPoint;
    public Vector3 nearPoint = new Vector3(5.5f, -3.35f, -0.25f);
    public float nearDistance = 2f;

    public bool EnableDrawGrassInstanceBounds;
    public bool EnableGenGoWithBounds;
    public bool DestroyGoWhenUnableDrawGrassBounds = true;
    public bool EnableBoundsWhenSelected;



    bool isDestroyed;
    public Mesh grassMesh;
    public Material grassMaterial;
    Bounds grassBounds;
    Matrix4x4[] grassInstances;
    Bounds[] grassBoundses;
    int shadowCasterPassIndex = -1;
    int forwardLitPassIndex = -1;
    int depthOnlyPassIndex = -1;


    public MaterialPropertyBlock mpb;
    public int instancesCount;
    public ComputeBuffer grassInstancesBuffer;
    public ComputeBuffer grassBoundsesBuffer;

    uint[] args = new uint[5] { 0, 0, 0, 0, 0 };
    public ComputeBuffer argsBuffer;
    public ComputeBuffer cullResultAppendBuffer;
    public ComputeBuffer cullResultBoundsAppendBuffer;
    public ComputeBuffer cullResultBoundsCountComputeBuffer;
    public uint[] cullResultBoundsCountArr = new uint[1] { 0 };
    public uint visibleBoundsesCount;
    public Bounds[] visibleBoundses;
    public bool IsDrawDataOk;

    public int kernel;
    public ComputeShader cs;
    public bool isOpenGL;
    public bool usesReversedZBuffer;
    Matrix4x4 vpMatrix;
    public Vector4[] FrustumPlanes;
    public Bounds drawBounds;
    Matrix4x4 per_vpMatrix;

    int rtMipmapCount;
    [Header("各层级mipmap尺寸以及数据偏移量")]
    public Vector3Int[] rtMipmapSizes;
    [Header("能够向mipmap取值的最小层级")]
    public int minMipmapLevel = 5;
   
    int maxDepthDatasLength;
    int depthDatasLength;
    // RT各层级mipmap的数据，将会全部写入该数组中，
    // 第0层mipmap，数据范围是0~offset_1； 第1层mipmap数据范围则是 offset_1~offset_2； 第2层mipmap数据范围则是offset_2~offset_3...
    // 对应要取第i层mipmap数据，则需要偏移offset_i，才取得正确的数据
    NativeArray<float> depthDataNativeArray;

    public event System.Action<NativeArray<float>, int> RTRequestDoneEvent;

    public void Init(ComputeShader cs, Mesh mesh, Material material, Bounds grassBounds, Matrix4x4[] instances, Bounds[] boundses)
    {
        OnDestroy();

        instancesCount = instances.Length;
        isDestroyed = false;
        grassMesh = mesh;
        grassMaterial = material;
        this.grassBounds = grassBounds;
        grassInstances = instances;
        grassBoundses = boundses;

        grassInstancesBuffer = new ComputeBuffer(instancesCount, sizeof(float) * 16, ComputeBufferType.Structured);
        grassBoundsesBuffer = new ComputeBuffer(instancesCount, sizeof(float) * (3 + 3), ComputeBufferType.Structured);
        cullResultAppendBuffer = new ComputeBuffer(instancesCount, sizeof(float) * 16, ComputeBufferType.Append);
        cullResultBoundsAppendBuffer = new ComputeBuffer(instancesCount, sizeof(float) * (3 + 3), ComputeBufferType.Append);

        visibleBoundses = new Bounds[instancesCount];
        grassInstancesBuffer.SetData(instances);
        grassBoundsesBuffer.SetData(boundses);
        cullResultAppendBuffer.SetData(instances);
        cullResultBoundsAppendBuffer.SetData(boundses);

        if (mpb == null)
            mpb = new MaterialPropertyBlock();
        mpb.Clear();
        mpb.SetBuffer("IndirectShaderDataBuffer", cullResultAppendBuffer);


        argsBuffer = new ComputeBuffer(1, sizeof(uint) * 5, ComputeBufferType.IndirectArguments);
        cullResultBoundsCountComputeBuffer = new ComputeBuffer(1, sizeof(uint), ComputeBufferType.IndirectArguments);

        args[0] = grassMesh.GetIndexCount(0);
        args[1] = 0;
        args[2] = grassMesh.GetIndexStart(0);
        args[3] = grassMesh.GetBaseVertex(0);
        args[4] = 0;
        argsBuffer.SetData(args);
        cullResultBoundsCountArr[0] = 0;



        this.cs = cs;
        kernel = cs.FindKernel("Hi_z_Main");
        FrustumPlanes = new Vector4[6];
        drawBounds.center = Camera.main.transform.position;
        drawBounds.size = Vector3.one * Camera.main.farClipPlane;
        per_vpMatrix = Matrix4x4.identity;

        isOpenGL = Camera.main.projectionMatrix.Equals(GL.GetGPUProjectionMatrix(Camera.main.projectionMatrix, false));
        usesReversedZBuffer = SystemInfo.usesReversedZBuffer;

        visibleBoundsesCount = 0;

        shadowCasterPassIndex = grassMaterial.FindPass("ShadowCaster");
        forwardLitPassIndex = grassMaterial.FindPass("Forward");
        depthOnlyPassIndex = grassMaterial.FindPass("DepthOnly");

    }
    public void GenMipmapSizes(int mipmapCount)
    {
        rtMipmapCount = mipmapCount;
        if (rtMipmapSizes == null || mipmapCount != rtMipmapSizes.Length)
            rtMipmapSizes = new Vector3Int[mipmapCount];
        maxDepthDatasLength = 0;
        // 这里计算各层mipmap尺寸以及偏移量，
        // 并把最终整个RT（各层mipmap）的数据量统计出来
        for (var i = 0; i < mipmapCount; ++i)
        {
            var w = RT.width >> i;
            var h = RT.height >> i;
            rtMipmapSizes[i] = new Vector3Int(w, h, maxDepthDatasLength);
            maxDepthDatasLength += w * h;
        }
    }
    private void Update()
    {
        if (RT != null)
            AsyncRTRequest();

        if (!useCommandBuffer && RT != null)
        {
            cs.SetInt("InstancesCount", instancesCount);
            cs.SetBuffer(kernel, "InstancesStructuredBuffer", grassInstancesBuffer);
            cs.SetBuffer(kernel, "InstancesBoundsStructuredBuffer", grassBoundsesBuffer);
            cs.SetBuffer(kernel, "cullResultAppendBuffer", cullResultAppendBuffer);
            cs.SetBuffer(kernel, "cullResultBoundsAppendBuffer", cullResultBoundsAppendBuffer);
            cs.SetInt("isOpenGL", isOpenGL ? 1 : 0);
            cs.SetInt("usesReversedZBuffer", usesReversedZBuffer ? 1 : 0);


            vpMatrix = GL.GetGPUProjectionMatrix(Camera.main.projectionMatrix, false) * Camera.main.worldToCameraMatrix;
            var isCameraChanged = per_vpMatrix != vpMatrix;
            per_vpMatrix = vpMatrix;
            // 更新视锥的六个面数据
            if (isCameraChanged)
            {
                FrustumPlanes = RenderVegetationIn1ms.Tool.GetFrustumPlanes(Camera.main, FrustumPlanes);
                cs.SetVector("CameraPosition", Camera.main.transform.position);
                cs.SetVectorArray("FrustumPlanes", FrustumPlanes);
                cs.SetMatrix("vpMatrix", vpMatrix);
                cs.SetFloat("farClipPlane", Camera.main.farClipPlane);
                cs.SetFloat("nearClipPlane", Camera.main.nearClipPlane);
                drawBounds.center = Camera.main.transform.position;
            }

            cs.SetInt("EnableFrustumCulling", EnableFrustumCulling ? 1 : 0);
            cs.SetInt("UseFrustumPlanes", UseFrustumPlanes ? 1 : 0);
            cs.SetInt("EnabelHi_z_OcclusionCulling", EnabelHi_z_OcclusionCulling ? 1 : 0);
            cs.SetInt("ScreenWidth", Screen.width);
            cs.SetInt("ScreenHeight", Screen.height);

            cs.SetInt("EnableDrawGrassInstanceBounds", EnableDrawGrassInstanceBounds ? 1 : 0);
            cs.SetInt("onlyGetVisibleBoundsNearPoint", onlyGetVisibleBoundsNearPoint ? 1 : 0);
            cs.SetVector("nearPoint", nearPoint);
            cs.SetFloat("nearDistance", nearDistance);

            cs.SetTexture(kernel, "_HiZMap", RT);
            cs.SetInt("rtMipmapCount", rtMipmapCount);
            cs.SetInt("minMipmapLevel", minMipmapLevel);

            cullResultAppendBuffer.SetCounterValue(0);
            cullResultBoundsAppendBuffer.SetCounterValue(0);
            int threadGroupsX = instancesCount / 64;
            if (instancesCount % 64 != 0) ++threadGroupsX;
            cs.Dispatch(kernel, threadGroupsX, 1, 1);

            ComputeBuffer.CopyCount(cullResultAppendBuffer, argsBuffer, sizeof(uint));
            if (EnableDrawGrassInstanceBounds)
            {
                ComputeBuffer.CopyCount(cullResultBoundsAppendBuffer, cullResultBoundsCountComputeBuffer, 0);
                AsyncGPUReadback.Request(cullResultBoundsCountComputeBuffer, request =>
                {
                    if (request.hasError || isDestroyed) return;
                    uint validCount = request.GetData<uint>()[0];
                    visibleBoundsesCount = validCount;
                    cullResultBoundsAppendBuffer.GetData(visibleBoundses, 0, 0, (int)validCount);
                });
            }
            else
                visibleBoundsesCount = 0;
        }

        if (drawWithGraphics)
            Graphics.DrawMeshInstancedIndirect(grassMesh, 0, grassMaterial, drawBounds, argsBuffer, 0, mpb,
                 ShadowCastingMode.On, true);

    }
    private void AsyncRTRequest()
    {
        if (!depthDataNativeArray.IsCreated || depthDataNativeArray.Length < maxDepthDatasLength)
        {
            if (depthDataNativeArray.IsCreated)
                depthDataNativeArray.Dispose();
            depthDataNativeArray = new NativeArray<float>(maxDepthDatasLength, Allocator.Persistent);
        }
        depthDatasLength = maxDepthDatasLength;
        for (var i = 0; i < rtMipmapCount; ++i)
        {
            var mipmapLevel = i;
            var mipmapOffset = rtMipmapSizes[i].z;
            // CPU回读RT，RT的各层级mipmap数据，就需要逐一回读才行，
            // 根据当前mipmap层级，将读到的数据写入数组的对应位置中去，
            // 在使用数组中各层级mipmap数据时，则根据写入的位置去取对应mipmap的值
            AsyncGPUReadback.Request(RT, mipmapLevel, TextureFormat.RFloat, request =>
            {
                if (isDestroyed) return;
                if (request.hasError) return;

                var depthDatas = request.GetData<float>();
                NativeArray<float>.Copy(depthDatas, 0, depthDataNativeArray, mipmapOffset, depthDatas.Length);

                RTRequestDoneEvent?.Invoke(depthDataNativeArray, depthDatasLength);
            });
        }
    }
    public void AfterDepthMapGenerated(CommandBuffer cmd, RenderTargetIdentifier targetIdentifier)
    {
        if (!useCommandBuffer) return;

        cmd.SetComputeIntParam(cs, "InstancesCount", instancesCount);
        cmd.SetComputeBufferParam(cs, kernel, "InstancesStructuredBuffer", grassInstancesBuffer);
        cmd.SetComputeBufferParam(cs, kernel, "InstancesBoundsStructuredBuffer", grassBoundsesBuffer);
        cmd.SetComputeBufferParam(cs, kernel, "cullResultAppendBuffer", cullResultAppendBuffer);
        cmd.SetComputeBufferParam(cs, kernel, "cullResultBoundsAppendBuffer", cullResultBoundsAppendBuffer);
        cmd.SetComputeIntParam(cs, "isOpenGL", isOpenGL ? 1 : 0);
        cmd.SetComputeIntParam(cs, "usesReversedZBuffer", usesReversedZBuffer ? 1 : 0);


        vpMatrix = GL.GetGPUProjectionMatrix(Camera.main.projectionMatrix, false) * Camera.main.worldToCameraMatrix;
        var isCameraChanged = per_vpMatrix != vpMatrix;
        per_vpMatrix = vpMatrix;
        FrustumPlanes = RenderVegetationIn1ms.Tool.GetFrustumPlanes(Camera.main, FrustumPlanes);
        cmd.SetComputeVectorParam(cs, "CameraPosition", Camera.main.transform.position);
        cmd.SetComputeVectorArrayParam(cs, "FrustumPlanes", FrustumPlanes);
        cmd.SetComputeMatrixParam(cs, "vpMatrix", vpMatrix);
        cmd.SetComputeFloatParam(cs, "farClipPlane", Camera.main.farClipPlane);
        cmd.SetComputeFloatParam(cs, "nearClipPlane", Camera.main.nearClipPlane);
        drawBounds.center = Camera.main.transform.position;

        cmd.SetComputeIntParam(cs, "EnableFrustumCulling", EnableFrustumCulling ? 1 : 0);
        cmd.SetComputeIntParam(cs, "UseFrustumPlanes", UseFrustumPlanes ? 1 : 0);
        cmd.SetComputeIntParam(cs, "EnabelHi_z_OcclusionCulling", EnabelHi_z_OcclusionCulling ? 1 : 0);
        cmd.SetComputeIntParam(cs, "ScreenWidth", Screen.width);
        cmd.SetComputeIntParam(cs, "ScreenHeight", Screen.height);

        cmd.SetComputeIntParam(cs, "EnableDrawGrassInstanceBounds", EnableDrawGrassInstanceBounds ? 1 : 0);
        cmd.SetComputeIntParam(cs, "onlyGetVisibleBoundsNearPoint", onlyGetVisibleBoundsNearPoint ? 1 : 0);
        cmd.SetComputeVectorParam(cs, "nearPoint", nearPoint);
        cmd.SetComputeFloatParam(cs, "nearDistance", nearDistance);

        cmd.SetComputeTextureParam(cs, kernel, "_HiZMap", targetIdentifier);
        cmd.SetComputeIntParam(cs, "rtMipmapCount", rtMipmapCount);
        cmd.SetComputeIntParam(cs, "minMipmapLevel", minMipmapLevel);

        cmd.SetBufferCounterValue(cullResultAppendBuffer, 0);
        cmd.SetBufferCounterValue(cullResultBoundsAppendBuffer, 0);
        int threadGroupsX = instancesCount / 64;
        if (instancesCount % 64 != 0) ++threadGroupsX;
        cmd.DispatchCompute(cs, kernel, threadGroupsX, 1, 1);

        cmd.CopyCounterValue(cullResultAppendBuffer, argsBuffer, sizeof(uint));
        IsDrawDataOk = true;

        if (EnableDrawGrassInstanceBounds)
        {
            cmd.CopyCounterValue(cullResultBoundsAppendBuffer, cullResultBoundsCountComputeBuffer, 0);
            AsyncGPUReadback.Request(cullResultBoundsCountComputeBuffer, request =>
            {
                if (request.hasError || isDestroyed) return;
                uint validCount = request.GetData<uint>()[0];
                visibleBoundsesCount = validCount;
                cullResultBoundsAppendBuffer.GetData(visibleBoundses, 0, 0, (int)validCount);
            });
        }
        else
            visibleBoundsesCount = 0;

    }

    public void DrawInstances(CommandBuffer cmd)
    {
        if (drawWithGraphics || !IsDrawDataOk) return;
        cmd.DrawMeshInstancedIndirect(grassMesh, 0, grassMaterial, forwardLitPassIndex, argsBuffer, 0, mpb);
    }
    public void DrawInstancesShadow(CommandBuffer cmd)
    {
        if (drawWithGraphics || !IsDrawDataOk) return;
        cmd.DrawMeshInstancedIndirect(grassMesh, 0, grassMaterial, shadowCasterPassIndex, argsBuffer, 0, mpb);
    }



    bool gend;
    GameObject goRoot;
    private void OnDrawGizmos()
    {
#if UNITY_EDITOR
        if (!EnableDraw) return;

        if (EnableDrawGrassInstanceBounds && visibleBoundsesCount > 0)
        {
            if (EnableGenGoWithBounds && goRoot == null)
                goRoot = new GameObject("goRoot");

            for (var i = 0; i < visibleBoundsesCount; ++i)
            {
                var grassBounds = visibleBoundses[i];
                Gizmos.DrawWireCube(grassBounds.center, grassBounds.size);

                if (EnableGenGoWithBounds && !gend)
                {
                    var go = new GameObject($"{i}-{grassMesh.name}");
                    go.AddComponent<MeshFilter>().sharedMesh = grassMesh;
                    go.AddComponent<MeshRenderer>().sharedMaterial = grassMaterial;
                    go.transform.parent = goRoot.transform;
                    go.transform.position = grassBounds.center;
                    go.transform.localScale = grassBounds.size;
                }
            }
            if (EnableGenGoWithBounds)
                gend = true;
        }
        else
        {
            if (DestroyGoWhenUnableDrawGrassBounds && goRoot != null)
                Destroy(goRoot);
            gend = false;
        }

        if (EnableBoundsWhenSelected && Selection.gameObjects != null && Selection.gameObjects.Length > 0)
        {
            for (var i = 0; i < Selection.gameObjects.Length; ++i)
            {
                var go = Selection.gameObjects[i];
                var mr = go.GetComponent<MeshRenderer>();
                if (!mr) continue;
                var bounds = mr.bounds;
                Gizmos.DrawWireCube(bounds.center, bounds.size);
            }
        }
#endif

    }


    private void OnDestroy()
    {
        EnableDraw = false;
        isDestroyed = true;

        if (mpb != null)
            mpb.Clear();
        mpb = null;
        grassInstancesBuffer?.Release();
        grassBoundsesBuffer?.Release();
        argsBuffer?.Release();
        cullResultAppendBuffer?.Release();
        cullResultBoundsAppendBuffer?.Release();
        cullResultBoundsCountComputeBuffer?.Release();

        if (depthDataNativeArray.IsCreated)
            depthDataNativeArray.Dispose();
        RTRequestDoneEvent = null;
    }
}
