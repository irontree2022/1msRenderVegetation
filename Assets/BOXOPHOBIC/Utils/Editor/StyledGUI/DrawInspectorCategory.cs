// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;
using Boxophobic.Constants;

namespace Boxophobic.StyledGUI
{
    public partial class StyledGUI 
    {
        public static void DrawInspectorCategory(string bannerText)
        {
            var categoryFullRect = GUILayoutUtility.GetRect(0, 0, 18, 0);
            var categoryBeginRect = new Rect(categoryFullRect.position.x, categoryFullRect.position.y, 10, 18);
            var categoryMiddleRect = new Rect(categoryFullRect.position.x + 10, categoryFullRect.position.y, categoryFullRect.xMax - 32, 18);
            var categoryEndRect = new Rect(categoryFullRect.xMax - 10, categoryFullRect.position.y, 10, 18);
            var titleRect = new Rect(categoryFullRect.position.x, categoryFullRect.position.y, categoryFullRect.width, 18);

            if (EditorGUIUtility.isProSkin)
            {
                GUI.color = CONSTANT.ColorDarkGray;
            }
            else
            {
                GUI.color = CONSTANT.ColorLightGray;
            }

            //Workaround for flickering images in CustomInspector with Attribute
            //GUIStyle styleB = new GUIStyle();
            //styleB.normal.background = CONSTANT.CategoryImageBegin;
            //EditorGUI.LabelField(categoryBeginRect, GUIContent.none, styleB);

            //GUIStyle styleM = new GUIStyle();
            //styleM.normal.background = CONSTANT.CategoryImageMiddle;
            //EditorGUI.LabelField(categoryMiddleRect, GUIContent.none, styleM);

            //GUIStyle styleE = new GUIStyle();
            //styleE.normal.background = CONSTANT.CategoryImageEnd;
            //EditorGUI.LabelField(categoryEndRect, GUIContent.none, styleE);

            GUI.DrawTexture(categoryBeginRect, CONSTANT.CategoryImageBegin, ScaleMode.StretchToFill, true);
            GUI.DrawTexture(categoryMiddleRect, CONSTANT.CategoryImageMiddle, ScaleMode.StretchToFill, true);
            GUI.DrawTexture(categoryEndRect, CONSTANT.CategoryImageEnd, ScaleMode.StretchToFill, true);

            GUI.color = Color.white;
            GUI.Label(titleRect, bannerText, CONSTANT.BoldTextStyle);
        }
    }
}

