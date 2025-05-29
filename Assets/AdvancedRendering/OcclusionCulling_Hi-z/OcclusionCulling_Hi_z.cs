using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.Universal;
using UnityEngine.Rendering;
using UnityEngine.UI;

public class OcclusionCulling_Hi_z : MonoBehaviour
{
    public Button SwitchButton;
    public bool EnabelHi_z_OcclusionCulling;
    public bool UseCPU;
    public OcclusionCulling_Hi_z__CPU hi_z__CPU;
    public OcclusionCulling_Hi_z__GPU hi_z__GPU;
    public Mesh grassMesh;
    public int subMeshIndex = 0;
    public Material grassMaterial;
    public Bounds grassBounds;
    Matrix4x4[] grassMatrixs;
    Bounds[] grassBoundses;

    public bool EnableRandomGenGrassInstances = true;
    public int GrassCountPerRaw = 300;//每行草的数量
    public ComputeShader compute;//剔除的ComputeShader
    public int m_grassCount;
    public Vector2 grassScaleRange = new Vector2(0.5f, 3f);


    [Space(10)]
    [Header("调试选项")]
    public bool EnableDebug;

    private Text SwitchText;
    private GenDepthMapController depthMapController;
    void Start()
    {
        SwitchText = SwitchButton.GetComponentInChildren<Text>();
        SwitchText.text = $"【{(UseCPU ? "CPU" : "GPU")}端】Hi-Z遮挡剔除";
        SwitchButton.onClick.AddListener(SwitchButtonClick);
        depthMapController = gameObject.GetComponent<GenDepthMapController>();
        InitGrassPosition();
        per_EnableRandomGenGrassInstances = EnableRandomGenGrassInstances;
    }

    void SwitchButtonClick()
    {
        UseCPU = !UseCPU;
        SwitchText.text = $"【{(UseCPU?"CPU":"GPU")}端】Hi-Z遮挡剔除";
    }

    bool per_EnableRandomGenGrassInstances;
    private void Update()
    {
        var needReGenGrassInstances = per_EnableRandomGenGrassInstances != EnableRandomGenGrassInstances;
        if (needReGenGrassInstances)
            InitGrassPosition();

        if (UseCPU)
        {
            if (hi_z__GPU != null)
            {
                depthMapController.AfterDepthMapGeneratedEvent -= hi_z__GPU.AfterDepthMapGenerated;
                depthMapController.DrawInstancesEvent -= hi_z__GPU.DrawInstances;
                depthMapController.DrawInstancesShadowEvent -= hi_z__GPU.DrawInstancesShadow;
                Destroy(hi_z__GPU); 
                hi_z__GPU = null;
            }
            if (hi_z__CPU == null)
                hi_z__CPU = gameObject.GetComponent<OcclusionCulling_Hi_z__CPU>();
            if (hi_z__CPU == null)
                hi_z__CPU = gameObject.AddComponent<OcclusionCulling_Hi_z__CPU>();

            if (needReGenGrassInstances || (!hi_z__CPU.EnableDraw && depthMapController.IsInitialized))
            {
                hi_z__CPU.Init(grassMesh, grassMaterial, grassBounds, grassMatrixs, grassBoundses);
                hi_z__CPU.EnableDraw = true;
            }

        }
        else
        {
            if(hi_z__CPU != null)
            {
                Destroy(hi_z__CPU);
                hi_z__CPU = null;
            }
            if (hi_z__GPU == null)
                hi_z__GPU = gameObject.GetComponent<OcclusionCulling_Hi_z__GPU>();
            if (hi_z__GPU == null)
                hi_z__GPU = gameObject.AddComponent<OcclusionCulling_Hi_z__GPU>();
            if (needReGenGrassInstances || (!hi_z__GPU.EnableDraw && depthMapController.IsInitialized))
            {
                hi_z__GPU.Init(compute, grassMesh, grassMaterial, grassBounds, grassMatrixs, grassBoundses);
                depthMapController.AfterDepthMapGeneratedEvent -= hi_z__GPU.AfterDepthMapGenerated;
                depthMapController.DrawInstancesEvent -= hi_z__GPU.DrawInstances;
                depthMapController.DrawInstancesShadowEvent -= hi_z__GPU.DrawInstancesShadow;
                depthMapController.AfterDepthMapGeneratedEvent += hi_z__GPU.AfterDepthMapGenerated;
                depthMapController.DrawInstancesEvent += hi_z__GPU.DrawInstances;
                depthMapController.DrawInstancesShadowEvent += hi_z__GPU.DrawInstancesShadow;
                hi_z__GPU.EnableDraw = true;
            }
        }


        if (depthMapController.IsMipmapGenCompleted)
        {
            if (hi_z__CPU != null)
            {
                hi_z__CPU.EnabelHi_z_OcclusionCulling = EnabelHi_z_OcclusionCulling;
                if (hi_z__CPU.RT == null)
                {
                    hi_z__CPU.RT = depthMapController.RT;
                    hi_z__CPU.GenMipmapSizes(depthMapController.MipmapCount);
                }
            }
            if (hi_z__GPU != null)
            {
                hi_z__GPU.EnabelHi_z_OcclusionCulling = EnabelHi_z_OcclusionCulling;
                if (hi_z__GPU.RT == null)
                {
                    hi_z__GPU.RT = depthMapController.RT;
                    hi_z__GPU.GenMipmapSizes(depthMapController.MipmapCount);
                }
            }

            if (EnableDebug)
            {
                if (!Hi_z_Debug.Enable)
                {
                    Hi_z_Debug.Enable = true;
                    Hi_z_Debug.Instance.RT = depthMapController.RT;
                    Hi_z_Debug.Instance.GenMipmapSizes(depthMapController.MipmapCount);
                }
            }
            else
            {
                if (Hi_z_Debug.Enable)
                    Hi_z_Debug.Enable = false;
            }
        }


        per_EnableRandomGenGrassInstances = EnableRandomGenGrassInstances;
    }


    //获取每个草的世界坐标矩阵
    void InitGrassPosition()
    {
        grassBounds = grassMesh.bounds;
        GameObject go = new GameObject();
        go.AddComponent<MeshFilter>().sharedMesh = grassMesh;
        MeshRenderer mr = go.AddComponent<MeshRenderer>();
        mr.sharedMaterial = grassMaterial;

        // 在场景种生成一些草的实例数据, 随机旋转和随机缩放
        m_grassCount = GrassCountPerRaw * GrassCountPerRaw;
        const int padding = 2;
        int width = (100 - padding * 2);
        int widthStart = -width / 2;
        float step = (float)width / GrassCountPerRaw;
        grassMatrixs = new Matrix4x4[m_grassCount];
        grassBoundses = new Bounds[m_grassCount];

        for (int i = 0; i < GrassCountPerRaw; i++)
        {
            for (int j = 0; j < GrassCountPerRaw; j++)
            {
                Vector2 xz = new Vector2(widthStart + step * i, widthStart + step * j);
                Vector3 position = new Vector3(xz.x, GetGroundHeight(xz), xz.y);
                var r = EnableRandomGenGrassInstances ? Quaternion.Euler(0, Random.Range(0, 360), 0) : Quaternion.identity;
                var s = EnableRandomGenGrassInstances ? Vector3.one * Random.Range(grassScaleRange.x, grassScaleRange.y) : Vector3.one;
                grassMatrixs[i * GrassCountPerRaw + j] = Matrix4x4.TRS(position, r, s);


                go.transform.position = position;
                go.transform.rotation = r;
                go.transform.localScale = s;
                grassBoundses[i * GrassCountPerRaw + j] = mr.bounds;
            }
        }

        Destroy(go);
    }
    //通过Raycast计算草的高度
    float GetGroundHeight(Vector2 xz)
    {
        RaycastHit hit;
        if (Physics.Raycast(new Vector3(xz.x, 10, xz.y), Vector3.down, out hit, 20))
        {
            return 10 - hit.distance;
        }
        return 0;
    }

}
