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
        public NativeArray<int> VisibleShadowCountNativeArray;
        public NativeArray<int> VegetationBoundsCountNativeArray;
        public NativeArray<int> FindInstanceDistanceToCameraResultsCountNativeArray;
        public void Execute()
        {
            VisibleLOD0CountNativeArray[0] = 0;
            VisibleLOD1CountNativeArray[0] = 0;
            VisibleLOD2CountNativeArray[0] = 0;
            VisibleLOD3CountNativeArray[0] = 0;
            VisibleLOD4CountNativeArray[0] = 0;
            VisibleShadowCountNativeArray[0] = 0;
            VegetationBoundsCountNativeArray[0] = 0;
            FindInstanceDistanceToCameraResultsCountNativeArray[0] = 0;
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

        // 添加四个参与LOD计算的参数
        [ReadOnly] public float QualitySettingsLodBias;
        [ReadOnly] public bool CameraOrthographic;
        [ReadOnly] public float CameraOrthographicSize;
        [ReadOnly] public float CameraFieldOfView;
        [ReadOnly] public float LODGroupSize;

        [ReadOnly] public float MaxCoreRenderingDistance;
        [ReadOnly] public float MaxRenderingDistance;


        public Unity.Collections.NativeArray<int> VisibleLOD0CountNativeArray;
        public Unity.Collections.NativeArray<int> VisibleLOD1CountNativeArray;
        public Unity.Collections.NativeArray<int> VisibleLOD2CountNativeArray;
        public Unity.Collections.NativeArray<int> VisibleLOD3CountNativeArray;
        public Unity.Collections.NativeArray<int> VisibleLOD4CountNativeArray;
        [NativeDisableParallelForRestriction] public Unity.Collections.NativeArray<VegetationInstanceData> VisibleLOD0NativeArray;
        [NativeDisableParallelForRestriction] public Unity.Collections.NativeArray<VegetationInstanceData> VisibleLOD1NativeArray;
        [NativeDisableParallelForRestriction] public Unity.Collections.NativeArray<VegetationInstanceData> VisibleLOD2NativeArray;
        [NativeDisableParallelForRestriction] public Unity.Collections.NativeArray<VegetationInstanceData> VisibleLOD3NativeArray;
        [NativeDisableParallelForRestriction] public Unity.Collections.NativeArray<VegetationInstanceData> VisibleLOD4NativeArray;


        [ReadOnly] public bool EnableShadowOptimization;
        // 阴影优化参数
        [ReadOnly] public float3 SunshineDir;
        // 仅渲染阴影的容器
        public Unity.Collections.NativeArray<int> VisibleShadowCountNativeArray;
        [NativeDisableParallelForRestriction] public Unity.Collections.NativeArray<VegetationInstanceData> VisibleShadowNativeArray;


        [ReadOnly] public bool ShowVisibleVegetationBounds;
        public Unity.Collections.NativeArray<int> VegetationBoundsCountNativeArray;
        [NativeDisableParallelForRestriction] public Unity.Collections.NativeArray<Bounds> VegetationBoundsNativeArray;

        // 查找植被实例对应变量和容器
        [ReadOnly] public bool EnableRuntimeAdditionDeletionModificationAndQuery;
        [ReadOnly] public float FindInstanceDistanceToCamera;
        public NativeArray<int> FindInstanceDistanceToCameraResultsCountNativeArray;
        [NativeDisableParallelForRestriction] public NativeArray<VegetationInstanceData> FindInstanceDistanceToCameraResultsNativeArray;


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
        /// <summary>
        /// 计算LOD对象的屏占比值
        /// </summary>
        float GetRelativeHeight(
            Vector3 lodBoundsCenter, Vector3 cameraPos, float lodBias,
            bool CameraOrthographic, float CameraOrthographicSize, float CameraFieldOfView,
            Vector3 lodGroupLossyScale, float lodGroupSize)
        {
            var scale = lodGroupLossyScale;
            float largestAxis = Mathf.Abs(scale.x);
            largestAxis = Mathf.Max(largestAxis, Mathf.Abs(scale.y));
            largestAxis = Mathf.Max(largestAxis, Mathf.Abs(scale.z));
            var size = lodGroupSize * largestAxis; // lod对象最大的尺寸

            if (CameraOrthographic)
                // 正交相机
                // 使用相机正交尺寸当作屏幕尺寸，计算屏占比
                return (size * 0.5F / CameraOrthographicSize) * lodBias;

            // 透视相机
            // 使用相似三角形，就算屏占比
            var distance = (lodBoundsCenter - cameraPos).magnitude;
            var halfAngle = Mathf.Tan(Mathf.Deg2Rad * CameraFieldOfView * 0.5F);
            var relativeHeight = size * 0.5F / (distance * halfAngle);
            return relativeHeight * lodBias;
        }
        /// <summary>
        /// 就LOD对象的LOD级别
        /// </summary>
        int CalculateLOD(Vector3 lodBoundsCenter, Vector3 cameraPos, float lodBias,
            bool CameraOrthographic, float CameraOrthographicSize, float CameraFieldOfView,
            Vector3 lodGroupLossyScale, float lodGroupSize,
            int lodLevelsCount, Vector4 lodLevels)
        {
            // 计算出LOD对象的屏占比值
            var currLOD = GetRelativeHeight(
                lodBoundsCenter,
                cameraPos,
                lodBias,
                CameraOrthographic, CameraOrthographicSize, CameraFieldOfView,
                lodGroupLossyScale, lodGroupSize);

            // 出LOD对象的LOD级别
            for (int i = 0; i < lodLevelsCount; i++)
            {
                if (i > 3) break;
                float lodLevel = 0;
                if (i == 0) lodLevel = lodLevels.x;
                else if (i == 1) lodLevel = lodLevels.y;
                else if (i == 2) lodLevel = lodLevels.z;
                else if (i == 3) lodLevel = lodLevels.w;
                if (currLOD >= lodLevel)
                    return i;
            }
            return 4;
        }
        /// <summary>
        /// 计算直线与平面的交点
        /// </summary>
        /// <param name="point">直线上某一点</param>
        /// <param name="direct">直线的方向</param>
        /// <param name="planeNormal">垂直于平面的的向量</param>
        /// <param name="planePoint">平面上的任意一点</param>
        /// <param name="result">交点</param>
        /// <returns>是否相交</returns>
        private bool GetIntersectWithLineAndPlane(float3 point, float3 direct, float3 planeNormal, float3 planePoint, out float3 result)
        {
            result = float3.zero;
            //要注意直线和平面平行的情况
            float d1 = math.dot(direct, planeNormal);
            if (d1 == 0) return false;
            float d2 = math.dot(planePoint - point, planeNormal);
            float d3 = d2 / d1;

            result = d3 * direct + point;
            return true;
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
                if (EnableShadowOptimization)
                {
                    // 重新计算阴影+原本植被包围盒的AABB包围盒
                    float3 newBoundsMin = boundMin;
                    float3 newBoundsMax = boundMax;
                    // 假设地面法向量向上，地面的一点是原本植被包围盒最底部的其中一点，
                    // 这里选择原本包围盒的最小点，也就是说这里假设植被最低点就是地面。
                    float3 planeNormal = Vector3.up;
                    float3 planePoint = boundMin;
                    var isIntersection = false;
                    // 阳光从原本植被包围盒顶部的那四个顶点射向地面
                    for (var i = 1; i < 8; i += 2)
                    {
                        var vert = boundVerts[i];
                        // result交点就是顶点投射到地面的阴影点，
                        if (GetIntersectWithLineAndPlane(vert, SunshineDir, planeNormal, planePoint, out float3 result))
                        {
                            isIntersection = true;
                            // 重新计算包围盒最大最小点
                            if (result.x < newBoundsMin.x)
                                newBoundsMin.x = result.x;
                            if (result.y < newBoundsMin.y)
                                newBoundsMin.y = result.y;
                            if (result.z < newBoundsMin.z)
                                newBoundsMin.z = result.z;
                            if (result.x > newBoundsMax.x)
                                newBoundsMax.x = result.x;
                            if (result.y > newBoundsMax.y)
                                newBoundsMax.y = result.y;
                            if (result.z > newBoundsMax.z)
                                newBoundsMax.z = result.z;
                        }
                        else
                        {
                            // 如果阳光与地面平行，则不存在阴影
                            isIntersection = false;
                            break;
                        }
                    }

                    if (isIntersection)
                    {
                        // 使用新的包围盒进行视锥剔除，
                        // 如果依旧不可见，则剔除这个植被
                        // 如果可见，则说明当前植被实例虽然植被本身不可见，但它的阴影却是可见的。
                        boundVerts[0] = newBoundsMin;
                        boundVerts[1] = newBoundsMax;
                        boundVerts[2] = new float3(newBoundsMax.x, newBoundsMax.y, newBoundsMin.z);
                        boundVerts[3] = new float3(newBoundsMax.x, newBoundsMin.y, newBoundsMax.z);
                        boundVerts[4] = new float3(newBoundsMax.x, newBoundsMin.y, newBoundsMin.z);
                        boundVerts[5] = new float3(newBoundsMin.x, newBoundsMax.y, newBoundsMax.z);
                        boundVerts[6] = new float3(newBoundsMin.x, newBoundsMax.y, newBoundsMin.z);
                        boundVerts[7] = new float3(newBoundsMin.x, newBoundsMin.y, newBoundsMax.z);
                        if (!IsCulled(boundVerts))
                        {
                            // 阴影可见时，将阴影植被数据存入仅渲染阴影的容器中
                            // 这里还可以再次计算阴影的lod，用以渲染时选择合适的lod网格和材质球
                            // 但计算了阴影lod之后，就需要对应容器写入....
                            VisibleShadowNativeArray[VisibleShadowCountNativeArray[0]++] = instance;
                        }
                    }

                    //// 将被提出的全部都渲染阴影
                    //VisibleShadowNativeArray[VisibleShadowCountNativeArray[0]++] = instance;
                }

                boundVerts.Dispose();
                return;
            }
            // 摄像机是否在当前区块内
            var isCameraInBlock = IsInBounds(CameraPosition, boundMin, boundMax);
            // 摄像机到当前实例的最近距离
            float cameraToInstanceDistance = isCameraInBlock ? 0 : Distance(CameraPosition, boundMin, boundMax);


            // 查找植被实例具体实现
            // 将那些距离相机一定距离内的可见植被存入查找结果容器中
            if(EnableRuntimeAdditionDeletionModificationAndQuery && cameraToInstanceDistance <= FindInstanceDistanceToCamera)
                FindInstanceDistanceToCameraResultsNativeArray[FindInstanceDistanceToCameraResultsCountNativeArray[0]++] = instance;


            // 剔除超过最大渲染距离的植被
            if (!isCameraInBlock && cameraToInstanceDistance > MaxRenderingDistance)
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
            int lod = 0;
            if (LODLevelsCount > 0)
            {
                float4x4 matrix = instance.matrix;
                Vector3 lossyScale = new float3(math.length(matrix.c0.xyz), math.length(matrix.c1.xyz), math.length(matrix.c2.xyz));
                lod = CalculateLOD(instance.center, CameraPosition, QualitySettingsLodBias,
                    CameraOrthographic, CameraOrthographicSize, CameraFieldOfView,
                    lossyScale, LODGroupSize,
                    LODLevelsCount, LODLevels);
            }
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