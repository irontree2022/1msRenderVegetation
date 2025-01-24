using System.Collections;
using System.Collections.Generic;
using UnityEngine;





#if UNITY_EDITOR
using UnityEditor;
#endif

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// ������ֲ����ԭʼ����
    /// </summary>
    public struct VegetationData
    {
        public int modelID;
        public Vector3 position;
        public Quaternion rotation;
        public Vector3 scale;
    }



    public class TerrainTool : MonoBehaviour
    {
#if UNITY_EDITOR
        public Terrain Terrain;
        public TerrainData TerrainData;
        public ModelPrototypeDatabase ModelPrototypeDatabase;
        private List<VegetationData> vegetationDatas;
        private GameObject tempGO;

        public void OnInspectorGUI()
        {
            GUILayout.Space(10);
            GUILayout.Button("", GUILayout.Height(1f));
            GUILayout.Space(10);

            var needSave = ModelPrototypeDatabase != null;
            ModelPrototypeDatabase = EditorGUILayout.ObjectField("ģ��ԭ�Ϳ⣺", ModelPrototypeDatabase, typeof(ModelPrototypeDatabase), false) as ModelPrototypeDatabase;
            if (needSave != (ModelPrototypeDatabase != null))
                EditorUtility.SetDirty(this);
            GUILayout.Space(10);



            if (GUILayout.Button("��ȡԭʼ������", GUILayout.Height(35)))
            {
                getTreesData();
            }
            if (GUILayout.Button("��ȡԭʼ������", GUILayout.Height(35)))
            {
                getGrassData();
            }
            if (GUILayout.Button("�������Ͳ�������ȷ��", GUILayout.Height(35)))
            {
                testTreesAndGrassData();
            }

            if(GUILayout.Button("Clear", GUILayout.Height(35)))
            {
                if(tempGO != null) 
                    GameObject.DestroyImmediate(tempGO);
                if (vegetationDatas != null)
                    vegetationDatas.Clear();
                Debug.Log("[TerrainTool] ��ʱ����������ϣ�");
            }
        }

        private void getTreesData()
        {
            if(vegetationDatas== null)
                vegetationDatas = new List<VegetationData>();

            // Terrain�ϵ���������ģ��
            var treePrototypes = TerrainData.treePrototypes;
            // Terrain��������ʵ������
            var trees = TerrainData.treeInstances;
            // ����������ʵ��
            for (int i = 0; i < trees.Length; i++) 
            {
                var progress = ++i / (float)trees.Length;
                EditorUtility.DisplayProgressBar($"���ԭʼ������ {i} / {trees.Length}", $"���ڻ��ԭʼ�����ݣ�{(progress.ToString("f2"))}%", progress);

                var tree = trees[i];
                // prototypeIndexָ����TerrainData.treePrototypes�е�����
                var treePrototype = treePrototypes[tree.prototypeIndex];
                if (treePrototype.prefab == null) continue;

                var modelID = getModelID(treePrototype.prefab);
                if(modelID < 0)
                {
                    EditorUtility.ClearProgressBar();
                    throw new System.NullReferenceException("[TerrainTool] treeģ��ID��ȡʧ�ܣ�����ģ��ԭ�����ݿ⣬�����á�");
                }

                var position = new Vector3(
                    tree.position.x * TerrainData.size.x,
                    tree.position.y * TerrainData.size.y,
                    tree.position.z * TerrainData.size.z);
                var rXYZ = new Vector3(0f, Mathf.Rad2Deg * tree.rotation, 0f);
                var rotation = Quaternion.Euler(rXYZ);
                var scale = new Vector3(tree.widthScale, tree.heightScale, tree.widthScale);

                var vd = new VegetationData();
                vd.position = position;
                vd.scale = scale;
                vd.rotation = rotation;
                vd.modelID = modelID;

                vegetationDatas.Add(vd);
            }

            EditorUtility.ClearProgressBar();
            Debug.Log("[TerrainTool] �����ϵ�����ԭʼ���ݻ�ȡ��ϣ�");
        }
        private void getGrassData()
        {
            if (vegetationDatas == null)
                vegetationDatas = new List<VegetationData>();

            // Terrain�����вݵ�ģ��
            var detailPrototypes = TerrainData.detailPrototypes;
            float resolutionPerPatch = (float)TerrainData.detailResolutionPerPatch;
            float resolution = (float)TerrainData.detailResolution;
            var patchCount = Mathf.CeilToInt(resolution / resolutionPerPatch); // ����������ǰTerrain��patch����
            var detailObjectDensity = Terrain.detailObjectDensity; // �ݵ��ܶ�

            for (var layer = 0; layer < detailPrototypes.Length; ++layer)
            {
                var detailPrototype = detailPrototypes[layer];
                if (detailPrototype.prototype == null) continue;

                var prefab = detailPrototype.prototype;
                var modelID = getModelID(prefab);
                if (modelID < 0)
                {
                    EditorUtility.ClearProgressBar();
                    throw new System.NullReferenceException("[TerrainTool] treeģ��ID��ȡʧ�ܣ�����ģ��ԭ�����ݿ⣬�����á�");
                }

                var donePatchCount = 0;
                for (var x = 0; x < patchCount; ++x)
                {
                    for (var y = 0; y < patchCount; ++y)
                    {
                        var progress = ++donePatchCount / (float)(patchCount * patchCount);
                        EditorUtility.DisplayProgressBar($"��������� {layer} / {detailPrototypes.Length}", 
                            $"���ڱ�������ݣ�patch({x},{y}) | {donePatchCount}/ {(patchCount * patchCount)}", progress);

                        var instances = new VegetationData[0];
                        // �����ǻ�ȡ��ԭʼ���ݵĺ��ĺ���
                        // ��ʾÿ��patch�ڲ����ݵ��ܶȼ�������вݵ�ʵ������
                        var _length = Spawn(ref TerrainData,in modelID, x, y, layer, detailObjectDensity, ref instances);
                        if (_length > 0)
                            vegetationDatas.AddRange(instances);
                    }
                }

            }

            EditorUtility.ClearProgressBar();
            Debug.Log("[TerrainTool] �����ϵĲݵ�ԭʼ���ݻ�ȡ��ϣ�");
        }
        private int Spawn(ref TerrainData terrainData,in int modelID, int patchX, int patchZ, int layer, float density, ref VegetationData[] instances, bool enbaleLog = false)
        {
            var sw = new System.Diagnostics.Stopwatch();
            sw.Start();

            // �ӿ�ComputeDetailInstanceTransforms���԰�����ȡ����ǰpatch�����вݵ�ʵ������
            DetailInstanceTransform[] matrices = terrainData.ComputeDetailInstanceTransforms(patchX, patchZ, layer, density, out _);
            int length = matrices.Length;
            bool flag = instances.Length < length;
            if (flag)
                instances = new VegetationData[length];

            for (var i = 0; i < length; ++i)
            {
                ref DetailInstanceTransform matix = ref matrices[i];
                var pos = new Vector3(matix.posX, matix.posY, matix.posZ);
                var rXYZ = new Vector3(0f, Mathf.Rad2Deg * matix.rotationY, 0f);
                var rotation = Quaternion.Euler(rXYZ);
                var s = new Vector3(matix.scaleXZ, matix.scaleY, matix.scaleXZ);

                var vd = new VegetationData();
                vd.position = pos;
                vd.scale = s;
                vd.rotation = rotation;
                vd.modelID = modelID;
                instances[i] = vd;
            }

            sw.Stop();
            var ts = sw.Elapsed;

            if (enbaleLog)
                Debug.Log($"[TerrainTool] Spawn({patchX}, {patchZ}, layer: {layer}, density: {density}, ...) | ������{length}��ʵ�� | �ܺ�ʱ��{ts.TotalMilliseconds}ms");

            return length;
        }
        private int getModelID(GameObject prefab)
        {
            foreach(var model in ModelPrototypeDatabase.ModelPrototypeList)
            {
                if (model.PrefabObject == prefab)
                    return model.ID;
            }
            return -1;
        }


        private void testTreesAndGrassData()
        {
            var WorldPos = Vector3.zero;
            WorldPos = Terrain.GetPosition();
            if (tempGO == null)
                tempGO = new GameObject($"tempRoot");
            foreach(var vd in vegetationDatas)
            {
                var prefab = ModelPrototypeDatabase.ModelPrototypeList[vd.modelID].PrefabObject;
                var go = GameObject.Instantiate(prefab);
                go.transform.parent = tempGO.transform;
                go.transform.position = vd.position + WorldPos; // ��ȡ����ֲ��ʵ��������λ��Ҫ����Terrain��λ��
                go.transform.rotation = vd.rotation;
                go.transform.localScale = vd.scale;
            }

        }
#endif
    }

#if UNITY_EDITOR

    [CustomEditor(typeof(TerrainTool))]
    public class TerrainToolEditor : Editor
    {
        TerrainTool tool;
        private void OnEnable()
        {
            tool = target as TerrainTool;
            tool.Terrain = tool.GetComponent<Terrain>();
            tool.TerrainData = tool.Terrain.terrainData;
            EditorUtility.SetDirty(tool);
        }

        public override void OnInspectorGUI()
        {
            DrawDefaultInspectorGUI();
            GUILayout.Space(10);
            tool.OnInspectorGUI();
        }
        bool enableBaseDrawInspectorGUI = false;
        void DrawDefaultInspectorGUI()
        {
            enableBaseDrawInspectorGUI = EditorGUILayout.ToggleLeft("��ʾĬ�ϵ��������", enableBaseDrawInspectorGUI);
            if (enableBaseDrawInspectorGUI)
            {
                GUILayout.BeginHorizontal(GUI.skin.box);
                GUILayout.Space(10);
                GUILayout.BeginVertical();
                base.OnInspectorGUI();
                GUILayout.EndVertical();
                GUILayout.EndHorizontal();
            }
        }

    }

#endif
}

