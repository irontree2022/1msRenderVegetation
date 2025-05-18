using System.Collections;
using System.Collections.Generic;
using Unity.Collections;
using Unity.Mathematics;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

public class Hi_z_Debug : MonoBehaviour
{
    static Hi_z_Debug instance;
    static bool enbale;
    public static bool Enable
    {
        get => enbale;
        set
        {
            enbale = value;
            if (enbale)
            {
                if (instance == null)
                {
                    var prefab = Resources.Load("Debug");
                    var go = Instantiate(prefab) as GameObject;
                    instance = go.GetComponent<Hi_z_Debug>();
                }
            }
            else
            {
                if (instance)
                    Destroy(instance.gameObject);
            }
        }
    }




    public GameObject TestGo;
    public Image Image;
    public Text Text;
    public bool UseTestGoWorldPos;


    private Transform TestGOTransform;
    private MeshRenderer TestGOMeshRenderer;
    private Material TestGOMaterial;
    private RectTransform ImageRectTransform;
    private int depthDatasLength;
    private NativeArray<float> DepthDatas;
    private Camera Camera;
    private bool isOpenGL;
    private void Awake()
    {
        OnDestroy();
        instance = this;
        TestGOTransform = TestGo.transform;
        TestGOMeshRenderer = TestGo.GetComponent<MeshRenderer>();
        TestGOMaterial = TestGOMeshRenderer.sharedMaterial;
        ImageRectTransform = Image.rectTransform;
        Camera = Camera.main;
        isOpenGL = Camera.main.projectionMatrix.Equals(GL.GetGPUProjectionMatrix(Camera.main.projectionMatrix, false));
        depthDatasLength = 0;
        rtUpdated = false;
    }

    private OcclusionCulling_Hi_z culling_Hi_Z;
    private Bounds per_testGOBounds;
    private Vector3 per_worldPos;
    private bool rtUpdated;
    private bool per_UseTestGoWorldPos;
    private float2[] uvs = new float2[4];
    private void Update()
    {

        if(culling_Hi_Z == null)
            culling_Hi_Z = GameObject.FindAnyObjectByType<OcclusionCulling_Hi_z>();
        if (culling_Hi_Z != null && culling_Hi_Z.UseCPU && culling_Hi_Z.hi_z__CPU != null && culling_Hi_Z.hi_z__CPU.EnableDraw)
        {
            culling_Hi_Z.hi_z__CPU.RTRequestDoneEvent -= WhenRTRequestDone;
            culling_Hi_Z.hi_z__CPU.RTRequestDoneEvent += WhenRTRequestDone;
        }
        else if(culling_Hi_Z != null && !culling_Hi_Z.UseCPU && culling_Hi_Z.hi_z__GPU != null && culling_Hi_Z.hi_z__GPU.EnableDraw)
        {
            culling_Hi_Z.hi_z__GPU.RTRequestDoneEvent -= WhenRTRequestDone;
            culling_Hi_Z.hi_z__GPU.RTRequestDoneEvent += WhenRTRequestDone;
        }


            var worldPos = TestGOTransform.position;
        var bounds = TestGOMeshRenderer.bounds;
        if (depthDatasLength > 0 && ((UseTestGoWorldPos && worldPos != per_worldPos) || (!UseTestGoWorldPos && bounds != per_testGOBounds)) || rtUpdated || per_UseTestGoWorldPos != UseTestGoWorldPos)
        {
            var vpMatrix = GL.GetGPUProjectionMatrix(Camera.main.projectionMatrix, false) * Camera.main.worldToCameraMatrix;
            var screenSize = new int2(Screen.width, Screen.height);

            float4 clipSpace = default;
            float3 ndc = default;
            var depth = 0f;
            var isInClipSpace = false;
            float2 uvSize = new float2(15f, 15f);

            // 将世界坐标转换到裁剪空间
            clipSpace = math.mul(vpMatrix, new float4(worldPos, 1f));
            isInClipSpace = IsInClipSpace(clipSpace);

            // 透视除法转换到NDC
            ndc = clipSpace.xyz / clipSpace.w;
            // ndc到屏幕坐标
            var uv0 = new float2(ndc.x, ndc.y);
            if (isInClipSpace)
            {
                uvs[0] = uv0;
                depth = ndc.z;
                if (isOpenGL)
                    depth = depth * 0.5f + 0.5f; // OpenGL ndc.z处于[-1,1]之间，需要映射到[0-1]
                if (SystemInfo.usesReversedZBuffer)
                    depth = 1f - depth; // 处理平台差异：DX11/Metal/Vulkan 使用反向Z，1.0（近） → 0.0（远）
            }


            if (!UseTestGoWorldPos)
            {
                //包围盒的8个顶点的View Space坐标
                var boundMin = bounds.min;
                var boundMax = bounds.max;
                var boundVerts = new float4[8];
                boundVerts[0] = new float4(boundMin, 1);
                boundVerts[1] = new float4(boundMax, 1);
                boundVerts[2] = new float4(boundMax.x, boundMax.y, boundMin.z, 1f);
                boundVerts[3] = new float4(boundMax.x, boundMin.y, boundMax.z, 1f);
                boundVerts[4] = new float4(boundMax.x, boundMin.y, boundMin.z, 1f);
                boundVerts[5] = new float4(boundMin.x, boundMax.y, boundMax.z, 1f);
                boundVerts[6] = new float4(boundMin.x, boundMax.y, boundMin.z, 1f);
                boundVerts[7] = new float4(boundMin.x, boundMin.y, boundMax.z, 1f);

                //NDC下新的的AABB各个参数
                isInClipSpace = false;
                float minX = 1, minY = 1, minZ = 1, maxX = -1, maxY = -1, maxZ = -1;
                for (int i = 0; i < 8; i++)
                {
                    // 将世界坐标转换到裁剪空间
                    clipSpace = math.mul(vpMatrix, boundVerts[i]);
                    if(!isInClipSpace && IsInClipSpace(clipSpace))
                        isInClipSpace = true;

                    // 透视除法转换到NDC
                    ndc = clipSpace.xyz / clipSpace.w;
                    //计算ndc下的新的AABB
                    if (minX > ndc.x) minX = ndc.x;
                    if (minY > ndc.y) minY = ndc.y;
                    if (minZ > ndc.z) minZ = ndc.z;
                    if (maxX < ndc.x) maxX = ndc.x;
                    if (maxY < ndc.y) maxY = ndc.y;
                    if (maxZ < ndc.z) maxZ = ndc.z;
                }

                if (isInClipSpace)
                {
                    // 计算在屏幕覆盖的区域
                    var minUV = new float2(minX, minY);
                    minUV = minUV * 0.5f + 0.5f;
                    var maxUV = new float2(maxX, maxY);
                    maxUV = maxUV * 0.5f + 0.5f;
                    uvSize = new float2((maxUV.x - minUV.x) * screenSize.x, (maxUV.y - minUV.y) * screenSize.y);

                    // 深度值映射到[0-1]之间
                    // 优先取相机最近的深度值，OpenGL取最小z；
                    // 其他平台默认是反转的，所以取最大z（再度反转后，也是最小z了）
                    depth = minZ;
                    if (isOpenGL)
                        depth = minZ * 0.5f + 0.5f; // OpenGL ndc.z处于[-1,1]之间，需要映射到[0-1]
                    if (SystemInfo.usesReversedZBuffer)
                    {
                        depth = maxZ;
                        depth = 1f - depth; // 处理平台差异：DX11/Metal/Vulkan 使用反向Z，1.0（近） → 0.0（远）
                    }
                    uvs[0] = new float2(minX, minY);
                    uvs[1] = new float2(minX, maxY);
                    uvs[2] = new float2(maxX, minY);
                    uvs[3] = new float2(maxX, maxY);
                }
            }

            //Debug.Log($"屏幕尺寸：{screenSize}, 深度图尺寸：{rtSize}, Mipmap尺寸：{mipmapSize}");


            var isOccluded = true;
            if (isInClipSpace)
            {
                // 计算出该点的深度，并经过线性处理
                var farClipPlane = Camera.farClipPlane;
                var nearClipPlane = Camera.nearClipPlane;
                float zBufferParamX = 1.0f - farClipPlane / nearClipPlane;
                float zBufferParamY = farClipPlane / nearClipPlane;
                float linear01Depth = 1.0f / (zBufferParamX * depth + zBufferParamY);


                // 保守剔除：新包围盒的四个顶点都被遮挡住了，才会被剔除
                for (var i = 0; i < uvs.Length; ++i)
                {
                    var uv = uvs[i];
                    // 先将uv映射到[0-1]之间，
                    uv = uv * 0.5f + 0.5f;
                    // ndc到屏幕坐标
                    var pixel = uv * screenSize;
                    if (pixel.x < 0 || pixel.y < 0 || pixel.x > screenSize.x || pixel.y > screenSize.y)
                    {
                        //Debug.Log($"像素点出界，screenSize:{screenSize}, pixel:{pixel}");
                        continue;
                    }


                    var pixelX = (int)pixel.x;
                    var pixelY = (int)pixel.y;


                    // 取出深度图中记录的该点深度值，计算遮挡关系
                    var bufferIndex = pixelY * screenSize.x + pixelX;
                    if (bufferIndex < 0 || bufferIndex >= depthDatasLength)
                    {
                        Debug.Log($"像素值索引出界，bufferIndex:{bufferIndex}, depthDatasLength:{depthDatasLength}");
                        continue;
                    }
                    var rtDepth = DepthDatas[bufferIndex];
                    isOccluded = linear01Depth > rtDepth;
                    //Debug.Log($"worldPos:{worldPos}, pixel:{pixel}，depth:{depth}, linear01Depth={linear01Depth}, rtDepth:{rtDepth}");

                    if (UseTestGoWorldPos || !isOccluded)
                        break; // 只要某个点没有被遮挡，则整个包围盒被判定不被遮挡
                }
            }




            // 更新对象和UI元素
            SetTestGoActive(!isOccluded);
            uv0 = uv0 * 0.5f + 0.5f;
            var _pixel = uv0 * screenSize;
            SetImage(_pixel, uvSize, isOccluded);
        }


        per_worldPos = worldPos;
        per_testGOBounds = bounds;
        rtUpdated = false;
        per_UseTestGoWorldPos = UseTestGoWorldPos;
    }
    //在Clip Space下，根据齐次坐标做Clipping操作
    bool IsInClipSpace(float4 clipSpacePosition)
    {
        if (isOpenGL)
            return clipSpacePosition.x > -clipSpacePosition.w && clipSpacePosition.x < clipSpacePosition.w &&
            clipSpacePosition.y > -clipSpacePosition.w && clipSpacePosition.y < clipSpacePosition.w &&
            clipSpacePosition.z > -clipSpacePosition.w && clipSpacePosition.z < clipSpacePosition.w;
        else
            return clipSpacePosition.x > -clipSpacePosition.w && clipSpacePosition.x < clipSpacePosition.w &&
            clipSpacePosition.y > -clipSpacePosition.w && clipSpacePosition.y < clipSpacePosition.w &&
            clipSpacePosition.z > 0 && clipSpacePosition.z < clipSpacePosition.w;
    }
    void SetTestGoActive(bool active)
    {
        var a = active ? 1f : 0.2f;
        TestGOMaterial.SetColor("_BaseColor", new Color(1f, 1f, 1f, a));
    }
    void SetImage(Vector2 pos, Vector2 size, bool isOccluded)
    {
        ImageRectTransform.anchoredPosition = pos;
        ImageRectTransform.sizeDelta = size;
        Text.text = $"覆盖像素\n{(int)size.x}x{(int)size.y}{(isOccluded? "\nHide" : "")}";
        Text.gameObject.SetActive(!UseTestGoWorldPos);
    }
    void WhenRTRequestDone(NativeArray<float> depthDatas, int depthDatasLength)
    {
        if (depthDatas.Length > 0)
        {
            if(!DepthDatas.IsCreated || DepthDatas.Length < depthDatasLength)
            {
                if(DepthDatas.IsCreated)
                    DepthDatas.Dispose();
                DepthDatas = new NativeArray<float>(depthDatasLength, Allocator.Persistent);
            }
            NativeArray<float>.Copy(depthDatas, DepthDatas, depthDatasLength);
        }
        this.depthDatasLength = depthDatas.Length;
        rtUpdated = true;
    }

    private void OnDestroy()
    {
        if(DepthDatas.IsCreated )
            DepthDatas.Dispose();
    }
}
