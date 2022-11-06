// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;

namespace Boxophobic.StyledGUI
{
    [CustomPropertyDrawer(typeof(StyledMask))]
    public class StyledMaskAttributeDrawer : PropertyDrawer
    {
        StyledMask a;

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            a = (StyledMask)attribute;

            GUIStyle styleLabel = new GUIStyle(EditorStyles.label)
            {
                richText = true,
                alignment = TextAnchor.MiddleCenter,
                wordWrap = true
            };

            string[] enums = a.options.Split(char.Parse("_"));

            GUILayout.Space(a.top);

            int mask = (int)property.intValue;

            mask = EditorGUILayout.MaskField(property.displayName, mask, enums);

            if (Mathf.Abs(mask) > 32000)
            {
                mask = -1;
            }

            // Debug Value
            //EditorGUILayout.LabelField(mask.ToString());

            property.intValue = mask;

            GUI.enabled = true;

            GUILayout.Space(a.down);
        }

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return -2;
        }
    }
}
