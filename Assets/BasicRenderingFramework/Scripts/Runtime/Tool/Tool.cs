using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// 工具类
    /// <para>一些工具函数</para>
    /// </summary>
    public class Tool
    {
        /// <summary>
        /// 一个点和一个法向量确定一个平面
        /// </summary>
        public static Vector4 GetPlane(Vector3 normal, Vector3 point)
        {
            return new Vector4(normal.x, normal.y, normal.z, -Vector3.Dot(normal, point));
        }
        /// <summary>
        /// 三点确定一个平面
        /// </summary>
        public static Vector4 GetPlane(Vector3 a, Vector3 b, Vector3 c)
        {
            Vector3 normal = Vector3.Normalize(Vector3.Cross(b - a, c - a));
            return GetPlane(normal, a);
        }
        /// <summary>
        /// 获取视锥体远平面的四个点
        /// </summary>
        public static Vector3[] GetCameraFarClipPlanePoint(Camera camera)
        {
            Vector3[] points = new Vector3[4];
            Transform transform = camera.transform;
            float distance = camera.farClipPlane;
            float halfFovRad = Mathf.Deg2Rad * camera.fieldOfView * 0.5f;
            float upLen = distance * Mathf.Tan(halfFovRad);
            float rightLen = upLen * camera.aspect;
            Vector3 farCenterPoint = transform.position + distance * transform.forward;
            Vector3 up = upLen * transform.up;
            Vector3 right = rightLen * transform.right;
            points[0] = farCenterPoint - up - right;//left-bottom
            points[1] = farCenterPoint - up + right;//right-bottom
            points[2] = farCenterPoint + up - right;//left-up
            points[3] = farCenterPoint + up + right;//right-up
            return points;
        }
        /// <summary>
        /// 获取视锥体的六个平面
        /// </summary>
        public static Vector4[] GetFrustumPlanes(Camera camera, Vector4[] planes = null)
        {
            if (planes == null) planes = new Vector4[6];
            Transform transform = camera.transform;
            Vector3 cameraPosition = transform.position;
            Vector3[] points = GetCameraFarClipPlanePoint(camera);
            //顺时针
            planes[0] = GetPlane(cameraPosition, points[0], points[2]);//left
            planes[1] = GetPlane(cameraPosition, points[3], points[1]);//right
            planes[2] = GetPlane(cameraPosition, points[1], points[0]);//bottom
            planes[3] = GetPlane(cameraPosition, points[2], points[3]);//up
            planes[4] = GetPlane(-transform.forward, transform.position + transform.forward * camera.nearClipPlane);//near
            planes[5] = GetPlane(transform.forward, transform.position + transform.forward * camera.farClipPlane);//far
            return planes;
        }
        /// <summary>
        /// 计算视锥体平截头
        /// </summary>
        public static void CalculateFrustumPlanes(Camera camera, Plane[] FrustumPlanes_CPU) => GeometryUtility.CalculateFrustumPlanes(camera, FrustumPlanes_CPU);
        /// <summary>
        /// 测试包围盒是否位于视锥体内
        /// </summary>
        public static bool TestPlanesAABB(Camera camera, Bounds bounds, Plane[] FrustumPlanes_CPU) => GeometryUtility.TestPlanesAABB(FrustumPlanes_CPU, bounds);
        /// <summary>
        /// 从矩阵中提取位置数据
        /// </summary>
        public static Vector4 ExtractPositionFromMatrix(Matrix4x4 matrix)
        {
            return matrix.GetColumn(3);
        }
        /// <summary>
        /// 从矩阵中提取旋转数据
        /// </summary>
        public static Quaternion ExtractRotationFromMatrix(Matrix4x4 matrix)
        {
            return Quaternion.LookRotation(
                matrix.GetColumn(2),
                matrix.GetColumn(1));
        }
        /// <summary>
        /// 从矩阵中提取缩放数据
        /// </summary>
        public static Vector3 ExtractScaleFromMatrix(Matrix4x4 matrix)
        {
            return new Vector3(
                matrix.GetColumn(0).magnitude,
                matrix.GetColumn(1).magnitude,
                matrix.GetColumn(2).magnitude);
        }
        /// <summary>
        /// 从矩阵中提取出各项数据
        /// </summary>
        public static void ExtractMatrix(Matrix4x4 matrix, out Vector3 position, out Quaternion rotation, out Vector3 scale)
        {
            // Extract new local position
            position = matrix.GetColumn(3);

            // Extract new local rotation
            rotation = Quaternion.LookRotation(
                matrix.GetColumn(2),
                matrix.GetColumn(1));

            // Extract new local scale
            scale = new Vector3(
                matrix.GetColumn(0).magnitude,
                matrix.GetColumn(1).magnitude,
                matrix.GetColumn(2).magnitude);
        }
        /// <summary>
        /// 本地矩阵中得到其世界坐标位置
        /// </summary>
        public static Vector3 LocalMatrixToWorldPosition(Matrix4x4 local2WorldTransfMatrix, Matrix4x4 matrix4X4)
        {
            var position = ExtractPositionFromMatrix(matrix4X4);
            var positionv4 = new Vector4(position.x, position.y, position.z, 1);
            return local2WorldTransfMatrix * positionv4;
        }
        /// <summary>
        /// 本地坐标位置中得到其世界坐标位置
        /// </summary>
        public static Vector3 LocalPositionToWorldPosition(Matrix4x4 local2WorldTransfMatrix, Vector3 position)
        {
            var positionv4 = new Vector4(position.x, position.y, position.z, 1);
            return local2WorldTransfMatrix * positionv4;
        }
        /// <summary>
        /// 本地矩阵中得到其世界旋转
        /// </summary>
        public static Quaternion LocalMatrixToWorldRotation(Matrix4x4 local2WorldTransfMatrix, Matrix4x4 matrix4X4)
        {
            var rotation = ExtractRotationFromMatrix(matrix4X4);
            var q = ExtractRotationFromMatrix(local2WorldTransfMatrix);
            return q * rotation;
        }
        /// <summary>
        /// 本地旋转中得到其世界旋转
        /// </summary>
        public static Quaternion LocalRotationToWorldRotation(Matrix4x4 local2WorldTransfMatrix, Quaternion rotation)
        {
            var q = ExtractRotationFromMatrix(local2WorldTransfMatrix);
            return q * rotation;
        }
        /// <summary>
        /// 本地矩阵中得到其世界缩放
        /// </summary>
        public static Vector3 LocalMatrixToWorldScale(Matrix4x4 local2WorldTransfMatrix, Matrix4x4 matrix4X4)
        {
            var scale = ExtractScaleFromMatrix(matrix4X4);
            var s = ExtractScaleFromMatrix(local2WorldTransfMatrix);
            return new Vector3(scale.x * s.x, scale.y * s.y, scale.z * s.z);
        }
        /// <summary>
        /// 本地缩放中得到其世界缩放
        /// </summary>
        public static Vector3 LocalScaleToWorldScale(Matrix4x4 local2WorldTransfMatrix, Vector3 scale)
        {
            var s = ExtractScaleFromMatrix(local2WorldTransfMatrix);
            return new Vector3(scale.x * s.x, scale.y * s.y, scale.z * s.z);
        }

        /// <summary>
        /// 本地矩阵转换成世界矩阵
        /// </summary>
        public static Matrix4x4 LocalMatrixToWorldMatrix(Matrix4x4 local2WorldTransfMatrix, Matrix4x4 matrix4X4)
        {
            Vector3 position = Vector3.zero;
            Quaternion rotation = Quaternion.identity;
            Vector3 scale = Vector3.one;
            ExtractMatrix(matrix4X4, out position, out rotation, out scale);
            var positionv4 = new Vector4(position.x, position.y, position.z, 1);
            position = local2WorldTransfMatrix * positionv4;
            var q = ExtractRotationFromMatrix(local2WorldTransfMatrix);
            rotation = q * rotation;
            var s = ExtractScaleFromMatrix(local2WorldTransfMatrix);
            scale = new Vector3(scale.x * s.x, scale.y * s.y, scale.z * s.z);
            return Matrix4x4.TRS(position, rotation, scale);
        }


        //public static void Matrix4x4ToFloatArray(this Matrix4x4 matrix4x4, float[] floatArray)
        //{
        //    floatArray[0] = matrix4x4[0, 0];
        //    floatArray[1] = matrix4x4[1, 0];
        //    floatArray[2] = matrix4x4[2, 0];
        //    floatArray[3] = matrix4x4[3, 0];
        //    floatArray[4] = matrix4x4[0, 1];
        //    floatArray[5] = matrix4x4[1, 1];
        //    floatArray[6] = matrix4x4[2, 1];
        //    floatArray[7] = matrix4x4[3, 1];
        //    floatArray[8] = matrix4x4[0, 2];
        //    floatArray[9] = matrix4x4[1, 2];
        //    floatArray[10] = matrix4x4[2, 2];
        //    floatArray[11] = matrix4x4[3, 2];
        //    floatArray[12] = matrix4x4[0, 3];
        //    floatArray[13] = matrix4x4[1, 3];
        //    floatArray[14] = matrix4x4[2, 3];
        //    floatArray[15] = matrix4x4[3, 3];
        //}
        public static bool isPointInBounds(Vector3 center, Bounds bounds) => IsInBounds(center, bounds.min, bounds.max);
        public static bool IsInBounds(Vector3 center, Vector3 min, Vector3 max) => center.x >= min.x && center.y >= min.y && center.z >= min.z && center.x <= max.x && center.y <= max.y && center.z <= max.z;
        public static bool isPointInBounds(Vector2 center, Vector2 min, Vector2 max) => (center.x >= min.x && center.y >= min.y && center.x <= max.x && center.y <= max.y);
        public static bool isOutsideBounds(Vector3 center, Vector3 min, Vector3 max) => (center.x < min.x || center.y < min.y || center.z < min.z || center.x > max.x || center.y > max.y || center.z > max.z);
        public static float Distance(Vector3 center, Vector3 min, Vector3 max)
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
            return Mathf.Abs(Vector3.Distance(new Vector3(x, y, z), center));
        }
        public static float Distance(Vector2 center, Vector2 min, Vector2 max)
        {
            var x = center.x;
            var y = center.y;
            if (x < min.x) x = min.x;
            else if (x > max.x) x = max.x;
            if (y < min.y) y = min.y;
            else if (y > max.y) y = max.y;
            return Mathf.Abs(Vector2.Distance(new Vector2(x, y), center));
        }
        private static void GetMeshRenderers(GameObject go, List<MeshRenderer> mrs)
        {
            var mr = go.GetComponent<MeshRenderer>();
            if (mr != null) mrs.Add(mr);
            for (var i = 0; i < go.transform.childCount; i++)
                GetMeshRenderers(go.transform.GetChild(i).gameObject, mrs);
        }
        public static Bounds GetBounds(GameObject _go)
        {
            var mrs = new List<MeshRenderer>();
            GetMeshRenderers(_go, mrs);
            var _bounds = new Bounds();
            var max = _bounds.max;
            var min = _bounds.min;
            for (var i = 0; i < mrs.Count; i++)
            {
                var mr = mrs[i];
                if (i == 0)
                {
                    _bounds = mr.bounds;
                    max = _bounds.max;
                    min = _bounds.min;
                }
                else
                {
                    var tbmax = mr.bounds.max;
                    var tbmin = mr.bounds.min;
                    if (tbmax.x > max.x) max.x = tbmax.x;
                    if (tbmax.y > max.y) max.y = tbmax.y;
                    if (tbmax.z > max.z) max.z = tbmax.z;
                    if (tbmin.x < min.x) min.x = tbmin.x;
                    if (tbmin.y < min.y) min.y = tbmin.y;
                    if (tbmin.z < min.z) min.z = tbmin.z;
                }

            }
            _bounds = new Bounds((max + min) / 2, max - min);
            return _bounds;
        }
        public static void CreateDirectoryIfNotExists(string dir)
        {
            if (!System.IO.Directory.Exists(dir))
                System.IO.Directory.CreateDirectory(dir);
        }
        /// <summary>
        /// 删除文件夹
        /// </summary>
        public static void DeleteDir(string dir)
        {
            if (System.IO.Directory.Exists(dir))
            {
                var dirinfo = new System.IO.DirectoryInfo(dir);
                foreach(var file in dirinfo.GetFiles())
                    System.IO.File.Delete(file.FullName);
                foreach (var _dir in dirinfo.GetDirectories())
                    DeleteDir(_dir.FullName);
            }
        }
        public static void CopyDir(string sourceDir, string dstDir, bool overwrite, System.Action<string> copyStatusAction = null)
        {
            if (System.IO.Directory.Exists(sourceDir))
            {
                System.IO.Directory.CreateDirectory(dstDir);
                var dirinfo = new System.IO.DirectoryInfo(sourceDir);
                foreach (var file in dirinfo.GetFiles())
                {
                    if (copyStatusAction != null) copyStatusAction(file.Name);
                    var dstFilepath = System.IO.Path.Combine(dstDir, file.Name);
                    System.IO.File.Copy(file.FullName, dstFilepath, overwrite);
                }
                foreach (var _dir in dirinfo.GetDirectories())
                    CopyDir(_dir.FullName, System.IO.Path.Combine(dstDir, _dir.Name), overwrite, copyStatusAction);
            }
        }
        public static Vector4 MakeLODLevelsToVector4(GameObject gameObject, LODGroup lodg = null)
        {
            var lodlevels = Vector4.zero;
            if (gameObject)
            {
                if (lodg == null)
                    lodg = gameObject.GetComponent<LODGroup>();
                if (lodg != null && lodg.lodCount > 0)
                {
                    var lods = lodg.GetLODs();
                    for (var i = 0; i < 4 && i < lodg.lodCount; i++)
                    {
                        if (i == 0) lodlevels.x = lods[i].screenRelativeTransitionHeight;
                        else if (i == 1) lodlevels.y = lods[i].screenRelativeTransitionHeight;
                        else if (i == 2) lodlevels.z = lods[i].screenRelativeTransitionHeight;
                        else if (i == 3) lodlevels.w = lods[i].screenRelativeTransitionHeight;
                    }
                }
            }
            return lodlevels;
        }
        public static List<float> MakeLODLevelsToList(GameObject gameObject, LODGroup lodg = null)
        {
            var lodlevels = new List<float>();
            if (gameObject)
            {
                if (lodg == null)
                    lodg = gameObject.GetComponent<LODGroup>();
                if (lodg != null && lodg.lodCount > 0)
                {
                    var lods = lodg.GetLODs();
                    for (var i = 0; i < lodg.lodCount; i++)
                        lodlevels.Add(lods[i].screenRelativeTransitionHeight);
                }
            }
            return lodlevels;
        }
        private static Matrix4x4 zeroMt = new Matrix4x4();
        public static Matrix4x4 ZeroMatrix4x4 { get => zeroMt; }
        public static string CreateMD5(string input)
        {
            // Use input string to calculate MD5 hash
            using (System.Security.Cryptography.MD5 md5 = System.Security.Cryptography.MD5.Create())
            {
                byte[] inputBytes = System.Text.Encoding.UTF8.GetBytes(input);
                byte[] hashBytes = md5.ComputeHash(inputBytes);

                // Convert the byte array to hexadecimal string
                var sb = new System.Text.StringBuilder();
                for (int i = 0; i < hashBytes.Length; i++)
                {
                    sb.Append(hashBytes[i].ToString("X2"));
                }
                return sb.ToString();
            }
        }
        /// <summary>
        /// 切割空间
        /// <para>以 x z 平面切割区块，y方向不变</para>
        /// </summary>
        /// <param name="_bounds">原始空间包围盒</param>
        /// <param name="splitSize">切割尺寸</param>
        /// <returns></returns>
        public static List<Bounds> GetSplitBounds(Bounds _bounds, int nextBlockReductionFactor)
        {
            var bounds = new List<Bounds>();
            int splitSizex = (int)_bounds.size.x / nextBlockReductionFactor;
            int splitSizez = (int)_bounds.size.z / nextBlockReductionFactor;
            for (var i = 0; i < nextBlockReductionFactor; i++)
            {
                for (var j = 0; j < nextBlockReductionFactor; j++)
                {
                    var b = new Bounds();
                    b.min = new Vector3(_bounds.min.x + j * splitSizex, _bounds.min.y, _bounds.min.z + i * splitSizez);
                    b.max = new Vector3(b.min.x + splitSizex, _bounds.max.y, b.min.z + splitSizez);
                    bounds.Add(b);
                }
            }
            return bounds;
        }
        public static bool IsPowerOf2(long n) => (n & (n - 1)) == 0; 
        public static int GetPowerOf2Value(double n)
        {
            var _n = (int)n;
            if (n > _n) ++_n;
            while (!IsPowerOf2(_n)) ++_n;
            return _n;
        }
    }
}
