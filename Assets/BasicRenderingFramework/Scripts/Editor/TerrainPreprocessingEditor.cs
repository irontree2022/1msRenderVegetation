using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    public class TerrainPreprocessingEditor : EditorWindow
    {
        static TerrainPreprocessingEditor window;

        [MenuItem("RenderVegetationIn1ms/ֲ��Ԥ����")]
        public static void OpenWindow()
        {
            window = GetWindow<TerrainPreprocessingEditor>("ֲ��Ԥ����");
            window.minSize = new Vector2(400, 800);
        }

        static string curScenePath;
        static SceneAsset curScene;
        Settings settings;
        ModelPrototypeDatabase ModelPrototypeDatabase;
        Terrain terrain;
        int generationInstancesCount = 2000000;
        Vector3 generatingPossibility = new Vector3(0.05f, 0.02f, 0.9f);
        Vector2 scaleRange_Tree = new Vector2(1f, 3f);
        Vector2 scaleRange_Stone = new Vector2(3f, 8f);
        Vector2 scaleRange_Grass = new Vector2(5f, 10f);
        DefaultAsset vegetationDatabaseDirAsset = null;
        string vegetationDatabaseDir = null;
        string rawVegetationDatabaseFilename = "RawVegetationDatabase";
        string rawVegetationDatabaseFileExtension = ".asset";
        int maxInstanceCountPerDatabase = 1000000;// ÿ�����ݿ�ﵽ�������ʱ��ԼΪ400M
        RawVegetationDatabase rawVegetationDatabase;
        int MaxLookAutoGenRawVegetationDatasCount = 10000;

        int minBlockSize = 8;
        int nextBlockReductionFactor = 2;

        private void OnGUI()
        {
            var originColor = GUI.color;
            GUI.color = Color.green;
            EditorGUILayout.Space(10);
            if (GUILayout.Button("���������", GUILayout.Height(30)))
                EditorUtility.ClearProgressBar();
            EditorGUILayout.Space(10);
            GUI.color = Color.white;
            GUILayout.Button("", GUILayout.Height(1));

            EditorGUILayout.Space(10);
            GUI.enabled = false;
            GUILayout.Button("�������ԭʼֲ������", GUILayout.Height(30));
            GUI.enabled = true;

            GUI.color = Color.white;
            EditorGUILayout.Space(10);
            if (curScene == null || UnityEditor.SceneManagement.EditorSceneManager.GetActiveScene().path != curScenePath)
            {
                curScenePath = UnityEditor.SceneManagement.EditorSceneManager.GetActiveScene().path;
                curScene = AssetDatabase.LoadAssetAtPath<SceneAsset>(curScenePath);
            }
            curScene = EditorGUILayout.ObjectField("��ǰ����: ", curScene, typeof(SceneAsset), true) as SceneAsset;
            if (terrain == null)
                terrain = GetTerrainInScene();

            ModelPrototypeDatabase = EditorGUILayout.ObjectField("ģ��ԭ�����ݿ�: ", ModelPrototypeDatabase, typeof(ModelPrototypeDatabase), true) as ModelPrototypeDatabase;
            terrain = EditorGUILayout.ObjectField("���ζ���: ", terrain, typeof(Terrain), true) as Terrain;

            generationInstancesCount = EditorGUILayout.IntField("Ԥ������ʵ������: ", generationInstancesCount);
            generatingPossibility = EditorGUILayout.Vector3Field("���ɸ���(x:����y:ʯͷ��z:�ݣ�x+y+z=1): ", generatingPossibility);
            if (generatingPossibility.x <= 0) generatingPossibility.x = 0.3f;
            if (generatingPossibility.y <= 0) generatingPossibility.y = 0.1f;
            if (generatingPossibility.z <= 0) generatingPossibility.z = 0.6f;
            if (GUILayout.Button("���¼������ɸ���"))
            {
                var genPossibility = generatingPossibility.x + generatingPossibility.y + generatingPossibility.z;
                generatingPossibility.x /= genPossibility;
                generatingPossibility.y /= genPossibility;
                generatingPossibility.z /= genPossibility;
            }
            scaleRange_Tree = EditorGUILayout.Vector2Field("���ɴ�С_��(x����С����ֵ��y: �������ֵ): ", scaleRange_Tree);
            scaleRange_Stone = EditorGUILayout.Vector2Field("���ɴ�С_ʯͷ(x����С����ֵ��y: �������ֵ): ", scaleRange_Stone);
            scaleRange_Grass = EditorGUILayout.Vector2Field("���ɴ�С_��(x����С����ֵ��y: �������ֵ): ", scaleRange_Grass);

            if (generationInstancesCount < 0) generationInstancesCount = 1000;

            if (scaleRange_Tree.x <= 0) scaleRange_Tree.x = 0.5f;
            if (scaleRange_Tree.y <= 0) scaleRange_Tree.y = 5f;
            if (scaleRange_Stone.x <= 0) scaleRange_Stone.x = 0.3f;
            if (scaleRange_Stone.y <= 0) scaleRange_Stone.y = 3f;
            if (scaleRange_Grass.x <= 0) scaleRange_Grass.x = 1f;
            if (scaleRange_Grass.y <= 0) scaleRange_Grass.y = 2f;

            vegetationDatabaseDirAsset = EditorGUILayout.ObjectField("�洢�ļ���·��: ", vegetationDatabaseDirAsset, typeof(DefaultAsset), allowSceneObjects: false) as DefaultAsset;
            if (vegetationDatabaseDirAsset != null) vegetationDatabaseDir = AssetDatabase.GetAssetPath(vegetationDatabaseDirAsset);
            else vegetationDatabaseDir = null;
            rawVegetationDatabaseFilename = EditorGUILayout.TextField("�洢�ļ�����:", rawVegetationDatabaseFilename);


            maxInstanceCountPerDatabase = EditorGUILayout.IntField("�������ݿ���������(��): ", maxInstanceCountPerDatabase);
            if (maxInstanceCountPerDatabase < 0) maxInstanceCountPerDatabase = 1000000;
            List<VegetationInstanceData> vids = null;
            try
            {
                vids = new List<VegetationInstanceData>(maxInstanceCountPerDatabase);
            }
            catch
            {
                while (true)
                {
                    --maxInstanceCountPerDatabase;
                    try
                    {
                        vids = new List<VegetationInstanceData>(maxInstanceCountPerDatabase);
                        break;
                    }
                    catch { };
                    if(maxInstanceCountPerDatabase <= 0) break;
                }
            }
            GUI.color = Color.green;
            if (GUILayout.Button("��ʼ�������ԭʼֲ������", GUILayout.Height(35)))
                StartAutoGenRawVegetationDatabase(vids);


            GUI.color = Color.white;
            EditorGUILayout.Space(10);
            GUILayout.Button("", GUILayout.Height(1));
            EditorGUILayout.Space(10);
            rawVegetationDatabase = EditorGUILayout.ObjectField("ԭʼֲ�����ݿ�: ", rawVegetationDatabase, typeof(RawVegetationDatabase), true) as RawVegetationDatabase;
            MaxLookAutoGenRawVegetationDatasCount = EditorGUILayout.IntField("���鿴ֲ��ʵ��������: ", MaxLookAutoGenRawVegetationDatasCount);
            if (MaxLookAutoGenRawVegetationDatasCount <= 0) MaxLookAutoGenRawVegetationDatasCount = 10000;
            if (GUILayout.Button("�鿴���ɵ�ԭʼֲ��", GUILayout.Height(35)))
                LookAutoGenRawVegetationDatas();


            GUI.color = Color.white;
            EditorGUILayout.Space(10);
            GUILayout.Button("", GUILayout.Height(1));
            EditorGUILayout.Space(10);
            GUI.enabled = false;
            GUILayout.Button("������������ֲ�����ݿ�", GUILayout.Height(30));
            GUI.enabled = true;
            GUI.color = Color.white;
            settings = EditorGUILayout.ObjectField("Settings: ", settings, typeof(Settings), true) as Settings;
            terrain = EditorGUILayout.ObjectField("���ζ���: ", terrain, typeof(Terrain), true) as Terrain;
            minBlockSize = EditorGUILayout.IntField("������С�ߴ�(2����)��", minBlockSize);
            if (minBlockSize <= 2) minBlockSize = 2;
            else minBlockSize = Tool.GetPowerOf2Value(minBlockSize);
            nextBlockReductionFactor = EditorGUILayout.IntField("��һ��������С������", nextBlockReductionFactor);
            if (nextBlockReductionFactor <= 2) nextBlockReductionFactor = 2;
            else nextBlockReductionFactor = Tool.GetPowerOf2Value(nextBlockReductionFactor);
            vegetationDatabaseDirAsset = EditorGUILayout.ObjectField("�洢�ļ���·��: ", vegetationDatabaseDirAsset, typeof(DefaultAsset), allowSceneObjects: false) as DefaultAsset;
            GUI.color = Color.green;
            if (GUILayout.Button("��ʼ������������ֲ�����ݿ�", GUILayout.Height(35)))
                StartGenBlockTreeAndVegetationDatabase();


            EditorGUILayout.Space(20);
        }
        private Terrain GetTerrainInScene()
        {
            GameObject[] rootGOs = UnityEditor.SceneManagement.EditorSceneManager.GetActiveScene().GetRootGameObjects();
            for(var i =0; i < rootGOs.Length; i++)
            {
                var rootgo = rootGOs[i];
                if (rootgo == null) continue;
                var terrain = rootgo.GetComponent<Terrain>();
                if(terrain == null) continue;
                return terrain;
            }
            return null;
        }
        



        private Dictionary<int, GameObject> modelPrototypeDic = new Dictionary<int, GameObject>();
        /// <summary>
        /// ��ʼ�Զ�����ԭʼֲ�����ݿ�
        /// </summary>
        /// <param name="vids">��ʱ����</param>
        private void StartAutoGenRawVegetationDatabase(List<VegetationInstanceData> vids)
        {
            if (terrain == null || ModelPrototypeDatabase == null) return; 
            if (string.IsNullOrEmpty(vegetationDatabaseDir) || string.IsNullOrEmpty(rawVegetationDatabaseFilename)) return;
            var dateTime = System.DateTime.Now;

            // �����ļ�����������ڵĻ�
            var fileDir = System.IO.Path.Combine(vegetationDatabaseDir, "RawVegetationDatabase");
            System.IO.Directory.CreateDirectory(fileDir);
            // ����֮ǰ������ļ�
            var dirinfo = new System.IO.DirectoryInfo(fileDir);
            foreach (var file in dirinfo.GetFiles())
                System.IO.File.Delete(file.FullName);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            // ����ԭʼֲ�����ݿ�
            var fullFilename = fileDir;
            if (rawVegetationDatabaseFilename.EndsWith(rawVegetationDatabaseFileExtension))
                fullFilename = System.IO.Path.Combine(fullFilename, rawVegetationDatabaseFilename);
            else
                fullFilename = System.IO.Path.Combine(fullFilename, rawVegetationDatabaseFilename + rawVegetationDatabaseFileExtension);
            RawVegetationDatabase database = ScriptableObject.CreateInstance<RawVegetationDatabase>();
            AssetDatabase.CreateAsset(database, fullFilename);
            EditorUtility.SetDirty(database);
            AssetDatabase.SaveAssets();

            // ��ʼ�Զ�����ԭʼ��ֲ������
            List<ModelPrototype> treeModelPrototypeList = new List<ModelPrototype>();
            List<ModelPrototype> stoneModelPrototypeList = new List<ModelPrototype>();
            List<ModelPrototype> grassModelPrototypeList = new List<ModelPrototype>();
            for (var _i = 0; _i < ModelPrototypeDatabase.ModelPrototypeList.Count; _i++)
            {
                var modelPrototype = ModelPrototypeDatabase.ModelPrototypeList[_i];
                switch (modelPrototype.Type)
                {
                    case VegetationType.Tree:
                        treeModelPrototypeList.Add(modelPrototype);
                        break;
                    case VegetationType.Stone:
                        stoneModelPrototypeList.Add(modelPrototype);
                        break;
                    case VegetationType.Grass:
                        grassModelPrototypeList.Add(modelPrototype);
                        break;
                }
            }
            
            var fixedTime = System.DateTime.Parse("2022/10/18 23:56:59");
            var dtime = System.DateTime.Now - fixedTime;
            Random.InitState((int)dtime.TotalMilliseconds);

            vids.Clear();
            rawVegetationDatabase = database;
            database.RawTotal = 0;
            database.RawTreeTotal = 0;
            database.RawStoneTotal = 0;
            database.RawGrassTotal = 0;
            database.rawVegetationInstanceDatabases = new List<RawInstances>();
            database.rawVegetationInstanceDatabases.Clear();
            EditorUtility.SetDirty(database);
            AssetDatabase.SaveAssets();


            var tree = 0;
            var stone = 0;
            var grass = 0;
            var rawInstancesIndex = 0;
            float genPossibility = 0;
            genPossibility += generatingPossibility.x;
            genPossibility += generatingPossibility.y;
            genPossibility += generatingPossibility.z;

            for (var i = 0; i < generationInstancesCount; i++)
            {
                var progress = (float)(i + 1) / generationInstancesCount;
                if (EditorUtility.DisplayCancelableProgressBar($"�������ɵ� {i} ��ʵ�� {(progress * 100).ToString("f2")}%", $"Tree: {tree}����Stone: {stone}����Grass: {grass}��", progress))
                    clancleButtonClicked();
                var x = Random.Range(0, terrain.terrainData.size.x);
                var z = Random.Range(0, terrain.terrainData.size.z);
                var randome = Random.Range(0, 100);
                var treep = generatingPossibility.x / genPossibility;
                var stonep = generatingPossibility.y / genPossibility + treep;
                ModelPrototype modelPrototype = null;
                Vector2 scaleRange = default;
                if (randome < treep * 100)
                {
                    if(treeModelPrototypeList.Count == 0)
                    {
                        --i;
                        continue;
                    }

                    modelPrototype = treeModelPrototypeList[Random.Range(0, treeModelPrototypeList.Count)];
                    ++tree;
                    scaleRange = scaleRange_Tree;
                }
                else if(randome < stonep * 100)
                {
                    if (stoneModelPrototypeList.Count == 0)
                    {
                        --i;
                        continue;
                    }

                    modelPrototype = stoneModelPrototypeList[Random.Range(0, stoneModelPrototypeList.Count)];
                    ++stone;
                    scaleRange = scaleRange_Stone;
                }
                else
                {
                    if (grassModelPrototypeList.Count == 0)
                    {
                        --i;
                        continue;
                    }

                    modelPrototype = grassModelPrototypeList[Random.Range(0, grassModelPrototypeList.Count)];
                    ++grass;
                    scaleRange = scaleRange_Grass;
                }

                var pos = new Vector3(x, 0, z);
                var vd = GetVegetationInstanceData(pos, scaleRange_Tree, modelPrototype, i);
                vids.Add(vd);

                if (vids.Count >= maxInstanceCountPerDatabase)
                {
                    database.RawTotal += vids.Count;
                    database.rawVegetationInstanceDatabases.Add(CreateRawInstances(fileDir, rawInstancesIndex, vids));
                    vids.Clear();
                    ++rawInstancesIndex;
                }
            }

            if (vids.Count > 0)
            {
                database.RawTotal += vids.Count;
                database.rawVegetationInstanceDatabases.Add(CreateRawInstances(fileDir, rawInstancesIndex, vids));
                vids.Clear();
            }

            EditorUtility.DisplayProgressBar("ԭʼֲ��������ȫ������ 100%", $"Tree: {tree}����Stone: {stone}����Grass: {grass}��", 1);


            foreach (var kv in modelPrototypeDic)
                if (kv.Value != null)
                    GameObject.DestroyImmediate(kv.Value);
            modelPrototypeDic.Clear();

            database.RawTreeTotal = tree;
            database.RawStoneTotal = stone;
            database.RawGrassTotal = grass;
            EditorUtility.SetDirty(database);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            EditorUtility.ClearProgressBar();

            Debug.Log($"[RenderVegetationIn1ms] �������ԭʼֲ������, Tree: {tree}����Stone: {stone}����Grass: {grass}�� ��ʱ��{(System.DateTime.Now - dateTime).TotalSeconds}s");
        }
        private VegetationInstanceData GetVegetationInstanceData(Vector3 pos, Vector2 scaleRange, ModelPrototype modelPrototype, int NextInstanceID)
        {
            GetRandomRotationScaleValue(pos, scaleRange, out Vector3 p, out Vector3 _r, out Vector3 s);
            var r = Quaternion.Euler(_r);
            var mat = Matrix4x4.TRS(p, r, s);
            GameObject go = null;
            if (!modelPrototypeDic.TryGetValue(modelPrototype.ID, out go))
            {
                go = GameObject.Instantiate(modelPrototype.PrefabObject);
                modelPrototypeDic[modelPrototype.ID] = go;
            }
            go.transform.position = p;
            go.transform.rotation = r;
            go.transform.localScale = s;
            var bounds = Tool.GetBounds(go);

            var vd = new VegetationInstanceData();
            vd.matrix = mat;
            vd.center = bounds.center;
            vd.extents = bounds.extents;
            vd.InstanceID = NextInstanceID;
            vd.ModelPrototypeID = modelPrototype.ID;
            return vd;
        }
        private void GetRandomRotationScaleValue(Vector3 pos, Vector2 scaleRange, out Vector3 p, out Vector3 r, out Vector3 s)
        {
            p = getPositionInTerrain(pos);
            r = new Vector3(0, Random.Range(0f, 360f), 0);
            s = Vector3.one * Random.Range(scaleRange.x, scaleRange.y);
        }
        private Vector3 getPositionInTerrain(Vector3 pos)
        {
            var _pos = pos;
            if (pos.y < terrain.terrainData.size.y)
                pos.y += terrain.terrainData.size.y;
            Ray ray = new Ray(pos, -Vector3.up);
            Vector3 targetPos = Vector3.zero;
            if (Physics.Raycast(ray, out RaycastHit result)) targetPos = result.point;
            else targetPos = _pos;
            return targetPos;
        }
        private RawInstances CreateRawInstances(string rawInstancesDir, int rawInstancesIndex, List<VegetationInstanceData> rawDatas)
        {
            var databasePath = rawInstancesDir + "/RawInstances_" + rawInstancesIndex + ".asset";
            RawInstances rawInstances = ScriptableObject.CreateInstance<RawInstances>();
            AssetDatabase.CreateAsset(rawInstances, databasePath);
            if (rawInstances.database == null)
                rawInstances.database = new List<VegetationInstanceData>(rawDatas.Count);
            rawInstances.database.AddRange(rawDatas);
            EditorUtility.SetDirty(rawInstances);
            AssetDatabase.SaveAssets();
            return rawInstances;
        }
        private void clancleButtonClicked()
        {
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            EditorUtility.ClearProgressBar();
            throw new System.Exception("[RenderVegetationIn1ms] ȡ��������");
        }

        private void LookAutoGenRawVegetationDatas()
        {
            if (rawVegetationDatabase == null || ModelPrototypeDatabase == null) return;
            GameObject lookGos = GameObject.Find("lookRawVegetationDatas");
            if (lookGos == null) lookGos = new GameObject("lookRawVegetationDatas");
            for(var i = 0; i < MaxLookAutoGenRawVegetationDatasCount; i++)
            {
                var rawVegetationDatabaseIndex = Random.Range(0, rawVegetationDatabase.rawVegetationInstanceDatabases.Count);
                var datas = rawVegetationDatabase.rawVegetationInstanceDatabases[rawVegetationDatabaseIndex];
                var rawVegetationIndex = Random.Range(0, datas.database.Count);
                var rawVegetationData = datas.database[rawVegetationIndex];
                var modelPrototype = ModelPrototypeDatabase.ModelPrototypeList[rawVegetationData.ModelPrototypeID];
                Tool.ExtractMatrix(rawVegetationData.matrix, out Vector3 pos, out Quaternion r, out Vector3 s);
                var go = Instantiate(modelPrototype.PrefabObject);
                go.transform.position = pos;
                go.transform.rotation = r;
                go.transform.localScale = s;
                go.transform.parent = lookGos.transform;
            }
        }


        /// <summary>
        /// ��ʼ������������ֲ�����ݿ�
        /// </summary>
        private void StartGenBlockTreeAndVegetationDatabase()
        {
            if (settings == null || rawVegetationDatabase == null || terrain == null) return;
            if (string.IsNullOrEmpty(vegetationDatabaseDir)) return;
            var dateTime = System.DateTime.Now;

            // ����֮ǰ������ļ�
            EditorUtility.DisplayProgressBar("������������ֲ�����ݿ�", $"����֮ǰ������ļ�...", 0);
            var fileDir = System.IO.Path.Combine(vegetationDatabaseDir, settings.StorageFoldername);
            var streamingAssetsFileDir = System.IO.Path.Combine(Application.streamingAssetsPath, settings.StorageFoldername);
            Tool.DeleteDir(fileDir);
            Tool.DeleteDir(streamingAssetsFileDir);
            System.IO.Directory.CreateDirectory(fileDir);
            System.IO.Directory.CreateDirectory(streamingAssetsFileDir);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            EditorUtility.DisplayProgressBar("������������ֲ�����ݿ�", $"������ļ�������ϣ�", 1f);

            // �ָ����鲢����������
            EditorUtility.DisplayProgressBar("������������ֲ�����ݿ�", $"�ָ����鲢����������...", 0);
            var blockTree = BlockTree.CreateBlockTree(terrain.terrainData.bounds, nextBlockReductionFactor, minBlockSize);
            EditorUtility.DisplayProgressBar("������������ֲ�����ݿ�", $"�����������ɣ�", 1);

            // ��һ����ֲ������
            EditorUtility.DisplayProgressBar("������������ֲ�����ݿ�", $"��һ����ֲ������", 0);
            var notMatchCount = 0;
            var database = new VegetationDatabase();
            var oneMbytes = 1024 * 1024;
            var maxDataCountInSingleBlock = settings.MaxBytesInSingleBlock * oneMbytes / VegetationInstanceData.stride;
            var blockVegetationDatas = new BlockVegetationDatas[blockTree.AllBlockNodesCount];
            rawVegetationDatabase.Each((index, total, vid) =>
            {
                var progress = (index + 1) / (float)total;
                if (EditorUtility.DisplayCancelableProgressBar("������������ֲ�����ݿ�", $"���ڷ���ֲ������... {progress * 100}%", progress))
                    clancleButtonClicked();
                if (!blockTree.RootBlockNode.MatchVegetationData(vid, blockVegetationDatas, maxDataCountInSingleBlock))
                {
                    blockTree.RootBlockNode.MatchVegetationDataByDistance(vid, blockVegetationDatas, maxDataCountInSingleBlock);
                    ++notMatchCount;
                }
            });
            Debug.Log($"[RenderVegetationIn1ms] û��ֱ��ƥ���ֲ��������{notMatchCount}�����ѽ����Ƿ��䵽�ٽ��������С�");
            database.TotalDataCount = blockTree.RootBlockNode.TotalDataCount;
            database.NextInstanceID = database.TotalDataCount;
            database.BlockVegetationDatasDatabaseFilepath = settings.BlockVegetationDatasDatabaseFilename;
            database.BlockVegetationDatasDatabaseInfoFilepath = settings.BlockVegetationDatasDatabaseInfoFilename;
            database.AllBlockVegetationDatas = blockVegetationDatas;
            EditorUtility.DisplayProgressBar("������������ֲ�����ݿ�", $"����ֲ�������ѷ�����ϣ�", 1);

            // ���л���������ֲ�����ݿ�
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            var filepath = System.IO.Path.Combine(fileDir, settings.BlockTreeFilename);
            EditorUtility.DisplayProgressBar("������������ֲ�����ݿ�", $"���л�������...", 0f);
            blockTree.Write(filepath, (isdone, progress) =>
            {
                if(EditorUtility.DisplayCancelableProgressBar("������������ֲ�����ݿ�", $"���л�������...{progress * 100}%", progress))
                    clancleButtonClicked();
            });

            filepath = System.IO.Path.Combine(fileDir, settings.VegetationDatabaseFilename);
            EditorUtility.DisplayProgressBar("������������ֲ�����ݿ�", $"���л�ֲ�����ݿ�...", 0f);
            database.Write(filepath, (isdone, progress) =>
            {
                if(EditorUtility.DisplayCancelableProgressBar("������������ֲ�����ݿ�", $"���л�ֲ�����ݿ�...{progress * 100}%", progress))
                    clancleButtonClicked();
            });
            EditorUtility.DisplayProgressBar("������������ֲ�����ݿ�", $"��������ֲ�����ݿ��Ѿ����л���ɣ�", 1);



            EditorUtility.DisplayProgressBar("������������ֲ�����ݿ�", $"Write To StreamingAssets...", 0);
            Tool.CopyDir(fileDir, streamingAssetsFileDir, true, copyingfilename=>
            {
                if(EditorUtility.DisplayCancelableProgressBar("������������ֲ�����ݿ�", $"Write To StreamingAssets...{copyingfilename}", Random.Range(0f, 1f)))
                    clancleButtonClicked();
            });
            EditorUtility.DisplayProgressBar("������������ֲ�����ݿ�", $"Write To StreamingAssets... Done!", 1);




            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            EditorUtility.ClearProgressBar();
            var dtime = System.DateTime.Now - dateTime;
            Debug.Log($"[RenderVegetationIn1ms] ������������ֲ�����ݿ� ��ʱ��{dtime.TotalSeconds}s, {dtime.TotalMinutes}m");
        }
    }
}
