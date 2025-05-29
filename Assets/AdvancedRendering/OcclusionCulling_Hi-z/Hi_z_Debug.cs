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
/// �������ר�������ڵ��޳���Debug��
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
    public GameObject TestGo;//��������ʱ�ƶ����󣬷���۲���
    public Image Image;//�޳������ͨ�����UI�����ʾ����Ļ��
    public Text Text;

    int rtMipmapCount;
    [Header("���㼶mipmap�ߴ��Լ�����ƫ����")]
    public Vector3Int[] rtMipmapSizes;
    [Header("�ܹ���mipmapȡֵ����С�㼶")]
    public int minMipmapLevel = 5;

    int maxDepthDatasLength;
    int depthDatasLength;
    // RT���㼶mipmap�����ݣ�����ȫ��д��������У�
    // ��0��mipmap�����ݷ�Χ��0~offset_1�� ��1��mipmap���ݷ�Χ���� offset_1~offset_2�� ��2��mipmap���ݷ�Χ����offset_2~offset_3...
    // ��ӦҪȡ��i��mipmap���ݣ�����Ҫƫ��offset_i����ȡ����ȷ������
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
        // ����������mipmap�ߴ��Լ�ƫ������
        // ������������RT������mipmap����������ͳ�Ƴ���
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

        //ʵʱ���㵱ǰTestGo������ڵ���ϵ
        var bounds = TestGOMeshRenderer.bounds;
        if (depthDatasLength > 0 || bounds != per_testGOBounds)
        {
            var vpMatrix = GL.GetGPUProjectionMatrix(Camera.main.projectionMatrix, false) * Camera.main.worldToCameraMatrix;
            var screenSize = new int2(Screen.width, Screen.height);

            float4 clipSpace = default;
            float3 ndc = default;
            var depth = 0f;
            var isInClipSpace = false;
            float2 uvSize = new float2(15f, 15f);// Ĭ�ϸ���15x15�������򣬺���ļ����ʵʱ������������Ļ�ϵ���������
            int4 mipmapData = new int4(screenSize.xy, 0, 0);


            //��Χ�е�8�������View Space����
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

            //NDC���µĵ�AABB��������
            isInClipSpace = false;
            float minX = 1, minY = 1, minZ = 1, maxX = -1, maxY = -1, maxZ = -1;
            for (int i = 0; i < 8; i++)
            {
                // ����������ת�����ü��ռ�
                clipSpace = math.mul(vpMatrix, boundVerts[i]);
                if (!isInClipSpace && IsInClipSpace(clipSpace))
                    isInClipSpace = true;

                // ͸�ӳ���ת����NDC
                ndc = clipSpace.xyz / clipSpace.w;
                //����ndc�µ��µ�AABB
                if (minX > ndc.x) minX = ndc.x;
                if (minY > ndc.y) minY = ndc.y;
                if (minZ > ndc.z) minZ = ndc.z;
                if (maxX < ndc.x) maxX = ndc.x;
                if (maxY < ndc.y) maxY = ndc.y;
                if (maxZ < ndc.z) maxZ = ndc.z;
            }

            if (isInClipSpace)
            {
                // ��������Ļ���ǵ�����
                var minUV = new float2(minX, minY);
                minUV = minUV * 0.5f + 0.5f;
                var maxUV = new float2(maxX, maxY);
                maxUV = maxUV * 0.5f + 0.5f;
                uvSize = new float2((maxUV.x - minUV.x) * screenSize.x, (maxUV.y - minUV.y) * screenSize.y);

                var maxPixelCount = math.max(math.abs(uvSize.x), math.abs(uvSize.y)); // ���帲����Ļ����������һ��
                // log2���ȡֵmipmap�㼶��clampȷ���㼶����С�����㼶֮��
                var mipmapLevel = math.clamp((int)math.log2(maxPixelCount), 0, math.min(rtMipmapCount - 1, minMipmapLevel)); 
                var _mipmapData = rtMipmapSizes[mipmapLevel];
                // ����������ƫ�������������ǻض�RT�����ǽ����в㼶mipmapд�������У�
                // ��������ƫ���������ڶ�λ��Ӧmipmap�㼶������
                // ��̬Mip�㼶ѡ�������Χ�и������ر߳����ڸ�Mip����ߴ磬��ѡ�����ϸ��Mip�㼶
                if (maxPixelCount > _mipmapData.x || maxPixelCount > _mipmapData.y)
                    _mipmapData = rtMipmapSizes[math.clamp(mipmapLevel - 1, 0, mipmapLevel - 1)];
                mipmapData = new int4(_mipmapData.x, _mipmapData.y, _mipmapData.z, mipmapLevel);

                // ���ֵӳ�䵽[0-1]֮��
                // ����ȡ�����������ֵ��OpenGLȡ��Сz��
                // ����ƽ̨Ĭ���Ƿ�ת�ģ�����ȡ���z���ٶȷ�ת��Ҳ����Сz�ˣ�
                depth = minZ;
                if (isOpenGL)
                    depth = minZ * 0.5f + 0.5f; // OpenGL ndc.z����[-1,1]֮�䣬��Ҫӳ�䵽[0-1]
                if (SystemInfo.usesReversedZBuffer)
                {
                    depth = maxZ;
                    depth = 1f - depth; // ����ƽ̨���죺DX11/Metal/Vulkan ʹ�÷���Z��1.0������ �� 0.0��Զ��
                }
                uvs[0] = new float2(minX, minY);
                uvs[1] = new float2(minX, maxY);
                uvs[2] = new float2(maxX, minY);
                uvs[3] = new float2(maxX, maxY);
            }

            //Debug.Log($"��Ļ�ߴ磺{screenSize}, ���ͼ�ߴ磺{rtSize}, Mipmap�ߴ磺{mipmapSize}");

            var isInScreen = false;
            var isOccluded = true;
            if (isInClipSpace)
            {
                // ������õ����ȣ����������Դ���
                var farClipPlane = Camera.farClipPlane;
                var nearClipPlane = Camera.nearClipPlane;
                float zBufferParamX = 1.0f - farClipPlane / nearClipPlane;
                float zBufferParamY = farClipPlane / nearClipPlane;
                float linear01Depth = 1.0f / (zBufferParamX * depth + zBufferParamY);

                // �����޳����°�Χ�е��ĸ����㶼���ڵ�ס�ˣ��Żᱻ�޳�
                for (var i = 0; i < uvs.Length; ++i)
                {
                    var uv = uvs[i];
                    // �Ƚ�uvӳ�䵽[0-1]֮�䣬
                    uv = uv * 0.5f + 0.5f;
                    var pixel = float2.zero;
                    //// ndc����Ļ����
                    //pixel = uv * screenSize;
                    //if (pixel.x < 0 || pixel.y < 0 || pixel.x > screenSize.x || pixel.y > screenSize.y)
                    //{
                    //    //Debug.Log($"���ص���磬screenSize:{screenSize}, pixel:{pixel}");
                    //    continue;
                    //}

                    isInScreen = true;
                    // ��ȡ��Ӧmipmap��������
                    var mipmapSize = new int2(mipmapData.x, mipmapData.y);
                    var mipmapOffset = mipmapData.z;
                    pixel = uv * mipmapSize;
                    var pixelX = math.clamp((int)pixel.x, 0, mipmapSize.x - 1);
                    var pixelY = math.clamp((int)pixel.y, 0, mipmapSize.y - 1);

                    // ȡ�����ͼ�м�¼�ĸõ����ֵ(��Ӧmipmap����Ҫƫ����)�������ڵ���ϵ
                    var bufferIndex = pixelY * mipmapSize.x + pixelX + mipmapOffset;
                    if (bufferIndex < 0 || bufferIndex >= depthDatasLength)
                    {
                        Debug.Log($"����ֵ�������磬bufferIndex:{bufferIndex}, depthDatasLength:{depthDatasLength}");
                        continue;
                    }
                    var rtDepth = depthDataNativeArray[bufferIndex];
                    isOccluded = linear01Depth > rtDepth;
                    //Debug.Log($"worldPos:{worldPos}, pixel:{pixel}��depth:{depth}, linear01Depth={linear01Depth}, rtDepth:{rtDepth}");

                    if (!isOccluded)
                        break; // ֻҪĳ����û�б��ڵ�����������Χ�б��ж������ڵ�
                }
            }

            // ���¶����UIԪ��
            SetTestGoActive(!isOccluded);
            // ��Ļ������
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
            // CPU�ض�RT��RT�ĸ��㼶mipmap���ݣ�����Ҫ��һ�ض����У�
            // ���ݵ�ǰmipmap�㼶��������������д������Ķ�Ӧλ����ȥ��
            // ��ʹ�������и��㼶mipmap����ʱ�������д���λ��ȥȡ��Ӧmipmap��ֵ
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
    //��Clip Space�£��������������Clipping����
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
        Text.text = $"Mip�㼶:{mipmapLevel}\n����:{(int)size.x}x{(int)size.y}{(isOccluded? "\nHide" : "")}";
        ImageRectTransform.gameObject.SetActive(isInScreen);
    }

    private void OnDestroy()
    {
        isDestroyed = true;
        if (depthDataNativeArray.IsCreated )
            depthDataNativeArray.Dispose();
    }
}
