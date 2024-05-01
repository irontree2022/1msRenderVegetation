using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShadowOptimization : MonoBehaviour
{

    public GameObject p0;
    public GameObject p1;
    public GameObject result;
    public GameObject plane;

    public Light Light;


    private void OnDrawGizmos()
    {
        var dir = p1.transform.position - p0.transform.position;
        var ok = GetIntersectWithLineAndPlane(p0.transform.position, dir.normalized, plane.transform.up, plane.transform.position, out Vector3 resultPoint);
        result.SetActive(ok);
        result.transform.position = resultPoint;
        Gizmos.DrawLine(p0.transform.position, p1.transform.position);

        // 画出太阳光方向
        Gizmos.color = Color.red;
        var lightDir = Light.transform.forward;
        Gizmos.DrawLine(Vector3.zero, lightDir * 100);
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
    private bool GetIntersectWithLineAndPlane(Vector3 point, Vector3 direct, Vector3 planeNormal, Vector3 planePoint, out Vector3 result)
    {
        result = Vector3.zero;
        //要注意直线和平面平行的情况
        float d1 = Vector3.Dot(direct.normalized, planeNormal);
        if (d1 == 0) return false;
        float d2 = Vector3.Dot(planePoint - point, planeNormal);
        float d3 = d2 / d1;

        result = d3 * direct.normalized + point;
        return true;
    }


}
