// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;
using Boxophobic.Constants;

namespace Boxophobic.StyledGUI
{
    public partial class StyledGUI
    {
        public static void DrawWindowBanner(Color bannerColor, string bannerText, string helpURL)
        {
            GUILayout.Space(15);

            var bannerFullRect = GUILayoutUtility.GetRect(0, 0, 36, 0);
            var bannerBeginRect = new Rect(bannerFullRect.position.x + 20, bannerFullRect.position.y, 20, 36);
            var bannerMiddleRect = new Rect(bannerFullRect.position.x + 36, bannerFullRect.position.y, bannerFullRect.xMax - 70, 36);
            var bannerEndRect = new Rect(bannerFullRect.xMax - 36, bannerFullRect.position.y, 20, 36);
            var iconRect = new Rect(bannerFullRect.xMax - 51, bannerFullRect.position.y + 5, 30, 26);

            Color guiColor;

            if (EditorGUIUtility.isProSkin)
            {
                bannerColor = new Color(bannerColor.r, bannerColor.g, bannerColor.b, 1f);
            }
            else
            {
                bannerColor = CONSTANT.ColorLightGray;
            }

            if (bannerColor.r + bannerColor.g + bannerColor.b <= 1.5)
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

            GUI.color = guiColor;

#if UNITY_2019_3_OR_NEWER
            GUI.Label(bannerFullRect, "<size=16><color=#" + ColorUtility.ToHtmlStringRGB(guiColor) + ">" + bannerText + "</color></size>", CONSTANT.TitleStyle);
#else
            GUI.Label(bannerFullRect, "<size=14><color=#" + ColorUtility.ToHtmlStringRGB(guiColor) + "><b>" + bannerText + "</b></color></size>", CONSTANT.TitleStyle);
#endif
            if (GUI.Button(iconRect, CONSTANT.IconHelp, new GUIStyle { alignment = TextAnchor.MiddleCenter }))
            {
                Application.OpenURL(helpURL);
            }

            GUI.color = Color.white;
            GUILayout.Space(15);
        }
    }
}

