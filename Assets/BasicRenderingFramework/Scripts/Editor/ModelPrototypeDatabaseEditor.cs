using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Runtime.InteropServices;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// 模型原型数据库编辑器代码
    /// </summary>
    [CustomEditor(typeof(ModelPrototypeDatabase))]
    public class ModelPrototypeDatabaseEditor : Editor
    {
        public static ModelPrototypeDatabase database;
        private void OnEnable()
        {
            database = target as ModelPrototypeDatabase;
        }
        private void OnDisable()
        {
            EditorUtility.UnloadUnusedAssetsImmediate(true);
        }

        DefaultAsset dirAsset;
        public override void OnInspectorGUI()
        {
            dirAsset = EditorGUILayout.ObjectField("模型文件夹：", dirAsset, typeof(DefaultAsset), true) as DefaultAsset;
            if (GUILayout.Button("一键填充模型原型数据库", GUILayout.Height(40)))
                FillModelPrototypeDatabase();
            if (GUILayout.Button("自动填充模型原型的其他必要数据", GUILayout.Height(40)))
                AutoHandleAll();
            if (GUILayout.Button("在场景中查看所有模型", GUILayout.Height(40)))
                ShowAllModels();
            GUILayout.Space(10);
            base.OnInspectorGUI();
        }

        private void FillModelPrototypeDatabase()
        {
            if (dirAsset == null)
            {
                Debug.LogError($"[RenderVegetationIn1ms] 模型文件夹未赋值！");
                return;
            }
            var dir = AssetDatabase.GetAssetPath(dirAsset);
            if (string.IsNullOrEmpty(dir) || !System.IO.Directory.Exists(dir))
            {
                Debug.LogError($"[RenderVegetationIn1ms] 模型文件夹为空或者赋予给模型文件夹的资源不存在！");
                return;
            }
            var projectDir = Path.GetDirectoryName(Application.dataPath);
            projectDir = new DirectoryInfo(projectDir).FullName + "\\";
            var modelDic = new Dictionary<string, List<string>>();
            FindModel(new System.IO.DirectoryInfo(dir), modelDic);
            foreach (var kv in modelDic)
            {
                var key = kv.Key;
                var vegetationType = VegetationType.None;
                if (key == "tree") vegetationType = VegetationType.Tree;
                else if (key == "stone") vegetationType = VegetationType.Stone;
                else if (key == "grass") vegetationType = VegetationType.Grass;
                var models = kv.Value;
                foreach (var modelpath in models)
                {
                    if (database.ModelPrototypeList == null)
                        database.ModelPrototypeList = new List<ModelPrototype>();
                    var _modelpath = modelpath.Replace(projectDir, "");
                    var modelname = Path.GetFileNameWithoutExtension(_modelpath);
                    var prefab = AssetDatabase.LoadAssetAtPath<GameObject>(_modelpath);
                    var find = false;
                    foreach (var _p in database.ModelPrototypeList)
                    {
                        if (_p.PrefabObject == null) continue;
                        if (_p.PrefabName != modelname) continue;
                        var _path = AssetDatabase.GetAssetPath(_p.PrefabObject);
                        var path = AssetDatabase.GetAssetPath(prefab);
                        if (_path == path)
                        {
                            find = true;
                            break;
                        }
                    }
                    if (find) continue;
                    var id = database.ModelPrototypeList.Count;
                    GameObject impostorPrefab = null;
                    var impostorModelPath = $"{modelname}_Impostor.prefab";
                    impostorModelPath = Path.Combine(Path.GetDirectoryName(_modelpath), impostorModelPath);
                    if (System.IO.File.Exists(impostorModelPath))
                        impostorPrefab = AssetDatabase.LoadAssetAtPath<GameObject>(impostorModelPath);
                    var prototype = new ModelPrototype(id, prefab);
                    prototype.Type = vegetationType;
                    prototype.PrefabImpostor = impostorPrefab;
                    database.ModelPrototypeList.Add(prototype);
                    EditorUtility.UnloadUnusedAssetsImmediate(true);
                }
            }

            EditorUtility.SetDirty(database);
            AssetDatabase.SaveAssetIfDirty(database);
            EditorUtility.ClearProgressBar();
            EditorUtility.UnloadUnusedAssetsImmediate(true);
        }
        private void FindModel(System.IO.DirectoryInfo dirInfo, Dictionary<string, List<string>> modelDic)
        {
            foreach (var _dirInfo in dirInfo.GetDirectories())
                FindModel(_dirInfo, modelDic);
            foreach (var fileInfo in dirInfo.GetFiles())
            {
                var ext = fileInfo.Extension;
                if (ext != ".prefab") continue;
                if (fileInfo.Name.EndsWith("_Impostor.prefab")) continue;
                string key = null;
                var dir = Path.GetDirectoryName(fileInfo.FullName);
                dir = Path.GetDirectoryName(dir);
                if (dir.EndsWith("Tree")) key = "tree";
                else if (dir.EndsWith("stone")) key = "stone";
                else if (dir.EndsWith("grass")) key = "grass";
                if (string.IsNullOrEmpty(key)) key = "none";
                if (modelDic.TryGetValue(key, out List<string> models))
                {
                    models.Add(fileInfo.FullName);
                }
                else
                {
                    models = new List<string>() { fileInfo.FullName };
                    modelDic[key] = models;
                }
            }
        }

        private void AutoHandleAll()
        {
            var ModelPrototypeListCount = database.ModelPrototypeList.Count;
            for (var i = 0; i < ModelPrototypeListCount; i++)
            {
                EditorUtility.DisplayProgressBar("自动填充模型原型数据", "正在处理 ... (" + (i + 1) + "/" + database.ModelPrototypeList.Count + ")", (i + 1) / (float)database.ModelPrototypeList.Count);
                var ModelPrototype = database.ModelPrototypeList[i];
                ModelPrototype.ID = i;
                if (ModelPrototype.PrefabObject)
                    ModelPrototype.PrefabName = ModelPrototype.PrefabObject.name;
                ModelPrototype.receiveShadows = true;
                ModelPrototype.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
                ModelPrototype.enableRenderImpostor = ModelPrototype.Type != VegetationType.Grass;
                ModelPrototype.Bounds = Tool.GetBounds(ModelPrototype.PrefabObject);
                ModelPrototype.ResetLODLevels();
            }
            EditorUtility.SetDirty(database);
            AssetDatabase.SaveAssetIfDirty(database);
            EditorUtility.ClearProgressBar();
            EditorUtility.UnloadUnusedAssetsImmediate(true);
        }

        private void ShowAllModels()
        {
            var allGOs = GameObject.Find("AllModels");
            if (allGOs == null)
                allGOs = new GameObject("AllModels");
            foreach (var p in database.ModelPrototypeList)
            {
                if (p.PrefabObject == null) continue;
                var x = Random.Range(0, database.ModelPrototypeList.Count);
                var z = Random.Range(0, database.ModelPrototypeList.Count);
                var pos = new Vector3(x, 0, z);
                var go = Instantiate(p.PrefabObject, allGOs.transform);
                go.transform.position = pos;
            }
        }

    }
}