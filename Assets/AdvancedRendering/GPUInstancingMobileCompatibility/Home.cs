using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Home : MonoBehaviour
{
    [Header("实例数量")]
    public int instanceCount = 500;
    [Header("生成的实例区域")]
    public Vector3Int genInstanceRange = new Vector3Int(10, 10, 10);
    [Header("实例预制体模型")]
    public GameObject instancePrefab;
    [Header("通用材质（用于DrawMeshInstanced接口）")]
    public Material GeneralMaterial;
    [Header("强制使用DrawMeshInstanced接口")]
    public bool ForceDrawMeshInstanced;
    [Header("强制使用RenderMeshInstanced接口")]
    public bool ForceRenderMeshInstanced;
    [Header("强制使用DrawMeshInstancedProcedural接口")]
    public bool ForceDrawMeshInstancedProcedural;

    private PrintingInformation printingInfo;
    private bool isHUAWEI;
    private string apiInfo;
    private string error1;
    private string error2;
    private bool codeBranchToDrawMeshInstanced; // 根据是否强制指定api和华为手机，综合决定代码分支
    private bool TooManyInstances 
    { 
        get 
        {
            // DrawMeshInstanced接口功能在不同Unity版本中不同，
            // 比如在2021.3中输入的实例数量超过1023就无法渲染直接报错，需要自己写代码分割数组才行。
            // 但在2022.3中，超过1023也没关系，其接口内部会帮我们处理它。
            //
            // 其他Unity版本没有具体测试，所以这里的宏定义就形成了 UNITY_2022_3_OR_NEWER，
            //
#if UNITY_2022_3_OR_NEWER
            // 不会走分割实例数组的代码，由DrawMeshInstanced接口内部决定一次darwcall绘制多少个实例
            return false;
#else
            // 超过数量限制时，将分割数组，每个数组最多存1023个实例，
            // 渲染时将多次调用DrawMeshInstanced接口，遍历所有分割后的实例数组。
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
        // 只能强制指定一种api
        if (ForceDrawMeshInstanced && ForceRenderMeshInstanced)
            ForceDrawMeshInstanced = false;
        if(ForceRenderMeshInstanced && ForceDrawMeshInstancedProcedural)
            ForceRenderMeshInstanced = false;
        if (ForceDrawMeshInstanced && ForceDrawMeshInstancedProcedural)
            ForceDrawMeshInstanced = false;

        printingInfo = GetComponent<PrintingInformation>();
        isHUAWEI = printingInfo.isHUAWEI;
        codeBranchToDrawMeshInstanced = !ForceDrawMeshInstancedProcedural && (ForceDrawMeshInstanced || ForceRenderMeshInstanced || isHUAWEI);
        var instanceDatasInfo = TooManyInstances ? "[手动分割成多个实例数组]" : "";
        var drawMeshInstancedAPIInfo = ForceRenderMeshInstanced ? "RenderMeshInstanced" : "DrawMeshInstanced";
        apiInfo = codeBranchToDrawMeshInstanced ? $"{drawMeshInstancedAPIInfo}(...,{instanceCount}) {instanceDatasInfo}" : $"DrawMeshInstancedProcedural(...,{instanceCount})";
        printingInfo.SetError($"{apiInfo}\n运行正常，无错误。");

        try
        {
            genInstanceDatas(instanceCount); // 生成实例数据
            instanceMesh = instancePrefab.GetComponent<MeshFilter>().sharedMesh;
            DrawBounds.center = Camera.main.transform.position;
            DrawBounds.size = Vector3.one * 100000;

            if (!codeBranchToDrawMeshInstanced) // 华为手机之外的设备或者需要buffer存储实例数据的，正常创建buffer
            {
                instanceMaterial = instancePrefab.GetComponent<MeshRenderer>().sharedMaterial;
                instanceOutputBuffer = new ComputeBuffer(instanceCount, sizeof(float) * 16);
                instanceOutputBuffer.SetData(instanceDatas);
                mpb = new MaterialPropertyBlock();
                mpb.SetBuffer("IndirectShaderDataBuffer", instanceOutputBuffer); // 准备好GPU上的Buffer
            }
            else if(ForceRenderMeshInstanced)
            {
                // 渲染参数设置
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
            // 每帧执行实例化渲染操作
            // 在渲染时，针对不同设备做分支处理，调用不同的实例化接口
            if (codeBranchToDrawMeshInstanced)
            {
                if(TooManyInstances)
                {                        
                    // 实例数量太多时，多个调用DrawMeshInstanced接口，直到把所有实例全部渲染一遍为止。
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
        if (codeBranchToDrawMeshInstanced && TooManyInstances) // 实例数量太多时，可以分割开来形成多个数组，每个数组最多存1023个实例。
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
