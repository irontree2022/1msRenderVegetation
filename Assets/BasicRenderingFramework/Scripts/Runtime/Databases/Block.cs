using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// ��������
    /// </summary>
    public struct Block
    {
        /// <summary>
        /// ��ǰ����ı��
        /// <para>�뵱ǰ����ڵ��IDֵһ��</para>
        /// </summary>
        public int ID;
        /// <summary>
        /// �Ƿ���Ҷ�ӽڵ�
        /// </summary>
        public bool IsLeaf
        {
            get => _IsLeaf != 0;
            set => _IsLeaf = value ? 1 : 0;
        }
        /// <summary>
        /// �Ƿ���Ҷ�ӽڵ�
        /// </summary>
        public int _IsLeaf;
        /// <summary>
        /// ��ʼ��Χ��
        /// </summary>
        public Bounds Bounds;
        /// <summary>
        /// ʵ�ʰ�Χ��
        /// </summary>
        public Bounds TrueBounds;
        /// <summary>
        /// �սڵ㣿
        /// <para>����ڲ�������ֲ�����ݣ�����Ϊ�սڵ㣬��֮���ǿսڵ㡣</para>
        /// </summary>
        public bool Empty
        {
            get => _Empty != 0;
            set => _Empty = value ? 1 : 0;
        }
        /// <summary>
        /// �սڵ㣿
        /// <para>����ڲ�������ֲ�����ݣ�����Ϊ�սڵ㣬��֮���ǿսڵ㡣</para>
        /// <para>����Ϊint����ԭ��ʹ֮������ComputeBuffer����ΪԪ��ʱҲ����ʹ�á�</para>
        /// <para>ʹ��boolֵ�Ļ������������±�����Ϣ��</para>
        /// <para>Invalid stride 9 for Compute Buffer - must be greater than 0, less or equal to 2048 and a multiple of 4.</para>
        /// <para>ArgumentException: Array passed to ComputeBuffer.SetData(array) must be blittable.</para>
        /// <para>bool is not blittable (System.Boolean)</para>
        /// </summary>
        public int _Empty;



        /// <summary>
        /// ��ǰ���ݿ��ã�
        /// </summary>
        public int _available;
        /// <summary>
        /// �Ƿ��Ǻ�������
        /// </summary>
        public int _IsCore;
        /// <summary>
        /// �Ƿ�����Ƭ����
        /// </summary>
        public int _IsImpostor;
        /// <summary>
        /// ��������İ˸������Ƿ�ȫ��������׶��֮��
        /// </summary>
        public int _IsCoreAllInPlanes;
        /// <summary>
        /// ��Ƭ�����޳�ʱ��ָʾ����Ƭ�����Ƿ���Լ����ռ������ӽڵ�
        /// </summary>
        public int _IsImpostorNeedCollected;
        /// <summary>
        /// �Ƿ�����Ӱ����
        /// </summary>
        public int _IsShadow;

        /// <summary>
        /// ��ǰ���ݿ��ã�
        /// </summary>
        public bool available
        {
            get => _available != 0;
            set => _available = value ? 1 : 0;
        }
        /// <summary>
        /// �Ƿ��Ǻ�������
        /// </summary>
        public bool IsCore
        {
            get => _IsCore != 0;
            set => _IsCore = value ? 1 : 0;
        }
        /// <summary>
        /// �Ƿ�����Ƭ����
        /// </summary>
        public bool IsImpostor
        {
            get => _IsImpostor != 0;
            set => _IsImpostor = value ? 1 : 0;
        }
        /// <summary>
        /// ��������İ˸������Ƿ�ȫ��������׶��֮��
        /// </summary>
        public bool IsCoreAllInPlanes
        {
            get => _IsCoreAllInPlanes != 0;
            set => _IsCoreAllInPlanes = value ? 1 : 0;
        }
        /// <summary>
        /// ��Ƭ�����޳�ʱ��ָʾ����Ƭ�����Ƿ���Լ����ռ������ӽڵ�
        /// </summary>
        public bool IsImpostorNeedCollected
        {
            get => _IsImpostorNeedCollected != 0;
            set => _IsImpostorNeedCollected = value ? 1 : 0;
        }
        /// <summary>
        /// �Ƿ�����Ӱ����
        /// </summary>
        public bool IsShadow
        {
            get => _IsShadow != 0;
            set => _IsShadow = value ? 1 : 0;
        }

        /// <summary>
        /// ����ʵ����ռ�ֽ���
        /// </summary>
        public static int stride => sizeof(float) * 12 + sizeof(int) * 9;
        public override string ToString() => $"(ID: {ID}, Empty: {Empty}, Bounds: (center: {Bounds.center}, size: {Bounds.size}), TrueBounds: (center: {TrueBounds.center}, size: {TrueBounds.size}))";
    }

}