using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Home : MonoBehaviour
{
    [Header("ʵ������")]
    public int instanceCount = 500;
    [Header("���ɵ�ʵ������")]
    public Vector3Int genInstanceRange = new Vector3Int(10, 10, 10);
    [Header("ʵ��Ԥ����ģ��")]
    public GameObject instancePrefab;
    [Header("ͨ�ò��ʣ�����DrawMeshInstanced�ӿڣ�")]
    public Material GeneralMaterial;
    [Header("ǿ��ʹ��DrawMeshInstanced�ӿ�")]
    public bool ForceDrawMeshInstanced;
    [Header("ǿ��ʹ��RenderMeshInstanced�ӿ�")]
    public bool ForceRenderMeshInstanced;
    [Header("ǿ��ʹ��DrawMeshInstancedProcedural�ӿ�")]
    public bool ForceDrawMeshInstancedProcedural;

    private PrintingInformation printingInfo;
    private bool isHUAWEI;
    private string apiInfo;
    private string error1;
    private string error2;
    private bool codeBranchToDrawMeshInstanced; // �����Ƿ�ǿ��ָ��api�ͻ�Ϊ�ֻ����ۺϾ��������֧
    private bool TooManyInstances 
    { 
        get 
        {
            // DrawMeshInstanced�ӿڹ����ڲ�ͬUnity�汾�в�ͬ��
            // ������2021.3�������ʵ����������1023���޷���Ⱦֱ�ӱ�����Ҫ�Լ�д����ָ�������С�
            // ����2022.3�У�����1023Ҳû��ϵ����ӿ��ڲ�������Ǵ�������
            //
            // ����Unity�汾û�о�����ԣ���������ĺ궨����γ��� UNITY_2022_3_OR_NEWER��
            //
#if UNITY_2022_3_OR_NEWER
            // �����߷ָ�ʵ������Ĵ��룬��DrawMeshInstanced�ӿ��ڲ�����һ��darwcall���ƶ��ٸ�ʵ��
            return false;
#else
            // ������������ʱ�����ָ����飬ÿ����������1023��ʵ����
            // ��Ⱦʱ����ε���DrawMeshInstanced�ӿڣ��������зָ���ʵ�����顣
            return instanceCount > 1023;
#endif
        }
    }

    private Matrix4x4[] instanceDatas;
    private Matrix4x4[][] drawInstanceDatas;
    private Mesh instanceMesh;
    private Material instanceMaterial;
    private Bounds DrawBounds = new Bounds();
    private RenderParams renderParams;
    private MaterialPropertyBlock mpb;
    private ComputeBuffer instanceOutputBuffer;
    void Start()
    {
        // ֻ��ǿ��ָ��һ��api
        if (ForceDrawMeshInstanced && ForceRenderMeshInstanced)
            ForceDrawMeshInstanced = false;
        if(ForceRenderMeshInstanced && ForceDrawMeshInstancedProcedural)
            ForceRenderMeshInstanced = false;
        if (ForceDrawMeshInstanced && ForceDrawMeshInstancedProcedural)
            ForceDrawMeshInstanced = false;

        printingInfo = GetComponent<PrintingInformation>();
        isHUAWEI = printingInfo.isHUAWEI;
        codeBranchToDrawMeshInstanced = !ForceDrawMeshInstancedProcedural && (ForceDrawMeshInstanced || ForceRenderMeshInstanced || isHUAWEI);
        var instanceDatasInfo = TooManyInstances ? "[�ֶ��ָ�ɶ��ʵ������]" : "";
        var drawMeshInstancedAPIInfo = ForceRenderMeshInstanced ? "RenderMeshInstanced" : "DrawMeshInstanced";
        apiInfo = codeBranchToDrawMeshInstanced ? $"{drawMeshInstancedAPIInfo}(...,{instanceCount}) {instanceDatasInfo}" : $"DrawMeshInstancedProcedural(...,{instanceCount})";
        printingInfo.SetError($"{apiInfo}\n�����������޴���");

        try
        {
            genInstanceDatas(instanceCount); // ����ʵ������
            instanceMesh = instancePrefab.GetComponent<MeshFilter>().sharedMesh;
            DrawBounds.center = Camera.main.transform.position;
            DrawBounds.size = Vector3.one * 100000;

            if (!codeBranchToDrawMeshInstanced) // ��Ϊ�ֻ�֮����豸������Ҫbuffer�洢ʵ�����ݵģ���������buffer
            {
                instanceMaterial = instancePrefab.GetComponent<MeshRenderer>().sharedMaterial;
                instanceOutputBuffer = new ComputeBuffer(instanceCount, sizeof(float) * 16);
                instanceOutputBuffer.SetData(instanceDatas);
                mpb = new MaterialPropertyBlock();
                mpb.SetBuffer("IndirectShaderDataBuffer", instanceOutputBuffer); // ׼����GPU�ϵ�Buffer
            }
            else if(ForceRenderMeshInstanced)
            {
                // ��Ⱦ��������
                renderParams = new RenderParams(GeneralMaterial);
                renderParams.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
                renderParams.receiveShadows = true;
            }
        }
        catch (System.Exception e)
        {
            error1 = $"{e.Message}\n{e.StackTrace}";
            printingInfo.SetError($"{apiInfo}\n{error1}");
        }
    }
    void Update()
    {
        try
        {
            // ÿִ֡��ʵ������Ⱦ����
            // ����Ⱦʱ����Բ�ͬ�豸����֧�������ò�ͬ��ʵ�����ӿ�
            if (codeBranchToDrawMeshInstanced)
            {
                if(TooManyInstances)
                {                        
                    // ʵ������̫��ʱ���������DrawMeshInstanced�ӿڣ�ֱ��������ʵ��ȫ����Ⱦһ��Ϊֹ��
                    if (ForceRenderMeshInstanced)
                        for (var i = 0; i < drawInstanceDatas.Length; ++i)
                            Graphics.RenderMeshInstanced(in renderParams, instanceMesh, 0, drawInstanceDatas[i]);
                    else
                        for (var i = 0; i < drawInstanceDatas.Length; ++i)
                            Graphics.DrawMeshInstanced(instanceMesh, 0, GeneralMaterial, drawInstanceDatas[i]);
                }
                else
                {
                    if(ForceRenderMeshInstanced)
                        Graphics.RenderMeshInstanced(in renderParams, instanceMesh, 0, instanceDatas);
                    else
                        Graphics.DrawMeshInstanced(instanceMesh, 0, GeneralMaterial, instanceDatas);
                }
            }
            else
                Graphics.DrawMeshInstancedProcedural(
                    instanceMesh,
                    0,
                    instanceMaterial,
                    DrawBounds,
                    instanceCount,
                    mpb);
        }
        catch (System.Exception e)
        {
            error2 = $"{e.Message}\n{e.StackTrace}";
            if (string.IsNullOrEmpty(error1))
                printingInfo.SetError($"{apiInfo}\n{error1}\n{error2}");
            else
                printingInfo.SetError($"{apiInfo}\n{error2}");
        }
    }
    private void genInstanceDatas(int instanceCount)
    {
        instanceDatas = new Matrix4x4[instanceCount];
        var instanceExtents = genInstanceRange / 2;
        var maxScale = 1f;
        for (var i = 0; i < instanceCount; i++)
        {
            var pos = new Vector3(
                UnityEngine.Random.Range(-instanceExtents.x, instanceExtents.x),
                UnityEngine.Random.Range(-instanceExtents.y, instanceExtents.y),
                UnityEngine.Random.Range(-instanceExtents.z, instanceExtents.z));
            var r = Quaternion.Euler(UnityEngine.Random.Range(0, 180), UnityEngine.Random.Range(0, 180), UnityEngine.Random.Range(0, 180));
            var s = new Vector3(UnityEngine.Random.Range(0.4f, maxScale), UnityEngine.Random.Range(0.4f, maxScale), UnityEngine.Random.Range(0.4f, maxScale));
            instanceDatas[i] = Matrix4x4.TRS(pos, r, s);
        }
        if (codeBranchToDrawMeshInstanced && TooManyInstances) // ʵ������̫��ʱ�����Էָ���γɶ�����飬ÿ����������1023��ʵ����
        {
            var arrayCount = instanceCount / 1023;
            if (instanceCount % 1023 != 0)
                arrayCount += 1;

            var num = 0;
            drawInstanceDatas = new Matrix4x4[arrayCount][];
            for(var i = 0; i < arrayCount; ++i)
            {
                var length = instanceCount - num;
                if (length > 1023)
                    length = 1023;
                drawInstanceDatas[i] = new Matrix4x4[length];
                Array.Copy(instanceDatas, num, drawInstanceDatas[i], 0, length);
                num += length;
            }
        }
    }
    private void OnDestroy()
    {
        instanceDatas = null;
        drawInstanceDatas = null;
        instanceOutputBuffer?.Release();
        if (mpb != null)
            mpb.Clear();
        mpb = null;
    }
}
