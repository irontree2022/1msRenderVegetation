// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;
using Boxophobic.Constants;

namespace Boxophobic.StyledGUI
{
    public partial class StyledGUI 
    {
        public static void DrawInspectorBanner(Color bannerColor, string title, string helpURL)
        {
            GUILayout.Space(10);

            var bannerFullRect = GUILayoutUtility.GetRect(0, 0, 36, 0);
            var bannerBeginRect = new Rect(bannerFullRect.position.x, bannerFullRect.position.y, 20, 36);
            var bannerMiddleRect = new Rect(bannerFullRect.position.x + 20, bannerFullRect.position.y, bannerFullRect.xMax - 54, 36);
            var bannerEndRect = new Rect(bannerFullRect.xMax - 20, bannerFullRect.position.y, 20, 36);
            var iconRect = new Rect(bannerFullRect.xMax - 34, bannerFullRect.position.y + 5, 30, 26);

            Color guiColor;

            if (EditorGUIUtility.isProSkin)
            {
                bannerColor = new Color(bannerColor.r, bannerColor.g, bannerColor.b, 1f);
            }
            else
            {
                bannerColor = CONSTANT.ColorLightGray;
            }

            if (bannerColor.r + bannerColor.g + bannerColor.b <= 1.5f)
            {
                guiColor = CONSTANT.ColorLightGray;
            }
            else
            {
                guiColor = CONSTANT.ColorDarkGray;
            }

            GUI.color = bannerColor;

            GUI.DrawTexture(bannerBeginRect, CONSTANT.BannerImageBegin, ScaleMode.StretchToFill, true);
            GUI.DrawTexture(bannerMiddleRect, CONSTANT.BannerImageMiddle, ScaleMode.StretchToFill, true);
            GUI.DrawTexture(bannerEndRect, CONSTANT.BannerImageEnd, ScaleMode.StretchToFill, true);

#if UNITY_2019_3_OR_NEWER
            GUI.Label(bannerFullRect, "<size=16><color=#" + ColorUtility.ToHtmlStringRGB(guiColor) + ">" + title + "</color></size>", CONSTANT.TitleStyle);
#else
            GUI.Label(bannerFullRect, "<size=14><color=#" + ColorUtility.ToHtmlStringRGB(guiColor) + "><b>" + title + "</b></color></size>", CONSTANT.TitleStyle);
#endif
            GUI.color = guiColor;

            if (GUI.Button(iconRect, CONSTANT.IconHelp, new GUIStyle { alignment = TextAnchor.MiddleCenter }))
            {
                Application.OpenURL(helpURL);
            }

            GUI.color = Color.white;

            GUILayout.Space(10);
        }

        public static void DrawInspectorBanner(string title)
        {
            GUILayout.Space(10);

            var bannerFullRect = GUILayoutUtility.GetRect(0, 0, 36, 0);
            var bannerBeginRect = new Rect(bannerFullRect.position.x, bannerFullRect.position.y, 20, 36);
            var bannerMiddleRect = new Rect(bannerFullRect.position.x + 20, bannerFullRect.position.y, bannerFullRect.xMax - 54, 36);
            var bannerEndRect = new Rect(bannerFullRect.xMax - 20, bannerFullRect.position.y, 20, 36);

            Color bannerColor;
            Color guiColor;

            if (EditorGUIUtility.isProSkin)
            {
                bannerColor = CONSTANT.ColorDarkGray;
                guiColor = CONSTANT.ColorLightGray;
            }
            else
            {
                bannerColor = CONSTANT.ColorLightGray;
                guiColor = CONSTANT.ColorDarkGray;
            }

            GUI.color = bannerColor;

            GUI.DrawTexture(bannerBeginRect, CONSTANT.BannerImageBegin, ScaleMode.StretchToFill, true);
            GUI.DrawTexture(bannerMiddleRect, CONSTANT.BannerImageMiddle, ScaleMode.StretchToFill, true);
            GUI.DrawTexture(bannerEndRect, CONSTANT.BannerImageEnd, ScaleMode.StretchToFill, true);

#if UNITY_2019_3_OR_NEWER
            GUI.Label(bannerFullRect, "<size=16><color=#" + ColorUtility.ToHtmlStringRGB(guiColor) + ">" + title + "</color></size>", CONSTANT.TitleStyle);
#else
            GUI.Label(bannerFullRect, "<size=14><color=#" + ColorUtility.ToHtmlStringRGB(guiColor) + "><b>" + title + "</b></color></size>", CONSTANT.TitleStyle);
#endif

            GUI.color = Color.white;

            GUILayout.Space(10);
        }
    }
}

