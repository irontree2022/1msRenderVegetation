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

    public int InstanceCount = 1000000;
    public Vector3Int InstanceExtents = new Vector3Int(500, 500, 500);
    public float RandomeMaxScaleValue = 5;


    public GameObject[] Prefabs;
    public int InstanceCount_3D = 100;
    public float distanceInterval = 10;
    public ComputeShader FrustumCullingComputeShader;
    public uint instanceBoundsCount = 0;

    [Header("调试：启用脚本")]
    public bool enable;
    [Header("调试：使用随机位置数据")]
    public bool useRandomPositionInstances;
    [Header("调试：使用2d位置数据")]
    public bool use2DPositionInstances;
    [Header("调试：使用3d位置数据")]
    public bool use3DPositionInstances;
    [Header("调试：显示实例包围盒 GetData()")]
    public bool showInstanceBounds_GetData;
    [Header("调试：显示实例包围盒 AsyncRequest")]
    public bool showInstanceBounds_AsyncRequest;


    private int FrustumCullingKernel;
    private Matrix4x4[] instances;
    private Vector4[] FrustumPlanes = new Vector4[6];
    private Bounds meshBounds;
    private ComputeBuffer instanceInputBuffer;
    private ComputeBuffer instanceOutputBuffer;

    private ComputeBuffer argsBuffer;
    private uint[] args = new uint[5] { 0, 0, 0, 0, 0 };
    private Mesh mesh;
    private Material material;
    private Bounds DrawBounds = new Bounds();
    private MaterialPropertyBlock mpb;


    private ComputeBuffer instanceBoundsBuffer;
    private ComputeBuffer instanceBoundsCountBuffer;
    private uint[] instanceBoundsCountArray = new uint[] { 0 };
    private GPUBounds[] instanceBounds;
    private bool waitRR;
    private bool instanceBoundsCount_ok = true;
    private bool instanceBoundsData_ok = true;
    private UnityEngine.Rendering.AsyncGPUReadbackRequest instanceBoundsDataRR;
    private UnityEngine.Rendering.AsyncGPUReadbackRequest instanceBoundsCountRR;


    private Matrix4x4[] instances_arr;
    private ComputeBuffer instanceInputBuffer_3D;
    private int FrustumCullingKernel_3D;
    private int tX = 8;
    private int tY = 8;
    private int tZ = 8;
    private int gX = 13;
    private int gY = 13;
    private int gZ = 13;
    private ComputeBuffer[] instanceOutputBuffers;



    private ComputeBuffer[] argsBuffers;
    private uint[][] argsArr;
    private Bounds[] meshBoundsArr;
    private Mesh[] meshs;
    private Material[] materials;
    private MaterialPropertyBlock[] mpbs;

    void Start()
    {
        if (!enable) return;

        instances = RandomGeneratedInstances(InstanceCount, InstanceExtents, RandomeMaxScaleValue);

        FrustumCullingKernel = FrustumCullingComputeShader.FindKernel("FrustumCulling");
        mesh = Prefab.GetComponent<MeshFilter>().sharedMesh;
        var mr = Prefab.GetComponent<MeshRenderer>();
        material = mr.sharedMaterial;
        meshBounds = mr.bounds;
        instanceOutputBuffer = new ComputeBuffer(InstanceCount, sizeof(float) * 16, ComputeBufferType.Append);
        instanceInputBuffer = new ComputeBuffer(instances.Length, sizeof(float) * 16);
        instanceInputBuffer.SetData(instances);
        FrustumCullingComputeShader.SetBuffer(FrustumCullingKernel, "input", instanceInputBuffer);
        FrustumCullingComputeShader.SetInt("inputCount", instanceInputBuffer.count);
        FrustumCullingComputeShader.SetVector("boxCenter", meshBounds.center);
        FrustumCullingComputeShader.SetVector("boxExtents", meshBounds.extents);
        FrustumCullingComputeShader.SetBuffer(FrustumCullingKernel, "VisibleBuffer", instanceOutputBuffer);


        DrawBounds.size = Vector3.one * 10000;
        args[0] = mesh.GetIndexCount(0);
        args[1] = 0;
        args[2] = mesh.GetIndexStart(0);
        args[3] = mesh.GetBaseVertex(0);
        args[4] = 0;
        argsBuffer = new ComputeBuffer(5, sizeof(uint) * 5, ComputeBufferType.IndirectArguments);
        argsBuffer.SetData(args);
        mpb = new MaterialPropertyBlock();
        mpb.SetBuffer("IndirectShaderDataBuffer", instanceOutputBuffer);

        instanceBoundsCountBuffer = new ComputeBuffer(1, sizeof(uint), ComputeBufferType.IndirectArguments);
        instanceBoundsBuffer = new ComputeBuffer(InstanceCount, sizeof(float) * 3 * 2, ComputeBufferType.Append);
        FrustumCullingComputeShader.SetBuffer(FrustumCullingKernel, "GPUBoundsBuffer", instanceBoundsBuffer);



        instances_arr = RandomGeneratedInstances_3D();
        FrustumCullingKernel_3D = FrustumCullingComputeShader.FindKernel("FrustumCulling_3d");
        FrustumCullingComputeShader.SetInt("maxInstanceX", InstanceCount_3D);
        FrustumCullingComputeShader.SetInt("maxInstanceY", InstanceCount_3D);
        FrustumCullingComputeShader.SetInt("maxInstanceZ", InstanceCount_3D);
        FrustumCullingComputeShader.SetInt("maxgX", gX);
        FrustumCullingComputeShader.SetInt("maxgY", gY);
        FrustumCullingComputeShader.SetInt("maxgZ", gZ);
        FrustumCullingComputeShader.SetBool("use2DPositionInstances", use2DPositionInstances);
        FrustumCullingComputeShader.SetBool("use3DPositionInstances", use3DPositionInstances);
        instanceOutputBuffers = new ComputeBuffer[Prefabs.Length];
        argsBuffers = new ComputeBuffer[Prefabs.Length];
        argsArr = new uint[Prefabs.Length][];
        meshBoundsArr = new Bounds[Prefabs.Length];
        meshs = new Mesh[Prefabs.Length];
        materials = new Material[Prefabs.Length];
        mpbs = new MaterialPropertyBlock[Prefabs.Length];
        for(var i = 0; i < Prefabs.Length; i++)
        {
            meshs[i] = Prefabs[i].GetComponent<MeshFilter>().sharedMesh;
            mr = Prefabs[i].GetComponent<MeshRenderer>();
            materials[i] = mr.sharedMaterial;
            meshBoundsArr[i] = mr.bounds;
            argsArr[i] = new uint[5] { 0, 0, 0, 0, 0 };
            argsArr[i][0] = meshs[i].GetIndexCount(0);
            argsArr[i][1] = 0;
            argsArr[i][2] = meshs[i].GetIndexStart(0);
            argsArr[i][3] = meshs[i].GetBaseVertex(0);
            argsArr[i][4] = 0;
            argsBuffers[i] = new ComputeBuffer(5, sizeof(uint) * 5, ComputeBufferType.IndirectArguments);
            argsBuffers[i].SetData(argsArr[i]);
            instanceOutputBuffers[i] = new ComputeBuffer(InstanceCount, sizeof(float) * 16, ComputeBufferType.Append);
            mpbs[i] = new MaterialPropertyBlock();
            mpbs[i].SetBuffer("IndirectShaderDataBuffer", instanceOutputBuffers[i]);
            if(i == 0)
                FrustumCullingComputeShader.SetBuffer(FrustumCullingKernel_3D, "VisibleBuffer1", instanceOutputBuffers[i]);
            else if(i == 1)
                FrustumCullingComputeShader.SetBuffer(FrustumCullingKernel_3D, "VisibleBuffer2", instanceOutputBuffers[i]);
            else if(i == 2)
                FrustumCullingComputeShader.SetBuffer(FrustumCullingKernel_3D, "VisibleBuffer3", instanceOutputBuffers[i]);
            else
                FrustumCullingComputeShader.SetBuffer(FrustumCullingKernel_3D, "VisibleBuffer4", instanceOutputBuffers[i]);
        }

        instanceInputBuffer_3D = new ComputeBuffer(instances_arr.Length, sizeof(float) * 16);
        instanceInputBuffer_3D.SetData(instances_arr);
        FrustumCullingComputeShader.SetBuffer(FrustumCullingKernel_3D, "input", instanceInputBuffer_3D);
        FrustumCullingComputeShader.SetBuffer(FrustumCullingKernel_3D, "GPUBoundsBuffer", instanceBoundsBuffer);

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
    private Matrix4x4[] RandomGeneratedInstances_3D()
    {
        gX = InstanceCount_3D / tX;
        if (InstanceCount_3D % tX != 0) ++gX;
        gY = InstanceCount_3D / tY;
        if (InstanceCount_3D % tY != 0) ++gY;
        gZ = InstanceCount_3D / tZ;
        if (InstanceCount_3D % tZ != 0) ++gZ;
        var instances = new Matrix4x4[gX * gY * gZ * tX * tY * tZ];
        for (int _gZ = 0; _gZ < gZ; _gZ++)
        {
            for(int _gY = 0; _gY < gY; _gY++)
            {
                for(var _gX = 0; _gX < gX; _gX++)
                {
                    for(var _tZ = 0; _tZ < tZ; _tZ++)
                    {
                        for(var _tY = 0; _tY < tY; _tY++)
                        {
                            for(var _tX = 0; _tX < tX; _tX++)
                            {
                                var x = _gX * tX + _tX;
                                var y = _gY * tY + _tY;
                                var z = _gZ * tZ + _tZ;
                                if (x >= InstanceCount_3D ||
                                    y >= InstanceCount_3D ||
                                    z >= InstanceCount_3D) continue;
                                var pos = new Vector3(
                                    x * distanceInterval,
                                    y * distanceInterval,
                                    z * distanceInterval);
                                var r = Quaternion.Euler(Random.Range(0, 180), Random.Range(0, 180), Random.Range(0, 180));
                                var s = new Vector3(Random.Range(0.5f, RandomeMaxScaleValue), Random.Range(0.5f, RandomeMaxScaleValue), Random.Range(0.5f, RandomeMaxScaleValue));
                                instances[
                                    z * gY * gX * tX * tY + 
                                    y * gX * tX +
                                    x
                                    ] = Matrix4x4.TRS(pos, r, s);
                            }
                        }
                    }
                }
            }
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
        if (!enable) return;

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

            instanceBoundsBuffer.SetCounterValue(0);
            FrustumCullingComputeShader.SetVectorArray("cameraPlanes", GetFrustumPlanes(MainCamera, FrustumPlanes));
            FrustumCullingComputeShader.SetBool("showInstanceBounds", showInstanceBounds_GetData || showInstanceBounds_AsyncRequest);

            int threadGroupsX = 0;
            if (useRandomPositionInstances)
            {
                instanceOutputBuffer.SetCounterValue(0);
                threadGroupsX = InstanceCount / 64;
                if (InstanceCount % 64 != 0) ++threadGroupsX;
                FrustumCullingComputeShader.Dispatch(FrustumCullingKernel, threadGroupsX, 1, 1);
                ComputeBuffer.CopyCount(instanceOutputBuffer, argsBuffer, sizeof(uint));
            }
            else
            {
                instanceOutputBuffers[0].SetCounterValue(0);
                instanceOutputBuffers[1].SetCounterValue(0);
                if (use3DPositionInstances)
                {
                    instanceOutputBuffers[2].SetCounterValue(0);
                    instanceOutputBuffers[3].SetCounterValue(0);
                }

                FrustumCullingComputeShader.Dispatch(FrustumCullingKernel_3D, gX, gY, gZ);
                ComputeBuffer.CopyCount(instanceOutputBuffers[0], argsBuffers[0], sizeof(uint));
                ComputeBuffer.CopyCount(instanceOutputBuffers[1], argsBuffers[1], sizeof(uint));
                if (use3DPositionInstances)
                {
                    ComputeBuffer.CopyCount(instanceOutputBuffers[2], argsBuffers[2], sizeof(uint));
                    ComputeBuffer.CopyCount(instanceOutputBuffers[3], argsBuffers[3], sizeof(uint));
                }
            }
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

        // 绘制
        if (useRandomPositionInstances)
            Graphics.DrawMeshInstancedIndirect(
                mesh,
                0,
                material,
                DrawBounds,
                argsBuffer,
                0,
                mpb
                );
        else
        {
            Graphics.DrawMeshInstancedIndirect(
                meshs[0],
                0,
                materials[0],
                DrawBounds,
                argsBuffers[0],
                0,
                mpbs[0]
                );
            Graphics.DrawMeshInstancedIndirect(
                meshs[1],
                0,
                materials[1],
                DrawBounds,
                argsBuffers[1],
                0,
                mpbs[1]
                );
            if(use3DPositionInstances)
            {
                Graphics.DrawMeshInstancedIndirect(
                meshs[2],
                0,
                materials[2],
                DrawBounds,
                argsBuffers[2],
                0,
                mpbs[2]
                );
                Graphics.DrawMeshInstancedIndirect(
                meshs[3],
                0,
                materials[3],
                DrawBounds,
                argsBuffers[3],
                0,
                mpbs[3]
                );
            }
        }
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        for (var i = 0; instanceBounds != null && instanceBoundsData_ok && i < instanceBoundsCount; i++)
        {
            if (i >= instanceBounds.Length) break;
            var gpubounds = instanceBounds[i];
            Gizmos.DrawWireCube((gpubounds.min + gpubounds.max) / 2f, gpubounds.max - gpubounds.min);
        }
    }

    private void OnDestroy()
    {
        instanceInputBuffer?.Release();
        instanceOutputBuffer?.Release();
        argsBuffer?.Release();

        instanceBoundsBuffer?.Release();
        instanceBoundsCountBuffer?.Release();
        instanceInputBuffer_3D?.Release();
        for (var i = 0; instanceOutputBuffers != null && i < instanceOutputBuffers.Length; i++)
        {
            instanceOutputBuffers[i]?.Release();
            argsBuffers[i]?.Release();
        }
    }

}
