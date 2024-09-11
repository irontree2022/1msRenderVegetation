using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WorldMigration_AddDeleteModifyQuery_CollisionDetection : MonoBehaviour
{

    Vector3 offset;
    Matrix4x4[] allInstances;
    void Start()
    {
        allInstances = new Matrix4x4[1000];
        for(var i = 0; i < allInstances.Length; ++i)
        {
            var mat4x4 = allInstances[i];
            var pos = mat4x4.GetPosition();
            pos += offset;
            var r = mat4x4.rotation;
            var s = mat4x4.lossyScale;

            allInstances[i] = Matrix4x4.TRS(pos, r, s); 
        }
    }


    void Update()
    {
        
    }
}
