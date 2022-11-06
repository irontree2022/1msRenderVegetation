// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using Boxophobic.StyledGUI;
using System.Collections.Generic;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace TheVegetationEngine
{
#if UNITY_EDITOR
    [ExecuteInEditMode]
    [AddComponentMenu("BOXOPHOBIC/The Vegetation Engine/TVE Element")]
#endif
    public class TVEElement : StyledMonoBehaviour
    {
        const string layerProp = "_ElementLayerValue";

        [StyledBanner(0.890f, 0.745f, 0.309f, "Element", "", "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.fd5y8rbb7aia")]
        public bool styledBanner;

        [HideInInspector]
        public TVEElementMaterialData materialData;

        Renderer meshRenderer;
        Material material;
        Shader shader;
        int layer;

        void OnEnable()
        {
            meshRenderer = gameObject.GetComponent<Renderer>();

            if (meshRenderer.sharedMaterial == null || meshRenderer.sharedMaterial.name == "Element")
            {
                if (materialData == null)
                {
                    materialData = new TVEElementMaterialData();
                }

                if (materialData.shader == null)
                {
#if UNITY_EDITOR
                    material = new Material(Resources.Load<Material>("Internal Colors"));
                    SaveMaterialData(material);
#endif
                }
                else
                {
                    material = new Material(materialData.shader);
                    LoadMaterialData();
                }

                material.name = "Element";
                gameObject.GetComponent<Renderer>().sharedMaterial = material;
            }

            if (meshRenderer.sharedMaterial != null)
            {
                shader = meshRenderer.sharedMaterial.shader;

                if (meshRenderer.sharedMaterial.HasProperty(layerProp))
                {
                    layer = meshRenderer.sharedMaterial.GetInt(layerProp);
                }
            }

            AddElementToVolume();
        }

        void OnDestroy()
        {
            RemoveElementFromVolume();
        }

        void OnDisable()
        {
            RemoveElementFromVolume();
        }

#if UNITY_EDITOR
        void Update()
        {
            if (Application.isPlaying)
            {
                return;
            }

            if (Selection.Contains(gameObject))
            {
                var sharedMaterial = meshRenderer.sharedMaterial;

                if (sharedMaterial != null && sharedMaterial.name == "Element")
                {
                    if (sharedMaterial.shader != null)
                    {
                        SaveMaterialData(gameObject.GetComponent<Renderer>().sharedMaterial);
                    }
                }

                if (sharedMaterial.shader != shader)
                {
                    gameObject.SetActive(false);
                    gameObject.SetActive(true);
                }

                if (sharedMaterial.HasProperty(layerProp) && sharedMaterial.GetInt(layerProp) != layer)
                {
                    RemoveElementFromVolume();
                    AddElementToVolume();
                    layer = sharedMaterial.GetInt(layerProp);
                }
            }
        }
#endif

#if UNITY_EDITOR
        void SaveMaterialData(Material mat)
        {
            materialData = new TVEElementMaterialData();
            materialData.props = new List<TVEElementPropertyData>();

            materialData.shader = mat.shader;

            for (int i = 0; i < ShaderUtil.GetPropertyCount(mat.shader); i++)
            {
                var type = ShaderUtil.GetPropertyType(mat.shader, i);
                var prop = ShaderUtil.GetPropertyName(mat.shader, i);

                if (type == ShaderUtil.ShaderPropertyType.TexEnv)
                {
                    var propData = new TVEElementPropertyData(PropertyType.Texture, prop, mat.GetTexture(prop));
                    materialData.props.Add(propData);
                }

                if (type == ShaderUtil.ShaderPropertyType.Vector || type == ShaderUtil.ShaderPropertyType.Color)
                {
                    var propData = new TVEElementPropertyData(PropertyType.Vector, prop, mat.GetVector(prop));
                    materialData.props.Add(propData);
                }

                if (type == ShaderUtil.ShaderPropertyType.Float || type == ShaderUtil.ShaderPropertyType.Range)
                {
                    var propData = new TVEElementPropertyData(PropertyType.Value, prop, mat.GetFloat(prop));
                    materialData.props.Add(propData);
                }
            }
        }
#endif

        void LoadMaterialData()
        {
            material.shader = materialData.shader;

            for (int i = 0; i < materialData.props.Count; i++)
            {
                if (materialData.props[i].type == PropertyType.Texture)
                {
                    material.SetTexture(materialData.props[i].prop, materialData.props[i].texture);
                }

                if (materialData.props[i].type == PropertyType.Vector)
                {
                    material.SetVector(materialData.props[i].prop, materialData.props[i].vector);
                }

                if (materialData.props[i].type == PropertyType.Value)
                {
                    material.SetFloat(materialData.props[i].prop, materialData.props[i].value);
                }
            }
        }

        void AddElementToVolume()
        {
            if (TVEManager.Instance == null)
                return;

            if (gameObject.GetComponent<MeshRenderer>() != null && gameObject.GetComponent<MeshRenderer>().sharedMaterial != null)
            {
                var renderer = gameObject.GetComponent<MeshRenderer>();
                var material = renderer.sharedMaterial;
                var data = new TVEElementDrawerData(BufferType.Undefined, 0, RendererType.Mesh, gameObject, gameObject.GetComponent<MeshFilter>().sharedMesh, renderer);

                AddElementByType(material, data);
                SetElementVisibility(renderer);
            }
            else if (gameObject.GetComponent<ParticleSystemRenderer>() != null && gameObject.GetComponent<ParticleSystemRenderer>().sharedMaterial != null)
            {
                var renderer = gameObject.GetComponent<ParticleSystemRenderer>();
                var material = renderer.sharedMaterial;
                var data = new TVEElementDrawerData(BufferType.Undefined, 0, RendererType.Particle, gameObject, new Mesh(), renderer);
                data.mesh.name = "Particle";

                AddElementByType(material, data);
                SetElementVisibility(renderer);
            }
            else if (gameObject.GetComponent<TrailRenderer>() != null && gameObject.GetComponent<TrailRenderer>().sharedMaterial != null)
            {
                var renderer = gameObject.GetComponent<TrailRenderer>();
                var material = renderer.sharedMaterial;
                var data = new TVEElementDrawerData(BufferType.Undefined, 0, RendererType.Trail, gameObject, new Mesh(), gameObject.GetComponent<Renderer>());
                data.mesh.name = "Trail";

                AddElementByType(material, data);
                SetElementVisibility(renderer);
            }
            //else if (gameObject.GetComponent<LineRenderer>() != null && gameObject.GetComponent<LineRenderer>().sharedMaterial != null)
            //{
            //    var material = gameObject.GetComponent<LineRenderer>().sharedMaterial;
            //    var data = new TVEElementDrawerData(ElementType.Undefined, ElementLayer.Any, RendererType.Line, gameObject, new Mesh(), gameObject.GetComponent<Renderer>());
            //    data.mesh.name = "Line";

            //    AddElementByType(material, data);
            //}
        }

        void AddElementByType(Material material, TVEElementDrawerData drawerData)
        {

            if (material.HasProperty(layerProp))
            {
                drawerData.elementLayer = material.GetInt(layerProp);
            }

            bool validType = false;

            if (material.HasProperty("_IsColorsShader"))
            {
                drawerData.elementType = BufferType.Colors;
                validType = true;
            }
            else if (material.HasProperty("_IsExtrasShader"))
            {
                drawerData.elementType = BufferType.Extras;
                validType = true;
            }
            else if (material.HasProperty("_IsMotionShader"))
            {
                drawerData.elementType = BufferType.Motion;
                validType = true;
            }
            else if (material.HasProperty("_IsReactShader"))
            {
                drawerData.elementType = BufferType.React;
                validType = true;
            }
            else if (material.HasProperty("_IsCustomShader"))
            {
                drawerData.elementType = BufferType.Custom;
                validType = true;
            }

            if (validType)
            {
                TVEManager.Instance.globalVolume.volumeElements.Add(drawerData);

                var volumeDataSet = TVEManager.Instance.globalVolume.volumeDataSet;

                for (int i = 0; i < volumeDataSet.Count; i++)
                {
                    var volumeData = volumeDataSet[i];

                    if (drawerData.elementType == volumeData.bufferType)
                    {
                        //volumeData.internalBufferSize = 0;

                        if (drawerData.elementLayer > volumeData.internalBufferSize)
                        {
                            volumeData.internalBufferSize = drawerData.elementLayer;
                            volumeData.isUpdated = true;
                        }
                    }
                }
            }
        }

        void RemoveElementFromVolume()
        {
            if (TVEManager.Instance == null)
                return;

            var elements = TVEManager.Instance.globalVolume.volumeElements;

            if (elements != null)
            {
                for (int i = 0; i < elements.Count; i++)
                {
                    if (elements[i].gameobject == gameObject)
                    {
                        elements.RemoveAt(i);
                    }
                }
            }
        }

        void SetElementVisibility(Renderer renderer)
        {
            if (TVEManager.Instance.globalVolume.elementsVisibility == TVEGlobalVolume.ElementsVisibility.AlwaysHidden)
            {
#if UNITY_2019_3_OR_NEWER
                renderer.forceRenderingOff = true;
#else
                renderer.enabled = false;
#endif
            }

            if (TVEManager.Instance.globalVolume.elementsVisibility == TVEGlobalVolume.ElementsVisibility.AlwaysVisible)
            {
#if UNITY_2019_3_OR_NEWER
                renderer.forceRenderingOff = false;
#else
                renderer.enabled = true;
#endif
            }

            if (TVEManager.Instance.globalVolume.elementsVisibility == TVEGlobalVolume.ElementsVisibility.HiddenInGame)
            {
                if (Application.isPlaying)
                {
#if UNITY_2019_3_OR_NEWER
                    renderer.forceRenderingOff = true;
#else
                    renderer.enabled = false;
#endif
                }
                else
                {
#if UNITY_2019_3_OR_NEWER
                    renderer.forceRenderingOff = false;
#else
                    renderer.enabled = true;
#endif
                }
            }
        }

        void OnDrawGizmosSelected()
        {
            Gizmos.color = new Color(0.890f, 0.745f, 0.309f, 1f);
            Gizmos.DrawWireCube(transform.position, new Vector3(transform.lossyScale.x, 0, transform.lossyScale.z));
        }

        void OnDrawGizmos()
        {
            Gizmos.color = new Color(0.5f, 0.5f, 0.5f, 0.1f);
            Gizmos.DrawWireCube(transform.position, new Vector3(transform.lossyScale.x, 0, transform.lossyScale.z));
        }
    }
}
