//Stripped down version from https://sharpcoderblog.com/blog/unity-3d-fps-controller

#if ENABLE_LEGACY_INPUT_MANAGER

using UnityEngine;

namespace TheVegetationEngine
{
    [RequireComponent(typeof(CharacterController))]
    public class TVESimpleFPSController : MonoBehaviour
    {
        public float walkingSpeed = 2.0f;
        public float lookSpeed = 2.0f;
        public float lookXLimit = 45.0f;

        [Space(10)]
        public Camera playerCamera;

        CharacterController characterController;
        float rotationX = 0;

        void Start()
        {
            characterController = GetComponent<CharacterController>();

            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }

        void Update()
        {
            Vector3 forward = transform.TransformDirection(Vector3.forward);
            Vector3 right = transform.TransformDirection(Vector3.right);
            Vector3 moveDirection = (forward * walkingSpeed * Input.GetAxis("Vertical")) + (right * walkingSpeed * Input.GetAxis("Horizontal"));

            characterController.Move(moveDirection * Time.deltaTime);

            rotationX += -Input.GetAxis("Mouse Y") * lookSpeed;
            rotationX = Mathf.Clamp(rotationX, -lookXLimit, lookXLimit);
            playerCamera.transform.localRotation = Quaternion.Euler(rotationX, 0, 0);
            transform.rotation *= Quaternion.Euler(0, Input.GetAxis("Mouse X") * lookSpeed, 0);

        }
    }
}
#endif