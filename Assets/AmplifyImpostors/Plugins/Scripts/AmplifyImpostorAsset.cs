// Amplify Impostors
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using System.Collections.Generic;
using UnityEngine;

namespace AmplifyImpostors
{
	public enum ImpostorType
	{
		Spherical = 0,
		Octahedron = 1,
		HemiOctahedron = 2
	}

	[System.Flags]
	public enum DeferredBuffers
	{
		AlbedoAlpha = 0x1,
		SpecularSmoothness = 0x2,
		NormalDepth = 0x4,
		EmissionOcclusion = 0x8,
	}

	public enum RenderingMaps
	{
		Standard = 0,
		Custom = 1,
	}

	[CreateAssetMenu( fileName = "New Impostor", order = 85 )]
	public class AmplifyImpostorAsset : ScriptableObject
	{
		[SerializeField]
		public Material Material;

		[SerializeField]
		public Mesh Mesh;

		[HideInInspector]
		[SerializeField]
		public int Version = 0;

		[SerializeField]
		public ImpostorType ImpostorType = ImpostorType.Octahedron;

		[HideInInspector]
		[SerializeField]
		public bool LockedSizes = true;

		[HideInInspector]
		[SerializeField]
		public int SelectedSize = 2048;

		[SerializeField]
		public Vector2 TexSize = new Vector2( 2048, 2048 );

		[HideInInspector]
		[SerializeField]
		public bool DecoupleAxisFrames = false;

		[SerializeField]
		[Range( 1, 32 )]
		public int HorizontalFrames = 16;

		[SerializeField]
		[Range( 1, 33 )] //check if 33 is needed later
		public int VerticalFrames = 16;

		[SerializeField]
		[Range( 0, 64 )]
		public int PixelPadding = 32;

		[SerializeField]
		[Range( 4, 16 )]
		public int MaxVertices = 8;

		[SerializeField]
		[Range( 0f, 0.2f )]
		public float Tolerance = 0.15f;

		[SerializeField]
		[Range( 0f, 1f )]
		public float NormalScale = 0.01f;

		[SerializeField]
		public Vector2[] ShapePoints = new Vector2[] {
			new Vector2(0.15f, 0f),
			new Vector2(0.85f, 0f),
			new Vector2(1f, 0.15f),
			new Vector2(1f, 0.85f),
			new Vector2(0.85f, 1f),
			new Vector2(0.15f, 1f),
			new Vector2(0f, 0.85f),
			new Vector2(0f, 0.15f),
		};

		[SerializeField]
		public AmplifyImpostorBakePreset Preset;

		[SerializeField]
		public List<TextureOutput> OverrideOutput = new List<TextureOutput>();
	}
}
