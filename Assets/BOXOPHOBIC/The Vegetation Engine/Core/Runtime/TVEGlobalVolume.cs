// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using Boxophobic.StyledGUI;
using UnityEngine.Rendering;
using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace TheVegetationEngine
{
    [ExecuteInEditMode]
    [AddComponentMenu("BOXOPHOBIC/The Vegetation Engine/TVE Global Volume")]
    public class TVEGlobalVolume : StyledMonoBehaviour
    {
        const int FOLLOW_CAMERA_RESOLUTION = 1024;
        const float FOLLOW_CAMERA_DISTANCE = 100f;

        public enum ElementsVisibility
        {
            AlwaysHidden = 0,
            AlwaysVisible = 10,
            HiddenInGame = 20,
        }

        public enum ElementsSorting
        {
            Off = 0,
            On = 10,
        }

        public enum VolumeDataMode
        {
            Off = -1,
            FollowMainCamera = 10,
            RenderedInVolumeLowerQuality = 256,
            RenderedInVolumeLowQuality = 512,
            RenderedInVolumeMediumQuality = 1024,
            RenderedInVolumeHighQuality = 2048,
            RenderedInVolumeUltraQuality = 4096,
        }

        [StyledBanner(0.890f, 0.745f, 0.309f, "Global Volume", "", "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.a39m1w5ouu94")]
        public bool styledBanner;

        [StyledCategory("Camera Settings", 5, 10)]
        public bool cameraCat;

        [StyledMessage("Error", "Main Camera not found! Make sure you have a main camera with Main Camera tag in your scene! Particle elements updating will be skipped without it. Enter play mode to update the status!", 0, 10)]
        public bool styledCameraMessaage = false;

        public Camera mainCamera;

        [StyledCategory("Elements Settings")]
        public bool elementsCat;

#if UNITY_EDITOR
        [StyledMessage("Info", "Realtime Sorting is not supported for elements with GPU Instanceing enabled!", 0, 10)]
        public bool styledSortingMessaage = true;
#endif

        [Tooltip("Controls the elements visibility in scene and game view.")]
        public ElementsVisibility elementsVisibility = ElementsVisibility.HiddenInGame;
        [HideInInspector]
        public ElementsVisibility elementsVisibilityOld = ElementsVisibility.HiddenInGame;

        [Tooltip("Controls the elements sorting by element position. Always on in scene view.")]
        public ElementsSorting elementsSorting = ElementsSorting.Off;
        [Tooltip("Controls the elements fading at the volume edges if the Enable Edge Fade Support is toggled on the element material.")]
        [Range(0, 1)]
        public float elementsEdgeFade = 0.75f;

        [StyledCategory("Render Settings")]
        public bool dataCat;

        [Tooltip("Volume data used for Colors elements rendering. In Dynamic mode, the buffer follows the Main Camera. In Quality mode, the buffer is rendered inside the Global Volume at the following resolutions: Lower 256, Low 512, Medium 1024, High 2048, Ultra 4096.")]
        public VolumeDataMode renderColorsData = VolumeDataMode.RenderedInVolumeMediumQuality;
        [Tooltip("Volume data used for Extras elements rendering. In Dynamic mode, the buffer follows the Main Camera. In Quality mode, the buffer is rendered inside the Global Volume at the following resolutions: Lower 256, Low 512, Medium 1024, High 2048, Ultra 4096.")]
        public VolumeDataMode renderExtrasData = VolumeDataMode.RenderedInVolumeMediumQuality;
        [Tooltip("Volume data used for Motion elements rendering. In Dynamic mode, the buffer follows the Main Camera. In Quality mode, the buffer is rendered inside the Global Volume at the following resolutions: Lower 256, Low 512, Medium 1024, High 2048, Ultra 4096.")]
        public VolumeDataMode renderMotionData = VolumeDataMode.RenderedInVolumeMediumQuality;
        [Tooltip("Volume data used for Interaction and Size elements rendering. In Dynamic mode, the buffer follows the Main Camera. In Quality mode, the buffer is rendered inside the Global Volume at the following resolutions: Lower 256, Low 512, Medium 1024, High 2048, Ultra 4096.")]
        public VolumeDataMode renderReactData = VolumeDataMode.RenderedInVolumeMediumQuality;
        //[Tooltip("Volume data used for Custom elements and effects rendering. In Dynamic mode, the buffer follows the Main Camera. In Quality mode, the buffer is rendered inside the Global Volume at the following resolutions: Low 512, Medium 1024, High 2048, Ultra 4096.")]
        //public VolumeDataMode renderCustomData = VolumeDataMode.Off;

        [StyledCategory("Debug Settings")]
        public bool debugCat;

        [StyledInteractive("OFF")]
        public bool interactiveOff;

        [Tooltip("List containg Volume data entities.")]
        public List<TVEVolumeData> volumeDataSet;
        [Tooltip("List containg all the Element entities.")]
        public List<TVEElementDrawerData> volumeElements;
        [Tooltip("List containg all the Element entities with GPU Instancing enabled.")]
        public List<TVEElementInstancedData> volumeInstanced;

        [StyledSpace(10)]
        public bool styledSpace0;

        TVEVolumeData colorsData;
        TVEVolumeData extrasData;
        TVEVolumeData motionData;
        TVEVolumeData reactData;

        Vector4 bufferParams;
        Mesh elementMesh;

        Matrix4x4 modelViewMatrix;
        Matrix4x4 projectionMatrix;

        void Awake()
        {
            CreateVolumeDataSet();

            volumeElements = new List<TVEElementDrawerData>();
            volumeInstanced = new List<TVEElementInstancedData>();

            modelViewMatrix = new Matrix4x4
            (
                new Vector4(1f, 0f, 0f, 0f),
                new Vector4(0f, 0f, -1f, 0f),
                new Vector4(0f, -1f, 0f, 0f),
                new Vector4(0f, 0f, 0f, 1f)
            );
        }

        void Start()
        {
            gameObject.name = "Global Volume";
            gameObject.transform.SetSiblingIndex(7);

            elementMesh = Resources.Load<Mesh>("QuadMesh");

            CreateRenderBuffers();

            SortElementObjects();
            SetElementsVisibility();

            if (Application.isPlaying)
            {
                GetInstancedElements();
            }

            GetMaincamera();
        }

        void Update()
        {
            if (Application.isPlaying == false || elementsSorting == ElementsSorting.On)
            {
                SortElementObjects();
            }

#if UNITY_EDITOR
            if (elementsSorting == ElementsSorting.On)
            {
                styledSortingMessaage = true;
            }
            else
            {
                styledSortingMessaage = false;
            }
#endif

            if (mainCamera == null)
            {
                styledCameraMessaage = true;
                GetMaincamera();
            }

            if (mainCamera != null)
            {
                styledCameraMessaage = false;

                UpdateParticleRenderers();
            }

            if (elementsVisibilityOld != elementsVisibility)
            {
                SetElementsVisibility();

                elementsVisibilityOld = elementsVisibility;
            }

#if UNITY_EDITOR
            CheckRenderBuffers();
#endif

            UpdateRenderBuffers();
            ExecuteRenderBuffers();

            SetGlobalShaderParameters();
        }

        void OnDrawGizmosSelected()
        {
            Gizmos.color = new Color(0.890f, 0.745f, 0.309f, 1f);
            Gizmos.DrawWireCube(transform.position, new Vector3(transform.lossyScale.x, transform.lossyScale.y, transform.lossyScale.z));
        }

        void OnDrawGizmos()
        {
            Gizmos.color = new Color(0.5f, 0.5f, 0.5f, 0.1f);
            Gizmos.DrawWireCube(transform.position, new Vector3(transform.lossyScale.x, transform.lossyScale.y, transform.lossyScale.z));
        }

        void GetMaincamera()
        {
            mainCamera = Camera.main;
        }

        void CreateVolumeDataSet()
        {
            volumeDataSet = new List<TVEVolumeData>();

            colorsData = new TVEVolumeData();
            colorsData.enabled = true;
            colorsData.bufferType = BufferType.Colors;
            colorsData.internalTexName = "TVE_ColorsTex";
            colorsData.internalTexCoord = "TVE_ColorsCoord";
            colorsData.internalTexUsage = "TVE_ColorsUsage";
            colorsData.internalResolution = 1024;
            colorsData.internalFormat = RenderTextureFormat.ARGBHalf;
            colorsData.internalBufferSize = 0;

            extrasData = new TVEVolumeData();
            extrasData.enabled = true;
            extrasData.bufferType = BufferType.Extras;
            extrasData.internalTexName = "TVE_ExtrasTex";
            extrasData.internalTexCoord = "TVE_ExtrasCoord";
            extrasData.internalTexUsage = "TVE_ExtrasUsage";
            extrasData.internalResolution = 1024;
            extrasData.internalFormat = RenderTextureFormat.Default;
            extrasData.internalBufferSize = 0;

            motionData = new TVEVolumeData();
            motionData.enabled = true;
            motionData.bufferType = BufferType.Motion;
            motionData.internalTexName = "TVE_MotionTex";
            motionData.internalTexCoord = "TVE_MotionCoord";
            motionData.internalTexUsage = "TVE_MotionUsage";
            motionData.internalResolution = 1024;
            motionData.internalFormat = RenderTextureFormat.Default;
            motionData.internalBufferSize = 0;

            reactData = new TVEVolumeData();
            reactData.enabled = true;
            reactData.bufferType = BufferType.React;
            reactData.internalTexName = "TVE_ReactTex";
            reactData.internalTexCoord = "TVE_ReactCoord";
            reactData.internalTexUsage = "TVE_ReactUsage";
            reactData.internalResolution = 1024;
            reactData.internalFormat = RenderTextureFormat.Default;
            reactData.internalBufferSize = 0;

            UpdateVolumeData(colorsData, renderColorsData);
            UpdateVolumeData(extrasData, renderExtrasData);
            UpdateVolumeData(motionData, renderMotionData);
            UpdateVolumeData(reactData, renderReactData);

            volumeDataSet.Add(colorsData);
            volumeDataSet.Add(extrasData);
            volumeDataSet.Add(motionData);
            volumeDataSet.Add(reactData);
        }

        void UpdateVolumeData(TVEVolumeData volumeData, VolumeDataMode volumeDataMode)
        {
            if (volumeDataMode == VolumeDataMode.Off)
            {
                volumeData.enabled = false;
                volumeData.internalResolution = 32;
                volumeData.internalBufferSize = 0;
            }
            else if (volumeDataMode == VolumeDataMode.FollowMainCamera)
            {
                volumeData.enabled = true;
                volumeData.internalResolution = FOLLOW_CAMERA_RESOLUTION;
                volumeData.followMainCamera = true;
            }
            else if (volumeDataMode == VolumeDataMode.RenderedInVolumeLowerQuality)
            {
                volumeData.enabled = true;
                volumeData.internalResolution = 256;
                volumeData.followMainCamera = false;
            }
            else if (volumeDataMode == VolumeDataMode.RenderedInVolumeLowQuality)
            {
                volumeData.enabled = true;
                volumeData.internalResolution = 512;
                volumeData.followMainCamera = false;
            }
            else if (volumeDataMode == VolumeDataMode.RenderedInVolumeMediumQuality)
            {
                volumeData.enabled = true;
                volumeData.internalResolution = 1024;
                volumeData.followMainCamera = false;
            }
            else if (volumeDataMode == VolumeDataMode.RenderedInVolumeHighQuality)
            {
                volumeData.enabled = true;
                volumeData.internalResolution = 2048;
                volumeData.followMainCamera = false;
            }
            else if (volumeDataMode == VolumeDataMode.RenderedInVolumeUltraQuality)
            {
                volumeData.enabled = true;
                volumeData.internalResolution = 4096;
                volumeData.followMainCamera = false;
            }
        }

        void CreateRenderBuffers()
        {
            for (int i = 0; i < volumeDataSet.Count; i++)
            {
                var volumeData = volumeDataSet[i];

                if (volumeData == null)
                {
                    continue;
                }

                if (volumeData.internalTex != null)
                {
                    volumeData.internalTex.Release();
                }

                if (volumeData.internalBuffer != null)
                {
                    for (int b = 0; b < volumeData.internalBuffer.Length; b++)
                    {
                        volumeData.internalBuffer[b].Clear();
                    }

                }

                volumeData.internalTex = new RenderTexture(volumeData.internalResolution, volumeData.internalResolution, 0, volumeData.internalFormat);
                volumeData.internalTex.dimension = TextureDimension.Tex2DArray;
                volumeData.internalTex.volumeDepth = volumeData.internalBufferSize + 1;
                volumeData.internalTex.name = volumeData.bufferType.ToString();
                volumeData.internalTex.wrapMode = TextureWrapMode.Clamp;

                volumeData.internalBuffer = new CommandBuffer[volumeData.internalBufferSize + 1];

                volumeData.internalBufferUsage = new float[9];

                for (int b = 0; b < volumeData.internalBuffer.Length; b++)
                {
                    volumeData.internalBuffer[b] = new CommandBuffer();
                    volumeData.internalBuffer[b].name = volumeData.bufferType.ToString();
                    volumeData.internalBufferUsage[b] = 1.0f;
                }

                Shader.SetGlobalTexture(volumeData.internalTexName, volumeData.internalTex);
                Shader.SetGlobalFloatArray(volumeData.internalTexUsage, volumeData.internalBufferUsage);
            }
        }

        void UpdateRenderBuffers()
        {
            for (int i = 0; i < volumeDataSet.Count; i++)
            {
                var volumeData = volumeDataSet[i];

                if (volumeData == null)
                {
                    continue;
                }

                if (volumeData.internalBuffer == null)
                {
                    continue;
                }

                if (volumeData.bufferType == BufferType.Extras)
                {
                    bufferParams = new Vector4(Shader.GetGlobalFloat("TVE_EmissiveValue"), Shader.GetGlobalFloat("TVE_WetnessValue"), Shader.GetGlobalFloat("TVE_OverlayValue"), 1);
                    Shader.SetGlobalVector("TVE_ExtrasParams", bufferParams);

                }
                else if (volumeData.bufferType == BufferType.Motion)
                {
                    bufferParams = Shader.GetGlobalVector("TVE_MotionParams");
                }
                else if (volumeData.bufferType == BufferType.React)
                {
                    bufferParams = new Vector4(0, 0, 0, 1);
                    Shader.SetGlobalVector("TVE_ReactParams", bufferParams);
                }
                else
                {
                    bufferParams = new Color(0.5f, 0.5f, 0.5f, 0.0f);

                    if (QualitySettings.activeColorSpace == ColorSpace.Linear)
                    {
                        bufferParams = new Color(0.5f, 0.5f, 0.5f, 0.0f).linear;
                    }
                    Shader.SetGlobalVector("TVE_ColorsParams", bufferParams);
                }

                for (int b = 0; b < volumeData.internalBuffer.Length; b++)
                {
                    volumeData.internalBuffer[b].Clear();
                    volumeData.internalBuffer[b].ClearRenderTarget(true, true, bufferParams);

                    if (volumeData.enabled == false)
                    {
                        continue;
                    }

                    for (int e = 0; e < volumeElements.Count; e++)
                    {
                        var elementData = volumeElements[e];

                        if (elementData.elementType == volumeData.bufferType)
                        {
                            if (elementData.elementLayer == b)
                            {
                                if (elementData.rendererType == RendererType.Mesh)
                                {
                                    volumeData.internalBuffer[b].DrawMesh(elementData.mesh, elementData.renderer.localToWorldMatrix, elementData.renderer.sharedMaterial);
                                }
                                else
                                {
                                    volumeData.internalBuffer[b].DrawMesh(elementData.mesh, Matrix4x4.identity, elementData.renderer.sharedMaterial);
                                }
                            }
                        }
                    }

                    if (!Application.isPlaying)
                    {
                        continue;
                    }

                    if (volumeData.enabled == false)
                    {
                        continue;
                    }

                    for (int g = 0; g < volumeInstanced.Count; g++)
                    {
                        var elementData = volumeInstanced[g];

                        if (elementData.elementType == volumeData.bufferType)
                        {
                            if (elementData.elementLayer == b)
                            {
                                Matrix4x4[] matrix4X4s = new Matrix4x4[elementData.instancedRenderers.Count];

                                for (int m = 0; m < elementData.instancedRenderers.Count; m++)
                                {
                                    matrix4X4s[m] = elementData.instancedRenderers[m].localToWorldMatrix;
                                }

                                volumeData.internalBuffer[b].DrawMeshInstanced(elementMesh, 0, elementData.instancedMaterial, 0, matrix4X4s);
                            }
                        }
                    }
                }
            }
        }

        void ExecuteRenderBuffers()
        {
            GL.PushMatrix();
            RenderTexture currentRenderTexture = RenderTexture.active;

            for (int i = 0; i < volumeDataSet.Count; i++)
            {
                var volumeData = volumeDataSet[i];

                if (volumeData == null)
                {
                    continue;
                }

                if (volumeData.internalBuffer == null)
                {
                    continue;
                }

                var position = gameObject.transform.position;
                var scale = gameObject.transform.lossyScale;

                if (volumeData.followMainCamera)
                {
                    if (mainCamera != null)
                    {
                        float grid = FOLLOW_CAMERA_DISTANCE / FOLLOW_CAMERA_RESOLUTION;
                        float posX = Mathf.Round(mainCamera.transform.position.x / grid) * grid;
                        float posZ = Mathf.Round(mainCamera.transform.position.z / grid) * grid;

                        position = new Vector3(posX, mainCamera.transform.position.y, posZ);
                        scale = new Vector3(FOLLOW_CAMERA_DISTANCE, gameObject.transform.lossyScale.y, FOLLOW_CAMERA_DISTANCE);
                    }
                }

                projectionMatrix = Matrix4x4.Ortho(-scale.x / 2 + position.x,
                                                    scale.x / 2 + position.x,
                                                    scale.z / 2 + -position.z,
                                                    -scale.z / 2 + -position.z,
                                                    -scale.y / 2 + position.y,
                                                    scale.y / 2 + position.y);

                var x = 1 / scale.x;
                var y = 1 / scale.z;
                var z = 1 / scale.x * position.x - 0.5f;
                var w = 1 / scale.z * position.z - 0.5f;
                var coord = new Vector4(x, y, -z, -w);

                //Shader.SetGlobalVector("TVE_VolumeCoord", new Vector4(x, y, -z, -w));

                GL.LoadProjectionMatrix(projectionMatrix);
                GL.modelview = modelViewMatrix;

                for (int b = 0; b < volumeData.internalBuffer.Length; b++)
                {
                    Graphics.SetRenderTarget(volumeData.internalTex, 0, CubemapFace.Unknown, b);
                    Graphics.ExecuteCommandBuffer(volumeData.internalBuffer[b]);
                }

                Shader.SetGlobalTexture(volumeData.internalTexName, volumeData.internalTex);
                Shader.SetGlobalVector(volumeData.internalTexCoord, coord);
            }

            RenderTexture.active = currentRenderTexture;
            GL.PopMatrix();
        }

        void CheckRenderBuffers()
        {
            if (Application.isPlaying)
            {
                return;
            }

            for (int i = 0; i < volumeDataSet.Count; i++)
            {
                var volumeData = volumeDataSet[i];

                if (volumeData == null)
                {
                    continue;
                }

                if (volumeData.isUpdated)
                {
                    CreateRenderBuffers();
                    volumeData.isUpdated = false;
                }
            }
        }

        void SetGlobalShaderParameters()
        {
            Shader.SetGlobalFloat("TVE_ElementsFadeValue", elementsEdgeFade);
        }

        void UpdateParticleRenderers()
        {
            for (int i = 0; i < volumeElements.Count; i++)
            {
                if (volumeElements[i] != null)
                {
                    if (volumeElements[i].rendererType == RendererType.Particle)
                    {
                        var renderer = (ParticleSystemRenderer)volumeElements[i].renderer;
                        renderer.BakeMesh(volumeElements[i].mesh, true);
                    }
                    else if (volumeElements[i].rendererType == RendererType.Trail)
                    {
                        var renderer = (TrailRenderer)volumeElements[i].renderer;
                        renderer.BakeMesh(volumeElements[i].mesh, true);
                    }
                    //else if (volumeElements[i].rendererType == RendererType.Line)
                    //{
                    //    var renderer = (LineRenderer)volumeElements[i].renderer;
                    //    renderer.BakeMesh(volumeElements[i].mesh, false);
                    //}
                }
            }
        }

        void SortElementObjects()
        {
            for (int i = 0; i < volumeElements.Count - 1; i++)
            {
                for (int j = 0; j < volumeElements.Count - 1; j++)
                {
                    if (volumeElements[j] != null && volumeElements[j].gameobject.transform.position.y > volumeElements[j + 1].gameobject.transform.position.y)
                    {
                        var temp = volumeElements[j + 1];
                        volumeElements[j + 1] = volumeElements[j];
                        volumeElements[j] = temp;
                    }
                }
            }
        }

        void GetInstancedElements()
        {
            if (volumeElements.Count == 0)
            {
                return;
            }

            var existingMaterials = new List<Material>();

            for (int i = 0; i < volumeElements.Count; i++)
            {
                var element = volumeElements[i];
                var material = element.renderer.sharedMaterial;

                if (material.enableInstancing == true && !existingMaterials.Contains(material) && element.rendererType != RendererType.Particle)
                {
                    existingMaterials.Add(material);
                    volumeInstanced.Add(new TVEElementInstancedData(element.elementType, element.elementLayer, material, null));
                }
            }

            for (int i = 0; i < volumeInstanced.Count; i++)
            {
                var renderersList = new List<Renderer>();

                for (int j = 0; j < volumeElements.Count; j++)
                {
                    var instancedMaterial = volumeInstanced[i].instancedMaterial;
                    var elementMaterial = volumeElements[j].renderer.sharedMaterial;

                    if (instancedMaterial == elementMaterial)
                    {
                        renderersList.Add(volumeElements[j].renderer);
                        volumeElements.Remove(volumeElements[j]);
                        j--;
                    }
                }

                volumeInstanced[i].instancedRenderers = renderersList;
            }
        }

        void SetElementsVisibility()
        {
            if (elementsVisibility == ElementsVisibility.AlwaysHidden)
            {
                DisableElementsVisibility();
            }
            else if (elementsVisibility == ElementsVisibility.AlwaysVisible)
            {
                EnableElementsVisibility();
            }
            else if (elementsVisibility == ElementsVisibility.HiddenInGame)
            {
                if (Application.isPlaying)
                {
                    DisableElementsVisibility();
                }
                else
                {
                    EnableElementsVisibility();
                }
            }
        }

        void EnableElementsVisibility()
        {
            for (int i = 0; i < volumeElements.Count; i++)
            {
                if (volumeElements[i] != null)
                {
#if UNITY_2019_3_OR_NEWER
                    volumeElements[i].renderer.forceRenderingOff = false;
#else
                    volumeElements[i].renderer.enabled = true;
#endif
                }
            }
        }

        void DisableElementsVisibility()
        {
            for (int i = 0; i < volumeElements.Count; i++)
            {
                if (volumeElements[i] != null)
                {
#if UNITY_2019_3_OR_NEWER
                    volumeElements[i].renderer.forceRenderingOff = true;
#else
                    volumeElements[i].renderer.enabled = false;
#endif
                }
            }
        }

#if UNITY_EDITOR
        void OnValidate()
        {
            if (colorsData != null && extrasData != null && motionData != null && reactData != null)
            {
                UpdateVolumeData(colorsData, renderColorsData);
                UpdateVolumeData(extrasData, renderExtrasData);
                UpdateVolumeData(motionData, renderMotionData);
                UpdateVolumeData(reactData, renderReactData);

                CreateRenderBuffers();
            }
        }
#endif
    }
}
