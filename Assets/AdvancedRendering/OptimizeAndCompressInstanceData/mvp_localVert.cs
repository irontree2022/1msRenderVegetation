using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

public class mvp_localVert : MonoBehaviour
{
    public GameObject Cube;
    public Image Image;
    public Text Text;

    private Mesh mesh;
    private RectTransform imageRectTransform;
    void Start()
    {
        mesh = Cube.GetComponent<MeshFilter>().sharedMesh;
        imageRectTransform = Image.GetComponent<RectTransform>();
    }


    private Vector4[] boundsVerts = new Vector4[8];
    private Vector3[] obbBoundsVerts = new Vector3[8];
    private Bounds calculatedBounds;
    void Update()
    {
        var localBounds = mesh.bounds;
        var localBoundsCenter = localBounds.center;
        var localBoundsExtents = localBounds.extents;
        // ģ�Ϳռ�8������
        boundsVerts[0] = new Vector4(
            localBoundsCenter.x - localBoundsExtents.x,
            localBoundsCenter.y - localBoundsExtents.y,
            localBoundsCenter.z - localBoundsExtents.z,
            1f);
        boundsVerts[1] = new Vector4(
            localBoundsCenter.x + localBoundsExtents.x,
            localBoundsCenter.y - localBoundsExtents.y,
            localBoundsCenter.z - localBoundsExtents.z,
            1f);
        boundsVerts[2] = new Vector4(
            localBoundsCenter.x + localBoundsExtents.x,
            localBoundsCenter.y - localBoundsExtents.y,
            localBoundsCenter.z + localBoundsExtents.z,
            1f);
        boundsVerts[3] = new Vector4(
            localBoundsCenter.x - localBoundsExtents.x,
            localBoundsCenter.y - localBoundsExtents.y,
            localBoundsCenter.z + localBoundsExtents.z,
            1f);
        boundsVerts[4] = new Vector4(
            localBoundsCenter.x - localBoundsExtents.x,
            localBoundsCenter.y + localBoundsExtents.y,
            localBoundsCenter.z - localBoundsExtents.z,
            1f);
        boundsVerts[5] = new Vector4(
            localBoundsCenter.x + localBoundsExtents.x,
            localBoundsCenter.y + localBoundsExtents.y,
            localBoundsCenter.z - localBoundsExtents.z,
            1f);
        boundsVerts[6] = new Vector4(
            localBoundsCenter.x + localBoundsExtents.x,
            localBoundsCenter.y + localBoundsExtents.y,
            localBoundsCenter.z + localBoundsExtents.z,
            1f);
        boundsVerts[7] = new Vector4(
            localBoundsCenter.x - localBoundsExtents.x,
            localBoundsCenter.y + localBoundsExtents.y,
            localBoundsCenter.z + localBoundsExtents.z,
            1f);

        // -------------------------------- ģ�Ϳռ�AABBת��������ռ�AABB -------------------------------
        var min = obbBoundsVerts[0];
        var max = obbBoundsVerts[0];
        // M����
        var m = Matrix4x4.TRS(Cube.transform.position, Cube.transform.rotation, Cube.transform.lossyScale);
        for(var i = 0; i < boundsVerts.Length; i++)
        {
            var boundsVert = boundsVerts[i];
            // ��ģ�Ϳռ�AABBת��������ռ�OBB
            obbBoundsVerts[i] = m * boundsVert;
            // ��OBB������AABB
            if(i == 0)
            {
                min = obbBoundsVerts[i];
                max = obbBoundsVerts[i];
            }
            else
            {
                min = Vector3.Min(min, obbBoundsVerts[i]);
                max = Vector3.Max(max, obbBoundsVerts[i]);
            }
        }
        // ����ռ�AABB
        calculatedBounds.min = min; 
        calculatedBounds.max = max;



        // -------------------------------- ģ�Ϳռ�AABBת����NDC -------------------------------
        var v = Camera.main.worldToCameraMatrix;
        var p = GL.GetGPUProjectionMatrix(Camera.main.projectionMatrix, false);
        var mvp = p * v * m;
        //NDC���µĵ�AABB��������
        float minX = 1, minY = 1, minZ = 1, maxX = -1, maxY = -1, maxZ = -1;
        for(var i = 0; i < boundsVerts.Length; ++i)
        {
            var boundsVert = boundsVerts[i];
            // ת�����ü��ռ�
            var clipSpace = mvp * new Vector4(boundsVert.x, boundsVert.y, boundsVert.z, 1f);
            // ͸�ӳ���ת����NDC
            var ndc = new Vector3(clipSpace.x, clipSpace.y, clipSpace.z) / clipSpace.w;
            //����ndc�µ��µ�AABB
            if (minX > ndc.x) minX = ndc.x;
            if (minY > ndc.y) minY = ndc.y;
            if (minZ > ndc.z) minZ = ndc.z;
            if (maxX < ndc.x) maxX = ndc.x;
            if (maxY < ndc.y) maxY = ndc.y;
            if (maxZ < ndc.z) maxZ = ndc.z;
        }
        // ��������Ļ���ǵ�����
        var minUV = new Vector2(minX, minY);
        minUV = minUV * 0.5f;
        minUV = new Vector2(minUV.x + 0.5f, minUV.y + 0.5f);
        var maxUV = new Vector2(maxX, maxY);
        maxUV = maxUV * 0.5f;
        maxUV = new Vector2(maxUV.x + 0.5f, maxUV.y + 0.5f);
        var uvSize = new Vector2((maxUV.x - minUV.x) * Screen.width, (maxUV.y - minUV.y) * Screen.height);
        // ���ĵ�����
        var uvCenter = new Vector2((minX + maxX) / 2f, (minY + maxY) / 2f) * 0.5f;
        uvCenter = new Vector2(uvCenter.x + 0.5f, uvCenter.y + 0.5f);
        var pixel = uvCenter * new Vector2(Screen.width, Screen.height);


        // ����UIԪ��
        imageRectTransform.anchoredPosition = pixel;
        imageRectTransform.sizeDelta = uvSize;
        Text.text = $"��������:{(int)uvSize.x}x{(int)uvSize.y}\n��Ļ���꣺{pixel}";
    }

    private void OnDrawGizmos()
    {
        // ����OBB�Լ���������
        Gizmos.color = Color.yellow;
        for (var i = 0; i < obbBoundsVerts.Length; ++i)
        {
            Gizmos.DrawSphere(obbBoundsVerts[i], 0.05f);
            Handles.Label(obbBoundsVerts[i], $"{i}");
        }
        Gizmos.DrawLine(obbBoundsVerts[0], obbBoundsVerts[1]);
        Gizmos.DrawLine(obbBoundsVerts[0], obbBoundsVerts[3]);
        Gizmos.DrawLine(obbBoundsVerts[1], obbBoundsVerts[2]);
        Gizmos.DrawLine(obbBoundsVerts[3], obbBoundsVerts[2]);

        Gizmos.DrawLine(obbBoundsVerts[4], obbBoundsVerts[5]);
        Gizmos.DrawLine(obbBoundsVerts[4], obbBoundsVerts[7]);
        Gizmos.DrawLine(obbBoundsVerts[5], obbBoundsVerts[6]);
        Gizmos.DrawLine(obbBoundsVerts[7], obbBoundsVerts[6]);

        Gizmos.DrawLine(obbBoundsVerts[0], obbBoundsVerts[4]);
        Gizmos.DrawLine(obbBoundsVerts[1], obbBoundsVerts[5]);
        Gizmos.DrawLine(obbBoundsVerts[2], obbBoundsVerts[6]);
        Gizmos.DrawLine(obbBoundsVerts[3], obbBoundsVerts[7]);


        // ����AABB
        Gizmos.color = Color.green;
        Gizmos.DrawWireCube(calculatedBounds.center, calculatedBounds.size);
    }

}
