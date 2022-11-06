// Amplify Impostors
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif
namespace AmplifyImpostors
{
	public static class ImpostorBakingTools
	{
		public static readonly string PrefGlobalFolder = "IMPOSTORS_GLOBALFOLDER";
		public static readonly string PrefGlobalRelativeFolder = "IMPOSTORS_GLOBALRELATIVEFOLDER";
		public static readonly string PrefGlobalDefault = "IMPOSTORS_GLOBALDEFAULT";
		public static readonly string PrefGlobalTexImport = "IMPOSTORS_GLOBALTEXIMPORT";
		public static readonly string PrefGlobalCreateLodGroup = "IMPOSTORS_GLOBALCREATELODGROUP ";
		public static readonly string PrefGlobalGBuffer0Name = "IMPOSTORS_GLOBALGBUFFER0SUFFIX";
		public static readonly string PrefGlobalGBuffer1Name = "IMPOSTORS_GLOBALGBUFFER1SUFFIX";
		public static readonly string PrefGlobalGBuffer2Name = "IMPOSTORS_GLOBALGBUFFER2SUFFIX";
		public static readonly string PrefGlobalGBuffer3Name = "IMPOSTORS_GLOBALGBUFFER3SUFFIX";
		public static readonly string PrefGlobalBakingOptions = "IMPOSTORS_GLOBALBakingOptions";

		public static readonly string PrefDataImpType = "IMPOSTORS_DATAIMPTYPE";
		public static readonly string PrefDataTexSizeLocked = "IMPOSTORS_DATATEXSIZEXLOCKED";
		public static readonly string PrefDataTexSizeSelected = "IMPOSTORS_DATATEXSIZEXSELECTED";
		public static readonly string PrefDataTexSizeX = "IMPOSTORS_DATATEXSIZEX";
		public static readonly string PrefDataTexSizeY = "IMPOSTORS_DATATEXSIZEY";
		public static readonly string PrefDataDecoupledFrames = "IMPOSTORS_DATADECOUPLEDFRAMES";
		public static readonly string PrefDataXFrames = "IMPOSTORS_DATAXFRAMES";
		public static readonly string PrefDataYFrames = "IMPOSTORS_DATAYFRAMES";
		public static readonly string PrefDataPixelBleeding = "IMPOSTORS_DATAPIXELBLEEDING";

		public static readonly string PrefDataTolerance = "IMPOSTORS_DATATOLERANCE ";
		public static readonly string PrefDataNormalScale = "IMPOSTORS_DATANORMALSCALE";
		public static readonly string PrefDataMaxVertices = "IMPOSTORS_DATAMAXVERTICES";

#if UNITY_EDITOR
		public static bool GlobalDefaultMode = false;
		public static string GlobalFolder = string.Empty;
		public static string GlobalRelativeFolder = string.Empty;
		public static int GlobalTexImport = 0;
		public static bool GlobalCreateLodGroup = false;
		public static string GlobalAlbedoAlpha = string.Empty;
		public static string GlobalSpecularSmoothness = string.Empty;
		public static string GlobalNormalDepth = string.Empty;
		public static string GlobalEmissionOcclusion = string.Empty;
		public static bool GlobalBakingOptions = true;
		private static readonly GUIContent DefaultSuffixesLabel = new GUIContent( "Default Suffixes", "Default Suffixes for new Bake Presets" );
		public static string OpenFolderForImpostor( this AmplifyImpostor instance )
		{
			string oneLevelUp = Application.dataPath + "/../";
			string directory = Path.GetFullPath( oneLevelUp ).Replace( "\\", "/" );
			string objectPath = AssetDatabase.GetAssetPath( instance.RootTransform );

			// Find Path next to prefab
			if( string.IsNullOrEmpty( objectPath ) )
			{
#if UNITY_2018_2_OR_NEWER
				objectPath = AssetDatabase.GetAssetPath( PrefabUtility.GetCorrespondingObjectFromSource( instance.RootTransform ) );
#else
				objectPath = AssetDatabase.GetAssetPath( PrefabUtility.GetPrefabParent( instance.RootTransform ) );
#endif
			}

			GlobalRelativeFolder = EditorPrefs.GetString( PrefGlobalRelativeFolder, "" );
			string fullpath = string.Empty;
			string suggestedRelativePath = directory + objectPath;
			if( string.IsNullOrEmpty( objectPath ) )
				suggestedRelativePath = Application.dataPath;
			else
				suggestedRelativePath = Path.GetDirectoryName( suggestedRelativePath ).Replace( "\\", "/" );

			GlobalFolder = EditorPrefs.GetString( PrefGlobalFolder, "" );

			// Find best match
			if( GlobalDefaultMode && AssetDatabase.IsValidFolder( GlobalFolder.TrimStart( '/' ) ) )
				fullpath = directory + GlobalFolder;
			else if( AssetDatabase.IsValidFolder( FileUtil.GetProjectRelativePath( suggestedRelativePath + GlobalRelativeFolder ).TrimEnd( '/' ) ) )
				fullpath = suggestedRelativePath + GlobalRelativeFolder;
			else if( AssetDatabase.IsValidFolder( FileUtil.GetProjectRelativePath( suggestedRelativePath ).TrimEnd( '/' ) ) )
				fullpath = suggestedRelativePath;
			else
				fullpath = Application.dataPath;

			string fileName = instance.name + "_Impostor";
			if( !string.IsNullOrEmpty( instance.m_impostorName ) )
				fileName = instance.m_impostorName;

			//Debug.Log( fullpath );
			//Debug.Log( fileName );

			string folderpath = EditorUtility.SaveFilePanelInProject( "Save Impostor to folder", fileName, "asset", "", FileUtil.GetProjectRelativePath( fullpath ) );
			fileName = Path.GetFileNameWithoutExtension( folderpath );

			if( !string.IsNullOrEmpty( fileName ) )
			{
				folderpath = Path.GetDirectoryName( folderpath ).Replace( "\\", "/" );
				if( !string.IsNullOrEmpty( folderpath ) )
				{
					folderpath += "/";
					if( !GlobalDefaultMode )
					{
						instance.m_folderPath = folderpath;
					}
					else
					{
						GlobalFolder = folderpath;
						EditorPrefs.SetString( PrefGlobalFolder, GlobalFolder );
					}
					instance.m_impostorName = fileName;
				}
			}
			return folderpath;
		}

		private static bool PrefsLoaded = false;
		private static GUIContent PathButtonContent = new GUIContent();
#if UNITY_2019_1_OR_NEWER
		[SettingsProvider]
		public static SettingsProvider ImpostorsSettings()
		{
			var provider = new SettingsProvider( "Preferences/Impostors", SettingsScope.User )
			{
				guiHandler = ( string searchContext ) => {
					PreferencesGUI();
				}
			};
			return provider;
		}
#else
		[PreferenceItem( "Impostors" )]
#endif
		public static void PreferencesGUI()
		{
			if( !PrefsLoaded )
			{
				LoadDefaults();
				PrefsLoaded = true;
			}

			PathButtonContent.text = string.IsNullOrEmpty( GlobalFolder ) ? "Click to select folder" : GlobalFolder;

			GlobalDefaultMode = (FolderMode)EditorGUILayout.EnumPopup( "New Impostor Default Path", GlobalDefaultMode ? FolderMode.Global : FolderMode.RelativeToPrefab ) == FolderMode.Global;
			EditorGUILayout.BeginHorizontal();
			if( GlobalDefaultMode )
			{
				EditorGUI.BeginChangeCheck();
				GlobalFolder = EditorGUILayout.TextField( "Global Folder", GlobalFolder );
				if( EditorGUI.EndChangeCheck() )
				{
					GlobalFolder = GlobalFolder.TrimStart( new char[] { '/', '*', '.', ' ' } );
					GlobalFolder = "/" + GlobalFolder;
					GlobalFolder = GlobalFolder.TrimEnd( new char[] { '/', '*', '.', ' ' } );
					EditorPrefs.SetString( PrefGlobalFolder, GlobalFolder );
				}
				if( GUILayout.Button( "...", "minibutton", GUILayout.Width(20)/*GUILayout.MaxWidth( Screen.width * 0.5f )*/ ) )
				{
					string oneLevelUp = Application.dataPath + "/../";
					string directory = Path.GetFullPath( oneLevelUp ).Replace( "\\", "/" );
					string fullpath = directory + GlobalFolder;
					string folderpath = EditorUtility.SaveFolderPanel( "Save Impostor to folder", FileUtil.GetProjectRelativePath( fullpath ), null );

					folderpath = FileUtil.GetProjectRelativePath( folderpath );
					if( !string.IsNullOrEmpty( folderpath ) )
					{
						GlobalFolder = folderpath;
						GlobalFolder = GlobalFolder.TrimStart( new char[] { '/', '*', '.', ' ' } );
						GlobalFolder = "/" + GlobalFolder;
						GlobalFolder = GlobalFolder.TrimEnd( new char[] { '/', '*', '.', ' ' } );
						EditorPrefs.SetString( PrefGlobalFolder, GlobalFolder );
					}
				}
			} else
			{
				EditorGUI.BeginChangeCheck();
				GlobalRelativeFolder = EditorGUILayout.TextField( "Relative to Prefab Folder", GlobalRelativeFolder );
				if( EditorGUI.EndChangeCheck() )
				{
					GlobalRelativeFolder = GlobalRelativeFolder.TrimStart( new char[] { '/', '*', '.', ' ' } );
					GlobalRelativeFolder = "/" + GlobalRelativeFolder;
					GlobalRelativeFolder = GlobalRelativeFolder.TrimEnd( new char[] { '/', '*', '.', ' ' } );
					EditorPrefs.SetString( PrefGlobalRelativeFolder, GlobalRelativeFolder );
				}
				EditorGUI.BeginDisabledGroup( true );
				GUILayout.Button( "...", "minibutton", GUILayout.Width( 20 ) );
				EditorGUI.EndDisabledGroup();
			}

			EditorGUILayout.EndHorizontal();

			GlobalTexImport = EditorGUILayout.Popup( "Texture Importer Settings", GlobalTexImport, new string[] { "Ask if resolution is different", "Don't ask, always change", "Don't ask, never change" } );
			GlobalCreateLodGroup = EditorGUILayout.Toggle( "Create LODGroup if not present", GlobalCreateLodGroup );
			GUILayout.Space( 5 );
			GUILayout.Label( DefaultSuffixesLabel, "boldlabel" );
			GlobalAlbedoAlpha = EditorGUILayout.TextField( "Albedo & Alpha", GlobalAlbedoAlpha );
			GlobalSpecularSmoothness = EditorGUILayout.TextField( "Specular & Smoothness", GlobalSpecularSmoothness );
			GlobalNormalDepth = EditorGUILayout.TextField( "Normal & Depth", GlobalNormalDepth );
			GlobalEmissionOcclusion = EditorGUILayout.TextField( "Emission & Occlusion", GlobalEmissionOcclusion );
			if( GUI.changed )
			{
				EditorPrefs.SetBool( PrefGlobalDefault, GlobalDefaultMode );
				EditorPrefs.SetInt( PrefGlobalTexImport, GlobalTexImport );
				EditorPrefs.SetBool( PrefGlobalCreateLodGroup, GlobalCreateLodGroup );

				EditorPrefs.SetString( PrefGlobalGBuffer0Name, GlobalAlbedoAlpha );
				EditorPrefs.SetString( PrefGlobalGBuffer1Name, GlobalSpecularSmoothness );
				EditorPrefs.SetString( PrefGlobalGBuffer2Name, GlobalNormalDepth );
				EditorPrefs.SetString( PrefGlobalGBuffer3Name, GlobalEmissionOcclusion );
			}
		}

		public static void LoadDefaults()
		{
			GlobalFolder = EditorPrefs.GetString( PrefGlobalFolder, "" );
			GlobalRelativeFolder = EditorPrefs.GetString( PrefGlobalRelativeFolder, "" );
			GlobalDefaultMode = EditorPrefs.GetBool( PrefGlobalDefault, false );
			GlobalTexImport = EditorPrefs.GetInt( PrefGlobalTexImport, 0 );
			GlobalCreateLodGroup = EditorPrefs.GetBool( PrefGlobalCreateLodGroup, false );
			GlobalBakingOptions = EditorPrefs.GetBool( PrefGlobalBakingOptions, true );

			GlobalAlbedoAlpha = EditorPrefs.GetString( PrefGlobalGBuffer0Name, "_AlbedoAlpha" );
			GlobalSpecularSmoothness = EditorPrefs.GetString( PrefGlobalGBuffer1Name, "_SpecularSmoothness" );
			GlobalNormalDepth = EditorPrefs.GetString( PrefGlobalGBuffer2Name, "_NormalDepth" );
			GlobalEmissionOcclusion = EditorPrefs.GetString( PrefGlobalGBuffer3Name, "_EmissionOcclusion" );
		}
#endif
	}
}
