// Amplify Impostors
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using System.Collections.Generic;
using UnityEngine;

namespace AmplifyImpostors
{
	public enum ImageFormat
	{
		PNG = 0,
		TGA = 1,
		EXR = 2
	}

	public enum TextureChannels
	{
		RGBA = 0,
		RGB = 1
	}

	public enum TextureCompression
	{
		None = 0,
		Normal = 1,
		High = 2,
		Low = 3,
	}

	public enum TextureScale
	{
		Full = 1,
		Half = 2,
		Quarter = 4,
		Eighth = 8,
	}

	[System.Flags]
	public enum OverrideMask
	{
		OutputToggle = 1 << 0,
		NameSuffix = 1 << 1,
		RelativeScale = 1 << 2,
		ColorSpace = 1 << 3,
		QualityCompression = 1 << 4,
		FileFormat = 1 << 5,
	}

	public enum PresetPipeline
	{
		Legacy = 0,
		Lightweight = 1,
		HighDefinition = 2
	}

	[System.Serializable]
	public class TextureOutput
	{
		[SerializeField]
		public int Index = -1;

		[SerializeField]
		public OverrideMask OverrideMask = 0;

		public bool Active = true;
		public string Name = string.Empty;
		public TextureScale Scale = TextureScale.Full;
		public bool SRGB = false;
		public TextureChannels Channels = TextureChannels.RGBA;
		public TextureCompression Compression = TextureCompression.Normal;
		public ImageFormat ImageFormat = ImageFormat.TGA;

		public TextureOutput() { }

		public TextureOutput( bool a, string n, TextureScale s, bool sr, TextureChannels c, TextureCompression nc, ImageFormat i )
		{
			Active = a;
			Name = n;
			Scale = s;
			SRGB = sr;
			Channels = c;
			Compression = nc;
			ImageFormat = i;
		}

		public TextureOutput Clone()
		{
			return (TextureOutput)this.MemberwiseClone();
		}
	}

	[CreateAssetMenu( fileName = "New Bake Preset", order = 86 )]
	public class AmplifyImpostorBakePreset : ScriptableObject
	{
		[SerializeField]
		public Shader BakeShader = null;

		[SerializeField]
		public Shader RuntimeShader = null;

		[SerializeField]
		public PresetPipeline Pipeline = PresetPipeline.Legacy;

		[SerializeField]
		public int AlphaIndex = 0;

		[SerializeField]
		public List<TextureOutput> Output = new List<TextureOutput>();
	}
}
