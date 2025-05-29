using System.Collections;
using System.Collections.Generic;
using Unity.Collections;
using Unity.Mathematics;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using UnityEngine.UI;

/// <summary>
/// 这个类是专门用于遮挡剔除的Debug类
/// </summary>
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
    public static Hi_z_Debug Instance => instance;



    public RenderTexture RT;
    public GameObject TestGo;//用于运行时移动对象，方便观察结果
    public Image Image;//剔除结果会通过这个UI组件显示在屏幕上
    public Text Text;

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

    bool isDestroyed;
    private Transform TestGOTransform;
    private MeshRenderer TestGOMeshRenderer;
    private Material TestGOMaterial;
    private RectTransform ImageRectTransform;
    private Camera Camera;
    private bool isOpenGL;
    private void Awake()
    {
        OnDestroy();
        isDestroyed = false;
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
            var w = Screen.width >> i;
            var h = Screen.height >> i;
            rtMipmapSizes[i] = new Vector3Int(w, h, maxDepthDatasLength);
            maxDepthDatasLength += w * h;
        }
    }



    private Bounds per_testGOBounds;
    private bool rtUpdated;
    private float2[] uvs = new float2[4];
    private void Update()
    {
        if (RT != null)
            AsyncRTRequest();

        //实时计算当前TestGo对象的遮挡关系
        var bounds = TestGOMeshRenderer.bounds;
        if (depthDatasLength > 0 || bounds != per_testGOBounds)
        {
            var vpMatrix = GL.GetGPUProjectionMatrix(Camera.main.projectionMatrix, false) * Camera.main.worldToCameraMatrix;
            var screenSize = new int2(Screen.width, Screen.height);

            float4 clipSpace = default;
            float3 ndc = default;
            var depth = 0f;
            var isInClipSpace = false;
            float2 uvSize = new float2(15f, 15f);// 默认覆盖15x15像素区域，后面的计算会实时更新物体在屏幕上的像素区域
            int4 mipmapData = new int4(screenSize.xy, 0, 0);


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
                if (!isInClipSpace && IsInClipSpace(clipSpace))
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

                var maxPixelCount = math.max(math.abs(uvSize.x), math.abs(uvSize.y)); // 物体覆盖屏幕像素区域的最长一边
                // log2求出取值mipmap层级，clamp确保层级在最小和最大层级之间
                var mipmapLevel = math.clamp((int)math.log2(maxPixelCount), 0, math.min(rtMipmapCount - 1, minMipmapLevel)); 
                var _mipmapData = rtMipmapSizes[mipmapLevel];
                // 宽、长、数据偏移量，由于我们回读RT数据是将所有层级mipmap写入数组中，
                // 这里数据偏移量，用于定位对应mipmap层级的数据
                // 动态Mip层级选择，如果包围盒覆盖像素边长大于该Mip纹理尺寸，则选择更精细的Mip层级
                if (maxPixelCount > _mipmapData.x || maxPixelCount > _mipmapData.y)
                    _mipmapData = rtMipmapSizes[math.clamp(mipmapLevel - 1, 0, mipmapLevel - 1)];
                mipmapData = new int4(_mipmapData.x, _mipmapData.y, _mipmapData.z, mipmapLevel);

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

            //Debug.Log($"屏幕尺寸：{screenSize}, 深度图尺寸：{rtSize}, Mipmap尺寸：{mipmapSize}");

            var isInScreen = false;
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
                    var pixel = float2.zero;
                    //// ndc到屏幕坐标
                    //pixel = uv * screenSize;
                    //if (pixel.x < 0 || pixel.y < 0 || pixel.x > screenSize.x || pixel.y > screenSize.y)
                    //{
                    //    //Debug.Log($"像素点出界，screenSize:{screenSize}, pixel:{pixel}");
                    //    continue;
                    //}

                    isInScreen = true;
                    // 获取对应mipmap像素坐标
                    var mipmapSize = new int2(mipmapData.x, mipmapData.y);
                    var mipmapOffset = mipmapData.z;
                    pixel = uv * mipmapSize;
                    var pixelX = math.clamp((int)pixel.x, 0, mipmapSize.x - 1);
                    var pixelY = math.clamp((int)pixel.y, 0, mipmapSize.y - 1);

                    // 取出深度图中记录的该点深度值(对应mipmap则需要偏移量)，计算遮挡关系
                    var bufferIndex = pixelY * mipmapSize.x + pixelX + mipmapOffset;
                    if (bufferIndex < 0 || bufferIndex >= depthDatasLength)
                    {
                        Debug.Log($"像素值索引出界，bufferIndex:{bufferIndex}, depthDatasLength:{depthDatasLength}");
                        continue;
                    }
                    var rtDepth = depthDataNativeArray[bufferIndex];
                    isOccluded = linear01Depth > rtDepth;
                    //Debug.Log($"worldPos:{worldPos}, pixel:{pixel}，depth:{depth}, linear01Depth={linear01Depth}, rtDepth:{rtDepth}");

                    if (!isOccluded)
                        break; // 只要某个点没有被遮挡，则整个包围盒被判定不被遮挡
                }
            }

            // 更新对象和UI元素
            SetTestGoActive(!isOccluded);
            // 屏幕上坐标
            var uv0 = new float2((minX + maxX) /2f, (minY + maxY) / 2f) * 0.5f + 0.5f;
            var _pixel = uv0 * screenSize;
            SetImage(_pixel, uvSize, isOccluded, isInScreen, mipmapData.w);
        }

        per_testGOBounds = bounds;
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
                rtUpdated = true;
            });
        }
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
    void SetImage(Vector2 pos, Vector2 size, bool isOccluded,bool isInScreen, int mipmapLevel)
    {
        ImageRectTransform.anchoredPosition = pos;
        ImageRectTransform.sizeDelta = size;
        Text.text = $"Mip层级:{mipmapLevel}\n像素:{(int)size.x}x{(int)size.y}{(isOccluded? "\nHide" : "")}";
        ImageRectTransform.gameObject.SetActive(isInScreen);
    }

    private void OnDestroy()
    {
        isDestroyed = true;
        if (depthDataNativeArray.IsCreated )
            depthDataNativeArray.Dispose();
    }
}
