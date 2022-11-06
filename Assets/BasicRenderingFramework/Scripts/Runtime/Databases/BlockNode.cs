using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq.Expressions;
using System.Runtime.CompilerServices;
using Unity.VisualScripting;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    public class BlockNode
    {
        /// <summary>
        /// ��ǰ����ڵ���
        /// </summary>
        public int ID;
        /// <summary>
        /// ��ǰ�������
        /// </summary>
        public int Depth;
        /// <summary>
        /// �Ƿ���Ҷ�ӽڵ�
        /// </summary>
        public bool IsLeaf;
        /// <summary>
        /// ��������
        /// </summary>
        public Block Block;
        /// <summary>
        /// ���ڵ�
        /// </summary>
        public BlockNode Parent;
        /// <summary>
        /// �ӽڵ�
        /// </summary>
        public BlockNode[] Childs;
        /// <summary>
        /// û�пյ����ӽڵ�
        /// </summary>
        public BlockNode[] NoEmptyChilds;

        /// <summary>
        /// �սڵ㣿
        /// <para>����ڲ�������ֲ�����ݣ�����Ϊ�սڵ㣬��֮���ǿսڵ㡣</para>
        /// </summary>
        public bool Empty;
        /// <summary>
        /// ������ֲ����������
        /// </summary>
        public int TotalDataCount;


        public override string ToString()
        {
            var parent = Parent == null ? "null" : Parent.ID.ToString();
            return $"(ID: {ID}, Depth: {Depth}, ��������: {TotalDataCount}, Parent��{parent}, Size: {Block.Bounds.size}, TrueSize: {Block.TrueBounds.size})";
        }


        /// <summary>
        /// ��������ڵ�
        /// </summary>
        /// <param name="nodeBounds">�����Χ��</param>
        /// <param name="nextBlockReductionFactor">��һ��������С����</param>
        /// <param name="minBlockSize">��С����ߴ�</param>
        /// <param name="blockNodes">�ռ�����ڵ������</param>
        /// <returns>���ش���������ڵ�</returns>
        public static BlockNode CreateBlockNode(Bounds nodeBounds, int depth, int nextBlockReductionFactor, int minBlockSize, List<BlockNode> blockNodes)
        {
            var blockNode = new BlockNode();
            blockNodes.Add(blockNode);
            var nodeSize = nodeBounds.size;
            if (nodeSize.x < 2) nodeSize.x = 2;
            if (nodeSize.z < 2) nodeSize.z = 2;
            nodeSize.x = Tool.GetPowerOf2Value(nodeSize.x);
            nodeSize.z = Tool.GetPowerOf2Value(nodeSize.z);
            nodeBounds.size = nodeSize;

            blockNode.Empty = true;
            blockNode.ID = -1;
            blockNode.Depth = depth;
            blockNode.Block = new Block();
            blockNode.Block.ID = -1;
            blockNode.Block.Empty = true;
            blockNode.Block.Bounds = nodeBounds;
            if (nodeSize.x > minBlockSize && nodeSize.z > minBlockSize)
            {
                var splitBounds = Tool.GetSplitBounds(nodeBounds, nextBlockReductionFactor);
                if (splitBounds.Count > 0)
                {
                    blockNode.Childs = new BlockNode[splitBounds.Count];
                    for (var i = 0; i < blockNode.Childs.Length; i++)
                    {
                        var child = CreateBlockNode(splitBounds[i], depth + 1, nextBlockReductionFactor, minBlockSize, blockNodes);
                        child.Parent = blockNode;
                        blockNode.Childs[i] = child;
                    }
                }
            }
            else
            {
                blockNode.IsLeaf = true;
                blockNode.Block.IsLeaf = false;
            }
            return blockNode;
        }
        /// <summary>
        /// ƥ��ֲ������
        /// <para>�ж�ֲ������λ���ĸ������У����ҽ�ֲ�����ݷ�����������</para>
        /// </summary>
        /// <param name="vid">ֲ������</param>
        /// <param name="blockVegetationDatas">��ֲ�����ݷ�������ʵ�������</param>
        /// <param name="maxDataCountInSingleBlock">��������ֲ���������ֵ</param>
        /// <returns>ƥ��ɹ���ture����ʾ����ֲ��һֱƥ�䵽Ҷ�ӽڵ㣻false����ʾ����ƥ�䵽Ҷ�ӽڵ�</returns>
        public bool MatchVegetationData(VegetationInstanceData vid, BlockVegetationDatas[] blockVegetationDatas, int maxDataCountInSingleBlock)
        {
            var match = Tool.IsInBounds(vid.center, Block.Bounds.min, Block.Bounds.max);
            if (match)
            {
                AddVegetationData(vid, blockVegetationDatas, maxDataCountInSingleBlock);

                if (Childs != null)
                {
                    for (var i = 0; i < Childs.Length; i++)
                    {
                        var child = Childs[i];
                        if (child.MatchVegetationData(vid, blockVegetationDatas, maxDataCountInSingleBlock))
                            break;
                    }
                }
            }
            return match;
        }
        /// <summary>
        /// ƥ��ֲ������
        /// <para>�ж�ֲ�����ݾ����ĸ������������ֲ�����ݷ�����������</para>
        /// </summary>
        /// <param name="vid">ֲ������</param>
        /// <param name="blockVegetationDatas">��ֲ�����ݷ�������ʵ�������</param>
        /// <param name="maxDataCountInSingleBlock">��������ֲ���������ֵ</param>
        public void MatchVegetationDataByDistance(VegetationInstanceData vid, BlockVegetationDatas[] blockVegetationDatas, int maxDataCountInSingleBlock)
        {
            AddVegetationData(vid, blockVegetationDatas, maxDataCountInSingleBlock);
            if(Childs != null)
            {
                BlockNode childNode = null;
                var _dist = float.MaxValue;
                for(var i = 0; i < Childs.Length; i++)
                {
                    var child = Childs[i];
                    var dist = Tool.Distance(vid.center, child.Block.Bounds.min, child.Block.Bounds.max);
                    if (dist < _dist)
                    {
                        _dist = dist;
                        childNode = child;
                    }
                }
                childNode.MatchVegetationDataByDistance(vid, blockVegetationDatas, maxDataCountInSingleBlock);
            }
        }
        public void AddVegetationData(VegetationInstanceData vid, BlockVegetationDatas[] blockVegetationDatas, int maxDataCountInSingleBlock)
        {
            var vidBounds = new Bounds();
            vidBounds.center = vid.center;
            vidBounds.extents = vid.extents;
            if (Empty) Block.TrueBounds = vidBounds;
            else Block.TrueBounds.Encapsulate(vidBounds);

            Empty = false;
            Block.Empty = false;

            ++TotalDataCount;

            if (blockVegetationDatas[ID] == null)
            {
                blockVegetationDatas[ID] = new BlockVegetationDatas();
                blockVegetationDatas[ID].ID = ID;
            }
            var status = blockVegetationDatas[ID];

            ++status.TotalDataCount;
            if (status.ModelPrototypeCount == 0)
            {
                status.ModelPrototypeCount = 1;
                status.ModelPrototypeIDs = new int[1];
                status.ModelPrototypeIDs[0] = vid.ModelPrototypeID;
                status.Datas = new List<VegetationInstanceData>[1];
                status.Datas[0] = new List<VegetationInstanceData>(1) { vid };
            }
            else
            {
                var modelPrototypeIndex = -1;
                for (var i = 0; i < status.ModelPrototypeCount; i++)
                {
                    if (status.ModelPrototypeIDs[i] == vid.ModelPrototypeID)
                    {
                        modelPrototypeIndex = i;
                        break;
                    }
                }

                if (status.TotalDataCount > maxDataCountInSingleBlock)
                {
                    status.Datas = null;
                    status.TooMuchData = true;
                }
                if (!status.TooMuchData)
                {
                    if (modelPrototypeIndex == -1)
                    {
                        var length = status.ModelPrototypeIDs.Length;
                        var datas = new List<VegetationInstanceData>[length + 1];
                        System.Array.Copy(status.Datas, datas, length);
                        status.Datas = datas;
                        status.Datas[length] = new List<VegetationInstanceData>(1) { vid };
                    }
                    else status.Datas[modelPrototypeIndex].Add(vid);
                }

                if (modelPrototypeIndex == -1)
                {
                    ++status.ModelPrototypeCount;
                    var length = status.ModelPrototypeIDs.Length;
                    var ids = new int[length + 1];
                    System.Array.Copy(status.ModelPrototypeIDs, ids, length);
                    status.ModelPrototypeIDs = ids;
                    status.ModelPrototypeIDs[length] = vid.ModelPrototypeID;
                }
            }
        }
        /// <summary>
        /// ������д���ļ�
        /// </summary>
        public void Write(BinaryWriter binaryWriter, System.Action action = null)
        {
            if (action != null) action();
            binaryWriter.Write(ID);
            binaryWriter.Write(Depth);
            binaryWriter.Write(IsLeaf);
            binaryWriter.Write(Empty);
            binaryWriter.Write(TotalDataCount);
            binaryWriter.Write(Block.Bounds.center.x);
            binaryWriter.Write(Block.Bounds.center.y);
            binaryWriter.Write(Block.Bounds.center.z);
            binaryWriter.Write(Block.Bounds.extents.x);
            binaryWriter.Write(Block.Bounds.extents.y);
            binaryWriter.Write(Block.Bounds.extents.z);
            binaryWriter.Write(Block.TrueBounds.center.x);
            binaryWriter.Write(Block.TrueBounds.center.y);
            binaryWriter.Write(Block.TrueBounds.center.z);
            binaryWriter.Write(Block.TrueBounds.extents.x);
            binaryWriter.Write(Block.TrueBounds.extents.y);
            binaryWriter.Write(Block.TrueBounds.extents.z);
            var length = Childs == null ? 0 : Childs.Length;
            binaryWriter.Write(length);
            for (var i = 0; i < length; i++)
                Childs[i].Write(binaryWriter, action);
        }
        /// <summary>
        /// �ӻ����ж�ȡ����
        /// </summary>
        /// <param name="buffer">����</param>
        /// <param name="startIndex">��ʼλ��</param>
        /// <param name="allBlockNodes">�ռ�����������������</param>
        /// <param name="action">���Ȼص�</param>
        public int ReadFromBuffer(byte[] buffer, int startIndex, List<BlockNode> allBlockNodes = null, System.Action action = null)
        {
            var bytesStartIndex = startIndex;
            allBlockNodes.Add(this);
            ID = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            Depth = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            IsLeaf = BitConverter.ToBoolean(buffer, startIndex); startIndex += sizeof(bool);
            Empty = BitConverter.ToBoolean(buffer, startIndex); startIndex += sizeof(bool);
            TotalDataCount = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            Block = new Block();
            Block.ID = ID;
            Block.IsLeaf = IsLeaf;
            Block.Empty = Empty;
            var x = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            var y = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            var z = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            var boundsCenter = new Vector3(x, y, z);
            x = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            y = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            z = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            var boundsExtentes = new Vector3(x, y, z);
            Block.Bounds = new Bounds(boundsCenter, boundsExtentes * 2);
            x = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            y = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            z = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            boundsCenter = new Vector3(x, y, z);
            x = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            y = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            z = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            boundsExtentes = new Vector3(x, y, z);
            Block.TrueBounds = new Bounds(boundsCenter, boundsExtentes * 2);
            var length = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            if(length > 0)
            {
                var noEmptyChilds = new List<BlockNode>();
                Childs = new BlockNode[length];
                for (var i = 0; i < length; i++)
                {
                    var child = new BlockNode();
                    Childs[i] = child;
                    child.Parent = this;
                    startIndex += child.ReadFromBuffer(buffer, startIndex, allBlockNodes, action);
                    if (!Childs[i].Empty) noEmptyChilds.Add(child);
                }
                if (noEmptyChilds.Count > 0)
                    NoEmptyChilds = noEmptyChilds.ToArray();
            }

            if (action != null) action();
            return startIndex - bytesStartIndex;
        }
    }
}
