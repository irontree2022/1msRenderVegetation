// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;
using System;

namespace Boxophobic.StyledGUI
{
    public class StyledCategoryDrawer : MaterialPropertyDrawer
    {
        public string category;
        public float top;
        public float down;

        public StyledCategoryDrawer(string category)
        {
            this.category = category;
            this.top = 10;
            this.down = 10;
        }

        public StyledCategoryDrawer(string category, float top, float down)
        {
            this.category = category;
            this.top = top;
            this.down = down;
        }

        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor materiaEditor)
        {
            if (prop.floatValue < 0)
            {
                GUI.enabled = true;
                EditorGUI.indentLevel = 0;
            }
            else
            {
                GUI.enabled = true;
                EditorGUI.indentLevel = 0;

                GUILayout.Space(top);
                StyledGUI.DrawInspectorCategory(category);
                GUILayout.Space(down);
            }
        }

        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
            return -2;
        }
    }
}
