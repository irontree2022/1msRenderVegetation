using Unity.Burst;
using Unity.Collections;
using Unity.Jobs;
using Unity.Mathematics;
using UnityEngine;

[BurstCompile]
public struct Hi_z_Job : IJobParallelFor
{
    [ReadOnly] public bool enabelDebug;
    [ReadOnly] public bool EnableFrustumCulling;
    [ReadOnly] public bool EnabelHi_z_OcclusionCulling;
    [ReadOnly] public bool isOpenGL;
    [ReadOnly] public bool usesReversedZBuffer;
    [ReadOnly] public Matrix4x4 vpMatrix;
    [ReadOnly] public Bounds grassBounds;
    [ReadOnly] public int grassCount;
    [ReadOnly] public NativeArray<Matrix4x4> grassInstances;
    [ReadOnly] public NativeArray<Bounds> grassBoundsesNativeArray;
    [ReadOnly] public bool UseFrustumPlanes;
    [ReadOnly] public NativeArray<float4> FrustumPlanes;
    [ReadOnly] public int depthDatasLength;
    [ReadOnly] public NativeArray<float> depthDataNativeArray;
    [ReadOnly] public float nearClipPlane;
    [ReadOnly] public float farClipPlane;
    [ReadOnly] public Vector2Int ScreenSize;
    [ReadOnly] public bool EnableDrawGrassInstanceBounds;
    [ReadOnly] public bool onlyGetVisibleBoundsNearPoint;
    [ReadOnly] public Vector3 nearPoint;
    [ReadOnly] public float nearDistance;

    [WriteOnly]
    [NativeDisableParallelForRestriction]
    public NativeArray<bool> grassVisibles;
    [WriteOnly]
    [NativeDisableParallelForRestriction]
    public NativeArray<bool> grassBoundsVisibles;

    public void Execute(int index)
    {
        if (index >= grassCount) return;
        grassVisibles[index] = false;
        grassBoundsVisibles[index] = false;

        var mMatrix = grassInstances[index];
        // 这里记录了每个草实例的实际包围盒，
        // 但是如果没有旋转和缩放，那么包围盒只需要一直值就足够了，
        // 那样就可以在这里使用类似代码： grassBounds.center = mMatrix.GetPosition();
        // 将包围盒更新到当前实例的世界坐标处
        var grassBounds = grassBoundsesNativeArray[index];
        // 包围盒是世界坐标的，就不用mvp，只要vp矩阵就足够了
        // mvp测试时候有问题，
        //var mvp = math.mul(vpMatrix, mMatrix);

        //包围盒的8个顶点的View Space坐标
        var boundMin = grassBounds.min;
        var boundMax = grassBounds.max;
        var boundVerts = new NativeArray<float4>(8, Allocator.Temp);
        boundVerts[0] = new float4(boundMin, 1);
        boundVerts[1] = new float4(boundMax, 1);
        boundVerts[2] = new float4(boundMax.x, boundMax.y, boundMin.z, 1f);
        boundVerts[3] = new float4(boundMax.x, boundMin.y, boundMax.z, 1f);
        boundVerts[4] = new float4(boundMax.x, boundMin.y, boundMin.z, 1f);
        boundVerts[5] = new float4(boundMin.x, boundMax.y, boundMax.z, 1f);
        boundVerts[6] = new float4(boundMin.x, boundMax.y, boundMin.z, 1f);
        boundVerts[7] = new float4(boundMin.x, boundMin.y, boundMax.z, 1f);


        bool ndcDone = false;
        float minX = 1, minY = 1, minZ = 1, maxX = -1, maxY = -1, maxZ = -1;//NDC下新的的AABB各个参数
        //-------------------------------------------------------视椎剔除-------------------------------------------------------
        if (EnableFrustumCulling)
        {
            if (UseFrustumPlanes)
            {
                // 使用视锥六个面进行剔除
                var isCulled = IsCulled(boundVerts);
                if (isCulled)
                {
                    boundVerts.Dispose();
                    return;
                }
            }
            else
            {
                // 裁剪空间剔除：
                //      适用小物体，比如草；
                //      当物体非常大时，就不适用了，因为大包围盒可见，但它的顶点都在NDC之外，就会被错误剔除掉
                //
                // 通过mvp矩阵得到顶点的Clip Space的齐次坐标，然后在Clip Space做视椎剔除判断，所有点都不在NDC内就被剔除。
                bool isInClipSpace = false;
                for (int i = 0; i < 8; i++)
                {
                    float4 clipSpace = math.mul(vpMatrix, boundVerts[i]);
                    if (!isInClipSpace && IsInClipSpace(clipSpace))
                        isInClipSpace = true;

                    if (EnabelHi_z_OcclusionCulling)
                    {
                        //计算ndc下的新的AABB
                        float3 ndc = clipSpace.xyz / clipSpace.w;
                        if (minX > ndc.x) minX = ndc.x;
                        if (minY > ndc.y) minY = ndc.y;
                        if (minZ > ndc.z) minZ = ndc.z;
                        if (maxX < ndc.x) maxX = ndc.x;
                        if (maxY < ndc.y) maxY = ndc.y;
                        if (maxZ < ndc.z) maxZ = ndc.z;
                        ndcDone = true;
                    }
                }

                if (!isInClipSpace)
                {
                    boundVerts.Dispose();
                    return;
                }
            }
        }


        //-------------------------------------------------------遮挡剔除-------------------------------------------------------
        if (EnabelHi_z_OcclusionCulling && depthDatasLength > 0)
        {
            if (!ndcDone)
            {
                for (int i = 0; i < 8; i++)
                {
                    float4 clipSpace = math.mul(vpMatrix, boundVerts[i]);
                    //计算ndc下的新的AABB
                    float3 ndc = clipSpace.xyz / clipSpace.w;
                    if (minX > ndc.x) minX = ndc.x;
                    if (minY > ndc.y) minY = ndc.y;
                    if (minZ > ndc.z) minZ = ndc.z;
                    if (maxX < ndc.x) maxX = ndc.x;
                    if (maxY < ndc.y) maxY = ndc.y;
                    if (maxZ < ndc.z) maxZ = ndc.z;
                }
            }


            // 深度值映射到[0-1]之间
            // 优先取相机最近的深度值，OpenGL取最小z；
            // 其他平台默认是反转的，所以取最大z（再度反转后，也是最小z了）
            var depth = minZ;
            if(isOpenGL)
                depth = minZ * 0.5f + 0.5f; // OpenGL ndc.z处于[-1,1]之间，需要映射到[0-1]
            if (usesReversedZBuffer)
            {
                depth = maxZ;
                depth = 1f - depth; // 处理平台差异：DX11/Metal/Vulkan 使用反向Z，1.0（近） → 0.0（远）
            }
            float zBufferParamX = 1.0f - farClipPlane / nearClipPlane;
            float zBufferParamY = farClipPlane / nearClipPlane;
            // 深度图中写入的是0-1的线性深度值，这里要同步处理成线性深度值
            float linear01Depth = 1.0f / (zBufferParamX * depth + zBufferParamY);
            // 保守剔除：新包围盒的四个顶点都被遮挡住了，才会被剔除
            var uv0 = new float2(minX, minY);
            var uv1 = new float2(minX, maxY);
            var uv2 = new float2(maxX, minY);
            var uv3 = new float2(maxX, maxY);
            if (isOccluded(uv0, linear01Depth) &&
                isOccluded(uv1, linear01Depth) &&
                isOccluded(uv2, linear01Depth) &&
                isOccluded(uv3, linear01Depth))
            {
                boundVerts.Dispose();
                return;
            }


            //if (enabelDebug)
            //    Debug.Log($"没有被遮挡剔除：{index}，offset={offset}, mipLevel={mipLevel}, uvSize={mipmapSize}");
        }


        var boundsVisible = false;
        if(EnableDrawGrassInstanceBounds && (!onlyGetVisibleBoundsNearPoint || math.distance(nearPoint, grassBounds.center) <= nearDistance))
            boundsVisible = true;
        grassBoundsVisibles[index] = boundsVisible;

        grassVisibles[index] = true;
        boundVerts.Dispose();

    }
    // 计算遮挡关系
    bool isOccluded(float2 uv, float depth)
    {
        var screenSize = ScreenSize;
        // 先将uv映射到[0-1]之间，
        uv = uv * 0.5f + 0.5f;
        var pixel = uv * new float2(screenSize.x, screenSize.y);


        var isInScreen = pixel.x >= 0 || pixel.y >= 0 || pixel.x <= screenSize.x - 1 || pixel.y <= screenSize.y - 1;
        // 剔除屏幕之外的像素点
        if (!isInScreen)
            return true;

        var pixelX = math.clamp((int)pixel.x, 0, screenSize.x -1);
        var pixelY = math.clamp((int)pixel.y, 0, screenSize.y -1);

        var bufferIndex = pixelY * screenSize.x + pixelX;
        if (bufferIndex < 0 || bufferIndex >= depthDataNativeArray.Length)
            return true;

        // 深度大于深度图记录的深度，表示被遮挡住了
        return depth > depthDataNativeArray[bufferIndex];
    }
    //在Clip Space下，根据齐次坐标做Clipping操作
    bool IsInClipSpace(float4 clipSpacePosition)
    {
        if (isOpenGL)
            return clipSpacePosition.x > -clipSpacePosition.w && clipSpacePosition.x < clipSpacePosition.w &&
            clipSpacePosition.y > -clipSpacePosition.w && clipSpacePosition.y < clipSpacePosition.w &&
            clipSpacePosition.z > -clipSpacePosition.w && clipSpacePosition.z < clipSpacePosition.w;
        else
            return clipSpacePosition.x > -clipSpacePosition.w && clipSpacePosition.x < clipSpacePosition.w &&
            clipSpacePosition.y > -clipSpacePosition.w && clipSpacePosition.y < clipSpacePosition.w &&
            clipSpacePosition.z > 0 && clipSpacePosition.z < clipSpacePosition.w;
    }

    bool IsOutPlane(float4 plane, float4 pointPosition) => (math.dot(plane.xyz, pointPosition.xyz) + plane.w > 0);
    bool IsCulled(in NativeArray<float4> boundVerts)
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
}

[BurstCompile]
public struct FilterJob : IJob
{
    [ReadOnly] public int grassCount;
    [ReadOnly] public NativeArray<Matrix4x4> grassInstances;
    [ReadOnly] public NativeArray<bool> grassVisibles;

    public NativeArray<int> visiblesCount;
    [WriteOnly] public NativeArray<Matrix4x4> visibles;


    [ReadOnly] public NativeArray<Bounds> grassBoundsInstances;
    [ReadOnly] public NativeArray<bool> grassVisiblesBounds;
    public NativeArray<int> visiblesBoundsCount;
    [WriteOnly] public NativeArray<Bounds> visiblesBounds;

    public void Execute()
    {
        // 提取容器中可见实例到visibles中，
        // 并记录可见实例总数量
        var count = 0;
        var boundsCount = 0;
        for(var i = 0; i < grassCount; ++i)
        {
            if (grassVisibles[i])
                visibles[count++] = grassInstances[i];
            if (grassVisiblesBounds[i])
                visiblesBounds[boundsCount++] = grassBoundsInstances[i];
        }
        visiblesCount[0] = count;
        visiblesBoundsCount[0] = boundsCount;
    }
}

