using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Mathematics;
using Unity.Collections;
using Unity.Jobs;

public class JobSystemDemo : MonoBehaviour
{
    public Camera MainCamera;
    public GameObject Prefab;
    public int InstanceCount = 100000;
    public Vector3Int InstanceExtents = new Vector3Int(500, 500, 500);
    [Range(0.1f, 10)]
    public float RandomeMaxScaleValue = 5;
    public Bounds DrawBounds = new Bounds();
    [Header("平截头内实例总数")]
    public int outputLength = 0;

    private Bounds meshBounds;
    private Mesh mesh;
    private Material material;
    private ComputeBuffer instanceOutputBuffer;
    private MaterialPropertyBlock mpb;
    private NativeArray<float4> FrustumPlanes;
    private NativeArray<float4x4> input;
    private NativeArray<int> outputCount;
    private NativeArray<float4x4> output;
    private float4[] FrustumPlanesArray = new float4[6];
    private FrustumCullingJob FrustumCullingJob;
    private JobHandle FrustumCullingJobHandle;


    void Start()
    {
        // 随机生成一系列实例数据
        RandomlyGenerated(InstanceCount, InstanceExtents, RandomeMaxScaleValue);

        mesh = Prefab.GetComponent<MeshFilter>().sharedMesh;
        var mr = Prefab.GetComponent<MeshRenderer>();
        material = mr.sharedMaterial;
        meshBounds = mr.bounds;
        instanceOutputBuffer = new ComputeBuffer(InstanceCount, sizeof(float) * 16);
        mpb = new MaterialPropertyBlock();
        mpb.SetBuffer("IndirectShaderDataBuffer", instanceOutputBuffer);
        DrawBounds.size = Vector3.one * 10000;

        FrustumPlanes = new NativeArray<float4>(6, Allocator.Persistent);
        outputCount = new NativeArray<int>(1, Allocator.Persistent);
        output = new NativeArray<float4x4>(InstanceCount, Allocator.Persistent);
        FrustumCullingJob = new FrustumCullingJob();
        FrustumCullingJob.input = input;
        FrustumCullingJob.outputCount = outputCount;
        FrustumCullingJob.output = output;
        FrustumCullingJob.boxCenter = meshBounds.center;
        FrustumCullingJob.boxExtents = meshBounds.extents;
        FrustumCullingJob.cameraPlanes = FrustumPlanes;

    }
    // 随机生成10万个实例矩阵
    private void RandomlyGenerated(int instanceCount, Vector3Int instanceExtents, float maxScale)
    {
        input = new NativeArray<float4x4>(instanceCount, Allocator.Persistent);
        var cameraPos = MainCamera.transform.position;
        for (int i = 0; i < instanceCount; i++)
        {
            var pos = new Vector3(
                cameraPos.x + UnityEngine.Random.Range(-instanceExtents.x, instanceExtents.x),
                cameraPos.y + UnityEngine.Random.Range(-instanceExtents.y, instanceExtents.y),
                cameraPos.z + UnityEngine.Random.Range(-instanceExtents.z, instanceExtents.z));
            var r = Quaternion.Euler(UnityEngine.Random.Range(0, 180), UnityEngine.Random.Range(0, 180), UnityEngine.Random.Range(0, 180));
            var s = new Vector3(UnityEngine.Random.Range(0.1f, maxScale), UnityEngine.Random.Range(0.1f, maxScale), UnityEngine.Random.Range(0.1f, maxScale));
            input[i] = Matrix4x4.TRS(pos, r, s);
        }
    }

    private static Vector4 GetPlane(Vector3 normal, Vector3 point) => new Vector4(normal.x, normal.y, normal.z, -Vector3.Dot(normal, point));
    private static Vector4 GetPlane(Vector3 a, Vector3 b, Vector3 c) => GetPlane(Vector3.Normalize(Vector3.Cross(b - a, c - a)), a);
    private static Vector3[] GetCameraFarClipPlanePoint(Camera camera)
    {
        Vector3[] points = new Vector3[4];
        Transform transform = camera.transform;
        float distance = camera.farClipPlane;
        float halfFovRad = Mathf.Deg2Rad * camera.fieldOfView * 0.5f;
        float upLen = distance * Mathf.Tan(halfFovRad);
        float rightLen = upLen * camera.aspect;
        Vector3 farCenterPoint = transform.position + distance * transform.forward;
        Vector3 up = upLen * transform.up;
        Vector3 right = rightLen * transform.right;
        points[0] = farCenterPoint - up - right;//left-bottom
        points[1] = farCenterPoint - up + right;//right-bottom
        points[2] = farCenterPoint + up - right;//left-up
        points[3] = farCenterPoint + up + right;//right-up
        return points;
    }
    // 获得摄像头六个面
    private static float4[] GetFrustumPlanes(Camera camera, float4[] planes = null)
    {
        if (planes == null) planes = new float4[6];
        Transform transform = camera.transform;
        Vector3 cameraPosition = transform.position;
        Vector3[] points = GetCameraFarClipPlanePoint(camera);
        //顺时针
        planes[0] = GetPlane(cameraPosition, points[0], points[2]);//left
        planes[1] = GetPlane(cameraPosition, points[3], points[1]);//right
        planes[2] = GetPlane(cameraPosition, points[1], points[0]);//bottom
        planes[3] = GetPlane(cameraPosition, points[2], points[3]);//up
        planes[4] = GetPlane(-transform.forward, transform.position + transform.forward * camera.nearClipPlane);//near
        planes[5] = GetPlane(transform.forward, transform.position + transform.forward * camera.farClipPlane);//far
        return planes;
    }

    private Vector3 per_playerPos = Vector3.zero;
    private Quaternion per_playerRot = Quaternion.identity;
    // 摄像头发生改变？
    public bool IsRenderCameraChange()
    {
        if (per_playerPos != MainCamera.transform.position ||
            per_playerRot != MainCamera.transform.rotation)
        {
            per_playerPos = MainCamera.transform.position;
            per_playerRot = MainCamera.transform.rotation;
            return true;
        }
        return false;
    }
    void Update()
    {
        if (IsRenderCameraChange())
        {
            // 视锥剔除
            outputCount[0] = 0;
            FrustumPlanes.CopyFrom(GetFrustumPlanes(MainCamera, FrustumPlanesArray));
            FrustumCullingJobHandle = FrustumCullingJob.Schedule(InstanceCount, InstanceCount);
            JobHandle.ScheduleBatchedJobs();
            FrustumCullingJobHandle.Complete();
            // 将剔除结果写入buffer中
            outputLength = outputCount[0];
            instanceOutputBuffer.SetData(output, 0, 0, outputLength);
            DrawBounds.center = MainCamera.transform.position;
            if (!material.enableInstancing) material.enableInstancing = true;
        }
        // 绘制
        Graphics.DrawMeshInstancedProcedural(
                     mesh,
                     0,
                     material,
                     DrawBounds,
                     outputLength,
                     mpb);
    }

    private void OnDestroy()
    {
        if (input.IsCreated) input.Dispose();
        if (outputCount.IsCreated) outputCount.Dispose();
        if (output.IsCreated) output.Dispose();
        if(FrustumPlanes.IsCreated) FrustumPlanes.Dispose();
        instanceOutputBuffer?.Release();
    }
}
