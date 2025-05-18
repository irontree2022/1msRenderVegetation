using RenderVegetationIn1ms;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Unity.Collections;
using Unity.Jobs;
using Unity.Mathematics;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.UI;

public class OcclusionCulling_Hi_z__CPU : MonoBehaviour
{
    public bool EnableDraw;
    public bool EnableFrustumCulling = true;
    public bool UseFrustumPlanes;
    public bool EnabelHi_z_OcclusionCulling = true;
    public RenderTexture RT;

    public bool onlyGetVisibleBoundsNearPoint;
    public Vector3 nearPoint = new Vector3(5.5f, -3.35f, -0.25f);
    public float nearDistance = 2f;
    public bool EnableDrawGrassInstanceBounds;
    public bool EnableGenGoWithBounds;
    public bool DestroyGoWhenUnableDrawGrassBounds  = true;
    public bool EnableBoundsWhenSelected;


    bool isDestroyed;
    Mesh grassMesh;
    Material grassMaterial;
    Bounds grassBounds;
    Matrix4x4[] grassInstances;
    Bounds[] grassBoundses;

    Matrix4x4 vpMatrix;
    bool isOpenGL;
    Bounds drawBounds;
    Vector4[] FrustumPlanes;
    NativeArray<float4> FrustumPlanesNativeArray;


    public int allInstancesCount;
    NativeArray<Matrix4x4> grassInstancesNativeArray;
    NativeArray<Bounds> grassBoundsesNativeArray;
    NativeArray<bool> grassVisiblesNativeArray;
    NativeArray<bool> grassBoundsesVisiblesNativeArray;
    NativeArray<Matrix4x4> visiblesNativeArray;
    NativeArray<int> visiblesCountNativeArray;
    public int visiblesCount;
    Matrix4x4[] visibles;
    NativeArray<Bounds> visibleBoundsesNativeArray;
    NativeArray<int> visibleBoundsesCountNativeArray;
    public int visibleBoundsesCount;
    Bounds[] visibleBoundses;
    public ComputeBuffer visiblesBuffer;
    MaterialPropertyBlock mpb;

    int depthDatasLength;
    NativeArray<float> depthDataNativeArray;
  

    Matrix4x4 per_vpMatrix;
    bool enabelDebug;


    public event System.Action<NativeArray<float>, int> RTRequestDoneEvent;


    public void Init(Mesh mesh, Material material, Bounds grassBounds, Matrix4x4[] instances, Bounds[] boundses)
    {
        OnDestroy();

        isDestroyed = false;
        grassMesh = mesh;
        grassMaterial = material;
        this.grassBounds = grassBounds;
        grassInstances = instances;
        grassBoundses = boundses;

        allInstancesCount = instances.Length;
        visibles = new Matrix4x4[instances.Length];
        visibleBoundses = new Bounds[instances.Length];
        grassInstancesNativeArray = new NativeArray<Matrix4x4>(instances.Length, Allocator.Persistent);
        grassBoundsesNativeArray = new NativeArray<Bounds>(boundses.Length, Allocator.Persistent);
        grassVisiblesNativeArray = new NativeArray<bool>(instances.Length, Allocator.Persistent);
        grassBoundsesVisiblesNativeArray = new NativeArray<bool>(instances.Length, Allocator.Persistent);
        visiblesNativeArray = new NativeArray<Matrix4x4>(instances.Length, Allocator.Persistent);
        visiblesCountNativeArray = new NativeArray<int>(1, Allocator.Persistent);
        visibleBoundsesNativeArray = new NativeArray<Bounds>(instances.Length, Allocator.Persistent);
        visibleBoundsesCountNativeArray = new NativeArray<int>(1, Allocator.Persistent);
        visiblesBuffer = new ComputeBuffer(instances.Length, sizeof(float) * 16);
        visiblesBuffer.SetData(instances);

        NativeArray<Matrix4x4>.Copy(instances, grassInstancesNativeArray);
        NativeArray<Bounds>.Copy(boundses, grassBoundsesNativeArray);
        NativeArray<Matrix4x4>.Copy(instances, visiblesNativeArray);
        System.Array.Copy(instances, visibles, instances.Length);
        visiblesCount = 0;

        isOpenGL = Camera.main.projectionMatrix.Equals(GL.GetGPUProjectionMatrix(Camera.main.projectionMatrix, false));
        drawBounds.center = Camera.main.transform.position;
        drawBounds.size = Vector3.one * Camera.main.farClipPlane;
        if(mpb == null)
            mpb = new MaterialPropertyBlock();
        mpb.Clear();
        mpb.SetBuffer("IndirectShaderDataBuffer", visiblesBuffer);

        FrustumPlanes = new Vector4[6];
        if (FrustumPlanesNativeArray.IsCreated)
            FrustumPlanesNativeArray.Dispose();
        FrustumPlanesNativeArray = new NativeArray<float4>(6, Allocator.Persistent);

        depthDatasLength = 0;
        depthDataNativeArray = new NativeArray<float>(0, Allocator.Persistent);
        enabelDebug = true;
        per_vpMatrix = Matrix4x4.identity;

    }

    JobHandle jobHandle;
    void Update()
    {
        if (!EnableDraw) return;
        if (RT == null) return;

        vpMatrix = GL.GetGPUProjectionMatrix(Camera.main.projectionMatrix, false) * Camera.main.worldToCameraMatrix;
        var isCameraChanged = per_vpMatrix != vpMatrix;
        per_vpMatrix = vpMatrix;

        // 更新视锥的六个面数据
        if (isCameraChanged)
        {
            FrustumPlanes = RenderVegetationIn1ms.Tool.GetFrustumPlanes(Camera.main, FrustumPlanes);
            for (var i = 0; i < FrustumPlanes.Length; i++)
                FrustumPlanesNativeArray[i] = new float4(
                        FrustumPlanes[i].x,
                        FrustumPlanes[i].y,
                        FrustumPlanes[i].z,
                        FrustumPlanes[i].w);
        }


        // 更新深度图数据
        var totalPixels = Screen.width * Screen.height;
        if (!depthDataNativeArray.IsCreated || depthDataNativeArray.Length < totalPixels)
        {
            if (depthDataNativeArray.IsCreated)
                depthDataNativeArray.Dispose();
            depthDataNativeArray = new NativeArray<float>(totalPixels, Allocator.Persistent);
        }
        // 异步向GPU请求读取深度图RT数据
        AsyncRTRequest();

        // 并行视锥剔除+遮挡剔除
        jobHandle = new Hi_z_Job()
        {
            EnableFrustumCulling = EnableFrustumCulling,
            EnabelHi_z_OcclusionCulling = EnabelHi_z_OcclusionCulling,
            UseFrustumPlanes = UseFrustumPlanes,
            FrustumPlanes = FrustumPlanesNativeArray,

            isOpenGL = isOpenGL,
            usesReversedZBuffer = SystemInfo.usesReversedZBuffer,
            vpMatrix = vpMatrix,
            grassBounds = grassBounds,
            grassCount = grassInstances.Length,
            grassInstances = grassInstancesNativeArray,
            grassBoundsesNativeArray = grassBoundsesNativeArray,
            grassVisibles = grassVisiblesNativeArray,
            depthDatasLength = depthDatasLength,
            depthDataNativeArray = depthDataNativeArray,

            farClipPlane = Camera.main.farClipPlane,
            nearClipPlane = Camera.main.nearClipPlane,
            ScreenSize = new Vector2Int(Screen.width, Screen.height),

            EnableDrawGrassInstanceBounds  = EnableDrawGrassInstanceBounds,
            onlyGetVisibleBoundsNearPoint = onlyGetVisibleBoundsNearPoint,
            nearPoint = nearPoint,
            nearDistance = nearDistance,
            grassBoundsVisibles = grassBoundsesVisiblesNativeArray,

            enabelDebug = enabelDebug,

        }.Schedule(grassInstances.Length, grassInstances.Length);
        jobHandle = new FilterJob()
        {
            grassCount = grassInstances.Length,
            grassInstances = grassInstancesNativeArray,
            grassVisibles = grassVisiblesNativeArray,
            visibles = visiblesNativeArray,
            visiblesCount = visiblesCountNativeArray,

            grassBoundsInstances = grassBoundsesNativeArray,
            grassVisiblesBounds = grassBoundsesVisiblesNativeArray,
            visiblesBounds = visibleBoundsesNativeArray,
            visiblesBoundsCount = visibleBoundsesCountNativeArray,

        }.Schedule(jobHandle);

    }

    private void AsyncRTRequest()
    {
        AsyncGPUReadback.Request(RT, 0, TextureFormat.RFloat, request =>
        {
            if (isDestroyed) return;
            if (request.hasError) return;


            var depthDatas = request.GetData<float>();
            NativeArray<float>.Copy(depthDatas, depthDataNativeArray, depthDatas.Length);
            depthDatasLength = depthDatas.Length;
            RTRequestDoneEvent?.Invoke(depthDataNativeArray, depthDatasLength);
        });
    }

    private void LateUpdate()
    {
        if (!EnableDraw) return;
        if (!jobHandle.IsCompleted)
        {
            jobHandle.Complete();
            visiblesCount = visiblesCountNativeArray[0];
            visiblesBuffer.SetData(visiblesNativeArray, 0, 0, visiblesCount);

            visibleBoundsesCount = visibleBoundsesCountNativeArray[0];
            NativeArray<Bounds>.Copy(visibleBoundsesNativeArray, visibleBoundses, visibleBoundsesCount);
        }
        if (visiblesCount > 0)
        {
            grassBounds.center = Camera.main.transform.position;
            Graphics.DrawMeshInstancedProcedural(grassMesh, 0, grassMaterial, drawBounds,
                visiblesCount, mpb);
        }

    }

    private void OnDestroy()
    {
        EnableDraw = false;
        isDestroyed = true;

        if (grassInstancesNativeArray.IsCreated)
            grassInstancesNativeArray.Dispose();
        if (grassBoundsesNativeArray.IsCreated)
            grassBoundsesNativeArray.Dispose();
        if (grassVisiblesNativeArray.IsCreated)
            grassVisiblesNativeArray.Dispose();
        if (grassBoundsesVisiblesNativeArray.IsCreated)
            grassBoundsesVisiblesNativeArray.Dispose();
        if (visiblesNativeArray.IsCreated)
            visiblesNativeArray.Dispose();
        if (visiblesCountNativeArray.IsCreated)
            visiblesCountNativeArray.Dispose();
        if (visibleBoundsesNativeArray.IsCreated)
            visibleBoundsesNativeArray.Dispose();
        if (visibleBoundsesCountNativeArray.IsCreated)
            visibleBoundsesCountNativeArray.Dispose();
        if (mpb != null)
            mpb.Clear();
        mpb = null;
        visiblesBuffer?.Release();
        if (FrustumPlanesNativeArray.IsCreated)
            FrustumPlanesNativeArray.Dispose();

        if (depthDataNativeArray.IsCreated)
            depthDataNativeArray.Dispose();

        RTRequestDoneEvent = null;
    }

    bool gend;
    GameObject goRoot;
    private void OnDrawGizmos()
    {
#if UNITY_EDITOR
        if (!EnableDraw) return;

        if (EnableDrawGrassInstanceBounds && visiblesCount > 0)
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
            for(var i = 0; i < Selection.gameObjects.Length; ++i)
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

}
