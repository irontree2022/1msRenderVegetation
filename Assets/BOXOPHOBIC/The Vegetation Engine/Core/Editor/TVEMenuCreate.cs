// Cristian Pop - https://boxophobic.com/

using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

namespace TheVegetationEngine
{
    public class TVEMenuCreate
    {
        [MenuItem("GameObject/BOXOPHOBIC/The Vegetation Engine/Manager", false, 6)]
        static void CreateManager()
        {
            if (GameObject.Find("The Vegetation Engine") != null)
            {
                Debug.Log("[Warning][The Vegetation Engine] " + "The Vegetation Engine Manager is already set in your scene!");
                return;
            }

            GameObject manager = new GameObject();
            manager.AddComponent<TVEManager>();
            manager.name = "The Vegetation Engine";

            EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
        }

        [MenuItem("GameObject/BOXOPHOBIC/The Vegetation Engine/Element", false, 6)]
        static void CreateElement()
        {
            if (GameObject.Find("The Vegetation Engine") == null)
            {
                Debug.Log("[Warning][The Vegetation Engine] " + "The Vegetation Engine manager is missing from your scene. Make sure setup it up first!");
                return;
            }

            GameObject element = MonoBehaviour.Instantiate(Resources.Load<GameObject>("Internal Element"));

            var sceneCamera = SceneView.lastActiveSceneView.camera;

            if (sceneCamera != null)
            {
                element.transform.position = sceneCamera.ViewportToWorldPoint(new Vector3(0.5f, 0.5f, 10f));
            }
            else
            {
                element.transform.localPosition = Vector3.zero;
                element.transform.localEulerAngles = Vector3.zero;
                element.transform.localScale = Vector3.one;
            }

            if (Selection.activeGameObject != null)
            {
                element.transform.parent = Selection.activeGameObject.transform;
            }

            if (EditorSceneManager.IsPreviewSceneObject(element))
            {
                Debug.Log("[Warning][The Vegetation Engine] " + "Elements cannot be created inside prefabs");
            }
            else
            {
                element.name = "Element";
                element.AddComponent<TVEElement>();
            }

            Selection.activeGameObject = element;

            EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
        }

        //[MenuItem("GameObject/BOXOPHOBIC/The Vegetation Engine/Volume", false, 7)]
        //static void CreateVolume()
        //{
        //    if (GameObject.Find("The Vegetation Engine") == null)
        //    {
        //        Debug.Log("[Warning][The Vegetation Engine] " + "The Vegetation Engine manager is missing from your scene. Make sure setup it up first!");
        //        return;
        //    }

        //    GameObject volume = new GameObject();
        //    volume.AddComponent<TVEVolume>();
        //    volume.GetComponent<TVEVolume>().volumeGizmo = new Color(0.890f, 0.745f, 0.309f, 1f);
        //    volume.name = "Volume";

        //    var sceneCamera = SceneView.lastActiveSceneView.camera;

        //    if (sceneCamera != null)
        //    {
        //        volume.transform.position = sceneCamera.ViewportToWorldPoint(new Vector3(0.5f, 0.5f, 10f));
        //    }
        //    else
        //    {
        //        volume.transform.localPosition = Vector3.zero;
        //        volume.transform.localEulerAngles = Vector3.zero;
        //    }

        //    volume.transform.localScale = new Vector3(200, 50, 200);

        //    Selection.activeGameObject = volume;

        //    EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
        //}
    }
}
