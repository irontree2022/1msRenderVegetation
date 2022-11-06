// Amplify Impostors
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

#if AMPLIFY_SHADER_EDITOR
using UnityEngine;
using UnityEditor;
using System;
using System.Collections.Generic;
using System.Reflection;

public static class AmplifyASEHelper
{
	public class R_RangedFloatNode
	{
		private AmplifyShaderEditor.RangedFloatNode m_instance;
		private System.Type m_type;

		public R_RangedFloatNode( AmplifyShaderEditor.RangedFloatNode instance )
		{
			m_instance = instance;
			m_type = instance.GetType();
		}

		public float Max
		{
			set
			{
				var field = m_type.GetField( "m_max", BindingFlags.Instance | BindingFlags.NonPublic );
				field.SetValue( m_instance, value );
			}
		}
	}

	public class R_PropertyNode
	{
		private AmplifyShaderEditor.PropertyNode m_instance;
		private System.Type m_type;

		public R_PropertyNode( AmplifyShaderEditor.PropertyNode instance )
		{
			m_instance = instance;
			m_type = instance.GetType();
		}

		public List<int> SelAttr
		{
			get
			{
				var field = m_type.GetField( "m_selectedAttribs", BindingFlags.Instance | BindingFlags.NonPublic );
				return (List<int>)field.GetValue( m_instance );
			}
			set
			{
				var field = m_type.GetField( "m_selectedAttribs", BindingFlags.Instance | BindingFlags.NonPublic );
				field.SetValue( m_instance, value );
			}
		}

		public string InspectorName
		{
			get
			{
				var field = m_type.GetField( "m_propertyInspectorName", BindingFlags.Instance | BindingFlags.NonPublic );
				return (string)field.GetValue( m_instance );
			}
			set
			{
				var field = m_type.GetField( "m_propertyInspectorName", BindingFlags.Instance | BindingFlags.NonPublic );
				field.SetValue( m_instance, value );
			}
		}
	}
}

namespace AmplifyShaderEditor
{
	[Serializable]
	[NodeAttributes( "Amplify Impostor", "Miscellaneous", "Impostor", NodeAvailabilityFlags = (int) NodeAvailability.TemplateShader )]
	public sealed class AmplifyImpostorNode : ParentNode
	{
		private string m_functionHeaderSphereFrag = "SphereImpostorFragment( o, clipPos, worldPos, {0}, {1} )";
		private string m_functionHeaderSphere = "SphereImpostorVertex( {0}, {1}, {2}, {3} )";
		private string m_functionHeaderFrag = "OctaImpostorFragment( o, clipPos, worldPos, {0}, {1}, {2}, {3}, {4} )";
		private string m_functionHeader = "OctaImpostorVertex( {0}, {1}, {2}, {3}, {4}, {5}, {6} )";
		private string m_functionBody = string.Empty;

		private enum CustomImpostorType
		{
			Spherical = 0,
			Octahedron = 1,
			HemiOctahedron = 2
		}

		private const string WorkflowStr = "Workflow";
		private string[] DielecticSRPFix =
		{
			"#ifdef UNITY_COLORSPACE_GAMMA//AI_SRP",
			"#define unity_ColorSpaceDielectricSpec half4(0.220916301, 0.220916301, 0.220916301, 1.0 - 0.220916301)//AI_SRP",
			"#else//AI_SRP",
			"#define unity_ColorSpaceDielectricSpec half4(0.04, 0.04, 0.04, 1.0 - 0.04) //AI_SRP",
			"#endif//AI_SRP"
		};

		[SerializeField]
		private ASEStandardSurfaceWorkflow m_workflow = ASEStandardSurfaceWorkflow.Specular;

		[SerializeField]
		private CustomImpostorType m_customImpostorType = CustomImpostorType.Octahedron;

		[SerializeField]
		private bool m_speedTreeHueSupport;

		[SerializeField]
		private bool m_showExtraData;

		[SerializeField]
		private bool m_forceClampFrames;

		[SerializeField]
		private RangedFloatNode m_framesProp;
		private int m_orderFramesProp = -1;

		[SerializeField]
		private RangedFloatNode m_framesXProp;
		private int m_orderFramesXProp = -1;

		[SerializeField]
		private RangedFloatNode m_framesYProp;
		private int m_orderFramesYProp = -1;

		[SerializeField]
		private RangedFloatNode m_sizeProp;
		private int m_orderSizeProp = -1;

		[SerializeField]
		private Vector4Node m_sizeOffsetProp;
		private int m_orderSizeOffsetProp = -1;

		[SerializeField]
		private RangedFloatNode m_parallaxProp;
		private int m_orderParallaxProp = -1;

		[SerializeField]
		private Vector3Node m_offsetProp;
		private int m_orderOffsetProp = -1;

		[SerializeField]
		private RangedFloatNode m_biasProp;
		private int m_orderBiasProp = -1;

		[SerializeField]
		private TexturePropertyNode m_albedoTexture;
		private int m_orderAlbedoTexture = -1;

		[SerializeField]
		private TexturePropertyNode m_normalTexture;
		private int m_orderNormalTexture = -1;

		[SerializeField]
		private TexturePropertyNode m_specularTexture;
		private int m_orderSpecularTexture = -1;

		[SerializeField]
		private TexturePropertyNode m_emissionTexture;
		private int m_orderEmissionTexture = -1;

		[SerializeField]
		private RangedFloatNode m_depthProp;
		private int m_orderDepthProp = -1;

		[SerializeField]
		private RangedFloatNode m_shadowBiasProp;
		private int m_orderShadowBiasProp = -1;

		[SerializeField]
		private RangedFloatNode m_shadowViewProp;
		private int m_orderShadowViewProp = -1;

		[SerializeField]
		private RangedFloatNode m_clipProp;
		private int m_orderClipProp = -1;

		[SerializeField]
		private ColorNode m_hueProp;
		private int m_orderHueProp = -1;

		[SerializeField]
		private int m_extraSamplers = 0;

		private const int MaxExtraSamplers = 8;

		private string[] m_extraPropertyNames;

		bool m_propertiesInitialize = false;

		private InputPort m_samplerStatePort;

		[SerializeField]
		private bool m_matchPropertyNames = false;

		protected override void CommonInit( int uniqueId )
		{
			base.CommonInit( uniqueId );

			for( int i = 0; i < MaxExtraSamplers; i++ )
			{
				AddInputPort( WirePortDataType.SAMPLER2D, true, "Tex" + i );
				AddOutputPort( WirePortDataType.FLOAT4, "Tex" + i, i + 8 );
			}

			AddInputPort( WirePortDataType.SAMPLERSTATE, false, "SS" );
			m_samplerStatePort = m_inputPorts[ m_inputPorts.Count - 1 ];

			AddOutputPort( WirePortDataType.FLOAT3, "Albedo", 0 );
			AddOutputPort( WirePortDataType.FLOAT3, "World Normal", 1 );
			AddOutputPort( WirePortDataType.FLOAT3, "Emission", 2 );
			AddOutputPort( WirePortDataType.FLOAT3, "Specular", 3 );
			AddOutputPort( WirePortDataType.FLOAT, "Smoothness", 4 );
			AddOutputPort( WirePortDataType.FLOAT, "Occlusion", 5 );
			AddOutputPort( WirePortDataType.FLOAT, "Alpha", 6 );
			AddOutputPort( WirePortDataType.FLOAT3, "World Pos", 7 );
			AddOutputPort( WirePortDataType.FLOAT3, "View Pos", 16 );

			m_autoWrapProperties = true;
			m_textLabelWidth = 160;

			UpdateTitle();
			UpdatePorts();
			UpdateInputPorts();
		}

		public override void AfterCommonInit()
		{
			base.AfterCommonInit();
			UpdateTag();
		}

		void UpdateTag()
		{
			List<CustomTagData> allTags = null;
			if( VersionInfo.FullNumber > 15500 )
			{
				allTags = ( (TemplateMultiPassMasterNode)m_containerGraph.CurrentMasterNode ).SubShaderModule.TagsHelper.AvailableTags;
			}
			else
			{
				allTags = ( m_containerGraph.MultiPassMasterNodes.NodesList[ m_containerGraph.MultiPassMasterNodes.Count - 1 ] ).SubShaderModule.TagsHelper.AvailableTags;
			}

			CustomTagData importorTag = allTags.Find( x => x.TagName == "ImpostorType" );
			if( importorTag != null )
				importorTag.TagValue = m_customImpostorType.ToString();
			else
				allTags.Add( new CustomTagData( "ImpostorType", m_customImpostorType.ToString(), 0 ) );
		}

		public override void DrawProperties()
		{
			base.DrawProperties();
			EditorGUI.BeginChangeCheck();
			m_customImpostorType = (CustomImpostorType)EditorGUILayoutEnumPopup( "Impostor Type", m_customImpostorType );
			if( EditorGUI.EndChangeCheck() )
			{
				UpdateTitle();
				UpdateTag();
			}

			EditorGUI.BeginChangeCheck();
			m_workflow = (ASEStandardSurfaceWorkflow)EditorGUILayoutEnumPopup( WorkflowStr, m_workflow );
			if( EditorGUI.EndChangeCheck() )
			{
				UpdatePorts();
			}

			m_speedTreeHueSupport = EditorGUILayoutToggle( "SpeedTree Hue Support", m_speedTreeHueSupport );

			EditorGUI.BeginChangeCheck();
			m_showExtraData = EditorGUILayoutToggle( "Output Extra Data", m_showExtraData );
			if( EditorGUI.EndChangeCheck() )
			{
				UpdatePorts();
			}

			m_forceClampFrames = EditorGUILayoutToggle( "Force Clamp Frames", m_forceClampFrames );
			EditorGUI.BeginChangeCheck();
			m_matchPropertyNames = EditorGUILayoutToggle( "Match Native Property Names" , m_matchPropertyNames );
			if( EditorGUI.EndChangeCheck() )
			{
				UpdatePropertyNames();
			}

			EditorGUI.BeginChangeCheck();
			float cacha = EditorGUIUtility.labelWidth;
			EditorGUIUtility.labelWidth = 120;
			m_extraSamplers = EditorGUILayoutIntSlider( "Extra Samplers", m_extraSamplers, 0, MaxExtraSamplers );
			if( EditorGUI.EndChangeCheck() )
			{
				UpdateInputPorts();
			}
			EditorGUIUtility.labelWidth = cacha;
		}

		public void UpdateInputPorts()
		{
			m_extraPropertyNames = new string[ m_extraSamplers ];
			for( int i = 0; i < MaxExtraSamplers; i++ )
			{
				GetOutputPortByArrayId( i ).Visible = i < m_extraSamplers;
				GetInputPortByArrayId( i ).Visible = i < m_extraSamplers;
			}
			m_samplerStatePort.Visible = m_extraSamplers > 0;
			m_sizeIsDirty = true;
		}

		public void UpdatePorts()
		{
			if( m_showExtraData )
			{
				GetOutputPortByUniqueId( 7 ).Visible = true;
				GetOutputPortByUniqueId( 16 ).Visible = true;
			}
			else
			{
				GetOutputPortByUniqueId( 7 ).Visible = false;
				GetOutputPortByUniqueId( 16 ).Visible = false;
			}

			if(m_workflow == ASEStandardSurfaceWorkflow.Specular )
			{
				GetOutputPortByUniqueId( 3 ).ChangeProperties( "Specular", WirePortDataType.FLOAT3, false );
			} else
			{
				GetOutputPortByUniqueId( 3 ).ChangeProperties( "Metallic", WirePortDataType.FLOAT, false );
			}
			m_sizeIsDirty = true;
		}

		void UpdatePropertyNames()
		{
			m_framesProp.RegisterPropertyName( true , m_matchPropertyNames ? "_Frames" : "_AI_Frames" );
			m_framesXProp.RegisterPropertyName( true , m_matchPropertyNames ? "_FramesX" : "_AI_FramesX" );
			m_framesYProp.RegisterPropertyName( true , m_matchPropertyNames ? "_FramesY" : "_AI_FramesY" );
			m_parallaxProp.RegisterPropertyName( true , m_matchPropertyNames ? "_Parallax" : "_AI_Parallax" );
			m_sizeProp.RegisterPropertyName( true , m_matchPropertyNames ? "_ImpostorSize" : "_AI_ImpostorSize" );
			m_offsetProp.RegisterPropertyName( true , m_matchPropertyNames ? "_Offset" : "_AI_Offset" );
			m_hueProp.RegisterPropertyName( true , m_matchPropertyNames ? "_HueVariation" : "_AI_HueVariation" );
			m_biasProp.RegisterPropertyName( true , m_matchPropertyNames ? "_TextureBias" : "_AI_TextureBias" );
			m_depthProp.RegisterPropertyName( true , m_matchPropertyNames ? "_DepthSize" : "_AI_DepthSize" );
			m_clipProp.RegisterPropertyName( true , m_matchPropertyNames ? "_ClipMask" : "_AI_Clip" );
		}


		public void Init()
		{
			if( m_propertiesInitialize )
				return;
			else
				m_propertiesInitialize = true;

			if( m_framesProp == null )
			{
				m_framesProp = ScriptableObject.CreateInstance<RangedFloatNode>();
			}
			m_framesProp.ContainerGraph = ContainerGraph;
			AmplifyASEHelper.R_PropertyNode temp2 = new AmplifyASEHelper.R_PropertyNode( m_framesProp );
			temp2.SelAttr.Add( 0 );
			m_framesProp.OrderIndex = m_orderFramesProp;
			m_framesProp.ChangeParameterType( PropertyType.Property );
			m_framesProp.UniqueId = UniqueId;
			m_framesProp.RegisterPropertyName( true, "_AI_Frames" );
			temp2.InspectorName = "Impostor Frames";

			if( m_framesXProp == null )
			{
				m_framesXProp = ScriptableObject.CreateInstance<RangedFloatNode>();
			}
			m_framesXProp.ContainerGraph = ContainerGraph;
			temp2 = new AmplifyASEHelper.R_PropertyNode( m_framesXProp );
			temp2.SelAttr.Add( 0 );
			m_framesXProp.OrderIndex = m_orderFramesXProp;
			m_framesXProp.ChangeParameterType( PropertyType.Property );
			m_framesXProp.UniqueId = UniqueId;
			m_framesXProp.RegisterPropertyName( true, "_AI_FramesX" );
			temp2.InspectorName = "Impostor Frames X";

			if( m_framesYProp == null )
			{
				m_framesYProp = ScriptableObject.CreateInstance<RangedFloatNode>();
			}
			m_framesYProp.ContainerGraph = ContainerGraph;
			temp2 = new AmplifyASEHelper.R_PropertyNode( m_framesYProp );
			temp2.SelAttr.Add( 0 );
			m_framesYProp.OrderIndex = m_orderFramesYProp;
			m_framesYProp.ChangeParameterType( PropertyType.Property );
			m_framesYProp.UniqueId = UniqueId;
			m_framesYProp.RegisterPropertyName( true, "_AI_FramesY" );
			temp2.InspectorName = "Impostor Frames Y";

			if( m_sizeProp == null )
			{
				m_sizeProp = ScriptableObject.CreateInstance<RangedFloatNode>();
			}
			m_sizeProp.ContainerGraph = ContainerGraph;
			temp2 = new AmplifyASEHelper.R_PropertyNode( m_sizeProp );
			temp2.SelAttr.Add( 0 );
			m_sizeProp.OrderIndex = m_orderSizeProp;
			m_sizeProp.ChangeParameterType( PropertyType.Property );
			m_sizeProp.UniqueId = UniqueId;
			m_sizeProp.RegisterPropertyName( true, "_AI_ImpostorSize" );
			temp2.InspectorName = "Impostor Size";

			if( m_parallaxProp == null )
			{
				m_parallaxProp = ScriptableObject.CreateInstance<RangedFloatNode>();
			}
			m_parallaxProp.ContainerGraph = ContainerGraph;
			temp2 = new AmplifyASEHelper.R_PropertyNode( m_parallaxProp );
			AmplifyASEHelper.R_RangedFloatNode temp = new AmplifyASEHelper.R_RangedFloatNode( m_parallaxProp );
			temp.Max = 1f;
			m_parallaxProp.SetFloatMode( false );
			m_parallaxProp.Value = 1;
			m_parallaxProp.OrderIndex = m_orderParallaxProp;
			m_parallaxProp.ChangeParameterType( PropertyType.Property );
			m_parallaxProp.UniqueId = UniqueId;
			m_parallaxProp.RegisterPropertyName( true, "_AI_Parallax" );
			temp2.InspectorName = "Impostor Parallax";

			if( m_offsetProp == null )
			{
				m_offsetProp = ScriptableObject.CreateInstance<Vector3Node>();
			}
			m_offsetProp.ContainerGraph = ContainerGraph;
			temp2 = new AmplifyASEHelper.R_PropertyNode( m_offsetProp );
			temp2.SelAttr.Add( 0 );
			m_offsetProp.OrderIndex = m_orderOffsetProp;
			m_offsetProp.ChangeParameterType( PropertyType.Property );
			m_offsetProp.UniqueId = UniqueId;
			m_offsetProp.RegisterPropertyName( true, "_AI_Offset" );
			temp2.InspectorName = "Impostor Offset";

			if( m_sizeOffsetProp == null )
			{
				m_sizeOffsetProp = ScriptableObject.CreateInstance<Vector4Node>();
			}
			m_sizeOffsetProp.ContainerGraph = ContainerGraph;
			temp2 = new AmplifyASEHelper.R_PropertyNode( m_sizeOffsetProp );
			temp2.SelAttr.Add( 0 );
			m_sizeOffsetProp.OrderIndex = m_orderSizeOffsetProp;
			m_sizeOffsetProp.ChangeParameterType( PropertyType.Property );
			m_sizeOffsetProp.UniqueId = UniqueId;
			m_sizeOffsetProp.RegisterPropertyName( true, "_AI_SizeOffset" );
			temp2.InspectorName = "Impostor Size Offset";

			if( m_biasProp == null )
			{
				m_biasProp = ScriptableObject.CreateInstance<RangedFloatNode>();
			}
			m_biasProp.ContainerGraph = ContainerGraph;
			temp2 = new AmplifyASEHelper.R_PropertyNode( m_biasProp );
			m_biasProp.Value = -1;
			m_biasProp.OrderIndex = m_orderBiasProp;
			m_biasProp.ChangeParameterType( PropertyType.Property );
			m_biasProp.UniqueId = UniqueId;
			m_biasProp.RegisterPropertyName( true, "_AI_TextureBias" );
			temp2.InspectorName = "Impostor Texture Bias";

			if( m_albedoTexture == null )
			{
				m_albedoTexture = ScriptableObject.CreateInstance<TexturePropertyNode>();
			}
			m_albedoTexture.ContainerGraph = ContainerGraph;
			temp2 = new AmplifyASEHelper.R_PropertyNode( m_albedoTexture );
			temp2.SelAttr.Add( 4 );
			m_albedoTexture.OrderIndex = m_orderAlbedoTexture;
			m_albedoTexture.CustomPrefix = "Albedo";
			m_albedoTexture.CurrentParameterType = PropertyType.Property;
			m_albedoTexture.DrawAutocast = false;
			m_albedoTexture.UniqueId = UniqueId;
			m_albedoTexture.RegisterPropertyName( true, "_Albedo" );
			temp2.InspectorName = "Impostor Albedo & Alpha";

			if( m_normalTexture == null )
			{
				m_normalTexture = ScriptableObject.CreateInstance<TexturePropertyNode>();
			}
			m_normalTexture.ContainerGraph = ContainerGraph;
			temp2 = new AmplifyASEHelper.R_PropertyNode( m_normalTexture );
			temp2.SelAttr.Add( 4 );
			m_normalTexture.OrderIndex = m_orderNormalTexture;
			m_normalTexture.CustomPrefix = "Normals";
			m_normalTexture.CurrentParameterType = PropertyType.Property;
			m_normalTexture.DrawAutocast = false;
			m_normalTexture.UniqueId = UniqueId;
			m_normalTexture.RegisterPropertyName( true, "_Normals" );
			temp2.InspectorName = "Impostor Normal & Depth";

			if( m_specularTexture == null )
			{
				m_specularTexture = ScriptableObject.CreateInstance<TexturePropertyNode>();
			}
			m_specularTexture.ContainerGraph = ContainerGraph;
			temp2 = new AmplifyASEHelper.R_PropertyNode( m_specularTexture );
			temp2.SelAttr.Add( 4 );
			m_specularTexture.OrderIndex = m_orderSpecularTexture;
			m_specularTexture.CustomPrefix = "Specular";
			m_specularTexture.DefaultTextureValue = TexturePropertyValues.black;
			m_specularTexture.CurrentParameterType = PropertyType.Property;
			m_specularTexture.DrawAutocast = false;
			m_specularTexture.UniqueId = UniqueId;
			m_specularTexture.RegisterPropertyName( true, "_Specular" );
			temp2.InspectorName = "Impostor Specular & Smoothness";

			if( m_emissionTexture == null )
			{
				m_emissionTexture = ScriptableObject.CreateInstance<TexturePropertyNode>();
			}
			m_emissionTexture.ContainerGraph = ContainerGraph;
			temp2 = new AmplifyASEHelper.R_PropertyNode( m_emissionTexture );
			temp2.SelAttr.Add( 4 );
			m_emissionTexture.OrderIndex = m_orderEmissionTexture;
			m_emissionTexture.CustomPrefix = "Emission";
			m_emissionTexture.DefaultTextureValue = TexturePropertyValues.black;
			m_emissionTexture.CurrentParameterType = PropertyType.Property;
			m_emissionTexture.DrawAutocast = false;
			m_emissionTexture.UniqueId = UniqueId;
			m_emissionTexture.RegisterPropertyName( true, "_Emission" );
			temp2.InspectorName = "Impostor Emission & Occlusion";

			if( m_depthProp == null )
			{
				m_depthProp = ScriptableObject.CreateInstance<RangedFloatNode>();
			}
			m_depthProp.ContainerGraph = ContainerGraph;
			temp2 = new AmplifyASEHelper.R_PropertyNode( m_depthProp );
			temp2.SelAttr.Add( 0 );
			m_depthProp.OrderIndex = m_orderDepthProp;
			m_depthProp.ChangeParameterType( PropertyType.Property );
			m_depthProp.UniqueId = UniqueId;
			m_depthProp.RegisterPropertyName( true, "_AI_DepthSize" );
			temp2.InspectorName = "Impostor Depth Size";

			if( m_shadowBiasProp == null )
			{
				m_shadowBiasProp = ScriptableObject.CreateInstance<RangedFloatNode>();
			}
			m_shadowBiasProp.ContainerGraph = ContainerGraph;
			temp2 = new AmplifyASEHelper.R_PropertyNode( m_shadowBiasProp );
			temp = new AmplifyASEHelper.R_RangedFloatNode( m_shadowBiasProp );
			temp.Max = 2f;
			m_shadowBiasProp.SetFloatMode( false );
			m_shadowBiasProp.Value = 0.25f;
			m_shadowBiasProp.OrderIndex = m_orderShadowBiasProp;
			m_shadowBiasProp.ChangeParameterType( PropertyType.Property );
			m_shadowBiasProp.UniqueId = UniqueId;
			m_shadowBiasProp.RegisterPropertyName( true, "_AI_ShadowBias" );
			temp2.InspectorName = "Impostor Shadow Bias";

			if( m_shadowViewProp == null )
			{
				m_shadowViewProp = ScriptableObject.CreateInstance<RangedFloatNode>();
			}
			m_shadowViewProp.ContainerGraph = ContainerGraph;
			temp2 = new AmplifyASEHelper.R_PropertyNode( m_shadowViewProp );
			temp = new AmplifyASEHelper.R_RangedFloatNode( m_shadowViewProp );
			temp.Max = 1f;
			m_shadowViewProp.SetFloatMode( false );
			m_shadowViewProp.Value = 1f;
			m_shadowViewProp.OrderIndex = m_orderShadowViewProp;
			m_shadowViewProp.ChangeParameterType( PropertyType.Property );
			m_shadowViewProp.UniqueId = UniqueId;
			m_shadowViewProp.RegisterPropertyName( true, "_AI_ShadowView" );
			temp2.InspectorName = "Impostor Shadow View";

			if( m_clipProp == null )
			{
				m_clipProp = ScriptableObject.CreateInstance<RangedFloatNode>();
			}
			m_clipProp.ContainerGraph = ContainerGraph;
			temp2 = new AmplifyASEHelper.R_PropertyNode( m_clipProp );
			temp = new AmplifyASEHelper.R_RangedFloatNode( m_clipProp );
			temp.Max = 1f;
			m_clipProp.Value = 0.5f;
			m_clipProp.SetFloatMode( false );
			m_clipProp.OrderIndex = m_orderClipProp;
			m_clipProp.ChangeParameterType( PropertyType.Property );
			m_clipProp.UniqueId = UniqueId;
			m_clipProp.RegisterPropertyName( true, "_AI_Clip" );
			temp2.InspectorName = "Impostor Clip";

			if( m_hueProp == null )
			{
				m_hueProp = ScriptableObject.CreateInstance<ColorNode>();
			}
			m_hueProp.ContainerGraph = ContainerGraph;
			temp2 = new AmplifyASEHelper.R_PropertyNode( m_hueProp );
			m_hueProp.OrderIndex = m_orderHueProp;
			m_hueProp.ChangeParameterType( PropertyType.Property );
			m_hueProp.UniqueId = UniqueId;
			m_hueProp.RegisterPropertyName( true, "_AI_HueVariation" );
			temp2.InspectorName = "Impostor Hue Variation";
			UpdatePropertyNames();
		}

		public override void SetMaterialMode( Material mat, bool fetchMaterialValues )
		{
			base.SetMaterialMode( mat, fetchMaterialValues );

			if( !m_propertiesInitialize )
				return;

			m_framesProp.SetMaterialMode( mat, fetchMaterialValues );
			m_framesXProp.SetMaterialMode( mat, fetchMaterialValues );
			m_framesYProp.SetMaterialMode( mat, fetchMaterialValues );
			m_sizeProp.SetMaterialMode( mat, fetchMaterialValues );
			m_parallaxProp.SetMaterialMode( mat, fetchMaterialValues );
			m_offsetProp.SetMaterialMode( mat, fetchMaterialValues );
			m_sizeOffsetProp.SetMaterialMode( mat, fetchMaterialValues );
			m_biasProp.SetMaterialMode( mat, fetchMaterialValues );
			m_albedoTexture.SetMaterialMode( mat, fetchMaterialValues );
			m_normalTexture.SetMaterialMode( mat, fetchMaterialValues );
			m_specularTexture.SetMaterialMode( mat, fetchMaterialValues );
			m_emissionTexture.SetMaterialMode( mat, fetchMaterialValues );
			m_depthProp.SetMaterialMode( mat, fetchMaterialValues );
			m_shadowBiasProp.SetMaterialMode( mat, fetchMaterialValues );
			m_shadowViewProp.SetMaterialMode( mat, fetchMaterialValues );
			m_clipProp.SetMaterialMode( mat, fetchMaterialValues );
			m_hueProp.SetMaterialMode( mat, fetchMaterialValues );
		}

		public override void RefreshExternalReferences()
		{
			base.RefreshExternalReferences();

			Init();

			UpdateTitle();
			UpdatePorts();
			UpdateInputPorts();
		}

		void UpdateTitle()
		{
			SetAdditonalTitleText( "Type( " + m_customImpostorType + " )" );

			//List<CustomTagData> allTags = null;
			//if( VersionInfo.FullNumber > 15500 )
			//{
			//	allTags = ( (TemplateMultiPassMasterNode)m_containerGraph.CurrentMasterNode ).SubShaderModule.TagsHelper.AvailableTags;
			//}
			//else
			//{
			//	allTags = ( m_containerGraph.MultiPassMasterNodes.NodesList[ m_containerGraph.MultiPassMasterNodes.Count - 1 ] ).SubShaderModule.TagsHelper.AvailableTags;
			//}

			//CustomTagData importorTag = allTags.Find( x => x.TagName == "ImpostorType" );
			//if( importorTag != null )
			//	importorTag.TagValue = m_customImpostorType.ToString();
			//else
			//	allTags.Add( new CustomTagData( "ImpostorType", m_customImpostorType.ToString(), 0 ) );
		}

		public override void OnNodeLogicUpdate( DrawInfo drawInfo )
		{
			base.OnNodeLogicUpdate( drawInfo );

			Init();
			m_framesProp.OnNodeLogicUpdate( drawInfo );
			m_framesXProp.OnNodeLogicUpdate( drawInfo );
			m_framesYProp.OnNodeLogicUpdate( drawInfo );
			m_sizeProp.OnNodeLogicUpdate( drawInfo );
			m_parallaxProp.OnNodeLogicUpdate( drawInfo );
			m_offsetProp.OnNodeLogicUpdate( drawInfo );
			m_sizeOffsetProp.OnNodeLogicUpdate( drawInfo );
			m_biasProp.OnNodeLogicUpdate( drawInfo );
			m_albedoTexture.OnNodeLogicUpdate( drawInfo );
			m_normalTexture.OnNodeLogicUpdate( drawInfo );
			m_specularTexture.OnNodeLogicUpdate( drawInfo );
			m_emissionTexture.OnNodeLogicUpdate( drawInfo );
			m_depthProp.OnNodeLogicUpdate( drawInfo );
			m_shadowBiasProp.OnNodeLogicUpdate( drawInfo );
			m_shadowViewProp.OnNodeLogicUpdate( drawInfo );
			m_clipProp.OnNodeLogicUpdate( drawInfo );
			m_hueProp.OnNodeLogicUpdate( drawInfo );
		}

		public override void Destroy()
		{
			base.Destroy();

			if( m_framesProp != null )
				m_framesProp.Destroy();
			m_framesProp = null;

			if( m_framesXProp != null )
				m_framesXProp.Destroy();
			m_framesXProp = null;

			if( m_framesYProp != null )
				m_framesYProp.Destroy();
			m_framesYProp = null;

			if( m_sizeProp != null )
				m_sizeProp.Destroy();
			m_sizeProp = null;

			if( m_parallaxProp != null )
				m_parallaxProp.Destroy();
			m_parallaxProp = null;

			if( m_offsetProp != null )
				m_offsetProp.Destroy();
			m_offsetProp = null;

			if( m_sizeOffsetProp != null )
				m_sizeOffsetProp.Destroy();
			m_sizeOffsetProp = null;

			if( m_biasProp != null )
				m_biasProp.Destroy();
			m_biasProp = null;

			if( m_albedoTexture != null )
				m_albedoTexture.Destroy();
			m_albedoTexture = null;

			if( m_normalTexture != null )
				m_normalTexture.Destroy();
			m_normalTexture = null;

			if( m_specularTexture != null )
				m_specularTexture.Destroy();
			m_specularTexture = null;

			if( m_emissionTexture != null )
				m_emissionTexture.Destroy();
			m_emissionTexture = null;

			if( m_depthProp != null )
				m_depthProp.Destroy();
			m_depthProp = null;

			if( m_shadowBiasProp != null )
				m_shadowBiasProp.Destroy();
			m_shadowBiasProp = null;

			if( m_shadowViewProp != null )
				m_shadowViewProp.Destroy();
			m_shadowViewProp = null;

			if( m_clipProp != null )
				m_clipProp.Destroy();
			m_clipProp = null;

			if( m_hueProp != null )
				m_hueProp.Destroy();
			m_hueProp = null;
		}

		public override string GenerateShaderForOutput( int outputId, ref MasterNodeDataCollector dataCollector, bool ignoreLocalvar )
		{
			UpdateInputPorts();

			bool hasSpec = true;
			if( !GetOutputPortByUniqueId( 3 ).IsConnected && !GetOutputPortByUniqueId( 4 ).IsConnected )
				hasSpec = false;

			bool hasEmission = true;
			if( !GetOutputPortByUniqueId( 2 ).IsConnected && !GetOutputPortByUniqueId( 5 ).IsConnected )
				hasEmission = false;

			bool generateSamplingMacros = UIUtils.CurrentWindow.OutsideGraph.CurrentMasterNode.SamplingMacros;
			m_albedoTexture.ForceSamplingMacrosGen = generateSamplingMacros;
			m_normalTexture.ForceSamplingMacrosGen = generateSamplingMacros;
			m_specularTexture.ForceSamplingMacrosGen = generateSamplingMacros;
			m_emissionTexture.ForceSamplingMacrosGen = generateSamplingMacros;

			m_framesProp.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );
			m_framesXProp.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );
			m_framesYProp.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );
			m_sizeProp.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );
			m_parallaxProp.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );
			m_offsetProp.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );
			m_sizeOffsetProp.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );
			m_biasProp.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );
			m_albedoTexture.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );
			m_normalTexture.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );
			if( hasSpec )
				m_specularTexture.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );
			if( hasEmission )
				m_emissionTexture.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );
			m_depthProp.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );
			m_shadowBiasProp.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );
			m_shadowViewProp.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );
			m_clipProp.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );

			if( m_speedTreeHueSupport )
			{
				dataCollector.AddToProperties( UniqueId, "[Toggle( EFFECT_HUE_VARIATION )] _Hue(\"Use SpeedTree Hue\", Float) = 0", m_hueProp.OrderIndex );
				dataCollector.AddToPragmas( UniqueId, "shader_feature EFFECT_HUE_VARIATION" );
				m_hueProp.GenerateShaderForOutput( 0, ref dataCollector, ignoreLocalvar );
			}

			if( dataCollector.IsSRP )
			{
				dataCollector.AddToDefines( UniqueId, "ai_ObjectToWorld GetObjectToWorldMatrix()" );
				dataCollector.AddToDefines( UniqueId, "ai_WorldToObject GetWorldToObjectMatrix()" );
				dataCollector.AddToDefines( UniqueId, "AI_INV_TWO_PI  INV_TWO_PI");
				dataCollector.AddToDefines( UniqueId, "AI_PI          PI" );
				dataCollector.AddToDefines( UniqueId, "AI_INV_PI      INV_PI" );
			} else
			{
				dataCollector.AddToDefines( UniqueId, "ai_ObjectToWorld unity_ObjectToWorld" );
				dataCollector.AddToDefines( UniqueId, "ai_WorldToObject unity_WorldToObject" );
				dataCollector.AddToDefines( UniqueId, "AI_INV_TWO_PI  UNITY_INV_TWO_PI" );
				dataCollector.AddToDefines( UniqueId, "AI_PI          UNITY_PI" );
				dataCollector.AddToDefines( UniqueId, "AI_INV_PI      UNITY_INV_PI" );
			}

			switch( m_customImpostorType )
			{
				case CustomImpostorType.Octahedron:
				{
					GenerateVectorToOctahedron();
					dataCollector.AddFunctions( "VectortoOctahedron", m_functionBody );

					GenerateOctahedronToVector();
					dataCollector.AddFunctions( "OctahedronToVector", m_functionBody );

					GenerateOctahedronRayPlaneIntersectionUV();
					dataCollector.AddFunctions( "RayPlaneIntersectionUV", m_functionBody );
				}
				break;
				case CustomImpostorType.HemiOctahedron:
				{
					GenerateVectorToHemiOctahedron();
					dataCollector.AddFunctions( "VectortoHemiOctahedron", m_functionBody );

					GenerateHemiOctahedronToVector();
					dataCollector.AddFunctions( "HemiOctahedronToVector", m_functionBody );

					GenerateOctahedronRayPlaneIntersectionUV();
					dataCollector.AddFunctions( "RayPlaneIntersectionUV", m_functionBody );
				}
				break;
				default:
				break;
			}

			if( m_customImpostorType == CustomImpostorType.Spherical )
				GenerateSphereImpostorVertex( dataCollector.IsSRP );
			else
				GenerateImpostorVertex( dataCollector.IsSRP );

			string uvFrame1Name = "UVsFrame1" + OutputId;
			string uvFrame2Name = "UVsFrame2" + OutputId;
			string uvFrame3Name = "UVsFrame3" + OutputId;
			string octaFrameName = "octaframe" + OutputId;
			string sphereFrames = "frameUVs" + OutputId;
			string viewPosName = "viewPos" + OutputId;
			TemplateVertexData data = null;
			if( m_customImpostorType == CustomImpostorType.Spherical )
			{
				data = dataCollector.TemplateDataCollectorInstance.RequestNewInterpolator( WirePortDataType.FLOAT4, false, sphereFrames );
				if( data != null )
					sphereFrames = data.VarName;
			}
			else
			{
				data = dataCollector.TemplateDataCollectorInstance.RequestNewInterpolator( WirePortDataType.FLOAT4, false, uvFrame1Name );
				if( data != null )
					uvFrame1Name = data.VarName;
				data = dataCollector.TemplateDataCollectorInstance.RequestNewInterpolator( WirePortDataType.FLOAT4, false, uvFrame2Name );
				if( data != null )
					uvFrame2Name = data.VarName;
				data = dataCollector.TemplateDataCollectorInstance.RequestNewInterpolator( WirePortDataType.FLOAT4, false, uvFrame3Name );
				if( data != null )
					uvFrame3Name = data.VarName;
				data = dataCollector.TemplateDataCollectorInstance.RequestNewInterpolator( WirePortDataType.FLOAT4, false, octaFrameName );
				if( data != null )
					octaFrameName = data.VarName;
			}
			data = dataCollector.TemplateDataCollectorInstance.RequestNewInterpolator( WirePortDataType.FLOAT4, false, viewPosName );
			if( data != null )
				viewPosName = data.VarName;

			MasterNodePortCategory portCategory = dataCollector.PortCategory;
			dataCollector.PortCategory = MasterNodePortCategory.Vertex;
			//Debug.Log( dataCollector.TemplateDataCollectorInstance.CurrentTemplateData.FragmentFunctionData.InVarType );
			string vertOut = dataCollector.TemplateDataCollectorInstance.CurrentTemplateData.VertexFunctionData.OutVarName;
			string vertIN = dataCollector.TemplateDataCollectorInstance.CurrentTemplateData.VertexFunctionData.InVarName;
			string functionResult = string.Empty;
			if( m_customImpostorType == CustomImpostorType.Spherical )
				functionResult = dataCollector.AddFunctions( m_functionHeaderSphere, m_functionBody, vertIN + ".vertex", vertIN + ".normal", vertOut + "." + sphereFrames, vertOut + "." + viewPosName );
			else
				functionResult = dataCollector.AddFunctions( m_functionHeader, m_functionBody, vertIN+".vertex", vertIN + ".normal", vertOut + "." + uvFrame1Name, vertOut + "." + uvFrame2Name, vertOut + "." + uvFrame3Name, vertOut + "." + octaFrameName, vertOut + "." + viewPosName );
			dataCollector.AddLocalVariable( UniqueId, functionResult + ";" );

			dataCollector.PortCategory = portCategory;

			if( dataCollector.IsFragmentCategory )
			{
				string extraHeader = string.Empty;

				for( int i = 0; i < m_extraSamplers; i++ )
				{
					if( GetInputPortByArrayId( i ).IsConnected && GetOutputPortByArrayId( i ).IsConnected )
					{
						m_extraPropertyNames[ i ] = GetInputPortByArrayId( i ).GeneratePortInstructions( ref dataCollector );
						dataCollector.AddLocalVariable( UniqueId, "float4 output" + i + " = 0;" );
						extraHeader += ", output" + i;
					}
				}

				string finalHeader = m_functionHeaderFrag;
				if( m_customImpostorType == CustomImpostorType.Spherical )
				{
					finalHeader = m_functionHeaderSphereFrag;
					finalHeader = finalHeader.Replace( "{1}", "{1}" + extraHeader );
				}
				else
				{
					finalHeader = finalHeader.Replace( "{4}", "{4}" + extraHeader );
				}

				string fragIN = dataCollector.TemplateDataCollectorInstance.CurrentTemplateData.FragmentFunctionData.InVarName;
				if( m_customImpostorType == CustomImpostorType.Spherical )
				{
					GenerateSphereImpostorFragment( ref dataCollector, hasSpec, hasEmission, dataCollector.IsSRP );
					functionResult = dataCollector.AddFunctions( finalHeader, m_functionBody, fragIN + "." + sphereFrames, fragIN + "." + viewPosName );
				}
				else
				{
					GenerateImpostorFragment( ref dataCollector, hasSpec, hasEmission, dataCollector.IsSRP );
					functionResult = dataCollector.AddFunctions( finalHeader, m_functionBody, fragIN + "." + uvFrame1Name, fragIN + "." + uvFrame2Name, fragIN + "." + uvFrame3Name, fragIN + "." + octaFrameName, fragIN + "." + viewPosName );
				}
				dataCollector.AddLocalVariable( UniqueId, functionResult + ";" );

				switch( outputId )
				{
					case 0:
					return "o.Albedo";
					case 1:
					return "o.Normal";
					case 2:
					return "o.Emission";
					case 3:
					return m_workflow == ASEStandardSurfaceWorkflow.Specular ? "o.Specular" : "o.Metallic";
					case 4:
					return "o.Smoothness";
					case 5:
					return "o.Occlusion";
					case 6:
					return "o.Alpha";
					case 7:
					return "worldPos";
					case 16:
					dataCollector.AddLocalVariable( UniqueId, "float3 viewPosOut" + OutputId + " = mul( UNITY_MATRIX_V, float4( worldPos.xyz, 1.0 ) ).xyz;" );
					return "viewPosOut" + OutputId;
					default:
					return "output" + ( outputId - 8 );
				}
			}
			else
			{
				switch( outputId )
				{
					case 7:
					dataCollector.AddLocalVariable( UniqueId, "float3 worldPosOut" + OutputId + " = mul( UNITY_MATRIX_I_V, float4( " + vertOut + "." + viewPosName + ".xyz, 1.0 ) ).xyz;" );
					return "worldPosOut" + OutputId;
					case 16:
					return vertOut + "." + viewPosName + ".xyz";
					default:
					return "0";
				}
			}
		}

		public override void WriteToString( ref string nodeInfo, ref string connectionsInfo )
		{
			base.WriteToString( ref nodeInfo, ref connectionsInfo );

			IOUtils.AddFieldValueToString( ref nodeInfo, AmplifyImpostors.VersionInfo.FullNumber );

			IOUtils.AddFieldValueToString( ref nodeInfo, m_customImpostorType );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_speedTreeHueSupport );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_showExtraData );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_forceClampFrames );

			IOUtils.AddFieldValueToString( ref nodeInfo, m_framesProp.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_framesXProp.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_framesYProp.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_sizeProp.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_parallaxProp.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_offsetProp.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_sizeOffsetProp.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_biasProp.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_albedoTexture.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_normalTexture.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_specularTexture.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_emissionTexture.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_depthProp.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_shadowBiasProp.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_shadowViewProp.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_clipProp.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_hueProp.OrderIndex.ToString() );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_extraSamplers );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_workflow );
			IOUtils.AddFieldValueToString( ref nodeInfo , m_matchPropertyNames );
		}

		public override void ReadFromString( ref string[] nodeParams )
		{
			base.ReadFromString( ref nodeParams );

			int version = 0;
			if( UIUtils.CurrentShaderVersion() > 15602 && AmplifyImpostors.VersionInfo.FullNumber >= 9202 )
				version = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );

			m_customImpostorType = (CustomImpostorType)Enum.Parse( typeof( CustomImpostorType ), GetCurrentParam( ref nodeParams ) );
			m_speedTreeHueSupport = Convert.ToBoolean( GetCurrentParam( ref nodeParams ) );

			m_showExtraData = Convert.ToBoolean( GetCurrentParam( ref nodeParams ) );

			if( version >= 9202 )
			{
				m_forceClampFrames = Convert.ToBoolean( GetCurrentParam( ref nodeParams ) );
			}

			m_orderFramesProp = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
			m_orderFramesXProp = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
			m_orderFramesYProp = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
			m_orderSizeProp = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
			m_orderParallaxProp = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
			m_orderOffsetProp = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
			if( version >= 9500 )
			{
				m_orderSizeOffsetProp = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
			}
			m_orderBiasProp = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
			m_orderAlbedoTexture = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
			m_orderNormalTexture = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
			m_orderSpecularTexture = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
			m_orderEmissionTexture = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
			m_orderDepthProp = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
			m_orderShadowBiasProp = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
			if( version >= 9300 )
			{
				m_orderShadowViewProp = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
			}

			m_orderClipProp = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
			m_orderHueProp = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );

			if( UIUtils.CurrentShaderVersion() > 15405 )
			{
				m_extraSamplers = Convert.ToInt32( GetCurrentParam( ref nodeParams ) );
				m_workflow = (ASEStandardSurfaceWorkflow)Enum.Parse( typeof( ASEStandardSurfaceWorkflow ), GetCurrentParam( ref nodeParams ) );
			}
			if( version > 9707 )
			{
				m_matchPropertyNames = Convert.ToBoolean( GetCurrentParam( ref nodeParams ) );
			}

			UpdateTitle();
			UpdatePorts();
			UpdateInputPorts();
		}

		private void GenerateVectorToOctahedron()
		{
			m_functionBody = string.Empty;
			IOUtils.AddFunctionHeader( ref m_functionBody, "float2 VectortoOctahedron( float3 N )" );
			IOUtils.AddFunctionLine( ref m_functionBody, "N /= dot( 1.0, abs( N ) );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "if( N.z <= 0 )" );
			IOUtils.AddFunctionLine( ref m_functionBody, "{" );
			IOUtils.AddFunctionLine( ref m_functionBody, "N.xy = ( 1 - abs( N.yx ) ) * ( N.xy >= 0 ? 1.0 : -1.0 );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "}" );
			IOUtils.AddFunctionLine( ref m_functionBody, "return N.xy;" );
			IOUtils.CloseFunctionBody( ref m_functionBody );
		}

		private void GenerateOctahedronToVector()
		{
			m_functionBody = string.Empty;
			IOUtils.AddFunctionHeader( ref m_functionBody, "float3 OctahedronToVector( float2 Oct )" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 N = float3( Oct, 1.0 - dot( 1.0, abs( Oct ) ) );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "if(N.z< 0 )" );
			IOUtils.AddFunctionLine( ref m_functionBody, "{" );
			IOUtils.AddFunctionLine( ref m_functionBody, "N.xy = ( 1 - abs( N.yx) ) * (N.xy >= 0 ? 1.0 : -1.0 );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "}" );
			IOUtils.AddFunctionLine( ref m_functionBody, "return normalize( N);" );
			IOUtils.CloseFunctionBody( ref m_functionBody );
		}

		private void GenerateVectorToHemiOctahedron()
		{
			m_functionBody = string.Empty;
			IOUtils.AddFunctionHeader( ref m_functionBody, "float2 VectortoHemiOctahedron( float3 N )" );
			IOUtils.AddFunctionLine( ref m_functionBody, "N.xy /= dot( 1.0, abs( N ) );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "return float2( N.x + N.y, N.x - N.y );" );
			IOUtils.CloseFunctionBody( ref m_functionBody );
		}

		private void GenerateHemiOctahedronToVector()
		{
			m_functionBody = string.Empty;
			IOUtils.AddFunctionHeader( ref m_functionBody, "float3 HemiOctahedronToVector( float2 Oct )" );
			IOUtils.AddFunctionLine( ref m_functionBody, "Oct = float2( Oct.x + Oct.y, Oct.x - Oct.y ) * 0.5;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 N = float3( Oct, 1 - dot( 1.0, abs( Oct ) ) );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "return normalize( N );" );
			IOUtils.CloseFunctionBody( ref m_functionBody );
		}

		private void GenerateOctahedronRayPlaneIntersectionUV()
		{
			m_functionBody = string.Empty;
			IOUtils.AddFunctionHeader( ref m_functionBody, "inline void RayPlaneIntersectionUV( float3 normal, float3 rayPosition, float3 rayDirection, inout float2 uvs, inout float3 localNormal )" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float lDotN = dot( rayDirection, normal ); " );
			IOUtils.AddFunctionLine( ref m_functionBody, "float p0l0DotN = dot( -rayPosition, normal );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float t = p0l0DotN / lDotN;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 p = rayDirection * t + rayPosition;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 upVector = float3( 0, 1, 0 );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 tangent = normalize( cross( upVector, normal ) + float3( -0.001, 0, 0 ) );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 bitangent = cross( tangent, normal );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float frameX = dot( p, tangent );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float frameZ = dot( p, bitangent );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "uvs = -float2( frameX, frameZ );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "if( t <= 0.0 )" );
			IOUtils.AddFunctionLine( ref m_functionBody, "uvs = 0;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3x3 worldToLocal = float3x3( tangent, bitangent, normal );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "localNormal = normalize( mul( worldToLocal, rayDirection ) );" );
			IOUtils.CloseFunctionBody( ref m_functionBody );
		}

		private void GenerateSphereImpostorVertex( bool isSRP = false )
		{
			m_functionBody = string.Empty;
			IOUtils.AddFunctionHeader( ref m_functionBody, "inline void SphereImpostorVertex( inout float4 vertex, inout float3 normal, inout float4 frameUVs, inout float4 viewPos )" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 uvOffset = _AI_SizeOffset.zw;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float sizeX = "+ m_framesXProp.PropertyName + ";" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float sizeY = "+ m_framesYProp.PropertyName + " - 1; " );
			IOUtils.AddFunctionLine( ref m_functionBody, "float UVscale = "+ m_sizeProp.PropertyName + ";" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float4 fractions = 1 / float4( sizeX, "+ m_framesYProp.PropertyName + ", sizeY, UVscale );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 sizeFraction = fractions.xy;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float axisSizeFraction = fractions.z;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float fractionsUVscale = fractions.w;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 worldOrigin = 0;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float4 perspective = float4( 0, 0, 0, 1 );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "if( UNITY_MATRIX_P[ 3 ][ 3 ] == 1 )" );
			IOUtils.AddFunctionLine( ref m_functionBody, "{" );
			IOUtils.AddFunctionLine( ref m_functionBody, "perspective = float4( 0, 0, 5000, 0 );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "worldOrigin = ai_ObjectToWorld._m03_m13_m23;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "}" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 worldCameraPos = worldOrigin + mul( UNITY_MATRIX_I_V, perspective ).xyz;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 objectCameraPosition = mul( ai_WorldToObject, float4( worldCameraPos, 1 ) ).xyz - "+ m_offsetProp.PropertyName + ".xyz; " );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 objectCameraDirection = normalize( objectCameraPosition );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 upVector = float3( 0,1,0 );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 objectHorizontalVector = normalize( cross( objectCameraDirection, upVector ) );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 objectVerticalVector = cross( objectHorizontalVector, objectCameraDirection );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float verticalAngle = frac( atan2( -objectCameraDirection.z, -objectCameraDirection.x ) * AI_INV_TWO_PI ) * sizeX + 0.5;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float verticalDot = dot( objectCameraDirection, upVector );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float upAngle = ( acos( -verticalDot ) * AI_INV_PI ) + axisSizeFraction * 0.5f;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float yRot = sizeFraction.x * AI_PI * verticalDot * ( 2 * frac( verticalAngle ) - 1 );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 uvExpansion = vertex.xy;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float cosY = cos( yRot );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float sinY = sin( yRot );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 uvRotator = mul( uvExpansion, float2x2( cosY, -sinY, sinY, cosY ) );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 billboard = objectHorizontalVector * uvRotator.x + objectVerticalVector * uvRotator.y + "+ m_offsetProp.PropertyName + ".xyz;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 relativeCoords = float2( floor( verticalAngle ), min( floor( upAngle * sizeY ), sizeY ) );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 frameUV = ( ( uvExpansion * fractionsUVscale + 0.5 ) + relativeCoords ) * sizeFraction;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "frameUVs.xy = frameUV - uvOffset;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "frameUVs.zw = 0;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.w = 0;" );
			if( isSRP )
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.xyz = TransformWorldToView( TransformObjectToWorld( billboard ) );" );
			}
			else
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.xyz = UnityObjectToViewPos( billboard );" );
			}
			if( m_speedTreeHueSupport )
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "#ifdef EFFECT_HUE_VARIATION" );
				IOUtils.AddFunctionLine( ref m_functionBody, "float hueVariationAmount = frac( ai_ObjectToWorld[0].w + ai_ObjectToWorld[1].w + ai_ObjectToWorld[2].w );" );
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.w = saturate(hueVariationAmount * "+ m_hueProp.PropertyName + ".a);" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
			}
			IOUtils.AddFunctionLine( ref m_functionBody, "vertex.xyz = billboard;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "normal.xyz = objectCameraDirection;" );
			IOUtils.CloseFunctionBody( ref m_functionBody );
		}

		private void GenerateSphereImpostorFragment( ref MasterNodeDataCollector dataCollector, bool withSpec = true, bool withEmission = true, bool isSRP = false )
		{
			m_functionBody = string.Empty;

			string extraHeader = string.Empty;
			for( int i = 0; i < m_extraSamplers; i++ )
			{
				if( GetInputPortByArrayId( i ).IsConnected && GetOutputPortByArrayId( i ).IsConnected )
					extraHeader += ", out float4 output" + i;
			}

			string structure = "SurfaceOutputStandard";
			if( m_workflow == ASEStandardSurfaceWorkflow.Specular )
				structure = "SurfaceOutputStandardSpecular";
			if( isSRP )
				structure = "SurfaceOutput";

			IOUtils.AddFunctionHeader( ref m_functionBody, "inline void SphereImpostorFragment( inout "+ structure + " o, out float4 clipPos, out float3 worldPos, float4 frameUV, float4 viewPos" + extraHeader + " )" );
			IOUtils.AddFunctionLine( ref m_functionBody, "#if _USE_PARALLAX_ON" );
			//IOUtils.AddFunctionLine( ref m_functionBody, "float4 parallaxSample = tex2Dbias( _Normals, float4( frameUV.xy, 0, -1 ) );" );
			IOUtils.AddFunctionLine( ref m_functionBody, 
			"float4 parallaxSample = " + GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Normals","sampler_Normals","frameUV.xy",MipType.MipBias, "-1" ) + ";" );

			IOUtils.AddFunctionLine( ref m_functionBody, "frameUV.xy = ( ( 0.5 - parallaxSample.a ) * frameUV.zw ) + frameUV.xy;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
			//IOUtils.AddFunctionLine( ref m_functionBody, "float4 albedoSample = tex2Dbias( _Albedo, float4( frameUV.xy, 0, _AI_TextureBias) );" );
			IOUtils.AddFunctionLine( ref m_functionBody,
			"float4 albedoSample = "+ GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Albedo","sampler_Albedo", "frameUV.xy",MipType.MipBias, m_biasProp.PropertyName ) +";" );

			IOUtils.AddFunctionLine( ref m_functionBody, "o.Alpha = ( albedoSample.a - "+ m_clipProp.PropertyName + " );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "clip( o.Alpha );" );
			if( m_speedTreeHueSupport )
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "#ifdef EFFECT_HUE_VARIATION" );
				IOUtils.AddFunctionLine( ref m_functionBody, "half3 shiftedColor = lerp(albedoSample.rgb, _HueVariation.rgb, viewPos.w);" );
				IOUtils.AddFunctionLine( ref m_functionBody, "half maxBase = max(albedoSample.r, max(albedoSample.g, albedoSample.b));" );
				IOUtils.AddFunctionLine( ref m_functionBody, "half newMaxBase = max(shiftedColor.r, max(shiftedColor.g, shiftedColor.b));" );
				IOUtils.AddFunctionLine( ref m_functionBody, "maxBase /= newMaxBase;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "maxBase = maxBase * 0.5f + 0.5f;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "shiftedColor.rgb *= maxBase;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "albedoSample.rgb = saturate(shiftedColor);" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
			}
			IOUtils.AddFunctionLine( ref m_functionBody, "o.Albedo = albedoSample.rgb;" );
			if( withSpec )
			{
				//IOUtils.AddFunctionLine( ref m_functionBody, "float4 specularSample = AI_SAMPLEBIAS( _Specular, sampler_Specular, frameUV.xy, _AI_TextureBias );" );
				IOUtils.AddFunctionLine( ref m_functionBody, 
				"float4 specularSample = " + GeneratorUtils.GenerateSamplingCall(ref dataCollector,WirePortDataType.SAMPLER2D,"_Specular","sampler_Specular", "frameUV.xy",MipType.MipBias, m_biasProp.PropertyName ) +";" );
				
				if( m_workflow == ASEStandardSurfaceWorkflow.Specular )
					IOUtils.AddFunctionLine( ref m_functionBody, "o.Specular = specularSample.rgb;" );
				else
					IOUtils.AddFunctionLine( ref m_functionBody, "o.Metallic = saturate( ( specularSample.rgb - unity_ColorSpaceDielectricSpec.rgb ) / ( albedoSample.rgb - unity_ColorSpaceDielectricSpec.rgb ) ); " );
				IOUtils.AddFunctionLine( ref m_functionBody, "o.Smoothness = specularSample.a;" );
			}
			if( withEmission )
			{
				//IOUtils.AddFunctionLine( ref m_functionBody, "float4 emissionSample = tex2Dbias( _Emission, float4( frameUV.xy, 0, _AI_TextureBias) );" );
				IOUtils.AddFunctionLine( ref m_functionBody, 
				"float4 emissionSample = "+ GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Emission","sampler_Emission","frameUV.xy",MipType.MipBias, m_biasProp.PropertyName ) +";" );

				IOUtils.AddFunctionLine( ref m_functionBody, "o.Emission = emissionSample.rgb;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "o.Occlusion = emissionSample.a;" );
			}
			if( isSRP )
			{
				for( int i = 0 ; i < DielecticSRPFix.Length ; i++ )
				{
					dataCollector.AddToDirectives( DielecticSRPFix[ i ] );
				}
				IOUtils.AddFunctionLine( ref m_functionBody, "#if defined(AI_HD_RENDERPIPELINE) && ( AI_HDRP_VERSION >= 50702 )" );
				IOUtils.AddFunctionLine( ref m_functionBody, "float4 feat1 = _Features.SampleLevel( SamplerState_Point_Repeat, frameUV.xy, 0);" );
				IOUtils.AddFunctionLine( ref m_functionBody, "o.Diffusion = feat1.rgb;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "o.Features = feat1.a;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "float4 test1 = _Specular.SampleLevel( SamplerState_Point_Repeat, frameUV.xy, 0);" );
				IOUtils.AddFunctionLine( ref m_functionBody, "o.MetalTangent = test1.b;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
			}
			for( int i = 0; i < m_extraSamplers; i++ )
			{
				if( GetInputPortByArrayId( i ).IsConnected && GetOutputPortByArrayId( i ).IsConnected )
				{
					//IOUtils.AddFunctionLine( ref m_functionBody, "output" + i + " = tex2Dbias( " + m_extraPropertyNames[ i ] + ", float4( frameUV.xy, 0, _AI_TextureBias) ); " );
					IOUtils.AddFunctionLine( ref m_functionBody, 
					"output" + i + " = "+ GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, m_extraPropertyNames[ i ], "sampler_"+ m_extraPropertyNames[ i ],"frameUV.xy", MipType.MipBias, m_biasProp.PropertyName ) +";" );
				}
			}
			//IOUtils.AddFunctionLine( ref m_functionBody, "float4 normalSample = tex2Dbias( _Normals, float4( frameUV.xy, 0, _AI_TextureBias) );" );
			IOUtils.AddFunctionLine( ref m_functionBody,
			"float4 normalSample = "+ GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Normals","sampler_Normals", "frameUV.xy",MipType.MipBias, m_biasProp.PropertyName ) +";" );

			IOUtils.AddFunctionLine( ref m_functionBody, "float4 remapNormal = normalSample * 2 - 1; " );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 worldNormal = normalize( mul( (float3x3)ai_ObjectToWorld, remapNormal.xyz ) );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "o.Normal = worldNormal;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float depth = remapNormal.a * "+ m_depthProp.PropertyName + " * 0.5 * length( ai_ObjectToWorld[ 2 ].xyz );" );
			if( !isSRP )
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "#if defined(SHADOWS_DEPTH)" );
				IOUtils.AddFunctionLine( ref m_functionBody, "if( unity_LightShadowBias.y == 1.0 ) " );
				IOUtils.AddFunctionLine( ref m_functionBody, "{" );
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.z += depth * _AI_ShadowView;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.z += -_AI_ShadowBias;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "}" );
				IOUtils.AddFunctionLine( ref m_functionBody, "else " );
				IOUtils.AddFunctionLine( ref m_functionBody, "{" );
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.z += depth;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "}" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#else " );
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.z += depth;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
			}
			else
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "#if ( defined(SHADERPASS) && (SHADERPASS == SHADERPASS_SHADOWS) ) || defined(UNITY_PASS_SHADOWCASTER)" );
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.z += depth * _AI_ShadowView;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.z += -_AI_ShadowBias;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#else " );
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.z += depth;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
			}
			if( isSRP && dataCollector.CurrentSRPType == TemplateSRPType.HD )
			{
				IOUtils.AddFunctionLine( ref m_functionBody , "worldPos = GetAbsolutePositionWS( mul( UNITY_MATRIX_I_V, float4( viewPos.xyz, 1 ) )).xyz;" );
			}
			else
			{
				IOUtils.AddFunctionLine( ref m_functionBody , "worldPos = mul( UNITY_MATRIX_I_V, float4( viewPos.xyz, 1 ) ).xyz;" );
			}
			IOUtils.AddFunctionLine( ref m_functionBody, "clipPos = mul( UNITY_MATRIX_P, float4( viewPos.xyz, 1 ) );" );
			if( !isSRP )
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "#if defined(SHADOWS_DEPTH)" );
				IOUtils.AddFunctionLine( ref m_functionBody, "clipPos = UnityApplyLinearShadowBias( clipPos );" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
			}
			else
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "#if defined(UNITY_PASS_SHADOWCASTER) && !defined(SHADERPASS)" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#if UNITY_REVERSED_Z" );
				IOUtils.AddFunctionLine( ref m_functionBody, "clipPos.z = min( clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE );" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#else" );
				IOUtils.AddFunctionLine( ref m_functionBody, "clipPos.z = max( clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE );" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
			}
			IOUtils.AddFunctionLine( ref m_functionBody, "clipPos.xyz /= clipPos.w;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "if( UNITY_NEAR_CLIP_VALUE < 0 )" );
			IOUtils.AddFunctionLine( ref m_functionBody, "clipPos = clipPos * 0.5 + 0.5;" );
			IOUtils.CloseFunctionBody( ref m_functionBody );
		}

		/// <summary>
		/// Octahedron vertex function
		/// </summary>
		/// <param name="isSRP"></param>
		private void GenerateImpostorVertex( bool isSRP = false )
		{
			m_functionBody = string.Empty;
			IOUtils.AddFunctionHeader( ref m_functionBody, "inline void OctaImpostorVertex( inout float4 vertex, inout float3 normal, inout float4 uvsFrame1, inout float4 uvsFrame2, inout float4 uvsFrame3, inout float4 octaFrame, inout float4 viewPos )" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 uvOffset = _AI_SizeOffset.zw;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float parallax = -"+ m_parallaxProp.PropertyName + "; " );
			IOUtils.AddFunctionLine( ref m_functionBody, "float UVscale = "+ m_sizeProp.PropertyName + ";" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float framesXY = "+ m_framesProp.PropertyName + ";" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float prevFrame = framesXY - 1;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 fractions = 1.0 / float3( framesXY, prevFrame, UVscale );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float fractionsFrame = fractions.x;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float fractionsPrevFrame = fractions.y;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float fractionsUVscale = fractions.z;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 worldOrigin = 0;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float4 perspective = float4( 0, 0, 0, 1 );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "if( UNITY_MATRIX_P[ 3 ][ 3 ] == 1 ) " );
			IOUtils.AddFunctionLine( ref m_functionBody, "{" );
			IOUtils.AddFunctionLine( ref m_functionBody, "perspective = float4( 0, 0, 5000, 0 );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "worldOrigin = ai_ObjectToWorld._m03_m13_m23;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "}" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 worldCameraPos = worldOrigin + mul( UNITY_MATRIX_I_V, perspective ).xyz;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 objectCameraPosition = mul( ai_WorldToObject, float4( worldCameraPos, 1 ) ).xyz - "+ m_offsetProp.PropertyName + ".xyz; " );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 objectCameraDirection = normalize( objectCameraPosition );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 upVector = float3( 0,1,0 );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 objectHorizontalVector = normalize( cross( objectCameraDirection, upVector ) );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 objectVerticalVector = cross( objectHorizontalVector, objectCameraDirection );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 uvExpansion = vertex.xy;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 billboard = objectHorizontalVector * uvExpansion.x + objectVerticalVector * uvExpansion.y;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 localDir = billboard - objectCameraPosition; " );
			if( m_customImpostorType == CustomImpostorType.HemiOctahedron )
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "objectCameraDirection.y = max(0.001, objectCameraDirection.y);" );
				IOUtils.AddFunctionLine( ref m_functionBody, "float2 frameOcta = VectortoHemiOctahedron( objectCameraDirection.xzy ) * 0.5 + 0.5;" );
			}
			else
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "float2 frameOcta = VectortoOctahedron( objectCameraDirection.xzy ) * 0.5 + 0.5;" );
			}
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 prevOctaFrame = frameOcta * prevFrame;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 baseOctaFrame = floor( prevOctaFrame );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 fractionOctaFrame = ( baseOctaFrame * fractionsFrame );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 octaFrame1 = ( baseOctaFrame * fractionsPrevFrame ) * 2.0 - 1.0;" );
			if( m_customImpostorType == CustomImpostorType.HemiOctahedron )
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "float3 octa1WorldY = HemiOctahedronToVector( octaFrame1 ).xzy;" );
			}
			else
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "float3 octa1WorldY = OctahedronToVector( octaFrame1 ).xzy;" );
			}
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 octa1LocalY;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 uvFrame1;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "RayPlaneIntersectionUV( octa1WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame1, /*inout*/ octa1LocalY );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 uvParallax1 = octa1LocalY.xy * fractionsFrame * parallax;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "uvFrame1 = ( uvFrame1 * fractionsUVscale + 0.5 ) * fractionsFrame + fractionOctaFrame;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "uvsFrame1 = float4( uvParallax1, uvFrame1) - float4( 0, 0, uvOffset );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 fractPrevOctaFrame = frac( prevOctaFrame );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 cornerDifference = lerp( float2( 0,1 ) , float2( 1,0 ) , saturate( ceil( ( fractPrevOctaFrame.x - fractPrevOctaFrame.y ) ) ));" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 octaFrame2 = ( ( baseOctaFrame + cornerDifference ) * fractionsPrevFrame ) * 2.0 - 1.0;" );
			if( m_customImpostorType == CustomImpostorType.HemiOctahedron )
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "float3 octa2WorldY = HemiOctahedronToVector( octaFrame2 ).xzy;" );
			}
			else
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "float3 octa2WorldY = OctahedronToVector( octaFrame2 ).xzy;" );
			}
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 octa2LocalY;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 uvFrame2;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "RayPlaneIntersectionUV( octa2WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame2, /*inout*/ octa2LocalY );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 uvParallax2 = octa2LocalY.xy * fractionsFrame * parallax;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "uvFrame2 = ( uvFrame2 * fractionsUVscale + 0.5 ) * fractionsFrame + ( ( cornerDifference * fractionsFrame ) + fractionOctaFrame );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "uvsFrame2 = float4( uvParallax2, uvFrame2) - float4( 0, 0, uvOffset );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 octaFrame3 = ( ( baseOctaFrame + 1 ) * fractionsPrevFrame  ) * 2.0 - 1.0;" );
			if( m_customImpostorType == CustomImpostorType.HemiOctahedron )
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "float3 octa3WorldY = HemiOctahedronToVector( octaFrame3 ).xzy;" );
			}
			else
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "float3 octa3WorldY = OctahedronToVector( octaFrame3 ).xzy;" );
			}
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 octa3LocalY;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 uvFrame3;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "RayPlaneIntersectionUV( octa3WorldY, objectCameraPosition, localDir, /*inout*/ uvFrame3, /*inout*/ octa3LocalY );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 uvParallax3 = octa3LocalY.xy * fractionsFrame * parallax;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "uvFrame3 = ( uvFrame3 * fractionsUVscale + 0.5 ) * fractionsFrame + ( fractionOctaFrame + fractionsFrame );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "uvsFrame3 = float4( uvParallax3, uvFrame3) - float4( 0, 0, uvOffset );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "octaFrame = 0;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "octaFrame.xy = prevOctaFrame;" );
			if( m_forceClampFrames )
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "octaFrame.zw = fractionOctaFrame;" );
			}
			IOUtils.AddFunctionLine( ref m_functionBody, "vertex.xyz = billboard + "+ m_offsetProp.PropertyName + ".xyz;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "normal.xyz = objectCameraDirection;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "viewPos = 0;" );
			if( isSRP )
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.xyz = TransformWorldToView( TransformObjectToWorld( vertex.xyz ) );" );
			}
			else
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.xyz = UnityObjectToViewPos( vertex.xyz );" );
			}
			if( m_speedTreeHueSupport )
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "#ifdef EFFECT_HUE_VARIATION" );
				IOUtils.AddFunctionLine( ref m_functionBody, "float hueVariationAmount = frac( ai_ObjectToWorld[0].w + ai_ObjectToWorld[1].w + ai_ObjectToWorld[2].w);" );
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.w = saturate(hueVariationAmount * "+ m_hueProp.PropertyName + ".a);" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
			}
			IOUtils.CloseFunctionBody( ref m_functionBody );
		}

		void GenerateImpostorFragment( ref MasterNodeDataCollector dataCollector, bool withSpec = true, bool withEmission = true, bool isSRP = false )
		{
			m_functionBody = string.Empty;

			string extraHeader = string.Empty;
			for( int i = 0; i < m_extraSamplers; i++ )
			{
				if( GetInputPortByArrayId( i ).IsConnected && GetOutputPortByArrayId( i ).IsConnected )
					extraHeader += ", out float4 output" + i;
			}

			string structure = "SurfaceOutputStandard";
			if( m_workflow == ASEStandardSurfaceWorkflow.Specular )
				structure = "SurfaceOutputStandardSpecular";
			if( isSRP )
				structure = "SurfaceOutput";

			IOUtils.AddFunctionHeader( ref m_functionBody, "inline void OctaImpostorFragment( inout "+ structure + " o, out float4 clipPos, out float3 worldPos, float4 uvsFrame1, float4 uvsFrame2, float4 uvsFrame3, float4 octaFrame, float4 interpViewPos" + extraHeader + " )" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float depthBias = -1.0;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float textureBias = "+ m_biasProp.PropertyName + ";" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 fraction = frac( octaFrame.xy );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float2 invFraction = 1 - fraction;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 weights;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "weights.x = min( invFraction.x, invFraction.y );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "weights.y = abs( fraction.x - fraction.y );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "weights.z = min( fraction.x, fraction.y );" );
			//IOUtils.AddFunctionLine( ref m_functionBody, "float4 parallaxSample1 = tex2Dbias( _Normals, float4( uvsFrame1.zw, 0, depthBias) );" );
			IOUtils.AddFunctionLine( ref m_functionBody, 
			"float4 parallaxSample1 = "+ GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Normals","sampler_Normals","uvsFrame1.zw", MipType.MipBias, "depthBias") + ";" );

			IOUtils.AddFunctionLine( ref m_functionBody, "float2 parallax1 = ( ( 0.5 - parallaxSample1.a ) * uvsFrame1.xy ) + uvsFrame1.zw;" );
			//IOUtils.AddFunctionLine( ref m_functionBody, "float4 parallaxSample2 = tex2Dbias( _Normals, float4( uvsFrame2.zw, 0, depthBias) );" );
			IOUtils.AddFunctionLine( ref m_functionBody,
			"float4 parallaxSample2 = "+ GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Normals","sampler_Normals","uvsFrame2.zw",MipType.MipBias, "depthBias") +";" );

			IOUtils.AddFunctionLine( ref m_functionBody, "float2 parallax2 = ( ( 0.5 - parallaxSample2.a ) * uvsFrame2.xy ) + uvsFrame2.zw;" );
			//IOUtils.AddFunctionLine( ref m_functionBody, "float4 parallaxSample3 = tex2Dbias( _Normals, float4( uvsFrame3.zw, 0, depthBias) );" );
			IOUtils.AddFunctionLine( ref m_functionBody,
			"float4 parallaxSample3 = "+ GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Normals","sampler_Normals","uvsFrame3.zw", MipType.MipBias, "depthBias") +";" );

			IOUtils.AddFunctionLine( ref m_functionBody, "float2 parallax3 = ( ( 0.5 - parallaxSample3.a ) * uvsFrame3.xy ) + uvsFrame3.zw;" );
			//IOUtils.AddFunctionLine( ref m_functionBody, "float4 albedo1 = tex2Dbias( _Albedo, float4( parallax1, 0, textureBias) );" );
			IOUtils.AddFunctionLine( ref m_functionBody,
			"float4 albedo1 = " + GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Albedo","sampler_Albedo","parallax1",MipType.MipBias, "textureBias")+ ";" );

			//IOUtils.AddFunctionLine( ref m_functionBody, "float4 albedo2 = tex2Dbias( _Albedo, float4( parallax2, 0, textureBias) );" );
			IOUtils.AddFunctionLine( ref m_functionBody, 
			"float4 albedo2 = "+ GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Albedo","sampler_Albedo", "parallax2", MipType.MipBias, "textureBias") +";" );

			//IOUtils.AddFunctionLine( ref m_functionBody, "float4 albedo3 = tex2Dbias( _Albedo, float4( parallax3, 0, textureBias) );" );
			IOUtils.AddFunctionLine( ref m_functionBody, 
			"float4 albedo3 = "+ GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Albedo","sampler_Albedo","parallax3", MipType.MipBias, "textureBias")+ ";" );

			IOUtils.AddFunctionLine( ref m_functionBody, "float4 blendedAlbedo = albedo1 * weights.x + albedo2 * weights.y + albedo3 * weights.z;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "o.Alpha = ( blendedAlbedo.a - "+ m_clipProp.PropertyName + " );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "clip( o.Alpha );" );
			if( m_forceClampFrames )
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "float t = ceil( fraction.x - fraction.y );" );
				IOUtils.AddFunctionLine( ref m_functionBody, "float4 cornerDifference = float4( t, 1 - t, 1, 1 );" );
				IOUtils.AddFunctionLine( ref m_functionBody, "float2 step_1 = ( parallax1 - octaFrame.zw ) * "+ m_framesProp.PropertyName + ";" );
				IOUtils.AddFunctionLine( ref m_functionBody, "float4 step23 = ( float4( parallax2, parallax3 ) -  octaFrame.zwzw ) * "+ m_framesProp.PropertyName + " - cornerDifference;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "step_1 = step_1 * (1-step_1);" );
				IOUtils.AddFunctionLine( ref m_functionBody, "step23 = step23 * (1-step23);" );
				IOUtils.AddFunctionLine( ref m_functionBody, "float3 steps;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "steps.x = step_1.x * step_1.y;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "steps.y = step23.x * step23.y;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "steps.z = step23.z * step23.w;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "steps = step(-steps, 0);" );
				IOUtils.AddFunctionLine( ref m_functionBody, "float final = dot( steps, weights );" );
				IOUtils.AddFunctionLine( ref m_functionBody, "clip( final - 0.5 );" );
			}
			if( m_speedTreeHueSupport )
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "#ifdef EFFECT_HUE_VARIATION" );
				IOUtils.AddFunctionLine( ref m_functionBody, "half3 shiftedColor = lerp(blendedAlbedo.rgb, _HueVariation.rgb, interpViewPos.w);" );
				IOUtils.AddFunctionLine( ref m_functionBody, "half maxBase = max(blendedAlbedo.r, max(blendedAlbedo.g, blendedAlbedo.b));" );
				IOUtils.AddFunctionLine( ref m_functionBody, "half newMaxBase = max(shiftedColor.r, max(shiftedColor.g, shiftedColor.b));" );
				IOUtils.AddFunctionLine( ref m_functionBody, "maxBase /= newMaxBase;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "maxBase = maxBase * 0.5f + 0.5f;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "shiftedColor.rgb *= maxBase;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "blendedAlbedo.rgb = saturate(shiftedColor);" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
			}
			IOUtils.AddFunctionLine( ref m_functionBody, "o.Albedo = blendedAlbedo.rgb;" );
			if( withEmission )
			{
				//IOUtils.AddFunctionLine( ref m_functionBody, "float4 mask1 = tex2Dbias( _Emission, float4( parallax1, 0, textureBias) );" );
				IOUtils.AddFunctionLine( ref m_functionBody,
				"float4 mask1 = "+ GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Emission","sampler_Emission","parallax1",MipType.MipBias, "textureBias")+ ";" );

				//IOUtils.AddFunctionLine( ref m_functionBody, "float4 mask2 = tex2Dbias( _Emission, float4( parallax2, 0, textureBias) );" );
				IOUtils.AddFunctionLine( ref m_functionBody,
				"float4 mask2 = " + GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Emission","sampler_Emission","parallax2", MipType.MipBias, "textureBias") +";" );

				//IOUtils.AddFunctionLine( ref m_functionBody, "float4 mask3 = tex2Dbias( _Emission, float4( parallax3, 0, textureBias) );" );
				IOUtils.AddFunctionLine( ref m_functionBody,
				"float4 mask3 = " + GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Emission","sampler_Emission","parallax3", MipType.MipBias, "textureBias") +";" );

				IOUtils.AddFunctionLine( ref m_functionBody, "float4 blendedMask = mask1 * weights.x  + mask2 * weights.y + mask3 * weights.z;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "o.Emission = blendedMask.rgb;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "o.Occlusion = blendedMask.a;" );
			}
			if( withSpec )
			{

				//IOUtils.AddFunctionLine( ref m_functionBody, "float4 spec1 = AI_SAMPLEBIAS( _Specular, sampler_Specular, parallax1, textureBias);" );
				IOUtils.AddFunctionLine( ref m_functionBody,
				"float4 spec1 = " + GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Specular", "sampler_Specular", "parallax1",MipType.MipBias, "textureBias")+";" );

				//IOUtils.AddFunctionLine( ref m_functionBody, "float4 spec2 = AI_SAMPLEBIAS( _Specular, sampler_Specular, parallax2, textureBias);" );
				IOUtils.AddFunctionLine( ref m_functionBody, 
				"float4 spec2 = " + GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Specular", "sampler_Specular", "parallax2", MipType.MipBias, "textureBias")+";" );

				//IOUtils.AddFunctionLine( ref m_functionBody, "float4 spec3 = AI_SAMPLEBIAS( _Specular, sampler_Specular, parallax3, textureBias);" );
				IOUtils.AddFunctionLine( ref m_functionBody,
				"float4 spec3 = "+ GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Specular", "sampler_Specular", "parallax3",MipType.MipBias, "textureBias")+";" );

				IOUtils.AddFunctionLine( ref m_functionBody, "float4 blendedSpec = spec1 * weights.x  + spec2 * weights.y + spec3 * weights.z;" );
			
				if( m_workflow == ASEStandardSurfaceWorkflow.Specular )
					IOUtils.AddFunctionLine( ref m_functionBody, "o.Specular = blendedSpec.rgb;" );
				else
					IOUtils.AddFunctionLine( ref m_functionBody, "o.Metallic = saturate( ( blendedSpec.rgb - unity_ColorSpaceDielectricSpec.rgb ) / ( blendedAlbedo.rgb - unity_ColorSpaceDielectricSpec.rgb ) ); " );
				IOUtils.AddFunctionLine( ref m_functionBody, "o.Smoothness = blendedSpec.a;" );
			}
			if( isSRP )
			{
				for( int i = 0 ; i < DielecticSRPFix.Length ; i++ )
				{
					dataCollector.AddToDirectives( DielecticSRPFix[ i ] );
				}

				IOUtils.AddFunctionLine( ref m_functionBody, "#if defined(AI_HD_RENDERPIPELINE) && ( AI_HDRP_VERSION >= 50702 )" );
				IOUtils.AddFunctionLine( ref m_functionBody, "float4 feat1 = _Features.SampleLevel( SamplerState_Point_Repeat, parallax1, 0);" );
				IOUtils.AddFunctionLine( ref m_functionBody, "o.Diffusion = feat1.rgb;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "o.Features = feat1.a;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "float4 test1 = _Specular.SampleLevel( SamplerState_Point_Repeat, parallax1, 0);" );
				IOUtils.AddFunctionLine( ref m_functionBody, "o.MetalTangent = test1.b;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
			}
			//IOUtils.AddFunctionLine( ref m_functionBody, "float4 normals1 = tex2Dbias( _Normals, float4( parallax1, 0, textureBias) );" );
			IOUtils.AddFunctionLine( ref m_functionBody,
			"float4 normals1 = "+ GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Normals","sampler_Normals", "parallax1", MipType.MipBias, "textureBias") + ";" );

			//IOUtils.AddFunctionLine( ref m_functionBody, "float4 normals2 = tex2Dbias( _Normals, float4( parallax2, 0, textureBias) );" );
			IOUtils.AddFunctionLine( ref m_functionBody,
			"float4 normals2 = "+ GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Normals","sampler_Normals","parallax2", MipType.MipBias, "textureBias")+";" );

			//IOUtils.AddFunctionLine( ref m_functionBody, "float4 normals3 = tex2Dbias( _Normals, float4( parallax3, 0, textureBias) );" );
			IOUtils.AddFunctionLine( ref m_functionBody, 
			"float4 normals3 = " + GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, "_Normals","sampler_Normals", "parallax3", MipType.MipBias, "textureBias")+ ";" );

			IOUtils.AddFunctionLine( ref m_functionBody, "float4 blendedNormal = normals1 * weights.x  + normals2 * weights.y + normals3 * weights.z;" );
			string customSamplerState = m_samplerStatePort.IsConnected ? m_samplerStatePort.GeneratePortInstructions( ref dataCollector ) : string.Empty;
			for( int i = 0; i < m_extraSamplers; i++ )
			{
				if( GetInputPortByArrayId( i ).IsConnected && GetOutputPortByArrayId( i ).IsConnected )
				{
					string samplerState = string.Empty;
					if( m_samplerStatePort.IsConnected )
					{
						samplerState = customSamplerState;
					}
					else
					{
						TexturePropertyNode node = GetInputPortByArrayId( i ).GetOutputNodeWhichIsNotRelay() as TexturePropertyNode;
						if( node != null )
						{
							samplerState = node.GenerateSamplerState( ref dataCollector );
						}
					}
					//IOUtils.AddFunctionLine( ref m_functionBody, "float4 output" + i + "a = tex2Dbias( " + m_extraPropertyNames[ i ] + ", float4( parallax1, 0, textureBias) ); " );
					IOUtils.AddFunctionLine( ref m_functionBody,
					"float4 output" + i + "a = " + GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, m_extraPropertyNames[ i ], samplerState, "parallax1", MipType.MipBias, "textureBias") +";" );

					//IOUtils.AddFunctionLine( ref m_functionBody, "float4 output" + i + "b = tex2Dbias( " + m_extraPropertyNames[ i ] + ", float4( parallax2, 0, textureBias) ); " );
					IOUtils.AddFunctionLine( ref m_functionBody, 
					"float4 output" + i + "b = " + GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, m_extraPropertyNames[ i ] , samplerState, "parallax2", MipType.MipBias, "textureBias") +";" );

					//IOUtils.AddFunctionLine( ref m_functionBody, "float4 output" + i + "c = tex2Dbias( " + m_extraPropertyNames[ i ] + ", float4( parallax3, 0, textureBias) ); " );
					IOUtils.AddFunctionLine( ref m_functionBody, 
					"float4 output" + i + "c = "+ GeneratorUtils.GenerateSamplingCall( ref dataCollector, WirePortDataType.SAMPLER2D, m_extraPropertyNames[ i ], samplerState, "parallax3", MipType.MipBias, "textureBias")+ ";" );

					IOUtils.AddFunctionLine( ref m_functionBody, "output" + i + " = output" + i + "a * weights.x  + output" + i + "b * weights.y + output" + i + "c * weights.z; " );
				}
			}
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 localNormal = blendedNormal.rgb * 2.0 - 1.0;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 worldNormal = normalize( mul( (float3x3)ai_ObjectToWorld, localNormal ) );" );
			IOUtils.AddFunctionLine( ref m_functionBody, "o.Normal = worldNormal;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float3 viewPos = interpViewPos.xyz;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "float depthOffset = ( ( parallaxSample1.a * weights.x + parallaxSample2.a * weights.y + parallaxSample3.a * weights.z ) - 0.5001 /** 2.0 - 1.0*/ ) /** 0.5*/ * "+ m_depthProp.PropertyName + " * length( ai_ObjectToWorld[ 2 ].xyz );" );
			if( !isSRP )
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "#if defined(SHADOWS_DEPTH)" );
				IOUtils.AddFunctionLine( ref m_functionBody, "if( unity_LightShadowBias.y == 1.0 ) " );
				IOUtils.AddFunctionLine( ref m_functionBody, "{" );
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.z += depthOffset * _AI_ShadowView;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.z += -_AI_ShadowBias;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "}" );
				IOUtils.AddFunctionLine( ref m_functionBody, "else " );
				IOUtils.AddFunctionLine( ref m_functionBody, "{" );
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.z += depthOffset;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "}" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#else " );
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.z += depthOffset;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
			}
			else
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "#if ( defined(SHADERPASS) && (SHADERPASS == SHADERPASS_SHADOWS) ) || defined(UNITY_PASS_SHADOWCASTER)" );
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.z += depthOffset * _AI_ShadowView;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.z += -_AI_ShadowBias;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#else " );
				IOUtils.AddFunctionLine( ref m_functionBody, "viewPos.z += depthOffset;" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
			}

			if( isSRP && dataCollector.CurrentSRPType == TemplateSRPType.HD )
			{
				IOUtils.AddFunctionLine( ref m_functionBody , "worldPos = GetAbsolutePositionWS( mul( UNITY_MATRIX_I_V, float4( viewPos.xyz, 1 ) )).xyz;" );
			}
			else
			{
				IOUtils.AddFunctionLine( ref m_functionBody , "worldPos = mul( UNITY_MATRIX_I_V, float4( viewPos.xyz, 1 ) ).xyz;" );
			}

			IOUtils.AddFunctionLine( ref m_functionBody, "clipPos = mul( UNITY_MATRIX_P, float4( viewPos, 1 ) );" );
			if( !isSRP )
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "#if defined(SHADOWS_DEPTH)" );
				IOUtils.AddFunctionLine( ref m_functionBody, "clipPos = UnityApplyLinearShadowBias( clipPos );" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
			}
			else
			{
				IOUtils.AddFunctionLine( ref m_functionBody, "#if defined(UNITY_PASS_SHADOWCASTER) && !defined(SHADERPASS)" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#if UNITY_REVERSED_Z" );
				IOUtils.AddFunctionLine( ref m_functionBody, "clipPos.z = min( clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE );" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#else" );
				IOUtils.AddFunctionLine( ref m_functionBody, "clipPos.z = max( clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE );" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
				IOUtils.AddFunctionLine( ref m_functionBody, "#endif" );
			}
			IOUtils.AddFunctionLine( ref m_functionBody, "clipPos.xyz /= clipPos.w;" );
			IOUtils.AddFunctionLine( ref m_functionBody, "if( UNITY_NEAR_CLIP_VALUE < 0 )" );
			IOUtils.AddFunctionLine( ref m_functionBody, "clipPos = clipPos * 0.5 + 0.5;" );
			IOUtils.CloseFunctionBody( ref m_functionBody );
		}
	}
}
#endif
