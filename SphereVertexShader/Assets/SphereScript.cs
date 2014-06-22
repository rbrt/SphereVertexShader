using UnityEngine;
using System.Collections;
using System.Linq;

public class SphereScript : MonoBehaviour {

	void Start () {
	    var mesh = GetComponent<MeshFilter>().mesh;
        Debug.Log(mesh.vertices.Length);
	}
	
	void Update () {
        
	}
}
