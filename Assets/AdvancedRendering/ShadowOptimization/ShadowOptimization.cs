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

        // ����̫���ⷽ��
        Gizmos.color = Color.red;
        var lightDir = Light.transform.forward;
        Gizmos.DrawLine(Vector3.zero, lightDir * 100);
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
    private bool GetIntersectWithLineAndPlane(Vector3 point, Vector3 direct, Vector3 planeNormal, Vector3 planePoint, out Vector3 result)
    {
        result = Vector3.zero;
        //Ҫע��ֱ�ߺ�ƽ��ƽ�е����
        float d1 = Vector3.Dot(direct.normalized, planeNormal);
        if (d1 == 0) return false;
        float d2 = Vector3.Dot(planePoint - point, planeNormal);
        float d3 = d2 / d1;

        result = d3 * direct.normalized + point;
        return true;
    }


}
