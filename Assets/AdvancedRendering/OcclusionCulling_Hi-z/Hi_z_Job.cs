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
    [ReadOnly] public int rtMipmapCount;
    [ReadOnly] public NativeArray<Vector3Int> rtMipmapSizesNativeArray;
    [ReadOnly] public int minMipmapLevel;
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
        // �����¼��ÿ����ʵ����ʵ�ʰ�Χ�У�
        // �������û����ת�����ţ���ô��Χ��ֻ��Ҫһ��ֵ���㹻�ˣ�
        // �����Ϳ���������ʹ�����ƴ��룺 grassBounds.center = mMatrix.GetPosition();
        // ����Χ�и��µ���ǰʵ�����������괦
        var grassBounds = grassBoundsesNativeArray[index];
        // �����Χ����ģ�Ϳռ�ģ�ʹ��mvp
        // ��������ʹ��mvpʱ��һֱû���Գɹ�...
        //var mvp = math.mul(vpMatrix, mMatrix);

        //��Χ�е�8�������View Space����
        var boundMin = grassBounds.min;
        var boundMax = grassBounds.max;
        var boundVerts = new NativeArray<float4>(8, Allocator.Temp);
        boundVerts[0] = new float4(boundMin, 1f);
        boundVerts[1] = new float4(boundMax, 1f);
        boundVerts[2] = new float4(boundMax.x, boundMax.y, boundMin.z, 1f);
        boundVerts[3] = new float4(boundMax.x, boundMin.y, boundMax.z, 1f);
        boundVerts[4] = new float4(boundMax.x, boundMin.y, boundMin.z, 1f);
        boundVerts[5] = new float4(boundMin.x, boundMax.y, boundMax.z, 1f);
        boundVerts[6] = new float4(boundMin.x, boundMax.y, boundMin.z, 1f);
        boundVerts[7] = new float4(boundMin.x, boundMin.y, boundMax.z, 1f);


        bool ndcDone = false;
        float minNDCx = 1, minNDCy = 1, minNDCz = 1, maxNDCx = -1, maxNDCy = -1, maxNDCz = -1;//NDC���µĵ�AABB��������
        //-------------------------------------------------------��׵�޳�-------------------------------------------------------
        if (EnableFrustumCulling)
        {
            if (UseFrustumPlanes)
            {
                // ʹ����׶����������޳�
                var isCulled = IsCulled(boundVerts);
                if (isCulled)
                {
                    boundVerts.Dispose();
                    return;
                }
            }
            else
            {
                // �ü��ռ��޳���
                //      ����С���壬����ݣ�
                //      ������ǳ���ʱ���Ͳ������ˣ���Ϊ���Χ�пɼ��������Ķ��㶼��NDC֮�⣬�ͻᱻ�����޳���
                //
                // ͨ��mvp����õ������Clip Space��������꣬Ȼ����Clip Space����׵�޳��жϣ����е㶼����NDC�ھͱ��޳���
                bool isInClipSpace = false;
                for (int i = 0; i < 8; i++)
                {
                    float4 clipSpace = math.mul(vpMatrix, boundVerts[i]);
                    if (!isInClipSpace && IsInClipSpace(clipSpace))
                        isInClipSpace = true;

                    if (EnabelHi_z_OcclusionCulling)
                    {
                        //����ndc�µ��µ�AABB
                        float3 ndc = clipSpace.xyz / clipSpace.w;
                        if (minNDCx > ndc.x) minNDCx = ndc.x;
                        if (minNDCy > ndc.y) minNDCy = ndc.y;
                        if (minNDCz > ndc.z) minNDCz = ndc.z;
                        if (maxNDCx < ndc.x) maxNDCx = ndc.x;
                        if (maxNDCy < ndc.y) maxNDCy = ndc.y;
                        if (maxNDCz < ndc.z) maxNDCz = ndc.z;
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


        //-------------------------------------------------------�ڵ��޳�-------------------------------------------------------
        if (EnabelHi_z_OcclusionCulling && depthDatasLength > 0)
        {
            if (!ndcDone)
            {
                for (int i = 0; i < 8; i++)
                {
                    // ת�����ÿռ�
                    float4 clipSpace = math.mul(vpMatrix, boundVerts[i]);
                    // ͸�ӳ����õ�ndc���꣬��zֵ��ʾ���
                    float3 ndc = clipSpace.xyz / clipSpace.w;
                    // ����ndc�µ��µ�AABB
                    if (minNDCx > ndc.x) minNDCx = ndc.x;
                    if (minNDCy > ndc.y) minNDCy = ndc.y;
                    if (minNDCz > ndc.z) minNDCz = ndc.z;
                    if (maxNDCx < ndc.x) maxNDCx = ndc.x;
                    if (maxNDCy < ndc.y) maxNDCy = ndc.y;
                    if (maxNDCz < ndc.z) maxNDCz = ndc.z;
                }
            }

            // ��ǰ������Ļ�����سߴ磬
            var minUV = new float2(minNDCx, minNDCy);
            var maxUV = new float2(maxNDCx, maxNDCy);
            minUV = minUV * 0.5f + 0.5f;
            maxUV = maxUV * 0.5f + 0.5f;
            var minPixel = minUV * new float2(ScreenSize.x, ScreenSize.y);
            var maxPixel = maxUV * new float2(ScreenSize.x, ScreenSize.y); // ����ͼ������ǰ���帲����Ļ����������
            // ������ıߣ�log2�����ӦmipmapLevel
            var maxPixelCount = math.max(math.abs(maxPixel.x - minPixel.x), math.abs(maxPixel.y - minPixel.y)); // ���帲����Ļ����������һ��
            var mipmapLevel = math.clamp((int)math.log2(maxPixelCount), 0, math.min(rtMipmapCount - 1, minMipmapLevel)); // log2���ȡֵmipmap�㼶��clampȷ���㼶����С�����㼶֮��
            // ��(mipmapData.x)����(mipmapData.y)������ƫ����(mipmapData.z)��
            // �������ǻض�RT�����ǽ����в㼶mipmap����д�������У�
            // �������������ƫ���������ڶ�λmipmap���ݵĿ�ʼλ��
            var _mipmapData = rtMipmapSizesNativeArray[mipmapLevel];
            // ��̬Mip�㼶ѡ�������Χ�и������ر߳����ڸ�Mip����ߴ磬��ѡ�����ϸ��Mip�㼶
            if(maxPixelCount > _mipmapData.x || maxPixelCount > _mipmapData.y)
                _mipmapData = rtMipmapSizesNativeArray[math.clamp(mipmapLevel - 1, 0, mipmapLevel - 1)];
            int3 mipmapData = new int3(_mipmapData.x, _mipmapData.y, _mipmapData.z); 

            // ���ֵӳ�䵽[0-1]֮��
            // ����ȡ�����������ֵ��OpenGLȡ��Сz��
            // ����ƽ̨Ĭ���Ƿ�ת�ģ�����ȡ���z���ٶȷ�ת��Ҳ����Сz�ˣ�
            var depth = minNDCz;
            if (isOpenGL)
                depth = minNDCz * 0.5f + 0.5f; // OpenGL ndc.z����[-1,1]֮�䣬��Ҫӳ�䵽[0-1]
            if (usesReversedZBuffer)
            {
                depth = maxNDCz;// ����ƽ̨���죺DX11/Metal/Vulkan ʹ�÷���Z��1.0������ �� 0.0��Զ��
                depth = 1f - depth; 
            }
            // �����������ֵ
            float zBufferParamX = 1.0f - farClipPlane / nearClipPlane;
            float zBufferParamY = farClipPlane / nearClipPlane;
            float linear01Depth = 1.0f / (zBufferParamX * depth + zBufferParamY);


            // �����޳����°�Χ�е��ĸ����㶼���ڵ�ס�ˣ��Żᱻ�޳�
            var uv0 = new float2(minNDCx, minNDCy);
            var uv1 = new float2(minNDCx, maxNDCy);
            var uv2 = new float2(maxNDCx, minNDCy);
            var uv3 = new float2(maxNDCx, maxNDCy);
            if (isOccluded(uv0, linear01Depth, mipmapData) &&
                isOccluded(uv1, linear01Depth, mipmapData) &&
                isOccluded(uv2, linear01Depth, mipmapData) &&
                isOccluded(uv3, linear01Depth, mipmapData))
            {
                boundVerts.Dispose();
                return;
            }
          

            if (enabelDebug)
                Debug.Log($"û�б��ڵ��޳���{index}��mipmapData={mipmapData}��mipmapLevel={mipmapLevel}��maxPixelCount={maxPixelCount}");
        }


        var boundsVisible = false;
        if(EnableDrawGrassInstanceBounds && (!onlyGetVisibleBoundsNearPoint || math.distance(nearPoint, grassBounds.center) <= nearDistance))
            boundsVisible = true;
        grassBoundsVisibles[index] = boundsVisible;

        grassVisibles[index] = true;
        boundVerts.Dispose();

    }
    // �����ڵ���ϵ
    bool isOccluded(float2 uv, float depth, int3 mipmapData)
    {
        // �Ƚ�uvӳ�䵽[0-1]֮�䣬
        uv = uv * 0.5f + 0.5f;

        // �޳���Ļ֮������ص�
        var pixel = uv * new float2(ScreenSize.x, ScreenSize.y);
        var isInScreen = pixel.x >= 0 || pixel.y >= 0 || pixel.x <= ScreenSize.x - 1 || pixel.y <= ScreenSize.y - 1;
        if (!isInScreen)
            return true;

        // ��mipmapȡֵʱȷ�������ݷ�Χ�ڣ���ҪԽ�� 
        // ��ȡ��Ӧmipmap��������
        var mipmapSize = new int2(mipmapData.x, mipmapData.y);
        pixel = uv * mipmapSize;
        var pixelX = math.clamp((int)pixel.x, 0, mipmapSize.x -1);
        var pixelY = math.clamp((int)pixel.y, 0, mipmapSize.y -1);
        // �ڶ�Ӧmipmapƫ�����ĵط�ȡֵ
        var mipmapOffset = mipmapData.z;
        var bufferIndex = pixelY * mipmapSize.x + pixelX + mipmapOffset;
        if (bufferIndex < 0 || bufferIndex >= depthDataNativeArray.Length)
            return true;

        // ��ȴ������ͼ��¼����ȣ���ʾ���ڵ�ס��
        return depth > depthDataNativeArray[bufferIndex];
    }
    //��Clip Space�£��������������Clipping����
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
        //���8�����㶼��ĳ�����⣬��϶�����׶������
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
        // ��ȡ�����пɼ�ʵ����visibles�У�
        // ����¼�ɼ�ʵ��������
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

