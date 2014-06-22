using UnityEngine;
using System.Collections;

public class Rotate : MonoBehaviour {

	public float rotationSpeed;
    
	// Update is called once per frame
	void Update () {
	    transform.Rotate(new Vector3(0,0,1), rotationSpeed);
	}
}
