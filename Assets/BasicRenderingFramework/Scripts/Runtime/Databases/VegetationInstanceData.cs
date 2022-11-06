using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// ֲ��ʵ������
    /// </summary>
    [Serializable]
    public struct VegetationInstanceData
    {
        /// <summary>
        /// ��Χ�����ĵ�
        /// </summary>
        public Vector3 center;
        /// <summary>
        /// ��Χ�б߽��ķ�Χ�� ��ʼ���ǰ�Χ�д�С��һ�롣
        /// </summary>
        public Vector3 extents;
        /// <summary>
        /// ����(ʵ��λ�á���ת������)
        /// </summary>
        public Matrix4x4 matrix;
        /// <summary>
        /// ��ǰʵ��ID
        /// </summary>
        public int InstanceID;
        /// <summary>
        /// ��ǰʵ����ģ��ԭ��ID
        /// </summary>
        public int ModelPrototypeID;

        /// <summary>
        /// ����ʵ����ռ�ֽ���
        /// </summary>
        public static int stride => sizeof(float) * (3 + 3 + 16) + sizeof(int) * (1 + 1);
        public override string ToString() => $"(ʵ��ID: {InstanceID}, ģ��ԭ��ID: {ModelPrototypeID}, Pos: {new Vector3(matrix.m03, matrix.m13, matrix.m23)} , Bounds: (center: {center}, size: {extents*2}))";
    
        public void Write(BinaryWriter binaryWriter)
        {
            binaryWriter.Write(center.x);
            binaryWriter.Write(center.y);
            binaryWriter.Write(center.z);

            binaryWriter.Write(extents.x);
            binaryWriter.Write(extents.y);
            binaryWriter.Write(extents.z);

            binaryWriter.Write(matrix.m00);
            binaryWriter.Write(matrix.m10);
            binaryWriter.Write(matrix.m20);
            binaryWriter.Write(matrix.m30);
            binaryWriter.Write(matrix.m01);
            binaryWriter.Write(matrix.m11);
            binaryWriter.Write(matrix.m21);
            binaryWriter.Write(matrix.m31);
            binaryWriter.Write(matrix.m02);
            binaryWriter.Write(matrix.m12);
            binaryWriter.Write(matrix.m22);
            binaryWriter.Write(matrix.m32);
            binaryWriter.Write(matrix.m03);
            binaryWriter.Write(matrix.m13);
            binaryWriter.Write(matrix.m23);
            binaryWriter.Write(matrix.m33);

            binaryWriter.Write(InstanceID);
            binaryWriter.Write(ModelPrototypeID);
        }
        public void ReadFromBuffer(byte[] buffer, int startIndex)
        {
            var centerx = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            var centery = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            var centerz = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            center = new Vector3(centerx, centery, centerz);

            var extentsx = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            var extentsy = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            var extentsz = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            extents = new Vector3(extentsx, extentsy, extentsz);

            matrix.m00 = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            matrix.m10 = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            matrix.m20 = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            matrix.m30 = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            matrix.m01 = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            matrix.m11 = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            matrix.m21 = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            matrix.m31 = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            matrix.m02 = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            matrix.m12 = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            matrix.m22 = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            matrix.m32 = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            matrix.m03 = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            matrix.m13 = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            matrix.m23 = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);
            matrix.m33 = BitConverter.ToSingle(buffer, startIndex); startIndex += sizeof(float);

            InstanceID = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
            ModelPrototypeID = BitConverter.ToInt32(buffer, startIndex); startIndex += sizeof(int);
        }
    }
}
