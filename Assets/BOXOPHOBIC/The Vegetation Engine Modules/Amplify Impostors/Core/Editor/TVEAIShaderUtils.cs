//Cristian Pop - https://boxophobic.com/

using UnityEditor;
using UnityEngine;

namespace TheVegetationEngineImpostors
{
    public class TVEAIShaderUtils
    {
        public static void SetMaterialSettings(Material material)
        {
            var shaderName = material.shader.name;

            material.SetOverrideTag("RenderType", "AlphaTest");
            material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.AlphaTest;

            // Assign Default HD Foliage profile
            if (material.HasProperty("_SubsurfaceDiffusion"))
            {
                if (material.GetFloat("_SubsurfaceDiffusion") == 0)
                {
                    material.SetFloat("_SubsurfaceDiffusion", 3.5648174285888672f);
                    material.SetVector("_SubsurfaceDiffusion_asset", new Vector4(228889264007084710000000000000000000000f, 0.000000000000000000000000012389357880079404f, 0.00000000000000000000000000000000000076932702684439582f, 0.00018220426863990724f));
                    material.SetVector("_SubsurfaceDiffusion_Asset", new Vector4(228889264007084710000000000000000000000f, 0.000000000000000000000000012389357880079404f, 0.00000000000000000000000000000000000076932702684439582f, 0.00018220426863990724f));
                }
            }

            // Set Material Type
            if (material.HasProperty("_MaterialType"))
            {
                if (material.GetInt("_MaterialType") == 10)
                {
                    material.EnableKeyword("TVE_IS_VEGETATION_SHADER");
                    material.DisableKeyword("TVE_IS_GRASS_SHADER");
                }
                else if (material.GetInt("_MaterialType") == 20)
                {
                    material.DisableKeyword("TVE_IS_VEGETATION_SHADER");
                    material.EnableKeyword("TVE_IS_GRASS_SHADER");
                }
            }

            // Set Detail Mode
            if (material.HasProperty("_DetailMode") && material.HasProperty("_SecondColor"))
            {
                if (material.GetInt("_DetailMode") == 0)
                {
                    material.EnableKeyword("TVE_DETAIL_MODE_OFF");
                    material.DisableKeyword("TVE_DETAIL_MODE_ON");
                }
                else
                {
                    material.DisableKeyword("TVE_DETAIL_MODE_OFF");
                    material.EnableKeyword("TVE_DETAIL_MODE_ON");
                }
            }

            if (material.HasProperty("_DetailBlendMode") && material.HasProperty("_SecondColor"))
            {
                if (material.GetInt("_DetailBlendMode") == 0)
                {
                    material.EnableKeyword("TVE_DETAIL_BLEND_OVERLAY");
                    material.DisableKeyword("TVE_DETAIL_BLEND_REPLACE");
                }
                else
                {
                    material.DisableKeyword("TVE_DETAIL_BLEND_OVERLAY");
                    material.EnableKeyword("TVE_DETAIL_BLEND_REPLACE");
                }
            }

            // Set GI Mode
            if (material.HasProperty("_EmissiveFlagMode"))
            {
                int flag = material.GetInt("_EmissiveFlagMode");

                if (flag == 0)
                {
                    material.globalIlluminationFlags = MaterialGlobalIlluminationFlags.None;
                }
                else if (flag == 10)
                {
                    material.globalIlluminationFlags = MaterialGlobalIlluminationFlags.AnyEmissive;
                }
                else if (flag == 20)
                {
                    material.globalIlluminationFlags = MaterialGlobalIlluminationFlags.BakedEmissive;
                }
                else if (flag == 30)
                {
                    material.globalIlluminationFlags = MaterialGlobalIlluminationFlags.RealtimeEmissive;
                }
            }

            // Enable Nature Rendered support
            material.SetOverrideTag("NatureRendererInstancing", "True");

            if (shaderName.Contains("Translucency"))
            {
                material.SetFloat("_Translucency", material.GetFloat("_TranslucencyIntensityValue"));
                material.SetFloat("_TransNormalDistortion", material.GetFloat("_TranslucencyNormalValue"));
                material.SetFloat("_TransScattering", material.GetFloat("_TranslucencyScatteringValue"));
                material.SetFloat("_TransDirect", material.GetFloat("_TranslucencyDirectValue"));
                material.SetFloat("_TransAmbient", material.GetFloat("_TranslucencyAmbientValue"));
                material.SetFloat("_TransShadow", material.GetFloat("_TranslucencyShadowValue"));
            }
        }

        public static void CopyMaterialProperties(Material oldMaterial, Material newMaterial)
        {
            var oldShader = oldMaterial.shader;
            var newShader = newMaterial.shader;

            for (int i = 0; i < ShaderUtil.GetPropertyCount(oldShader); i++)
            {
                for (int j = 0; j < ShaderUtil.GetPropertyCount(newShader); j++)
                {
                    var propertyName = ShaderUtil.GetPropertyName(oldShader, i);
                    var propertyType = ShaderUtil.GetPropertyType(oldShader, i);

                    if (propertyName == ShaderUtil.GetPropertyName(newShader, j))
                    {
                        if (propertyType == ShaderUtil.ShaderPropertyType.Color || propertyType == ShaderUtil.ShaderPropertyType.Vector)
                        {
                            newMaterial.SetVector(propertyName, oldMaterial.GetVector(propertyName));
                        }

                        if (propertyType == ShaderUtil.ShaderPropertyType.Float || propertyType == ShaderUtil.ShaderPropertyType.Range)
                        {
                            if (propertyName != "_IsVersion")
                            {
                                newMaterial.SetFloat(propertyName, oldMaterial.GetFloat(propertyName));
                            }
                        }

                        if (propertyType == ShaderUtil.ShaderPropertyType.TexEnv)
                        {
                            newMaterial.SetTexture(propertyName, oldMaterial.GetTexture(propertyName));
                        }
                    }
                }
            }
        }

        public static void DrawCopySettingsFromGameObject(Material material)
        {
            GameObject go = null;
            go = (GameObject)EditorGUILayout.ObjectField("Copy Settings From GameObject", go, typeof(GameObject), true);

            if (go != null)
            {
                var oldMaterials = go.GetComponent<MeshRenderer>().sharedMaterials;

                for (int i = 0; i < oldMaterials.Length; i++)
                {
                    var oldMaterial = oldMaterials[i];

                    if (oldMaterial != null)
                    {
                        CopyMaterialProperties(oldMaterial, material);

                        if (oldMaterial.HasProperty("_IsCrossShader") || oldMaterial.HasProperty("_IsGrassShader") || oldMaterial.HasProperty("_IsBarkShader") || oldMaterial.HasProperty("_IsLeafShader"))
                        {
                            material.SetInt("_MaterialType", 10);
                        }

                        if (oldMaterial.HasProperty("_IsGrassShader"))
                        {
                            material.SetInt("_MaterialType", 20);
                        }

                        // Switch to Deferred shaders
                        if ((oldMaterial.shader.name.Contains("Cross") || oldMaterial.shader.name.Contains("Grass") || oldMaterial.shader.name.Contains("Leaf")) && oldMaterial.shader.name.Contains("Standard"))
                        {
                            var newShaderName = material.shader.name.Replace("Subsurface", "Standard");

                            if (Shader.Find(newShaderName) != null)
                            {
                                material.shader = Shader.Find(newShaderName);
                            }
                        }

                        // Switch to Subsurface shaders
                        if ((oldMaterial.shader.name.Contains("Cross") || oldMaterial.shader.name.Contains("Grass") || oldMaterial.shader.name.Contains("Leaf")) && oldMaterial.shader.name.Contains("Subsurface"))
                        {
                            var newShaderName = material.shader.name.Replace("Standard", "Subsurface");
                            if (Shader.Find(newShaderName) != null)
                            {
                                material.shader = Shader.Find(newShaderName);
                            }
                        }

                        material.SetFloat("_IsInitialized", 1);
                        go = null;
                    }
                }
            }
        }
    }
}
