// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;
using System;

public class StyledEmissiveIntensityDrawer : MaterialPropertyDrawer
{
    public float top = 0;
    public float down = 0;

    public StyledEmissiveIntensityDrawer()
    {
        this.top = 0;
        this.down = 0;
    }

    public StyledEmissiveIntensityDrawer(float top, float down)
    {
        this.top = top;
        this.down = down;
    }

    public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
    {
        var stylePopup = new GUIStyle(EditorStyles.popup)
        {
            fontSize = 9,
            alignment = TextAnchor.MiddleCenter,
        };

        Vector4 propVector = prop.vectorValue;

        GUILayout.Space(top);

        EditorGUI.BeginChangeCheck();

        EditorGUI.showMixedValue = prop.hasMixedValue;

        GUILayout.BeginHorizontal();
        GUILayout.Space(-1);
        GUILayout.Label(label, GUILayout.Width(EditorGUIUtility.labelWidth));

        if (propVector.w == 0)
        {
            propVector.y = EditorGUILayout.FloatField(propVector.y);
        }
        else if (propVector.w == 1)
        {
            propVector.z = EditorGUILayout.FloatField(propVector.z);
        }

        GUI.enabled = true;

        GUILayout.Space(2);

        propVector.w = (float)EditorGUILayout.Popup((int)propVector.w, new string[] { "Nits", "EV100" }, stylePopup, GUILayout.Width(50));

        GUILayout.EndHorizontal();

        EditorGUI.showMixedValue = false;
        if (EditorGUI.EndChangeCheck())
        {
            if (propVector.w == 0)
            {
                propVector.x = propVector.y;
            }
            else if (propVector.w == 1)
            {
                propVector.x = ConvertEvToLuminance(propVector.z);
            }

            prop.vectorValue = propVector;
        }

        GUILayout.Space(down);
    }

    public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
    {
        return -2;
    }

    //public float ConvertLuminanceToEv(float luminance)
    //{
    //    return (float)Math.Log((luminance * 100f) / 12.5f, 2);
    //}

    public float ConvertEvToLuminance(float ev)
    {
        return (12.5f / 100.0f) * Mathf.Pow(2f, ev);
    }
}