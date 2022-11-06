using UnityEngine;
using System.Collections;

public class ExtendedFlycam : MonoBehaviour
{

	/*
	EXTENDED FLYCAM
		Desi Quintans (CowfaceGames.com), 17 August 2012.
		Based on FlyThrough.js by Slin (http://wiki.unity3d.com/index.php/FlyThrough), 17 May 2011.

	LICENSE
		Free as in speech, and free as in beer.

	FEATURES
		WASD/Arrows:    Movement
		          Q:    Climb
		          E:    Drop
                      Shift:    Move faster
                    Control:    Move slower
                        End:    Toggle cursor locking to screen (you can also press Ctrl+P to toggle play mode on and off).
	*/

	public float cameraSensitivity = 90;
	public float climbSpeed = 4;
	public float normalMoveSpeed = 10;
	public float slowMoveFactor = 0.25f;
	public float fastMoveFactor = 3;

	private float rotationX = 0.0f;
	private float rotationY = 0.0f;

	void Start()
	{
		Cursor.lockState = CursorLockMode.Locked;
		Cursor.visible = false;
		//Screen.lockCursor = true;
	}

	void Update()
	{
		if( Cursor.lockState != CursorLockMode.None )
		{
			rotationX += Input.GetAxis( "Mouse X" ) * cameraSensitivity * Time.deltaTime;
			rotationY += Input.GetAxis( "Mouse Y" ) * cameraSensitivity * Time.deltaTime;
		}
		rotationY = Mathf.Clamp( rotationY, -90, 90 );

		Quaternion temp = Quaternion.AngleAxis( rotationX, Vector3.up );
		temp *= Quaternion.AngleAxis( rotationY, Vector3.left );

		transform.localRotation = Quaternion.Lerp( transform.localRotation, temp, Time.deltaTime * 5);

		//transform.localRotation = Quaternion.AngleAxis( rotationX, Vector3.up );
		//transform.localRotation *= Quaternion.AngleAxis( rotationY, Vector3.left );

		if( Input.GetKey( KeyCode.LeftShift ) || Input.GetKey( KeyCode.RightShift ) )
		{
			transform.position += transform.forward * ( normalMoveSpeed * fastMoveFactor ) * Input.GetAxis( "Vertical" ) * Time.deltaTime;
			transform.position += transform.right * ( normalMoveSpeed * fastMoveFactor ) * Input.GetAxis( "Horizontal" ) * Time.deltaTime;

			if( Input.GetKey( KeyCode.Q ) ) { transform.position += Vector3.up * climbSpeed * fastMoveFactor * Time.deltaTime; }
			if( Input.GetKey( KeyCode.E ) ) { transform.position -= Vector3.up * climbSpeed * fastMoveFactor * Time.deltaTime; }
		}
		else if( Input.GetKey( KeyCode.LeftControl ) || Input.GetKey( KeyCode.RightControl ) )
		{
			transform.position += transform.forward * ( normalMoveSpeed * slowMoveFactor ) * Input.GetAxis( "Vertical" ) * Time.deltaTime;
			transform.position += transform.right * ( normalMoveSpeed * slowMoveFactor ) * Input.GetAxis( "Horizontal" ) * Time.deltaTime;

			if( Input.GetKey( KeyCode.Q ) ) { transform.position += Vector3.up * climbSpeed * slowMoveFactor * Time.deltaTime; }
			if( Input.GetKey( KeyCode.E ) ) { transform.position -= Vector3.up * climbSpeed * slowMoveFactor * Time.deltaTime; }
		}
		else
		{
			transform.position += transform.forward * normalMoveSpeed * Input.GetAxis( "Vertical" ) * Time.deltaTime;
			transform.position += transform.right * normalMoveSpeed * Input.GetAxis( "Horizontal" ) * Time.deltaTime;

			if( Input.GetKey( KeyCode.Q ) ) { transform.position += Vector3.up * climbSpeed * Time.deltaTime; }
			if( Input.GetKey( KeyCode.E ) ) { transform.position -= Vector3.up * climbSpeed * Time.deltaTime; }
		}

		if( Input.GetKeyDown( KeyCode.End ) || Input.GetKeyDown( KeyCode.Escape ) )
		{
			if( Cursor.lockState == CursorLockMode.None )
			{
				Cursor.lockState = CursorLockMode.Locked;
				Cursor.visible = false;
			} else
			{
				Cursor.lockState = CursorLockMode.None;
				Cursor.visible = true;
			}
			//Cursor.lockState = ( Cursor.lockState == CursorLockMode.Locked ) ? CursorLockMode.None : CursorLockMode.Locked;
			//Screen.lockCursor = ( Screen.lockCursor == false ) ? true : false;
		}
	}
}
