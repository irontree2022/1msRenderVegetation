using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using static UnityEditor.ShaderGraph.Internal.KeywordDependentCollection;

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// 1ms����Ⱦ���ģֲ���ű�
    /// <para>�˽ű��㼯������Ⱦ��������Unity�༭�����ṩͳһ����巽������޸ġ�</para>
    /// <para>�������� MonoBehaviour �������¼�������Ⱦϵͳ�ṩ�����ĳ��������¼���</para>
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


        [Header("---��Ⱦ���Ʋ���ѡ��---")]
        [Header("������Ⱦ��")]
        public bool AllowRendering = true;
        [Header("ģ��ԭ�����ݿ�")]
        public ModelPrototypeDatabase ModelPrototypeDatabase;
        [Header("Ԥ�Ƶ�������")]
        public Settings Settings;
        [Header("�����")]
        public Camera Camera;
        [Header("�޳�ֲ��ComputeShader")]
        public ComputeShader CullVegetationsComputeShader;
        [Header("ʹ�� Procedural ����ʵ����")]
        [Tooltip("true: Graphics.DrawMeshInstancedProcedural; false: Graphics.DrawMeshInstancedIndirect")]
        public bool DrawsWithProcedural = true;
        [Header("�����Ⱦ����")]
        [Tooltip("��������֮��Ĳ��ᱻ��Ⱦ��ʾ")]
        public float MaxRenderingDistance = 512;
        [Header("�������������Ⱦ����")]
        public float MaxCoreRenderingDistance = 100;
        [Header("��Ƭ�������ߴ�")]
        public float ImpostorBlockMaxSize = 1024;
        [Header("��Ƭ������С�ߴ�")]
        public float ImpostorBlockMinSize = 128;
        [Header("�ݵ������Ⱦ����")]
        public float MaxGrassRenderingDistance = 20;
        [Header("����Ⱦ��������ֲ��")]
        public bool OnlyRenderingCore;
        [Header("����Ⱦ��Ƭֲ��")]
        public bool OnlyRenderingImpostor;

        [Space(30)]
        [Header("---�������ѡ��---")]
        [Header("���ԣ���ʾ����ֲ���İ�Χ��")]
        public bool ShowVisibleVegetationBounds;
        [Header("���ԣ���ʾ������ʵ��Χ��")]
        public bool ShowBlockTrueBounds;
        [Header("���ԣ���ʾ����ģ�Ͱ�Χ��")]
        public bool ShowAllModelBounds;
        [Header("���ԣ���ʾ�޳����������")]
        public bool ShowVisibleBlock;
        [Header("���ԣ���ʾ����������")]
        public bool ShowLocalBlockTree;
        [Header("���ԣ�����ʾ����������ID��x: blockID, y: �ݹ���ʾ�ӽڵ㣿")]
        public List<int> OnlyShowBlockIDs;
        public bool[] BlockTreeDepths;


    }

}