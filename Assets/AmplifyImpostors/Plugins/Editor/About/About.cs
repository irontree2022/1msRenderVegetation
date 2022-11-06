// Amplify Impostors
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using UnityEngine;
using UnityEditor;

namespace AmplifyImpostors
{
	public class About : EditorWindow
	{
		private const string AboutImageGUID = "f6d52893e066905409ec8ac1bde8d300";
		private Vector2 m_scrollPosition = Vector2.zero;
		private Texture2D m_aboutImage;

		[MenuItem( "Window/Amplify Impostors/Manual", false, 998 )]
		static void OpenManual()
		{
			Application.OpenURL( "http://wiki.amplify.pt/index.php?title=Unity_Products:Amplify_Impostors/Manual" );
		}

		[MenuItem( "Window/Amplify Impostors/About...", false, 999 )]
		static void Init()
		{
			About window = (About)GetWindow( typeof( About ), true, "About Amplify Impostors" );
			window.minSize = new Vector2( 502, 250 );
			window.maxSize = new Vector2( 502, 250 );
			window.Show();
		}

		private void OnEnable()
		{
			m_aboutImage = AssetDatabase.LoadAssetAtPath<Texture2D>( AssetDatabase.GUIDToAssetPath( AboutImageGUID ) );
		}

		public void OnGUI()
		{
			m_scrollPosition = GUILayout.BeginScrollView( m_scrollPosition );

			GUILayout.BeginVertical();

			GUILayout.Space( 10 );

			GUILayout.BeginHorizontal();
			GUILayout.FlexibleSpace();
			GUILayout.Box( m_aboutImage, GUIStyle.none );

			if( Event.current.type == EventType.MouseUp && GUILayoutUtility.GetLastRect().Contains( Event.current.mousePosition ) )
				Application.OpenURL( "http://www.amplify.pt" );

			GUILayout.FlexibleSpace();
			GUILayout.EndHorizontal();

			GUIStyle labelStyle = new GUIStyle( EditorStyles.label );
			labelStyle.alignment = TextAnchor.MiddleCenter;
			labelStyle.wordWrap = true;

			GUILayout.Label( "\nAmplify Impostors " + VersionInfo.StaticToString(), labelStyle, GUILayout.ExpandWidth( true ) );

			GUILayout.Label( "\nCopyright (c) Amplify Creations, Lda. All rights reserved.\n", labelStyle, GUILayout.ExpandWidth( true ) );

			GUILayout.EndVertical();

			GUILayout.EndScrollView();
		}
	}
}
