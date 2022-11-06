using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

namespace RenderVegetationIn1ms
{ 
    /// <summary>
    /// 模型渲染LOD数据
    /// </summary>
    public class ModelRenderingLOD
    {
        public List<ModelRenderer> renderers;

        public void Clear()
        {
            if (renderers == null)
                return;

            for (var i = 0; i < renderers.Count; i++)
                if (renderers[i] != null)
                    renderers[i].Clear();
            renderers.Clear();
            renderers = null;
        }
    }

    /// <summary>
    /// 模型渲染渲染数据
    /// </summary>
    public class ModelRenderer
    {
        public Mesh mesh;
        public int subMeshCount;
        public List<Material> materials;
        public MaterialPropertyBlock mpb;
        public List<uint[]>argsList;
        public List<ComputeBuffer> argsBufferList;
        public void AutoSetup()
        {
            subMeshCount = mesh.subMeshCount;
            for (var i = 0; materials != null && i < materials.Count; i++)
            {
                var mt = materials[i];
                if (mt != null && !mt.enableInstancing) mt.enableInstancing = true;
            }
        }
        public void Clear()
        {
            if (materials != null)
            {
                materials.Clear();
                materials = null;
            }
            if (mpb != null)
            {
                mpb.Clear();
                mpb = null;
            }
            if (argsBufferList != null)
            {
                for (var i = 0; i < argsBufferList.Count; i++)
                    argsBufferList[i]?.Release();
                argsBufferList.Clear();
                argsBufferList = null;
            }
        }
    }
}
