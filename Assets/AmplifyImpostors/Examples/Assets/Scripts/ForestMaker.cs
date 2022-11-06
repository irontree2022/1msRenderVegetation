using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ForestMaker : MonoBehaviour
{
	public GameObject m_treePrefab;
	public int m_amount;
	public GameObject m_ground;
	public float m_radiusDistance;

	void Start()
	{
		if( m_treePrefab == null )
			return;

		m_ground.transform.localScale = new Vector3( m_amount * 10, 1, m_amount * 5 * 1.866f);

		for( int i = -m_amount / 2; i <= m_amount / 2; i++ )
		{
			for( int j = -m_amount / 2; j <= m_amount / 2; j++ )
			{
				if( Random.Range( 0f, 1.0f ) > 0.5f )
					continue;
				GameObject newGo = Instantiate<GameObject>( m_treePrefab);
				Vector3 newPos = Vector3.zero;
				newPos.x = ( i + j * 0.5f - (int)((j < 0?j-1f:j) / 2.0f) ) * 2 * m_radiusDistance;
				newPos.z = ( j ) * 1.866f * m_radiusDistance;
				newGo.transform.position = newPos;
				float size = Random.Range( 1f, 1.5f );
				newGo.transform.localScale = Vector3.one * size;
				newGo.transform.Rotate( Random.Range( -10f, 10f ), Random.Range( -180f, 180f ), Random.Range( -10f, 10f ) );
			}
		}
	}
}
