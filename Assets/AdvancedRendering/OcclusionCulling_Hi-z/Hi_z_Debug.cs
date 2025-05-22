using System.Collections;
using System.Collections.Generic;
using Unity.Collections;
using Unity.Mathematics;
using UnityEditor;
using UnityEngine;
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
                    instance.GenMipmapSizes();
                }
            }
            else
            {
                if (instance)
                    Destroy(instance.gameObject);
            }
        }
    }




    public GameObject TestGo;//��������ʱ�ƶ����󣬷���۲���
    public Image Image;//�޳������ͨ�����UI�����ʾ����Ļ��
    public Text Text;
    public bool UseTestGoWorldPos;//�����ʾ����ʹ��TestGo������������꣨�������İ�Χ�У�ȥ�����ڵ���ϵ
    public static int rtMipmapCount;
    [Header("���㼶mipmap�ߴ��Լ�����ƫ����")]
    public Vector3Int[] rtMipmapSizes;
    [Header("�ܹ���mipmapȡֵ����С�㼶")]
    public int minMipmapLevel = 5;

    int maxDepthDatasLength;
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

    void GenMipmapSizes()
    {
        if (rtMipmapSizes == null || rtMipmapCount != rtMipmapSizes.Length)
            rtMipmapSizes = new Vector3Int[rtMipmapCount];
        maxDepthDatasLength = 0;
        // ����������mipmap�ߴ��Լ�ƫ������
        // ������������RT������mipmap����������ͳ�Ƴ���
        for (var i = 0; i < rtMipmapCount; ++i)
        {
            var w = Screen.width >> i;
            var h = Screen.height >> i;
            rtMipmapSizes[i] = new Vector3Int(w, h, maxDepthDatasLength);
            maxDepthDatasLength += w * h;
        }
        minMipmapLevel = rtMipmapCount - 1;
    }


    private OcclusionCulling_Hi_z culling_Hi_Z;
    private Bounds per_testGOBounds;
    private Vector3 per_worldPos;
    private bool rtUpdated;
    private bool per_UseTestGoWorldPos;
    private float2[] uvs = new float2[4];
    private void Update()
    {
        //RT�ض����ݵ��¼�ע��
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


        //ʵʱ���㵱ǰTestGo������ڵ���ϵ
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
            float2 uvSize = new float2(15f, 15f);// Ĭ�ϸ���15x15�������򣬺���ļ����ʵʱ������������Ļ�ϵ���������
            int4 mipmapData = new int4(screenSize.xy, 0, 0);

            // ����������ת�����ü��ռ�
            clipSpace = math.mul(vpMatrix, new float4(worldPos, 1f));
            isInClipSpace = IsInClipSpace(clipSpace);

            // ͸�ӳ���ת����NDC
            ndc = clipSpace.xyz / clipSpace.w;
            // ndc����Ļ����
            var uv0 = new float2(ndc.x, ndc.y);
            if (isInClipSpace)
            {
                uvs[0] = uv0;
                depth = ndc.z;
                if (isOpenGL)
                    depth = depth * 0.5f + 0.5f; // OpenGL ndc.z����[-1,1]֮�䣬��Ҫӳ�䵽[0-1]
                if (SystemInfo.usesReversedZBuffer)
                    depth = 1f - depth; // ����ƽ̨���죺DX11/Metal/Vulkan ʹ�÷���Z��1.0������ �� 0.0��Զ��
            }


            if (!UseTestGoWorldPos)
            {
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
                    if(!isInClipSpace && IsInClipSpace(clipSpace))
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
                    var mipmapLevel = math.clamp((int)math.log2(maxPixelCount), 0, math.min(rtMipmapCount - 1, minMipmapLevel)); // log2���ȡֵmipmap�㼶��clampȷ���㼶����С�����㼶֮��
                    var _mipmapData = rtMipmapSizes[mipmapLevel];
                    // ����������ƫ�������������ǻض�RT�����ǽ����в㼶mipmapд�������У�
                    // ��������ƫ���������ڶ�λ��Ӧmipmap�㼶������
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
                    // ndc����Ļ����
                    var pixel = uv * screenSize;
                    if (pixel.x < 0 || pixel.y < 0 || pixel.x > screenSize.x || pixel.y > screenSize.y)
                    {
                        //Debug.Log($"���ص���磬screenSize:{screenSize}, pixel:{pixel}");
                        continue;
                    }

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
                    var rtDepth = DepthDatas[bufferIndex];
                    isOccluded = linear01Depth > rtDepth;
                    //Debug.Log($"worldPos:{worldPos}, pixel:{pixel}��depth:{depth}, linear01Depth={linear01Depth}, rtDepth:{rtDepth}");

                    if (UseTestGoWorldPos || !isOccluded)
                        break; // ֻҪĳ����û�б��ڵ�����������Χ�б��ж������ڵ�
                }
            }




            // ���¶����UIԪ��
            SetTestGoActive(!isOccluded);
            uv0 = uv0 * 0.5f + 0.5f;
            var _pixel = uv0 * screenSize;
            SetImage(_pixel, uvSize, isOccluded, isInScreen, mipmapData.w);
        }


        per_worldPos = worldPos;
        per_testGOBounds = bounds;
        rtUpdated = false;
        per_UseTestGoWorldPos = UseTestGoWorldPos;
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
        Text.text = $"mipmap:{mipmapLevel}\n����:{(int)size.x}x{(int)size.y}{(isOccluded? "\nHide" : "")}";
        Text.gameObject.SetActive(!UseTestGoWorldPos);
        ImageRectTransform.gameObject.SetActive(isInScreen);
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
