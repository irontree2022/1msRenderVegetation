// Modified code from: http://wiki.unity3d.com/index.php?title=Triangulator

using UnityEngine;
using System.Collections.Generic;

namespace AmplifyImpostors
{
	public class Triangulator
	{
		private List<Vector2> m_points = new List<Vector2>();
		public List<Vector2> Points { get { return m_points; } }
		public Triangulator( Vector2[] points )
		{
			m_points = new List<Vector2>( points );
		}

		public Triangulator( Vector2[] points, bool invertY = true )
		{
			if( invertY )
			{
				m_points = new List<Vector2>();
				for( int i = 0; i < points.Length; i++ )
				{
					m_points.Add( new Vector2( points[ i ].x, 1 - points[ i ].y ) );
				}
			}
			else
			{
				m_points = new List<Vector2>( points );
			}
		}

		public int[] Triangulate()
		{
			List<int> indices = new List<int>();

			int n = m_points.Count;
			if( n < 3 )
				return indices.ToArray();

			int[] V = new int[ n ];
			if( Area() > 0 )
			{
				for( int v = 0; v < n; v++ )
					V[ v ] = v;
			}
			else
			{
				for( int v = 0; v < n; v++ )
					V[ v ] = ( n - 1 ) - v;
			}

			int nv = n;
			int count = 2 * nv;
			for( int m = 0, v = nv - 1; nv > 2; )
			{
				if( ( count-- ) <= 0 )
					return indices.ToArray();

				int u = v;
				if( nv <= u )
					u = 0;
				v = u + 1;
				if( nv <= v )
					v = 0;
				int w = v + 1;
				if( nv <= w )
					w = 0;

				if( Snip( u, v, w, nv, V ) )
				{
					int a, b, c, s, t;
					a = V[ u ];
					b = V[ v ];
					c = V[ w ];
					indices.Add( a );
					indices.Add( b );
					indices.Add( c );
					m++;
					for( s = v, t = v + 1; t < nv; s++, t++ )
						V[ s ] = V[ t ];
					nv--;
					count = 2 * nv;
				}
			}

			indices.Reverse();
			return indices.ToArray();
		}

		private float Area()
		{
			int n = m_points.Count;
			float A = 0.0f;
			for( int p = n - 1, q = 0; q < n; p = q++ )
			{
				Vector2 pval = m_points[ p ];
				Vector2 qval = m_points[ q ];
				A += pval.x * qval.y - qval.x * pval.y;
			}
			return ( A * 0.5f );
		}

		private bool Snip( int u, int v, int w, int n, int[] V )
		{
			int p;
			Vector2 A = m_points[ V[ u ] ];
			Vector2 B = m_points[ V[ v ] ];
			Vector2 C = m_points[ V[ w ] ];
			if( Mathf.Epsilon > ( ( ( B.x - A.x ) * ( C.y - A.y ) ) - ( ( B.y - A.y ) * ( C.x - A.x ) ) ) )
				return false;
			for( p = 0; p < n; p++ )
			{
				if( ( p == u ) || ( p == v ) || ( p == w ) )
					continue;
				Vector2 P = m_points[ V[ p ] ];
				if( InsideTriangle( P, A, B, C ) )
					return false;
			}
			return true;
		}

		private bool InsideTriangle( Vector2 pt, Vector2 v1, Vector2 v2, Vector2 v3 )
		{
			bool b1, b2, b3;

			b1 = pt.Cross( v1, v2 ) < 0.0f;
			b2 = pt.Cross( v2, v3 ) < 0.0f;
			b3 = pt.Cross( v3, v1 ) < 0.0f;

			return ( ( b1 == b2 ) && ( b2 == b3 ) );
		}
	}
}
