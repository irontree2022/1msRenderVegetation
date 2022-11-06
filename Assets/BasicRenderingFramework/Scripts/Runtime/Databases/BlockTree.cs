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
        /// 区块树的最大深度
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
        /// 所有区块节点数量
        /// </summary>
        public int AllBlockNodesCount;
        /// <summary>
        /// 根节点
        /// </summary>
        public BlockNode RootBlockNode;
        /// <summary>
        /// 所有区块节点
        /// </summary>
        public BlockNode[] AllBlockNodes;


        public BlockNode GetBlockNode(int id) => AllBlockNodes[id];
        public override string ToString() => $"(Depth: {Depth}, AllBlockNodesCount: {AllBlockNodesCount})";
        /// <summary>
        /// 重新计算区块树深度
        /// </summary>
        /// <returns>返回区块树的最大深度</returns>
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
        /// 创建区块树
        /// </summary>
        /// <param name="rootNodeBounds">根节点包围盒</param>
        /// <param name="nextBlockReductionFactor">下一层区块缩小倍数</param>
        /// <param name="minBlockSize">最小区块尺寸</param>
        /// <returns>区块树</returns>
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
        /// 将数据写入文件
        /// </summary>
        /// <param name="filepath">文件路径</param>
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
        /// 从文件中读取数据
        /// </summary>
        /// <param name="filepath">文件路径</param>
        /// <param name="progressAction">进度回调</param>
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
        /// 区块树的最大深度
        /// </summary>
        private int _Depth = -1;

    }
}
