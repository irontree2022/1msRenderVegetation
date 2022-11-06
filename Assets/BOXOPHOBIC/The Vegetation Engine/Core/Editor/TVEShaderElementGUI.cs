//Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using TheVegetationEngine;

public class TVEShaderElementGUI : ShaderGUI
{
    bool multiSelection = false;
    bool showAdditionalInfo = false;

    public override void AssignNewShaderToMaterial(Material material, Shader oldShader, Shader newShader)
    {
        base.AssignNewShaderToMaterial(material, oldShader, newShader);

        AssignDefaultTexture(material, newShader);
    }

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        var material0 = materialEditor.target as Material;
        var materials = materialEditor.targets;

        if (materials.Length > 1)
            multiSelection = true;

        DrawDynamicInspector(material0, materialEditor, props);

        foreach (Material material in materials)
        {

            TVEShaderUtils.SetElementSettings(material);
        }
    }

    void DrawDynamicInspector(Material material, MaterialEditor materialEditor, MaterialProperty[] props)
    {
        var customPropsList = new List<MaterialProperty>();

        if (multiSelection)
        {
            for (int i = 0; i < props.Length; i++)
            {
                var prop = props[i];

                if (prop.flags == MaterialProperty.PropFlags.HideInInspector)
                    continue;

                customPropsList.Add(prop);
            }
        }
        else
        {
            for (int i = 0; i < props.Length; i++)
            {
                var prop = props[i];

                if (prop.flags == MaterialProperty.PropFlags.HideInInspector)
                {
                    continue;
                }

                if (material.HasProperty("_ElementMode"))
                {
                    if (material.GetInt("_ElementMode") == 1 && prop.name == "_MainColor")
                        continue;

                    if (material.GetInt("_ElementMode") == 0 && prop.name == "_AdditionalColor1")
                        continue;

                    if (material.GetInt("_ElementMode") == 0 && prop.name == "_AdditionalColor2")
                        continue;

                    if (material.GetInt("_ElementMode") == 0 && prop.name == "_AdditionalColor3")
                        continue;

                    if (material.GetInt("_ElementMode") == 0 && prop.name == "_AdditionalColor4")
                        continue;

                    if (material.GetInt("_ElementMode") == 1 && prop.name == "_MainValue")
                        continue;

                    if (material.GetInt("_ElementMode") == 0 && prop.name == "_AdditionalValue1")
                        continue;

                    if (material.GetInt("_ElementMode") == 0 && prop.name == "_AdditionalValue2")
                        continue;

                    if (material.GetInt("_ElementMode") == 0 && prop.name == "_AdditionalValue3")
                        continue;

                    if (material.GetInt("_ElementMode") == 0 && prop.name == "_AdditionalValue4")
                        continue;
                }

                customPropsList.Add(prop);
            }
        }

        //Draw Custom GUI
        for (int i = 0; i < customPropsList.Count; i++)
        {
            var prop = customPropsList[i];

            materialEditor.ShaderProperty(prop, prop.displayName);

        }

        if (AssetDatabase.GetAssetPath(material) != "")
        {
            materialEditor.EnableInstancingField();
        }
        else
        {
            material.enableInstancing = false;
        }

        GUILayout.Space(10);

        showAdditionalInfo = EditorGUILayout.Toggle("Show Additional Info", showAdditionalInfo);

        if (showAdditionalInfo)
        {
            GUILayout.Space(10);

            TVEShaderUtils.DrawTechnicalDetails(material);
        }

        GUILayout.Space(20);

        TVEShaderUtils.DrawPoweredByTheVegetationEngine();
    }

    void AssignDefaultTexture(Material material, Shader shader)
    {
        if (shader.name.Contains("Interaction"))
        {
            material.SetTexture("_MainTex", Resources.Load<Material>("Internal Interaction").GetTexture("_MainTex"));
        }
        else if (shader.name.Contains("Flow"))
        {
            material.SetTexture("_MainTex", Resources.Load<Material>("Internal Flow").GetTexture("_MainTex"));
        }
        else
        {
            material.SetTexture("_MainTex", Resources.Load<Material>("Internal Colors").GetTexture("_MainTex"));
        }
    }
}

