using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    public class TerrainPreprocessingEditor : EditorWindow
    {
        static TerrainPreprocessingEditor window;

        [MenuItem("RenderVegetationIn1ms/植被预处理")]
        public static void OpenWindow()
        {
            window = GetWindow<TerrainPreprocessingEditor>("植被预处理");
            window.minSize = new Vector2(400, 800);
        }

        static string curScenePath;
        static SceneAsset curScene;
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
        int maxInstanceCountPerDatabase = 1000000;// 每个数据库达到最大容量时，约为400M
        int MaxLookAutoGenRawVegetationDatasCount = 10000;
        
        RawVegetationDatabase rawVegetationDatabase;

        Settings settings;
        int minBlockSize = 8;
        int nextBlockReductionFactor = 2;

        private void OnGUI()
        {
            var originColor = GUI.color;
            GUI.color = Color.green;
            EditorGUILayout.Space(10);
            if (GUILayout.Button("清除进度条", GUILayout.Height(30)))
                EditorUtility.ClearProgressBar();
            EditorGUILayout.Space(10);
            GUI.color = Color.white;
            GUILayout.Button("", GUILayout.Height(1));

            EditorGUILayout.Space(10);
            GUI.enabled = false;
            GUILayout.Button("随机生成原始植被数据", GUILayout.Height(30));
            GUI.enabled = true;

            GUI.color = Color.white;
            EditorGUILayout.Space(10);
            // 计算当前场景
            if (curScene == null || UnityEditor.SceneManagement.EditorSceneManager.GetActiveScene().path != curScenePath)
            {
                curScenePath = UnityEditor.SceneManagement.EditorSceneManager.GetActiveScene().path;
                curScene = AssetDatabase.LoadAssetAtPath<SceneAsset>(curScenePath);
            }
            curScene = EditorGUILayout.ObjectField("当前场景: ", curScene, typeof(SceneAsset), true) as SceneAsset;
            
            // 计算地形对象
            if (terrain == null)
                terrain = GetTerrainInScene();

            ModelPrototypeDatabase = EditorGUILayout.ObjectField("模型原型数据库: ", ModelPrototypeDatabase, typeof(ModelPrototypeDatabase), true) as ModelPrototypeDatabase;
            terrain = EditorGUILayout.ObjectField("地形对象: ", terrain, typeof(Terrain), true) as Terrain;

            generationInstancesCount = EditorGUILayout.IntField("预计生成实例总数: ", generationInstancesCount);
            generatingPossibility = EditorGUILayout.Vector3Field("生成概率(x:树，y:石头，z:草，x+y+z=1): ", generatingPossibility);
            // 设置​默认的生成概率
            if (generatingPossibility.x <= 0) generatingPossibility.x = 0.3f;
            if (generatingPossibility.y <= 0) generatingPossibility.y = 0.1f;
            if (generatingPossibility.z <= 0) generatingPossibility.z = 0.6f;
            if (GUILayout.Button("重新计算生成概率"))
            {
                var genPossibility = generatingPossibility.x + generatingPossibility.y + generatingPossibility.z;
                generatingPossibility.x /= genPossibility;
                generatingPossibility.y /= genPossibility;
                generatingPossibility.z /= genPossibility;
            }
            scaleRange_Tree = EditorGUILayout.Vector2Field("生成大小_树(x：最小缩放值，y: 最大缩放值): ", scaleRange_Tree);
            scaleRange_Stone = EditorGUILayout.Vector2Field("生成大小_石头(x：最小缩放值，y: 最大缩放值): ", scaleRange_Stone);
            scaleRange_Grass = EditorGUILayout.Vector2Field("生成大小_草(x：最小缩放值，y: 最大缩放值): ", scaleRange_Grass);

            // 设置生成实例总数默认最少1000个
            if (generationInstancesCount < 0) generationInstancesCount = 1000;
            // 设置树、石头和草默认最小尺寸
            if (scaleRange_Tree.x <= 0) scaleRange_Tree.x = 0.5f;
            if (scaleRange_Tree.y <= 0) scaleRange_Tree.y = 5f;
            if (scaleRange_Stone.x <= 0) scaleRange_Stone.x = 0.3f;
            if (scaleRange_Stone.y <= 0) scaleRange_Stone.y = 3f;
            if (scaleRange_Grass.x <= 0) scaleRange_Grass.x = 1f;
            if (scaleRange_Grass.y <= 0) scaleRange_Grass.y = 2f;

            vegetationDatabaseDirAsset = EditorGUILayout.ObjectField("存储文件夹路径: ", vegetationDatabaseDirAsset, typeof(DefaultAsset), allowSceneObjects: false) as DefaultAsset;
            if (vegetationDatabaseDirAsset != null) vegetationDatabaseDir = AssetDatabase.GetAssetPath(vegetationDatabaseDirAsset);
            else vegetationDatabaseDir = null;
            rawVegetationDatabaseFilename = EditorGUILayout.TextField("存储文件名称:", rawVegetationDatabaseFilename);


            maxInstanceCountPerDatabase = EditorGUILayout.IntField("单个数据库容量上限(个): ", maxInstanceCountPerDatabase);
            if (maxInstanceCountPerDatabase < 0) maxInstanceCountPerDatabase = 1000000;

            GUI.color = Color.green;
            if (GUILayout.Button("开始随机生成原始植被数据", GUILayout.Height(35)))
            {
                // 临时容器
                List<VegetationInstanceData> vids = null;
                // 保证临时容器成功生成
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
                        if (maxInstanceCountPerDatabase <= 0) break;
                    }
                }
                StartAutoGenRawVegetationDatabase(vids);
            }

            GUI.color = Color.white;
            EditorGUILayout.Space(10);
            GUILayout.Button("", GUILayout.Height(1));
            EditorGUILayout.Space(10);
            rawVegetationDatabase = EditorGUILayout.ObjectField("原始植被数据库: ", rawVegetationDatabase, typeof(RawVegetationDatabase), true) as RawVegetationDatabase;
            MaxLookAutoGenRawVegetationDatasCount = EditorGUILayout.IntField("最多查看植被实例的总数: ", MaxLookAutoGenRawVegetationDatasCount);
            if (MaxLookAutoGenRawVegetationDatasCount >= 0 && MaxLookAutoGenRawVegetationDatasCount < 10000) MaxLookAutoGenRawVegetationDatasCount = 10000;
            if (GUILayout.Button("查看生成的原始植被", GUILayout.Height(35)))
                LookAutoGenRawVegetationDatas();


            GUI.color = Color.white;
            EditorGUILayout.Space(10);
            GUILayout.Button("", GUILayout.Height(1));
            EditorGUILayout.Space(10);
            GUI.enabled = false;
            GUILayout.Button("生成区块树和植被数据库", GUILayout.Height(30));
            GUI.enabled = true;
            GUI.color = Color.white;
            settings = EditorGUILayout.ObjectField("Settings: ", settings, typeof(Settings), true) as Settings;
            terrain = EditorGUILayout.ObjectField("地形对象: ", terrain, typeof(Terrain), true) as Terrain;
            minBlockSize = EditorGUILayout.IntField("区块最小尺寸(2的幂)：", minBlockSize);
            if (minBlockSize <= 2) minBlockSize = 2;
            else minBlockSize = Tool.GetPowerOf2Value(minBlockSize);
            nextBlockReductionFactor = EditorGUILayout.IntField("下一层区块缩小倍数：", nextBlockReductionFactor);
            if (nextBlockReductionFactor <= 2) nextBlockReductionFactor = 2;
            else nextBlockReductionFactor = Tool.GetPowerOf2Value(nextBlockReductionFactor);
            vegetationDatabaseDirAsset = EditorGUILayout.ObjectField("存储文件夹路径: ", vegetationDatabaseDirAsset, typeof(DefaultAsset), allowSceneObjects: false) as DefaultAsset;
            GUI.color = Color.green;
            if (GUILayout.Button("开始生成区块树和植被数据库", GUILayout.Height(35)))
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
        /// 开始自动生成原始植被数据库
        /// </summary>
        /// <param name="vids">临时容器</param>
        private void StartAutoGenRawVegetationDatabase(List<VegetationInstanceData> vids)
        {
            if (terrain == null || ModelPrototypeDatabase == null) return; 
            if (string.IsNullOrEmpty(vegetationDatabaseDir) || string.IsNullOrEmpty(rawVegetationDatabaseFilename)) return;
            var dateTime = System.DateTime.Now;

            // 如果不存在的话创建文件夹
            // 将在存储路径下，再创建一个文件夹: RawVegetationDatabase
            var fileDir = System.IO.Path.Combine(vegetationDatabaseDir, "RawVegetationDatabase");
            System.IO.Directory.CreateDirectory(fileDir);
            // 清理之前残余的文件
            var dirinfo = new System.IO.DirectoryInfo(fileDir);
            foreach (var file in dirinfo.GetFiles())
                System.IO.File.Delete(file.FullName);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            // 生成原始植被数据库
            var fullFilename = fileDir;
            if (rawVegetationDatabaseFilename.EndsWith(rawVegetationDatabaseFileExtension))
                fullFilename = System.IO.Path.Combine(fullFilename, rawVegetationDatabaseFilename);
            else
                fullFilename = System.IO.Path.Combine(fullFilename, rawVegetationDatabaseFilename + rawVegetationDatabaseFileExtension);
            RawVegetationDatabase database = ScriptableObject.CreateInstance<RawVegetationDatabase>();
            AssetDatabase.CreateAsset(database, fullFilename);
            EditorUtility.SetDirty(database);
            AssetDatabase.SaveAssets();

            // 开始自动生成原始的植被数据
            if (ModelPrototypeDatabase.ModelPrototypeList.Count == 0)
            {
                Debug.LogError("[RenderVegetationIn1ms] 模型原型数据库中不存在任何模型原型，请先添加模型原型！");
                return;
            }
            List<ModelPrototype> treeModelPrototypeList = new List<ModelPrototype>();
            List<ModelPrototype> stoneModelPrototypeList = new List<ModelPrototype>();
            List<ModelPrototype> grassModelPrototypeList = new List<ModelPrototype>();
            List<ModelPrototype> otherModelPrototypeList = new List<ModelPrototype>();
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
                    case VegetationType.None:
                        otherModelPrototypeList.Add(modelPrototype);
                        break;
                }
            }
            if (treeModelPrototypeList.Count == 0 && grassModelPrototypeList.Count == 0 && stoneModelPrototypeList.Count == 0)
            {
                Debug.LogError("[RenderVegetationIn1ms] 模型原型数据库中不存在任何树、石头或草的模型原型，请调整模型原型数据中的模型原型的植被类型！");
                return;
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
                if (EditorUtility.DisplayCancelableProgressBar($"正在生成第 {i} 个实例 {(progress * 100).ToString("f2")}%", $"Tree: {tree}个，Stone: {stone}个，Grass: {grass}个", progress))
                    clancleButtonClicked();
                var x = Random.Range(0, terrain.terrainData.size.x) + terrain.transform.position.x;
                var z = Random.Range(0, terrain.terrainData.size.z) + terrain.transform.position.z;
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
                var vd = GetVegetationInstanceData(pos, scaleRange, modelPrototype, i);
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

            EditorUtility.DisplayProgressBar("原始植被数据已全部生成 100%", $"Tree: {tree}个，Stone: {stone}个，Grass: {grass}个", 1);


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

            Debug.Log($"[RenderVegetationIn1ms] 随机生成原始植被数据, Tree: {tree}个，Stone: {stone}个，Grass: {grass}个 耗时：{(System.DateTime.Now - dateTime).TotalSeconds}s");
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
            throw new System.Exception("[RenderVegetationIn1ms] 取消操作！");
        }


        /// <summary>
        /// 查看生成的原始植被
        /// </summary>
        private void LookAutoGenRawVegetationDatas()
        {
            if (rawVegetationDatabase == null || ModelPrototypeDatabase == null) return;
            GameObject lookGos = GameObject.Find("lookRawVegetationDatas");
            if (lookGos == null) lookGos = new GameObject("lookRawVegetationDatas");
            if(MaxLookAutoGenRawVegetationDatasCount > 0)
            {
                for (var i = 0; i < MaxLookAutoGenRawVegetationDatasCount && i < rawVegetationDatabase.RawTotal; i++)
                {
                    EditorUtility.DisplayProgressBar($"查看生成的原始植被 {i}/{MaxLookAutoGenRawVegetationDatasCount}", "正在生成中...", i / (float)MaxLookAutoGenRawVegetationDatasCount);
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
            else
            {
                rawVegetationDatabase.Each((index, total, vegetationData) => {
                    EditorUtility.DisplayProgressBar($"查看生成的原始植被 {index}/{total}", "正在生成中...", index / (float)total);
                    var modelPrototype = ModelPrototypeDatabase.ModelPrototypeList[vegetationData.ModelPrototypeID];
                    Tool.ExtractMatrix(vegetationData.matrix, out Vector3 pos, out Quaternion r, out Vector3 s);
                    var go = Instantiate(modelPrototype.PrefabObject);
                    go.transform.position = pos;
                    go.transform.rotation = r;
                    go.transform.localScale = s;
                    go.transform.parent = lookGos.transform;
                });
            }
            EditorUtility.ClearProgressBar();
        }


        /// <summary>
        /// 开始生成区块树和植被数据库
        /// </summary>
        private void StartGenBlockTreeAndVegetationDatabase()
        {
            if (settings == null || rawVegetationDatabase == null || terrain == null) return;
            if (string.IsNullOrEmpty(vegetationDatabaseDir)) return;
            var dateTime = System.DateTime.Now;

            // 清理之前残余的文件
            EditorUtility.DisplayProgressBar("生成区块树和植被数据库", $"清理之前残余的文件...", 0);
            var fileDir = System.IO.Path.Combine(vegetationDatabaseDir, settings.StorageFoldername);
            var streamingAssetsFileDir = System.IO.Path.Combine(Application.streamingAssetsPath, settings.StorageFoldername);
            Tool.DeleteDir(fileDir);
            Tool.DeleteDir(streamingAssetsFileDir);
            System.IO.Directory.CreateDirectory(fileDir);
            System.IO.Directory.CreateDirectory(streamingAssetsFileDir);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            EditorUtility.DisplayProgressBar("生成区块树和植被数据库", $"残余的文件清理完毕！", 1f);

            // 分割区块并生成区块树
            EditorUtility.DisplayProgressBar("生成区块树和植被数据库", $"分割区块并生成区块树...", 0);
            var blockTree = BlockTree.CreateBlockTree(terrain.terrainData.bounds, nextBlockReductionFactor, minBlockSize);
            EditorUtility.DisplayProgressBar("生成区块树和植被数据库", $"区块树已生成！", 1);

            // 逐一分配植被数据
            EditorUtility.DisplayProgressBar("生成区块树和植被数据库", $"逐一分配植被数据", 0);
            var notMatchCount = 0;
            var database = new VegetationDatabase();
            var oneMbytes = 1024 * 1024;
            var maxDataCountInSingleBlock = settings.MaxBytesInSingleBlock * oneMbytes / VegetationInstanceData.stride;
            var blockVegetationDatas = new BlockVegetationDatas[blockTree.AllBlockNodesCount];
            rawVegetationDatabase.Each((index, total, vid) =>
            {
                var progress = (index + 1) / (float)total;
                if (EditorUtility.DisplayCancelableProgressBar("生成区块树和植被数据库", $"正在分配植被数据... {progress * 100}%", progress))
                    clancleButtonClicked();
                if (!blockTree.RootBlockNode.MatchVegetationData(vid, blockVegetationDatas, maxDataCountInSingleBlock))
                {
                    blockTree.RootBlockNode.MatchVegetationDataByDistance(vid, blockVegetationDatas, maxDataCountInSingleBlock);
                    ++notMatchCount;
                }
            });
            Debug.Log($"[RenderVegetationIn1ms] 没有直接匹配的植被数量：{notMatchCount}，现已将它们分配到临近的区块中。");
            database.TotalDataCount = blockTree.RootBlockNode.TotalDataCount;
            database.NextInstanceID = database.TotalDataCount;
            database.BlockVegetationDatasDatabaseFilepath = settings.BlockVegetationDatasDatabaseFilename;
            database.BlockVegetationDatasDatabaseInfoFilepath = settings.BlockVegetationDatasDatabaseInfoFilename;
            database.AllBlockVegetationDatas = blockVegetationDatas;
            EditorUtility.DisplayProgressBar("生成区块树和植被数据库", $"所有植被数据已分配完毕！", 1);

            // 序列化区块树和植被数据库
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            var filepath = System.IO.Path.Combine(fileDir, settings.BlockTreeFilename);
            EditorUtility.DisplayProgressBar("生成区块树和植被数据库", $"序列化区块树...", 0f);
            blockTree.Write(filepath, (isdone, progress) =>
            {
                if(EditorUtility.DisplayCancelableProgressBar("生成区块树和植被数据库", $"序列化区块树...{progress * 100}%", progress))
                    clancleButtonClicked();
            });

            filepath = System.IO.Path.Combine(fileDir, settings.VegetationDatabaseFilename);
            EditorUtility.DisplayProgressBar("生成区块树和植被数据库", $"序列化植被数据库...", 0f);
            database.Write(filepath, (isdone, progress) =>
            {
                if(EditorUtility.DisplayCancelableProgressBar("生成区块树和植被数据库", $"序列化植被数据库...{progress * 100}%", progress))
                    clancleButtonClicked();
            });
            EditorUtility.DisplayProgressBar("生成区块树和植被数据库", $"区块树和植被数据库已经序列化完成！", 1);



            EditorUtility.DisplayProgressBar("生成区块树和植被数据库", $"Write To StreamingAssets...", 0);
            Tool.CopyDir(fileDir, streamingAssetsFileDir, true, copyingfilename=>
            {
                if(EditorUtility.DisplayCancelableProgressBar("生成区块树和植被数据库", $"Write To StreamingAssets...{copyingfilename}", Random.Range(0f, 1f)))
                    clancleButtonClicked();
            });
            EditorUtility.DisplayProgressBar("生成区块树和植被数据库", $"Write To StreamingAssets... Done!", 1);




            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            EditorUtility.ClearProgressBar();
            var dtime = System.DateTime.Now - dateTime;
            Debug.Log($"[RenderVegetationIn1ms] 生成区块树和植被数据库 耗时：{dtime.TotalSeconds}s, {dtime.TotalMinutes}m");
        }
    }
}
