using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Burst;
using Unity.Collections;
using Unity.Jobs;
using Unity.Mathematics;

namespace RenderVegetationIn1ms
{
    [BurstCompile(CompileSynchronously = true)]
    public struct CullBlocksJob : IJobParallelFor
    {
        [ReadOnly] public NativeArray<Block> CollectedBlocksNativeArray;
        [ReadOnly] public NativeArray<float4> FrustumPlanes;
        [NativeDisableParallelForRestriction] public NativeArray<Block> AfterCullingBlocksNativeArray;
        [ReadOnly] public float MaxRenderingDistance;
        [ReadOnly] public float MaxCoreRenderingDistance;
        [ReadOnly] public float ImpostorBlockMaxSize;
        [ReadOnly] public float ImpostorBlockMinSize;
        [ReadOnly] public Vector3 CameraPosition;
        [ReadOnly] public bool EnableShadowOptimization;
        [ReadOnly] public float ShadowOptimizationRange;

        bool IsOutPlane(float4 plane, float3 pointPosition) => 
            (math.dot(plane.xyz, pointPosition) + plane.w > 0);
        bool IsCulled(in NativeArray<float3> boundVerts)
        {
            //如果8个顶点都在某个面外，则肯定在视锥体外面
            for (int i = 0; i < 6; i++)
            {
                for (int j = 0; j < 8; j++)
                {
                    if (!IsOutPlane(FrustumPlanes[i], boundVerts[j]))
                        break;
                    if (j == 7)
                        return true;
                }
            }
            return false;
        }

        float Distance(float3 point, float3 min, float3 max)
        {
            var x = point.x;
            var y = point.y;
            var z = point.z;
            if (x < min.x) x = min.x;
            else if (x > max.x) x = max.x;
            if (y < min.y) y = min.y;
            else if (y > max.y) y = max.y;
            if (z < min.z) z = min.z;
            else if (z > max.z) z = max.z;
            return math.abs(math.distance(new float3(x, y, z), point));
        }
        bool IsInBounds(float3 center, float3 min, float3 max) => 
            center.x > min.x && center.y > min.y && center.z > min.z && center.x < max.x && center.y < max.y && center.z < max.z;
        bool IsAllInPlanesWhenNotCulled(in NativeArray<float3> boundVerts)
        {
            for (int i = 0; i < 6; i++)
            {
                for (int j = 0; j < 8; j++)
                {
                    if (IsOutPlane(FrustumPlanes[i], boundVerts[j]))
                        return false;
                }
            }
            return true;
        }
        public void Execute(int index)
        {
            var block = CollectedBlocksNativeArray[index];
            AfterCullingBlocksNativeArray[index] = block;
            if (block.Empty) return;
            float3 min = block.TrueBounds.min;
            float3 max = block.TrueBounds.max;

            // 包围盒的八个点
            var boundVerts = new NativeArray<float3>(8, Allocator.Temp);
            boundVerts[0] = min;
            boundVerts[1] = max;
            boundVerts[2] = new float3(max.x, max.y, min.z);
            boundVerts[3] = new float3(max.x, min.y, max.z);
            boundVerts[4] = new float3(max.x, min.y, min.z);
            boundVerts[5] = new float3(min.x, max.y, max.z);
            boundVerts[6] = new float3(min.x, max.y, min.z);
            boundVerts[7] = new float3(min.x, min.y, max.z);

            var isCulled = IsCulled(boundVerts);
            if (isCulled) 
            {
                if (EnableShadowOptimization && Distance(CameraPosition, min, max) <= ShadowOptimizationRange)
                {
                    // 不可见的区块，但处于阴影优化范围之内的，
                    // 依然需要收集起来
                    block.available = true;
                    block.IsCore = true;
                    block.IsShadow = block.IsLeaf;
                    AfterCullingBlocksNativeArray[index] = block;
                }

                boundVerts.Dispose();
                return;
            }

            block.available = true;
            var blockSize = math.max(block.Bounds.size.x, block.Bounds.size.z);
            // 摄像机是否在当前区块内
            var isCameraInBlock = IsInBounds(CameraPosition, min, max);
            // 摄像机到当前区块的最近距离
            float cameraToBlockDistance = isCameraInBlock ? 0 : Distance(CameraPosition, min, max);

            bool isCoreBlock = isCameraInBlock || cameraToBlockDistance <= MaxCoreRenderingDistance;
            bool isImpostorBlock = !isCoreBlock && cameraToBlockDistance < MaxRenderingDistance;

            if (isCoreBlock)
                block.IsCoreAllInPlanes = IsAllInPlanesWhenNotCulled(boundVerts);

            if (isImpostorBlock && !block.IsLeaf 
                && (blockSize > ImpostorBlockMaxSize || (blockSize > ImpostorBlockMinSize && !IsAllInPlanesWhenNotCulled(boundVerts))))
                block.IsImpostorNeedCollected = true;

            block.IsCore = isCoreBlock;
            block.IsImpostor = isImpostorBlock;


            AfterCullingBlocksNativeArray[index] = block;
            boundVerts.Dispose();
        }
    }
}
