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

        // ����ĸ�����LOD����Ĳ���
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
        // ��Ӱ�Ż�����
        [ReadOnly] public float3 SunshineDir;
        // ����Ⱦ��Ӱ������
        public Unity.Collections.NativeArray<int> VisibleShadowCountNativeArray;
        [NativeDisableParallelForRestriction] public Unity.Collections.NativeArray<VegetationInstanceData> VisibleShadowNativeArray;


        [ReadOnly] public bool ShowVisibleVegetationBounds;
        public Unity.Collections.NativeArray<int> VegetationBoundsCountNativeArray;
        [NativeDisableParallelForRestriction] public Unity.Collections.NativeArray<Bounds> VegetationBoundsNativeArray;

        // ����ֲ��ʵ����Ӧ����������
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
            //���8�����㶼��ĳ�����⣬��϶�����׶������
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
        /// ����LOD�������ռ��ֵ
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
            var size = lodGroupSize * largestAxis; // lod�������ĳߴ�

            if (CameraOrthographic)
                // �������
                // ʹ����������ߴ統����Ļ�ߴ磬������ռ��
                return (size * 0.5F / CameraOrthographicSize) * lodBias;

            // ͸�����
            // ʹ�����������Σ�������ռ��
            var distance = (lodBoundsCenter - cameraPos).magnitude;
            var halfAngle = Mathf.Tan(Mathf.Deg2Rad * CameraFieldOfView * 0.5F);
            var relativeHeight = size * 0.5F / (distance * halfAngle);
            return relativeHeight * lodBias;
        }
        /// <summary>
        /// ��LOD�����LOD����
        /// </summary>
        int CalculateLOD(Vector3 lodBoundsCenter, Vector3 cameraPos, float lodBias,
            bool CameraOrthographic, float CameraOrthographicSize, float CameraFieldOfView,
            Vector3 lodGroupLossyScale, float lodGroupSize,
            int lodLevelsCount, Vector4 lodLevels)
        {
            // �����LOD�������ռ��ֵ
            var currLOD = GetRelativeHeight(
                lodBoundsCenter,
                cameraPos,
                lodBias,
                CameraOrthographic, CameraOrthographicSize, CameraFieldOfView,
                lodGroupLossyScale, lodGroupSize);

            // ��LOD�����LOD����
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
        /// ����ֱ����ƽ��Ľ���
        /// </summary>
        /// <param name="point">ֱ����ĳһ��</param>
        /// <param name="direct">ֱ�ߵķ���</param>
        /// <param name="planeNormal">��ֱ��ƽ��ĵ�����</param>
        /// <param name="planePoint">ƽ���ϵ�����һ��</param>
        /// <param name="result">����</param>
        /// <returns>�Ƿ��ཻ</returns>
        private bool GetIntersectWithLineAndPlane(float3 point, float3 direct, float3 planeNormal, float3 planePoint, out float3 result)
        {
            result = float3.zero;
            //Ҫע��ֱ�ߺ�ƽ��ƽ�е����
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
            // ��Χ�еİ˸���
            var boundVerts = new NativeArray<float3>(8, Allocator.Temp);
            boundVerts[0] = boundMin;
            boundVerts[1] = boundMax;
            boundVerts[2] = new float3(boundMax.x, boundMax.y, boundMin.z);
            boundVerts[3] = new float3(boundMax.x, boundMin.y, boundMax.z);
            boundVerts[4] = new float3(boundMax.x, boundMin.y, boundMin.z);
            boundVerts[5] = new float3(boundMin.x, boundMax.y, boundMax.z);
            boundVerts[6] = new float3(boundMin.x, boundMax.y, boundMin.z);
            boundVerts[7] = new float3(boundMin.x, boundMin.y, boundMax.z);

            // ����ֲ���ɼ���
            bool culled = IsCulled(boundVerts);
            // �޳����ɼ���ֲ��
            if (culled)
            {
                if (EnableShadowOptimization)
                {
                    // ���¼�����Ӱ+ԭ��ֲ����Χ�е�AABB��Χ��
                    float3 newBoundsMin = boundMin;
                    float3 newBoundsMax = boundMax;
                    // ������淨�������ϣ������һ����ԭ��ֲ����Χ����ײ�������һ�㣬
                    // ����ѡ��ԭ����Χ�е���С�㣬Ҳ����˵�������ֲ����͵���ǵ��档
                    float3 planeNormal = Vector3.up;
                    float3 planePoint = boundMin;
                    var isIntersection = false;
                    // �����ԭ��ֲ����Χ�ж��������ĸ������������
                    for (var i = 1; i < 8; i += 2)
                    {
                        var vert = boundVerts[i];
                        // result������Ƕ���Ͷ�䵽�������Ӱ�㣬
                        if (GetIntersectWithLineAndPlane(vert, SunshineDir, planeNormal, planePoint, out float3 result))
                        {
                            isIntersection = true;
                            // ���¼����Χ�������С��
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
                            // ������������ƽ�У��򲻴�����Ӱ
                            isIntersection = false;
                            break;
                        }
                    }

                    if (isIntersection)
                    {
                        // ʹ���µİ�Χ�н�����׶�޳���
                        // ������ɲ��ɼ������޳����ֲ��
                        // ����ɼ�����˵����ǰֲ��ʵ����Ȼֲ�������ɼ�����������Ӱȴ�ǿɼ��ġ�
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
                            // ��Ӱ�ɼ�ʱ������Ӱֲ�����ݴ������Ⱦ��Ӱ��������
                            // ���ﻹ�����ٴμ�����Ӱ��lod��������Ⱦʱѡ����ʵ�lod����Ͳ�����
                            // ����������Ӱlod֮�󣬾���Ҫ��Ӧ����д��....
                            VisibleShadowNativeArray[VisibleShadowCountNativeArray[0]++] = instance;
                        }
                    }

                    //// ���������ȫ������Ⱦ��Ӱ
                    //VisibleShadowNativeArray[VisibleShadowCountNativeArray[0]++] = instance;
                }

                boundVerts.Dispose();
                return;
            }
            // ������Ƿ��ڵ�ǰ������
            var isCameraInBlock = IsInBounds(CameraPosition, boundMin, boundMax);
            // ���������ǰʵ�����������
            float cameraToInstanceDistance = isCameraInBlock ? 0 : Distance(CameraPosition, boundMin, boundMax);


            // ����ֲ��ʵ������ʵ��
            // ����Щ�������һ�������ڵĿɼ�ֲ��������ҽ��������
            if(EnableRuntimeAdditionDeletionModificationAndQuery && cameraToInstanceDistance <= FindInstanceDistanceToCamera)
                FindInstanceDistanceToCameraResultsNativeArray[FindInstanceDistanceToCameraResultsCountNativeArray[0]++] = instance;


            // �޳����������Ⱦ�����ֲ��
            if (!isCameraInBlock && cameraToInstanceDistance > MaxRenderingDistance)
            {
                boundVerts.Dispose();
                return;
            }


            // ��������ֲ����Ⱦ����ģ���Ⱦ��Ƭ
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

            // ����lod
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