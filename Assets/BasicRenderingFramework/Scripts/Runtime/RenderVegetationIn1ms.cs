using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using static UnityEditor.ShaderGraph.Internal.KeywordDependentCollection;

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// 1ms内渲染大规模植被脚本
    /// <para>此脚本汇集所有渲染参数，在Unity编辑器中提供统一的面板方便参数修改。</para>
    /// <para>另外依照 MonoBehaviour 的运行事件，向渲染系统提供基本的程序运行事件。</para>
    /// </summary>
    public class RenderVegetationIn1ms : MonoBehaviour
    {
        private void OnEnable() => RenderingLogic.OnEnable();
        private void OnDisable() => RenderingLogic.OnDisable();
        private void Awake() => RenderingLogic.Awake(this);
        private void Start() => RenderingLogic.Start();
        private void Update() => RenderingLogic.Update();
        private void OnDrawGizmos() => RenderingLogic.OnDrawGizmos();
        private void OnDestroy() => RenderingLogic.OnDestroy();


        [Header("---渲染控制参数选项---")]
        [Header("允许渲染？")]
        public bool AllowRendering = true;
        [Header("模型原型数据库")]
        public ModelPrototypeDatabase ModelPrototypeDatabase;
        [Header("预制的设置项")]
        public Settings Settings;
        [Header("摄像机")]
        public Camera Camera;
        [Header("剔除植被ComputeShader")]
        public ComputeShader CullVegetationsComputeShader;
        [Header("使用 Procedural 绘制实例？")]
        [Tooltip("true: Graphics.DrawMeshInstancedProcedural; false: Graphics.DrawMeshInstancedIndirect")]
        public bool DrawsWithProcedural = true;
        [Header("最大渲染距离")]
        [Tooltip("超出距离之外的不会被渲染显示")]
        public float MaxRenderingDistance = 512;
        [Header("核心区域最大渲染距离")]
        public float MaxCoreRenderingDistance = 100;
        [Header("面片区块最大尺寸")]
        public float ImpostorBlockMaxSize = 1024;
        [Header("面片区块最小尺寸")]
        public float ImpostorBlockMinSize = 128;
        [Header("草的最大渲染距离")]
        public float MaxGrassRenderingDistance = 20;
        [Header("仅渲染核心区块植被")]
        public bool OnlyRenderingCore;
        [Header("仅渲染面片植被")]
        public bool OnlyRenderingImpostor;

        [Space(30)]
        [Header("---调试相关选项---")]
        [Header("调试：显示可视植被的包围盒")]
        public bool ShowVisibleVegetationBounds;
        [Header("调试：显示区块真实包围盒")]
        public bool ShowBlockTrueBounds;
        [Header("调试：显示所有模型包围盒")]
        public bool ShowAllModelBounds;
        [Header("调试：显示剔除后可视区块")]
        public bool ShowVisibleBlock;
        [Header("调试：显示本地区块树")]
        public bool ShowLocalBlockTree;
        [Header("调试：仅显示包含的区块ID；x: blockID, y: 递归显示子节点？")]
        public List<int> OnlyShowBlockIDs;
        public bool[] BlockTreeDepths;


    }

}