using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimulationGPUDispatchThread: MonoBehaviour
{
    public GameObject root;
    public RectTransform DispatchThreadZPrefab;
    public UnityEngine.UI.Image ImagePrefab;
    [Header("开始模拟GPU调度线程")]
    public bool StartSimulationGPUDispatchThread;
    public float speed = 0.2f;
    [Header("正在模拟？")]
    public bool Simulating;
    [Header("模拟完成？")]
    public bool SimulationCompleted;
    public Vector3Int Dispatch = new Vector3Int(4, 3, 2);
    public Vector3Int numthreads = new Vector3Int(5, 4, 3);


    private float textWidth;
    private float textHeight;
    private float textZ;
    private float dtime;
    private Vector3Int curr_SV_DispatchThreadID = new Vector3Int(-1, -1, -1);
    private Vector3Int curr_SV_GroupID = new Vector3Int(-1, -1, -1);
    private Vector3Int curr_SV_GroupThreadID = new Vector3Int(-1, -1, -1);
    private int curr_SV_GroupIndex = -1;
    private Color[] SV_GroupIDColors = { 
        Color.white,
        Color.red,
        Color.yellow,
        Color.green
    };
    private Dictionary<Vector3, Color> GroupIDColorDic = new Dictionary<Vector3, Color>();
    private void Update()
    {
        if (!StartSimulationGPUDispatchThread)
        {
            SimulationCompleted = false;
            Simulating = false;
            dtime = 0;
            curr_SV_DispatchThreadID = new Vector3Int(-1, -1, -1);
            return;
        }
        if (SimulationCompleted) return;


        if (root == null || DispatchThreadZPrefab == null || ImagePrefab == null)
        {
            Debug.LogError("root、DispatchThreadZPrefab、ImagePrefab不能为null");
            return;
        }

        if (!Simulating)
        {
            for (var i = 0; i < root.transform.childCount; i++)
                GameObject.DestroyImmediate(root.transform.GetChild(i).gameObject);

            if (Dispatch.x <= 0) Dispatch.x = 4;
            if (Dispatch.y <= 0) Dispatch.y = 3;
            if (Dispatch.z <= 0) Dispatch.z = 2;
            if (numthreads.x <= 0) numthreads.x = 5;
            if (numthreads.y <= 0) numthreads.y = 4;
            if (numthreads.z <= 0) numthreads.z = 3;

            var rt = ImagePrefab.GetComponent<RectTransform>();
            textWidth = rt.sizeDelta.x;
            textHeight = rt.sizeDelta.y;
            textZ = rt.anchoredPosition3D.z;

            if(Dispatch.x > SV_GroupIDColors.Length)
            {
                var colors = new Color[Dispatch.x];
                for (var i = 0; i < Dispatch.x; i++)
                    colors[i] = SV_GroupIDColors[i % SV_GroupIDColors.Length];
                SV_GroupIDColors = colors;
            }
            bool increment = true;
            int colorIndex = 0;
            for (var k = 0; k < Dispatch.z; k++)
            {
                if(k % 2 == 0)
                {
                    increment = true;
                    colorIndex = 0;
                }
                else
                {
                    increment = false;
                    colorIndex = Dispatch.x - 1;
                }
                for (var j = 0; j < Dispatch.y; j++)
                {
                    for(var i = 0; i < Dispatch.x; i++)
                    {
                        if (increment) GroupIDColorDic[new Vector3(i, j, k)] = SV_GroupIDColors[colorIndex++];
                        else GroupIDColorDic[new Vector3(i, j, k)] = SV_GroupIDColors[colorIndex--];
                        if (colorIndex >= Dispatch.x)
                        {
                            colorIndex = Dispatch.x - 1;
                            increment = false;
                        }
                        if(colorIndex < 0)
                        {
                            colorIndex = 0;
                            increment = true;
                        }
                    }
                }
            }
        }

        Simulating = true;
        dtime += Time.deltaTime;
        if(dtime > speed)
        {
            dtime = 0;
            SimulationGPU();
        }

    }

    private void SimulationGPU()
    {
        if (curr_SV_DispatchThreadID == new Vector3Int(-1, -1, -1))
        {
            curr_SV_DispatchThreadID = Vector3Int.zero;
            curr_SV_GroupID = Vector3Int.zero;
            curr_SV_GroupThreadID = Vector3Int.zero;
            curr_SV_GroupIndex = 0;
        }
        else
        {
            var tx = curr_SV_DispatchThreadID.x;
            var ty = curr_SV_DispatchThreadID.y;
            var tz = curr_SV_DispatchThreadID.z;
            ++tx;
            if (tx >= Dispatch.x * numthreads.x)
            {
                tx = 0;
                ++ty;
            }
            if (ty >= Dispatch.y * numthreads.y)
            {
                ty = 0;
                ++tz;
            }
            if (tz >= Dispatch.z * numthreads.z)
            {
                Simulating = false;
                SimulationCompleted = true;
                return;
            }
            curr_SV_DispatchThreadID = new Vector3Int(tx, ty, tz);
            curr_SV_GroupID.x = tx / numthreads.x;
            curr_SV_GroupID.y = ty / numthreads.y;
            curr_SV_GroupID.z = tz / numthreads.z;
            curr_SV_GroupThreadID.x = tx % numthreads.x;
            curr_SV_GroupThreadID.y = ty % numthreads.y;
            curr_SV_GroupThreadID.z = tz % numthreads.z;
            curr_SV_GroupIndex = curr_SV_GroupThreadID.z * numthreads.x * numthreads.y + curr_SV_GroupThreadID.y * numthreads.y + curr_SV_GroupThreadID.x;
        }

        var posx = curr_SV_DispatchThreadID.x * textWidth;
        var posy = curr_SV_DispatchThreadID.y * textHeight;
        var posz = curr_SV_DispatchThreadID.z * textZ;

        if (curr_SV_DispatchThreadID.z >= root.transform.childCount)
        {
            var go = GameObject.Instantiate(DispatchThreadZPrefab);
            go.name = "SV_DispatchThreadIDZ: " + curr_SV_DispatchThreadID.z;
            go.transform.parent = root.transform;
            var gort = go.GetComponent<RectTransform>();
            gort.offsetMin = Vector3.zero;
            gort.offsetMax = Vector3.zero;
            gort.anchoredPosition3D = new Vector3(0, 0, posz);
        }

        var image = GameObject.Instantiate(ImagePrefab);
        image.transform.parent = root.transform.GetChild(curr_SV_DispatchThreadID.z);
        image.name = "SV_DispatchThreadID: " + curr_SV_DispatchThreadID;
        var text = image.transform.GetChild(0).GetComponent<UnityEngine.UI.Text>();
        text.text = $"SV_DispatchThreadID: {curr_SV_DispatchThreadID}\n" +
            $"SV_GroupID: {curr_SV_GroupID}\n" +
            $"SV_GroupThreadID: {curr_SV_GroupThreadID}\n" +
            $"SV_GroupIndex: {curr_SV_GroupIndex}\n";
        var rt = image.GetComponent<RectTransform>();
        rt.anchoredPosition3D = new Vector3(posx, -posy, 0);

        image.color = GroupIDColorDic[curr_SV_GroupID];
    }
}
