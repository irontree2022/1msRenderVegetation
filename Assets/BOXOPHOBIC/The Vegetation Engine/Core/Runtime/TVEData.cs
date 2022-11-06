// Cristian Pop - https://boxophobic.com/

using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace TheVegetationEngine
{
    public enum BufferType
    {
        Undefined = -1,
        Colors = 10,
        Extras = 20,
        Motion = 30,
        React = 40,
        Custom = 100,
    }

    public enum RendererType
    {
        Mesh = 0,
        Particle = 1,
        Trail = 2,
        //Line = 3,
    }

    public enum PropertyType
    {
        Texture = 0,
        Vector = 1,
        Value = 2,
    }

    [System.Serializable]
    public class TVEElementMaterialData
    {
        public Shader shader;
        public List<TVEElementPropertyData> props;

        public TVEElementMaterialData()
        {

        }
    }

    [System.Serializable]
    public class TVEElementPropertyData
    {
        public PropertyType type;
        public string prop;
        public Texture texture;
        public Vector4 vector;
        public float value;

        public TVEElementPropertyData(PropertyType type, string prop, Texture texture)
        {
            this.type = type;
            this.prop = prop;
            this.texture = texture;
        }

        public TVEElementPropertyData(PropertyType type, string prop, Vector4 vector)
        {
            this.type = type;
            this.prop = prop;
            this.vector = vector;
        }

        public TVEElementPropertyData(PropertyType type, string prop, float value)
        {
            this.type = type;
            this.prop = prop;
            this.value = value;
        }
    }

    [System.Serializable]
    public class TVEElementDrawerData
    {
        public BufferType elementType;
        public int elementLayer;
        public RendererType rendererType;
        public GameObject gameobject;
        public Mesh mesh;
        public Renderer renderer;

        public TVEElementDrawerData(BufferType elementType, int elementLayer, RendererType rendererType, GameObject gameobject, Mesh mesh, Renderer renderer)
        {
            this.elementType = elementType;
            this.elementLayer = elementLayer;
            this.rendererType = rendererType;
            this.gameobject = gameobject;
            this.mesh = mesh;
            this.renderer = renderer;
        }
    }

    [System.Serializable]
    public class TVEElementInstancedData
    {
        public BufferType elementType;
        public int elementLayer;
        public Material instancedMaterial;
        public List<Renderer> instancedRenderers;

        public TVEElementInstancedData(BufferType elementType, int elementLayer, Material instancedMaterial, List<Renderer> instancedRenderers)
        {
            this.elementType = elementType;
            this.elementLayer = elementLayer;
            this.instancedMaterial = instancedMaterial;
            this.instancedRenderers = instancedRenderers;
        }
    }

    [System.Serializable]
    public class TVEVolumeData
    {
        public bool enabled;
        public bool isUpdated;
        public BufferType bufferType;
        public RenderTexture internalTex;
        public RenderTextureFormat internalFormat;
        public int internalResolution;
        public string internalTexName;
        public string internalTexCoord;
        public string internalTexUsage;
        public CommandBuffer[] internalBuffer;
        public int internalBufferSize = 0;
        public float[] internalBufferUsage;
        public bool followMainCamera;

        public TVEVolumeData()
        {

        }
    }
}