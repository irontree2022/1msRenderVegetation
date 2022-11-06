// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;

namespace Boxophobic.StyledGUI
{
    [CustomPropertyDrawer(typeof(StyledEnum))]
    public class StyledEnumAttributeDrawer : PropertyDrawer
    {
        StyledEnum a;

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            a = (StyledEnum)attribute;

            GUIStyle styleLabel = new GUIStyle(EditorStyles.label)
            {
                richText = true,
                alignment = TextAnchor.MiddleCenter,
                wordWrap = true
            };

            string[] enums = a.options.Split(char.Parse("_"));

            GUILayout.Space(a.top);

            int index = (int)property.intValue;

            index = EditorGUILayout.Popup(property.displayName, index, enums);

            // Debug Value
            //EditorGUILayout.LabelField(mask.ToString());

            property.intValue = index;

            GUI.enabled = true;

            GUILayout.Space(a.down);
        }

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return -2;
        }
    }
}
