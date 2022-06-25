using Unity.Jobs;
using Unity.Burst;
using Unity.Collections;
using Unity.Mathematics;

[BurstCompile(CompileSynchronously = true)]
public struct FrustumCullingJob : IJobParallelFor
{
    [ReadOnly] public NativeArray<float4x4> input;
    [ReadOnly] public NativeArray<float4> cameraPlanes;
    [ReadOnly]  public float3 boxCenter;
    [ReadOnly]  public float3 boxExtents;

    public NativeArray<int> outputCount;
    public NativeArray<float4x4> output;

    // 判断一个点是否在一个面之外
    bool IsOutsideThePlane(float4 plane, float3 point) => math.dot(plane.xyz, point) + plane.w > 0;
    bool IsCulled(in NativeArray<float4> boundVerts)
    {
        // 如果8个顶点都在某个面之外，则肯定在视锥体之外
        for(var i = 0; i < 6; i++)
        {
            for(var j = 0; j < 8; j++)
            {
                if (!IsOutsideThePlane(cameraPlanes[i], boundVerts[j].xyz)) break;
                if(j == 7) return true;
            }
        }
        return false;
    }

    public void Execute(int index)
    {
        var instance = input[index];
        // 获得实例包围盒的8个顶点
        float3 boundMin = boxCenter - boxExtents;
        float3 boundMax = boxCenter + boxExtents;
        var boundVerts = new NativeArray<float4>(8, Allocator.Temp);
        boundVerts[0] = math.mul(instance, new float4(boundMin, 1));
        boundVerts[1] = math.mul(instance, new float4(boundMax, 1));
        boundVerts[2] = math.mul(instance, new float4(boundMax.x, boundMax.y, boundMin.z, 1));
        boundVerts[3] = math.mul(instance, new float4(boundMax.x, boundMin.y, boundMax.z, 1));
        boundVerts[6] = math.mul(instance, new float4(boundMax.x, boundMin.y, boundMin.z, 1));
        boundVerts[4] = math.mul(instance, new float4(boundMin.x, boundMax.y, boundMax.z, 1));
        boundVerts[5] = math.mul(instance, new float4(boundMin.x, boundMax.y, boundMin.z, 1));
        boundVerts[7] = math.mul(instance, new float4(boundMin.x, boundMin.y, boundMax.z, 1));

        // 剔除
        if (!IsCulled(boundVerts))
            output[outputCount[0]++] = instance;

        boundVerts.Dispose();
    }
}
