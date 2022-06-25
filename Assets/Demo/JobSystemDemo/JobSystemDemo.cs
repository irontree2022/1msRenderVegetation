using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Mathematics;
using Unity.Collections;
using Unity.Jobs;

public class JobSystemDemo : MonoBehaviour
{
    public Camera MainMamera;
    public GameObject Prefab;

    public int InstanceCount = 100000;
    public Vector3Int InstanceExtents = new Vector3Int(500, 500, 500);
    public float RandomeMaxScaleValue = 5;
    public int outputLength;

    private Bounds meshBounds;
    private float4[] FrustumPlanesArray = new float4[6];
    private NativeArray<float4> FrustumPlanes;
    private NativeArray<float4x4> input;
    private NativeArray<int> outputCount;
    private NativeArray<float4x4> output;


    private Mesh mesh;
    private Material material;
    private Bounds DrawBounds = new Bounds();
    private MaterialPropertyBlock mpb;
    private ComputeBuffer instanceOutputBuffer;

    void Start()
    {
        // 随机生成实例数据
        RandomGeneratedInstances(InstanceCount, InstanceExtents, RandomeMaxScaleValue);

        // 初始化各种参数
        mesh = Prefab.GetComponent<MeshFilter>().sharedMesh;
        var mr = Prefab.GetComponent<MeshRenderer>();
        material = mr.sharedMaterial;
        meshBounds = mr.bounds;
        FrustumPlanes = new NativeArray<float4>(6, Allocator.Persistent);
        outputCount = new NativeArray<int>(1, Allocator.Persistent);
        output = new NativeArray<float4x4>(InstanceCount, Allocator.Persistent);
        DrawBounds.size = Vector3.one * 100000;

        instanceOutputBuffer = new ComputeBuffer(InstanceCount, sizeof(float) * 16);
        mpb = new MaterialPropertyBlock();
        // 设置缓冲区位置
        mpb.SetBuffer("IndirectShaderDataBuffer", instanceOutputBuffer);
    }
    /// <summary>
    /// 随机生成实例数据
    /// </summary>
    private void RandomGeneratedInstances(int instanceCount, Vector3Int instanceExtents, float maxScale)
    {
        input = new NativeArray<float4x4>(instanceCount, Allocator.Persistent);

        var cameraPos = MainMamera.transform.position;
        for(var i = 0; i < instanceCount; i++)
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


    private Vector3 per_playerPos = Vector3.zero;
    private Quaternion per_playerRot = Quaternion.identity;
    // 判断摄像机是否发生了变化
    public bool IsCameraChange()
    {
        if(per_playerPos != MainMamera.transform.position ||
            per_playerRot != MainMamera.transform.rotation)
        {
            per_playerPos = MainMamera.transform.position;
            per_playerRot = MainMamera.transform.rotation;
            return true;
        }
        return false;
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



    void Update()
    {
        if (IsCameraChange())
        {
            // 执行视锥剔除
            DrawBounds.center = MainMamera.transform.position;
            outputCount[0] = 0;
            FrustumPlanes.CopyFrom(GetFrustumPlanes(MainMamera, FrustumPlanesArray));
            var job = new FrustumCullingJob();
            job.input = input;
            job.outputCount = outputCount;
            job.output = output;
            job.boxCenter = meshBounds.center;
            job.boxExtents = meshBounds.extents;
            job.cameraPlanes = FrustumPlanes;
            var jobhanle = job.Schedule(InstanceCount, InstanceCount);
            JobHandle.ScheduleBatchedJobs();
            jobhanle.Complete();
            // 剔除之后，获得保留的所有实例数量
            outputLength = outputCount[0];
            // 将这些实例数量全部拷贝进缓冲区中，供绘制使用
            instanceOutputBuffer.SetData(output, 0, 0, outputLength);
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
        // 需要手动释放变量
        if (input.IsCreated)
            input.Dispose();
        if (FrustumPlanes.IsCreated)
            FrustumPlanes.Dispose();
        if (outputCount.IsCreated)
            outputCount.Dispose();
        if (output.IsCreated)
            output.Dispose();
        instanceOutputBuffer?.Release();
    }
}
