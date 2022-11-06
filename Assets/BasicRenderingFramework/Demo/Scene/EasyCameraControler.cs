using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RenderVegetationIn1ms
{
    public class EasyCameraControler : MonoBehaviour
    {
        public GameObject Target;

        private Vector3 dirVector3;
        private Vector3 rotaVector3;


        [Header("�����������Χ��0������ʾ������")]
        public float dis = 100000;

        [Header("�ƶ�����")]
        public float paramater = 0.25f;
        [Header("ʹ����������ת")]
        public bool useMouse = true;
        [Header("ʹ�ü��̵��������Ҽ�ͷ������ת")]
        public bool useUp_down_left_and_rightArrows = true;
        [Header("x��ת����")]
        public float xspeed = 10f;
        [Header("y��ת����")]
        public float yspeed = 10f;
        [Header("��ͣ")]
        public KeyCode stopKeyCode = KeyCode.Escape;

        bool stop = false;
        void Start()
        {

            if (Target == null)
            {
                Target = Camera.main.gameObject;
            }

            rotaVector3 = Target.transform.localEulerAngles;
        }

        void Update()
        {
            if (Input.GetKeyUp(stopKeyCode))
                stop = true;
            if (Input.GetMouseButtonUp(0))
                stop = false;
            if (stop) return;
            //�ƶ�
            dirVector3 = Vector3.zero;

            if (Input.GetKey(KeyCode.W))
            {
                if (Input.GetKey(KeyCode.LeftShift)) dirVector3.z = 3;
                else dirVector3.z = 1;
            }
            if (Input.GetKey(KeyCode.S))
            {
                if (Input.GetKey(KeyCode.LeftShift)) dirVector3.z = -3;
                else dirVector3.z = -1;
            }
            if (Input.GetKey(KeyCode.A))
            {
                if (Input.GetKey(KeyCode.LeftShift)) dirVector3.x = -3;
                else dirVector3.x = -1;
            }
            if (Input.GetKey(KeyCode.D))
            {
                if (Input.GetKey(KeyCode.LeftShift)) dirVector3.x = 3;
                else dirVector3.x = 1;
            }
            if (Input.GetKey(KeyCode.Q))
            {
                if (Input.GetKey(KeyCode.LeftShift)) dirVector3.y = -3;
                else dirVector3.y = -1;
            }
            if (Input.GetKey(KeyCode.E))
            {
                if (Input.GetKey(KeyCode.LeftShift)) dirVector3.y = 3;
                else dirVector3.y = 1;
            }
            Target.transform.Translate(dirVector3 * paramater, Space.Self);

            //��ת
            if (useMouse)
            {
                useUp_down_left_and_rightArrows = false;
                float horizontal = Input.GetAxis("Mouse X");
                float vertical = Input.GetAxis("Mouse Y");
                rotaVector3.y += horizontal * yspeed ;
                rotaVector3.x += -vertical * xspeed ;
                Target.transform.rotation = Quaternion.Euler(rotaVector3);
            }
            if (useUp_down_left_and_rightArrows)
            {
                useMouse = false;
                rotaVector3.y += Input.GetAxis("Horizontal") * yspeed;
                rotaVector3.x += Input.GetAxis("Vertical") * xspeed;
                Target.transform.rotation = Quaternion.Euler(rotaVector3);
            }

            if (dis > 0)
                //�����������Χ
                Target.transform.position = Vector3.ClampMagnitude(Target.transform.position, dis);
        }

        bool ck = false;
        private void OnApplicationFocus(bool focus)
        {
            ck = focus;
        }
    }
}
