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
    public struct CullVegetationsInitJob : IJob
    {
        public NativeArray<int> VisibleLOD0CountNativeArray;
        public NativeArray<int> VisibleLOD1CountNativeArray;
        public NativeArray<int> VisibleLOD2CountNativeArray;
        public NativeArray<int> VisibleLOD3CountNativeArray;
        public NativeArray<int> VisibleLOD4CountNativeArray;
        public NativeArray<int> VegetationBoundsCountNativeArray;
        public void Execute()
        {
            VisibleLOD0CountNativeArray[0] = 0;
            VisibleLOD1CountNativeArray[0] = 0;
            VisibleLOD2CountNativeArray[0] = 0;
            VisibleLOD3CountNativeArray[0] = 0;
            VisibleLOD4CountNativeArray[0] = 0;
            VegetationBoundsCountNativeArray[0] = 0;
        }
    }
    [BurstCompile(CompileSynchronously = true)]
    public struct CullVegetationsJob : IJobParallelFor
    {
        [ReadOnly] public int InstanceCount;
        [ReadOnly] public NativeArray<VegetationInstanceData> InstancesNativeArray;

        [ReadOnly] public int LODLevelsCount;
        [ReadOnly] public Vector4 LODLevels;
        [ReadOnly] public bool enableImpostor;
        [ReadOnly] public float tanHalfAngle;
        [ReadOnly] public NativeArray<float4> FrustumPlanes;
        [ReadOnly] public float3 CameraPosition;
        [ReadOnly] public float MaxCoreRenderingDistance;
        [ReadOnly] public float MaxRenderingDistance;
        [ReadOnly] public bool ShowVisibleVegetationBounds;

        public Unity.Collections.NativeArray<int> VisibleLOD0CountNativeArray;
        public Unity.Collections.NativeArray<int> VisibleLOD1CountNativeArray;
        public Unity.Collections.NativeArray<int> VisibleLOD2CountNativeArray;
        public Unity.Collections.NativeArray<int> VisibleLOD3CountNativeArray;
        public Unity.Collections.NativeArray<int> VisibleLOD4CountNativeArray;
        public Unity.Collections.NativeArray<int> VegetationBoundsCountNativeArray;
        [NativeDisableParallelForRestriction] public Unity.Collections.NativeArray<VegetationInstanceData> VisibleLOD0NativeArray;
        [NativeDisableParallelForRestriction] public Unity.Collections.NativeArray<VegetationInstanceData> VisibleLOD1NativeArray;
        [NativeDisableParallelForRestriction] public Unity.Collections.NativeArray<VegetationInstanceData> VisibleLOD2NativeArray;
        [NativeDisableParallelForRestriction] public Unity.Collections.NativeArray<VegetationInstanceData> VisibleLOD3NativeArray;
        [NativeDisableParallelForRestriction] public Unity.Collections.NativeArray<VegetationInstanceData> VisibleLOD4NativeArray;
        [NativeDisableParallelForRestriction] public Unity.Collections.NativeArray<Bounds> VegetationBoundsNativeArray;

        float Distance(float3 center, float3 min, float3 max)
        {
            var x = center.x;
            var y = center.y;
            var z = center.z;
            if (x < min.x) x = min.x;
            else if (x > max.x) x = max.x;
            if (y < min.y) y = min.y;
            else if (y > max.y) y = max.y;
            if (z < min.z) z = min.z;
            else if (z > max.z) z = max.z;
            return math.abs(math.distance(new float3(x, y, z), center));
        }
        bool IsInBounds(float3 center, float3 min, float3 max) => center.x > min.x && center.y > min.y && center.z > min.z && center.x < max.x && center.y < max.y && center.z < max.z;
        bool IsOutPlane(float4 plane, float3 pointPosition) => (math.dot(plane.xyz, pointPosition) + plane.w > 0);
        bool IsCulled(in NativeArray<float3> boundVerts)
        {
            //如果8个顶点都在某个面外，则肯定在视锥体外面
            for (int i = 0; i < 6; i++)
            {
                for (int j = 0; j < 8; j++)
                {
                    if (!IsOutPlane(FrustumPlanes[i], boundVerts[j])) break;
                    if (j == 7) return true;
                }
            }
            return false;
        }
        int CalculateLOD(float4x4 instanceMatrix, float3 boundsExtents)
        {
            if (LODLevelsCount <= 0) return 0;
            float dist = math.abs(math.distance(new float3(instanceMatrix.c0.w, instanceMatrix.c1.w, instanceMatrix.c2.w), CameraPosition));
            float maxExtents = math.max(math.max(boundsExtents.x, boundsExtents.y), boundsExtents.z);
            var maxViewSize = maxExtents / (dist * tanHalfAngle);
            for (int i = 0; i < LODLevelsCount; i++)
            {
                if (i > 3) break;
                float lodLevel = 0;
                if (i == 0) lodLevel = LODLevels.x;
                else if (i == 1) lodLevel = LODLevels.y;
                else if (i == 2) lodLevel = LODLevels.z;
                else if (i == 3) lodLevel = LODLevels.w;
                if (maxViewSize >= lodLevel) return i;
                var lodLevel_byDist = maxExtents / lodLevel / tanHalfAngle;
                if (dist >= lodLevel_byDist) return i;
            }
            return 4;
        }
        public void Execute(int index)
        {
            var instance = InstancesNativeArray[index];

            float3 boundMin = instance.center - instance.extents;
            float3 boundMax = instance.center + instance.extents;
            // 包围盒的八个点
            var boundVerts = new NativeArray<float3>(8, Allocator.Temp);
            boundVerts[0] = boundMin;
            boundVerts[1] = boundMax;
            boundVerts[2] = new float3(boundMax.x, boundMax.y, boundMin.z);
            boundVerts[3] = new float3(boundMax.x, boundMin.y, boundMax.z);
            boundVerts[4] = new float3(boundMax.x, boundMin.y, boundMin.z);
            boundVerts[5] = new float3(boundMin.x, boundMax.y, boundMax.z);
            boundVerts[6] = new float3(boundMin.x, boundMax.y, boundMin.z);
            boundVerts[7] = new float3(boundMin.x, boundMin.y, boundMax.z);

            // 测试植被可见性
            bool culled = IsCulled(boundVerts);
            // 剔除不可见的植被
            if (culled)
            {
                boundVerts.Dispose();
                return;
            }
            // 摄像机是否在当前区块内
            var isCameraInBlock = IsInBounds(CameraPosition, boundMin, boundMax);
            // 摄像机到当前实例的最近距离
            float cameraToInstanceDistance = isCameraInBlock ? 0 : Distance(CameraPosition, boundMin, boundMax);

            // 剔除超过最大渲染距离的植被
            if(!isCameraInBlock && cameraToInstanceDistance > MaxRenderingDistance)
            {
                boundVerts.Dispose();
                return;
            }


            // 超出核心植被渲染距离的，渲染面片
            if (!isCameraInBlock && cameraToInstanceDistance > MaxCoreRenderingDistance)
            {
                if (enableImpostor)
                {
                    VisibleLOD4NativeArray[VisibleLOD4CountNativeArray[0]++] = instance;
                    if (ShowVisibleVegetationBounds)
                        VegetationBoundsNativeArray[VegetationBoundsCountNativeArray[0]++] = new Bounds(instance.center, instance.extents * 2);
                }
                boundVerts.Dispose();
                return;
            }

            // 计算lod
            int lod = CalculateLOD(instance.matrix, instance.extents);
            if (lod == 0)
                VisibleLOD0NativeArray[VisibleLOD0CountNativeArray[0]++] = instance;
            else if (lod == 1)
                VisibleLOD1NativeArray[VisibleLOD1CountNativeArray[0]++] = instance;
            else if (lod == 2)
                VisibleLOD2NativeArray[VisibleLOD2CountNativeArray[0]++] = instance;
            else if (lod == 3)
                VisibleLOD3NativeArray[VisibleLOD3CountNativeArray[0]++] = instance;
            else if (lod == 4 && enableImpostor)
                VisibleLOD4NativeArray[VisibleLOD4CountNativeArray[0]++] = instance;

            boundVerts.Dispose();

            if (ShowVisibleVegetationBounds)
                VegetationBoundsNativeArray[VegetationBoundsCountNativeArray[0]++] = new Bounds(instance.center, instance.extents * 2);
        }
    }

}