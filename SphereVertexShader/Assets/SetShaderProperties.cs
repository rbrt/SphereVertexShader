using UnityEngine;
using System.Collections;

public class SetShaderProperties : MonoBehaviour {

    void Start () {
        renderer.material.SetFloat("_TexWidth", renderer.material.GetTexture("_MainTex").width);
        renderer.material.SetFloat("_TexHeight", renderer.material.GetTexture("_MainTex").height);
    }

    void Update () {

    }

}
