using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public struct GPUBounds
{
    public Vector3 min;
    public Vector3 max;
}


public class ComputeShaderDemo : MonoBehaviour
{
    public Camera MainCamera;
    public GameObject Prefab;
    public ComputeShader FrustumCullingComputeShader;
    public int InstanceCount = 100000;
    public Vector3Int InstanceExtents = new Vector3Int(500, 500, 500);
    [Range(0.1f, 10)]
    public float RandomeMaxScaleValue = 5;
    public Bounds DrawBounds = new Bounds();

    private Bounds meshBounds;
    private Mesh mesh;
    private Material material;
    private int FrustumCullingKernel;
    private ComputeBuffer instanceInputBuffer;
    private ComputeBuffer instanceOutputBuffer;
    private ComputeBuffer instanceBoundsBuffer;
    private GPUBounds[] instanceBounds;
    private uint[] instanceBoundsCount = new uint[] { 0 };
    private ComputeBuffer instanceBoundsCountBuffer;
    private ComputeBuffer argsBuffer;
    private uint[] args = new uint[5] { 0, 0, 0, 0, 0 };
    private MaterialPropertyBlock mpb;
    private Vector4[] FrustumPlanes = new Vector4[6];
    // 随机生成10万个实例矩阵
    private Matrix4x4[] RandomlyGenerated(int instanceCount, Vector3Int instanceExtents, float maxScale)
    {
        var instances = new Matrix4x4[instanceCount];
        var cameraPos = MainCamera.transform.position;
        for (int i = 0; i < instanceCount; i++)
        {
            var pos = new Vector3(
                cameraPos.x + Random.Range(-instanceExtents.x, instanceExtents.x),
                cameraPos.y + Random.Range(-instanceExtents.y, instanceExtents.y),
                cameraPos.z + Random.Range(-instanceExtents.z, instanceExtents.z));
            var r = Quaternion.Euler(Random.Range(0, 180), Random.Range(0, 180), Random.Range(0, 180));
            var s = new Vector3(Random.Range(0.1f, maxScale), Random.Range(0.1f, maxScale), Random.Range(0.1f, maxScale));
            instances[i] = Matrix4x4.TRS(pos, r, s);
        }
        return instances;
    }
    private void initData()
    {
        FrustumCullingKernel = FrustumCullingComputeShader.FindKernel("FrustumCulling");
        mesh = Prefab.GetComponent<MeshFilter>().sharedMesh;
        var mr = Prefab.GetComponent<MeshRenderer>();
        material = mr.sharedMaterial;
        meshBounds = mr.bounds;
        args[0] = mesh.GetIndexCount(0);
        args[1] = 0;
        args[2] = mesh.GetIndexStart(0);
        args[3] = mesh.GetBaseVertex(0);
        args[4] = 0;
        argsBuffer = new ComputeBuffer(5, sizeof(uint) * 5, ComputeBufferType.IndirectArguments);
        argsBuffer.SetData(args);
        instanceInputBuffer = new ComputeBuffer(InstanceCount, sizeof(float) * 16);
        instanceInputBuffer.SetData(RandomlyGenerated(InstanceCount, InstanceExtents, RandomeMaxScaleValue));
        instanceOutputBuffer = new ComputeBuffer(InstanceCount, sizeof(float) * 16, ComputeBufferType.Append);
        instanceBoundsBuffer = new ComputeBuffer(InstanceCount, sizeof(float) * 3 * 2, ComputeBufferType.Append);
        instanceBoundsCountBuffer = new ComputeBuffer(1, sizeof(uint), ComputeBufferType.IndirectArguments);
        mpb = new MaterialPropertyBlock();
        mpb.SetBuffer("IndirectShaderDataBuffer", instanceOutputBuffer);
        DrawBounds.size = Vector3.one * 10000;
    }
    private void SetComputeShaderArgs()
    {
        FrustumCullingComputeShader.SetInt("inputCount", instanceInputBuffer.count);
        FrustumCullingComputeShader.SetVector("boxCenter", meshBounds.center);
        FrustumCullingComputeShader.SetVector("boxExtents", meshBounds.extents);
        FrustumCullingComputeShader.SetBuffer(FrustumCullingKernel, "input", instanceInputBuffer);
        FrustumCullingComputeShader.SetBuffer(FrustumCullingKernel, "VisibleBuffer", instanceOutputBuffer);
        FrustumCullingComputeShader.SetBuffer(FrustumCullingKernel, "GPUBoundsBuffer", instanceBoundsBuffer);

    }
    void Start()
    {
        initData();
        SetComputeShaderArgs();
    }


    private Vector3 per_playerPos = Vector3.zero;
    private Quaternion per_playerRot = Quaternion.identity;
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
    private static Vector4[] GetFrustumPlanes(Camera camera, Vector4[] planes = null)
    {
        if (planes == null) planes = new Vector4[6];
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
    private void UpdateBuffer()
    {
        instanceOutputBuffer.SetCounterValue(0);
        instanceBoundsBuffer.SetCounterValue(0);
        FrustumCullingComputeShader.SetVectorArray("cameraPlanes", GetFrustumPlanes(MainCamera, FrustumPlanes));
        int threadGroupsX = InstanceCount / 32;
        if (InstanceCount % 32 != 0) ++threadGroupsX;
        FrustumCullingComputeShader.Dispatch(FrustumCullingKernel, threadGroupsX, 1, 1);
        ComputeBuffer.CopyCount(instanceOutputBuffer, argsBuffer, sizeof(uint));
        DrawBounds.center = MainCamera.transform.position;
        ComputeBuffer.CopyCount(instanceBoundsBuffer, instanceBoundsCountBuffer, 0);
        instanceBoundsCountBuffer.GetData(instanceBoundsCount);
        if (instanceBounds == null || instanceBounds.Length != instanceBoundsCount[0])
            instanceBounds = new GPUBounds[instanceBoundsCount[0]];
        instanceBoundsBuffer.GetData(instanceBounds);
    }
    private void Draw()
    {
        UnityEngine.Profiling.Profiler.BeginSample("DrawMeshInstancedIndirect");
        if(!material.enableInstancing) material.enableInstancing = true;
        Graphics.DrawMeshInstancedIndirect(
                    mesh,
                    0,
                    material,
                    DrawBounds,
                    argsBuffer,
                    0,
                    mpb
                    );
        UnityEngine.Profiling.Profiler.EndSample();

    }
    void Update()
    {
        if (IsRenderCameraChange())
            UpdateBuffer();
        Draw();
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        for (var i = 0; i < instanceBoundsCount[0]; i++)
        {
            var gpubounds = instanceBounds[i];
            Gizmos.DrawCube((gpubounds.min + gpubounds.max) / 2f, gpubounds.max - gpubounds.min);
        }
    }

    private void OnDestroy()
    {
        instanceInputBuffer?.Release();
        instanceOutputBuffer?.Release();
        instanceBoundsBuffer?.Release();
        instanceBoundsCountBuffer?.Release();
        argsBuffer?.Release();
    }

}
