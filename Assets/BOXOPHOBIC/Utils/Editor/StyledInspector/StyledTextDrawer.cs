// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;

namespace Boxophobic.StyledGUI
{
    [CustomPropertyDrawer(typeof(StyledText))]
    public class StyledTextAttributeDrawer : PropertyDrawer
    {
        StyledText a;

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            a = (StyledText)attribute;

            GUIStyle styleLabel = new GUIStyle(EditorStyles.label)
            {
                richText = true,
                wordWrap = true
            };

            styleLabel.alignment = a.alignment;

            GUILayout.Space(a.top);

            if (a.disabled == true)
            {
                GUI.enabled = false;
            }

            GUILayout.Label(property.stringValue, styleLabel);

            GUI.enabled = true;

            GUILayout.Space(a.down);
        }

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return -2;
        }
    }
}

