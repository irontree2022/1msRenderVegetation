using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// 区块数据
    /// </summary>
    public struct Block
    {
        /// <summary>
        /// 当前区块的编号
        /// <para>与当前区块节点的ID值一致</para>
        /// </summary>
        public int ID;
        /// <summary>
        /// 是否是叶子节点
        /// </summary>
        public bool IsLeaf
        {
            get => _IsLeaf != 0;
            set => _IsLeaf = value ? 1 : 0;
        }
        /// <summary>
        /// 是否是叶子节点
        /// </summary>
        public int _IsLeaf;
        /// <summary>
        /// 初始包围盒
        /// </summary>
        public Bounds Bounds;
        /// <summary>
        /// 实际包围盒
        /// </summary>
        public Bounds TrueBounds;
        /// <summary>
        /// 空节点？
        /// <para>如果内部不存在植被数据，则视为空节点，反之不是空节点。</para>
        /// </summary>
        public bool Empty
        {
            get => _Empty != 0;
            set => _Empty = value ? 1 : 0;
        }
        /// <summary>
        /// 空节点？
        /// <para>如果内部不存在植被数据，则视为空节点，反之不是空节点。</para>
        /// <para>定义为int类型原因：使之可以在ComputeBuffer中作为元素时也可以使用。</para>
        /// <para>使用bool值的话，则会出现以下报错信息：</para>
        /// <para>Invalid stride 9 for Compute Buffer - must be greater than 0, less or equal to 2048 and a multiple of 4.</para>
        /// <para>ArgumentException: Array passed to ComputeBuffer.SetData(array) must be blittable.</para>
        /// <para>bool is not blittable (System.Boolean)</para>
        /// </summary>
        public int _Empty;



        /// <summary>
        /// 当前数据可用？
        /// </summary>
        public int _available;
        /// <summary>
        /// 是否是核心区域
        /// </summary>
        public int _IsCore;
        /// <summary>
        /// 是否是面片区域
        /// </summary>
        public int _IsImpostor;
        /// <summary>
        /// 核心区块的八个顶点是否全部处于视锥体之内
        /// </summary>
        public int _IsCoreAllInPlanes;
        /// <summary>
        /// 面片区块剔除时，指示该面片区块是否可以继续收集它的子节点
        /// </summary>
        public int _IsImpostorNeedCollected;
        /// <summary>
        /// 是否是阴影区块
        /// </summary>
        public int _IsShadow;

        /// <summary>
        /// 当前数据可用？
        /// </summary>
        public bool available
        {
            get => _available != 0;
            set => _available = value ? 1 : 0;
        }
        /// <summary>
        /// 是否是核心区域
        /// </summary>
        public bool IsCore
        {
            get => _IsCore != 0;
            set => _IsCore = value ? 1 : 0;
        }
        /// <summary>
        /// 是否是面片区域
        /// </summary>
        public bool IsImpostor
        {
            get => _IsImpostor != 0;
            set => _IsImpostor = value ? 1 : 0;
        }
        /// <summary>
        /// 核心区块的八个顶点是否全部处于视锥体之内
        /// </summary>
        public bool IsCoreAllInPlanes
        {
            get => _IsCoreAllInPlanes != 0;
            set => _IsCoreAllInPlanes = value ? 1 : 0;
        }
        /// <summary>
        /// 面片区块剔除时，指示该面片区块是否可以继续收集它的子节点
        /// </summary>
        public bool IsImpostorNeedCollected
        {
            get => _IsImpostorNeedCollected != 0;
            set => _IsImpostorNeedCollected = value ? 1 : 0;
        }
        /// <summary>
        /// 是否是阴影区块
        /// </summary>
        public bool IsShadow
        {
            get => _IsShadow != 0;
            set => _IsShadow = value ? 1 : 0;
        }

        /// <summary>
        /// 单个实例所占字节数
        /// </summary>
        public static int stride => sizeof(float) * 12 + sizeof(int) * 9;
        public override string ToString() => $"(ID: {ID}, Empty: {Empty}, Bounds: (center: {Bounds.center}, size: {Bounds.size}), TrueBounds: (center: {TrueBounds.center}, size: {TrueBounds.size}))";
    }

}