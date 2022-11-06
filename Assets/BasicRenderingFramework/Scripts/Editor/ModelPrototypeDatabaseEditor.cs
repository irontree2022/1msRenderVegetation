using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// ģ��ԭ�����ݿ�༭������
    /// </summary>
    [CustomEditor(typeof(ModelPrototypeDatabase))]
    public class ModelPrototypeDatabaseEditor : Editor
    {
        public static ModelPrototypeDatabase database;
        private void OnEnable()
        {
            database = target as ModelPrototypeDatabase;
        }
        public override void OnInspectorGUI()
        {
            if (GUILayout.Button("�Զ����ģ��ԭ�͵�������Ҫ����", GUILayout.Height(40)))
                AutoHandleAll();
            GUILayout.Space(10);
            base.OnInspectorGUI();
        }


        private void AutoHandleAll()
        {
            var ModelPrototypeListCount = database.ModelPrototypeList.Count;
            for (var i = 0; i < ModelPrototypeListCount; i++)
            {
                EditorUtility.DisplayProgressBar("�Զ����ģ��ԭ������", "���ڴ��� ... (" + (i + 1) + "/" + database.ModelPrototypeList.Count + ")", (i + 1) / (float)database.ModelPrototypeList.Count);
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
        }
    }
}