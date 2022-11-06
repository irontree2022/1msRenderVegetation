using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Unity.Collections;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Rendering;
using static UnityEditor.MaterialProperty;

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// 模型渲染数据
    /// </summary>
    public class ModelRenderingData
    {
        public int ID;
        public ModelPrototype Model;
        public List<ModelRenderingLOD> LODs;

        public int InstanceCount;
        public VegetationInstanceData[] Instances;
        public NativeArray<VegetationInstanceData> InstancesNativeArray;
        public ComputeBuffer InstancesComputeBuffer;

        public int VisibleLOD0Count;
        public int VisibleLOD1Count;
        public int VisibleLOD2Count;
        public int VisibleLOD3Count;
        public int VisibleLOD4Count;
        public int VegetationBoundsCount;

        public Unity.Collections.NativeArray<int> VisibleLOD0CountNativeArray;
        public Unity.Collections.NativeArray<int> VisibleLOD1CountNativeArray;
        public Unity.Collections.NativeArray<int> VisibleLOD2CountNativeArray;
        public Unity.Collections.NativeArray<int> VisibleLOD3CountNativeArray;
        public Unity.Collections.NativeArray<int> VisibleLOD4CountNativeArray;
        public Unity.Collections.NativeArray<int> VegetationBoundsCountNativeArray;
        public Unity.Collections.NativeArray<VegetationInstanceData> VisibleLOD0NativeArray;
        public Unity.Collections.NativeArray<VegetationInstanceData> VisibleLOD1NativeArray;
        public Unity.Collections.NativeArray<VegetationInstanceData> VisibleLOD2NativeArray;
        public Unity.Collections.NativeArray<VegetationInstanceData> VisibleLOD3NativeArray;
        public Unity.Collections.NativeArray<VegetationInstanceData> VisibleLOD4NativeArray;
        public Unity.Collections.NativeArray<Bounds> VegetationBoundsNativeArray;

        public ComputeBuffer VisibleLOD0ComputeBuffer;
        public ComputeBuffer VisibleLOD1ComputeBuffer;
        public ComputeBuffer VisibleLOD2ComputeBuffer;
        public ComputeBuffer VisibleLOD3ComputeBuffer;
        public ComputeBuffer VisibleLOD4ComputeBuffer;

        public uint[] VegetationBoundsCountArr = new uint[1] { 0 };
        public ComputeBuffer VegetationBoundsCountComputeBuffer;
        public ComputeBuffer VegetationBoundsComputeBuffer;
        public Bounds[] VegetationBoundsDatas;

        public Mesh impostorMesh;
        public Material impostorMaterial;
        public MaterialPropertyBlock impostorMPB;
        public uint[] impostorArgs;
        public int impostorInstancesCount;
        public VegetationInstanceData[] impostorInstances;
        public ComputeBuffer impostorArgsBuffer;



        /// <summary>
        /// 添加植被数据
        /// </summary>
        /// <param name="isCore">来自核心区块的植被数据？</param>
        /// <param name="datas">植被数据</param>
        public void AddVegetationDatas(bool isCore, VegetationInstanceData[] datas)
        {
            if (isCore)
            {
                if (Instances == null) Instances = new VegetationInstanceData[datas.Length];
                else if (InstanceCount + datas.Length > Instances.Length)
                {
                    var _datas = new VegetationInstanceData[InstanceCount + datas.Length];
                    System.Array.Copy(Instances, _datas, InstanceCount);
                    Instances = _datas;
                }
                System.Array.Copy(datas, 0, Instances, InstanceCount, datas.Length);
                InstanceCount += datas.Length;
            }
            else
            {
                if (impostorInstances == null)
                    impostorInstances = new VegetationInstanceData[datas.Length];
                else if(impostorInstancesCount + datas.Length > impostorInstances.Length)
                {
                    var _datas = new VegetationInstanceData[impostorInstancesCount + datas.Length];
                    System.Array.Copy(impostorInstances, _datas, impostorInstancesCount);
                    impostorInstances = _datas;
                }
                System.Array.Copy(datas, 0, impostorInstances, impostorInstancesCount, datas.Length);
                impostorInstancesCount += datas.Length;
            }
        }
        /// <summary>
        /// 准备剔除植被的相关数据
        /// </summary>
        public void PrepareCullVegetationDatas(bool usingJobSystem)
        {
            if (usingJobSystem) PrepareCullVegetationDatasUsingJobSystem();
            else PrepareCullVegetationDatasUsingComputeShader();
        }
        private void PrepareCullVegetationDatasUsingJobSystem()
        {
            if (InstanceCount <= 0) return;
            if (!InstancesNativeArray.IsCreated || InstancesNativeArray.Length < InstanceCount)
            {
                if (InstancesNativeArray.IsCreated)
                    InstancesNativeArray.Dispose();
                InstancesNativeArray = new NativeArray<VegetationInstanceData>(InstanceCount, Allocator.Persistent);
            }
            NativeArray<VegetationInstanceData>.Copy(Instances, InstancesNativeArray, InstanceCount);

            VisibleLOD0Count = 0;
            VisibleLOD1Count = 0;
            VisibleLOD2Count = 0;
            VisibleLOD3Count = 0;
            VisibleLOD4Count = 0;

            if (!VisibleLOD0CountNativeArray.IsCreated)
                VisibleLOD0CountNativeArray = new NativeArray<int>(1, Allocator.Persistent);
            if (!VisibleLOD1CountNativeArray.IsCreated)
                VisibleLOD1CountNativeArray = new NativeArray<int>(1, Allocator.Persistent);
            if (!VisibleLOD2CountNativeArray.IsCreated)
                VisibleLOD2CountNativeArray = new NativeArray<int>(1, Allocator.Persistent);
            if (!VisibleLOD3CountNativeArray.IsCreated)
                VisibleLOD3CountNativeArray = new NativeArray<int>(1, Allocator.Persistent);
            if (!VisibleLOD4CountNativeArray.IsCreated)
                VisibleLOD4CountNativeArray = new NativeArray<int>(1, Allocator.Persistent);
            if (!VegetationBoundsCountNativeArray.IsCreated)
                VegetationBoundsCountNativeArray = new NativeArray<int>(1, Allocator.Persistent);

            if (!VisibleLOD0NativeArray.IsCreated || VisibleLOD0NativeArray.Length < InstanceCount)
            {
                if (VisibleLOD0NativeArray.IsCreated)
                    VisibleLOD0NativeArray.Dispose();
                VisibleLOD0NativeArray = new NativeArray<VegetationInstanceData>(InstanceCount, Allocator.Persistent);
            }
            if (!VisibleLOD1NativeArray.IsCreated || VisibleLOD1NativeArray.Length < InstanceCount)
            {
                if (VisibleLOD1NativeArray.IsCreated)
                    VisibleLOD1NativeArray.Dispose();
                VisibleLOD1NativeArray = new NativeArray<VegetationInstanceData>(InstanceCount, Allocator.Persistent);
            }
            if (!VisibleLOD2NativeArray.IsCreated || VisibleLOD2NativeArray.Length < InstanceCount)
            {
                if (VisibleLOD2NativeArray.IsCreated)
                    VisibleLOD2NativeArray.Dispose();
                VisibleLOD2NativeArray = new NativeArray<VegetationInstanceData>(InstanceCount, Allocator.Persistent);
            }
            if (!VisibleLOD3NativeArray.IsCreated || VisibleLOD3NativeArray.Length < InstanceCount)
            {
                if (VisibleLOD3NativeArray.IsCreated)
                    VisibleLOD3NativeArray.Dispose();
                VisibleLOD3NativeArray = new NativeArray<VegetationInstanceData>(InstanceCount, Allocator.Persistent);
            }
            if (!VisibleLOD4NativeArray.IsCreated || VisibleLOD4NativeArray.Length < InstanceCount)
            {
                if (VisibleLOD4NativeArray.IsCreated)
                    VisibleLOD4NativeArray.Dispose();
                VisibleLOD4NativeArray = new NativeArray<VegetationInstanceData>(InstanceCount, Allocator.Persistent);
            }
            if (!VegetationBoundsNativeArray.IsCreated || VegetationBoundsNativeArray.Length < InstanceCount)
            {
                if (VegetationBoundsNativeArray.IsCreated)
                    VegetationBoundsNativeArray.Dispose();
                VegetationBoundsNativeArray = new NativeArray<Bounds>(InstanceCount, Allocator.Persistent);
            }
        }
        private void PrepareCullVegetationDatasUsingComputeShader()
        {
            if (LODs == null) InitLODs(false);
            if (InstanceCount > 0)
            {
                if (InstancesComputeBuffer == null || InstancesComputeBuffer.count < InstanceCount)
                {
                    InstancesComputeBuffer?.Release();
                    InstancesComputeBuffer = new ComputeBuffer(InstanceCount, VegetationInstanceData.stride);
                }
                InstancesComputeBuffer.SetData(Instances, 0, 0, InstanceCount);

                if (VisibleLOD0ComputeBuffer == null || VisibleLOD0ComputeBuffer.count < InstanceCount)
                {
                    VisibleLOD0ComputeBuffer?.Release();
                    VisibleLOD0ComputeBuffer = new ComputeBuffer(InstanceCount * 2, VegetationInstanceData.stride, ComputeBufferType.Append);
                    ResetLODsMPB(0);
                }
                if (VisibleLOD1ComputeBuffer == null || VisibleLOD1ComputeBuffer.count < InstanceCount)
                {
                    VisibleLOD1ComputeBuffer?.Release();
                    VisibleLOD1ComputeBuffer = new ComputeBuffer(InstanceCount * 2, VegetationInstanceData.stride, ComputeBufferType.Append);
                    ResetLODsMPB(1);
                }
                if (VisibleLOD2ComputeBuffer == null || VisibleLOD2ComputeBuffer.count < InstanceCount)
                {
                    VisibleLOD2ComputeBuffer?.Release();
                    VisibleLOD2ComputeBuffer = new ComputeBuffer(InstanceCount * 2, VegetationInstanceData.stride, ComputeBufferType.Append);
                    ResetLODsMPB(2);
                }
                if (VisibleLOD3ComputeBuffer == null || VisibleLOD3ComputeBuffer.count < InstanceCount)
                {
                    VisibleLOD3ComputeBuffer?.Release();
                    VisibleLOD3ComputeBuffer = new ComputeBuffer(InstanceCount * 2, VegetationInstanceData.stride, ComputeBufferType.Append);
                    ResetLODsMPB(3);
                }
                var impostorCount = InstanceCount + impostorInstancesCount;
                if (VisibleLOD4ComputeBuffer == null || VisibleLOD4ComputeBuffer.count < impostorCount)
                {
                    VisibleLOD4ComputeBuffer?.Release();
                    VisibleLOD4ComputeBuffer = new ComputeBuffer(impostorCount * 2, VegetationInstanceData.stride, ComputeBufferType.Append);
                    ResetLODsMPB(4);
                }
                VisibleLOD0ComputeBuffer.SetCounterValue(0);
                VisibleLOD1ComputeBuffer.SetCounterValue(0);
                VisibleLOD2ComputeBuffer.SetCounterValue(0);
                VisibleLOD3ComputeBuffer.SetCounterValue(0);
                VisibleLOD4ComputeBuffer.SetCounterValue(0);

                if (VegetationBoundsCountComputeBuffer == null)
                    VegetationBoundsCountComputeBuffer = new ComputeBuffer(1, sizeof(uint), ComputeBufferType.IndirectArguments);
                if (VegetationBoundsComputeBuffer == null || VegetationBoundsComputeBuffer.count < InstanceCount)
                {
                    VegetationBoundsComputeBuffer?.Release();
                    VegetationBoundsComputeBuffer = new ComputeBuffer(InstanceCount * 2, sizeof(float) * 6, ComputeBufferType.Append);
                }
                VegetationBoundsComputeBuffer.SetCounterValue(0);
            }

            if (impostorInstancesCount > 0)
            {
                int impostorCount = InstanceCount + impostorInstancesCount;
                if (VisibleLOD4ComputeBuffer == null || VisibleLOD4ComputeBuffer.count < impostorCount)
                {
                    VisibleLOD4ComputeBuffer?.Release();
                    VisibleLOD4ComputeBuffer = new ComputeBuffer(impostorCount * 2, VegetationInstanceData.stride, ComputeBufferType.Append);
                    ResetLODsMPB(4);
                }
                VisibleLOD4ComputeBuffer.SetData(impostorInstances, 0, 0, impostorInstancesCount);
                VisibleLOD4ComputeBuffer.SetCounterValue((uint)impostorInstancesCount);
            }

        }
        /// <summary>
        /// 初始化LOD数据
        /// </summary>
        /// <param name="usingJobSystem">使用JobSystem渲染植被数据？</param>
        public void InitLODs(bool usingJobSystem)
        {
            if (Model.enableRenderImpostor)
            {
                impostorMesh = Model.PrefabImpostor.GetComponent<MeshFilter>().sharedMesh;
                impostorMaterial = Model.PrefabImpostor.GetComponent<MeshRenderer>().sharedMaterial;
                if (impostorMaterial != null && !impostorMaterial.enableInstancing) impostorMaterial.enableInstancing = true;
                if (impostorMPB == null) impostorMPB = new MaterialPropertyBlock();
                else impostorMPB.Clear();
                if (impostorMesh && !usingJobSystem)
                {
                    impostorArgsBuffer?.Release();
                    impostorArgsBuffer = new ComputeBuffer(1, sizeof(uint) * 5, ComputeBufferType.IndirectArguments);
                    impostorArgs = new uint[5] { 0, 0, 0, 0, 0 };
                    impostorArgs[0] = impostorMesh.GetIndexCount(0);
                    impostorArgs[1] = 0;
                    impostorArgs[2] = impostorMesh.GetIndexStart(0);
                    impostorArgs[3] = impostorMesh.GetBaseVertex(0);
                    impostorArgs[4] = 0;
                    impostorArgsBuffer.SetData(impostorArgs);
                }
            }
            LODs = new List<ModelRenderingLOD>();
            if (Model.isLODGroup)
            {
                var lodgroup = Model.PrefabObject.GetComponent<LODGroup>();
                var lods = lodgroup.GetLODs();
                for (int i = 0; i < lods.Length; i++)
                {
                    if (i > 3) continue;
                    var LOD = new ModelRenderingLOD();
                    LOD.renderers = new List<ModelRenderer>();
                    LODs.Add(LOD);
                    if (lods[i].renderers == null) continue;
                    for (int j = 0; j < lods[i].renderers.Length; j++)
                    {
                        if (lods[i].renderers[j] == null || lods[i].renderers[j].gameObject == null) continue;
                        var mf = lods[i].renderers[j].gameObject.GetComponent<MeshFilter>();
                        var mr = lods[i].renderers[j].gameObject.GetComponent<MeshRenderer>();
                        if (lods[i].renderers[j].sharedMaterials == null || mf == null || mf.sharedMesh == null || mr == null) continue;
                        var renderer = new ModelRenderer();
                        renderer.materials = new List<Material>();
                        LOD.renderers.Add(renderer);
                        renderer.materials.AddRange(lods[i].renderers[j].sharedMaterials);
                        renderer.mesh = mf.sharedMesh;
                        renderer.mpb = new MaterialPropertyBlock();
                        renderer.AutoSetup();
                    }
                }
            }
            else
            {
                var LOD = new ModelRenderingLOD();
                LOD.renderers = new List<ModelRenderer>();
                LODs.Add(LOD);
                var mf = Model.PrefabObject.GetComponent<MeshFilter>();
                var mr = Model.PrefabObject.GetComponent<MeshRenderer>();
                if (mr != null && mf != null)
                {
                    var mesh = mf.sharedMesh;
                    var materials = mr.sharedMaterials;
                    if (mesh != null && materials != null)
                    {
                        var renderer = new ModelRenderer();
                        LOD.renderers.Add(renderer);
                        renderer.materials = new List<Material>();
                        renderer.materials.AddRange(materials);
                        renderer.mesh = mesh;
                        renderer.mpb = new MaterialPropertyBlock();
                        renderer.AutoSetup();
                    }
                }
            }

            // argsbuffers
            for (int lod = 0; !usingJobSystem && lod < LODs.Count; lod++)
            {
                var LOD = LODs[lod];
                for (int r = 0; r < LOD.renderers.Count; r++)
                {
                    var renderer = LOD.renderers[r];
                    if (renderer.argsList == null)
                        renderer.argsList = new List<uint[]>();
                    if (renderer.argsBufferList == null)
                        renderer.argsBufferList = new List<ComputeBuffer>();
                    int submeshesToRender = Mathf.Min(renderer.subMeshCount, renderer.materials.Count);
                    for (int j = 0; j < submeshesToRender; j++)
                    {
                        var args = new uint[5] { 0, 0, 0, 0, 0 };
                        args[0] = renderer.mesh.GetIndexCount(j); // index count per instance
                        args[1] = 0;// (uint)runtimeData.bufferSize;
                        args[2] = renderer.mesh.GetIndexStart(j); // start index location
                        args[3] = renderer.mesh.GetBaseVertex(j); // base vertex location
                        args[4] = 0; // start instance location
                        renderer.argsList.Add(args);
                        var argsbuffer = new ComputeBuffer(1, sizeof(uint) * 5, ComputeBufferType.IndirectArguments);
                        argsbuffer.SetData(args);
                        renderer.argsBufferList.Add(argsbuffer);
                    }
                }
            }

        }
        /// <summary>
        /// 重新设置LODs的材质属性快
        /// </summary>
        /// <param name="lod">lod</param>
        public void ResetLODsMPB(int lod)
        {
            if (LODs == null) return;
            if(lod == 4)
            {
                if (Model.enableRenderImpostor)
                {
                    impostorMPB.Clear();
                    impostorMPB.SetBuffer(RenderingAPI.RenderVars.ShaderName_IndirectShaderDataBuffer_ID, VisibleLOD4ComputeBuffer);
                }
                return;
            }
            if (lod >= LODs.Count) return;
            ComputeBuffer cb = null;
            switch (lod)
            {
                case 0:
                    cb = VisibleLOD0ComputeBuffer;
                    break;
                case 1:
                    cb = VisibleLOD1ComputeBuffer;
                    break;
                case 2:
                    cb = VisibleLOD2ComputeBuffer;
                    break;
                case 3:
                    cb = VisibleLOD3ComputeBuffer;
                    break;
            }
            if (cb == null) return;

            var LOD = LODs[lod];
            for(var i = 0; i < LOD.renderers.Count; i++)
            {
                var renderer = LOD.renderers[i];
                renderer.mpb.Clear();
                renderer.mpb.SetBuffer(RenderingAPI.RenderVars.ShaderName_IndirectShaderDataBuffer_ID, cb);
            }
        }

        public void Clear()
        {
            if (LODs != null)
            {
                for(var i = 0; i < LODs.Count; i++)
                    LODs[i].Clear();
                LODs.Clear();
                LODs = null;
            }

            InstanceCount = 0;
            Instances = null;
            if (InstancesNativeArray.IsCreated)
                InstancesNativeArray.Dispose();
            InstancesComputeBuffer?.Release();



            if (VisibleLOD0CountNativeArray.IsCreated)
                VisibleLOD0CountNativeArray.Dispose();
            if (VisibleLOD1CountNativeArray.IsCreated)
                VisibleLOD1CountNativeArray.Dispose();
            if (VisibleLOD2CountNativeArray.IsCreated)
                VisibleLOD2CountNativeArray.Dispose();
            if (VisibleLOD3CountNativeArray.IsCreated)
                VisibleLOD3CountNativeArray.Dispose();
            if (VisibleLOD4CountNativeArray.IsCreated)
                VisibleLOD4CountNativeArray.Dispose();
            if (VegetationBoundsCountNativeArray.IsCreated)
                VegetationBoundsCountNativeArray.Dispose();


            if (VisibleLOD0NativeArray.IsCreated)
                VisibleLOD0NativeArray.Dispose();
            if (VisibleLOD1NativeArray.IsCreated)
                VisibleLOD1NativeArray.Dispose();
            if (VisibleLOD2NativeArray.IsCreated)
                VisibleLOD2NativeArray.Dispose();
            if (VisibleLOD3NativeArray.IsCreated)
                VisibleLOD3NativeArray.Dispose();
            if (VisibleLOD4NativeArray.IsCreated)
                VisibleLOD4NativeArray.Dispose();
            if (VegetationBoundsNativeArray.IsCreated)
                VegetationBoundsNativeArray.Dispose();


            VisibleLOD0ComputeBuffer?.Release();
            VisibleLOD1ComputeBuffer?.Release();
            VisibleLOD2ComputeBuffer?.Release();
            VisibleLOD3ComputeBuffer?.Release();
            VisibleLOD4ComputeBuffer?.Release();
            VisibleLOD0ComputeBuffer = null;
            VisibleLOD1ComputeBuffer = null;
            VisibleLOD2ComputeBuffer = null;
            VisibleLOD3ComputeBuffer = null;
            VisibleLOD4ComputeBuffer = null;


            VegetationBoundsCountComputeBuffer?.Release();
            VegetationBoundsComputeBuffer?.Release();
            VegetationBoundsCountComputeBuffer = null;
            VegetationBoundsComputeBuffer = null;
            VegetationBoundsDatas = null;


            impostorMesh = null;
            impostorMaterial = null;
            if (impostorMPB != null)
                impostorMPB.Clear();
            impostorMPB = null;
            impostorArgs = null;
            impostorInstancesCount = 0;
            impostorInstances = null;
            impostorArgsBuffer?.Release();

        }
    }

}