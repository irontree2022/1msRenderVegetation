using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    public class BlockTree
    {
        /// <summary>
        /// ��������������
        /// </summary>
        public int Depth
        {
            get
            {
                if (_Depth < 0)
                    RecalculateDepth();
                return _Depth;
            }
        }
        /// <summary>
        /// ��������ڵ�����
        /// </summary>
        public int AllBlockNodesCount;
        /// <summary>
        /// ���ڵ�
        /// </summary>
        public BlockNode RootBlockNode;
        /// <summary>
        /// ��������ڵ�
        /// </summary>
        public BlockNode[] AllBlockNodes;


        public BlockNode GetBlockNode(int id) => AllBlockNodes[id];
        public override string ToString() => $"(Depth: {Depth}, AllBlockNodesCount: {AllBlockNodesCount})";
        /// <summary>
        /// ���¼������������
        /// </summary>
        /// <returns>������������������</returns>
        public int RecalculateDepth()
        {
            if (RootBlockNode == null)
            {
                _Depth = 0;
                return _Depth;
            }
            _Depth = 1;
            if (RootBlockNode.Childs == null)
                return _Depth;

            BlockNode nextDepthNode = RootBlockNode.Childs[0];
            while(nextDepthNode != null)
            {
                ++_Depth;
                if (nextDepthNode.Childs == null) break;
                nextDepthNode = nextDepthNode.Childs[0];
            }
            return _Depth;
        }
        /// <summary>
        /// ����������
        /// </summary>
        /// <param name="rootNodeBounds">���ڵ��Χ��</param>
        /// <param name="nextBlockReductionFactor">��һ��������С����</param>
        /// <param name="minBlockSize">��С����ߴ�</param>
        /// <returns>������</returns>
        public static BlockTree CreateBlockTree(Bounds rootNodeBounds, int nextBlockReductionFactor, int minBlockSize)
        {
            BlockTree blockTree = new BlockTree();
            var allBlockNodes = new List<BlockNode>();
            blockTree.RootBlockNode = BlockNode.CreateBlockNode(rootNodeBounds, 1, nextBlockReductionFactor, minBlockSize, allBlockNodes);
            blockTree.AllBlockNodesCount = allBlockNodes.Count;
            for(var i = 0; i < blockTree.AllBlockNodesCount; i++)
            {
                var blockNode = allBlockNodes[i];
                blockNode.ID = i;
                blockNode.Block.ID = i;
            }
            return blockTree;
        }
        /// <summary>
        /// ������д���ļ�
        /// </summary>
        /// <param name="filepath">�ļ�·��</param>
        public void Write(string filepath, System.Action<bool, float> progressAction = null)
        {
            var dir = System.IO.Path.GetDirectoryName(filepath);
            System.IO.Directory.CreateDirectory(dir);

            using (FileStream fs = new FileStream(filepath, FileMode.Create))
            {
                var binaryWriter = new BinaryWriter(fs, System.Text.Encoding.UTF8);
                binaryWriter.Write(Depth);
                binaryWriter.Write(AllBlockNodesCount);
                var index = 0;
                RootBlockNode.Write(binaryWriter, () =>
                {
                    if (progressAction != null)
                        progressAction(false, ++index / (float)AllBlockNodesCount);
                });
                if (progressAction != null)
                    progressAction(true, 1);
                binaryWriter.Close();
                binaryWriter.Dispose();
            }
        }
        /// <summary>
        /// ���ļ��ж�ȡ����
        /// </summary>
        /// <param name="filepath">�ļ�·��</param>
        /// <param name="progressAction">���Ȼص�</param>
        public void ReadFromFile(string filepath, System.Action<bool, float> progressAction = null)
        {
            if (progressAction != null) progressAction(false, 0);
            var buffer = System.IO.File.ReadAllBytes(filepath);
            var startIndex = 0;
            _Depth = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            AllBlockNodesCount = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            RootBlockNode = new BlockNode();
            var blockIndex = 0;
            var allBlockNodes = new List<BlockNode>(AllBlockNodesCount);
            RootBlockNode.ReadFromBuffer(buffer, startIndex, allBlockNodes, () => {
                if(progressAction != null) progressAction(false, ++blockIndex / (float) AllBlockNodesCount);
            });
            AllBlockNodes = allBlockNodes.ToArray();
            if (progressAction != null) progressAction(true, 1);
        }
        /// <summary>
        /// ��������������
        /// </summary>
        private int _Depth = -1;

    }
}
