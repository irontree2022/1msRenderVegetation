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
    public int InstanceCount = 100000;
    public Vector3Int InstanceExtents = new Vector3Int(500, 500, 500);
    public float RandomeMaxScaleValue = 5;
    public ComputeShader FrustumCullingComputeShader;
    public uint instanceBoundsCount = 0;
    [Header("调试：显示实例包围盒 GetData()")]
    public bool showInstanceBounds_GetData;
    [Header("调试：显示实例包围盒 AsyncRequest")]
    public bool showInstanceBounds_AsyncRequest;


    private int FrustumCullingKernel;
    private ComputeBuffer instanceInputBuffer;
    private ComputeBuffer instanceOutputBuffer;
    private ComputeBuffer instanceBoundsBuffer;
    private ComputeBuffer instanceBoundsCountBuffer;
    private Vector4[] FrustumPlanes = new Vector4[6];
    private uint[] instanceBoundsCountArray = new uint[] { 0 };
    private GPUBounds[] instanceBounds;
    private bool waitRR;
    private bool instanceBoundsCount_ok = true;
    private bool instanceBoundsData_ok = true;
    private UnityEngine.Rendering.AsyncGPUReadbackRequest instanceBoundsDataRR;
    private UnityEngine.Rendering.AsyncGPUReadbackRequest instanceBoundsCountRR;

    private ComputeBuffer argsBuffer;
    private uint[] args = new uint[5] { 0, 0, 0, 0, 0 };
    private Bounds meshBounds;
    private Mesh mesh;
    private Material material;
    private Bounds DrawBounds = new Bounds();
    private MaterialPropertyBlock mpb;


    void Start()
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
        instanceInputBuffer.SetData(RandomGeneratedInstances(InstanceCount, InstanceExtents, RandomeMaxScaleValue));
        instanceOutputBuffer = new ComputeBuffer(InstanceCount, sizeof(float) * 16, ComputeBufferType.Append);
        instanceBoundsBuffer = new ComputeBuffer(InstanceCount, sizeof(float) * 3 * 2, ComputeBufferType.Append);
        instanceBoundsCountBuffer = new ComputeBuffer(1, sizeof(uint), ComputeBufferType.IndirectArguments);
        mpb = new MaterialPropertyBlock();
        mpb.SetBuffer("IndirectShaderDataBuffer", instanceOutputBuffer);
        DrawBounds.size = Vector3.one * 10000;

        FrustumCullingComputeShader.SetInt("inputCount", instanceInputBuffer.count);
        FrustumCullingComputeShader.SetVector("boxCenter", meshBounds.center);
        FrustumCullingComputeShader.SetVector("boxExtents", meshBounds.extents);
        FrustumCullingComputeShader.SetBuffer(FrustumCullingKernel, "input", instanceInputBuffer);
        FrustumCullingComputeShader.SetBuffer(FrustumCullingKernel, "VisibleBuffer", instanceOutputBuffer);
        FrustumCullingComputeShader.SetBuffer(FrustumCullingKernel, "GPUBoundsBuffer", instanceBoundsBuffer);
    }
    // 随机生成10万个实例矩阵
    private Matrix4x4[] RandomGeneratedInstances(int instanceCount, Vector3Int instanceExtents, float maxScale)
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
    void Update()
    {
        if (!instanceBoundsCount_ok && instanceBoundsCountRR.done)
        {
            instanceBoundsCount_ok = true;
            if (!instanceBoundsCountRR.hasError)
            {
                instanceBoundsCountRR.GetData<uint>(0).CopyTo(instanceBoundsCountArray);
                instanceBoundsCount = instanceBoundsCountArray[0];
                if (instanceBoundsCount > 0)
                {
                    instanceBoundsData_ok = false;
                    instanceBoundsDataRR = UnityEngine.Rendering.AsyncGPUReadback.Request(instanceBoundsBuffer, (int)instanceBoundsCount * sizeof(float) * (3 + 3), 0);
                }
                else instanceBoundsCount = 0;
            }
            else instanceBoundsCount = 0;
        }
        if (!instanceBoundsData_ok && instanceBoundsCount_ok && instanceBoundsDataRR.done)
        {
            instanceBoundsData_ok = true;
            if (!instanceBoundsDataRR.hasError)
            {
                if (instanceBounds == null || instanceBounds.Length != instanceBoundsCount)
                    instanceBounds = new GPUBounds[instanceBoundsCount];
                instanceBoundsDataRR.GetData<GPUBounds>(0).CopyTo(instanceBounds);
            }
            else instanceBoundsCount = 0;
        }
        if (instanceBoundsCount_ok &&
            instanceBoundsData_ok)
            waitRR = false;

        if (IsRenderCameraChange())
        {
            DrawBounds.center = MainCamera.transform.position;

            instanceOutputBuffer.SetCounterValue(0);
            instanceBoundsBuffer.SetCounterValue(0);
            FrustumCullingComputeShader.SetVectorArray("cameraPlanes", GetFrustumPlanes(MainCamera, FrustumPlanes));
            FrustumCullingComputeShader.SetBool("showInstanceBounds", showInstanceBounds_GetData || showInstanceBounds_AsyncRequest);

            int threadGroupsX = InstanceCount / 32;
            if (InstanceCount % 32 != 0) ++threadGroupsX;
            FrustumCullingComputeShader.Dispatch(FrustumCullingKernel, threadGroupsX, 1, 1);
            ComputeBuffer.CopyCount(instanceOutputBuffer, argsBuffer, sizeof(uint));
            if (showInstanceBounds_GetData)
            {
                ComputeBuffer.CopyCount(instanceBoundsBuffer, instanceBoundsCountBuffer, 0);
                instanceBoundsCountBuffer.GetData(instanceBoundsCountArray);
                instanceBoundsCount = instanceBoundsCountArray[0];
                if (instanceBounds == null || instanceBounds.Length != instanceBoundsCount)
                    instanceBounds = new GPUBounds[instanceBoundsCount];
                instanceBoundsBuffer.GetData(instanceBounds);
                instanceBoundsCount_ok = true;
                instanceBoundsData_ok = true;
            }

            if (!waitRR && showInstanceBounds_AsyncRequest)
            {
                waitRR = true;
                instanceBoundsCount_ok = true;
                instanceBoundsData_ok = true;
                ComputeBuffer.CopyCount(instanceBoundsBuffer, instanceBoundsCountBuffer, 0);
                instanceBoundsCount_ok = false;
                instanceBoundsCountRR = UnityEngine.Rendering.AsyncGPUReadback.Request(instanceBoundsCountBuffer);
            }
        }
        Graphics.DrawMeshInstancedIndirect(
            mesh,
            0,
            material,
            DrawBounds,
            argsBuffer,
            0,
            mpb
            );
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        for (var i = 0; instanceBounds != null && instanceBoundsData_ok && i < instanceBoundsCount; i++)
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
