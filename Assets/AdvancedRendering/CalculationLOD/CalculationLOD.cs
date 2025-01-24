using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using UnityEditor;
using UnityEngine;

public class CalculationLOD : MonoBehaviour
{
    public bool syncGameAndScene = true;
    public GameObject golod;
    public GameObject runtimeLODgo;
    public int lodLevelsCount = -1;
    public Vector4 lodLevels = default;
    public float currLOD = -1f;
    public int currLodLevel = -1;
    public float currLODGoOffsetX = -5f;

    /// <summary>
    /// ����LOD�������ռ��ֵ
    /// </summary>
    float GetRelativeHeight(
        Vector3 lodBoundsCenter, Vector3 cameraPos, float lodBias, 
        bool CameraOrthographic, float CameraOrthographicSize, float CameraFieldOfView,
        Vector3 lodGroupLossyScale, float lodGroupSize)
    {
        var scale = lodGroupLossyScale;
        float largestAxis = Mathf.Abs(scale.x);
        largestAxis = Mathf.Max(largestAxis, Mathf.Abs(scale.y));
        largestAxis = Mathf.Max(largestAxis, Mathf.Abs(scale.z));
        var size = lodGroupSize * largestAxis; // ����lod����ĳߴ�

        if (CameraOrthographic)
            // �������
            // ʹ����������ߴ統����Ļ�ߴ磬������ռ��
            return (size * 0.5F / CameraOrthographicSize) * lodBias; 

        // ͸�����
        // ʹ�����������Σ�������ռ��
        var distance = (lodBoundsCenter - cameraPos).magnitude;
        var halfAngle = Mathf.Tan(Mathf.Deg2Rad * CameraFieldOfView * 0.5F);
        var relativeHeight = size * 0.5F / (distance * halfAngle);
        return relativeHeight * lodBias;
    }
    /// <summary>
    /// ��LOD�����LOD����
    /// </summary>
    int CalculateLOD(Vector3 boxCenter, Vector3 lossyScale, float lodGroupSize, int lodLevelsCount, Vector4 lodLevels)
    {
        var MainCamera = Camera.main;

        // �����LOD�������ռ��ֵ
        currLOD = GetRelativeHeight(
            boxCenter, 
            MainCamera.transform.position,
            QualitySettings.lodBias,
            MainCamera.orthographic, MainCamera.orthographicSize, MainCamera.fieldOfView,
            lossyScale, lodGroupSize);

        // ��LOD�����LOD����
        for (int i = 0; i < lodLevelsCount; i++)
        {
            float lodLevel = 0;
            if (i == 0) lodLevel = lodLevels.x;
            else if (i == 1) lodLevel = lodLevels.y;
            else if (i == 2) lodLevel = lodLevels.z;
            else if (i == 3) lodLevel = lodLevels.w;
            if (currLOD >= lodLevel)
                return i;
        }
        return lodLevelsCount;
    }

    Bounds lodBounds = default;
    float lodsize = 1;
    /// <summary>
    /// ʵʱ����LOD��������LOD����
    /// </summary>
    private void GenLOD()
    {
        var lodg = golod.GetComponent<LODGroup>();
        lodBounds = RenderVegetationIn1ms.Tool.GetBounds(golod);
        lodLevels = RenderVegetationIn1ms.Tool.MakeLODLevelsToVector4(golod);
        lodLevelsCount = lodg.lodCount;
        lodsize = lodg.size;

        // ����LOD����
        var lodLevel = CalculateLOD(lodBounds.center, lodg.transform.lossyScale, lodsize, lodLevelsCount, lodLevels);
        if (runtimeLODgo && lodLevel >= lodLevelsCount)
        {
            DestroyImmediate(runtimeLODgo);
            currLodLevel = lodLevel;
        }
        // ���ɰ�����ӦLOD����Mesh��GameObject
        if (!runtimeLODgo || (currLodLevel != lodLevel && lodLevel < lodLevelsCount))
        {
            currLodLevel = lodLevel;
            if (lodLevel < lodLevelsCount)
            {
                if (runtimeLODgo) DestroyImmediate(runtimeLODgo);
                var lods = golod.GetComponent<LODGroup>().GetLODs();
                var lod = lods[lodLevel];
                runtimeLODgo = Instantiate(lod.renderers[0].gameObject, new Vector3(golod.transform.position.x + currLODGoOffsetX, golod.transform.position.y, golod.transform.position.z), golod.transform.rotation);
            }
        }
    }

#if UNITY_EDITOR
    private void OnDrawGizmos()
    {
        // ʵʱ����LOD��������LOD����
        GenLOD();

        // Scene��������ʾ������ʱ�����LOD����
        if (runtimeLODgo)
        {
            var bounds = RenderVegetationIn1ms.Tool.GetBounds(runtimeLODgo);
            Handles.color = Color.green;
            bounds.center = new Vector3(bounds.center.x - 0.5f, bounds.center.y, bounds.center.z);
            Handles.Label(bounds.center, $"Runtime\nLOD {currLodLevel}", EditorStyles.boldLabel);
        }

        if (!syncGameAndScene) return;
        // ���´���ʵ��Game������Scene�����ͬ��
        Camera cameraMain = Camera.main;
        var sceneView = SceneView.lastActiveSceneView;
        if (sceneView != null)
        {
            sceneView.orthographic = cameraMain.orthographic;
            sceneView.size = cameraMain.orthographicSize;
            sceneView.cameraSettings.nearClip = cameraMain.nearClipPlane;
            sceneView.cameraSettings.fieldOfView = cameraMain.fieldOfView;
            sceneView.pivot = cameraMain.transform.position +
                cameraMain.transform.forward * sceneView.cameraDistance;
            sceneView.rotation = cameraMain.transform.rotation;
        }
    }
#endif

}
