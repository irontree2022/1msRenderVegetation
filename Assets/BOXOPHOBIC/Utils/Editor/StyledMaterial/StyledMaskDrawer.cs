// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;
using System;

namespace Boxophobic.StyledGUI
{
    public class StyledMaskDrawer : MaterialPropertyDrawer
    {
        public string options = "";

        public float top = 0;
        public float down = 0;

        public StyledMaskDrawer(string options)
        {
            this.options = options;

            this.top = 0;
            this.down = 0;
        }

        public StyledMaskDrawer(string options, float top, float down)
        {
            this.options = options;

            this.top = top;
            this.down = down;
        }

        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor materialEditor)
        {
            GUIStyle styleLabel = new GUIStyle(EditorStyles.label)
            {
                richText = true,
                alignment = TextAnchor.MiddleCenter,
                wordWrap = true
            };

            string[] enums = options.Split(char.Parse("_"));

            GUILayout.Space(top);

            int mask = (int)prop.floatValue;

            mask = EditorGUILayout.MaskField(prop.displayName, mask, enums);

            if (mask < 0)
            {
                mask = -1;
            }

            // Debug Value
            //EditorGUILayout.LabelField(mask.ToString());

            prop.floatValue = mask;

            GUI.enabled = true;

            GUILayout.Space(down);
        }

        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
            return -2;
        }
    }
}
