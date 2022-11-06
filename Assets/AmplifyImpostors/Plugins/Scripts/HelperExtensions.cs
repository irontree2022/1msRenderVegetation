// Amplify Impostors
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif
using System.Reflection;
using System;
using System.IO;

namespace AmplifyImpostors
{
	public static class BoundsEx
	{
		public static Bounds Transform( this Bounds bounds, Matrix4x4 matrix )
		{
			var center = matrix.MultiplyPoint3x4( bounds.center );
			var extents = bounds.extents;

			var axisX = matrix.MultiplyVector( new Vector3( extents.x, 0, 0 ) );
			var axisY = matrix.MultiplyVector( new Vector3( 0, extents.y, 0 ) );
			var axisZ = matrix.MultiplyVector( new Vector3( 0, 0, extents.z ) );

			extents.x = Mathf.Abs( axisX.x ) + Mathf.Abs( axisY.x ) + Mathf.Abs( axisZ.x );
			extents.y = Mathf.Abs( axisX.y ) + Mathf.Abs( axisY.y ) + Mathf.Abs( axisZ.y );
			extents.z = Mathf.Abs( axisX.z ) + Mathf.Abs( axisY.z ) + Mathf.Abs( axisZ.z );

			return new Bounds { center = center, extents = extents };
		}
	}
#if UNITY_EDITOR
	public static class MaterialEx
	{
		public static void CopyPropertiesFrom( this Material to, Material from )
		{
			int count = ShaderUtil.GetPropertyCount( from.shader );
			for( int i = 0; i < count; i++ )
			{
				var ty = ShaderUtil.GetPropertyType( from.shader, i );
				var name = ShaderUtil.GetPropertyName( from.shader, i );
				switch( ty )
				{
					case ShaderUtil.ShaderPropertyType.Color:
					to.SetColor( name, from.GetColor( name ) );
					break;
					case ShaderUtil.ShaderPropertyType.Vector:
					to.SetVector( name, from.GetVector( name ) );
					break;
					case ShaderUtil.ShaderPropertyType.Float:
					to.SetFloat( name, from.GetFloat( name ) );
					break;
					case ShaderUtil.ShaderPropertyType.Range:
					to.SetFloat( name, from.GetFloat( name ) );
					break;
					case ShaderUtil.ShaderPropertyType.TexEnv:
					to.SetTexture( name, from.GetTexture( name ) );
					to.SetTextureOffset( name, from.GetTextureOffset( name ) );
					to.SetTextureScale( name, from.GetTextureScale( name ) );
					break;
					default:
					break;
				}
			}
			to.renderQueue = from.renderQueue;
			to.globalIlluminationFlags = from.globalIlluminationFlags;
			to.shaderKeywords = from.shaderKeywords;
			foreach( var keyword in to.shaderKeywords )
			{
				to.EnableKeyword( keyword );
			}
			to.enableInstancing = from.enableInstancing;
			EditorUtility.SetDirty( to );
		}
	}
#endif

	public static class Texture2DEx
	{
		static readonly byte[] Footer = { 0x54, 0x52, 0x55, 0x45, 0x56, 0x49, 0x53, 0x49, 0x4F, 0x4E, 0x2D, 0x58, 0x46, 0x49, 0x4C, 0x45, 0x2E, 0x00 }; // TRUEVISION-XFILE.\0 signature (new TGA format)

		public enum Compression
		{
			None,
			RLE
		}

		public static byte[] EncodeToTGA( this Texture2D tex, Compression compression = Compression.RLE )
		{
			const int headerSize = 18;
			const int bytesRGB24 = 3;
			const int bytesRGBA32 = 4;

			int bytesPerPixel = tex.format == TextureFormat.ARGB32 || tex.format == TextureFormat.RGBA32 ? bytesRGBA32 : bytesRGB24;

			using( MemoryStream stream = new MemoryStream( headerSize + tex.width * tex.height * bytesPerPixel ) )
			{
				using( BinaryWriter writer = new BinaryWriter( stream ) )
				{
					writer.Write( (byte)0 );                      // IDLength (not in use)
					writer.Write( (byte)0 );                      // ColorMapType (not in use)
					writer.Write( (byte)( compression == Compression.None ? 2 : 10 ) ); // DataTypeCode (10 == Runlength encoded RGB images)
					writer.Write( (short)0 );                     // ColorMapOrigin (not in use)
					writer.Write( (short)0 );                     // ColorMapLength (not in use)
					writer.Write( (byte)0 );                      // ColorMapDepth (not in use)
					writer.Write( (short)0 );                     // Origin X
					writer.Write( (short)0 );                     // Origin Y
					writer.Write( (short)tex.width );             // Width
					writer.Write( (short)tex.height );            // Height
					writer.Write( (byte)( bytesPerPixel * 8 ) );  // Bits Per Pixel
					writer.Write( (byte)8 );                      // ImageDescriptor (photoshop uses 8?)

					Color32[] pixels = tex.GetPixels32();

					if( compression == Compression.None )
					{
						for( int i = 0; i < pixels.Length; i++ )
						{
							Color32 pixel = pixels[ i ];
							writer.Write( pixel.r );
							writer.Write( pixel.g );
							writer.Write( pixel.b );

							if( bytesPerPixel == bytesRGBA32 )
								writer.Write( pixel.a );
						}
					}
					else
					{
						const int maxPacket = 128;
						int packetStart = 0;
						int packetEnd = 0;

						while( packetStart < pixels.Length )
						{
							Color32 currentPixel = pixels[ packetStart ];

							bool isRLE = ( packetStart != pixels.Length - 1 ) && Equals( pixels[ packetStart ], pixels[ packetStart + 1 ] );
							int endOfWidth = ( ( packetStart / tex.width ) + 1 ) * tex.width;
							int readEnd = Mathf.Min( packetStart + maxPacket, pixels.Length, endOfWidth );

							for( packetEnd = packetStart + 1; packetEnd < readEnd; ++packetEnd )
							{
								bool bPreviousEqualsCurrent = Equals( pixels[ packetEnd - 1 ], pixels[ packetEnd ] );

								if( !isRLE && bPreviousEqualsCurrent || isRLE && !bPreviousEqualsCurrent )
									break;
							}

							int packetLength = packetEnd - packetStart;

							if( isRLE )
							{
								writer.Write( (byte)( ( packetLength - 1 ) | ( 1 << 7 ) ) );
								writer.Write( currentPixel.r );
								writer.Write( currentPixel.g );
								writer.Write( currentPixel.b );

								if( bytesPerPixel == bytesRGBA32 )
									writer.Write( currentPixel.a );
							}
							else
							{
								writer.Write( (byte)( packetLength - 1 ) );
								for( int i = packetStart; i < packetEnd; ++i )
								{
									Color32 pixel = pixels[ i ];
									writer.Write( pixel.r );
									writer.Write( pixel.g );
									writer.Write( pixel.b );

									if( bytesPerPixel == bytesRGBA32 )
										writer.Write( pixel.a );
								}
							}
							packetStart = packetEnd;
						}
					}

					writer.Write( 0 );        // Offset of meta-information (not in use)
					writer.Write( 0 );        // Offset of Developer-Area (not in use)
					writer.Write( Footer );   // Signature
				}
				return stream.ToArray();
			}
		}

		private static bool Equals( Color32 first, Color32 second )
		{
			return first.r == second.r && first.g == second.g && first.b == second.b && first.a == second.a;
		}
	}

	public static class SpriteUtilityEx
	{
		private static System.Type type = null;
		public static System.Type Type { get { return ( type == null ) ? type = System.Type.GetType( "UnityEditor.Sprites.SpriteUtility, UnityEditor" ) : type; } }

		public static void GenerateOutline( Texture2D texture, Rect rect, float detail, byte alphaTolerance, bool holeDetection, out Vector2[][] paths )
		{
			Vector2[][] opaths = new Vector2[ 0 ][];
			object[] parameters = new object[] { texture, rect, detail, alphaTolerance, holeDetection, opaths };
			MethodInfo method = Type.GetMethod( "GenerateOutline", BindingFlags.Static | BindingFlags.NonPublic );
			method.Invoke( null, parameters );
			paths = (Vector2[][])parameters[ 5 ];
		}
	}

	public static class RenderTextureEx
	{
		public static RenderTexture GetTemporary( RenderTexture renderTexture )
		{
			return RenderTexture.GetTemporary( renderTexture.width, renderTexture.height, renderTexture.depth, renderTexture.format );
		}
	}

	public static class Vector2Ex
	{
		public static float Cross( this Vector2 O, Vector2 A, Vector2 B )
		{
			return ( A.x - O.x ) * ( B.y - O.y ) - ( A.y - O.y ) * ( B.x - O.x );
		}

		public static float TriangleArea( this Vector2 O, Vector2 A, Vector2 B )
		{
			return Mathf.Abs( ( A.x - B.x ) * ( O.y - A.y ) - ( A.x - O.x ) * ( B.y - A.y ) ) * 0.5f;
		}

		public static float TriangleArea( this Vector3 O, Vector3 A, Vector3 B )
		{
			return Mathf.Abs( ( A.x - B.x ) * ( O.y - A.y ) - ( A.x - O.x ) * ( B.y - A.y ) ) * 0.5f;
		}

		public static Vector2[] ConvexHull( Vector2[] P )
		{
			if( P.Length > 1 )
			{
				int n = P.Length, k = 0;
				Vector2[] H = new Vector2[ 2 * n ];

				Comparison<Vector2> comparison = new Comparison<Vector2>( ( a, b ) =>
				{
					if( a.x == b.x )
						return a.y.CompareTo( b.y );
					else
						return a.x.CompareTo( b.x );
				} );
				Array.Sort<Vector2>( P, comparison );

				// Build lower hull
				for( int i = 0; i < n; ++i )
				{
					while( k >= 2 && P[ i ].Cross( H[ k - 2 ], H[ k - 1 ] ) <= 0 )
						k--;
					H[ k++ ] = P[ i ];
				}

				// Build upper hull
				for( int i = n - 2, t = k + 1; i >= 0; i-- )
				{
					while( k >= t && P[ i ].Cross( H[ k - 2 ], H[ k - 1 ] ) <= 0 )
						k--;
					H[ k++ ] = P[ i ];
				}
				if( k > 1 )
					Array.Resize<Vector2>( ref H, k - 1 );

				return H;
			}
			else if( P.Length <= 1 )
			{
				return P;
			}
			else
			{
				return null;
			}
		}

		public static Vector2[] ScaleAlongNormals( Vector2[] P, float scaleAmount )
		{
			Vector2[] normals = new Vector2[ P.Length ];
			for( int i = 0; i < normals.Length; i++ )
			{
				int prev = i - 1;
				int next = i + 1;
				if( i == 0 )
					prev = P.Length - 1;
				if( i == P.Length - 1 )
					next = 0;

				Vector2 ba = P[ i ] - P[ prev ];
				Vector2 bc = P[ i ] - P[ next ];
				Vector2 normal = ( ba.normalized + bc.normalized ).normalized;
				normals[ i ] = normal;
			}

			for( int i = 0; i < normals.Length; i++ )
			{
				P[ i ] = P[ i ] + normals[ i ] * scaleAmount;
			}

			return P;
		}

		static Vector2[] ReduceLeastSignificantVertice( Vector2[] P )
		{
			float currentArea = 0;
			int smallestIndex = 0;
			int replacementIndex = 0;
			Vector2 newPos = Vector2.zero;
			for( int i = 0; i < P.Length; i++ )
			{
				int next = i + 1;
				int upNext = i + 2;
				int finalNext = i + 3;
				if( next >= P.Length )
					next -= P.Length;
				if( upNext >= P.Length )
					upNext -= P.Length;
				if( finalNext >= P.Length )
					finalNext -= P.Length;

				Vector2 intersect = GetIntersectionPointCoordinates( P[ i ], P[ next ], P[ upNext ], P[ finalNext ] );
				if( i == 0 )
				{
					currentArea = intersect.TriangleArea( P[ next ], P[ upNext ] );

					if( OutsideBounds( intersect ) > 0 )
						currentArea = currentArea + OutsideBounds( intersect ) * 1;

					smallestIndex = next;
					replacementIndex = upNext;
					newPos = intersect;
				}
				else
				{
					float newArea = intersect.TriangleArea( P[ next ], P[ upNext ] );

					if( OutsideBounds( intersect ) > 0 )
						newArea = newArea + OutsideBounds( intersect ) * 1;

					if( newArea < currentArea && OutsideBounds( intersect ) <= 0 )
					{
						currentArea = newArea;
						smallestIndex = next;
						replacementIndex = upNext;
						newPos = intersect;
					}
				}
			}

			P[ replacementIndex ] = newPos;
			return Array.FindAll<Vector2>( P, x => Array.IndexOf( P, x ) != smallestIndex );
		}


		public static Vector2[] ReduceVertices( Vector2[] P, int maxVertices )
		{
			if( maxVertices == 4 )
			{
				// turn into a box
				Rect newBox = new Rect( P[ 0 ].x, P[ 0 ].y, 0f, 0f );
				for( int i = 0; i < P.Length; i++ )
				{
					newBox.xMin = Mathf.Min( newBox.xMin, P[ i ].x );
					newBox.xMax = Mathf.Max( newBox.xMax, P[ i ].x );
					newBox.yMin = Mathf.Min( newBox.yMin, P[ i ].y );
					newBox.yMax = Mathf.Max( newBox.yMax, P[ i ].y );
				}

				P = new Vector2[]
				{
					new Vector2(newBox.xMin, newBox.yMin),
					new Vector2(newBox.xMax, newBox.yMin),
					new Vector2(newBox.xMax, newBox.yMax),
					new Vector2(newBox.xMin, newBox.yMax),
				};
			}
			else
			{
				// remove vertices to target count (naive implementation)
				int reduction = Math.Max( 0, P.Length - maxVertices );
				for( int k = 0; k < reduction; k++ )
				{
					P = ReduceLeastSignificantVertice( P );
					// OLD METHOD
					//float prevArea = 0;
					//int indexForRemoval = 0;
					//for( int i = 0; i < P.Length; i++ )
					//{
					//	int prev = i - 1;
					//	int next = i + 1;
					//	if( i == 0 )
					//		prev = P.Length - 1;
					//	if( i == P.Length - 1 )
					//		next = 0;

					//	float area = P[ i ].TriangleArea( P[ prev ], P[ next ] );
					//	if( i == 0 )
					//		prevArea = area;

					//	if( area < prevArea )
					//	{
					//		indexForRemoval = i;
					//		prevArea = area;
					//	}
					//}
					//ArrayUtility.RemoveAt<Vector2>( ref P, indexForRemoval );
				}
			}

			return P;
		}

		static Vector2 GetIntersectionPointCoordinates( Vector2 A1, Vector2 A2, Vector2 B1, Vector2 B2 )
		{
			float tmp = ( B2.x - B1.x ) * ( A2.y - A1.y ) - ( B2.y - B1.y ) * ( A2.x - A1.x );

			if( tmp == 0 )
			{
				return ( ( Vector2.Lerp( A2, B1, 0.5f ) - ( Vector2.one * 0.5f ) ) * 1000 ) + ( Vector2.one * 500f );//Vector2.positiveInfinity;// Vector2.zero;
			}

			float mu = ( ( A1.x - B1.x ) * ( A2.y - A1.y ) - ( A1.y - B1.y ) * ( A2.x - A1.x ) ) / tmp;

			return new Vector2(
				B1.x + ( B2.x - B1.x ) * mu,
				B1.y + ( B2.y - B1.y ) * mu
			);
		}

		static float OutsideBounds( Vector2 P )
		{
			P = P - ( Vector2.one * 0.5f );
			float vert = Mathf.Clamp01( Mathf.Abs( P.y ) - 0.5f );
			float hori = Mathf.Clamp01( Mathf.Abs( P.x ) - 0.5f );
			return hori + vert;
		}

	}
}
