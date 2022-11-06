using UnityEngine;
using UnityEditor;
using UnityEditorInternal;
using System.Collections.Generic;

namespace AmplifyImpostors
{
	[CustomEditor( typeof( AmplifyImpostorBakePreset ) )]
	public class AmplifyImpostorBakePresetEditor : Editor
	{
		AmplifyImpostorBakePreset instance;
		private ReorderableList m_reorderableOutput = null;

		private bool m_usingStandard;

		public static readonly GUIContent BakeShaderStr = new GUIContent( "Bake Shader", "Shader used to bake the different outputs" );
		public static readonly GUIContent RuntimeShaderStr = new GUIContent( "Runtime Shader", "Custom impostor shader to assign the outputs to" );
		public static readonly GUIContent PipelineStr = new GUIContent( "Pipeline", "Defines the default preset for the selected pipeline" );

		public static readonly GUIContent TargetsStr = new GUIContent( "RT#", "Render Target number" );
		public static readonly GUIContent SuffixStr = new GUIContent( "Suffix", "Name suffix for file saving and for material assignment" );

		public static readonly int[] TexScaleOpt = { 1, 2, 4, 8 };
		public static readonly GUIContent[] TexScaleListStr = { new GUIContent( "1" ), new GUIContent( "1\u20442" ), new GUIContent( "1\u20444" ), new GUIContent( "1\u20448" ) };
		public static readonly GUIContent TexScaleStr = new GUIContent( "Scale", "Texture Scaling" );

		public static readonly GUIContent ColorSpaceStr = new GUIContent( "sRGB", "Texture color space" );
		public static readonly GUIContent[] ColorSpaceListStr = { new GUIContent( "sRGB" ), new GUIContent( "Linear" ) };

		public static readonly int[] CompressionOpt = { 0, 3, 1, 2 };
		public static readonly GUIContent[] CompressionListStr = { new GUIContent( "None" ), new GUIContent( "Low" ), new GUIContent( "Normal" ), new GUIContent( "High" ) };
		public static readonly GUIContent CompressionStr = new GUIContent( "Compression", "Compression quality" );

		public static readonly GUIContent FormatStr = new GUIContent( "Format", "File save format" );
		public static readonly GUIContent ChannelsStr = new GUIContent( "Channels", "Channels being used" );
		public GUIContent AlphaIcon;

		public static readonly GUIContent OverrideStr = new GUIContent( "Override", "Override" );

		public void OnEnable()
		{
			instance = (AmplifyImpostorBakePreset)target;
			ImpostorBakingTools.LoadDefaults();

			AlphaIcon = EditorGUIUtility.IconContent( "PreTextureAlpha" );
			AlphaIcon.tooltip = "Alpha output selection";
			AddList();
		}

		private void OnDisable()
		{
			RemoveList();
		}

		void RemoveList()
		{
			m_reorderableOutput.drawHeaderCallback -= DrawHeader;
			m_reorderableOutput.drawElementCallback -= DrawElement;

			m_reorderableOutput.onAddCallback -= AddItem;
		}

		void AddList()
		{
			m_usingStandard = false;
			if( instance.BakeShader == null )
				m_usingStandard = true;

			m_reorderableOutput = new ReorderableList( instance.Output, typeof( TextureOutput ), !m_usingStandard, true, !m_usingStandard, !m_usingStandard );

			m_reorderableOutput.drawHeaderCallback += DrawHeader;
			m_reorderableOutput.drawElementCallback += DrawElement;

			m_reorderableOutput.onAddCallback += AddItem;
		}

		void RefreshList()
		{
			RemoveList();

			AddList();
		}

		private void DrawHeader( Rect rect )
		{
			rect.xMax -= 20;
			Rect alphaRect = rect;
			alphaRect.width = 24;
			alphaRect.x = rect.xMax;
			alphaRect.height = 24;

			rect.xMax -= 35;
			Rect overrideRect = rect;
			overrideRect.width = 32;
			EditorGUI.LabelField( overrideRect, TargetsStr );
			overrideRect = rect;
			overrideRect.xMin += 32 + ( m_usingStandard ? 0 : 13 );
			overrideRect.width = EditorGUIUtility.labelWidth - overrideRect.xMin + 13;
			EditorGUI.LabelField( overrideRect, SuffixStr );
			Rect optionRect = rect;
			optionRect.xMin = EditorGUIUtility.labelWidth + 13;
			float fullwidth = optionRect.width;
			optionRect.width = fullwidth * 0.25f;
			EditorGUI.LabelField( optionRect, TexScaleStr );
			optionRect.x += optionRect.width;
			EditorGUI.LabelField( optionRect, ChannelsStr );
			optionRect.x += optionRect.width;
			optionRect.width = 35;
			EditorGUI.LabelField( optionRect, ColorSpaceStr );
			optionRect.x += optionRect.width;
			optionRect.width = fullwidth * 0.25f;
			EditorGUI.LabelField( optionRect, CompressionStr );
			optionRect.x += optionRect.width;
			EditorGUI.LabelField( optionRect, FormatStr );
			
			EditorGUI.LabelField( alphaRect, AlphaIcon );
		}

		private void DrawElement( Rect rect, int index, bool active, bool focused )
		{
			rect.y += 1;
			Rect alphaRect = rect;
			alphaRect.height = EditorGUIUtility.singleLineHeight;
			alphaRect.width = 20;
			alphaRect.x = rect.xMax - alphaRect.width;
			rect.xMax -= alphaRect.width + 35;
			Rect overrideRect = rect;
			overrideRect.width = 16;
			overrideRect.height = EditorGUIUtility.singleLineHeight;
			EditorGUI.LabelField( overrideRect, new GUIContent( index.ToString() ) );

			rect.height = EditorGUIUtility.singleLineHeight;
			Rect toggleRect = rect;
			toggleRect.x = overrideRect.xMax;
			toggleRect.width = 16;
			instance.Output[ index ].Active = EditorGUI.Toggle( toggleRect, instance.Output[ index ].Active );
			rect.y += 1;

			EditorGUI.BeginDisabledGroup( !instance.Output[ index ].Active );
			Rect nameRect = rect;
			nameRect.x = toggleRect.xMax;
			nameRect.width = EditorGUIUtility.labelWidth - 32 - ( m_usingStandard ? 5 : 19 );
			instance.Output[ index ].Name = EditorGUI.TextField( nameRect, instance.Output[ index ].Name );

			Rect optionRect = rect;
			optionRect.xMin = nameRect.xMax;
			float fullwidth = optionRect.width;
			optionRect.width = fullwidth * 0.25f;
			instance.Output[ index ].Scale = (TextureScale)EditorGUI.IntPopup( optionRect, (int)instance.Output[ index ].Scale, TexScaleListStr, TexScaleOpt );
			optionRect.x += optionRect.width;
			instance.Output[ index ].Channels = (TextureChannels)EditorGUI.EnumPopup( optionRect, instance.Output[ index ].Channels );
			optionRect.x += optionRect.width + 10;
			optionRect.width = 35;
			optionRect.y -= 1;
			instance.Output[ index ].SRGB = EditorGUI.Toggle( optionRect, instance.Output[ index ].SRGB );
			optionRect.y += 1;
			optionRect.x += optionRect.width - 10;
			optionRect.width = fullwidth * 0.25f;
			instance.Output[ index ].Compression = (TextureCompression)EditorGUI.IntPopup( optionRect, (int)instance.Output[ index ].Compression, CompressionListStr, CompressionOpt );
			optionRect.x += optionRect.width;
			instance.Output[ index ].ImageFormat = (ImageFormat)EditorGUI.EnumPopup( optionRect, instance.Output[ index ].ImageFormat );
			EditorGUI.EndDisabledGroup();

			alphaRect.xMin += 4;
			instance.AlphaIndex = EditorGUI.Toggle( alphaRect, instance.AlphaIndex == index, "radio" ) ? index : instance.AlphaIndex;
		}

		private void AddItem( ReorderableList reordableList )
		{
			reordableList.list.Add( new TextureOutput() );

			EditorUtility.SetDirty( target );
		}

		public override void OnInspectorGUI()
		{
			//base.OnInspectorGUI();
			EditorGUI.BeginChangeCheck();
			instance.BakeShader = EditorGUILayout.ObjectField( BakeShaderStr, instance.BakeShader, typeof( Shader ), false ) as Shader;

			instance.RuntimeShader = EditorGUILayout.ObjectField( RuntimeShaderStr, instance.RuntimeShader, typeof( Shader ), false ) as Shader;

			instance.Pipeline = (PresetPipeline)EditorGUILayout.EnumPopup( PipelineStr, instance.Pipeline );

			m_usingStandard = instance.BakeShader == null;
			bool check = false;
			if( EditorGUI.EndChangeCheck() )
			{
				check = true;
			}

			if( check || ( m_usingStandard && instance.Output.Count == 0 ) )
			{
				check = false;
				if( m_usingStandard )
				{
					if( instance.Pipeline == PresetPipeline.HighDefinition )
					{
						instance.Output.Clear();
						instance.Output = new List<TextureOutput>()
						{
							new TextureOutput(true, ImpostorBakingTools.GlobalAlbedoAlpha, TextureScale.Full, true, TextureChannels.RGBA, TextureCompression.Normal, ImageFormat.TGA ),
							new TextureOutput(true, ImpostorBakingTools.GlobalSpecularSmoothness, TextureScale.Full, true, TextureChannels.RGBA, TextureCompression.Normal, ImageFormat.TGA ),
							new TextureOutput(true, ImpostorBakingTools.GlobalNormalDepth, TextureScale.Full, false, TextureChannels.RGBA, TextureCompression.Normal, ImageFormat.TGA ),
							new TextureOutput(true, ImpostorBakingTools.GlobalEmissionOcclusion, TextureScale.Full, false, TextureChannels.RGBA, TextureCompression.Normal, ImageFormat.EXR ),
							new TextureOutput(true, "_DiffusionFeatures", TextureScale.Full, false, TextureChannels.RGBA, TextureCompression.None, ImageFormat.TGA ),
						};
					} 
					else
					{
						instance.Output.Clear();
						instance.Output = new List<TextureOutput>()
						{
							new TextureOutput(true, ImpostorBakingTools.GlobalAlbedoAlpha, TextureScale.Full, true, TextureChannels.RGBA, TextureCompression.Normal, ImageFormat.TGA ),
							new TextureOutput(true, ImpostorBakingTools.GlobalSpecularSmoothness, TextureScale.Full, true, TextureChannels.RGBA, TextureCompression.Normal, ImageFormat.TGA ),
							new TextureOutput(true, ImpostorBakingTools.GlobalNormalDepth, TextureScale.Full, false, TextureChannels.RGBA, TextureCompression.Normal, ImageFormat.TGA ),
							new TextureOutput(true, ImpostorBakingTools.GlobalEmissionOcclusion, TextureScale.Full, false, TextureChannels.RGBA, TextureCompression.Normal, ImageFormat.TGA ),
						};
					}
				}

				RefreshList();

				Repaint();
			}

			m_reorderableOutput.DoLayoutList();

			if( GUI.changed )
				EditorUtility.SetDirty( instance );
		}
	}
}
