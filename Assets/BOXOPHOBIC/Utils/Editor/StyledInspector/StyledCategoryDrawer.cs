// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;
using Boxophobic.Constants;

namespace Boxophobic.StyledGUI
{
    [CustomPropertyDrawer(typeof(StyledCategory))]
    public class StyledCategoryAttributeDrawer : PropertyDrawer
    {
        StyledCategory a;

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            a = (StyledCategory)attribute;

            GUI.enabled = true;
            EditorGUI.indentLevel = 0;

            GUILayout.Space(a.top);
            StyledGUI.DrawInspectorCategory(a.category);
            GUILayout.Space(a.down);
        }

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return -2;
        }
    }
}
