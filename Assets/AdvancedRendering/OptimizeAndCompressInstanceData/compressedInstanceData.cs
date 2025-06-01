using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using UnityEditor.Sprites;
using UnityEngine;
using UnityEngine.UIElements;

/// <summary>
/// 压缩信息
/// <para>用于压缩和数据还原</para>
/// </summary>
public struct CompressedInfo
{
    // position各分量取值范围
    // 也可以像scale一样使用整体的取值范围：posMin，posMax，posRange
    public float posMinX;
    public float posMaxX;
    public float posRangeX;

    public float posMinY;
    public float posMaxY;
    public float posRangeY;

    public float posMinZ;
    public float posMaxZ;
    public float posRangeZ;

    // scale取值范围
    public float scaleMin;
    public float scaleMax;
    public float scaleRange;
}
/// <summary>
/// 压缩的矩阵
/// <para>压缩方法：矩阵分解+量化</para>
/// <para>遍历所有数据，记录取值范围信息(CompressedInfo)，然后再进行量化</para>
/// <para>原始 Matrix4x4：16×float = ​64 字节​</para>
/// <para>压缩后：3×ushort + 4×ushort + 3×ushort = ​20 字节​（压缩率 约​70%​）</para>
/// <para>两个short写入一个uint中，使用位操作，手动打包和解包</para>
/// </summary>
[Serializable]
public struct CompressedMatrix
{
    [Header("Position")]
    public ushort px, py, pz; // Position (quantized)
    [Header("Rotation")]
    public ushort qx, qy, qz, qw; // Rotation (quantized quaternion)
    [Header("Scale")]
    public ushort sx, sy, sz; // Scale (quantized)

    public CompressedMatrix(CompressedInfo info, Vector3 pos, Quaternion r, Vector3 s)
    {
        px = 0;
        py = 0;
        pz = 0;
             
        qx = 0;
        qy = 0;
        qz = 0;
        qw = 0;
             
        sx = 0;
        sy = 0;
        sz = 0;

        Compress(info, pos, r, s);
    }
    public CompressedMatrix(CompressedInfo info, Matrix4x4 matrix) : this(info, matrix.GetPosition(), matrix.rotation, matrix.lossyScale) { }


    public void Compress(CompressedInfo info, Vector3 pos, Quaternion r, Vector3 s)
    {
        // 量化 (x - min) / range
        px = (ushort)((pos.x - info.posMinX) / info.posRangeX * 65535);
        py = (ushort)((pos.y - info.posMinY) / info.posRangeY * 65535);
        pz = (ushort)((pos.z - info.posMinZ) / info.posRangeZ * 65535);

        // 四元数各个分量在[-1,1]，映射到[0,1]
        qx = (ushort)((r.x * 0.5f + 0.5f) * 65535);
        qy = (ushort)((r.y * 0.5f + 0.5f) * 65535);
        qz = (ushort)((r.z * 0.5f + 0.5f) * 65535);
        qw = (ushort)((r.w * 0.5f + 0.5f) * 65535);

        // 量化 (x - min) / range
        sx = (ushort)((s.x - info.scaleMin) / info.scaleRange * 65535);
        sy = (ushort)((s.y - info.scaleMin) / info.scaleRange * 65535);
        sz = (ushort)((s.z - info.scaleMin) / info.scaleRange * 65535);
    }
    public Matrix4x4 Decompress(CompressedInfo info)
    {
        var pos = new Vector3(
            px / 65535f * info.posRangeX + info.posMinX,
            py / 65535f * info.posRangeY + info.posMinY,
            pz / 65535f * info.posRangeZ + info.posMinZ
        );
        var r = new Quaternion(
            (qx / 65535f - 0.5f) * 2f,
            (qy / 65535f - 0.5f) * 2f,
            (qz / 65535f - 0.5f) * 2f,
            (qw / 65535f - 0.5f) * 2f
        ).normalized;
        var s = new Vector3(
            sx / 65535f * info.scaleRange + info.scaleMin,
            sy / 65535f * info.scaleRange + info.scaleMin,
            sz / 65535f * info.scaleRange + info.scaleMin
        );
        return Matrix4x4.TRS(pos, r, s);
    }

    public uint[] pack(uint[] packed = null)
    {
        if (packed == null)
            packed = new uint[5];

        // 一个uint 存入 两个ushort: 低16位，高16位
        packed[0] = ((uint)px & 0xFFFF) | ((uint)py << 16);
        packed[1] = ((uint)pz & 0xFFFF) | ((uint)qx << 16);
        packed[2] = ((uint)qy & 0xFFFF) | ((uint)qz << 16);
        packed[3] = ((uint)qw & 0xFFFF) | ((uint)sx << 16);
        packed[4] = ((uint)sy & 0xFFFF) | ((uint)sz << 16);

        return packed;
    }
    public void unpack(uint[] packed, int index = 0)
    {
        px = (ushort)(packed[index + 0] & 0xFFFF);
        py = (ushort)(packed[index + 0] >> 16);
        pz = (ushort)(packed[index + 1] & 0xFFFF);

        qx = (ushort)(packed[index + 1] >> 16);
        qy = (ushort)(packed[index + 2] & 0xFFFF);
        qz = (ushort)(packed[index + 2] >> 16);
        qw = (ushort)(packed[index + 3] & 0xFFFF);

        sx = (ushort)(packed[index + 3] >> 16);
        sy = (ushort)(packed[index + 4] & 0xFFFF);
        sz = (ushort)(packed[index + 4] >> 16);
    }

    public static int stride => sizeof(ushort) * 3 + sizeof(ushort) * 4 + sizeof(ushort) * 3;
    public const int packedCount = 5;
    public override string ToString() => $"quantized: (position:{px},{py},{pz}), (rotation:{qx},{qy},{qz},{qw}), (scale:{sx},{sy},{sz})";
}

public class compressedInstanceData : MonoBehaviour
{

    public GameObject[] Cubes;
    public CompressedMatrix[] CompressedCubeDatas;
    public uint[] packed;
    public bool enablePack;

    void Start()
    {
        // Matrix4x4: 16个float,占用64个字节
        // 压缩方法：矩阵分解+量化
        // 将矩阵分解为*Position + Rotation + Scale，然后分别压缩
        // position: 计算所有实例坐标范围，使用ushort量化,(x - min) / range * 65535
        // rotation: 四元数每个分量在[-1,1]，可以使用ushort量化, 先将值映射到[0-1], (x * 0.5 + 0.5) * 65535
        // scale: 计算缩放范围，使用ushort量化，(x - min) / range * 65535
        //Matrix4x4 matrix = new Matrix4x4();
        //var position = matrix.GetPosition();
        //var rotation = matrix.rotation;
        //var scale = matrix.lossyScale;


        // position各分量的最小最大值和范围
        // 这里单独给x，y，z统计取值范围，
        // 实际上也可以跟scale一样，只用posMin，posMax，posRange
        float posMinX = float.MaxValue, posMaxX = float.MinValue, posRangeX;
        float posMinY = float.MaxValue, posMaxY = float.MinValue, posRangeY;
        float posMinZ = float.MaxValue, posMaxZ = float.MinValue, posRangeZ;
        // scale最小最大值和范围
        float scaleMin = float.MaxValue, scaleMax = float.MinValue, scaleRange;
        for(var i = 0; i < Cubes.Length; ++i)
        {
            var cube = Cubes[i];
            var pos = cube.transform.position;
            var s = cube.transform.lossyScale;

            if (pos.x > posMaxX) posMaxX = pos.x;
            if (pos.x < posMinX) posMinX = pos.x;
            if (pos.y > posMaxY) posMaxY = pos.y;
            if (pos.y < posMinY) posMinY = pos.y;
            if (pos.z > posMaxZ) posMaxZ = pos.z;
            if (pos.z < posMinZ) posMinZ = pos.z;

            if (s.x > scaleMax) scaleMax = s.x;
            if (s.y > scaleMax) scaleMax = s.y;
            if (s.z > scaleMax) scaleMax = s.z;
            if (s.x < scaleMin) scaleMin = s.x;
            if (s.y < scaleMin) scaleMin = s.y;
            if (s.z < scaleMin) scaleMin = s.z;
        }
        posRangeX = posMaxX - posMinX;
        posRangeY = posMaxY - posMinY;
        posRangeZ = posMaxZ - posMinZ;
        scaleRange = scaleMax - scaleMin;
        Debug.Log($"posRangeX={posRangeX}, posRangeY={posRangeY}, posRangeZ={posRangeZ}, scaleRange={scaleRange}");

        // 压缩信息，用于压缩和数据还原
        var info = new CompressedInfo()
        {
            posMinX = posMinX,
            posMaxX = posMaxX,
            posRangeX = posRangeX,
            posMinY = posMinY,
            posMaxY = posMaxY,
            posRangeY = posRangeY,
            posMinZ = posMinZ,
            posMaxZ = posMaxZ,
            posRangeZ = posRangeZ,

            scaleMin = scaleMin,
            scaleMax= scaleMax,
            scaleRange = scaleRange,
        };
        packed = new uint[Cubes.Length * CompressedMatrix.packedCount];
        CompressedCubeDatas = new CompressedMatrix[Cubes.Length];
        uint[] tempPacked = null;
        for(var i = 0; i < Cubes.Length; ++i)
        {
            var cube = Cubes[i];
            var pos = cube.transform.position;
            var r = cube.transform.rotation;
            var s = cube.transform.lossyScale;

            CompressedCubeDatas[i].Compress(info, pos, r, s);
            tempPacked = CompressedCubeDatas[i].pack(tempPacked);
            packed[i * 5 + 0] = tempPacked[0];
            packed[i * 5 + 1] = tempPacked[1];
            packed[i * 5 + 2] = tempPacked[2];
            packed[i * 5 + 3] = tempPacked[3];
            packed[i * 5 + 4] = tempPacked[4];

        }

        var compressedMatrix = new CompressedMatrix();
        var root = new GameObject("DecompressRoot").transform;
        for(var i = 0; i < CompressedCubeDatas.Length; ++i)
        {
            if (enablePack)
                compressedMatrix.unpack(packed, i * CompressedMatrix.packedCount);
            else
                compressedMatrix = CompressedCubeDatas[i];
            var decompressMatrix = compressedMatrix.Decompress(info);
            var cube = GameObject.CreatePrimitive(PrimitiveType.Cube);
            cube.name = $"cube-{i}";
            cube.transform.position = decompressMatrix.GetPosition();
            cube.transform.rotation = decompressMatrix.rotation;
            cube.transform.localScale = decompressMatrix.lossyScale;
            cube.transform.parent = root;
        }



    }


}
